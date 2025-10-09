import 'package:demoecommerceproduct/models/category_model.dart';
import 'package:demoecommerceproduct/models/product/product_data_model.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/product_model.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable variables
  var selectedCategoryId = 'Shoes'.obs;
  var categories = <Category>[].obs;
  var allProducts = <ProductItem>[].obs;
  var productsOfCategory = <ProductItem>[].obs;
  var forYouProducts = <ProductItem>[].obs;
  var isLoading = false.obs;
  var isForYouLoading = false.obs;
  var isForYouLoadingMore = false.obs;
  RxBool isForYouuLoadingg = false.obs;
  var favoriteProducts = <ProductItem>[].obs;
  var isFavoritesLoading = false.obs;
  var isFavoritesEmpty = false.obs;

  var pageNumber = 1.obs;
  var forYouPageNumber = 1.obs;

  @override
  void onInit() {
    super.onInit();
    // loadData();
    getCategoriesFromLocal();
    getForYouProducts();
  }

  void getFavoriteProducts() {
    isFavoritesLoading.value = true;
    ApisService.getAllFavoritesProducts((success) {
      isFavoritesLoading.value = false;
      favoriteProducts.value = success;
      isFavoritesEmpty.value = favoriteProducts.isEmpty;
    }, (fail) {
      isFavoritesLoading.value = false;
    });
  }

  void getCategoriesFromLocal() async {
    isLoading.value = true;

    // Try to get categories from local database first
    final localCategories = await IsarService.instance.getCategories();

    if (localCategories.isNotEmpty) {
      categories.value = localCategories;
      selectedCategoryId.value = categories[0].id;
      isLoading.value = false;
      getProductsByCategory(categories[0].id, "6", "1");
    } else {
      // If no local categories, fetch from API
      getCategoriesFromAPI();
    }
  }

  void getCategoriesFromAPI() {
    isLoading.value = true;
    ApisService.getAllCategories((success) {
      categories.value = success;
      selectedCategoryId.value = categories[0].id;
      isLoading.value = false;
      getProductsByCategory(categories[0].id, "6", "1");
    }, (fail) {
      isLoading.value = false;
    });
  }

  void getProductsByCategory(
      String categoryId, String pageSize, String pageNumebr) {
    selectedCategoryId.value = categoryId;
    pageNumber.value = 1;
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
    isLoading.value = true;
    loadProductsFromLocal(categoryId, pageSize, pageNumebr);
    // ApisService.getProductByCategoryId(categoryId, pageSize, pageNumebr, (res) {
    //   isLoading.value = false;
    //   productsOfCategory.value = res.items;
    // }, (fail) {
    //   isLoading.value = false;
    // });
  }

  void loadProductsFromLocal(
      String categoryId, String pageSize, String pageNumebr) async {
    productsOfCategory.value = await IsarService.instance
        .getProductsByCategoryWithRelations(categoryId);

    if (productsOfCategory.isNotEmpty) {
      isLoading.value = false;
      print("Loaded ${productsOfCategory.length} products from local database");
    } else {
      ApisService.getProductByCategoryId(
          categoryId, pageSize, false, pageNumebr, (res) {
        isLoading.value = false;
        productsOfCategory.value = res.items;
      }, (fail) {
        isLoading.value = false;
      });
      print("No products found locally for this category");
    }
  }

  RxBool callFunction = true.obs;
  RxBool isScrollLoading = false.obs;
  void loadMoreProducts(BuildContext context, String categoryId,
      String pageSize, String pageNumebr) {
    isScrollLoading.value = true;
    callFunction.value = false;
    ApisService.getProductByCategoryId(categoryId, pageSize, true, pageNumebr,
        (res) {
      if (res.items.isEmpty) {
        Utils.showFlushbarError(
            context, "No more products for this category!!");
      } else {
        for (var item in res.items) {
          productsOfCategory.add(item);
        }
      }
      Future.delayed(Duration(milliseconds: 500), () {
        isScrollLoading.value = false;
        callFunction.value = true;
      });
    }, (fail) {
      isScrollLoading.value = false;
    });
  }

  // Mock data loading
  void searchData(String searchText) {
    isLoading.value = true;

    // Mock categories
    //  categories.value = [
    //   Category(
    //     id: 'wearable',
    //     name: 'Wearable',
    //   ),
    //   Category(
    //     id: 'laptops',
    //     name: 'Laptops',
    //   ),
    //   Category(
    //     id: 'phones',
    //     name: 'Phones',
    //   ),
    //   Category(
    //     id: 'drones',
    //     name: 'Drones',
    //   ),
    // ];

    // Mock products
    // allProducts.value = [
    //   Product(
    //     id: '1',
    //     name: 'Apple Watch',
    //     fullName: '2020 Apple iPad Air 10.9"',
    //     categoryId: 'wearable',
    //     description:
    //         "Available when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tion",
    //     price: 359,
    //     imageUrl: 'assets/images/MaskGroup.png',
    //     backgroundColor: Colors.pink.withOpacity(0.2),
    //   ),
    //   Product(
    //     id: '2',
    //     name: 'SAMSUNG',
    //     fullName: '2020 Apple iPad Air 10.9"',
    //     categoryId: 'wearable',
    //     colors: ["#000000", "#90EE90", "#8F00FF"],
    //     description:
    //         "Available when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tionAvailable when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tion",
    //     price: 199,
    //     imageUrl: 'assets/images/MaskGroup.png',
    //     backgroundColor: Colors.blue.withOpacity(0.2),
    //   ),
    //   Product(
    //     id: '3',
    //     name: 'MacBook Pro',
    //     fullName: '2020 Apple iPad Air 10.9"',
    //     categoryId: 'laptops',
    //     description:
    //         "Available when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tion",
    //     price: 1299,
    //     imageUrl: 'assets/images/MaskGroup.png',
    //     backgroundColor: Colors.grey.withOpacity(0.2),
    //   ),
    //   Product(
    //     id: '4',
    //     name: 'iPhone 14',
    //     fullName: '2020 Apple iPad Air 10.9"',
    //     categoryId: 'phones',
    //     description:
    //         "Available when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tion",
    //     price: 1099,
    //     imageUrl: 'assets/images/MaskGroup.png',
    //     backgroundColor: Colors.purple.withOpacity(0.2),
    //   ),
    //   Product(
    //     id: '5',
    //     name: 'DJI Mini 3',
    //     fullName: '2020 Apple iPad Air 10.9"',
    //     categoryId: 'drones',
    //     description:
    //         "Available when you purchase any new iPhone, iPad, iPod Touch, Mac or Apple TV, £4.99/month after free trial.tion",
    //     price: 899,
    //     imageUrl: 'assets/images/MaskGroup.png',
    //     backgroundColor: Colors.orange.withOpacity(0.2),
    //   ),
    // ];

    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }

  // Change selected category
  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;

    // Update category colors
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
  }

  // Get filtered products based on selected category
  List<ProductItem> get filteredProducts {
    return allProducts
        .where((product) => product.categoryId == selectedCategoryId.value)
        .toList();
  }

  // Get selected category
  Category get selectedCategory {
    return categories.firstWhere(
      (cat) => cat.id == selectedCategoryId.value,
      orElse: () => categories.first,
    );
  }

  // Get For You products (initial load)
  void getForYouProducts() async {
    isForYouLoading.value = true;
    forYouPageNumber.value = 1;

    // Get current user ID
    final user = await IsarService.instance.getCurrentUser();
    // if (user != null) {
    ApisService.getForYouByUserId("2f54085d-00e8-4bc8-adaf-3a54e1d6c2be", "6",
        forYouPageNumber.value.toString(), //user.userId
        (ProductData productData) {
      forYouProducts.value = productData.items;
      isForYouLoading.value = false;
    }, (error) {
      isForYouLoading.value = false;
      debugPrint("Error loading For You products: $error");
    });
    // } else {
    //   isForYouLoading.value = false;
    // }
  }

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

  // Load more For You products (pagination)
  void loadMoreForYouProducts(BuildContext context) async {
    if (isForYouLoadingMore.value) return;

    isForYouLoadingMore.value = true;
    forYouPageNumber.value++;
    isForYouuLoadingg.value = true;
    // Get current user ID
    final user = await IsarService.instance.getCurrentUser();
    // if (user != null) {
    ApisService.getForYouByUserId("2f54085d-00e8-4bc8-adaf-3a54e1d6c2be", "6",
        forYouPageNumber.value.toString(), (ProductData productData) {
      // Add new products to existing list
      if (productData.items.isEmpty) {
        Utils.showFlushbarError(context, "No More For You Products!!");
      } else {
        forYouProducts.addAll(productData.items);
      }
      isForYouuLoadingg.value = false;
      isForYouLoadingMore.value = false;
    }, (error) {
      isForYouLoadingMore.value = false;
      isForYouuLoadingg.value = false;
      // Decrease page number if API call failed
      forYouPageNumber.value--;
      debugPrint("Error loading more For You products: $error");
    });
    // } else {
    //   isForYouuLoadingg.value = false;
    //   isForYouLoadingMore.value = false;
    //   forYouPageNumber.value--;
    // }
  }
}
