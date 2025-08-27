import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class BasketService {
  static BasketService? _instance;
  static Isar? _isar;

  BasketService._();

  static BasketService get instance {
    _instance ??= BasketService._();
    return _instance!;
  }

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [CheckoutProductSchema],
      directory: dir.path,
      name: 'basket_db',
    );

    return _isar!;
  }

  // Add product to basket
  Future<void> addToBasket(CheckoutProduct product) async {
    final db = await isar;
    
    await db.writeTxn(() async {
      // Check if product with same productId AND variantId already exists in basket
      final existingProduct = await db.checkoutProducts
          .filter()
          .productIdEqualTo(product.productId)
          .and()
          .variantIdEqualTo(product.variantId)
          .findFirst();

      if (existingProduct != null) {
        // Update quantity if exact same product+variant already exists
        existingProduct.quantity += product.quantity;
        existingProduct.updatedAt = DateTime.now();
        await db.checkoutProducts.put(existingProduct);
      } else {
        // Add new product+variant combination to basket
        await db.checkoutProducts.put(product);
      }
    });
  }

  // Remove product from basket (specific product+variant combination)
  Future<void> removeFromBasket(String productId, {String? variantId}) async {
    final db = await isar;
    
    await db.writeTxn(() async {
      final query = db.checkoutProducts
          .filter()
          .productIdEqualTo(productId);
      
      // Add variantId filter if provided
      final product = variantId != null 
          ? await query.and().variantIdEqualTo(variantId).findFirst()
          : await query.findFirst();
      
      if (product != null) {
        await db.checkoutProducts.delete(product.isarId);
      }
    });
  }

  // Update product quantity for specific product+variant combination
  Future<void> updateQuantity(String productId, int quantity, {String? variantId}) async {
    final db = await isar;
    
    await db.writeTxn(() async {
      final query = db.checkoutProducts
          .filter()
          .productIdEqualTo(productId);
      
      // Add variantId filter if provided
      final product = variantId != null 
          ? await query.and().variantIdEqualTo(variantId).findFirst()
          : await query.findFirst();
      
      if (product != null) {
        if (quantity <= 0) {
          // Remove product if quantity is 0 or less
          await db.checkoutProducts.delete(product.isarId);
        } else {
          product.quantity = quantity;
          product.updatedAt = DateTime.now();
          await db.checkoutProducts.put(product);
        }
      }
    });
  }

  // Get all products in basket
  Future<List<CheckoutProduct>> getBasketProducts() async {
    final db = await isar;
    return await db.checkoutProducts
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }

  // Get basket total amount
  Future<double> getBasketTotal() async {
    final products = await getBasketProducts();
    double total = 0.0;
    
    for (final product in products) {
      total += (product.price * product.quantity);
    }
    
    return total;
  }

  // Get basket items count
  Future<int> getBasketItemsCount() async {
    final db = await isar;
    return await db.checkoutProducts.count();
  }

  // Get total quantity of all items
  Future<int> getBasketTotalQuantity() async {
    final products = await getBasketProducts();
    int totalQuantity = 0;
    
    for (final product in products) {
      totalQuantity += product.quantity;
    }
    
    return totalQuantity;
  }

  // Clear entire basket
  Future<void> clearBasket() async {
    final db = await isar;
    
    await db.writeTxn(() async {
      await db.checkoutProducts.clear();
    });
  }

  // Check if product exists in basket
  Future<bool> isProductInBasket(String productId) async {
    final db = await isar;
    final product = await db.checkoutProducts
        .filter()
        .productIdEqualTo(productId)
        .findFirst();
    
    return product != null;
  }

  // Get specific product from basket
  Future<CheckoutProduct?> getBasketProduct(String productId) async {
    final db = await isar;
    return await db.checkoutProducts
        .filter()
        .productIdEqualTo(productId)
        .findFirst();
  }

  // Update entire product
  Future<void> updateProduct(CheckoutProduct product) async {
    final db = await isar;
    
    await db.writeTxn(() async {
      product.updatedAt = DateTime.now();
      await db.checkoutProducts.put(product);
    });
  }

  // Get basket products as stream for real-time updates
  Stream<List<CheckoutProduct>> watchBasketProducts() async* {
    final db = await isar;
    yield* db.checkoutProducts
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  // Get basket count as stream
  Stream<int> watchBasketCount() async* {
    final db = await isar;
    yield* db.checkoutProducts
        .watchLazy()
        .asyncMap((_) async => await db.checkoutProducts.count());
  }
}