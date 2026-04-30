import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String password, String firstName, String lastName);
  Future<void> logout();
  Future<bool> checkAuthStatus();
  Future<Either<Failure, String>> forgotPassword(String email);
  Future<Either<Failure, String>> resetPassword(String email, String code, String newPassword);
  /// جلب المستخدم المخزَّن محلياً
  Future<User?> getCurrentUser();
}
