import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:demoecommerceproduct/widgets/change_password_form.dart';
import 'package:demoecommerceproduct/widgets/change_phone_number_form.dart';
import 'package:demoecommerceproduct/widgets/edit_prodile_form.dart';
import 'package:demoecommerceproduct/widgets/login_signup_appBar.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  bool isChangeNumber;

  EditProfileScreen({
    super.key,
    required this.isChangeNumber,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
                        title: "Edit\nProfile",
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
                          child: widget.isChangeNumber
                              ? EditProfileChangeNumberForm()
                              : EditProfileChangePasswordForm()))
                ],
              ),
            ),
          )),
    );
  }
}
