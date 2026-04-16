import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static const String forgotPasswordUrl =
      'https://helpr.digital/api/forgot-password';

  Future<Map<String, dynamic>> forgotPassword({
    String? email,
    String? phone,
  }) async {
    try {
      final Map<String, dynamic> body = {};

      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }

      if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }

      print('===== FORGOT PASSWORD API HIT =====');
      print('URL: $forgotPasswordUrl');
      print('REQUEST BODY: $body');

      final response = await http.post(
        Uri.parse(forgotPasswordUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('===== FORGOT PASSWORD RESPONSE =====');
      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');

      final data = jsonDecode(response.body);

      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Something went wrong',
        'user_id': data['user_id'],
        'data': data,
      };
    } catch (e) {
      print('===== FORGOT PASSWORD ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    }
  }
}