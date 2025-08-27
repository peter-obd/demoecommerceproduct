import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:demoecommerceproduct/widgets/login_signup_appBar.dart';
import 'package:demoecommerceproduct/widgets/verify_otp_form.dart';
import 'package:flutter/material.dart';

class VerifyOtpScreen extends StatefulWidget {
  String phone;
  VerifyOtpScreen({super.key, required this.phone});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
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
                        title: "Reset\nPassword",
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
                          child: VerifyOtpForm(
                            phone: widget.phone,
                          )))
                ],
              ),
            ),
          )),
    );
  }
}
