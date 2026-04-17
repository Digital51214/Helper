import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  static const String loginUrl = 'https://helpr.digital/api/signin';

  bool _parseSuccess(dynamic value, int statusCode) {
    if (value is bool) return value;

    if (value is String) {
      final v = value.trim().toLowerCase();
      if (v == 'true' || v == '1') return true;
      if (v == 'false' || v == '0') return false;
    }

    if (value is int) return value == 1;

    return statusCode == 200 || statusCode == 201;
  }

  int? _extractUserId(Map<String, dynamic> data) {
    final dynamic id =
        data['user_id'] ??
            data['id'] ??
            data['user']?['id'] ??
            data['data']?['user_id'] ??
            data['data']?['id'] ??
            data['data']?['user']?['id'];

    if (id is int) return id;
    return int.tryParse(id?.toString() ?? '');
  }

  String? _extractEmail(Map<String, dynamic> data) {
    final dynamic value =
        data['email'] ??
            data['user']?['email'] ??
            data['data']?['email'] ??
            data['data']?['user']?['email'];

    return value?.toString();
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('===== LOGIN API HIT =====');
      print('URL: $loginUrl');
      print('EMAIL: $email');
      print('PASSWORD: $password');

      final response = await http
          .post(
        Uri.parse(loginUrl),
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

      print('===== LOGIN API RESPONSE =====');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server returned empty response',
          'user_id': null,
          'email': null,
          'data': null,
        };
      }

      final decodedData = jsonDecode(response.body);

      if (decodedData is! Map<String, dynamic>) {
        return {
          'success': false,
          'message': 'Invalid server response',
          'user_id': null,
          'email': null,
          'data': null,
        };
      }

      final success = _parseSuccess(decodedData['success'], response.statusCode);
      final userId = _extractUserId(decodedData);
      final extractedEmail = _extractEmail(decodedData);

      print('===== EXTRACTED LOGIN DATA =====');
      print('USER ID: $userId');
      print('EMAIL: $extractedEmail');

      return {
        'success': success,
        'message': decodedData['message'] ??
            (success ? 'Login successful' : 'Login failed'),
        'user_id': userId,
        'email': extractedEmail ?? email,
        'data': decodedData,
      };
    } on SocketException catch (e) {
      print('===== LOGIN SOCKET ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Network error. Please check your internet connection.',
        'user_id': null,
        'email': null,
        'data': null,
      };
    } on TimeoutException {
      print('===== LOGIN TIMEOUT ERROR =====');

      return {
        'success': false,
        'message': 'Server is taking too long to respond.',
        'user_id': null,
        'email': null,
        'data': null,
      };
    } on FormatException {
      print('===== LOGIN FORMAT ERROR =====');

      return {
        'success': false,
        'message': 'Invalid server response.',
        'user_id': null,
        'email': null,
        'data': null,
      };
    } catch (e) {
      print('===== LOGIN ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Something went wrong: $e',
        'user_id': null,
        'email': null,
        'data': null,
      };
    }
  }
}