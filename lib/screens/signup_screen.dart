import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:demoecommerceproduct/widgets/login_signup_appBar.dart';
import 'package:demoecommerceproduct/widgets/signup_form.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                        title: "Sign up\nand enjoy",
                      )),
                  Expanded(
                      flex: 6,
                      child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                          child: const SignupForm()))
                ],
              ),
            ),
          )),
    );
  }
}
