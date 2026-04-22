class ProfileUserModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String profilePic;
  final String createdAt;
  final String updatedAt;
  final String role;

  ProfileUserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.profilePic,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}