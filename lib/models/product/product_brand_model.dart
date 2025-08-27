// import 'package:isar/isar.dart';

// class Brand {
//   final String? id;
//   final String? name;
//   final String? abbreviation;
//   final String? slogan;
//   final String? logoUrl;
//   final String? description;
//   final String? createdAt;
//   final String? updatedAt;

//   Brand({
//     this.id,
//     this.name,
//     this.abbreviation,
//     this.slogan,
//     this.logoUrl,
//     this.description,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory Brand.fromJson(Map<String, dynamic> json) {
//     return Brand(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       abbreviation: json['abbreviation'] ?? '',
//       slogan: json['slogan'] ?? '',
//       logoUrl: json['logoUrl'] ?? '',
//       description: json['description'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'abbreviation': abbreviation,
//         'slogan': slogan,
//         'logoUrl': logoUrl,
//         'description': description,
//         'createdAt': createdAt,
//         'updatedAt': updatedAt,
//       };
// }
// product_brand_model.dart
import 'package:isar/isar.dart';

part 'product_brand_model.g.dart';

@collection
class Brand {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  String? id;

  String? name;
  String? abbreviation;
  String? slogan;
  String? logoUrl;
  String? description;
  String? createdAt;
  String? updatedAt;

  Brand({
    this.id,
    this.name,
    this.abbreviation,
    this.slogan,
    this.logoUrl,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  Brand.empty();

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
      slogan: json['slogan'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'abbreviation': abbreviation,
        'slogan': slogan,
        'logoUrl': logoUrl,
        'description': description,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
