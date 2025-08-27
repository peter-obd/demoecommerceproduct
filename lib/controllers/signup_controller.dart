import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/screens/login_screen.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isOtpLoading = false.obs;
  RxBool isResendLoading = false.obs;
  TextEditingController otpController = TextEditingController();
  bool isValidPassword(String password) {
    final hasMinLength = password.length >= 6;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));

    return hasMinLength && hasUppercase && hasNumber;
  }

  void signup(
      String fullPhoneNumber, BuildContext context, String password) async {
    isLoading.value = true;
    ApisService.signup(fullPhoneNumber, password, (success) {
      isLoading.value = false;
      showOtpVerificationPopup(context, success, () {
        isOtpLoading.value = true;
        ApisService.verifyUser(fullPhoneNumber, otpController.text, (success) {
          isOtpLoading.value = false;
          Get.offAll(LoginScreen());
        }, (fail) {
          isOtpLoading.value = false;
          Utils.showFlushbarError(context, fail.message);
        });
      }, () {
        isResendLoading.value = true;
        ApisService.resendOtp(fullPhoneNumber, (success) {
          isResendLoading.value = false;
          Utils.showFlushbarSuccess(context, success);
        }, (fail) {
          isResendLoading.value = false;
          Utils.showFlushbarError(context, fail.message);
        });
      });
    }, (fail) {
      isLoading.value = false;
      Utils.showFlushbarError(context, fail.message);
    });
  }

  void showOtpVerificationPopup(BuildContext context, String dynamicText,
      VoidCallback onVerifyPressed, VoidCallback onResendPressed) {
    var responsive = Responsive(context);
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(
            'Verify by OTP',
            style: AppTextStyle.textStyle(
                responsive.sp(35), AppColors.blackText, FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dynamicText,
                style: AppTextStyle.textStyle(
                    responsive.sp(30), AppColors.blackText, FontWeight.normal),
              ),
              SizedBox(height: 20),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintStyle: AppTextStyle.textStyle(
                      responsive.sp(30), AppColors.greyText, FontWeight.bold),
                  hintText: 'Enter OTP',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: responsive.hp(40),
                child: ElevatedButton(
                    onPressed: onVerifyPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Obx(
                      () => isOtpLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text('Verify',
                              style: AppTextStyle.textStyle(responsive.sp(30),
                                  AppColors.secondary, FontWeight.bold)),
                    )),
              ),
              Obx(
                () => isResendLoading.value
                    ? CircularProgressIndicator()
                    : TextButton(
                        onPressed: onResendPressed,
                        child: Text('Resend',
                            style: AppTextStyle.textStyle(responsive.sp(30),
                                AppColors.primary, FontWeight.bold)),
                      ),
              ),
            ],
          ),
          // actions: [
          //   Obx(
          //     () => isResendLoading.value
          //         ? CircularProgressIndicator()
          //         : TextButton(
          //             onPressed: onResendPressed,
          //             child: Text('Resend'),
          //           ),
          //   ),
          //   Obx(
          //     () => ElevatedButton(
          //       onPressed: onVerifyPressed,
          //       child: isOtpLoading.value
          //           ? CircularProgressIndicator()
          //           : Text('Verify'),
          //     ),
          //   ),
          // ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
