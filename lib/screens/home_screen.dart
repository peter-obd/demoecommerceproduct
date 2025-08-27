import 'package:demoecommerceproduct/controllers/basket_controller.dart';
import 'package:demoecommerceproduct/controllers/profile_controller.dart';
import 'package:demoecommerceproduct/screens/oders_screen.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/screens/pages/favorites_page.dart';
import 'package:demoecommerceproduct/screens/pages/home_page.dart';
import 'package:demoecommerceproduct/screens/pages/profile_page.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool isSelected = true;
  final PageController _pageController = PageController();
  final BasketController basketController = Get.put(BasketController());
  final ProfileController profileController = Get.put(ProfileController());
  final List<CheckoutProduct> products = [
    // CheckoutProduct(
    //   productId: "",
    //   imageUrl: 'assets/images/MaskGroup.png',
    //   name: '2020 Apple iPad Air 10.9"',
    //   price: 579.00,
    // ),
    // CheckoutProduct(
    //   productId: "",
    //   imageUrl: 'assets/images/MaskGroup.png',
    //   name: 'APPLE AirPods Pro - White',
    //   price: 375.00,
    // ),
  ];

  void _handleIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  final List<Widget> _icons = [
    Image.asset(
      "assets/icons/Home.png",
      height: 25,
      width: 25,
    ),
    Image.asset("assets/icons/Heart.png", height: 25, width: 25),
    Image.asset("assets/icons/Profile.png", height: 25, width: 25),
    Image.asset("assets/icons/Buy.png", height: 25, width: 25),
  ];
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (index == 3) {
            basketController.getCheckoutProducts();
          } else if (index == 2) {
            profileController.getLocation();
          }
          setState(() {
            _currentIndex = index; // Updates the tab indicator
          });
        },
        children: [
          HomePage(),
          FavoritesPage(products: products),
          MyProfileScreen(),
          BasketPage(
              // products: products,
              )
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: responsive.hp(30)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        color: AppColors.greyBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_icons.length, (index) {
            isSelected = index == _currentIndex;
            return GestureDetector(
              onTap: () => _handleIndexChanged(index),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: _currentIndex == index
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.greyShadow.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      )
                    : null,
                child: buildIcon(
                    "assets/icons/${[
                      "Home",
                      "Heart",
                      "Profile",
                      "Buy"
                    ][index]}.png",
                    index,
                    responsive),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildIcon(String path, int index, Responsive responsive) {
    return Image.asset(
      path,
      height: responsive.hp(23),
      width: responsive.wp(30),
      color:
          _currentIndex == index ? AppColors.primary : const Color(0xFF1E102F),
    );
  }
}
