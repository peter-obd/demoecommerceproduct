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
    return Padding(
      padding: EdgeInsets.only(
          left: responsive.wp(40),
          right: responsive.wp(40),
          top: responsive.hp(50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No Worries',
              style: AppTextStyle.textStyle(
                  responsive.sp(50), AppColors.blackText, FontWeight.bold)),
          SizedBox(height: responsive.hp(5)),
          Text('Let\'s fix this so you can get in again',
              style: AppTextStyle.textStyle(
                  responsive.sp(35), AppColors.greyText, FontWeight.w400)),
          SizedBox(height: responsive.hp(30)),

          // Phone Number Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/icons/Call.png",
                    height: responsive.hp(25),
                    width: responsive.wp(25),
                    color: AppColors.greyShadow,
                  ),
                  SizedBox(width: responsive.wp(15)),
                  Text('Phone Number',
                      style: AppTextStyle.textStyle(responsive.sp(30),
                          AppColors.greyText, FontWeight.normal)),
                ],
              ),
              SizedBox(height: responsive.hp(5)),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.greyShadow,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('+961',
                          style: AppTextStyle.textStyle(responsive.sp(30),
                              AppColors.secondary, FontWeight.normal)),
                    ),
                    SizedBox(width: responsive.wp(10)),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Only allow digits
                          LengthLimitingTextInputFormatter(
                              8), // Limit to 8 digits
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '00-000-000',
                          hintStyle: AppTextStyle.textStyle(
                            responsive.sp(30),
                            AppColors.greyShadow,
                            FontWeight.normal,
                          ),
                        ),
                        style: AppTextStyle.textStyle(
                          responsive.sp(40),
                          AppColors.blackText,
                          FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(40)),

          // Login Button
          Container(
            width: double.infinity,
            height: responsive.hp(60),
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
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: AppColors.secondary,
                    )
                  : Text('Reset Password',
                      style: AppTextStyle.textStyle(responsive.sp(37),
                          AppColors.secondary, FontWeight.bold)),
            ),
          ),

          SizedBox(height: responsive.hp(10)),

          // Create Account
          Center(
            child: TextButton(
              onPressed: () {
                Get.to(LoginScreen());
              },
              child: Text('Login',
                  style: AppTextStyle.textStyle(
                      responsive.sp(35), AppColors.primary, FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
