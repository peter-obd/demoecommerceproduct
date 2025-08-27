import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/product_model.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/screens/see_more_screen.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesItemsWidget extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    // return Scaffold(
    //   backgroundColor: AppColors.greyBackground,
    //   body:
    return Padding(
      padding: EdgeInsets.only(top: responsive.hp(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories Header
          Padding(
            padding: EdgeInsets.only(left: responsive.wp(40)),
            child: _buildCategoriesHeader(context),
          ),
          SizedBox(height: 20),

          // Products Grid
          Container(
            // color: Colors.amber,
            height: responsive.hp(330),
            child: _buildProductsGrid(context),
          ),

          // See More Button
          Obx(
            () => controller.productsOfCategory.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: _buildSeeMoreButton(
                      context,
                    ),
                  ),
          )
        ],
      ),
      // ),
    );
  }

  Widget _buildCategoriesHeader(BuildContext context) {
    var responsive = Responsive(context);
    return Container(
      height: responsive.hp(50),
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              final isSelected =
                  category.id == controller.selectedCategoryId.value;

              return GestureDetector(
                onTap: () =>
                    controller.getProductsByCategory(category.id, "3", "1"),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(category.name,
                          style: AppTextStyle.textStyle(
                              responsive.sp(35),
                              isSelected
                                  ? AppColors.primary
                                  : AppColors.greyShadow,
                              FontWeight.w700)),
                      SizedBox(height: responsive.hp(5)),
                      Container(
                        height: 3,
                        width: responsive.wp(100),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget _buildProductsGrid(BuildContext context) {
    var responsive = Responsive(context);
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );
      }

      final products = controller.productsOfCategory.value;

      if (products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: responsive.sp(100),
                color: AppColors.greyText,
              ),
              SizedBox(height: responsive.hp(10)),
              Text('No products found',
                  style: AppTextStyle.textStyle(
                      responsive.sp(35), AppColors.greyText, FontWeight.w700)),
            ],
          ),
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return index == 0
              ? Padding(
                  padding: EdgeInsets.only(
                      left: responsive.wp(40), bottom: responsive.hp(15)),
                  child: _buildMyProduct(products[index], context),
                )
              : Padding(
                  padding: EdgeInsets.only(bottom: responsive.hp(15)),
                  child: _buildMyProduct(products[index], context),
                );
        },
      );
    });
  }

  Widget _buildMyProduct(ProductItem product, BuildContext context) {
    var responsive = Responsive(context);
    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailsScreen(product: product));
      },
      child: Container(
        // height: responsive.hp(),
        margin: EdgeInsets.only(right: responsive.wp(20)),
        width: responsive.wp(200),

        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(top: responsive.hp(60)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ), // Applies radius to all four borders

                child: Column(children: [
                  Expanded(
                    child: SizedBox(),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: responsive.wp(15), left: responsive.wp(15)),
                      width: double.infinity,
                      child: Column(children: [
                        Text(product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.textStyle(responsive.sp(40),
                                AppColors.blackText, FontWeight.w500)),
                        SizedBox(height: responsive.hp(5)),
                        Text(product.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.textStyle(responsive.sp(30),
                                AppColors.greyText, FontWeight.w500)),
                        SizedBox(height: responsive.hp(10)),
                        Text("\$${product.cost.round()}",
                            style: AppTextStyle.textStyle(responsive.sp(35),
                                AppColors.primary, FontWeight.w600))
                      ]),
                    ),
                  )
                ]),
              ),
            ),
            Container(
              height: responsive.hp(160),
              width: responsive.wp(160),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,
              ),
              child: ClipOval(
                child: Image.network(
                  product.thumbnail ?? "",
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSeeMoreButton(
    BuildContext context,
  ) {
    var responsive = Responsive(context);
    return Container(
      margin: EdgeInsets.only(top: responsive.hp(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              // Handle see more action
              Get.to(SeeMoreScreen());
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('see more',
                    style: AppTextStyle.textStyle(
                        responsive.sp(33), AppColors.primary, FontWeight.w600)),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Usage Example in main.dart
