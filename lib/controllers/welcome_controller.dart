import 'package:demoecommerceproduct/models/category_model.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/screens/login_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  RxBool isNavigated = false.obs;
  var selectedCategoryId = 'Shoes'.obs;
  var categories = <Category>[].obs;
  var allProducts = <ProductItem>[].obs;
  var productsOfCategory = <ProductItem>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getAllProducts();
    getCategories();
  }

  void getCategories() {
    isNavigated.value = false;
    IsarService.instance.clearDatabase();
    ApisService.getAllCategories((success) {
      categories.value = success;
      selectedCategoryId.value = categories[0].id;
      isNavigated.value = true;
      getProductsByCategory(categories[0].id, "6", "1");
    }, (fail) {});
  }

  void getProductsByCategory(
      String categoryId, String pageSize, String pageNumebr) {
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
    isNavigated.value = false;

    ApisService.getProductByCategoryId(categoryId, pageSize, false, pageNumebr,
        (res) {
      isNavigated.value = true;
      productsOfCategory.value = res.items;
    }, (fail) {
      isNavigated.value = true;
    });
  }

  void navigateToLoginScreen() {
    Get.offAll(const LoginScreen());
  }

  // void getAllProducts() {
  //   ApisService.getAllProducts((success) {
  //     isNavigated.value = true;
  //   }, (fail) {});
  // }
}
