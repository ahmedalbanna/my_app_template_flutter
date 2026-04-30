import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

// ═══════════════════════════════════════════════════════════════
// Events
// ═══════════════════════════════════════════════════════════════

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// فحص حالة المصادقة عند بدء التطبيق
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// طلب تسجيل الدخول
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

/// طلب إنشاء حساب جديد
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

/// طلب نسيت كلمة المرور
class AuthForgotPasswordRequested extends AuthEvent {
  final String email;
  const AuthForgotPasswordRequested(this.email);
  @override
  List<Object?> get props => [email];
}

/// طلب إعادة تعيين كلمة المرور
class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  final String code;
  final String newPassword;
  const AuthResetPasswordRequested({
    required this.email,
    required this.code,
    required this.newPassword,
  });
  @override
  List<Object?> get props => [email, code, newPassword];
}

/// تسجيل الخروج
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

// ═══════════════════════════════════════════════════════════════
// States
// ═══════════════════════════════════════════════════════════════

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// الحالة الابتدائية قبل أي فحص
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// جارٍ التحميل
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// مستخدم مُسجَّل الدخول
class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

/// غير مُسجَّل (ضيف)
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// عملية ناجحة (مثل: إرسال رمز OTP، إعادة تعيين كلمة المرور)
class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

/// حدث خطأ
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// ═══════════════════════════════════════════════════════════════
// Bloc
// ═══════════════════════════════════════════════════════════════

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const AuthInitial()) {

    // ─── Check Auth ────────────────────────────────────────────
    on<AuthCheckRequested>((event, emit) async {
      emit(const AuthLoading());
      final isAuthenticated = await authRepository.checkAuthStatus();
      if (isAuthenticated) {
        // جلب بيانات المستخدم المخزَّنة محلياً
        final user = await authRepository.getCurrentUser();
        if (user != null) {
          emit(Authenticated(user));
        } else {
          // token موجود لكن user data تالفة → إخراج المستخدم
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    });

    // ─── Login ─────────────────────────────────────────────────
    on<AuthLoginRequested>((event, emit) async {
      emit(const AuthLoading());
      final result = await authRepository.login(event.email, event.password);
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    // ─── Register ──────────────────────────────────────────────
    on<AuthRegisterRequested>((event, emit) async {
      emit(const AuthLoading());
      final result = await authRepository.register(
        event.email,
        event.password,
        event.firstName,
        event.lastName,
      );
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    // ─── Forgot Password ───────────────────────────────────────
    on<AuthForgotPasswordRequested>((event, emit) async {
      emit(const AuthLoading());
      final result = await authRepository.forgotPassword(event.email);
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (successMsg) => emit(AuthSuccess(successMsg)),
      );
    });

    // ─── Reset Password ────────────────────────────────────────
    on<AuthResetPasswordRequested>((event, emit) async {
      emit(const AuthLoading());
      final result = await authRepository.resetPassword(
        event.email,
        event.code,
        event.newPassword,
      );
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (successMsg) => emit(AuthSuccess(successMsg)),
      );
    });

    // ─── Logout ────────────────────────────────────────────────
    on<AuthLogoutRequested>((event, emit) async {
      emit(const AuthLoading());
      await authRepository.logout();
      emit(const Unauthenticated());
    });
  }
}
