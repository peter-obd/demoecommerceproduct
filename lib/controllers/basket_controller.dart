import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:get/get.dart';

class BasketController extends GetxController {
  var products = <CheckoutProduct>[].obs;
  var total;
  void getCheckoutProducts() async {
    products.value = await BasketService.instance.getBasketProducts();
    total = await BasketService.instance.getBasketTotal();
    update();
  }

  void removeAllProducts() async {
    await BasketService.instance.clearBasket();
    getCheckoutProducts();
  }

  void productTapped(CheckoutProduct product) async {
    await IsarService.instance
        .getProductWithAllRelations(product.productId)
        .then((onValue) {
      Get.to(ProductDetailsScreen(product: onValue!));
    });
  }

  void removeProduct(CheckoutProduct product) async {
    await BasketService.instance
        .removeFromBasket(product.productId, variantId: product.variantId);
    getCheckoutProducts();
  }

  void increaseQuantity(CheckoutProduct product) async {
    await BasketService.instance.updateQuantity(
        product.productId, product.quantity + 1,
        variantId: product.variantId);
    getCheckoutProducts();
  }

  void decreaseQuantity(CheckoutProduct product) async {
    await BasketService.instance.updateQuantity(
        product.productId, product.quantity - 1,
        variantId: product.variantId);
    getCheckoutProducts();
  }
}
