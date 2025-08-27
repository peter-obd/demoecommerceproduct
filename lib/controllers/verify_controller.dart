import 'package:get/get.dart';

class VerifyController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isResendLoading = false.obs;
  bool isValidPassword(String password) {
    final hasMinLength = password.length >= 6;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));

    return hasMinLength && hasUppercase && hasNumber;
  }
}
