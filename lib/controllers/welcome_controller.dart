import 'package:demoecommerceproduct/controllers/login_controller.dart';

import 'package:demoecommerceproduct/screens/login_screen.dart';

import 'package:demoecommerceproduct/services/isar_service.dart';

import 'package:get/get.dart';

class WelcomeController extends GetxController {
  RxBool isNavigated = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkIfLoggedIn();
  }

  void checkIfLoggedIn() async {
    isNavigated.value = true;
    Future.delayed(const Duration(milliseconds: 100), () async {
      LoginController loginController = Get.find<LoginController>();
      final user = await IsarService.instance.getCurrentUser();
      if (user != null) {
        loginController.getCategories(Get.context!);
        // Get.offAll(HomeScreen());
      } else {
        Get.offAll(const LoginScreen());
      }
    });
  }

  // void navigateToLoginScreen(context) async {
  //   LoginController loginController = Get.find<LoginController>();
  //   final user = await IsarService.instance.getCurrentUser();
  //   if (user != null) {
  //     loginController.getCategories(context);
  //     // Get.offAll(HomeScreen());
  //   } else {
  //     Get.offAll(const LoginScreen());
  //   }
  // }
}
