import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/screens/search_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesPage extends StatefulWidget {
  final List<ProductItem> products;
  const FavoritesPage({super.key, required this.products});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Stack(
        children: [
          Column(
            children: [
              // Enhanced Header
              _buildEnhancedHeader(responsive),

              // Enhanced Body Content
              Obx(
                () => Expanded(
                  child: !homeController.isFavoritesEmpty.value
                      ? _buildFavoritesContent(responsive)
                      : _buildEmptyFavoritesState(responsive),
                ),
              )
            ],
          ),
          Obx(() => homeController.isFavoritesLoading.value
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(responsive.wp(40)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: responsive.hp(20)),
                          Text(
                            'Loading Your Favorites',
                            style: AppTextStyle.textStyle(
                              responsive.sp(40),
                              AppColors.blackText,
                              FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: responsive.hp(8)),
                          Text(
                            'Please wait...',
                            style: AppTextStyle.textStyle(
                              responsive.sp(32),
                              AppColors.greyText,
                              FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink())
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(Responsive responsive) {
    return Container(
      height: responsive.hp(120),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(20)),
          child: Row(
            children: [
              // Favorites Icon
              Container(
                padding: EdgeInsets.all(responsive.wp(12)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: responsive.sp(45),
                ),
              ),
              SizedBox(width: responsive.wp(15)),

              // Title Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'My Favorites',
                      style: AppTextStyle.textStyle(
                        responsive.sp(50),
                        Colors.white,
                        FontWeight.w800,
                      ),
                    ),
                    Text(
                      "Favorites",
                      // !homeController.isFavoritesEmpty.value
                      //     ? '${homeController.favoriteProducts.length} favorites items'
                      //     : 'No favorites yet',
                      style: AppTextStyle.textStyle(
                        responsive.sp(32),
                        Colors.white.withOpacity(0.9),
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Clear All Button (only show when favorites has items)
              if (!homeController.isFavoritesEmpty.value)
                GestureDetector(
                  onTap: () => _showClearFavoritesDialog(responsive),
                  child: Container(
                    padding: EdgeInsets.all(responsive.wp(12)),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.delete_sweep_rounded,
                      color: Colors.white,
                      size: responsive.sp(45),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesContent(Responsive responsive) {
    return Column(
      children: [
        // Favorites List
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(10)),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: responsive.hp(20)),
              itemCount: homeController.favoriteProducts.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key('fav_${homeController.favoriteProducts[index].id}'),
                  onDismissed: (direction) {
                    // setState(() {
                    //   homeController.favoriteProducts.removeAt(index);
                    // });
                    // Handle remove from favorites
                    if (homeController.favoriteProducts.length == 1) {
                      homeController.isFavoritesEmpty.value = true;
                    }
                    ApisService.toggleFavoriteProduct(
                      homeController.favoriteProducts[index].id,
                      false,
                      (success) {
                        if (success) {}
                      },
                      (error) {
                        debugPrint("Error deleting favorite: ${error.message}");
                        // Revert state if API call failed
                      },
                    );
                  },
                  background: _buildDismissBackground(),
                  child: EnhancedFavoriteCard(
                    product: homeController.favoriteProducts[index],
                    responsive: responsive,
                    homeController: homeController,
                  ),
                );
              },
            ),
          ),
        ),

        // Enhanced Add All to Basket Section
        // _buildEnhancedAddAllSection(responsive),
      ],
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 30),
            child: Icon(
              Icons.favorite_border_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAddAllSection(Responsive responsive) {
    return Column(
      children: [
        // Favorites Summary
        // Row(
        //   children: [
        //     Container(
        //       padding: EdgeInsets.all(responsive.wp(12)),
        //       decoration: BoxDecoration(
        //         color: AppColors.primary.withOpacity(0.1),
        //         borderRadius: BorderRadius.circular(15),
        //       ),
        //       child: Icon(
        //         Icons.favorite_rounded,
        //         color: AppColors.primary,
        //         size: responsive.sp(40),
        //       ),
        //     ),
        //     SizedBox(width: responsive.wp(15)),
        //     // Expanded(
        //     //   child: Column(
        //     //     crossAxisAlignment: CrossAxisAlignment.start,
        //     //     children: [
        //     //       Text(
        //     //         '${widget.products.length} Favorite Items',
        //     //         style: AppTextStyle.textStyle(
        //     //           responsive.sp(40),
        //     //           AppColors.blackText,
        //     //           FontWeight.w700,
        //     //         ),
        //     //       ),
        //     //       Text(
        //     //         'Add all to your basket',
        //     //         style: AppTextStyle.textStyle(
        //     //           responsive.sp(30),
        //     //           AppColors.greyText,
        //     //           FontWeight.w400,
        //     //         ),
        //     //       ),
        //     //     ],
        //     //   ),
        //     // ),
        //   ],
        // ),

        // SizedBox(height: responsive.hp(20)),

        // Enhanced Add All Button
        Container(
          margin: EdgeInsets.all(responsive.wp(15)),
          width: double.infinity,
          height: responsive.hp(70),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              // Handle add all to basket
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_shopping_cart_rounded,
                  color: Colors.white,
                  size: responsive.sp(45),
                ),
                SizedBox(width: responsive.wp(15)),
                Text(
                  'Add All to Basket',
                  style: AppTextStyle.textStyle(
                    responsive.sp(40),
                    Colors.white,
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyFavoritesState(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(40)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Enhanced Empty Icon
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
              Icons.favorite_border_rounded,
              size: responsive.sp(120),
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: responsive.hp(30)),

          Text(
            'No Favorite Products',
            style: AppTextStyle.textStyle(
              responsive.sp(50),
              AppColors.blackText,
              FontWeight.w800,
            ),
          ),

          SizedBox(height: responsive.hp(15)),

          Text(
            'Start adding products to your favorites by tapping the heart icon on product cards. Your favorite items will appear here!',
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle(
              responsive.sp(35),
              AppColors.greyText,
              FontWeight.w400,
            ),
          ),

          SizedBox(height: responsive.hp(40)),

          // Enhanced Browse Products Button
          Container(
            width: double.infinity,
            height: responsive.hp(60),
            margin: EdgeInsets.symmetric(horizontal: responsive.wp(20)),
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
            child: ElevatedButton(
              onPressed: () => Get.to(const SearchScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: responsive.sp(45),
                  ),
                  SizedBox(width: responsive.wp(15)),
                  Text(
                    'Browse Products',
                    style: AppTextStyle.textStyle(
                      responsive.sp(37),
                      Colors.white,
                      FontWeight.w700,
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

  void _showClearFavoritesDialog(Responsive responsive) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Clear Favorites',
          style: AppTextStyle.textStyle(
            responsive.sp(45),
            AppColors.blackText,
            FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all items from your favorites?',
          style: AppTextStyle.textStyle(
            responsive.sp(35),
            AppColors.greyText,
            FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyle.textStyle(
                responsive.sp(35),
                AppColors.greyText,
                FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                homeController.favoriteProducts.clear();
              });
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Clear All',
              style: AppTextStyle.textStyle(
                responsive.sp(35),
                Colors.white,
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnhancedFavoriteCard extends StatelessWidget {
  final ProductItem product;
  final Responsive responsive;
  final HomeController homeController;
  const EnhancedFavoriteCard({
    super.key,
    required this.product,
    required this.responsive,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.wp(10),
        vertical: responsive.hp(8),
      ),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            homeController.isFavoritesLoading.value = true;
            ApisService.getProductByProductId(product.id, (success) {
              homeController.isFavoritesLoading.value = false;
              Get.to(() => ProductDetailsScreen(
                  product: success, isFromFavorites: true))?.then((result) {
                if (result == true) {
                  homeController.getFavoriteProducts();
                }
              });
            }, (fail) {
              homeController.isFavoritesLoading.value = false;
              Utils.showFlushbarError(context, fail.message);
            });
            // await IsarService.instance
            //     .getProductWithAllRelations(product.id)
            //     .then((onValue) {
            //   Get.to(() => ProductDetailsScreen(
            //       product: onValue!, isFromFavorites: true))?.then((result) {
            //     if (result == true) {
            //       homeController.getFavoriteProducts();
            //     }
            //   });
            // });
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(responsive.wp(15)),
            child: Row(
              children: [
                // Enhanced Product Image
                Container(
                  width: responsive.wp(90),
                  height: responsive.hp(90),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.05),
                        AppColors.lightBlue.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      product.thumbnail ?? "",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.greyBackground.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: responsive.sp(50),
                            color: AppColors.greyText,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(width: responsive.wp(15)),

                // Product Info Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.name,
                        style: AppTextStyle.textStyle(
                          responsive.sp(38),
                          AppColors.blackText,
                          FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: responsive.hp(8)),

                      // Enhanced Price Display
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(12),
                          vertical: responsive.hp(6),
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
                          "\$${product.sellingPrice.toStringAsFixed(0)}",
                          style: AppTextStyle.textStyle(
                            responsive.sp(35),
                            AppColors.primary,
                            FontWeight.w800,
                          ),
                        ),
                      ),

                      SizedBox(height: responsive.hp(12)),

                      // Action Buttons Row
                      Row(
                        children: [
                          // Add to Basket Button
                          // Expanded(
                          //   child: Container(
                          //     height: responsive.hp(45),
                          //     decoration: BoxDecoration(
                          //       color: AppColors.primary,
                          //       borderRadius: BorderRadius.circular(12),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: AppColors.primary.withOpacity(0.3),
                          //           blurRadius: 8,
                          //           offset: const Offset(0, 3),
                          //         ),
                          //       ],
                          //     ),
                          //     child: ElevatedButton(
                          //       onPressed: () {
                          //         homeController.addToBasket(
                          //             product.name,
                          //             product.cost,
                          //             product.thumbnail,
                          //             product.id,
                          //             product.allVariants.first.id,
                          //             context);
                          //       },
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: Colors.transparent,
                          //         shadowColor: Colors.transparent,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(12),
                          //         ),
                          //       ),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Icon(
                          //             Icons.add_shopping_cart_rounded,
                          //             color: Colors.white,
                          //             size: responsive.sp(30),
                          //           ),
                          //           SizedBox(width: responsive.wp(8)),
                          //           Text(
                          //             'Add to Basket',
                          //             style: AppTextStyle.textStyle(
                          //               responsive.sp(25),
                          //               Colors.white,
                          //               FontWeight.w600,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // SizedBox(width: responsive.wp(10)),

                          // Remove from Favorites Button
                          Container(
                            padding: EdgeInsets.all(responsive.wp(10)),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.red,
                              size: responsive.sp(35),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
