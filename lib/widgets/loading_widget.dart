import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenLoader {
  static void show() {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
        PopScope(
          canPop: false,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                const SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        useSafeArea: false);
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
