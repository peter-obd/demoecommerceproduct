import 'package:demoecommerceproduct/controllers/welcome_controller.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/bottomsheet/bottomsheet.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WelcomeController controller = Get.put(WelcomeController());
    var responsive = Responsive(context);
    return Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: EdgeInsets.only(top: responsive.hp(70)),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: responsive.wp(290),
                  child: Text(
                    "Find your\nGadget",
                    style: AppTextStyle.titleStyle(responsive.sp(100)),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: responsive.hp(350),
                  child: Image.asset(
                    ImagesConstants.splashImage,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  height: responsive.hp(70),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        spreadRadius: 20,
                        color: AppColors.primary.withOpacity(0.9),
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                ),
                // Obx(
                //   () => controller.isNavigated.value == false
                //       ? const CircularProgressIndicator(
                //           color: Colors.white,
                //         )
                //       :
                GestureDetector(
                  onTap: () {
                    controller.navigateToLoginScreen();
                  },
                  child: Container(
                    height: responsive.hp(60),
                    width: responsive.wp(290),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: AppColors.secondary,
                    ),
                    child: Center(
                      child: Text("Get Started",
                          style: AppTextStyle.textStyle(responsive.sp(35),
                              AppColors.primary, FontWeight.bold)),
                    ),
                  ),
                ),
                //   ),
              ],
            ),
          ),
        ));
  }
}
