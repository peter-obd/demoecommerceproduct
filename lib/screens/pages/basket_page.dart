import 'package:demoecommerceproduct/controllers/basket_controller.dart';
import 'package:demoecommerceproduct/screens/checkout_screen.dart';
import 'package:demoecommerceproduct/screens/search_screen.dart';
import 'package:demoecommerceproduct/services/basket_service.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

part 'basket_page.g.dart';

class BasketPage extends StatefulWidget {
  // List<CheckoutProduct> products;

  BasketPage({
    super.key,
  }); //required this.products

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final BasketController controller = Get.put(BasketController());
  // var total;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getCheckoutProducts();
  // }

  // void getCheckoutProducts() async {
  //   widget.products = await BasketService.instance.getBasketProducts();
  //   total = await BasketService.instance.getBasketTotal();
  // }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Obx(() => Stack(
          children: [
            Scaffold(
                backgroundColor: AppColors.greyBackground,
                body: Column(
                  children: [
                    // Enhanced Header
                    _buildEnhancedHeader(responsive),

                    // Enhanced Body Content
                    Expanded(
                      child: controller.products.isNotEmpty
                          ? _buildBasketContent(responsive)
                          : _buildEmptyBasketState(responsive),
                    ),
                  ],
                )),
            controller.isLoading.value
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ));
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
              // Basket Icon
              Container(
                padding: EdgeInsets.all(responsive.wp(12)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.shopping_basket_rounded,
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
                      'My Basket',
                      style: AppTextStyle.textStyle(
                        responsive.sp(50),
                        Colors.white,
                        FontWeight.w800,
                      ),
                    ),
                    Text(
                      controller.products.isNotEmpty
                          ? '${controller.products.length} items in your basket'
                          : 'Your basket is empty',
                      style: AppTextStyle.textStyle(
                        responsive.sp(32),
                        Colors.white.withOpacity(0.9),
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Clear All Button (only show when basket has items)
              if (controller.products.isNotEmpty)
                GestureDetector(
                  onTap: () => _showClearBasketDialog(responsive),
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

  Widget _buildBasketContent(Responsive responsive) {
    return Column(
      children: [
        // Products List
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(10)),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: responsive.hp(20)),
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(
                      '${controller.products[index].productId}_${controller.products[index].variantId ?? 'no_variant'}'),
                  onDismissed: (direction) {
                    controller.removeProduct(controller.products[index]);
                  },
                  background: _buildDismissBackground(),
                  child: EnhancedProductCard(
                    product: controller.products[index],
                    controller: controller,
                  ),
                );
              },
            ),
          ),
        ),

        // Enhanced Checkout Section
        _buildEnhancedCheckoutSection(responsive),
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
              Icons.delete_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedCheckoutSection(Responsive responsive) {
    return Container(
      margin: EdgeInsets.all(responsive.wp(20)),
      padding: EdgeInsets.all(responsive.wp(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, -10),
            spreadRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Summary
          _buildOrderSummary(responsive),

          SizedBox(height: responsive.hp(20)),

          // Enhanced Checkout Button
          _buildEnhancedCheckoutButton(responsive),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(Responsive responsive) {
    return Column(
      children: [
        // Subtotal Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal',
              style: AppTextStyle.textStyle(
                responsive.sp(35),
                AppColors.greyText,
                FontWeight.w500,
              ),
            ),
            Text(
              '\$${controller.total.toStringAsFixed(0)}',
              style: AppTextStyle.textStyle(
                responsive.sp(35),
                AppColors.blackText,
                FontWeight.w600,
              ),
            ),
          ],
        ),

        SizedBox(height: responsive.hp(8)),

        // Delivery Fee Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Fee',
              style: AppTextStyle.textStyle(
                responsive.sp(35),
                AppColors.greyText,
                FontWeight.w500,
              ),
            ),
            Text(
              'Free',
              style: AppTextStyle.textStyle(
                responsive.sp(35),
                AppColors.primary,
                FontWeight.w600,
              ),
            ),
          ],
        ),

        SizedBox(height: responsive.hp(15)),

        // Divider
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.primary.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // SizedBox(height: responsive.hp(15)),

        // // Total Row
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       'Total',
        //       style: AppTextStyle.textStyle(
        //         responsive.sp(45),
        //         AppColors.blackText,
        //         FontWeight.w800,
        //       ),
        //     ),
        //     Container(
        //       padding: EdgeInsets.symmetric(
        //         horizontal: responsive.wp(15),
        //         vertical: responsive.hp(8),
        //       ),
        //       decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //           colors: [
        //             AppColors.primary.withOpacity(0.15),
        //             AppColors.lightBlue.withOpacity(0.15),
        //           ],
        //         ),
        //         borderRadius: BorderRadius.circular(15),
        //       ),
        //       child: Text(
        //         '\$${controller.total.toStringAsFixed(2)}',
        //         style: AppTextStyle.textStyle(
        //           responsive.sp(45),
        //           AppColors.primary,
        //           FontWeight.w800,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildEnhancedCheckoutButton(Responsive responsive) {
    return Container(
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
          // Navigate to checkout screen
          Get.to(() => CheckoutScreen(
                items: controller.products,
                subtotal: controller.total,
                deliveryCharge: 0.0,
              ));
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
              Icons.shopping_cart_checkout_rounded,
              color: Colors.white,
              size: responsive.sp(45),
            ),
            SizedBox(width: responsive.wp(15)),
            Text(
              'Proceed to Checkout',
              style: AppTextStyle.textStyle(
                responsive.sp(40),
                Colors.white,
                FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBasketState(Responsive responsive) {
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
              Icons.shopping_basket_outlined,
              size: responsive.sp(120),
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: responsive.hp(30)),

          Text(
            'Your Basket is Empty',
            style: AppTextStyle.textStyle(
              responsive.sp(50),
              AppColors.blackText,
              FontWeight.w800,
            ),
          ),

          SizedBox(height: responsive.hp(15)),

          Text(
            'Looks like you haven\'t added anything to your basket yet. Start browsing our amazing products!',
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle(
              responsive.sp(35),
              AppColors.greyText,
              FontWeight.w400,
            ),
          ),

          SizedBox(height: responsive.hp(40)),

          // Enhanced Start Shopping Button
          Container(
            width: double.infinity,
            height: responsive.hp(60),
            margin: EdgeInsets.symmetric(horizontal: responsive.wp(40)),
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
              onPressed: () => Get.to(() => const SearchScreen())?.then(
                (result) {
                  if (result == true) {
                    controller.getCheckoutProducts();
                  }
                },
              ),
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
                    Icons.shopping_bag_rounded,
                    color: Colors.white,
                    size: responsive.sp(45),
                  ),
                  SizedBox(width: responsive.wp(15)),
                  Text(
                    'Start Shopping',
                    style: AppTextStyle.textStyle(
                      responsive.sp(35),
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

  void _showClearBasketDialog(Responsive responsive) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Clear Basket',
          style: AppTextStyle.textStyle(
            responsive.sp(45),
            AppColors.blackText,
            FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all items from your basket?',
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
              controller.removeAllProducts();
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

@collection
class CheckoutProduct {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, composite: [CompositeIndex('variantId')])
  late String productId;
  late String imageUrl;
  late String name;
  late double price;
  late int quantity;
  int? stock;
  String? variantId;
  DateTime? createdAt;
  DateTime? updatedAt;

  CheckoutProduct({
    required this.productId,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.stock,
    this.quantity = 1,
    this.variantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  CheckoutProduct.empty()
      : productId = '',
        imageUrl = '',
        name = '',
        price = 0.0,
        quantity = 1,
        variantId = null,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'imageUrl': imageUrl,
        'name': name,
        'price': price,
        'quantity': quantity,
        'variantId': variantId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  CheckoutProduct copyWith({
    String? productId,
    String? imageUrl,
    String? name,
    double? price,
    int? stock,
    int? quantity,
    String? variantId,
    DateTime? updatedAt,
  }) {
    return CheckoutProduct(
      productId: productId ?? this.productId,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      quantity: quantity ?? this.quantity,
      variantId: variantId ?? this.variantId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class EnhancedProductCard extends StatefulWidget {
  final CheckoutProduct product;
  final BasketController controller;
  const EnhancedProductCard(
      {required this.product, required this.controller, super.key});

  @override
  State<EnhancedProductCard> createState() => _EnhancedProductCardState();
}

class _EnhancedProductCardState extends State<EnhancedProductCard> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
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
            widget.controller.productTapped(widget.product);
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
                      widget.product.imageUrl,
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
                        widget.product.name,
                        style: AppTextStyle.textStyle(
                          responsive.sp(38),
                          AppColors.blackText,
                          FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: responsive.hp(5)),

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
                          "\$${widget.product.price.toStringAsFixed(0)}",
                          style: AppTextStyle.textStyle(
                            responsive.sp(35),
                            AppColors.primary,
                            FontWeight.w800,
                          ),
                        ),
                      ),

                      SizedBox(height: responsive.hp(10)),

                      // Enhanced Quantity Controls
                      Row(
                        children: [
                          Text(
                            "Qty",
                            style: AppTextStyle.textStyle(
                              responsive.sp(32),
                              AppColors.greyText,
                              FontWeight.w500,
                            ),
                          ),

                          SizedBox(width: responsive.wp(10)),

                          // Quantity Controls Container
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.greyBackground.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Decrease Button
                                GestureDetector(
                                  onTap: () {
                                    if (widget.product.quantity > 1) {
                                      widget.controller
                                          .decreaseQuantity(widget.product);
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(responsive.wp(8)),
                                    decoration: BoxDecoration(
                                      color: widget.product.quantity > 1
                                          ? AppColors.primary.withOpacity(0.1)
                                          : AppColors.greyText.withOpacity(0.1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.remove_rounded,
                                      color: widget.product.quantity > 1
                                          ? AppColors.primary
                                          : AppColors.greyText,
                                      size: responsive.sp(35),
                                    ),
                                  ),
                                ),

                                // Quantity Display
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(15),
                                    vertical: responsive.hp(8),
                                  ),
                                  child: Text(
                                    widget.product.quantity.toString(),
                                    style: AppTextStyle.textStyle(
                                      responsive.sp(35),
                                      AppColors.blackText,
                                      FontWeight.w700,
                                    ),
                                  ),
                                ),

                                // Increase Button
                                GestureDetector(
                                  onTap: () {
                                    widget.controller
                                        .increaseQuantity(widget.product);
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(responsive.wp(8)),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: AppColors.primary,
                                      size: responsive.sp(35),
                                    ),
                                  ),
                                ),
                              ],
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

class ProductCard extends StatefulWidget {
  final CheckoutProduct product;
  final BasketController controller;
  const ProductCard(
      {required this.product, required this.controller, super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // int quantity = 1;

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return GestureDetector(
      onTap: () {
        widget.controller.productTapped(widget.product);
      },
      child: Card(
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
              Image.network(
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
                    Text("\$${widget.product.price.toStringAsFixed(0)}",
                        style: AppTextStyle.textStyle(
                          responsive.sp(30),
                          AppColors.primary,
                          FontWeight.bold,
                        )),
                    SizedBox(height: responsive.hp(5)),
                    Row(
                      children: [
                        Text("Quantity",
                            style: AppTextStyle.textStyle(
                              responsive.sp(30),
                              AppColors.blackText,
                              FontWeight.bold,
                            )),
                        SizedBox(width: responsive.wp(10)),
                        Container(
                          height: responsive.hp(30),
                          width: responsive.wp(30),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.remove, size: responsive.sp(25)),
                            onPressed: () {
                              if (widget.product.quantity > 1) {
                                widget.controller
                                    .decreaseQuantity(widget.product);
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        SizedBox(width: responsive.wp(10)),
                        Text(widget.product.quantity.toString(),
                            style: const TextStyle(fontSize: 16)),
                        SizedBox(width: responsive.wp(10)),
                        Container(
                          height: responsive.hp(30),
                          width: responsive.wp(30),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add, size: responsive.sp(25)),
                            onPressed: () {
                              widget.controller
                                  .increaseQuantity(widget.product);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
