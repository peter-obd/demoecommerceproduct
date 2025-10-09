// product_service.dart
import 'package:demoecommerceproduct/models/category_model.dart';
import 'package:demoecommerceproduct/models/product/product_attribute_model.dart';
import 'package:demoecommerceproduct/models/product/product_brand_model.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/product/product_variant_model.dart';
import 'package:demoecommerceproduct/models/user.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static IsarService? _instance;
  static Isar? _isar;

  IsarService._();

  static IsarService get instance {
    _instance ??= IsarService._();
    return _instance!;
  }

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        ProductItemSchema,
        BrandSchema,
        CategorySchema,
        ProductAttributeSchema,
        ProductVariantSchema,
        CheckoutProductSchema,
        UserSchema
      ],
      directory: dir.path,
      name: 'ecommerce_db',
    );

    return _isar!;
  }

  // ========================================
  // SAVE PRODUCT WITH ALL RELATIONSHIPS
  // ========================================
  Future<void> saveProductWithRelations(ProductItem product) async {
    final db = await isar;

    await db.writeTxn(() async {
      // 1. Save Brand first (if exists)
      if (product.brand.value != null) {
        await db.brands.put(product.brand.value!);
      }

      // 2. Save Category first (if exists)
      if (product.category.value != null) {
        await db.categorys.put(product.category.value!);
      }

      // 3. Save all Attributes from temp storage and add to links
      if (product.tempAttributes != null &&
          product.tempAttributes!.isNotEmpty) {
        for (final attribute in product.tempAttributes!) {
          await db.productAttributes.put(attribute);
        }
        product.attributes.addAll(product.tempAttributes!);
        product.tempAttributes = null; // Clear temp storage
      }

      // 4. Save all Variants from temp storage and add to links
      if (product.tempVariants != null && product.tempVariants!.isNotEmpty) {
        for (final variant in product.tempVariants!) {
          await db.productVariants.put(variant);
        }
        product.variants.addAll(product.tempVariants!);
        product.tempVariants = null; // Clear temp storage
      }

      // 5. Save the main Product
      await db.productItems.put(product);

      // 6. Save all relationships
      await product.brand.save();
      await product.category.save();
      await product.attributes.save();
      await product.variants.save();
    });
  }

  Future<void> saveUser(User user) async {
    final db = await isar;

    await db.writeTxn(() async {
      // Clear existing user data first (since we only want one user at a time)
      await db.users.clear();
      // Save the new user
      await db.users.put(user);
    });
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    final db = await isar;
    return await db.users.where().findFirst();
  }

  // Update user token
  Future<void> updateUserToken(String newToken) async {
    final user = await getCurrentUser();
    if (user == null) return;

    user.token = newToken;

    final db = await isar;
    await db.writeTxn(() async {
      await db.users.put(user);
    });
  }

  // Check if user is logged in and token is not expired
  Future<bool> isUserLoggedIn() async {
    final user = await getCurrentUser();
    if (user == null) return false;

    // Check if token is still valid
    return DateTime.now().isBefore(user.expiresAt);
  }

  // Get user token if valid
  Future<String?> getValidToken() async {
    final user = await getCurrentUser();
    if (user == null) return null;

    // Check if token is still valid
    if (DateTime.now().isBefore(user.expiresAt)) {
      return user.token;
    }

    return null;
  }

  // Clear user data (logout)
  Future<void> clearUser() async {
    final db = await isar;

    await db.writeTxn(() async {
      await db.users.clear();
    });
  }

  // Update user information
  Future<void> updateUser(User updatedUser) async {
    final db = await isar;

    await db.writeTxn(() async {
      await db.users.put(updatedUser);
    });
  }

  // Get user by userId
  Future<User?> getUserById(String userId) async {
    final db = await isar;
    return await db.users.filter().userIdEqualTo(userId).findFirst();
  }

  // Check if token is about to expire (within next hour)
  Future<bool> isTokenNearExpiry() async {
    final user = await getCurrentUser();
    if (user == null) return true;

    final oneHourFromNow = DateTime.now().add(const Duration(hours: 1));
    return user.expiresAt.isBefore(oneHourFromNow);
  }

  // Get user as stream for real-time updates
  Stream<User?> watchCurrentUser() async* {
    final db = await isar;
    yield* db.users
        .where()
        .watch(fireImmediately: true)
        .map((users) => users.isEmpty ? null : users.first);
  }

  // ========================================
  // CLEAR ALL DATABASE DATA
  // ========================================
  Future<void> clearDatabase() async {
    final db = await isar;

    await db.writeTxn(() async {
      await db.productItems.clear();
      await db.productAttributes.clear();
      await db.productVariants.clear();
      await db.brands.clear();
      await db.categorys.clear();
    });
  }

  // ========================================
  // SAVE MULTIPLE CATEGORIES
  // ========================================
  Future<void> saveMultipleCategories(List<Category> categories) async {
    final db = await isar;

    await db.writeTxn(() async {
      // Clear categories first within the same transaction
      await db.categorys.clear();

      // Then save new categories
      for (final category in categories) {
        await db.categorys.put(category);
      }
    });
  }

  Future<List<Category>> getCategories() async {
    final db = await isar;

    final categories = await db.categorys.where().findAll();

    return categories;
  }

  Future<void> clearCategoriesDatabase() async {
    final db = await isar;

    await db.writeTxn(() async {
      await db.categorys.clear();
    });
  }

  // ========================================
  // GET PRODUCT BY PRODUCT ID AND UPDATE ITS ISFAVORITE
  // ========================================
  Future<void> updateProductIsFavoriteById(
      String productId, bool isFavorite) async {
    final db = await isar;

    final product =
        await db.productItems.filter().idEqualTo(productId).findFirst();

    if (product != null) {
      product.isFavorite = isFavorite;

      await db.writeTxn(() async {
        await db.productItems.put(product);
      });
    }
  }

  // ========================================
  // SAVE MULTIPLE PRODUCTS WITH RELATIONSHIPS (UPSERT MODE)
  // ========================================
  Future<void> saveMultipleProductsUpsert(List<ProductItem> products) async {
    final db = await isar;

    await db.writeTxn(() async {
      for (var product in products) {
        // Save Brand with upsert
        if (product.brand.value != null) {
          final existingBrand = await db.brands
              .filter()
              .idEqualTo(product.brand.value!.id)
              .findFirst();
          if (existingBrand == null) {
            await db.brands.put(product.brand.value!);
          } else {
            product.brand.value = existingBrand;
          }
        }

        // Save Category with upsert
        if (product.category.value != null) {
          final existingCategory = await db.categorys
              .filter()
              .idEqualTo(product.category.value!.id)
              .findFirst();
          if (existingCategory == null) {
            await db.categorys.put(product.category.value!);
          } else {
            product.category.value = existingCategory;
          }
        }

        // Save Attributes from temp storage and add to links
        if (product.tempAttributes != null &&
            product.tempAttributes!.isNotEmpty) {
          for (final attr in product.tempAttributes!) {
            // Attributes don't have unique constraints, so we can safely put them
            await db.productAttributes.put(attr);
            product.attributes.add(attr);
          }
          product.tempAttributes = null;
        }

        // Save Variants from temp storage and add to links with upsert
        if (product.tempVariants != null && product.tempVariants!.isNotEmpty) {
          for (final variant in product.tempVariants!) {
            final existingVariant = await db.productVariants
                .filter()
                .idEqualTo(variant.id)
                .findFirst();
            if (existingVariant == null) {
              await db.productVariants.put(variant);
              product.variants.add(variant);
            } else {
              product.variants.add(existingVariant);
            }
          }
          product.tempVariants = null;
        }

        // Save Product with upsert
        final existingProduct =
            await db.productItems.filter().idEqualTo(product.id).findFirst();
        if (existingProduct == null) {
          await db.productItems.put(product);
        } else {
          // Update existing product fields
          existingProduct.name = product.name;
          existingProduct.code = product.code;
          existingProduct.description = product.description;
          existingProduct.categoryId = product.categoryId;
          existingProduct.brandId = product.brandId;
          existingProduct.cost = product.cost;
          existingProduct.margin = product.margin;
          existingProduct.sellingPrice = product.sellingPrice;
          existingProduct.discount = product.discount;
          existingProduct.currency = product.currency;
          existingProduct.thumbnail = product.thumbnail;
          existingProduct.rating = product.rating;
          existingProduct.updatedAt = product.updatedAt;

          // Update relationships
          existingProduct.brand.value = product.brand.value;
          existingProduct.category.value = product.category.value;

          // Clear existing links and add new ones
          existingProduct.attributes.clear();
          existingProduct.variants.clear();
          existingProduct.attributes.addAll(product.attributes);
          existingProduct.variants.addAll(product.variants);

          await db.productItems.put(existingProduct);

          // Use existing product for relationship saving
          product = existingProduct;
        }

        // Save links AFTER put()
        await product.brand.save();
        await product.category.save();
        await product.attributes.save();
        await product.variants.save();
      }
    });
  }

  // ========================================
  // SAVE MULTIPLE PRODUCTS WITH RELATIONSHIPS (CLEAR FIRST)
  // ========================================
  Future<void> saveMultipleProducts(List<ProductItem> products,
      {bool clearFirst = true}) async {
    final db = await isar;

    if (clearFirst) {
      await clearDatabase();
    }

    await db.writeTxn(() async {
      for (final product in products) {
        // Save Brand
        if (product.brand.value != null) {
          await db.brands.put(product.brand.value!);
        }

        // Save Category
        if (product.category.value != null) {
          await db.categorys.put(product.category.value!);
        }

        // Save Attributes from temp storage and add to links
        if (product.tempAttributes != null &&
            product.tempAttributes!.isNotEmpty) {
          for (final attr in product.tempAttributes!) {
            await db.productAttributes.put(attr);
          }
          product.attributes.addAll(product.tempAttributes!);
          product.tempAttributes = null; // Clear temp storage
        }

        // Save Variants from temp storage and add to links
        if (product.tempVariants != null && product.tempVariants!.isNotEmpty) {
          for (final variant in product.tempVariants!) {
            await db.productVariants.put(variant);
          }
          product.variants.addAll(product.tempVariants!);
          product.tempVariants = null; // Clear temp storage
        }

        // Save Product
        await db.productItems.put(product);

        // Save links AFTER put()
        await product.brand.save();
        await product.category.save();
        await product.attributes.save();
        await product.variants.save();
      }
    });
  }

  // Future<void> saveMultipleProducts(List<ProductItem> products) async {
  //   final db = await isar;

  //   await db.writeTxn(() async {
  //     for (final product in products) {
  //       // Save Brand
  //       if (product.brand.value != null) {
  //         await db.brands.put(product.brand.value!);
  //       }

  //       // Save Category
  //       if (product.category.value != null) {
  //         await db.categorys.put(product.category.value!);
  //       }

  //       // Save Attributes
  //       for (final attribute in product.attributes) {
  //         await db.productAttributes.put(attribute);
  //       }

  //       // Save Variants
  //       for (final variant in product.variants) {
  //         await db.productVariants.put(variant);
  //       }

  //       // Save Product
  //       await db.productItems.put(product);

  //       // Save relationships
  //       await product.brand.save();
  //       await product.category.save();
  //       await product.attributes.save();
  //       await product.variants.save();
  //     }
  //   });
  // }

  // ========================================
  // GET PRODUCT WITH ALL RELATIONSHIPS
  // ========================================
  Future<ProductItem?> getProductWithAllRelations(String productId) async {
    final db = await isar;

    final product =
        await db.productItems.filter().idEqualTo(productId).findFirst();

    if (product != null) {
      // Load all relationships
      await product.brand.load();
      await product.category.load();
      await product.attributes.load();
      await product.variants.load();
    }

    return product;
  }

  // ========================================
  // GET ALL PRODUCTS WITH RELATIONSHIPS
  // ========================================
  Future<List<ProductItem>> getAllProductsWithRelations() async {
    final db = await isar;

    final products = await db.productItems.where().findAll();

    // Load relationships for all products
    for (final product in products) {
      await product.brand.load();
      await product.category.load();
      await product.attributes.load();
      await product.variants.load();
    }

    return products;
  }

  // ========================================
  // SAVE FROM JSON WITH AUTOMATIC RELATIONSHIP SETUP
  // ========================================
  Future<void> saveProductFromJson(Map<String, dynamic> json) async {
    final product = ProductItem.fromJson(json, false);

    // The relationships are already set up in ProductItem.fromJson()
    // Now we just need to save everything
    await saveProductWithRelations(product);
  }

  // ========================================
  // SAVE MULTIPLE FROM JSON
  // ========================================
  Future<void> saveMultipleProductsFromJson(
      List<Map<String, dynamic>> jsonList) async {
    final products =
        jsonList.map((json) => ProductItem.fromJson(json, false)).toList();
    await saveMultipleProducts(products);
  }

  // ========================================
  // SEARCH PRODUCTS WITH RELATIONSHIPS
  // ========================================
  Future<List<ProductItem>> searchProductsWithRelations(String query) async {
    final db = await isar;

    final products = await db.productItems
        .filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .descriptionContains(query, caseSensitive: false)
        .findAll();

    // Load relationships
    for (final product in products) {
      await product.brand.load();
      await product.category.load();
      await product.attributes.load();
      await product.variants.load();
    }

    return products;
  }

  // ========================================
  // GET PRODUCTS BY CATEGORY WITH RELATIONSHIPS
  // ========================================
  Future<List<ProductItem>> getProductsByCategoryWithRelations(
      String categoryId) async {
    final db = await isar;

    final products =
        await db.productItems.filter().categoryIdEqualTo(categoryId).findAll();

    // Load relationships
    for (final product in products) {
      await product.brand.load();
      await product.category.load();
      await product.attributes.load();
      await product.variants.load();
    }

    return products;
  }

  // ========================================
  // GET PRODUCTS BY BRAND WITH RELATIONSHIPS
  // ========================================
  Future<List<ProductItem>> getProductsByBrandWithRelations(
      String brandId) async {
    final db = await isar;

    final products =
        await db.productItems.filter().brandIdEqualTo(brandId).findAll();

    // Load relationships
    for (final product in products) {
      await product.brand.load();
      await product.category.load();
      await product.attributes.load();
      await product.variants.load();
    }

    return products;
  }

  // ========================================
  // DELETE PRODUCT AND ALL RELATED DATA
  // ========================================
  Future<void> deleteProductWithRelations(String productId) async {
    final db = await isar;

    await db.writeTxn(() async {
      final product =
          await db.productItems.filter().idEqualTo(productId).findFirst();

      if (product != null) {
        // Load relationships to delete them
        await product.attributes.load();
        await product.variants.load();

        // Delete all attributes
        for (final attribute in product.attributes) {
          await db.productAttributes.delete(attribute.isarId);
        }

        // Delete all variants
        for (final variant in product.variants) {
          await db.productVariants.delete(variant.isarId);
        }

        // Delete the product itself
        await db.productItems.delete(product.isarId);

        // Note: We don't delete Brand and Category as they might be used by other products
      }
    });
  }

  // ========================================
  // HELPER: GET PRODUCT VARIANT ATTRIBUTES
  // ========================================
  Map<String, dynamic> getVariantAttributes(ProductVariant variant) {
    return variant.getAttributesValues();
  }

  // ========================================
  // HELPER: UPDATE VARIANT ATTRIBUTES
  // ========================================
  Future<void> updateVariantAttributes(
      ProductVariant variant, Map<String, dynamic> newAttributes) async {
    final db = await isar;

    variant.setAttributesValues(newAttributes);

    await db.writeTxn(() async {
      await db.productVariants.put(variant);
    });
  }
}

// ========================================
// USAGE EXAMPLE
// ========================================
// class ProductUsageExample {
//   final ProductService _service = ProductService.instance;

//   // Example: Save a complete product from JSON
//   Future<void> saveCompleteProduct() async {
//     final productJson = {
//       'id': 'prod_123',
//       'name': 'Sample Product',
//       'code': 'SP001',
//       'description': 'A sample product',
//       'categoryId': 'cat_1',
//       'brandId': 'brand_1',
//       'cost': 10.0,
//       'margin': 5.0,
//       'sellingPrice': 15.0,
//       'discount': 2.0,
//       'currency': 'USD',
//       'thumbnail': 'https://example.com/thumb.jpg',
//       'rating': 4.5,
//       'createdAt': '2024-01-01T00:00:00Z',
//       'updatedAt': '2024-01-01T00:00:00Z',
//       'brand': {
//         'id': 'brand_1',
//         'name': 'Sample Brand',
//         'abbreviation': 'SB',
//         'slogan': 'Quality First',
//         'logoUrl': 'https://example.com/logo.jpg',
//         'description': 'A trusted brand',
//         'createdAt': '2024-01-01T00:00:00Z',
//         'updatedAt': '2024-01-01T00:00:00Z',
//       },
//       'category': {
//         'id': 'cat_1',
//         'name': 'Electronics',
//         'abbreviation': 'ELEC',
//         'iconUrl': 'https://example.com/icon.jpg',
//         'createdAt': '2024-01-01T00:00:00Z',
//         'updatedAt': '2024-01-01T00:00:00Z',
//       },
//       'attributes': [
//         {
//           'basicDataCategoryName': 'Colors',
//           'isProductVariant': true,
//           'values': ['Red', 'Blue', 'Green'],
//         },
//         {
//           'basicDataCategoryName': 'Size',
//           'isProductVariant': true,
//           'values': ['S', 'M', 'L', 'XL'],
//         }
//       ],
//       'variants': [
//         {
//           'id': 'var_1',
//           'sku': 'SP001-RED-M',
//           'discount': 5,
//           'stock': 100,
//           'images': ['https://example.com/red_m.jpg'],
//           'attributesValues': {'Colors': 'Red', 'Size': 'M'},
//         },
//         {
//           'id': 'var_2',
//           'sku': 'SP001-BLUE-L',
//           'discount': 3,
//           'stock': 50,
//           'images': ['https://example.com/blue_l.jpg'],
//           'attributesValues': {'Colors': 'Blue', 'Size': 'L'},
//         }
//       ],
//     };

//     // Save the complete product with all relationships
//     await _service.saveProductFromJson(productJson);
//     print('Product saved successfully!');
//   }

//   // Example: Get and use product with all relationships
//   Future<void> getAndUseProduct() async {
//     final product = await _service.getProductWithAllRelations('prod_123');

//     if (product != null) {
//       print('Product: ${product.name}');
//       print('Brand: ${product.brand.value?.name}');
//       print('Category: ${product.category.value?.name}');
//       print('Attributes count: ${product.attributes.length}');
//       print('Variants count: ${product.variants.length}');

//       // Work with variants
//       for (final variant in product.variants) {
//         final attributes = variant.getAttributesValues();
//         print(
//             'Variant ${variant.sku}: Color=${attributes['Colors']}, Size=${attributes['Size']}');
//       }
//     }
//   }

//   // Example: Search and filter
//   Future<void> searchExample() async {
//     // Search products
//     final searchResults = await _service.searchProductsWithRelations('Sample');
//     print('Search results: ${searchResults.length}');

//     // Get by category
//     final categoryProducts =
//         await _service.getProductsByCategoryWithRelations('cat_1');
//     print('Category products: ${categoryProducts.length}');

//     // Get by brand
//     final brandProducts =
//         await _service.getProductsByBrandWithRelations('brand_1');
//     print('Brand products: ${brandProducts.length}');
//   }
// }
