import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/local_data_source.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final LocalDataSource localDataSource;

  AuthRepositoryImpl({required this.dio, required this.localDataSource});

  // ─── Helper ──────────────────────────────────────────────────
  String _extractMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?['message']?.toString() ??
          fallback;
    }
    return fallback;
  }

  Future<void> _persistUser(UserModel user) async {
    await localDataSource.saveAccessToken(user.token);
    if (user.refreshToken != null) {
      await localDataSource.saveRefreshToken(user.refreshToken!);
    }
    await localDataSource.saveUserData(user.toJson());
  }

  // ─── Login ───────────────────────────────────────────────────
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data['data'] ?? response.data;
      final user = UserModel.fromJson(
        data['user'] ?? data,
        token: data['access_token'] ?? data['accessToken'] ?? '',
        refreshToken: data['refresh_token'] ?? data['refreshToken'],
      );

      await _persistUser(user);
      return Right(user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure(_extractMessage(e, 'Invalid credentials')));
      }
      return Left(ServerFailure(_extractMessage(e, 'Login failed')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ─── Register ────────────────────────────────────────────────
  @override
  Future<Either<Failure, User>> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final response = await dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      });

      final data = response.data['data'] ?? response.data;
      final user = UserModel.fromJson(
        data['user'] ?? data,
        token: data['access_token'] ?? data['accessToken'] ?? '',
        refreshToken: data['refresh_token'] ?? data['refreshToken'],
      );

      await _persistUser(user);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(_extractMessage(e, 'Registration failed')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ─── Logout ──────────────────────────────────────────────────
  @override
  Future<void> logout() async {
    try {
      // إبلاغ الخادم بتسجيل الخروج (اختياري)
      await dio.post('/auth/logout');
    } catch (_) {}
    await localDataSource.clearAll();
  }

  // ─── Check Auth ──────────────────────────────────────────────
  @override
  Future<bool> checkAuthStatus() async {
    final token = await localDataSource.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ─── Get Current User ────────────────────────────────────────
  @override
  Future<User?> getCurrentUser() async {
    final userData = await localDataSource.getUserData();
    if (userData == null) return null;
    try {
      return UserModel.fromJson(
        userData,
        token: userData['token'] ?? '',
        refreshToken: userData['refreshToken'],
      );
    } catch (_) {
      return null;
    }
  }

  // ─── Forgot Password ─────────────────────────────────────────
  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      await dio.post('/auth/forgot-password', data: {'email': email});
      return const Right('Verification code sent to your email');
    } on DioException catch (e) {
      return Left(ServerFailure(_extractMessage(e, 'Action failed')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ─── Reset Password ──────────────────────────────────────────
  @override
  Future<Either<Failure, String>> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      await dio.post('/auth/reset-password', data: {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      });
      return const Right('Password reset successfully');
    } on DioException catch (e) {
      return Left(ServerFailure(_extractMessage(e, 'Action failed')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
