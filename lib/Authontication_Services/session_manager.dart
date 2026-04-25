import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _clientIdKey = 'client_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _profilePicKey = 'profile_pic';

  static const String _baseUrl = 'https://helpr.digital/';

  static String normalizeProfilePic(String profilePic) {
    final value = profilePic.trim();

    if (value.isEmpty) return '';

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    if (value.startsWith('/')) {
      return '${_baseUrl}${value.substring(1)}';
    }

    return '$_baseUrl$value';
  }

  static Future<void> saveLoginSession({
    required int userId,
    required String email,
    int? clientId,
    String username = '',
    String profilePic = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedProfilePic = normalizeProfilePic(profilePic);

    final int finalClientId = clientId ?? userId;

    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setInt(_clientIdKey, finalClientId);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, username);
    await prefs.setString(_profilePicKey, normalizedProfilePic);

    print('===== SESSION SAVED =====');
    print('USER ID   : $userId');
    print('CLIENT ID : $finalClientId');
    print('EMAIL     : $email');
    print('USERNAME  : $username');
    print('PROFILE   : $normalizedProfilePic');
  }

  static Future<void> updateProfileData({
    required String username,
    required String email,
    required String profilePic,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedProfilePic = normalizeProfilePic(profilePic);

    await prefs.setString(_userNameKey, username);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_profilePicKey, normalizedProfilePic);

    print('===== SESSION PROFILE UPDATED =====');
    print('USERNAME : $username');
    print('EMAIL    : $email');
    print('PIC URL  : $normalizedProfilePic');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey) ?? 0;
  }

  static Future<int> getClientId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_clientIdKey) ?? 0;
  }

  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey) ?? '';
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey) ?? '';
  }

  static Future<String> getProfilePic() async {
    final prefs = await SharedPreferences.getInstance();
    final profilePic = prefs.getString(_profilePicKey) ?? '';
    return normalizeProfilePic(profilePic);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_clientIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_profilePicKey);

    print('===== SESSION CLEARED =====');
  }
}