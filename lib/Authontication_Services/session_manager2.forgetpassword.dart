import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _forgotUserIdKey = 'forgot_user_id';
  static const String _forgotOtpKey = 'forgot_otp';
  static const String _forgotSentToKey = 'forgot_sent_to';
  static const String _forgotIsPhoneKey = 'forgot_is_phone';
  static const String _forgotOtpExpiryKey = 'forgot_otp_expiry';
  static const String _forgotOtpConsumedKey = 'forgot_otp_consumed';
  static const String _forgotOtpVerifiedKey = 'forgot_otp_verified';

  static const int otpExpiryInMinutes = 5;

  static Future<void> saveForgotPasswordSession({
    required int userId,
    required int otp,
    required String sentTo,
    required bool isPhone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final expiry = DateTime.now()
        .add(const Duration(minutes: otpExpiryInMinutes))
        .millisecondsSinceEpoch;

    await prefs.setInt(_forgotUserIdKey, userId);
    await prefs.setInt(_forgotOtpKey, otp);
    await prefs.setString(_forgotSentToKey, sentTo);
    await prefs.setBool(_forgotIsPhoneKey, isPhone);
    await prefs.setInt(_forgotOtpExpiryKey, expiry);
    await prefs.setBool(_forgotOtpConsumedKey, false);
    await prefs.setBool(_forgotOtpVerifiedKey, false);
  }

  static Future<int?> getForgotUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_forgotUserIdKey);
  }

  static Future<int?> getForgotOtp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_forgotOtpKey);
  }

  static Future<String?> getForgotSentTo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_forgotSentToKey);
  }

  static Future<bool?> getForgotIsPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_forgotIsPhoneKey);
  }

  static Future<int?> getForgotOtpExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_forgotOtpExpiryKey);
  }

  static Future<bool> isForgotOtpConsumed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_forgotOtpConsumedKey) ?? false;
  }

  static Future<bool> isForgotOtpVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_forgotOtpVerifiedKey) ?? false;
  }

  static Future<void> markForgotOtpConsumed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_forgotOtpConsumedKey, true);
  }

  static Future<void> markForgotOtpVerified(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_forgotOtpVerifiedKey, value);
  }

  static Future<bool> isForgotOtpExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiry = prefs.getInt(_forgotOtpExpiryKey);

    if (expiry == null) return true;

    return DateTime.now().millisecondsSinceEpoch > expiry;
  }

  static Future<void> clearForgotPasswordSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_forgotUserIdKey);
    await prefs.remove(_forgotOtpKey);
    await prefs.remove(_forgotSentToKey);
    await prefs.remove(_forgotIsPhoneKey);
    await prefs.remove(_forgotOtpExpiryKey);
    await prefs.remove(_forgotOtpConsumedKey);
    await prefs.remove(_forgotOtpVerifiedKey);
  }
}