import '../../domain/entities/user.dart';

/// UserModel – يمتد من User ويضيف fromJson/toJson لطبقة Data
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.token,
    super.refreshToken,
    super.role,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String token = '', String? refreshToken}) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? json['first_name'] ?? '',
      lastName: json['lastName'] ?? json['last_name'] ?? '',
      token: token,
      refreshToken: refreshToken,
      role: json['role']?.toString(),
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'token': token,
      'refreshToken': refreshToken,
      'role': role,
      'avatarUrl': avatarUrl,
    };
  }

  /// تحويل كيان User العادي إلى UserModel
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      token: user.token,
      refreshToken: user.refreshToken,
      role: user.role,
      avatarUrl: user.avatarUrl,
    );
  }
}
