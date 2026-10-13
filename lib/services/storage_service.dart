import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyStudentEmail = 'student_email';
  static const String keyRememberMe = 'remember_me';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (_) {
      _prefs = null;
    }
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  static Future<bool> setBool(String key, bool value) async {
    if (_prefs == null) return false;
    return await _prefs!.setBool(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  static Future<bool> setString(String key, String value) async {
    if (_prefs == null) return false;
    return await _prefs!.setString(key, value);
  }

  static Future<bool> remove(String key) async {
    if (_prefs == null) return false;
    return await _prefs!.remove(key);
  }

  static Future<bool> clear() async {
    if (_prefs == null) return false;
    return await _prefs!.clear();
  }
}
