import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/product_model.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/screens/see_more_screen.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
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
      padding: EdgeInsets.only(top: responsive.hp(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories Header
          Padding(
            padding: EdgeInsets.only(left: responsive.wp(0)),
            child: _buildCategoriesHeader(context),
          ),
          SizedBox(height: responsive.hp(20)),

          // Products Grid
          Container(
            // color: Colors.amber,
            height: responsive.hp(300),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: EdgeInsets.only(left: responsive.wp(20)),
          child: Text(
            "Categories",
            style: AppTextStyle.textStyle(
              responsive.sp(45),
              AppColors.blackText,
              FontWeight.w800,
            ),
          ),
        ),
        SizedBox(height: responsive.hp(15)),
        // Scrollable Categories List
        SizedBox(
          height: responsive.hp(50),
          child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(left: responsive.wp(20)),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  final isSelected =
                      category.id == controller.selectedCategoryId.value;

                  return GestureDetector(
                    onTap: () =>
                        controller.getProductsByCategory(category.id, "3", "1"),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(
                        right: responsive.wp(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(20),
                        vertical: responsive.hp(12),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.greyShadow.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.3)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: isSelected ? 12 : 6,
                            offset: Offset(0, isSelected ? 4 : 2),
                            spreadRadius: isSelected ? 0.5 : 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          category.name,
                          style: AppTextStyle.textStyle(
                            responsive.sp(32),
                            isSelected ? Colors.white : AppColors.blackText,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
        ),
      ],
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
                      left: responsive.wp(20), bottom: responsive.hp(15)),
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
      onTap: () async {
        await IsarService.instance
            .getProductWithAllRelations(product.id)
            .then((onValue) {
          Get.to(ProductDetailsScreen(product: product));
        });
        // Get.to(ProductDetailsScreen(product: product));
      },
      child: Container(
        margin: EdgeInsets.only(right: responsive.wp(20)),
        width: responsive.wp(200),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Main Card
            Padding(
              padding: EdgeInsets.only(top: responsive.hp(70)),
              child: Container(
                height: responsive.hp(280),
                width: responsive.wp(200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
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
                child: Column(
                  children: [
                    // Top spacing for image
                    SizedBox(height: responsive.hp(80)),
                    // Product Info
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(15),
                          vertical: responsive.hp(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Product Name
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.textStyle(
                                responsive.sp(38),
                                AppColors.blackText,
                                FontWeight.w600,
                              ),
                            ),
                            // Product Description
                            Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.textStyle(
                                responsive.sp(28),
                                AppColors.greyText,
                                FontWeight.w400,
                              ),
                            ),
                            // Price with background
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(15),
                                vertical: responsive.hp(8),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "\$${product.sellingPrice.round()}",
                                style: AppTextStyle.textStyle(
                                  responsive.sp(40),
                                  AppColors.primary,
                                  FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Product Image with enhanced styling
            Container(
              height: responsive.hp(140),
              width: responsive.wp(140),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.1),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Container(
                  padding: EdgeInsets.all(responsive.wp(10)),
                  child: Image.network(
                    product.thumbnail ?? "",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyBackground,
                          shape: BoxShape.circle,
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
            // Favorite Icon (optional)
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
