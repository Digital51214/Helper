import 'dart:convert';

class JobModel {
  final int id;
  final int clientId;
  final String category;
  final String title;
  final String description;
  final String images;
  final String amount;
  final String schedule;
  final String location;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String categoryIcon;
  final String postedAt;
  final String appliedCount;

  JobModel({
    required this.id,
    required this.clientId,
    required this.category,
    required this.title,
    required this.description,
    required this.images,
    required this.amount,
    required this.schedule,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryIcon,
    required this.postedAt,
    required this.appliedCount,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json["id"] ?? 0,
      clientId: json["client_id"] ?? 0,
      category: json["category"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      images: json["images"] is List
          ? jsonEncode(json["images"])
          : json["images"]?.toString() ?? "",
      amount: json["amount"]?.toString() ?? "",
      schedule: json["schedule"] ?? "",
      location: json["location"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      categoryIcon: json["category_icon"] ?? "",
      postedAt: json["posted_at"] ?? "",
      appliedCount: json["applied_count"] ?? "50k+ Applied",
    );
  }

  String get fullJobImage {
    if (images.isEmpty) return "";
    if (images.startsWith("http")) return images;
    return "https://helpr.digital/$images";
  }
}