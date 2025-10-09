// import 'package:demoecommerceproduct/models/category_model.dart';
// import 'package:demoecommerceproduct/models/product/product_attribute_model.dart';
// import 'package:demoecommerceproduct/models/product/product_brand_model.dart';
// import 'package:demoecommerceproduct/models/product/product_variant_model.dart';

// class ProductItem {
//   final String id;
//   final String name;
//   final String code;
//   final String description;
//   final String categoryId;
//   final String brandId;
//   final double cost;
//   final double margin;
//   final double sellingPrice;
//   final double discount;
//   final String currency;
//   final String? thumbnail;
//   final Brand? brand;
//   final Category? category;
//   final List<ProductAttribute> attributes;
//   final List<ProductVariant> variants;
//   final double rating;
//   final String createdAt;
//   final String updatedAt;

//   ProductItem({
//     required this.id,
//     required this.name,
//     required this.code,
//     required this.description,
//     required this.categoryId,
//     required this.brandId,
//     required this.cost,
//     required this.margin,
//     required this.sellingPrice,
//     required this.discount,
//     required this.currency,
//     this.thumbnail,
//     this.brand,
//     this.category,
//     required this.attributes,
//     required this.variants,
//     required this.rating,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory ProductItem.fromJson(Map<String, dynamic> json) {
//     return ProductItem(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       code: json['code'] ?? '',
//       description: json['description'] ?? '',
//       categoryId: json['categoryId'] ?? '',
//       brandId: json['brandId'] ?? '',
//       cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
//       margin: (json['margin'] as num?)?.toDouble() ?? 0.0,
//       sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
//       discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
//       currency: json['currency'] ?? '',
//       thumbnail: json['thumbnail'],
//       brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
//       category:
//           json['category'] != null ? Category.fromJson(json['category']) : null,
//       attributes: (json['attributes'] as List<dynamic>?)
//               ?.map((e) => ProductAttribute.fromJson(e))
//               .toList() ??
//           [],
//       variants: (json['variants'] as List<dynamic>?)
//               ?.map((e) => ProductVariant.fromJson(e))
//               .toList() ??
//           [],
//       rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'code': code,
//         'description': description,
//         'categoryId': categoryId,
//         'brandId': brandId,
//         'cost': cost,
//         'margin': margin,
//         'sellingPrice': sellingPrice,
//         'discount': discount,
//         'currency': currency,
//         'thumbnail': thumbnail,
//         'brand': brand?.toJson(),
//         'category': category?.toJson(),
//         'attributes': attributes.map((e) => e.toJson()).toList(),
//         'variants': variants.map((e) => e.toJson()).toList(),
//         'rating': rating,
//         'createdAt': createdAt,
//         'updatedAt': updatedAt,
//       };
// }
// product_item.dart
import 'package:demoecommerceproduct/models/category_model.dart';
import 'package:isar/isar.dart';
import 'product_brand_model.dart';
import 'product_attribute_model.dart';
import 'product_variant_model.dart';

part 'product_model.g.dart';

@collection
class ProductItem {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String name;
  late String code;
  late String description;
  late String categoryId;
  late String brandId;
  late double cost;
  late double margin;
  late double sellingPrice;
  late double discount;
  late String currency;

  String? thumbnail;
  bool? isFavorite;
  late double rating;
  late String createdAt;
  late String updatedAt;

  // Relationships
  final brand = IsarLink<Brand>();
  final category = IsarLink<Category>();
  final attributes = IsarLinks<ProductAttribute>();
  final variants = IsarLinks<ProductVariant>();

  // Temporary storage for unsaved objects from JSON
  @ignore
  List<ProductAttribute>? _tempAttributes;
  @ignore
  List<ProductVariant>? _tempVariants;

  ProductItem({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.categoryId,
    required this.brandId,
    required this.cost,
    required this.margin,
    required this.sellingPrice,
    required this.discount,
    required this.currency,
    this.thumbnail,
    this.isFavorite,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  ProductItem.empty()
      : id = '',
        name = '',
        code = '',
        description = '',
        categoryId = '',
        brandId = '',
        cost = 0.0,
        margin = 0.0,
        sellingPrice = 0.0,
        discount = 0.0,
        currency = '',
        rating = 0.0,
        createdAt = '',
        updatedAt = '';

  // Getter and setter for temporary attributes
  @ignore
  List<ProductAttribute>? get tempAttributes => _tempAttributes;
  set tempAttributes(List<ProductAttribute>? value) => _tempAttributes = value;

  // Getter and setter for temporary variants
  @ignore
  List<ProductVariant>? get tempVariants => _tempVariants;
  set tempVariants(List<ProductVariant>? value) => _tempVariants = value;

  // Helper method to get all variants (from database or temporary)
  @ignore
  List<ProductVariant> get allVariants {
    // If tempVariants exist (from API), use those
    if (_tempVariants != null && _tempVariants!.isNotEmpty) {
      return _tempVariants!;
    }
    // Otherwise use variants from database
    return variants.toList();
  }

  // Helper method to get all attributes (from database or temporary)
  @ignore
  List<ProductAttribute> get allAttributes {
    // If tempAttributes exist (from API), use those
    if (_tempAttributes != null && _tempAttributes!.isNotEmpty) {
      return _tempAttributes!;
    }
    // Otherwise use attributes from database
    return attributes.toList();
  }

  factory ProductItem.fromJson(Map<String, dynamic> jso, bool isFavorite) {
    var json;
    isFavorite ? json = jso['product'] : json = jso;

    final product = ProductItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? '',
      brandId: json['brandId'] ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      margin: (json['margin'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      thumbnail: json['thumbnail'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );

    // Handle relationships
    if (json['brand'] != null) {
      product.brand.value = Brand.fromJson(json['brand']);
    }
    if (json['category'] != null) {
      product.category.value = Category.fromJson(json['category']);
    }

    // Store attributes temporarily (don't add to IsarLinks yet)
    if (json['attributes'] != null) {
      product.tempAttributes = (json['attributes'] as List<dynamic>)
          .map((e) => ProductAttribute.fromJson(e))
          .toList();
    }

    // Store variants temporarily (don't add to IsarLinks yet)
    if (json['variants'] != null) {
      product.tempVariants = (json['variants'] as List<dynamic>)
          .map((e) => ProductVariant.fromJson(e))
          .toList();
    }

    return product;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'description': description,
        'categoryId': categoryId,
        'brandId': brandId,
        'cost': cost,
        'margin': margin,
        'sellingPrice': sellingPrice,
        'discount': discount,
        'currency': currency,
        'thumbnail': thumbnail,
        'brand': brand.value?.toJson(),
        'category': category.value?.toJson(),
        'attributes': attributes.map((e) => e.toJson()).toList(),
        'variants': variants.map((e) => e.toJson()).toList(),
        'rating': rating,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
