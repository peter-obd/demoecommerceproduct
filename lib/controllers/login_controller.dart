import 'package:demoecommerceproduct/models/category_model.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/screens/home_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  var selectedCategoryId = 'Shoes'.obs;
  var categories = <Category>[].obs;

  var productsOfCategory = <ProductItem>[].obs;

  void getCategories(BuildContext context) {
    IsarService.instance.clearDatabase();
    ApisService.getAllCategories((success) {
      categories.value = success;
      selectedCategoryId.value = categories[0].id;

      getProductsByCategory(categories[0].id, "6", "1", context);
    }, (fail) {
      isLoading.value = false;
    });
  }

  void getProductsByCategory(String categoryId, String pageSize,
      String pageNumebr, BuildContext context) {
    selectedCategoryId.value = categoryId;

    for (int i = 0; i < categories.length; i++) {
      if (categories[i].id == categoryId) {
        categories[i] = Category(
          id: categories[i].id,
          name: categories[i].name,
        );
      } else {
        categories[i] = Category(
          id: categories[i].id,
          name: categories[i].name,
        );
      }
    }
    categories.refresh();

    ApisService.getProductByCategoryId(categoryId, pageSize, false, pageNumebr,
        (res) {
      productsOfCategory.value = res.items;
      isLoading.value = false;
      Get.offAll(HomeScreen());
    }, (fail) {
      isLoading.value = false;
      Utils.showFlushbarError(context, "Please try again!!");
    });
  }

  bool isValidPassword(String password) {
    final hasMinLength = password.length >= 6;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));

    return hasMinLength && hasUppercase && hasNumber;
  }

  void login(String number, String password, BuildContext context) {
    isLoading.value = true;
    ApisService.loginUser(number, password, (success) {
      getCategories(context);
    }, (fail) {
      isLoading.value = false;
      Utils.showFlushbarError(context, fail.message);
    });
  }
}
