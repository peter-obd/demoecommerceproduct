import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final RxBool isVerifyingOtp = false.obs;
  final RxBool isResendingOtp = false.obs;
  final RxBool isRequestingPhoneChange = false.obs;
  final RxBool isRequestingPasswordChange = false.obs;

  bool isValidPassword(String password) {
    final hasMinLength = password.length >= 6;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));

    return hasMinLength && hasUppercase && hasNumber;
  }

  void requestPasswordChange(String newPassword, String currentPassword) {
    isRequestingPasswordChange.value = true;
    ApisService.requestPasswordChange(
      newPassword,
      currentPassword,
      (response) {
        isRequestingPasswordChange.value = false;
        // Show OTP popup on success
        _showOtpVerificationDialog(false);
      },
      (fail) {
        isRequestingPasswordChange.value = false;
        Get.snackbar(
          'Error',
          fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  void requestPhoneChange(
    String newPhoneNumber,
    String password,
  ) {
    isRequestingPhoneChange.value = true;
    ApisService.requestPhoneChange(
      newPhoneNumber,
      password,
      (response) {
        isRequestingPhoneChange.value = false;
        // Show OTP popup on success
        _showOtpVerificationDialog(true);
      },
      (fail) {
        isRequestingPhoneChange.value = false;
        Get.snackbar(
          'Error',
          fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  void verifyOtpPhoneNumber() {
    if (otpController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter the OTP code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isVerifyingOtp.value = true;
    ApisService.verifyPhoneChange(
      otpController.text,
      (response) {
        isVerifyingOtp.value = false;
        otpController.clear();
        Get.back(); // Close the dialog
        Get.offAllNamed('/home'); // Navigate to home screen
        Get.snackbar(
          'Success',
          'Phone number changed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      (fail) {
        isVerifyingOtp.value = false;
        Get.snackbar(
          'Error',
          fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  void verifyOtpPassword() {
    if (otpController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter the OTP code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isVerifyingOtp.value = true;
    ApisService.verifyPasswordChange(
      otpController.text,
      (response) {
        isVerifyingOtp.value = false;
        otpController.clear();
        Get.back(); // Close the dialog
        Get.offAllNamed('/home'); // Navigate to home screen
        Get.snackbar(
          'Success',
          'Password changed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      (fail) {
        isVerifyingOtp.value = false;
        Get.snackbar(
          'Error',
          fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  void resendOtp() {
    isResendingOtp.value = true;
    ApisService.resendOtpPhoneChange(
      (response) {
        isResendingOtp.value = false;
        Get.snackbar(
          'Success',
          'OTP has been resent',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      (fail) {
        isResendingOtp.value = false;
        Get.snackbar(
          'Error',
          fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  void _showOtpVerificationDialog(bool isPhoneChange) {
    otpController.clear();
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent back button
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Verify Phone Number',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please enter the OTP code sent to your new phone number',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      if (isVerifyingOtp.value || isResendingOtp.value) {
                      } else {
                        if (isPhoneChange) {
                          verifyOtpPhoneNumber();
                        } else {
                          verifyOtpPassword();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: isVerifyingOtp.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => OutlinedButton(
                    onPressed: (isVerifyingOtp.value || isResendingOtp.value)
                        ? null
                        : resendOtp,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: AppColors.primary),
                      disabledForegroundColor: Colors.grey,
                    ),
                    child: isResendingOtp.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : const Text(
                            'Resend OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
