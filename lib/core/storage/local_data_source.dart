import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';

/// واجهة التخزين المحلي – تغطي: Token، Refresh Token، User، Theme، Onboarding
abstract class LocalDataSource {
  // ─── Tokens ─────────────────────────────────────────────────
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> clearAccessToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearRefreshToken();

  // ─── User ───────────────────────────────────────────────────
  Future<void> saveUserData(Map<String, dynamic> userData);
  Future<Map<String, dynamic>?> getUserData();
  Future<void> clearUserData();

  // ─── Theme ──────────────────────────────────────────────────
  Future<void> saveTheme(bool isDarkMode);
  bool getTheme();

  // ─── Onboarding ─────────────────────────────────────────────
  Future<void> setOnboardingSeen();
  bool isOnboardingSeen();

  // ─── Language ───────────────────────────────────────────────
  Future<void> saveLanguage(String languageCode);
  String? getLanguage();

  // ─── Clear All ──────────────────────────────────────────────
  Future<void> clearAll();

  // ─── Legacy compatibility ────────────────────────────────────
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  LocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  // ─── Access Token ────────────────────────────────────────────
  @override
  Future<void> saveAccessToken(String token) async {
    await secureStorage.write(key: AppConstants.accessTokenKey, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: AppConstants.accessTokenKey);
  }

  @override
  Future<void> clearAccessToken() async {
    await secureStorage.delete(key: AppConstants.accessTokenKey);
  }

  // ─── Refresh Token ───────────────────────────────────────────
  @override
  Future<void> saveRefreshToken(String token) async {
    await secureStorage.write(key: AppConstants.refreshTokenKey, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  @override
  Future<void> clearRefreshToken() async {
    await secureStorage.delete(key: AppConstants.refreshTokenKey);
  }

  // ─── User Data ───────────────────────────────────────────────
  @override
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await secureStorage.write(
      key: AppConstants.userDataKey,
      value: jsonEncode(userData),
    );
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    final jsonString = await secureStorage.read(key: AppConstants.userDataKey);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearUserData() async {
    await secureStorage.delete(key: AppConstants.userDataKey);
  }

  // ─── Theme ───────────────────────────────────────────────────
  @override
  Future<void> saveTheme(bool isDarkMode) async {
    await sharedPreferences.setBool(AppConstants.themeKey, isDarkMode);
  }

  @override
  bool getTheme() {
    return sharedPreferences.getBool(AppConstants.themeKey) ?? false;
  }

  // ─── Onboarding ──────────────────────────────────────────────
  @override
  Future<void> setOnboardingSeen() async {
    await sharedPreferences.setBool(AppConstants.onboardingSeenKey, true);
  }

  @override
  bool isOnboardingSeen() {
    return sharedPreferences.getBool(AppConstants.onboardingSeenKey) ?? false;
  }

  // ─── Language ────────────────────────────────────────────────
  @override
  Future<void> saveLanguage(String languageCode) async {
    await sharedPreferences.setString(AppConstants.languageKey, languageCode);
  }

  @override
  String? getLanguage() {
    return sharedPreferences.getString(AppConstants.languageKey);
  }

  // ─── Clear All ───────────────────────────────────────────────
  @override
  Future<void> clearAll() async {
    await secureStorage.deleteAll();
    await sharedPreferences.clear();
  }

  // ─── Legacy compatibility (old key: 'auth_token') ─────────────
  @override
  Future<void> saveToken(String token) => saveAccessToken(token);

  @override
  Future<String?> getToken() => getAccessToken();

  @override
  Future<void> clearToken() => clearAccessToken();
}
