import 'dart:async';

import 'package:demoecommerceproduct/controllers/search_controller.dart';
import 'package:demoecommerceproduct/models/product/product_model.dart';
import 'package:demoecommerceproduct/models/product_model.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
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
  Timer? _debounceTimer;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
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
          // Search Bar
          Container(
            margin: EdgeInsets.only(
              left: responsive.wp(15),
              top: responsive.hp(55),
              right: responsive.wp(15),
            ),
            child: Row(
              children: [
                // Back arrow button
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        "assets/icons/ArrowLeft.png",
                      )),
                ),
                SizedBox(width: responsive.wp(10)),
                // Search text field
                Expanded(
                  child: Container(
                    height: responsive.hp(60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isFocused
                            ? AppColors.primary
                            : AppColors.greyShadow,
                        width: 2,
                      ),
                      color: AppColors.greyBackground,
                    ),
                    child: Center(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: (value) {
                          searchController.isLoading.value = true;
                          _debounceTimer?.cancel();

                          _debounceTimer =
                              Timer(const Duration(seconds: 1), () {
                            searchController.searchProducts(value);
                          });

                          // searchController.updateSearchQuery(value);
                        },
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                          prefixIcon: Image.asset("assets/icons/Search.png",
                              height: responsive.hp(50),
                              width: responsive.wp(50)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(16),
                            vertical: responsive.hp(13),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results Section
          Obx(() {
            final products = searchController.filteredProducts;
            return searchController.isLoading.value == true
                ? SizedBox(
                    height: responsive.hp(300),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : products.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(20),
                            vertical: responsive.hp(20),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Results count
                                SizedBox(height: responsive.hp(20)),
                                Text('Found ${products.length} results',
                                    style: AppTextStyle.textStyle(
                                        responsive.sp(50),
                                        AppColors.blackText,
                                        FontWeight.w600)),
                                // SizedBox(height: responsive.hp(5)),

                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: responsive.wp(15),
                                    mainAxisSpacing: responsive.hp(15),
                                    childAspectRatio: 0.65,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    var indexfilter = index / 2;
                                    return indexfilter.toString().contains(".0")
                                        ? GestureDetector(
                                            onTap: () {
                                              Get.to(ProductDetailsScreen(
                                                  product: product));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 20),
                                              child: Container(
                                                child: ProductCard(
                                                  product: product,
                                                  responsive: responsive,
                                                ),
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              Get.to(ProductDetailsScreen(
                                                  product: product));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: ProductCard(
                                                product: product,
                                                responsive: responsive,
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : searchController.noItemFound.value
                        ? Expanded(
                            child: Column(
                            children: [
                              Center(
                                child: Image.asset(
                                    "assets/images/noItemFound.png"),
                              ),
                              Text(
                                "Item not found",
                                style: AppTextStyle.textStyle(responsive.sp(50),
                                    AppColors.blackText, FontWeight.w600),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(17)),
                                child: Text(
                                  "Try a more generic search term or try looking for alternative products.",
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.textStyle(
                                      responsive.sp(30),
                                      AppColors.blackText.withOpacity(0.5),
                                      FontWeight.w400),
                                ),
                              )
                            ],
                          ))
                        : Expanded(
                            child: Center(
                                child: Text(
                            "Search your favorite products!!",
                            style: AppTextStyle.textStyle(responsive.sp(35),
                                AppColors.blackText, FontWeight.w600),
                          )));
          }),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductItem product;
  final Responsive responsive;

  const ProductCard({
    Key? key,
    required this.product,
    required this.responsive,
  }) : super(key: key);

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
                      "\$${product.cost.toString()}",
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
