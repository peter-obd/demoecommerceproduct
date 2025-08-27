// class ProductVariant {
//   final String id;
//   final String sku;
//   final int discount;
//   final int stock;
//   final List<String> images;
//   final Map<String, dynamic> attributesValues;

//   ProductVariant({
//     required this.id,
//     required this.sku,
//     required this.discount,
//     required this.stock,
//     required this.images,
//     required this.attributesValues,
//   });

//   factory ProductVariant.fromJson(Map<String, dynamic> json) {
//     return ProductVariant(
//       id: json['id'] ?? '',
//       sku: json['sku'] ?? '',
//       discount: json['discount'] ?? 0,
//       stock: json['stock'] ?? 0,
//       images: (json['images'] as List<dynamic>?)
//               ?.map((e) => e.toString())
//               .toList() ??
//           [],
//       attributesValues: (json['attributesValues'] as Map<String, dynamic>?)
//               ?.map((k, v) => MapEntry(k, v.toString())) ??
//           {},
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'sku': sku,
//         'discount': discount,
//         'stock': stock,
//         'images': images,
//         'attributesValues': attributesValues,
//       };
// }
// product_variant_model.dart
// product_variant_model.dart
import 'dart:convert';

import 'package:isar/isar.dart';

part 'product_variant_model.g.dart';

@collection
class ProductVariant {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String sku;
  late int discount;
  late int stock;
  late List<String> images;

  // Store the map as JSON string for Isar compatibility
  late String attributesValuesJson;

  ProductVariant({
    required this.id,
    required this.sku,
    required this.discount,
    required this.stock,
    required this.images,
    Map<String, dynamic>? attributesValues,
  }) {
    // Convert Map to JSON string for storage
    attributesValuesJson = jsonEncode(attributesValues ?? {});
  }

  ProductVariant.empty()
      : id = '',
        sku = '',
        discount = 0,
        stock = 0,
        images = [],
        attributesValuesJson = '{}';

  // Helper methods for attributesValues
  Map<String, dynamic> getAttributesValues() {
    try {
      return Map<String, dynamic>.from(jsonDecode(attributesValuesJson));
    } catch (e) {
      return {};
    }
  }

  void setAttributesValues(Map<String, dynamic> value) {
    attributesValuesJson = jsonEncode(value);
  }

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] ?? '',
      sku: json['sku'] ?? '',
      discount: json['discount'] ?? 0,
      stock: json['stock'] ?? 0,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      attributesValues:
          (json['attributesValues'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sku': sku,
        'discount': discount,
        'stock': stock,
        'images': images,
        'attributesValues': getAttributesValues(),
      };
}
