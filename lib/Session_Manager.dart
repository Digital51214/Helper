import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String isLoginKey = 'isLogin';

  static Future<void> saveLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoginKey, true);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLoginKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoginKey) ?? false;
  }
}