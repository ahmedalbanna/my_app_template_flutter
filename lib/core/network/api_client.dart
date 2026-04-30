import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../storage/local_data_source.dart';
import 'auth_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(LocalDataSource localDataSource) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // إضافة JWT + Refresh Token interceptor
    dio.interceptors.add(AuthInterceptor(localDataSource: localDataSource));

    // تسجيل الطلبات في وضع التطوير
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => Logger().d(obj),
      ),
    );

    return dio;
  }
}
