import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/models/category_model.dart';
import 'package:demoecommerceproduct/screens/help_support_screen.dart';
import 'package:demoecommerceproduct/screens/search_screen.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:demoecommerceproduct/widgets/for_you_section_widget.dart';
import 'package:demoecommerceproduct/widgets/home_categories_products_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  final HomeController controller = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        controller.forYouProducts.isNotEmpty) {
      // User has scrolled to the bottom, load more products
      controller.loadMoreForYouProducts(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.greyBackground,
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(children: [
              // App Header with gradient
              _buildAppHeader(responsive, context),

              // Hero Banner Section
              _buildHeroBanner(responsive, context),

              // Categories and Products Section
              SizedBox(
                  height: responsive.hp(476), child: CategoriesItemsWidget()),

              // For You Section with enhanced spacing
              const ForYouSectionWidget(),

              // Bottom Spacing
              SizedBox(height: responsive.hp(60)),
            ]),
          ),
        ),
        // Enhanced Loading Overlay
        // Obx(
        //   () => controller.isForYouuLoadingg.value
        //       ? Container(
        //           color: Colors.black.withOpacity(0.6),
        //           child: Center(
        //             child: Container(
        //               padding: EdgeInsets.all(20),
        //               decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(15),
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color: Colors.black.withOpacity(0.1),
        //                     blurRadius: 10,
        //                     spreadRadius: 2,
        //                   ),
        //                 ],
        //               ),
        //               child: Column(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   CircularProgressIndicator(
        //                     color: AppColors.primary,
        //                     strokeWidth: 3,
        //                   ),
        //                   SizedBox(height: 15),
        //                   Text(
        //                     'Loading more products...',
        //                     style: AppTextStyle.textStyle(
        //                         14, AppColors.blackText, FontWeight.w500),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         )
        //       : Container(),
        // )
      ],
    );
  }

  Widget _buildAppHeader(Responsive responsive, BuildContext context) {
    return Container(
      height: responsive.hp(131),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(20),
            vertical: responsive.hp(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // App Logo/Brand
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'One Dollar',
                    style: AppTextStyle.textStyle(
                      responsive.sp(48),
                      AppColors.primary,
                      FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Your shopping companion',
                    style: AppTextStyle.textStyle(
                      responsive.sp(28),
                      AppColors.greyText,
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
              // Notification Icon
              GestureDetector(
                onTap: () => Get.to(const HelpSupportScreen()),
                child: Container(
                  padding: EdgeInsets.all(responsive.wp(12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.help_outline_outlined,
                    color: AppColors.primary,
                    size: responsive.sp(50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(Responsive responsive, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.wp(20),
        vertical: responsive.hp(20),
      ),
      child: Column(
        children: [
          // Enhanced Search Bar
          _buildEnhancedSearchBar(responsive),

          SizedBox(height: responsive.hp(30)),

          // Promotional Banner
          _buildPromotionalBanner(responsive),
        ],
      ),
    );
  }

  Widget _buildEnhancedSearchBar(Responsive responsive) {
    return GestureDetector(
      onTap: () {
        Get.to(SearchScreen());
      },
      child: Container(
        height: responsive.hp(70),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5),
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
                size: responsive.sp(45),
              ),
            ),
            SizedBox(width: responsive.wp(15)),
            Expanded(
              child: Text(
                "Search for products, brands, and more...",
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
                size: responsive.sp(40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionalBanner(Responsive responsive) {
    return Container(
      height: responsive.hp(180),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
            AppColors.lightBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: responsive.wp(150),
              height: responsive.hp(150),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: -50,
            bottom: -30,
            child: Container(
              width: responsive.wp(100),
              height: responsive.hp(100),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(responsive.wp(10)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "🎉 Special Offer!",
                        style: AppTextStyle.textStyle(
                          responsive.sp(35),
                          Colors.white,
                          FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: responsive.hp(8)),
                      Text(
                        "Order online\nCollect in store",
                        style: AppTextStyle.textStyle(
                          responsive.sp(48),
                          Colors.white,
                          FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: responsive.hp(10)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(15),
                          vertical: responsive.hp(8),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "Free delivery on orders over \$50",
                          style: AppTextStyle.textStyle(
                            responsive.sp(26),
                            Colors.white,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Shopping bag icon
                Container(
                  padding: EdgeInsets.all(responsive.wp(20)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: responsive.sp(80),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
