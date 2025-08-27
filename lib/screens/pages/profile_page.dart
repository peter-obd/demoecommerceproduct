import 'package:demoecommerceproduct/controllers/profile_controller.dart';
import 'package:demoecommerceproduct/screens/edit_profile_screen.dart';
import 'package:demoecommerceproduct/screens/oders_screen.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    var responsive = Responsive(context);
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.greyBackground,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(30)),
          child: Column(
            children: [
              // Profile Card
              Container(
                padding: EdgeInsets.all(responsive.wp(10)),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.greyBackground,
                      child: Center(
                          child: Image.asset(
                        "assets/icons/Profile.png",
                        height: responsive.hp(30),
                        width: responsive.wp(70),
                      )),
                    ),
                    SizedBox(height: responsive.hp(7)),
                    Text(
                      "Rosina Doe",
                      style: AppTextStyle.textStyle(
                          20, AppColors.blackText, FontWeight.w600),
                    ),
                    SizedBox(height: responsive.hp(7)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("assets/icons/Location.png",
                            height: responsive.hp(20),
                            width: responsive.wp(20)),
                        const SizedBox(width: 4),
                        Flexible(
                            child: Obx(
                          () => Text(
                              controller.location?.address ??
                                  "no chosen address yet!",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.textStyle(responsive.sp(25),
                                  AppColors.blackText, FontWeight.w400)),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.hp(30)),

              // List Items
              buildListTile("Edit Profile", responsive, onTap: () {
                Get.to(EditProfileScreen());
              }),
              buildListTile("Shopping address", responsive, onTap: () {
                controller.pickLocation(context);
              }),
              buildListTile("Order history", responsive, onTap: () {
                Get.to(OdersScreen());
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile(String title, Responsive responsive,
      {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(20)),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        title: Text(
          title,
          style: AppTextStyle.textStyle(
              responsive.sp(35), AppColors.blackText, FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
