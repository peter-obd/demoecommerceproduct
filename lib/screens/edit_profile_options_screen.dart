import 'package:demoecommerceproduct/controllers/profile_controller.dart';
import 'package:demoecommerceproduct/screens/edit_profile_screen.dart';
import 'package:demoecommerceproduct/screens/help_support_screen.dart';
import 'package:demoecommerceproduct/screens/oders_screen.dart';
import 'package:demoecommerceproduct/screens/manage_addresses_screen.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileOptionsScreen extends StatelessWidget {
  const EditProfileOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    var responsive = Responsive(context);
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Column(
        children: [
          // Enhanced Header
          _buildEnhancedHeader(responsive),

          // Enhanced Profile Content
          Expanded(
            child: _buildEnhancedProfileContent(responsive, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(Responsive responsive) {
    return Container(
      height: responsive.hp(130),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(20)),
          child: Row(
            children: [
              // Back Button (if needed)
              Container(
                padding: EdgeInsets.all(responsive.wp(12)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: responsive.sp(45),
                ),
              ),
              SizedBox(width: responsive.wp(15)),

              // Profile Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Edit Profile',
                      style: AppTextStyle.textStyle(
                        responsive.sp(50),
                        Colors.white,
                        FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Choose what to edit',
                      style: AppTextStyle.textStyle(
                        responsive.sp(32),
                        Colors.white.withOpacity(0.9),
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedProfileContent(
      Responsive responsive, ProfileController controller) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(20)),
        child: Column(
          children: [
            SizedBox(height: responsive.hp(20)),

            // Enhanced Profile Card

            SizedBox(height: responsive.hp(30)),

            // Enhanced Menu Items
            _buildEnhancedMenuItem(
              'Change Number',
              'Update your mobile number',
              Icons.edit_rounded,
              responsive,
              onTap: () => Get.to(EditProfileScreen(
                isChangeNumber: true,
              )),
            ),
            _buildEnhancedMenuItem(
              'Change Password',
              'Update your password',
              Icons.edit_rounded,
              responsive,
              onTap: () => Get.to(EditProfileScreen(
                isChangeNumber: false,
              )),
            ),
            SizedBox(height: responsive.hp(20)),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: responsive.hp(10)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primary,
                      size: responsive.sp(50),
                    ),
                    SizedBox(width: responsive.wp(15)),
                    Text(
                      'Go Back',
                      style: AppTextStyle.textStyle(
                        responsive.sp(42),
                        AppColors.primary,
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: responsive.hp(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedMenuItem(
    String title,
    String subtitle,
    IconData icon,
    Responsive responsive, {
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(15)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(responsive.wp(20)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDestructive
                    ? Colors.red.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDestructive
                      ? Colors.red.withOpacity(0.05)
                      : AppColors.primary.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.wp(12)),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? Colors.red.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red : AppColors.primary,
                    size: responsive.sp(45),
                  ),
                ),
                SizedBox(width: responsive.wp(15)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.textStyle(
                          responsive.sp(40),
                          isDestructive ? Colors.red : AppColors.blackText,
                          FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: responsive.hp(3)),
                      Text(
                        subtitle,
                        style: AppTextStyle.textStyle(
                          responsive.sp(30),
                          AppColors.greyText,
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(responsive.wp(5)),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? Colors.red.withOpacity(0.1)
                        : AppColors.greyBackground.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDestructive ? Colors.red : AppColors.greyText,
                    size: responsive.sp(30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
