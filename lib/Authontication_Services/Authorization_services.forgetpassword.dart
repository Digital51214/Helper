import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordResponse {
  final bool success;
  final int otp;
  final String message;
  final int userId;

  ForgotPasswordResponse({
    required this.success,
    required this.otp,
    required this.message,
    required this.userId,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] ?? false,
      otp: json['otp'] ?? 0,
      message: json['message'] ?? '',
      userId: json['user_id'] ?? 0,
    );
  }
}

class ForgotPasswordService {
  static const String _url = 'https://helpr.digital/api/forgot-password';

  Future<ForgotPasswordResponse> sendForgotPasswordOtp({
    String? email,
    String? phone,
  }) async {
    try {
      final Map<String, dynamic> body = {};

      if (email != null && email.trim().isNotEmpty) {
        body['email'] = email.trim();
      }

      if (phone != null && phone.trim().isNotEmpty) {
        body['phone'] = phone.trim();
      }

      if (body.isEmpty) {
        throw Exception('Email or phone is required');
      }

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ForgotPasswordResponse.fromJson(decoded);
      } else {
        throw Exception(
          decoded['message']?.toString() ?? 'Failed to send OTP',
        );
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}