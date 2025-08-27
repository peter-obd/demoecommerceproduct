import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/controllers/signup_controller.dart';
import 'package:demoecommerceproduct/screens/login_screen.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _confirmObscurePassword = true;

  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Padding(
      padding: EdgeInsets.only(
          left: responsive.wp(40),
          right: responsive.wp(40),
          top: responsive.hp(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sing up',
              style: AppTextStyle.textStyle(
                  responsive.sp(50), AppColors.blackText, FontWeight.bold)),
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
                    color: AppColors.greyText,
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
                  scrollPadding: EdgeInsets.zero,
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
              SizedBox(height: responsive.hp(15)),
              Row(
                children: [
                  Image.asset(
                    "assets/icons/Lock.png",
                    height: responsive.hp(25),
                    width: responsive.wp(25),
                    color: AppColors.greyShadow,
                  ),
                  SizedBox(width: responsive.wp(10)),
                  Text('Confirm password',
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
                  obscureText: _confirmObscurePassword,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _confirmObscurePassword = !_confirmObscurePassword;
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

          SizedBox(height: responsive.hp(20)),

          // Login Button
          Container(
            width: double.infinity,
            height: responsive.hp(50),
            child: ElevatedButton(
                onPressed: () {
                  // Handle login
                  String fullPhoneNumber = '+961${_phoneController.text}';
                  print('Phone: $fullPhoneNumber');
                  print('Password: ${_passwordController.text}');
                  if (_phoneController.text.isEmpty) {
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
                    controller.signup(
                        fullPhoneNumber, context, _passwordController.text);
                  }

                  ;
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
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Singup',
                          style: AppTextStyle.textStyle(responsive.sp(35),
                              AppColors.secondary, FontWeight.bold)),
                )),
          ),

          SizedBox(height: responsive.hp(10)),

          // Create Account
          Center(
            child: TextButton(
              onPressed: () {
                Get.off(LoginScreen());
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
