import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForYouSectionWidget extends StatefulWidget {
  const ForYouSectionWidget({super.key});

  @override
  State<ForYouSectionWidget> createState() => _ForYouSectionWidgetState();
}

class _ForYouSectionWidgetState extends State<ForYouSectionWidget> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // For You Header
          Text(
            "For You",
            style: AppTextStyle.textStyle(
              responsive.sp(45),
              AppColors.blackText,
              FontWeight.w700,
            ),
          ),

          // Products List
          _buildForYouProducts(context),
        ],
      ),
    );
  }

  Widget _buildForYouProducts(BuildContext context) {
    var responsive = Responsive(context);

    return Obx(() {
      final products = controller.forYouProducts;

      if (products.isEmpty) {
        return SizedBox(
          height: responsive.hp(200),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.recommend_outlined,
                  size: responsive.sp(100),
                  color: AppColors.greyText,
                ),
                SizedBox(height: responsive.hp(10)),
                Text(
                  'No recommendations yet',
                  style: AppTextStyle.textStyle(
                    responsive.sp(35),
                    AppColors.greyText,
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length +
                (controller.isForYouLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == products.length) {
                // Loading indicator at the bottom
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                );
              }
              return _buildForYouProductCard(products[index], context, index);
            },
          ),
        ],
      );
    });
  }

  Widget _buildForYouProductCard(
      ProductItem product, BuildContext context, int index) {
    var responsive = Responsive(context);

    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailsScreen(product: product));
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: responsive.hp(20),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              height: responsive.hp(150),
              width: responsive.wp(150),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: Image.network(
                  product.thumbnail ?? "",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.greyBackground,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: AppColors.greyText,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(responsive.wp(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.textStyle(
                        responsive.sp(40),
                        AppColors.blackText,
                        FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: responsive.hp(8)),

                    // Product Description
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.textStyle(
                        responsive.sp(34),
                        AppColors.greyText,
                        FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: responsive.hp(12)),

                    // Product Price
                    Text(
                      "\$${product.cost.round()}",
                      style: AppTextStyle.textStyle(
                        responsive.sp(44),
                        AppColors.primary,
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
