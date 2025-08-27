import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement; // Local ID for Isar

  late String token;
  late DateTime expiresAt;
  late String userId;
  late String phone;
  late String name;

  // Default constructor
  User();

  // Named constructor for creating from API JSON
  User.fromData({
    required this.token,
    required this.expiresAt,
    required this.userId,
    required this.phone,
    required this.name,
  });

  // Factory constructor to create from API JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User.fromData(
      token: json['token'] ?? '',
      expiresAt: DateTime.parse(json['expiresAt']),
      userId: json['userId'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
    );
  }

  // Convert back to JSON (for API usage)
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
      'userId': userId,
      'phone': phone,
      'name': name,
    };
  }
}