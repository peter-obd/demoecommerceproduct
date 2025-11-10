import 'package:demoecommerceproduct/screens/login_screen.dart';
import 'package:demoecommerceproduct/screens/verify_otp_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: responsive.wp(30),
            right: responsive.wp(30),
            top: responsive.hp(40)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Header Section
            _buildForgotPasswordHeader(responsive),
            SizedBox(height: responsive.hp(20)),

            // Enhanced Phone Number Field
            _buildPhoneNumberField(responsive),

            SizedBox(height: responsive.hp(30)),

            // Enhanced Reset Button
            _buildResetPasswordButton(responsive),

            // Enhanced Back to Login Section
            _buildBackToLoginSection(responsive),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordHeader(Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'No Worries',
          style: AppTextStyle.textStyle(
            responsive.sp(50),
            AppColors.blackText,
            FontWeight.w800,
          ),
        ),
        SizedBox(height: responsive.hp(8)),
        Text(
          'Let\'s fix this so you can get in again',
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

  Widget _buildResetPasswordButton(Responsive responsive) {
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
          var fullPhoneNumber = '+961${_phoneController.text}';
          setState(() {
            _isLoading = true;
          });
          ApisService.forgotPassword(fullPhoneNumber, (success) {
            setState(() {
              _isLoading = false;
            });
            Get.to(VerifyOtpScreen(
              phone: fullPhoneNumber,
            ));
          }, (fail) {
            setState(() {
              _isLoading = false;
            });
            Utils.showFlushbarError(context, fail.message);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                  SizedBox(width: responsive.wp(15)),
                  Text(
                    'Sending...',
                    style: AppTextStyle.textStyle(
                      responsive.sp(35),
                      Colors.white,
                      FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restore_rounded,
                    color: Colors.white,
                    size: responsive.sp(50),
                  ),
                  SizedBox(width: responsive.wp(15)),
                  Text(
                    'Reset Password',
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

  Widget _buildBackToLoginSection(Responsive responsive) {
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
                  'Back to Login',
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
