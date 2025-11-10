import 'package:demoecommerceproduct/screens/home_screen.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/widgets/add_to_basket_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  var images = [
    "assets/images/MaskGroup.png",
    "assets/images/MaskGroup.png",
    "assets/images/MaskGroup.png",
    "assets/images/MaskGroup.png",
    "assets/images/MaskGroup.png",
  ].obs;
  RxBool isFavorite = false.obs;
  RxBool isLoading = false.obs;

  void addToBasket(
      String productName,
      double productCost,
      String? productThumbnail,
      String productid,
      int stock,
      String? variantId,
      BuildContext context,
      {String? variantImage}) async {
    isLoading.value = true;
    await BasketService.instance
        .addToBasket(CheckoutProduct(
      productId: productid,
      name: productName,
      price: productCost,
      stock: stock,
      imageUrl: variantImage ?? productThumbnail ?? "",
      quantity: 1,
      variantId: variantId,
    ))
        .then((onValue) {
      isLoading.value = false;

      // Show add to basket dialog
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return AddToBasketDialog(
              onViewBasket: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                // Navigate to home screen with basket tab selected (index 2)
                Get.off(
                  () => const HomeScreen(),
                  transition: Transition.noTransition,
                  arguments: {
                    'initialIndex': 3
                  }, // Pass initial index for basket
                );
              },
              onBack: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
            );
          },
        );
      }
    });
  }

  // void addProductToFavorites(ProductItem product, String userId,
  //     String productId, BuildContext context) {
  //   isFavorite.value = true;
  //   ApisService.addToFavorites(productId, userId, (success) {
  //     product.isFavorite = success;
  //     isFavorite.value = success;
  //     update();
  //   }, (fail) {
  //     isFavorite.value = false;
  //     Utils.showFlushbarError(context, "could not add Item to Favorites");
  //   });
  // }
}
