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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _confirmObscurePassword = true;

  final SignupController controller = Get.put(SignupController());

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
            _buildSignupHeader(responsive),
            SizedBox(height: responsive.hp(20)),
            _buildNameField(responsive),
            _buildLastNameField(responsive),
            // Enhanced Phone Number Field
            _buildPhoneNumberField(responsive),

            // Enhanced Password Field
            _buildPasswordField(responsive),

            // Enhanced Confirm Password Field
            _buildConfirmPasswordField(responsive),

            // SizedBox(height: responsive.hp(10)),

            // Enhanced Signup Button
            _buildSignupButton(responsive),

            // Enhanced Login Section
            _buildLoginSection(responsive),
            SizedBox(height: responsive.hp(70)),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupHeader(Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create your account',
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

  Widget _buildNameField(Responsive responsive) {
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
                    Icons.panorama_fish_eye_outlined,
                    color: AppColors.primary,
                    size: responsive.sp(30),
                  ),
                ),
                SizedBox(width: responsive.wp(15)),
                Text(
                  'First Name',
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
              controller: _nameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your first name',
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
          ],
        ),
      ),
    );
  }

  Widget _buildLastNameField(Responsive responsive) {
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
                    Icons.panorama_fish_eye_outlined,
                    color: AppColors.primary,
                    size: responsive.sp(30),
                  ),
                ),
                SizedBox(width: responsive.wp(15)),
                Text(
                  'Last Name',
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
              controller: _lastNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your last name',
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
                  'Confirm Password',
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
                hintText: 'Confirm your password',
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

  Widget _buildSignupButton(Responsive responsive) {
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
          if (_phoneController.text.isEmpty ||
              _phoneController.text.length < 8) {
            Utils.showFlushbarError(
                context, "Make sure to enter your phone number");
          } else if (_lastNameController.text.isEmpty) {
            Utils.showFlushbarError(
                context, "Make sure to enter your last name");
          } else if (_nameController.text.isEmpty) {
            Utils.showFlushbarError(
                context, "Make sure to enter your first name");
          } else if (!controller.isValidPassword(_passwordController.text)) {
            Utils.showFlushbarError(context,
                "Password must be atleast 6 charachters and must have at least one number and one capital letter");
          } else if (_confirmPasswordController.text !=
              _passwordController.text) {
            Utils.showFlushbarError(
                context, "Password and Confirm Password must be same");
          } else {
            controller.signup(
                fullPhoneNumber,
                context,
                _passwordController.text,
                _nameController.text,
                _lastNameController.text);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Obx(
          () => controller.isLoading.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                    SizedBox(width: responsive.wp(15)),
                    Text(
                      'Creating Account...',
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
                      Icons.person_add_rounded,
                      color: Colors.white,
                      size: responsive.sp(50),
                    ),
                    SizedBox(width: responsive.wp(15)),
                    Text(
                      'Sign Up',
                      style: AppTextStyle.textStyle(
                        responsive.sp(42),
                        Colors.white,
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLoginSection(Responsive responsive) {
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
            padding: EdgeInsets.symmetric(vertical: responsive.hp(16)),
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
                  Icons.login_rounded,
                  color: AppColors.primary,
                  size: responsive.sp(50),
                ),
                SizedBox(width: responsive.wp(15)),
                Text(
                  'Already have an account?',
                  style: AppTextStyle.textStyle(
                    responsive.sp(35),
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
