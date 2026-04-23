class SendMessageResponseModel {
  final bool success;
  final SendMessageData? message;

  SendMessageResponseModel({
    required this.success,
    required this.message,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return SendMessageResponseModel(
      success: json['success'] ?? false,
      message: json['message'] != null
          ? SendMessageData.fromJson(json['message'])
          : null,
    );
  }
}

class SendMessageData {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final String type;
  final String? filePath;
  final String? createdAt;
  final String? updatedAt;

  SendMessageData({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SendMessageData.fromJson(Map<String, dynamic> json) {
    return SendMessageData(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      message: json['message'] ?? '',
      type: json['type'] ?? 'text',
      filePath: json['file_path'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}