import 'dart:convert';

import 'package:demoecommerceproduct/models/category_model.dart';
import 'package:demoecommerceproduct/models/on_checkout_order_product_model.dart';
import 'package:demoecommerceproduct/models/order_model.dart';
import 'package:demoecommerceproduct/models/product/product_data_model.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/user.dart';
import 'package:demoecommerceproduct/models/user_address_model.dart';
import 'package:demoecommerceproduct/networking/app_request_manager.dart';
import 'package:demoecommerceproduct/networking/request_manager.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/services/user_service.dart';
import 'package:flutter/material.dart';

typedef CategoriesSuccess = Function(List<Category> serviceDirectoryModel);
typedef ProductDataSuccess = Function(ProductData productData);
typedef ProductSuccess = Function(List<ProductItem> productData);
typedef UserSuccess = Function(User user);
typedef addFavoriteProductSuccess = Function(bool success);
typedef OrdersHistorySuccess = Function(List<OrderModel> orders);
typedef UserAddressesSuccess = Function(List<UserAddress> addresses);
typedef SetDefaultAddressSuccess = Function(UserAddress updatedAddress);
typedef GetDefaultAddressSuccess = Function(UserAddress? defaultAddress);

class ApisService {
  static const String _baseUrl = "https://onedollarapp.onrender.com/";
  static const String _urlPath = "api/";

  static void getAllCategories(CategoriesSuccess success, RequestFail fail) {
    var urlMethod = "Category/get-all";
    var url = _baseUrl + _urlPath + urlMethod;
    AppRequestManager.getWithToken(url, null, null, true, (response) async {
      try {
        Map<String, dynamic> result = json.decode(response);
        List data = result['data'];
        List<Category> categories = [];
        for (var category in data) {
          categories.add(Category.fromJson(category));
        }
        await IsarService.instance.saveMultipleCategories(categories);

        success(categories);
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void signup(String firstName, String lastName, String phone,
      String password, RequestSuccess success, RequestFail fail) {
    var urlMethod = "Auth/signup";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {
      "phone": phone,
      "password": password,
      "firstName": firstName,
      "lastName": lastName
    };
    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        String successData = result['data'];
        success(successData);
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void verifyUser(
      String phone, String otpCode, RequestSuccess success, RequestFail fail) {
    var urlMethod = "Auth/verify-otp";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {
      "phone": phone,
      "otpCode": otpCode,
    };
    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        String successData = result['data'];
        success(successData);
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void resendOtp(
      String phone, RequestSuccess success, RequestFail fail) {
    var urlMethod = "Auth/resend-otp";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {"phoneNumber": phone}; // pob rja3la t2akad

    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        String successData = result['data'];
        success(successData);
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void resendPasswordResetOtp(
      String phone, RequestSuccess success, RequestFail fail) {
    var urlMethod = "Auth/resend-password-reset-otp";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {"phoneNumber": phone}; // pob rja3la t2akad

    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        String successData = result['data'];
        success(successData);
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void forgotPassword(
      String phone, RequestSuccess success, RequestFail fail) {
    var urlMethod = "Auth/forgot-password";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {"phone": phone};

    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        String successData = result['data'];
        success(successData);
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void resetPassword(String phone, String otp, String password,
      RequestSuccess success, RequestFail fail) {
    var urlMethod = "Auth/reset-password";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {"phone": phone, "otpCode": otp, "newPassword": password};

    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        String successData = result['data'];
        success(successData);
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void loginUser(
      String phone, String password, UserSuccess success, RequestFail fail) {
    var urlMethod = "Auth/login";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {"phone": phone, "password": password};
    AppRequestManager.postWithToken(url, params, null, true, false,
        (response) async {
      try {
        Map<String, dynamic> result = json.decode(response);
        User user = User.fromJson(result['data']);
        await IsarService.instance.saveUser(user);
        success(user);
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void addUserAddress(String title, String description, double long,
      double lat, bool isDefault, RequestSuccess success, RequestFail fail) {
    var urlMethod = "UserAddress/add-user-address";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {
      "title": title,
      "description": description,
      "longitude": long,
      "latitude": lat,
      "isDefault": isDefault
    };

    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        bool successData = result['success'];
        if (successData) {
          success("successData");
        }
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void getUserAddresses(UserAddressesSuccess success, RequestFail fail) {
    var urlMethod = "UserAddress/get-addresses-by-user";
    var url = _baseUrl + _urlPath + urlMethod;

    AppRequestManager.getWithToken(url, null, null, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        List data = result['data'];
        List<UserAddress> addresses = [];
        for (var address in data) {
          addresses.add(UserAddress.fromJson(address));
        }
        success(addresses);
      } catch (e) {
        debugPrint("Could not parse user addresses: ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void setDefaultAddress(String addressId, SetDefaultAddressSuccess success, RequestFail fail) {
    var urlMethod = "UserAddress/set-default-address/$addressId";
    var url = _baseUrl + _urlPath + urlMethod;

    AppRequestManager.postWithToken(url, {}, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        if (result['success'] == true) {
          UserAddress updatedAddress = UserAddress.fromJson(result['data']);
          success(updatedAddress);
        }
      } catch (e) {
        debugPrint("Could not parse set default address response: ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void getDefaultAddress(GetDefaultAddressSuccess success, RequestFail fail) {
    var urlMethod = "UserAddress/get-default-address";
    var url = _baseUrl + _urlPath + urlMethod;

    AppRequestManager.getWithToken(url, null, null, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        if (result['success'] == true && result['data'] != null) {
          UserAddress defaultAddress = UserAddress.fromJson(result['data']);
          success(defaultAddress);
        } else {
          success(null);
        }
      } catch (e) {
        debugPrint("Could not parse get default address response: ${e.toString()}");
        success(null);
      }
    }, (error) {
      debugPrint("Failed to get default address: $error");
      success(null);
    });
  }

  static void checkoutOrder(
      String couponCode,
      List<OnCheckoutOrderProductModel> products,
      RequestSuccess success,
      RequestFail fail) {
    var urlMethod = "Order/checkout";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {
      "couponCode": couponCode,
      "orderItems": products.map((p) => p.toJson()).toList(),
    };

    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        if (result['success'] == true) {
          success("successData");
        }
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void getOrdersHistory(OrdersHistorySuccess success, RequestFail fail) {
    String urlMethod =
        'Order/get-orders-by-user-with-details-paginated?pageNumber=1&pageSize=1000&sortDescending=true';
    var url = _baseUrl + _urlPath + urlMethod;

    AppRequestManager.getWithToken(url, null, null, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        var orderList = result['data']['items'];
        List<OrderModel> orders = [];
        for (var order in orderList) {
          orders.add(OrderModel.fromJson(order));
        }
        success(orders);
      } catch (e) {
        debugPrint("Could not parse  : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void getProductByCategoryId(
      String categoryId,
      String pageSize,
      bool adding,
      String pageNumebr,
      ProductDataSuccess success,
      RequestFail fail) {
    var urlMethod =
        "Product/get-by-category-id-with-details-paginated/$categoryId/$pageSize/$pageNumebr";
    var url = _baseUrl + _urlPath + urlMethod;

    AppRequestManager.getWithToken(url, null, null, true, (response) async {
      try {
        Map<String, dynamic> result = json.decode(response);

        ProductData productData = ProductData.fromJson(result['data']);
        // if (!adding) {
        await IsarService.instance
            .saveMultipleProductsUpsert(productData.items);
        // }

        success(productData);
      } catch (e) {
        debugPrint("Could not parse  : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void getForYouByUserId(String userId, String pageSize,
      String pageNumebr, ProductDataSuccess success, RequestFail fail) {
    var urlMethod = "Product/products-for-you/$userId/$pageNumebr/$pageSize";
    var url = _baseUrl + _urlPath + urlMethod;

    AppRequestManager.getWithToken(url, null, null, true, (response) async {
      try {
        Map<String, dynamic> result = json.decode(response);

        ProductData productData = ProductData.fromJson(result['data']);

        success(productData);
      } catch (e) {
        debugPrint("Could not parse  : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void getAllProducts(ProductSuccess success, RequestFail fail) {
    var urlMethod = "Product/get-all";
    var url = _baseUrl + _urlPath + urlMethod;

    AppRequestManager.getWithToken(url, null, null, true, (response) async {
      try {
        Map<String, dynamic> result = json.decode(response);
        var items = result['data'];
        List<ProductItem> products = [];
        for (var product in items) {
          products.add(ProductItem.fromJson(product, false));
        }

        await IsarService.instance.saveMultipleProducts(products);

        success(products);
      } catch (e) {
        debugPrint("Could not parse  : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void getAllFavoritesProducts(
      ProductSuccess success, RequestFail fail) {
    var urlMethod =
        "Favorite/get-favorites-by-user-with-details-paginated?pageNumber=1&pageSize=10&sortDescending=true";
    var url = _baseUrl + _urlPath + urlMethod;

    AppRequestManager.getWithToken(url, null, null, true, (response) async {
      try {
        Map<String, dynamic> result = json.decode(response);
        var items = result['data']['items'];
        List<ProductItem> products = [];
        for (var product in items) {
          products.add(ProductItem.fromJson(product, true));
        }

        success(products);
      } catch (e) {
        debugPrint("Could not parse  : ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void addToFavorites(String productId, String userId,
      addFavoriteProductSuccess success, RequestFail fail) {
    var urlMethod = "Favorite/insert";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {
      "productId": productId,
      "userId": userId,
    };
    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        bool successData = result['success'];
        success(successData);
      } catch (e) {
        debugPrint("Could not parse Favorite Product: ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  // static void deletFavitProduct(
  //     String productId, addFavoriteProductSuccess success, RequestFail fail) {
  //   var urlMethod = "Favorite/delete/$productId";
  //   var url = _baseUrl + _urlPath + urlMethod;

  //   AppRequestManager.deleteWithToken(url, null, true, (response) {
  //     try {
  //       Map<String, dynamic> result = json.decode(response);
  //       bool successData = result['success'];
  //       success(successData);
  //     } catch (e) {
  //       debugPrint("Could not parse Favorite Product: ${e.toString()}");
  //     }
  //   }, (error) => fail(error));
  // }

  static void toggleFavoriteProduct(String productId, bool trueOrFalse,
      addFavoriteProductSuccess success, RequestFail fail) {
    var urlMethod = "Favorite/toggle-favorite-product";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {"productId": productId, "isFavorite": trueOrFalse};
    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        bool successData = result['success'];
        success(successData);
      } catch (e) {
        debugPrint("Could not parse Favorite Product: ${e.toString()}");
      }
    }, (error) => fail(error));
  }

  static void searchProduct(
      String searchText, ProductSuccess success, RequestFail fail) {
    var urlMethod = "Product/product-search";
    var url = _baseUrl + _urlPath + urlMethod;

    var params = {"searchText": searchText};

    AppRequestManager.postWithToken(url, params, null, true, true, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);

        List data = result['data'];
        List<ProductItem> products = [];
        for (var product in data) {
          products.add(ProductItem.fromJson(product, false));
        }
        success(products);
      } catch (e) {
        debugPrint("Could not parse Searched Product: ${e.toString()}");
      }
    }, (error) => fail(error));
  }
}
// {
//   "searchText": "string",
//   "code": "string",
//   "categoryId": "string",
//   "brandId": "string",
//   "currency": "string",
//   "minPrice": 0,
//   "maxPrice": 0,
//   "attributes": [
//     {
//       "basicDataCategoryName": "string",
//       "isProductVariant": true,
//       "values": [
//         "string"
//       ]
//     }
//   ],
//   "page": 0,
//   "pageSize": 0
// }