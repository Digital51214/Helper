import 'package:shared_preferences/shared_preferences.dart';

class SessionManager4 {
  static Future<int?> getClientId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("client_id");
  }

  static Future<void> saveClientId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("client_id", id);
  }

  static Future<void> clearClientId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("client_id");
  }
}