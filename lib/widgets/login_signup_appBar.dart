import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';

class LoginSignupAppbar extends StatelessWidget {
  final String title;
  const LoginSignupAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Stack(
      children: [
        Container(
          color: AppColors.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            top: responsive.hp(30), left: responsive.wp(40)),
                        child: Image.asset("assets/images/roundedPurple.png")),
                    Container(
                        margin: EdgeInsets.only(right: responsive.wp(20)),
                        child: Image.asset("assets/images/roundedPink.png"))
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Container(
                        margin: EdgeInsets.only(
                            bottom: responsive.hp(30),
                            right: responsive.wp(40)),
                        child: Image.asset(
                            "assets/images/roundedPurpleLarge.png")),
                  ],
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            height: responsive.hp(150),
            width: responsive.wp(300),
            decoration: BoxDecoration(color: AppColors.primary, boxShadow: [
              BoxShadow(
                blurRadius: 20,
                spreadRadius: 20,
                color: AppColors.primary.withOpacity(0.9),
                offset: const Offset(0, -1),
              )
            ]),
            child: Text(
              title,
              style: AppTextStyle.titleStyle(responsive.sp(100)),
            ),
          ),
        )
      ],
    );
    ;
  }
}
