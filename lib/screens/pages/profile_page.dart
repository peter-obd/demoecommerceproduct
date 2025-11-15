import 'package:demoecommerceproduct/controllers/profile_controller.dart';
import 'package:demoecommerceproduct/screens/edit_profile_options_screen.dart';
import 'package:demoecommerceproduct/screens/edit_profile_screen.dart';
import 'package:demoecommerceproduct/screens/help_support_screen.dart';
import 'package:demoecommerceproduct/screens/oders_screen.dart';
import 'package:demoecommerceproduct/screens/manage_addresses_screen.dart';
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
      height: responsive.hp(125),
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
                      'My Profile',
                      style: AppTextStyle.textStyle(
                        responsive.sp(50),
                        Colors.white,
                        FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Manage your account settings',
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
            _buildEnhancedProfileCard(responsive, controller),

            SizedBox(height: responsive.hp(30)),

            // Enhanced Menu Items
            _buildEnhancedMenuItem(
              'Edit Profile',
              'Update your personal information',
              Icons.edit_rounded,
              responsive,
              onTap: () => Get.to(const EditProfileOptionsScreen()),
            ),
            _buildEnhancedMenuItem(
              'Order History',
              'View your past orders and purchases',
              Icons.history_rounded,
              responsive,
              onTap: () => Get.to(const OdersScreen()),
            ),

            _buildEnhancedMenuItem(
              'Shopping Addresses',
              'Manage your delivery addresses',
              Icons.location_on_rounded,
              responsive,
              onTap: () => Get.to(() => const ManageAddressesScreen()),
            ),

            // _buildEnhancedMenuItem(
            //   'Notifications',
            //   'Manage your notification preferences',
            //   Icons.notifications_rounded,
            //   responsive,
            //   onTap: () {
            //     // Handle notifications
            //   },
            // ),

            _buildEnhancedMenuItem(
              'Help & Support',
              'Get help or contact customer support',
              Icons.help_rounded,
              responsive,
              onTap: () => Get.to(const HelpSupportScreen()),
            ),

            _buildEnhancedMenuItem(
              'Logout',
              'Sign out of your account',
              Icons.logout_rounded,
              responsive,
              isDestructive: true,
              onTap: () {
                // Handle logout
                controller.logoutUser();
              },
            ),

            _buildEnhancedMenuItem(
              'Delete Account',
              'Permanently delete your account',
              Icons.delete_forever_rounded,
              responsive,
              isDestructive: true,
              onTap: () {
                _showDeleteAccountDialog(Get.context!, responsive, controller);
              },
            ),

            SizedBox(height: responsive.hp(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedProfileCard(
      Responsive responsive, ProfileController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.wp(10)),
      padding: EdgeInsets.all(responsive.wp(25)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced Avatar Section
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: responsive.wp(120),
                height: responsive.wp(120),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      AppColors.lightBlue.withOpacity(0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: responsive.wp(110),
                height: responsive.wp(110),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    padding: EdgeInsets.all(responsive.wp(20)),
                    child: Image.asset(
                      "assets/icons/Profile.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Edit Button
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   child: Container(
              //     padding: EdgeInsets.all(responsive.wp(8)),
              //     decoration: BoxDecoration(
              //       color: AppColors.primary,
              //       shape: BoxShape.circle,
              //       boxShadow: [
              //         BoxShadow(
              //           color: AppColors.primary.withOpacity(0.3),
              //           blurRadius: 10,
              //           offset: const Offset(0, 3),
              //         ),
              //       ],
              //     ),
              //     child: Icon(
              //       Icons.camera_alt_rounded,
              //       color: Colors.white,
              //       size: responsive.sp(35),
              //     ),
              //   ),
              // ),
            ],
          ),

          SizedBox(height: responsive.hp(20)),

          // Enhanced User Info
          Text(
            controller.user?.name ?? "Unkown",
            style: AppTextStyle.textStyle(
              responsive.sp(50),
              AppColors.blackText,
              FontWeight.w700,
            ),
          ),

          SizedBox(height: responsive.hp(8)),

          // Container(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: responsive.wp(15),
          //     vertical: responsive.hp(6),
          //   ),
          //   decoration: BoxDecoration(
          //     color: AppColors.primary.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Text(
          //     "Premium Member",
          //     style: AppTextStyle.textStyle(
          //       responsive.sp(30),
          //       AppColors.primary,
          //       FontWeight.w600,
          //     ),
          //   ),
          // ),

          // SizedBox(height: responsive.hp(15)),

          // Enhanced Location Section
          GestureDetector(
            onTap: () {
              Get.to(() => const ManageAddressesScreen());
            },
            child: Container(
              padding: EdgeInsets.all(responsive.wp(15)),
              decoration: BoxDecoration(
                color: AppColors.greyBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(responsive.wp(8)),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: responsive.sp(35),
                    ),
                  ),
                  SizedBox(width: responsive.wp(15)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Default Delivery Address",
                          style: AppTextStyle.textStyle(
                            responsive.sp(28),
                            AppColors.greyText,
                            FontWeight.w500,
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.defaultAddress?.title ??
                                "No selected address",
                            style: AppTextStyle.textStyle(
                              responsive.sp(32),
                              controller.defaultAddress != null
                                  ? AppColors.blackText
                                  : AppColors.greyText,
                              FontWeight.w600,
                            ),
                          ),
                        ),
                        Obx(
                          () => controller.defaultAddress != null
                              ? Text(
                                  controller.defaultAddress!.description,
                                  style: AppTextStyle.textStyle(
                                    responsive.sp(26),
                                    AppColors.greyText,
                                    FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  "Tap to add your delivery address",
                                  style: AppTextStyle.textStyle(
                                    responsive.sp(26),
                                    AppColors.greyText,
                                    FontWeight.w400,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.greyText,
                    size: responsive.sp(30),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  void _showDeleteAccountDialog(BuildContext context, Responsive responsive,
      ProfileController controller) {
    final passwordController = TextEditingController();

    final RxBool obscurePassword = true.obs;

    Get.dialog(
      Obx(
        () => Stack(
          children: [
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: responsive.wp(700),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(responsive.wp(30)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon and Title
                        Container(
                          padding: EdgeInsets.all(responsive.wp(20)),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.red,
                            size: responsive.sp(80),
                          ),
                        ),
                        SizedBox(height: responsive.hp(20)),

                        Text(
                          'Delete Account',
                          style: AppTextStyle.textStyle(
                            responsive.sp(50),
                            AppColors.blackText,
                            FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: responsive.hp(10)),

                        Text(
                          'This action cannot be undone. All your data will be permanently deleted.',
                          style: AppTextStyle.textStyle(
                            responsive.sp(32),
                            AppColors.greyText,
                            FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: responsive.hp(30)),

                        // Password Field
                        Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: AppColors.greyBackground.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: passwordController,
                              obscureText: obscurePassword.value,
                              enabled: !controller.isdeleteLoading.value,
                              decoration: InputDecoration(
                                labelText: 'Enter your password',
                                labelStyle: AppTextStyle.textStyle(
                                  responsive.sp(34),
                                  AppColors.greyText,
                                  FontWeight.w400,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_rounded,
                                  color: AppColors.primary,
                                  size: responsive.sp(45),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword.value
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: AppColors.greyText,
                                    size: responsive.sp(45),
                                  ),
                                  onPressed: () {
                                    obscurePassword.value =
                                        !obscurePassword.value;
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(20),
                                  vertical: responsive.hp(18),
                                ),
                              ),
                              style: AppTextStyle.textStyle(
                                responsive.sp(36),
                                AppColors.blackText,
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.hp(30)),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: controller.isdeleteLoading.value
                                    ? null
                                    : () {
                                        Get.back();
                                      },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: responsive.hp(16),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.greyBackground,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color:
                                          AppColors.greyText.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: AppTextStyle.textStyle(
                                      responsive.sp(38),
                                      AppColors.blackText,
                                      FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: responsive.wp(15)),
                            Expanded(
                              child: GestureDetector(
                                onTap: controller.isdeleteLoading.value
                                    ? null
                                    : () {
                                        if (passwordController.text
                                            .trim()
                                            .isEmpty) {
                                          Get.snackbar(
                                            'Error',
                                            'Please enter your password',
                                            backgroundColor:
                                                Colors.red.withOpacity(0.8),
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.TOP,
                                            margin: EdgeInsets.all(
                                                responsive.wp(20)),
                                            borderRadius: 15,
                                          );
                                          return;
                                        }

                                        controller.isdeleteLoading.value = true;
                                        controller.deleteUser(
                                            passwordController.text.trim());
                                        // Note: The dialog will close when user is logged out
                                      },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: responsive.hp(16),
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red,
                                        Colors.red.shade700,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Delete',
                                    style: AppTextStyle.textStyle(
                                      responsive.sp(38),
                                      Colors.white,
                                      FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Loading Overlay
            if (controller.isdeleteLoading.value)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(responsive.wp(30)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                            strokeWidth: 3,
                          ),
                          SizedBox(height: responsive.hp(15)),
                          Text(
                            'Deleting account...',
                            style: AppTextStyle.textStyle(
                              responsive.sp(36),
                              AppColors.blackText,
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
