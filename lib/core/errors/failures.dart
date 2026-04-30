import 'package:equatable/equatable.dart';

/// Base Failure class used across all layers
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// خطأ من الخادم (4xx, 5xx)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// خطأ في الشبكة (لا اتصال)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// خطأ في التخزين المحلي
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// خطأ غير مصرح (401)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired. Please log in again.']);
}

/// خطأ في التحقق من صحة البيانات (422)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
