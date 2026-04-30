import 'package:equatable/equatable.dart';

/// كيان المستخدم – يمثل البيانات الأساسية في طبقة Domain
class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String token;
  final String? refreshToken;
  final String? role;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.token,
    this.refreshToken,
    this.role,
    this.avatarUrl,
  });

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [id, email, firstName, lastName, token, refreshToken, role, avatarUrl];
}
