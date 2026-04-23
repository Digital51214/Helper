import 'dart:convert';
import 'package:helper/Models/chat%20list%20model.dart';
import 'package:http/http.dart' as http;

class ChatListService {
  static const String _url = 'https://helpr.digital/api/chat/list';

  static Future<List<ChatListModel>> getChatList({required int userId}) async {
    try {
      print('ChatListService: calling chat list API for userId = $userId');

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
        }),
      );

      print('ChatListService: status code = ${response.statusCode}');
      print('ChatListService: response = ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List chats = data['chats'] ?? [];
        return chats.map((e) => ChatListModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load chat list');
      }
    } catch (e) {
      print('ChatListService Error: $e');
      rethrow;
    }
  }
}