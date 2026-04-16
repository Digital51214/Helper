import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String loginUrl = 'https://helpr.digital/api/signin';
  static const String signupUrl = 'https://helpr.digital/api/signup';

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

      print('===== LOGIN RESPONSE =====');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      final data = jsonDecode(response.body);

      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Something went wrong',
        'data': data,
      };
    } catch (e) {
      print('===== LOGIN ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    }
  }

  Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      print('===== SIGNUP API HIT =====');
      print('URL: $signupUrl');
      print('USERNAME: $username');
      print('EMAIL: $email');
      print('PHONE: $phone');
      print('PASSWORD: $password');

      final response = await http.post(
        Uri.parse(signupUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      print('===== SIGNUP RESPONSE =====');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      final data = jsonDecode(response.body);

      String errorMessage = data['message'] ?? 'Signup failed';

      if (data['errors'] != null && data['errors'] is Map) {
        final errors = data['errors'] as Map<String, dynamic>;
        List<String> allErrors = [];

        errors.forEach((key, value) {
          if (value is List) {
            for (var item in value) {
              allErrors.add(item.toString());
            }
          } else {
            allErrors.add(value.toString());
          }
        });

        if (allErrors.isNotEmpty) {
          errorMessage = allErrors.join('\n');
        }
      }

      return {
        'success': data['success'] ?? false,
        'message': errorMessage,
        'data': data,
      };
    } catch (e) {
      print('===== SIGNUP ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    }
  }
}