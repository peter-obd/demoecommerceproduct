import 'package:demoecommerceproduct/controllers/login_controller.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:demoecommerceproduct/widgets/login_form.dart';
import 'package:demoecommerceproduct/widgets/login_signup_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
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
                            title: "Welcome\nBack",
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
                              child: LoginForm()))
                    ],
                  ),
                ),
              )),
          Obx(
            () => loginController.isLoading.value
                ? Expanded(
                    child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )))
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}
