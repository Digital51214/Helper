import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static const String _url = 'https://helpr.digital/api/reset-password';

  static Future<Map<String, dynamic>> resetPassword({
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

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server returned empty response.',
        };
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        return {
          'success': false,
          'message': 'Invalid server response.',
        };
      }

      final bool success =
          decoded['success'] == true ||
              decoded['success']?.toString().toLowerCase() == 'true';

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': success,
          'message': decoded['message'] ??
              (success
                  ? 'Password reset successful! You can now login with your new password.'
                  : 'Unable to reset password.'),
        };
      }

      return {
        'success': false,
        'message': decoded['message'] ??
            'Something went wrong. Please try again.',
      };
    } on SocketException {
      return {
        'success': false,
        'message': 'No internet connection. Please check your network.',
      };
    } on FormatException {
      return {
        'success': false,
        'message': 'Invalid server response.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}