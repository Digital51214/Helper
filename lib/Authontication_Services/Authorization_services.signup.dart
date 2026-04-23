import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:helper/Authontication_Services/session_manager.dart';

class AuthService {
  static const String signupUrl = 'https://helpr.digital/api/signup';

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

  String _extractReadableError(
      Map<String, dynamic> decodedData,
      String defaultMessage,
      ) {
    String message = decodedData['message']?.toString().trim() ?? defaultMessage;

    final errors = decodedData['errors'];

    if (errors is Map) {
      final List<String> allErrors = [];

      // Sab field errors collect karo
      errors.forEach((key, value) {
        if (value is List) {
          for (final item in value) {
            final text = item.toString().trim();
            if (text.isNotEmpty) {
              allErrors.add(text);
            }
          }
        } else if (value != null) {
          final text = value.toString().trim();
          if (text.isNotEmpty) {
            allErrors.add(text);
          }
        }
      });

      if (allErrors.isNotEmpty) {
        // Agar phone ka specific error ho to usko priority do
        final phoneError = allErrors.firstWhere(
              (e) =>
          e.toLowerCase().contains('phone') ||
              e.toLowerCase().contains('mobile'),
          orElse: () => '',
        );

        if (phoneError.isNotEmpty) {
          return phoneError;
        }

        return allErrors.join('\n');
      }
    }

    // Kuch APIs "error" field bhejti hain
    if (decodedData['error'] != null &&
        decodedData['error'].toString().trim().isNotEmpty) {
      return decodedData['error'].toString().trim();
    }

    return message;
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

      final response = await http
          .post(
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
      )
          .timeout(const Duration(seconds: 20));

      print('===== SIGNUP RESPONSE =====');
      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server returned empty response',
          'user_id': null,
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
          'email': null,
          'username': null,
          'profile_pic': null,
          'data': null,
        };
      }

      final success = _parseSuccess(decodedData['success'], response.statusCode);
      final userId = _extractUserId(decodedData);
      final extractedEmail = _extractEmail(decodedData);
      final extractedUsername = _extractUsername(decodedData);
      final extractedProfilePic = _extractProfilePic(decodedData);
      final normalizedProfilePic =
      SessionManager.normalizeProfilePic(extractedProfilePic ?? '');

      final readableMessage = _extractReadableError(
        decodedData,
        success ? 'Signup successful' : 'Signup failed',
      );

      print('===== EXTRACTED SIGNUP DATA =====');
      print('USER ID: $userId');
      print('EMAIL: $extractedEmail');
      print('USERNAME: $extractedUsername');
      print('PROFILE PIC RAW: $extractedProfilePic');
      print('PROFILE PIC NORMALIZED: $normalizedProfilePic');
      print('READABLE MESSAGE: $readableMessage');

      return {
        'success': success,
        'message': readableMessage,
        'user_id': userId,
        'email': extractedEmail ?? email,
        'username': extractedUsername ?? username,
        'profile_pic': normalizedProfilePic,
        'data': decodedData,
      };
    } on SocketException catch (e) {
      print('===== SIGNUP SOCKET ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Network error. Please check your internet connection.',
        'user_id': null,
        'email': null,
        'username': null,
        'profile_pic': null,
        'data': null,
      };
    } on TimeoutException {
      print('===== SIGNUP TIMEOUT ERROR =====');

      return {
        'success': false,
        'message': 'Server is taking too long to respond.',
        'user_id': null,
        'email': null,
        'username': null,
        'profile_pic': null,
        'data': null,
      };
    } on FormatException {
      print('===== SIGNUP FORMAT ERROR =====');

      return {
        'success': false,
        'message': 'Invalid server response.',
        'user_id': null,
        'email': null,
        'username': null,
        'profile_pic': null,
        'data': null,
      };
    } catch (e) {
      print('===== SIGNUP ERROR =====');
      print(e.toString());

      return {
        'success': false,
        'message': 'Something went wrong: $e',
        'user_id': null,
        'email': null,
        'username': null,
        'profile_pic': null,
        'data': null,
      };
    }
  }
}