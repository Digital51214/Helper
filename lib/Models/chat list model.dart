class ChatListModel {
  final int userId;
  final String username;
  final String? profilePic;
  final String lastMessage;
  final String time;
  final int unreadCount;

  ChatListModel({
    required this.userId,
    required this.username,
    required this.profilePic,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    return ChatListModel(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      profilePic: json['profile_pic'],
      lastMessage: json['last_message'] ?? '',
      time: json['time'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}