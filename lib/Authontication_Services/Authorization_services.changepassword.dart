import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  static const String changePasswordUrl =
      'https://helpr.digital/api/user/change-password';

  bool _parseSuccess(dynamic value, int statusCode) {
    if (value is bool) return value;

    if (value is String) {
      final v = value.trim().toLowerCase();
      if (v == 'true' || v == '1') return true;
      if (v == 'false' || v == '0') return false;
    }

    if (value is int) {
      return value == 1;
    }

    return statusCode >= 200 && statusCode < 300;
  }

  Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final body = {
        'user_id': userId,
        'current_password': currentPassword,
        'new_password': newPassword,
      };

      print('===== CHANGE PASSWORD API HIT =====');
      print('URL: $changePasswordUrl');
      print('REQUEST BODY: ${jsonEncode(body)}');

      final response = await http
          .post(
        Uri.parse(changePasswordUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 20));

      print('===== CHANGE PASSWORD RESPONSE =====');
      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server returned empty response',
        };
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        return {
          'success': false,
          'message': 'Unexpected server response',
        };
      }

      return {
        'success': _parseSuccess(decoded['success'], response.statusCode),
        'message': decoded['message']?.toString() ?? 'Something went wrong',
        'data': decoded,
      };
    } on SocketException catch (e) {
      print('===== CHANGE PASSWORD SOCKET ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Network error. Please check your internet connection.',
      };
    } on TimeoutException {
      print('===== CHANGE PASSWORD TIMEOUT ERROR =====');

      return {
        'success': false,
        'message': 'Server is taking too long to respond. Please try again.',
      };
    } on FormatException {
      print('===== CHANGE PASSWORD FORMAT ERROR =====');

      return {
        'success': false,
        'message': 'Invalid server response.',
      };
    } catch (e) {
      print('===== CHANGE PASSWORD ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    }
  }
}