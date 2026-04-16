import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String loginUrl = 'https://helpr.digital/api/signin';

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('===== LOGIN API HIT =====');
      print('URL: $loginUrl');
      print('EMAIL: $email');
      print('PASSWORD: $password');

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('===== LOGIN API RESPONSE =====');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': decodedData['success'] ?? true,
          'message': decodedData['message'] ?? 'Login successful',
          'data': decodedData,
        };
      } else {
        return {
          'success': decodedData['success'] ?? false,
          'message': decodedData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('===== LOGIN API ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    }
  }
}