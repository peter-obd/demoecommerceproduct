import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:demoecommerceproduct/widgets/forgot_password_form.dart';
import 'package:demoecommerceproduct/widgets/login_form.dart';
import 'package:demoecommerceproduct/widgets/login_signup_appBar.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: AppColors.primary,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const Expanded(
                      flex: 2,
                      child: LoginSignupAppbar(
                        title: "Forgot\nPassword",
                      )),
                  Expanded(
                      flex: 4,
                      child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                          child: ForgotPasswordForm()))
                ],
              ),
            ),
          )),
    );
  }
}
