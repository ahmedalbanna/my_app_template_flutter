import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../storage/local_data_source.dart';
import '../constants/app_constants.dart';

/// Interceptor يضيف JWT تلقائياً ويُجدِّد التوكن عند انتهاء صلاحيته (401)
class AuthInterceptor extends Interceptor {
  final LocalDataSource localDataSource;
  final Logger _logger = Logger();

  // Dio مستقل للـ refresh (لا يمر عبر هذا الـ Interceptor مرة أخرى)
  late final Dio _refreshDio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  AuthInterceptor({required this.localDataSource});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await localDataSource.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      _logger.w('Token expired, attempting refresh...');
      final refreshed = await _tryRefreshToken(err, handler);
      if (refreshed) return;
    }
    handler.next(err);
  }

  /// محاولة تجديد التوكن وإعادة الطلب الأصلي
  Future<bool> _tryRefreshToken(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _logger.e('No refresh token found');
        return false;
      }

      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final data = response.data['data'] ?? response.data;
      final newAccessToken = data['access_token'] ?? data['accessToken'];
      final newRefreshToken = data['refresh_token'] ?? data['refreshToken'];

      if (newAccessToken == null) return false;

      // حفظ التوكنات الجديدة
      await localDataSource.saveAccessToken(newAccessToken);
      if (newRefreshToken != null) {
        await localDataSource.saveRefreshToken(newRefreshToken);
      }

      _logger.i('Token refreshed successfully');

      // إعادة الطلب الأصلي بالتوكن الجديد
      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryDio = Dio();
      final retryResponse = await retryDio.fetch(retryOptions);
      handler.resolve(retryResponse);
      return true;
    } catch (e) {
      _logger.e('Token refresh failed: $e');
      // مسح البيانات لإجبار المستخدم على تسجيل الدخول من جديد
      await localDataSource.clearAll();
      return false;
    }
  }
}
