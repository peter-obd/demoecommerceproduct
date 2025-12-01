import 'package:demoecommerceproduct/models/on_checkout_order_product_model.dart';
import 'package:demoecommerceproduct/screens/home_screen.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/widgets/loading_widget.dart';
import 'package:demoecommerceproduct/widgets/order_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasketController extends GetxController {
  var products = <CheckoutProduct>[].obs;
  RxBool isLoading = false.obs;
  RxString addressId = "".obs;
  RxDouble total = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCheckoutProducts();
  }

  void getCheckoutProducts() async {
    products.value = await BasketService.instance.getBasketProducts();
    total.value = await BasketService.instance.getBasketTotal();
    update();
  }

  void removeAllProducts() async {
    await BasketService.instance.clearBasket();
    getCheckoutProducts();
  }

  void productTapped(CheckoutProduct product) async {
    // Show loading indicator
    FullScreenLoader.show();

    // Fetch product details from API
    ApisService.getProductByProductId(
      product.productId,
      (productData) {
        // Hide loading indicator
        FullScreenLoader.hide();

        // Navigate to ProductDetailsScreen with the specific variant
        Get.to(() => ProductDetailsScreen(
              product: productData,
              variantId: product.variantId,
            ));
      },
      (error) {
        // Hide loading indicator
        FullScreenLoader.hide();

        // Show error message
        if (Get.context != null) {
          Utils.showFlushbarError(Get.context!, error.message);
        }
      },
    );
  }

  void removeProduct(CheckoutProduct product) async {
    await BasketService.instance
        .removeFromBasket(product.productId, variantId: product.variantId);
    getCheckoutProducts();
  }

  void checkoutOrder(BuildContext context) async {
    // isLoading.value = true;
    FullScreenLoader.show();
    List<OnCheckoutOrderProductModel> onCheckoutOrderProducts = [];
    for (var product in products) {
      onCheckoutOrderProducts.add(OnCheckoutOrderProductModel(
          productId: product.productId,
          quantity: product.quantity,
          variantId: product.variantId));
    }
    ApisService.checkoutOrder("", addressId.value, onCheckoutOrderProducts,
        (success) {
      products.clear();
      BasketService.instance.clearBasket();

      // Show success dialog
      FullScreenLoader.hide();
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
      FullScreenLoader.hide();
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
      FullScreenLoader.show();
      ApisService.getProductByProductId(
        product.productId,
        (productData) async {
          // Hide loading indicator

          var variants = productData.allVariants;
          for (var variant in variants) {
            if (variant.id == product.variantId) {
              if (variant.stock > product.quantity) {
                FullScreenLoader.hide();
                await BasketService.instance.updateQuantity(
                    product.productId, product.quantity + 1,
                    variantId: product.variantId);
                getCheckoutProducts();
              } else {
                FullScreenLoader.hide();
                Utils.showFlushbarError(Get.context!,
                    "There is no more then ${variant.stock} in stock");
              }
              return;
            } else {
              FullScreenLoader.hide();
              Utils.showFlushbarError(Get.context!, "variant not found");
              return;
            }
          }
        },
        (error) {
          // Hide loading indicator
          FullScreenLoader.hide();

          // Show error message
          if (Get.context != null) {
            Utils.showFlushbarError(Get.context!, error.message);
          }
        },
      );
      // Utils.showFlushbarError(
      //     Get.context!, "There is no more then ${product.stock} in stock");
    }
  }

  void decreaseQuantity(CheckoutProduct product) async {
    await BasketService.instance.updateQuantity(
        product.productId, product.quantity - 1,
        variantId: product.variantId);
    getCheckoutProducts();
  }
}
