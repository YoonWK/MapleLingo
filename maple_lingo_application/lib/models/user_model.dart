//lib/models/user_model.dart

class UserModel {
  final String user_id;
  final String user_name;
  final String user_email;
  final String user_password; // Hashed password for security

  const UserModel({
    required this.user_id,
    this.user_name = '',
    this.user_email = '',
    this.user_password = '',
  });

  // Factory constructor for session management with just user_id
  factory UserModel.fromUserId(String userId) => UserModel(user_id: userId);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user_id: json['user_id'],
        user_name: json['user_name'] ?? '', // Handle potential missing values
        user_email: json['user_email'] ?? '',
        user_password: json['user_password'] ?? '',
      );
}
