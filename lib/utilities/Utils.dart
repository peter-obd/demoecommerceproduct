import 'package:another_flushbar/flushbar.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum FlushbarType { success, notice, error, notification }

class Utils {
  Utils._();

  static void showFlushbarError(BuildContext context, String error) {
    _showFLushbar(context, error, FlushbarType.error);
  }

  static void showFlushbarSuccess(BuildContext context, String message) {
    _showFLushbar(context, message, FlushbarType.success);
  }

  static void _showFLushbar(
      BuildContext context, String message, FlushbarType type) {
    var responsive = Responsive(context);

    Color color = Colors.green;
    switch (type) {
      case FlushbarType.success:
        color = Colors.green;
        break;
      case FlushbarType.notice:
        color = Colors.blue;
        break;
      case FlushbarType.notification:
        color = AppColors.secondary;
        break;
      case FlushbarType.error:
        color = Colors.red;
        break;
      default:
        break;
    }

    Icon icon = const Icon(Icons.info);
    switch (type) {
      case FlushbarType.success:
        icon = const Icon(Icons.check_circle);
        break;
      case FlushbarType.error:
        icon = const Icon(Icons.error);
        break;
      case FlushbarType.notification:
        icon = const Icon(Icons.notifications_active);
        break;
      case FlushbarType.notice:
        icon = const Icon(Icons.info);
        break;
      default:
        break;
    }

    var flushBar = Flushbar(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      borderRadius: BorderRadius.circular(15),
      flushbarPosition: FlushbarPosition.TOP,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      backgroundColor: color,
      duration: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 250),
      messageText: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.5),
            child: Icon(
              icon.icon,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Flexible(
            child: Text(
              message,
              style: AppTextStyle.textStyle(
                  responsive.sp(30), AppColors.secondary, FontWeight.w400),
            ),
          ),
        ],
      ),
    );

    flushBar.show(context);
  }

  static void showBottomSheet(BuildContext context,
      {required String title,
      required String text,
      required bool showButton,
      String? buttonText,
      VoidCallback? onPressed}) {
    var responsive = Responsive(context);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.textStyle(
                    responsive.sp(35), AppColors.primary, FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: AppTextStyle.textStyle(
                  responsive.sp(30),
                  AppColors.greyText,
                  FontWeight.w400,
                ),
              ),
              if (showButton)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: responsive.hp(60),
                      child: ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(buttonText ?? 'Ok',
                            style: AppTextStyle.textStyle(responsive.sp(37),
                                AppColors.secondary, FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
