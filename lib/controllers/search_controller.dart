// Search Controller
import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/product_model.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:get/get.dart';

class SearchControllerr extends GetxController {
  final RxString searchQuery = ''.obs;
  final HomeController homeController = Get.put(HomeController());
  final RxList<ProductItem> filteredProducts = <ProductItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool noItemFound = false.obs;
  @override
  void onInit() {
    super.onInit();
    // loadProducts();
    // ever(searchQuery, (_) => filterProducts());
  }

  // void openProductDetails(Product product) {
  //   Get.to(ProductDetailsScreen(
  //     product: product,
  //   ));
  // }

  void searchProducts(String searchText) {
    isLoading.value = true;
    ApisService.searchProduct(searchText, (success) {
      isLoading.value = false;
      filteredProducts.value = [];
      filteredProducts.value = success;
      if (filteredProducts.isEmpty) {
        noItemFound.value = true;
      }
    }, (fail) {
      filteredProducts.value = [];
      noItemFound.value = true;
      isLoading.value = false;
    });
    // Mock data - replace with your actual data source
    // allProducts.value = [
    //   Product(
    //     id: '1',
    //     name: 'Apple iPad Air',
    //     price: 'From £579',
    //     image: 'assets/images/ipad_air.png',
    //     category: 'tablet',
    //   ),
    //   Product(
    //     id: '2',
    //     name: 'Apple Watch',
    //     price: 'From £139',
    //     image: 'assets/images/apple_watch.png',
    //     category: 'watch',
    //   ),
    //   Product(
    //     id: '3',
    //     name: 'Apple MacBook',
    //     price: 'From £879',
    //     image: 'assets/images/macbook.png',
    //     category: 'laptop',
    //   ),
    //   Product(
    //     id: '4',
    //     name: 'Apple iPhone',
    //     price: 'From £879',
    //     image: 'assets/images/iphone.png',
    //     category: 'phone',
    //   ),
    //   Product(
    //     id: '5',
    //     name: 'Apple AirPods',
    //     price: 'From £129',
    //     image: 'assets/images/airpods.png',
    //     category: 'audio',
    //   ),
    //   Product(
    //     id: '6',
    //     name: 'Apple TV',
    //     price: 'From £149',
    //     image: 'assets/images/apple_tv.png',
    //     category: 'entertainment',
    //   ),
    // ];

    // Initially show all products
    // filteredProducts.value = homeController.allProducts;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void filterProducts() {
    if (searchQuery.value.isEmpty) {
      filteredProducts.value = homeController.allProducts;
    } else {
      filteredProducts.value = homeController.allProducts
          .where((product) =>
              product.name
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              product.categoryId
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }
}
