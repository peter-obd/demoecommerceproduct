import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/screens/product_details_screen.dart';
import 'package:demoecommerceproduct/screens/search_screen.dart';
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

        controller.loadMoreProducts(
            context,
            controller.selectedCategoryId.value,
            "6",
            controller.pageNumber.value.toString());
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
          Container(
            height: responsive.hp(130),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: responsive.hp(45),
                    left: responsive.wp(10),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          "assets/icons/ArrowLeft.png",
                        )),
                  ),
                ),
                SizedBox(width: responsive.wp(10)),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(SearchScreen());
                    },
                    child: Container(
                      height: responsive.hp(60),
                      width: responsive.wp(290),
                      margin: EdgeInsets.only(
                        top: responsive.hp(45),
                        left: responsive.wp(5),
                        right: responsive.wp(40),
                      ),
                      // padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColors.greyBackground,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.greyShadow),
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/icons/Search.png",
                              height: responsive.hp(50),
                              width: responsive.wp(50)),
                          SizedBox(width: responsive.wp(10)),
                          Text("Search",
                              style: AppTextStyle.textStyle(responsive.sp(30),
                                  AppColors.greyText, FontWeight.normal))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: responsive.wp(10), top: responsive.hp(20)),
            child: _buildCategoriesHeader(context),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return SizedBox(
                  height: responsive.hp(500),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
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
                          style: AppTextStyle.textStyle(responsive.sp(35),
                              AppColors.greyText, FontWeight.w700)),
                    ],
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(20),
                  vertical: responsive.hp(20),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                    Get.to(
                                        ProductDetailsScreen(product: product));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
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
                                    Get.to(
                                        ProductDetailsScreen(product: product));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: ProductCard(
                                      product: product,
                                      responsive: responsive,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                    if (controller.isScrollLoading.value)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

Widget _buildCategoriesHeader(BuildContext context) {
  var responsive = Responsive(context);
  final HomeController controller = Get.put(HomeController());
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
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
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
