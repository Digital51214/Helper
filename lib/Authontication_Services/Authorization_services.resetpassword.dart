import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static const String resetPasswordUrl =
      'https://helpr.digital/api/reset-password';

  Future<Map<String, dynamic>> resetPassword({
    required int userId,
    required String otp,
    required String password,
  }) async {
    try {
      final body = {
        'user_id': userId,
        'otp': otp,
        'password': password,
      };

      print('===== RESET PASSWORD API HIT =====');
      print('URL: $resetPasswordUrl');
      print('REQUEST BODY: $body');

      final response = await http.post(
        Uri.parse(resetPasswordUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('===== RESET PASSWORD RESPONSE =====');
      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');

      final data = jsonDecode(response.body);

      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Something went wrong',
        'data': data,
      };
    } catch (e) {
      print('===== RESET PASSWORD ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    }
  }
}