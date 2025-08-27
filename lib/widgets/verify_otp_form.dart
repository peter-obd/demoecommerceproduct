import 'package:demoecommerceproduct/controllers/verify_controller.dart';
import 'package:demoecommerceproduct/screens/login_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VerifyOtpForm extends StatefulWidget {
  String phone;
  VerifyOtpForm({super.key, required this.phone});

  @override
  State<VerifyOtpForm> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends State<VerifyOtpForm> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _OTPController = TextEditingController();
  final VerifyController controller = Get.put(VerifyController());
  bool _obscurePassword = true;
  bool _confirmobscurePassword = true;

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
          Text('OTP sent',
              style: AppTextStyle.textStyle(
                  responsive.sp(50), AppColors.blackText, FontWeight.bold)),
          SizedBox(height: responsive.hp(30)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/icons/Activity.png",
                    height: responsive.hp(23),
                    width: responsive.wp(23),
                    color: AppColors.greyShadow,
                  ),
                  SizedBox(width: responsive.wp(10)),
                  Text('OTP',
                      style: AppTextStyle.textStyle(responsive.sp(30),
                          AppColors.greyText, FontWeight.normal)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.greyShadow,
                      width: 1,
                    ),
                  ),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _OTPController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: responsive.sp(25),
                    color: Colors.black,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(25)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/icons/Lock.png",
                    height: responsive.hp(25),
                    width: responsive.wp(25),
                    color: AppColors.greyShadow,
                  ),
                  SizedBox(width: responsive.wp(10)),
                  Text('Password',
                      style: AppTextStyle.textStyle(responsive.sp(30),
                          AppColors.greyText, FontWeight.normal)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.greyShadow,
                      width: 1,
                    ),
                  ),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Text('Show',
                          style: AppTextStyle.textStyle(responsive.sp(30),
                              AppColors.primary, FontWeight.w600)),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: responsive.sp(25),
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(25)),

          // Password Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/icons/Lock.png",
                    height: responsive.hp(25),
                    width: responsive.wp(25),
                    color: AppColors.greyShadow,
                  ),
                  SizedBox(width: responsive.wp(10)),
                  Text('Confirm Password',
                      style: AppTextStyle.textStyle(responsive.sp(30),
                          AppColors.greyText, FontWeight.normal)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.greyShadow,
                      width: 1,
                    ),
                  ),
                ),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: _confirmobscurePassword,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _confirmobscurePassword = !_confirmobscurePassword;
                        });
                      },
                      child: Text('Show',
                          style: AppTextStyle.textStyle(responsive.sp(30),
                              AppColors.primary, FontWeight.w600)),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: responsive.sp(25),
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(10)),

          // Forgot Password

          SizedBox(height: responsive.hp(20)),

          // Login Button
          Container(
            width: double.infinity,
            height: responsive.hp(50),
            child: ElevatedButton(
                onPressed: () {
                  // Handle login
                  // String fullPhoneNumber = '+961${_phoneController.text}';
                  // print('Phone: $fullPhoneNumber');
                  // print('Password: ${_passwordController.text}');
                  // Get.off(HomeScreen());
                  if (_OTPController.text.isEmpty) {
                    Utils.showFlushbarError(
                        context, "Make sure to enter your phone number");
                  } else if (!controller
                      .isValidPassword(_passwordController.text)) {
                    Utils.showFlushbarError(context,
                        "Password must be atleast 6 charachters and must have at least one number and one capital letter");
                  } else if (_confirmPasswordController.text !=
                      _passwordController.text) {
                    Utils.showFlushbarError(
                        context, "Password and Confirm Password must be same");
                  } else {
                    controller.isLoading.value = true;
                    ApisService.resetPassword(widget.phone, _OTPController.text,
                        _passwordController.text, (success) {
                      controller.isLoading.value = false;
                      Utils.showFlushbarSuccess(context, success);
                      Get.offAll(LoginScreen());
                    }, (fail) {
                      controller.isLoading.value = false;
                      Utils.showFlushbarError(context, fail.message);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Obx(
                  () => controller.isLoading.value
                      ? CircularProgressIndicator(
                          color: AppColors.secondary,
                        )
                      : Text('Reset',
                          style: AppTextStyle.textStyle(responsive.sp(35),
                              AppColors.secondary, FontWeight.bold)),
                )),
          ),

          SizedBox(height: responsive.hp(10)),

          // Create Account
          Center(
            child: TextButton(
                onPressed: () {
                  // Handle create account
                  // Get.off(SignupScreen());
                  controller.isResendLoading.value = true;
                  ApisService.resendPasswordResetOtp(widget.phone, (success) {
                    controller.isResendLoading.value = false;
                    Utils.showFlushbarSuccess(context, success);
                  }, (fail) {
                    controller.isResendLoading.value = false;
                    Utils.showFlushbarError(context, fail.message);
                  });
                },
                child: Obx(
                  () => controller.isResendLoading.value
                      ? CircularProgressIndicator(
                          color: AppColors.primary,
                        )
                      : Text('resend OTP',
                          style: AppTextStyle.textStyle(responsive.sp(35),
                              AppColors.primary, FontWeight.bold)),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
