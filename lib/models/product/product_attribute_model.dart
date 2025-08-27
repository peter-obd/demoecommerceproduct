// class ProductAttribute {
//   final String basicDataCategoryName;
//   final bool isProductVariant;
//   final List<dynamic> values;

//   ProductAttribute({
//     required this.basicDataCategoryName,
//     required this.isProductVariant,
//     required this.values,
//   });

//   factory ProductAttribute.fromJson(Map<String, dynamic> json) {
//     return ProductAttribute(
//       basicDataCategoryName: json['basicDataCategoryName'] ?? '',
//       isProductVariant: json['isProductVariant'] ?? false,
//       values: (json['values'] as List<dynamic>?)
//               ?.map((e) => e.toString())
//               .toList() ??
//           [],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'basicDataCategoryName': basicDataCategoryName,
//         'isProductVariant': isProductVariant,
//         'values': values,
//       };
// }
// product_attribute_model.dart
import 'package:isar/isar.dart';

part 'product_attribute_model.g.dart';

@collection
class ProductAttribute {
  Id isarId = Isar.autoIncrement;

  late String basicDataCategoryName;
  late bool isProductVariant;
  late List<String> values;

  ProductAttribute({
    required this.basicDataCategoryName,
    required this.isProductVariant,
    required this.values,
  });

  ProductAttribute.empty()
      : basicDataCategoryName = '',
        isProductVariant = false,
        values = [];

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      basicDataCategoryName: json['basicDataCategoryName'] ?? '',
      isProductVariant: json['isProductVariant'] ?? false,
      values: (json['values'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'basicDataCategoryName': basicDataCategoryName,
        'isProductVariant': isProductVariant,
        'values': values,
      };
}
