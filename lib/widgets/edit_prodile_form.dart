import 'package:demoecommerceproduct/controllers/edit_profile_controller.dart';
import 'package:demoecommerceproduct/controllers/signup_controller.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _confirmObscurePassword = true;

  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: responsive.wp(30),
            right: responsive.wp(30),
            top: responsive.hp(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Header Section
            _buildEditProfileHeader(responsive),
            SizedBox(height: responsive.hp(20)),

            // Enhanced Phone Number Field
            _buildPhoneNumberField(responsive),

            // Enhanced Password Field
            _buildPasswordField(responsive),

            // Enhanced Confirm Password Field
            _buildConfirmPasswordField(responsive),

            // SizedBox(height: responsive.hp(10)),

            // Enhanced Save Button
            _buildSaveButton(responsive),

            // Enhanced Back Section
            _buildBackSection(responsive),
          ],
        ),
      ),
    );
  }

  Widget _buildEditProfileHeader(Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update your profile information',
          style: AppTextStyle.textStyle(
            responsive.sp(35),
            AppColors.greyText,
            FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: AppColors.greyShadow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.wp(8)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.phone_rounded,
                    color: AppColors.primary,
                    size: responsive.sp(30),
                  ),
                ),
                SizedBox(width: responsive.wp(15)),
                Text(
                  'Phone Number',
                  style: AppTextStyle.textStyle(
                    responsive.sp(35),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.hp(10)),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: responsive.hp(8),
                    horizontal: responsive.wp(12),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '+961',
                    style: AppTextStyle.textStyle(
                      responsive.sp(29),
                      Colors.white,
                      FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: responsive.wp(15)),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '00-000-000',
                      hintStyle: AppTextStyle.textStyle(
                        responsive.sp(35),
                        AppColors.greyShadow,
                        FontWeight.w400,
                      ),
                    ),
                    style: AppTextStyle.textStyle(
                      responsive.sp(40),
                      AppColors.blackText,
                      FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: AppColors.greyShadow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.wp(5)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    color: AppColors.primary,
                    size: responsive.sp(30),
                  ),
                ),
                SizedBox(width: responsive.wp(15)),
                Text(
                  'New Password',
                  style: AppTextStyle.textStyle(
                    responsive.sp(35),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.hp(10)),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter new password',
                hintStyle: AppTextStyle.textStyle(
                  responsive.sp(35),
                  AppColors.greyShadow,
                  FontWeight.w400,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(responsive.wp(8)),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.primary,
                      size: responsive.sp(45),
                    ),
                  ),
                ),
              ),
              style: AppTextStyle.textStyle(
                responsive.sp(40),
                AppColors.blackText,
                FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: AppColors.greyShadow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.wp(5)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primary,
                    size: responsive.sp(30),
                  ),
                ),
                SizedBox(width: responsive.wp(15)),
                Text(
                  'Confirm New Password',
                  style: AppTextStyle.textStyle(
                    responsive.sp(35),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.hp(10)),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _confirmObscurePassword,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Confirm new password',
                hintStyle: AppTextStyle.textStyle(
                  responsive.sp(35),
                  AppColors.greyShadow,
                  FontWeight.w400,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _confirmObscurePassword = !_confirmObscurePassword;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(responsive.wp(8)),
                    child: Icon(
                      _confirmObscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.primary,
                      size: responsive.sp(45),
                    ),
                  ),
                ),
              ),
              style: AppTextStyle.textStyle(
                responsive.sp(40),
                AppColors.blackText,
                FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(top: responsive.hp(12)),
      width: double.infinity,
      height: responsive.hp(60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          String fullPhoneNumber = '+961${_phoneController.text}';
          print('Phone: $fullPhoneNumber');
          print('Password: ${_passwordController.text}');
          if (_phoneController.text.isEmpty) {
            Utils.showFlushbarError(
                context, "Make sure to enter your phone number");
          } else if (!controller.isValidPassword(_passwordController.text)) {
            Utils.showFlushbarError(context,
                "Password must be atleast 6 charachters and must have at least one number and one capital letter");
          } else if (_confirmPasswordController.text !=
              _passwordController.text) {
            Utils.showFlushbarError(
                context, "Password and Confirm Password must be same");
          } else {
            print("Profile Updated");
            // Add success message or navigate back
            Utils.showFlushbarError(context, "Profile updated successfully!");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.save_rounded,
              color: Colors.white,
              size: responsive.sp(50),
            ),
            SizedBox(width: responsive.wp(15)),
            Text(
              'Save Changes',
              style: AppTextStyle.textStyle(
                responsive.sp(42),
                Colors.white,
                FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackSection(Responsive responsive) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.greyShadow.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(20)),
              child: Text(
                'OR',
                style: AppTextStyle.textStyle(
                  responsive.sp(32),
                  AppColors.greyText,
                  FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.greyShadow.withOpacity(0.5),
              ),
            ),
          ],
        ),
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
                  'Cancel Changes',
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
      ],
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
