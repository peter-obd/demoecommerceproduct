// Search Controller
import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/product_model.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:get/get.dart';

class SearchControllerr extends GetxController {
  final RxString searchQuery = ''.obs;
  final HomeController homeController = Get.put(HomeController());
  final RxList<ProductItem> filteredProducts = <ProductItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool noItemFound = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasNextPage = false.obs;
  final RxInt currentPage = 1.obs;
  final int pageSize = 7;
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
    // Reset pagination state for new search
    currentPage.value = 1;
    filteredProducts.value = [];
    noItemFound.value = false;
    hasNextPage.value = false;

    isLoading.value = true;
    ApisService.searchProduct(searchText, currentPage.value, pageSize,
        (success) async {
      isLoading.value = false;

      if (success.items.isEmpty) {
        noItemFound.value = true;
      } else {
        await IsarService.instance.saveMultipleProductsUpsert(success.items);
        filteredProducts.value = success.items;
        hasNextPage.value = success.hasNextPage;
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

  void loadMoreProducts() {
    if (isLoadingMore.value || !hasNextPage.value) {
      return;
    }

    isLoadingMore.value = true;
    currentPage.value++;

    ApisService.searchProduct(searchQuery.value, currentPage.value, pageSize,
        (success) async {
      isLoadingMore.value = false;

      if (success.items.isNotEmpty) {
        await IsarService.instance.saveMultipleProductsUpsert(success.items);
        filteredProducts.addAll(success.items);
        hasNextPage.value = success.hasNextPage;
      } else {
        hasNextPage.value = false;
      }
    }, (fail) {
      isLoadingMore.value = false;
      // Keep the current page on failure
      currentPage.value--;
    });
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
