import 'package:flutter/material.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:demoecommerceproduct/values/colors.dart';

class OrderSuccessDialog extends StatelessWidget {
  final VoidCallback onOkPressed;

  const OrderSuccessDialog({
    super.key,
    required this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return PopScope(
      canPop: false, // Prevent dismissal by back button
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.wp(20)),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(responsive.wp(20)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(responsive.wp(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: responsive.wp(20),
                offset: Offset(0, responsive.hp(10)),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon with Animation
              Container(
                width: responsive.wp(100),
                height: responsive.wp(100),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: responsive.wp(60),
                ),
              ),

              SizedBox(height: responsive.hp(20)),

              // Success Title
              Text(
                'Order Placed!',
                style: TextStyle(
                  fontSize: responsive.sp(24),
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackText,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: responsive.hp(12)),

              // Success Message
              Text(
                'Successfully ordered!!',
                style: TextStyle(
                  fontSize: responsive.sp(25),
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: responsive.hp(8)),

              // Additional Message
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(10)),
                child: Text(
                  'Your order has been successfully placed and is being processed.',
                  style: TextStyle(
                    fontSize: responsive.sp(22),
                    color: AppColors.greyText,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: responsive.hp(30)),

              // OK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onOkPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.hp(16),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(responsive.wp(12)),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: responsive.sp(25),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
