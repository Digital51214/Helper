import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:helper/Authontication_Services/session_manager.dart';

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

  int? _extractClientId(Map<String, dynamic> data) {
    final dynamic id =
        data['client_id'] ??
            data['client']?['id'] ??
            data['user']?['client_id'] ??
            data['user']?['client']?['id'] ??
            data['data']?['client_id'] ??
            data['data']?['client']?['id'] ??
            data['data']?['user']?['client_id'] ??
            data['data']?['user']?['client']?['id'];

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

  String? _extractUsername(Map<String, dynamic> data) {
    final dynamic value =
        data['username'] ??
            data['name'] ??
            data['user']?['username'] ??
            data['user']?['name'] ??
            data['data']?['username'] ??
            data['data']?['name'] ??
            data['data']?['user']?['username'] ??
            data['data']?['user']?['name'];

    return value?.toString();
  }

  String? _extractProfilePic(Map<String, dynamic> data) {
    final dynamic value =
        data['profile_pic'] ??
            data['profile_image'] ??
            data['image'] ??
            data['user']?['profile_pic'] ??
            data['user']?['profile_image'] ??
            data['user']?['image'] ??
            data['data']?['profile_pic'] ??
            data['data']?['profile_image'] ??
            data['data']?['image'] ??
            data['data']?['user']?['profile_pic'] ??
            data['data']?['user']?['profile_image'] ??
            data['data']?['user']?['image'];

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
      print('PASSWORD LENGTH: ${password.length}');

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
          'client_id': null,
          'email': null,
          'username': null,
          'profile_pic': null,
          'data': null,
        };
      }

      final decodedData = jsonDecode(response.body);

      if (decodedData is! Map<String, dynamic>) {
        return {
          'success': false,
          'message': 'Invalid server response',
          'user_id': null,
          'client_id': null,
          'email': null,
          'username': null,
          'profile_pic': null,
          'data': null,
        };
      }

      final success = _parseSuccess(decodedData['success'], response.statusCode);
      final userId = _extractUserId(decodedData);
      final clientId = _extractClientId(decodedData) ?? userId;

      final extractedEmail = _extractEmail(decodedData);
      final extractedUsername = _extractUsername(decodedData);
      final extractedProfilePic = _extractProfilePic(decodedData);
      final normalizedProfilePic =
      SessionManager.normalizeProfilePic(extractedProfilePic ?? '');

      print('===== EXTRACTED LOGIN DATA =====');
      print('USER ID: $userId');
      print('CLIENT ID: $clientId');
      print('EMAIL: $extractedEmail');
      print('USERNAME: $extractedUsername');
      print('PROFILE PIC RAW: $extractedProfilePic');
      print('PROFILE PIC NORMALIZED: $normalizedProfilePic');

      return {
        'success': success,
        'message': decodedData['message'] ??
            (success ? 'Login successful' : 'Login failed'),
        'user_id': userId,
        'client_id': clientId,
        'email': extractedEmail ?? email,
        'username': extractedUsername ?? '',
        'profile_pic': normalizedProfilePic,
        'data': decodedData,
      };
    } on SocketException catch (e) {
      print('===== LOGIN SOCKET ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Network error. Please check your internet connection.',
        'user_id': null,
        'client_id': null,
        'email': null,
        'username': null,
        'profile_pic': null,
        'data': null,
      };
    } on TimeoutException {
      print('===== LOGIN TIMEOUT ERROR =====');

      return {
        'success': false,
        'message': 'Server is taking too long to respond.',
        'user_id': null,
        'client_id': null,
        'email': null,
        'username': null,
        'profile_pic': null,
        'data': null,
      };
    } on FormatException {
      print('===== LOGIN FORMAT ERROR =====');

      return {
        'success': false,
        'message': 'Invalid server response.',
        'user_id': null,
        'client_id': null,
        'email': null,
        'username': null,
        'profile_pic': null,
        'data': null,
      };
    } catch (e) {
      print('===== LOGIN ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Something went wrong: $e',
        'user_id': null,
        'client_id': null,
        'email': null,
        'username': null,
        'profile_pic': null,
        'data': null,
      };
    }
  }
}