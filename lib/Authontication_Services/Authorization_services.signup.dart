import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'https://helpr.digital';
  static final Uri _loginUri = Uri.parse('$_baseUrl/api/signin');
  static final Uri _signupUri = Uri.parse('$_baseUrl/api/signup');

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('===== LOGIN API HIT =====');
      print('URL: $_loginUri');
      print('EMAIL: $email');

      final response = await http
          .post(
        _loginUri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      )
          .timeout(const Duration(seconds: 20));

      print('===== LOGIN RESPONSE =====');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      return _handleResponse(response, defaultMessage: 'Login failed');
    } on SocketException catch (e) {
      print('===== LOGIN SOCKET ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message':
        'Internet ya server issue hai. Apna network check karein ya baad me dobara try karein.',
      };
    } on TimeoutException {
      print('===== LOGIN TIMEOUT ERROR =====');

      return {
        'success': false,
        'message': 'Server response late aa raha hai. Dobara try karein.',
      };
    } on FormatException {
      print('===== LOGIN FORMAT ERROR =====');

      return {
        'success': false,
        'message': 'Server se invalid response aaya hai.',
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
      print('URL: $_signupUri');
      print('USERNAME: $username');
      print('EMAIL: $email');
      print('PHONE: $phone');

      final response = await http
          .post(
        _signupUri,
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
      )
          .timeout(const Duration(seconds: 20));

      print('===== SIGNUP RESPONSE =====');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      return _handleResponse(response, defaultMessage: 'Signup failed');
    } on SocketException catch (e) {
      print('===== SIGNUP SOCKET ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message':
        'Server ya domain reach nahi ho raha. Internet/DNS issue ho sakta hai. Browser me helpr.digital check karein.',
      };
    } on TimeoutException {
      print('===== SIGNUP TIMEOUT ERROR =====');

      return {
        'success': false,
        'message': 'Server response late aa raha hai. Dobara try karein.',
      };
    } on FormatException {
      print('===== SIGNUP FORMAT ERROR =====');

      return {
        'success': false,
        'message': 'Server se invalid response aaya hai.',
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

  Map<String, dynamic> _handleResponse(
      http.Response response, {
        required String defaultMessage,
      }) {
    Map<String, dynamic> data = {};

    try {
      data = jsonDecode(response.body);
    } catch (_) {
      return {
        'success': false,
        'message': 'Server response samajh nahi aaya.',
        'data': {},
      };
    }

    String errorMessage = data['message'] ?? defaultMessage;

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
      'success': data['success'] ?? (response.statusCode >= 200 && response.statusCode < 300),
      'message': errorMessage,
      'data': data,
    };
  }
}