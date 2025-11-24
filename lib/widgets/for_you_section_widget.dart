import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
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

    return Container(
      // margin: EdgeInsets.only(top: responsive.hp(30)),
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced For You Header
          _buildSectionHeader(responsive),
          // SizedBox(height: responsive.hp(2)),
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
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildForYouProductCard(products[index], context, index);
            },
          ),
          // Loading indicator at the bottom (same style as see_more_screen)
          if (controller.isForYouLoadingMore.value)
            Container(
              padding: EdgeInsets.only(
                left: responsive.wp(20),
                right: responsive.wp(20),
                top: responsive.hp(20),
                //+ MediaQuery.of(context).padding.bottom,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                  SizedBox(width: responsive.wp(15)),
                  Text(
                    'Loading more products...',
                    style: AppTextStyle.textStyle(
                      responsive.sp(32),
                      AppColors.greyText,
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  Widget _buildForYouProductCard(
      ProductItem product, BuildContext context, int index) {
    var responsive = Responsive(context);

    return GestureDetector(
      onTap: () async {
        await IsarService.instance
            .getProductWithAllRelations(product.id)
            .then((onValue) {
          Get.to(ProductDetailsScreen(product: product));
        });
        // Get.to(ProductDetailsScreen(product: product));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: responsive.hp(25)),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Enhanced Product Image
            Container(
              height: responsive.hp(160),
              width: responsive.wp(160),
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     AppColors.primary.withOpacity(0.1),
                //     AppColors.lightBlue.withOpacity(0.1),
                //   ],
                // ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(responsive.wp(15)),
                      child: Center(
                        child: Image.network(
                          product.thumbnail ?? "",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color:
                                    AppColors.greyBackground.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: responsive.sp(60),
                                color: AppColors.greyText,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Enhanced Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(responsive.wp(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name with better styling
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.textStyle(
                            responsive.sp(42),
                            AppColors.blackText,
                            FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: responsive.hp(8)),

                        // Product Description with improved styling
                        Text(
                          product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.textStyle(
                            responsive.sp(32),
                            AppColors.greyText,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: responsive.hp(15)),

                    // Price and Action Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Enhanced Price Display
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(15),
                            vertical: responsive.hp(8),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.15),
                                AppColors.lightBlue.withOpacity(0.15),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "\$${product.sellingPrice.round()}",
                            style: AppTextStyle.textStyle(
                              responsive.sp(44),
                              AppColors.primary,
                              FontWeight.w800,
                            ),
                          ),
                        ),

                        // Add to Cart Button
                        // Container(
                        //   padding: EdgeInsets.all(responsive.wp(12)),
                        //   decoration: BoxDecoration(
                        //     color: AppColors.primary,
                        //     borderRadius: BorderRadius.circular(12),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: AppColors.primary.withOpacity(0.3),
                        //         blurRadius: 8,
                        //         offset: const Offset(0, 3),
                        //       ),
                        //     ],
                        //   ),
                        //   child: Icon(
                        //     Icons.add_shopping_cart_rounded,
                        //     color: Colors.white,
                        //     size: responsive.sp(40),
                        //   ),
                        // ),
                      ],
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

  Widget _buildSectionHeader(Responsive responsive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "For You",
              style: AppTextStyle.textStyle(
                responsive.sp(50),
                AppColors.blackText,
                FontWeight.w800,
              ),
            ),
            SizedBox(height: responsive.hp(5)),
            Container(
              height: 4,
              width: responsive.wp(80),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.lightBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
        // Optional: View All button
        // Container(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: responsive.wp(15),
        //     vertical: responsive.hp(8),
        //   ),
        //   decoration: BoxDecoration(
        //     color: AppColors.primary.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(15),
        //     border: Border.all(
        //       color: AppColors.primary.withOpacity(0.3),
        //       width: 1,
        //     ),
        //   ),
        //   child: Text(
        //     "View All",
        //     style: AppTextStyle.textStyle(
        //       responsive.sp(28),
        //       AppColors.primary,
        //       FontWeight.w600,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
