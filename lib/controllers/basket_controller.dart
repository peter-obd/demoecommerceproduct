import 'package:demoecommerceproduct/models/on_checkout_order_product_model.dart';
import 'package:demoecommerceproduct/screens/home_screen.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/widgets/order_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasketController extends GetxController {
  var products = <CheckoutProduct>[].obs;
  RxBool isLoading = false.obs;
  RxString addressId = "".obs;
  var total;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCheckoutProducts();
  }

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
    ApisService.checkoutOrder("", addressId.value, onCheckoutOrderProducts,
        (success) {
      isLoading.value = false;
      products.clear();
      BasketService.instance.clearBasket();

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissal by tapping outside
        builder: (BuildContext context) {
          return OrderSuccessDialog(
            onOkPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Get.offAll(HomeScreen()); // Navigate to home
            },
          );
        },
      );
    }, (fail) {
      isLoading.value = false;
      Utils.showFlushbarError(context, fail.message);
    });
  }

  void increaseQuantity(CheckoutProduct product) async {
    if (product.stock! > product.quantity) {
      await BasketService.instance.updateQuantity(
          product.productId, product.quantity + 1,
          variantId: product.variantId);
      getCheckoutProducts();
    } else {
      Utils.showFlushbarError(
          Get.context!, "There is no more then ${product.stock} in stock");
    }
  }

  void decreaseQuantity(CheckoutProduct product) async {
    await BasketService.instance.updateQuantity(
        product.productId, product.quantity - 1,
        variantId: product.variantId);
    getCheckoutProducts();
  }
}
