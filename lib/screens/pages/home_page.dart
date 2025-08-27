import 'package:demoecommerceproduct/controllers/home_controller.dart';
import 'package:demoecommerceproduct/models/category_model.dart';
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
              GestureDetector(
                onTap: () {
                  Get.to(SearchScreen());
                },
                child: Container(
                  height: responsive.hp(60),
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: responsive.hp(55),
                    left: responsive.wp(40),
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
                          height: responsive.hp(50), width: responsive.wp(50)),
                      SizedBox(width: responsive.wp(10)),
                      Text("Search",
                          style: AppTextStyle.textStyle(responsive.sp(30),
                              AppColors.greyText, FontWeight.normal))
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: responsive.wp(40),
                    right: responsive.wp(40),
                    top: responsive.hp(50)),
                width: double.infinity,
                child: Text(
                  "Order online\nCollect in store",
                  style: AppTextStyle.textStyle(
                      responsive.sp(60), AppColors.blackText, FontWeight.w700),
                ),
              ),
              SizedBox(height: responsive.hp(30)),
              SizedBox(
                  height: responsive.hp(500), child: CategoriesItemsWidget()),
              const ForYouSectionWidget(),
            ]),
          ),
        ),
        Obx(
          () => controller.isForYouuLoadingg.value
              ? Expanded(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                )
              : Container(),
        )
      ],
    );
  }
}
