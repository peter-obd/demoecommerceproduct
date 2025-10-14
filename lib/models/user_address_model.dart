class UserAddress {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String phoneNumber;
  final double longitude;
  final double latitude;
  final bool isDefault;
  final String createdAt;
  final String updatedAt;

  UserAddress({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.phoneNumber,
    required this.longitude,
    required this.latitude,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      longitude: (json['longitude'] is num) ? json['longitude'].toDouble() : 0.0,
      latitude: (json['latitude'] is num) ? json['latitude'].toDouble() : 0.0,
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'phoneNumber': phoneNumber,
      'longitude': longitude,
      'latitude': latitude,
      'isDefault': isDefault,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}