// class Category {
//   final String id;
//   final String name;
//   final String? abbreviation;
//   final String? iconUrl;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   Category({
//     required this.id,
//     required this.name,
//     this.abbreviation,
//     this.iconUrl,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['id'] ?? "",
//       name: json['name'] ?? "",
//       abbreviation: json['abbreviation'] ?? "",
//       iconUrl: json['iconUrl'] ?? "",
//       createdAt: DateTime.parse(json['createdAt'] ?? ""),
//       updatedAt: DateTime.parse(json['updatedAt'] ?? ""),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'abbreviation': abbreviation,
//       'iconUrl': iconUrl,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }
// category_model.dart
import 'package:isar/isar.dart';

part 'category_model.g.dart';

@collection
class Category {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String name;
  String? abbreviation;
  String? iconUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    this.abbreviation,
    this.iconUrl,
    this.createdAt,
    this.updatedAt,
  });

  Category.empty()
      : id = '',
        name = '';

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      abbreviation: json['abbreviation'],
      iconUrl: json['iconUrl'],
      createdAt:
          json['createdAt'] != null && json['createdAt'].toString().isNotEmpty
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null && json['updatedAt'].toString().isNotEmpty
              ? DateTime.tryParse(json['updatedAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'iconUrl': iconUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
