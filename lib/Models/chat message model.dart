class ChatMessageModel {
  final int id;
  final String message;
  final String type;
  final String? fileUrl;
  final bool isMine;
  final String time;

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.type,
    required this.fileUrl,
    required this.isMine,
    required this.time,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      type: json['type'] ?? 'text',
      fileUrl: json['file_url'],
      isMine: json['is_mine'] ?? false,
      time: json['time'] ?? '',
    );
  }
}