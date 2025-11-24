import 'dart:async';

import 'package:demoecommerceproduct/controllers/search_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/product_model.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/utilities/Utils.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  final TextEditingController _searchController = TextEditingController();
  final SearchControllerr searchController = Get.put(SearchControllerr());
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _focusNode.requestFocus();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      searchController.loadMoreProducts();
    }
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Column(
        children: [
          // Enhanced Search Header
          _buildEnhancedSearchHeader(responsive),

          // Enhanced Results Section
          Expanded(
            child: _buildEnhancedResultsSection(responsive),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSearchHeader(Responsive responsive) {
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
                onTap: () => Get.back(result: true),
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
                    size: responsive.sp(40),
                  ),
                ),
              ),
              SizedBox(width: responsive.wp(15)),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 55, // fixed for consistency across devices
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: _isFocused
                            ? AppColors.primary.withOpacity(0.2)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: _isFocused ? 15 : 8,
                        offset: const Offset(0, 5),
                        spreadRadius: _isFocused ? 2 : 0,
                      ),
                    ],
                    border: Border.all(
                      color: _isFocused
                          ? AppColors.primary
                          : AppColors.greyShadow.withOpacity(0.3),
                      width: _isFocused ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isFocused
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.search,
                          color: _isFocused ? Colors.white : AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          style: AppTextStyle.textStyle(
                            16, // fixed sp for readability
                            AppColors.blackText,
                            FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search products...",
                            hintStyle: AppTextStyle.textStyle(
                              16,
                              AppColors.greyText,
                              FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onChanged: (value) {
                            searchController.isLoading.value = true;
                            _debounceTimer?.cancel();
                            _debounceTimer =
                                Timer(const Duration(seconds: 1), () {
                              searchController.searchProducts(value);
                            });
                          },
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            searchController.filteredProducts.clear();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.greyText.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.close,
                              color: AppColors.greyText,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Enhanced Search Field
              // Expanded(
              //   child: AnimatedContainer(
              //     duration: const Duration(milliseconds: 300),
              //     height: responsive.hp(60),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(30),
              //       boxShadow: [
              //         BoxShadow(
              //           color: _isFocused
              //               ? AppColors.primary.withOpacity(0.2)
              //               : Colors.black.withOpacity(0.1),
              //           blurRadius: _isFocused ? 15 : 8,
              //           offset: const Offset(0, 5),
              //           spreadRadius: _isFocused ? 2 : 0,
              //         ),
              //       ],
              //       border: Border.all(
              //         color: _isFocused
              //             ? AppColors.primary
              //             : AppColors.greyShadow.withOpacity(0.3),
              //         width: _isFocused ? 2 : 1,
              //       ),
              //     ),
              //     child: Row(
              //       children: [
              //         SizedBox(width: responsive.wp(20)),
              //         AnimatedContainer(
              //           duration: const Duration(milliseconds: 300),
              //           padding: EdgeInsets.all(responsive.wp(8)),
              //           decoration: BoxDecoration(
              //             color: _isFocused
              //                 ? AppColors.primary
              //                 : AppColors.primary.withOpacity(0.1),
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //           child: Icon(
              //             Icons.search,
              //             color: _isFocused ? Colors.white : AppColors.primary,
              //             size: responsive.sp(35),
              //           ),
              //         ),
              //         SizedBox(width: responsive.wp(15)),
              //         Expanded(
              //           child: TextField(
              //             controller: _searchController,
              //             focusNode: _focusNode,
              //             onChanged: (value) {
              //               searchController.isLoading.value = true;
              //               _debounceTimer?.cancel();

              //               _debounceTimer =
              //                   Timer(const Duration(seconds: 1), () {
              //                 searchController.searchProducts(value);
              //               });
              //             },
              //             style: AppTextStyle.textStyle(
              //               responsive.sp(32),
              //               AppColors.blackText,
              //               FontWeight.w500,
              //             ),
              //             decoration: InputDecoration(
              //               hintText: "Search products...",
              //               hintStyle: AppTextStyle.textStyle(
              //                 responsive.sp(32),
              //                 AppColors.greyText,
              //                 FontWeight.w400,
              //               ),
              //               border: InputBorder.none,
              //               contentPadding: EdgeInsets.symmetric(
              //                 vertical: responsive.hp(15),
              //               ),
              //             ),
              //           ),
              //         ),
              //         if (_searchController.text.isNotEmpty)
              //           GestureDetector(
              //             onTap: () {
              //               _searchController.clear();
              //               searchController.filteredProducts.clear();
              //             },
              //             child: Container(
              //               margin: EdgeInsets.only(right: responsive.wp(15)),
              //               padding: EdgeInsets.all(responsive.wp(8)),
              //               decoration: BoxDecoration(
              //                 color: AppColors.greyText.withOpacity(0.2),
              //                 borderRadius: BorderRadius.circular(12),
              //               ),
              //               child: Icon(
              //                 Icons.close,
              //                 color: AppColors.greyText,
              //                 size: responsive.sp(30),
              //               ),
              //             ),
              //           ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedResultsSection(Responsive responsive) {
    return Obx(() {
      final products = searchController.filteredProducts;

      if (searchController.isLoading.value) {
        return _buildEnhancedLoadingState(responsive);
      }

      if (products.isNotEmpty) {
        return _buildEnhancedSearchResults(responsive, products);
      }

      if (searchController.noItemFound.value) {
        return _buildEnhancedNoResultsState(responsive);
      }

      return _buildEnhancedEmptyState(responsive);
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
              // color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              // boxShadow: [
              //   BoxShadow(
              //     color: AppColors.primary.withOpacity(0.1),
              //     blurRadius: 20,
              //     spreadRadius: 2,
              //   ),
              // ],
            ),
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
                SizedBox(height: responsive.hp(20)),
                Text(
                  'Searching...',
                  style: AppTextStyle.textStyle(
                    responsive.sp(40),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
                Text(
                  'Finding the best products for you',
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

  Widget _buildEnhancedSearchResults(Responsive responsive, List products) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(20),
        // vertical: responsive.hp(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Results Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(15),
              vertical: responsive.hp(10),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.wp(8)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.search_outlined,
                    color: AppColors.primary,
                    size: responsive.sp(35),
                  ),
                ),
                SizedBox(width: responsive.wp(15)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Found ${products.length} results',
                        style: AppTextStyle.textStyle(
                          responsive.sp(40),
                          AppColors.blackText,
                          FontWeight.w700,
                        ),
                      ),
                      Text(
                        'for "${_searchController.text}"',
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
          ),
          // SizedBox(height: responsive.hp(10)),

          // Enhanced Products Grid
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
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
                          await IsarService.instance
                              .getProductWithAllRelations(product.id)
                              .then((onValue) {
                            Get.to(ProductDetailsScreen(product: onValue!));
                          });

                          // Get.to(ProductDetailsScreen(product: product));
                        },
                        child: EnhancedSearchProductCard(
                          product: product,
                          responsive: responsive,
                        ),
                      );
                    },
                  ),
                ),
                Obx(() {
                  if (searchController.isLoadingMore.value) {
                    return Container(
                      margin: EdgeInsets.only(bottom: responsive.hp(40)),
                      padding:
                          EdgeInsets.symmetric(vertical: responsive.hp(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: responsive.wp(15)),
                          Text(
                            'Loading more...',
                            style: AppTextStyle.textStyle(
                              responsive.sp(32),
                              AppColors.greyText,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedNoResultsState(Responsive responsive) {
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
              Icons.search_off_outlined,
              size: responsive.sp(120),
              color: AppColors.greyText,
            ),
          ),
          SizedBox(height: responsive.hp(10)),
          Text(
            'No Results Found',
            style: AppTextStyle.textStyle(
              responsive.sp(50),
              AppColors.blackText,
              FontWeight.w800,
            ),
          ),
          SizedBox(height: responsive.hp(5)),
          Text(
            'We couldn\'t find any products matching "${_searchController.text}". Try using different keywords or check spelling.',
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle(
              responsive.sp(32),
              AppColors.greyText,
              FontWeight.w400,
            ),
          ),
          // SizedBox(height: responsive.hp(30)),
          // GestureDetector(
          //   onTap: () {
          //     _searchController.clear();
          //     searchController.filteredProducts.clear();
          //     _focusNode.requestFocus();
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(
          //       horizontal: responsive.wp(30),
          //       vertical: responsive.hp(15),
          //     ),
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [
          //           AppColors.primary,
          //           AppColors.primary.withOpacity(0.8),
          //         ],
          //       ),
          //       borderRadius: BorderRadius.circular(25),
          //       boxShadow: [
          //         BoxShadow(
          //           color: AppColors.primary.withOpacity(0.3),
          //           blurRadius: 15,
          //           offset: const Offset(0, 5),
          //         ),
          //       ],
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Icon(
          //           Icons.refresh_rounded,
          //           color: Colors.white,
          //           size: responsive.sp(45),
          //         ),
          //         SizedBox(width: responsive.wp(10)),
          //         Text(
          //           'Try Again',
          //           style: AppTextStyle.textStyle(
          //             responsive.sp(38),
          //             Colors.white,
          //             FontWeight.w600,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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
              Icons.search_rounded,
              size: responsive.sp(120),
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: responsive.hp(20)),
          Text(
            'Start Your Search',
            style: AppTextStyle.textStyle(
              responsive.sp(50),
              AppColors.blackText,
              FontWeight.w800,
            ),
          ),
          SizedBox(height: responsive.hp(10)),
          Text(
            'Find your favorite products by typing in the search bar above. We have thousands of amazing products waiting for you!',
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle(
              responsive.sp(35),
              AppColors.greyText,
              FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class EnhancedSearchProductCard extends StatelessWidget {
  final ProductItem product;
  final Responsive responsive;

  const EnhancedSearchProductCard({
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
                      // GestureDetector(
                      //   onTap: () async {
                      //     await BasketService.instance
                      //         .addToBasket(CheckoutProduct(
                      //             productId: product.id,
                      //             imageUrl: product.thumbnail ?? "",
                      //             name: product.name,
                      //             price: product.sellingPrice))
                      //         .then((onValue) {
                      //       Utils.showFlushbarSuccess(
                      //           context, "Item added to Basket");
                      //     });
                      //     ;
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.all(responsive.wp(10)),
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
                      //     child: Icon(
                      //       Icons.add_shopping_cart_rounded,
                      //       color: Colors.white,
                      //       size: responsive.sp(35),
                      //     ),
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

class ProductCard extends StatelessWidget {
  final ProductItem product;
  final Responsive responsive;

  const ProductCard({
    super.key,
    required this.product,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    var productNameLength = product.name.length;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: responsive.hp(30), left: 15, right: 15),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 10,
                color: AppColors.greyShadow.withOpacity(0.3),
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: SizedBox(),
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                    SizedBox(
                      width: responsive.wp(90),
                      height: productNameLength <= 10
                          ? responsive.hp(25)
                          : responsive.hp(50),
                      child: Text(
                        product.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: AppTextStyle.textStyle(responsive.sp(35),
                            AppColors.blackText, FontWeight.w600),
                      ),
                    ),
                    Text(
                      "\$${product.sellingPrice.toString()}",
                      style: AppTextStyle.textStyle(responsive.sp(30),
                          AppColors.primary, FontWeight.w600),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
        Container(
          height: responsive.hp(100),
          margin: EdgeInsets.only(
              left: responsive.wp(25), right: responsive.wp(25)),
          color: AppColors.secondary,
          child: Center(
            child: Image.network(product.thumbnail ?? ""),
          ),
        )
      ],
    );
  }
}
