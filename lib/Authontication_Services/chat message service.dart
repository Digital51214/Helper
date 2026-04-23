import 'dart:convert';
import 'package:helper/Models/chat%20message%20model.dart';
import 'package:http/http.dart' as http;

class ChatMessagesService {
  static const String _url = 'https://helpr.digital/api/chat/messages';

  static Future<List<ChatMessageModel>> getMessages({
    required int userId,
    required int otherUserId,
  }) async {
    try {
      print('ChatMessagesService: calling messages API');
      print('ChatMessagesService: userId = $userId, otherUserId = $otherUserId');

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'other_user_id': otherUserId,
        }),
      );

      print('ChatMessagesService: status code = ${response.statusCode}');
      print('ChatMessagesService: response = ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List messages = data['messages'] ?? [];
        return messages.map((e) => ChatMessageModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      print('ChatMessagesService Error: $e');
      rethrow;
    }
  }
}