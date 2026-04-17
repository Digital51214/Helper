import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

      if (email != null && email.trim().isNotEmpty) {
        body['email'] = email.trim().toLowerCase();
      } else if (phone != null && phone.trim().isNotEmpty) {
        body['phone'] = phone.trim();
      } else {
        return {
          'success': false,
          'message': 'Email or phone is required.',
        };
      }

      print('===== FORGOT PASSWORD API HIT =====');
      print('URL: $forgotPasswordUrl');
      print('REQUEST BODY: ${jsonEncode(body)}');

      final response = await http
          .post(
        Uri.parse(forgotPasswordUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 20));

      print('===== FORGOT PASSWORD RESPONSE =====');
      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server returned empty response',
        };
      }

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return {
          'success': decoded['success'] == true ||
              (response.statusCode >= 200 && response.statusCode < 300),
          'message': decoded['message']?.toString() ?? 'Something went wrong',
          'user_id': decoded['user_id'],
          'data': decoded,
        };
      } else {
        return {
          'success': false,
          'message': 'Unexpected server response',
        };
      }
    } on SocketException catch (e) {
      print('===== FORGOT PASSWORD SOCKET ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Network error. Please check your internet connection.',
      };
    } on TimeoutException {
      print('===== FORGOT PASSWORD TIMEOUT ERROR =====');

      return {
        'success': false,
        'message': 'Server is taking too long to respond. Please try again.',
      };
    } on FormatException {
      print('===== FORGOT PASSWORD FORMAT ERROR =====');

      return {
        'success': false,
        'message': 'Invalid server response.',
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