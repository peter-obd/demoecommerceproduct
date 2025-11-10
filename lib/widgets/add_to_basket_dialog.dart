import 'package:flutter/material.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:demoecommerceproduct/values/colors.dart';

class AddToBasketDialog extends StatelessWidget {
  final VoidCallback onViewBasket;
  final VoidCallback onBack;

  const AddToBasketDialog({
    super.key,
    required this.onViewBasket,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Dialog(
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
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_rounded,
                color: AppColors.primary,
                size: responsive.wp(50),
              ),
            ),

            SizedBox(height: responsive.hp(20)),

            // Success Title
            Text(
              'Added to Basket!',
              style: TextStyle(
                fontSize: responsive.sp(27),
                fontWeight: FontWeight.bold,
                color: AppColors.blackText,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: responsive.hp(10)),

            // Success Message
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(10)),
              child: Text(
                'Item added to basket successfully!!',
                style: TextStyle(
                  fontSize: responsive.sp(25),
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: responsive.hp(30)),

            // Buttons Row
            Row(
              children: [
                // Back Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.hp(16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.wp(12)),
                      ),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: responsive.sp(25),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: responsive.wp(12)),

                // View Basket Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onViewBasket,
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
                      'View Basket',
                      style: TextStyle(
                        fontSize: responsive.sp(25),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
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
}
