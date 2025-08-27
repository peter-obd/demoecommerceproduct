import 'package:get/get.dart';

class EditProfileController extends GetxController {
  bool isValidPassword(String password) {
    final hasMinLength = password.length >= 6;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));

    return hasMinLength && hasUppercase && hasNumber;
  }
}
