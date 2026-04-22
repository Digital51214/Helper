import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:helper/Models/profile_model.dart';
import 'package:http/http.dart' as http;

class ProfileViewService {
  static const String profileViewUrl =
      'https://helpr.digital/api/user/profile/view';

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

  static Future<Map<String, dynamic>> fetchProfile({
    required int userId,
  }) async {
    try {
      print('===== PROFILE VIEW API HIT =====');
      print('URL: $profileViewUrl');
      print('USER ID: $userId');

      final body = {
        'user_id': userId,
      };

      print('===== PROFILE VIEW REQUEST BODY =====');
      print(jsonEncode(body));

      final response = await http
          .post(
        Uri.parse(profileViewUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 20));

      print('===== PROFILE VIEW RESPONSE =====');
      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server returned empty response',
          'user': null,
        };
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        return {
          'success': false,
          'message': 'Invalid server response',
          'user': null,
        };
      }

      final success = _parseSuccess(decoded['success'], response.statusCode);

      ProfileUserModel? user;
      if (decoded['user'] is Map<String, dynamic>) {
        user = ProfileUserModel.fromJson(decoded['user']);
      }

      return {
        'success': success,
        'message': decoded['message']?.toString() ?? '',
        'user': user,
      };
    } on SocketException catch (e) {
      print('===== PROFILE VIEW SOCKET ERROR =====');
      print(e.toString());
      return {
        'success': false,
        'message': 'Network error. Please check your internet connection.',
        'user': null,
      };
    } on TimeoutException {
      print('===== PROFILE VIEW TIMEOUT =====');
      return {
        'success': false,
        'message': 'Server is taking too long to respond.',
        'user': null,
      };
    } on FormatException {
      print('===== PROFILE VIEW FORMAT ERROR =====');
      return {
        'success': false,
        'message': 'Invalid server response.',
        'user': null,
      };
    } catch (e) {
      print('===== PROFILE VIEW ERROR =====');
      print(e.toString());
      return {
        'success': false,
        'message': 'Something went wrong: $e',
        'user': null,
      };
    }
  }
}