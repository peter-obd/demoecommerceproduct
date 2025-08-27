import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/screens/search_screen.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesPage extends StatefulWidget {
  final List<CheckoutProduct> products;
  const FavoritesPage({super.key, required this.products});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.greyBackground,
        leading: widget.products.isNotEmpty ? SizedBox() : null,
        //  Image.asset("assets/icons/ArrowLeft.png")),
        title: Center(
          child: Text(
            "Fvorites",
            style: AppTextStyle.textStyle(
                responsive.sp(40), AppColors.blackText, FontWeight.w600),
          ),
        ),
        actions: [
          widget.products.isEmpty
              ? Container()
              : Row(
                  children: [
                    Image.asset(
                      "assets/icons/Delete.png",
                      height: responsive.hp(22),
                    ),
                    SizedBox(width: responsive.wp(20)),
                  ],
                ),
        ],
      ),
      body: widget.products.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    child: ListView.builder(
                      // padding: const EdgeInsets.all(16),
                      itemCount: widget.products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: widget.products[index]);
                      },
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: responsive.wp(30),
                                right: responsive.wp(30)),
                            height: responsive.hp(70),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text('Add All to Basket',
                                  style: AppTextStyle.textStyle(
                                      responsive.sp(35),
                                      AppColors.secondary,
                                      FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            )
          : Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: responsive.hp(10),
                    right: responsive.wp(10),
                    left: responsive.wp(10)),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/noItemsFound.png",
                      height: responsive.hp(400),
                    ),
                    Text(
                      "No favorites products",
                      style: AppTextStyle.textStyle(responsive.sp(40),
                          AppColors.blackText, FontWeight.w600),
                    ),
                    SizedBox(height: responsive.hp(10)),
                    Text(
                      "Hit the blue button down below ",
                      style: AppTextStyle.textStyle(responsive.sp(30),
                          AppColors.greyText, FontWeight.w600),
                    ),
                    Text(
                      "to add some",
                      style: AppTextStyle.textStyle(responsive.sp(30),
                          AppColors.greyText, FontWeight.w600),
                    ),
                    SizedBox(height: responsive.hp(10)),
                    Container(
                      width: responsive.wp(250),
                      height: responsive.hp(45),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(SearchScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text('Browse products',
                            style: AppTextStyle.textStyle(responsive.sp(35),
                                AppColors.secondary, FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final CheckoutProduct product;

  const ProductCard({required this.product, super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Card(
      color: AppColors.secondary,
      elevation: 3,
      margin: EdgeInsets.only(
        bottom: responsive.hp(20),
        left: responsive.wp(30),
        right: responsive.wp(30),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.asset(
              widget.product.imageUrl,
              width: responsive.wp(90),
              height: responsive.hp(70),
              fit: BoxFit.contain,
            ),
            SizedBox(width: responsive.wp(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: AppTextStyle.textStyle(responsive.sp(30),
                        AppColors.blackText, FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: responsive.hp(3)),
                  Text("\$${widget.product.price.toStringAsFixed(2)}",
                      style: AppTextStyle.textStyle(
                        responsive.sp(30),
                        AppColors.primary,
                        FontWeight.bold,
                      )),
                  SizedBox(height: responsive.hp(5)),
                  // Row(
                  //   children: [
                  //     Text("Quantity",
                  //         style: AppTextStyle.textStyle(
                  //           responsive.sp(30),
                  //           AppColors.blackText,
                  //           FontWeight.bold,
                  //         )),
                  //     SizedBox(width: responsive.wp(10)),
                  //     Container(
                  //       height: responsive.hp(30),
                  //       width: responsive.wp(30),
                  //       decoration: BoxDecoration(
                  //         color: AppColors.lightBlue,
                  //         borderRadius: BorderRadius.circular(6),
                  //       ),
                  //       child: IconButton(
                  //         icon: Icon(Icons.remove, size: responsive.sp(25)),
                  //         onPressed: () {
                  //           if (quantity > 1) {
                  //             setState(() => quantity--);
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //     SizedBox(width: responsive.wp(10)),
                  //     Text(quantity.toString(),
                  //         style: const TextStyle(fontSize: 16)),
                  //     SizedBox(width: responsive.wp(10)),
                  //     Container(
                  //       height: responsive.hp(30),
                  //       width: responsive.wp(30),
                  //       decoration: BoxDecoration(
                  //         color: AppColors.lightBlue,
                  //         borderRadius: BorderRadius.circular(6),
                  //       ),
                  //       child: IconButton(
                  //         icon: Icon(Icons.add, size: responsive.sp(25)),
                  //         onPressed: () {
                  //           setState(() => quantity++);
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
