import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:helper/Models/profile_model.dart';
import 'package:http/http.dart' as http;

class EditProfileService {
  static const String updateProfileUrl =
      'https://helpr.digital/api/user/profile/update';

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

  static Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String username,
    required String email,
    String profilePicBase64 = '',
  }) async {
    try {
      print('===== EDIT PROFILE API HIT =====');
      print('URL: $updateProfileUrl');
      print('USER ID: $userId');
      print('USERNAME: $username');
      print('EMAIL: $email');
      print('PROFILE PIC BASE64 LENGTH: ${profilePicBase64.length}');

      final body = <String, dynamic>{
        'user_id': userId,
        'username': username,
        'email': email,
      };

      if (profilePicBase64.trim().isNotEmpty) {
        body['profile_pic'] = profilePicBase64;
      }

      print('===== EDIT PROFILE REQUEST BODY =====');
      print(jsonEncode(body));

      final response = await http
          .post(
        Uri.parse(updateProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 25));

      print('===== EDIT PROFILE RESPONSE =====');
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
        'message': decoded['message']?.toString() ??
            (success ? 'Profile Updated Successfully!' : 'Failed to update profile'),
        'user': user,
      };
    } on SocketException catch (e) {
      print('===== EDIT PROFILE SOCKET ERROR =====');
      print(e.toString());
      return {
        'success': false,
        'message': 'Network error. Please check your internet connection.',
        'user': null,
      };
    } on TimeoutException {
      print('===== EDIT PROFILE TIMEOUT =====');
      return {
        'success': false,
        'message': 'Server is taking too long to respond.',
        'user': null,
      };
    } on FormatException {
      print('===== EDIT PROFILE FORMAT ERROR =====');
      return {
        'success': false,
        'message': 'Invalid server response.',
        'user': null,
      };
    } catch (e) {
      print('===== EDIT PROFILE ERROR =====');
      print(e.toString());
      return {
        'success': false,
        'message': 'Something went wrong: $e',
        'user': null,
      };
    }}}