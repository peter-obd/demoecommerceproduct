import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
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
      String? variantId,
      BuildContext context,
      {String? variantImage}) async {
    isLoading.value = true;
    await BasketService.instance
        .addToBasket(CheckoutProduct(
      productId: productid,
      name: productName,
      price: productCost,
      imageUrl: variantImage ?? productThumbnail ?? "",
      quantity: 1,
      variantId: variantId,
    ))
        .then((onValue) {
      isLoading.value = false;
      Utils.showFlushbarSuccess(context, "Item added to Basket");
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
