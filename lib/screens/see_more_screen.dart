import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/screens/search_screen.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeeMoreScreen extends StatefulWidget {
  const SeeMoreScreen({super.key});

  @override
  State<SeeMoreScreen> createState() => _SeeMoreScreenState();
}

class _SeeMoreScreenState extends State<SeeMoreScreen> {
  final HomeController controller = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (controller.callFunction.value &&
          controller.isScrollLoading.value == false) {
        controller.pageNumber.value += 1;
        if (controller.hasNextPage.value) {
          controller.loadMoreProducts(
              context,
              controller.selectedCategoryId.value,
              "6",
              controller.pageNumber.value.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Column(
        children: [
          // Enhanced Header
          _buildEnhancedHeader(responsive),
          // Enhanced Categories Header
          _buildEnhancedCategoriesSection(responsive),
          // Enhanced Products Grid
          Expanded(
            child: _buildEnhancedProductsGrid(responsive),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(Responsive responsive) {
    return Container(
      height: responsive.hp(140),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(20)),
          child: Row(
            children: [
              // Enhanced Back Button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(responsive.wp(12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: AppColors.blackText,
                    size: responsive.sp(45),
                  ),
                ),
              ),
              SizedBox(width: responsive.wp(15)),

              // Enhanced Search Bar
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(const SearchScreen()),
                  child: Container(
                    height: responsive.hp(60),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: responsive.wp(20)),
                        Container(
                          padding: EdgeInsets.all(responsive.wp(8)),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.search,
                            color: AppColors.primary,
                            size: responsive.sp(35),
                          ),
                        ),
                        SizedBox(width: responsive.wp(15)),
                        Expanded(
                          child: Text(
                            "Search products...",
                            style: AppTextStyle.textStyle(
                              responsive.sp(32),
                              AppColors.greyText,
                              FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: responsive.wp(15)),
                          padding: EdgeInsets.all(responsive.wp(8)),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: responsive.sp(35),
                          ),
                        ),
                      ],
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

  Widget _buildEnhancedCategoriesSection(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(
        // top: responsive.hp(20),
        bottom: responsive.hp(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(20)),
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
                      onTap: () {
                        if (controller.isLoading.value == false &&
                            controller.isScrollLoading.value == false) {
                          controller.getProductsByCategory(
                              category.id, "6", "1");
                        }
                      },
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
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: isSelected
                          //         ? AppColors.primary.withOpacity(0.3)
                          //         : Colors.black.withOpacity(0.05),
                          //     blurRadius: isSelected ? 12 : 6,
                          //     offset: Offset(0, isSelected ? 4 : 2),
                          //     spreadRadius: isSelected ? 0.5 : 0,
                          //   ),
                          // ],
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
      ),
    );
  }

  Widget _buildEnhancedProductsGrid(Responsive responsive) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildEnhancedLoadingState(responsive);
      }

      final products = controller.productsOfCategory;

      if (products.isEmpty) {
        return _buildEnhancedEmptyState(responsive);
      }

      return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(20),
            // vertical: responsive.hp(10),
          ),
          child: Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: responsive.wp(15),
                      mainAxisSpacing: responsive.hp(15),
                      childAspectRatio: 0.7,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () async {
                          final onValue = await IsarService.instance
                              .getProductWithAllRelations(product.id);
                          Get.to(ProductDetailsScreen(product: onValue!));
                        },
                        child: EnhancedProductCard(
                          product: product,
                          responsive: responsive,
                        ),
                      );
                    },
                  ),

                  /// ---- Loading more at the BOTTOM ----
                  if (controller.isScrollLoading.value)
                    Container(
                      padding: EdgeInsets.only(
                        left: responsive.wp(20),
                        right: responsive.wp(20),
                        top: responsive.hp(20),
                        bottom: responsive.hp(20) +
                            MediaQuery.of(context).padding.bottom,
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
              ),
            ),
          )
          // Column(
          //   children: [
          //     Expanded(
          //       child: GridView.builder(
          //         controller: _scrollController,
          //         physics: const BouncingScrollPhysics(),
          //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 2,
          //           crossAxisSpacing: responsive.wp(15),
          //           mainAxisSpacing: responsive.hp(15),
          //           childAspectRatio: 0.7,
          //         ),
          //         itemCount: products.length,
          //         itemBuilder: (context, index) {
          //           final product = products[index];
          //           return GestureDetector(
          //             onTap: () async {
          //               await IsarService.instance
          //                   .getProductWithAllRelations(product.id)
          //                   .then((onValue) {
          //                 Get.to(ProductDetailsScreen(product: onValue!));
          //               });
          //               // Get.to(ProductDetailsScreen(product: product));
          //             },
          //             child: EnhancedProductCard(
          //               product: product,
          //               responsive: responsive,
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //     if (controller.isScrollLoading.value)
          //       Container(
          //         padding: EdgeInsets.only(
          //           left: responsive.wp(20),
          //           right: responsive.wp(20),
          //           top: responsive.hp(20),
          //           bottom:
          //               responsive.hp(20) + MediaQuery.of(context).padding.bottom,
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             const CircularProgressIndicator(
          //               color: AppColors.primary,
          //               strokeWidth: 2,
          //             ),
          //             SizedBox(width: responsive.wp(15)),
          //             Text(
          //               'Loading more products...',
          //               style: AppTextStyle.textStyle(
          //                 responsive.sp(32),
          //                 AppColors.greyText,
          //                 FontWeight.w500,
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
          //   ],
          // ),
          );
    });
  }

  Widget _buildEnhancedLoadingState(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(40)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(responsive.wp(30)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
                SizedBox(height: responsive.hp(20)),
                Text(
                  'Loading Products...',
                  style: AppTextStyle.textStyle(
                    responsive.sp(40),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
                Text(
                  'Please wait while we fetch the latest products',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle(
                    responsive.sp(30),
                    AppColors.greyText,
                    FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedEmptyState(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(40)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(responsive.wp(40)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.lightBlue.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: responsive.sp(120),
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: responsive.hp(30)),
          Text(
            'No Products Found',
            style: AppTextStyle.textStyle(
              responsive.sp(50),
              AppColors.blackText,
              FontWeight.w800,
            ),
          ),
          SizedBox(height: responsive.hp(10)),
          Text(
            'Sorry, we couldn\'t find any products in this category. Try selecting a different category or check back later.',
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle(
              responsive.sp(35),
              AppColors.greyText,
              FontWeight.w400,
            ),
          ),
          SizedBox(height: responsive.hp(30)),
          GestureDetector(
            onTap: () => Get.to(const SearchScreen()),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(30),
                vertical: responsive.hp(15),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: responsive.sp(45),
                  ),
                  SizedBox(width: responsive.wp(10)),
                  Text(
                    'Search Products',
                    style: AppTextStyle.textStyle(
                      responsive.sp(38),
                      Colors.white,
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced Product Card Widget
class EnhancedProductCard extends StatelessWidget {
  final ProductItem product;
  final Responsive responsive;

  const EnhancedProductCard({
    super.key,
    required this.product,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Image Section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.05),
                    AppColors.lightBlue.withOpacity(0.05),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Background Pattern
                  const Positioned(
                    top: -10,
                    right: -10,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  // Product Image
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(responsive.wp(15)),
                      child: Image.network(
                        product.thumbnail ?? "",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.greyBackground.withOpacity(0.5),
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
                  // Favorite Button
                  // Positioned(
                  //   top: responsive.hp(10),
                  //   right: responsive.wp(10),
                  //   child: Container(
                  //     padding: EdgeInsets.all(responsive.wp(8)),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       shape: BoxShape.circle,
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withOpacity(0.1),
                  //           blurRadius: 8,
                  //           offset: const Offset(0, 2),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Icon(
                  //       Icons.favorite_border_rounded,
                  //       color: AppColors.greyText,
                  //       size: responsive.sp(30),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Enhanced Product Info Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(
                  left: responsive.wp(15),
                  right: responsive.wp(15),
                  top: responsive.hp(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.textStyle(
                      responsive.sp(36),
                      AppColors.blackText,
                      FontWeight.w600,
                    ),
                  ),
                  // Price and Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Enhanced Price Display
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(12),
                          // vertical: responsive.hp(6),
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
                            responsive.sp(38),
                            AppColors.primary,
                            FontWeight.w800,
                          ),
                        ),
                      ),
                      // Add to Cart Button
                      // Container(
                      //   padding: EdgeInsets.all(responsive.wp(10)),
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
                      //     size: responsive.sp(35),
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
    );
  }
}
