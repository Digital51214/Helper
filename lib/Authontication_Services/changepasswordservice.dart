import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  static const String changePasswordUrl =
      'https://helpr.digital/api/user/change-password';

  static bool _parseSuccess(dynamic value, int statusCode) {
    if (value is bool) return value;

    if (value is String) {
      final v = value.trim().toLowerCase();
      if (v == 'true' || v == '1') return true;
      if (v == 'false' || v == '0') return false;
    }

    if (value is int) return value == 1;

    return statusCode == 200 || statusCode == 201;
  }

  static Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      print('===== CHANGE PASSWORD API HIT =====');
      print('URL: $changePasswordUrl');
      print('USER ID: $userId');
      print('CURRENT PASSWORD LENGTH: ${currentPassword.length}');
      print('NEW PASSWORD LENGTH: ${newPassword.length}');

      final body = {
        'user_id': userId,
        'current_password': currentPassword,
        'new_password': newPassword,
      };

      print('===== CHANGE PASSWORD REQUEST BODY =====');
      print(jsonEncode(body));

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

      print('===== CHANGE PASSWORD API RESPONSE =====');
      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server returned empty response',
          'data': null,
        };
      }

      final decodedData = jsonDecode(response.body);

      if (decodedData is! Map<String, dynamic>) {
        return {
          'success': false,
          'message': 'Invalid server response',
          'data': null,
        };
      }

      final success = _parseSuccess(decodedData['success'], response.statusCode);

      return {
        'success': success,
        'message': decodedData['message'] ??
            (success
                ? 'Password changed successfully'
                : 'Failed to change password'),
        'data': decodedData,
      };
    } on SocketException catch (e) {
      print('===== CHANGE PASSWORD SOCKET ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Network error. Please check your internet connection.',
        'data': null,
      };
    } on TimeoutException {
      print('===== CHANGE PASSWORD TIMEOUT ERROR =====');

      return {
        'success': false,
        'message': 'Server is taking too long to respond.',
        'data': null,
      };
    } on FormatException {
      print('===== CHANGE PASSWORD FORMAT ERROR =====');

      return {
        'success': false,
        'message': 'Invalid server response.',
        'data': null,
      };
    } catch (e) {
      print('===== CHANGE PASSWORD ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Something went wrong: $e',
        'data': null,
      };
    }
  }
}