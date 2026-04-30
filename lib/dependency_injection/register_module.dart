import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

@module
abstract class RegisterModule {
  /// SharedPreferences – يحتاج await لذا preResolve
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  /// FlutterSecureStorage – تخزين آمن للـ tokens
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  /// Connectivity – لمراقبة حالة الشبكة
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
