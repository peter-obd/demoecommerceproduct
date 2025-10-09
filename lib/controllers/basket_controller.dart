import 'package:demoecommerceproduct/models/on_checkout_order_product_model.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasketController extends GetxController {
  var products = <CheckoutProduct>[].obs;
  RxBool isLoading = false.obs;
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

  void checkoutOrder(BuildContext context) async {
    isLoading.value = true;
    List<OnCheckoutOrderProductModel> onCheckoutOrderProducts = [];
    for (var product in products) {
      onCheckoutOrderProducts.add(OnCheckoutOrderProductModel(
          productId: product.productId,
          quantity: product.quantity,
          variantId: product.variantId));
    }
    ApisService.checkoutOrder("", onCheckoutOrderProducts, (success) {
      isLoading.value = false;
      products.clear();
      Utils.showFlushbarSuccess(context, "Successfully ordered!!");
    }, (fail) {
      isLoading.value = false;
      Utils.showFlushbarError(context, fail.message);
    });
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
