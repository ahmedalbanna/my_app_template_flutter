/// ثوابت التطبيق الأساسية
class AppConstants {
  AppConstants._();

  // ─── API ────────────────────────────────────────────────────
  /// عنوان الـ API الأساسي – غيّره حسب بيئة الإنتاج/التطوير
  static const String baseUrl = 'http://localhost:3000';
  static const String apiVersion = '/api/v1';

  // ─── App Info ────────────────────────────────────────────────
  static const String appName = 'Flutter Template';
  static const String supportEmail = 'support@example.com';
  static const String appVersion = '1.0.0';

  // ─── SharedPreferences Keys ──────────────────────────────────
  static const String themeKey = 'isDarkMode';
  static const String languageKey = 'appLanguage';
  static const String onboardingSeenKey = 'onboardingSeen';

  // ─── SecureStorage Keys ──────────────────────────────────────
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  // ─── Pagination ──────────────────────────────────────────────
  static const int defaultPageSize = 20;

  // ─── Timeouts ────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
