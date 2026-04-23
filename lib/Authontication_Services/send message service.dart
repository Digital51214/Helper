import 'dart:convert';
import 'package:helper/Models/send%20message%20responce%20model.dart';
import 'package:http/http.dart' as http;

class SendMessageService {
  static const String _url = 'https://helpr.digital/api/chat/send';

  static Future<SendMessageResponseModel> sendTextMessage({
    required int senderId,
    required int receiverId,
    required String message,
  }) async {
    try {
      print('SendMessageService: sending text message');

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'sender_id': senderId,
          'receiver_id': receiverId,
          'type': 'text',
          'message': message,
        }),
      );

      print('SendMessageService Text: status = ${response.statusCode}');
      print('SendMessageService Text: response = ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SendMessageResponseModel.fromJson(data);
      } else {
        throw Exception('Failed to send text message');
      }
    } catch (e) {
      print('SendMessageService Text Error: $e');
      rethrow;
    }
  }

  static Future<SendMessageResponseModel> sendAudioMessage({
    required int senderId,
    required int receiverId,
    required String base64Audio,
    String message = 'Voice Note',
  }) async {
    try {
      print('SendMessageService: sending audio message');

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'sender_id': senderId,
          'receiver_id': receiverId,
          'type': 'audio',
          'file_data': base64Audio,
          'message': message,
        }),
      );

      print('SendMessageService Audio: status = ${response.statusCode}');
      print('SendMessageService Audio: response = ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SendMessageResponseModel.fromJson(data);
      } else {
        throw Exception('Failed to send audio message');
      }
    } catch (e) {
      print('SendMessageService Audio Error: $e');
      rethrow;
    }
  }
}