import 'package:demoecommerceproduct/controllers/login_controller.dart';
import 'package:demoecommerceproduct/screens/forgot_password_screen.dart';
import 'package:demoecommerceproduct/screens/home_screen.dart';
import 'package:demoecommerceproduct/screens/signup_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/route_manager.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  bool _obscurePassword = true;

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
            _buildLoginHeader(responsive),
            SizedBox(height: responsive.hp(20)),

            // Enhanced Phone Number Field
            _buildPhoneNumberField(responsive),

            // SizedBox(height: responsive.hp(20)),

            // Enhanced Password Field
            _buildPasswordField(responsive),
            // SizedBox(height: responsive.hp(15)),

            // Enhanced Forgot Password
            _buildForgotPasswordButton(responsive),

            SizedBox(height: responsive.hp(10)),

            // Enhanced Login Button
            _buildLoginButton(responsive),

            // SizedBox(height: responsive.hp(25)),

            // Enhanced Create Account Section
            _buildCreateAccountSection(responsive),

            SizedBox(height: responsive.hp(70)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginHeader(Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   padding: EdgeInsets.all(responsive.wp(15)),
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         AppColors.primary.withOpacity(0.1),
        //         AppColors.lightBlue.withOpacity(0.1),
        //       ],
        //     ),
        //     borderRadius: BorderRadius.circular(15),
        //   ),
        //   child: Icon(
        //     Icons.lock_person_rounded,
        //     color: AppColors.primary,
        //     size: responsive.sp(60),
        //   ),
        // ),
        // SizedBox(height: responsive.hp(20)),
        // Text(
        //   'Welcome Back!',
        //   style: AppTextStyle.textStyle(
        //     responsive.sp(60),
        //     AppColors.blackText,
        //     FontWeight.w900,
        //   ),
        // ),
        // SizedBox(height: responsive.hp(8)),
        Text(
          'Sign in to your account',
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
                    Icons.lock_rounded,
                    color: AppColors.primary,
                    size: responsive.sp(30),
                  ),
                ),
                SizedBox(width: responsive.wp(15)),
                Text(
                  'Password',
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
                hintText: 'Enter your password',
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

  Widget _buildForgotPasswordButton(Responsive responsive) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Get.to(ForgotPasswordScreen());
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(15),
            vertical: responsive.hp(5),
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Forgot Password?',
            style: AppTextStyle.textStyle(
              responsive.sp(29),
              AppColors.primary,
              FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(Responsive responsive) {
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
          // Handle login - keeping original functionality
          if (_phoneController.text.isEmpty ||
              _phoneController.text.length < 8) {
            Utils.showFlushbarError(
                context, "Make sure to enter your phone number");
          } else if (_passwordController.text.isEmpty) {
            Utils.showFlushbarError(
                context, "Make sure to enter your password");
          } else {
            loginController.login("+961${_phoneController.text}",
                _passwordController.text, context);
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
              Icons.login_rounded,
              color: Colors.white,
              size: responsive.sp(50),
            ),
            SizedBox(width: responsive.wp(15)),
            Text(
              'Login',
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

  Widget _buildCreateAccountSection(Responsive responsive) {
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
        // SizedBox(height: responsive.hp(2)),
        GestureDetector(
          onTap: () {
            Get.off(SignupScreen());
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: responsive.hp(13)),
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
                  Icons.person_add_rounded,
                  color: AppColors.primary,
                  size: responsive.sp(50),
                ),
                SizedBox(width: responsive.wp(15)),
                Text(
                  'Create Account',
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
