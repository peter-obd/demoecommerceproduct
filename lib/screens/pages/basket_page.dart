import 'package:demoecommerceproduct/controllers/basket_controller.dart';
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
    return Obx(() => Scaffold(
          backgroundColor: AppColors.greyBackground,
          appBar: AppBar(
            backgroundColor: AppColors.greyBackground,
            leading: controller.products.isNotEmpty ? SizedBox() : null,
            //  Image.asset("assets/icons/ArrowLeft.png")),
            title: Center(
              child: Text(
                "Basket",
                style: AppTextStyle.textStyle(
                    responsive.sp(40), AppColors.blackText, FontWeight.w600),
              ),
            ),
            actions: [
              controller.products.isEmpty
                  ? Container()
                  : Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.removeAllProducts();
                          },
                          child: Image.asset(
                            "assets/icons/Delete.png",
                            height: responsive.hp(22),
                          ),
                        ),
                        SizedBox(width: responsive.wp(20)),
                      ],
                    ),
            ],
          ),
          body: controller.products.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        child: ListView.builder(
                          // padding: const EdgeInsets.all(16),
                          itemCount: controller.products.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key('${controller.products[index].productId}_${controller.products[index].variantId ?? 'no_variant'}'),
                              onDismissed: (direction) {
                                controller
                                    .removeProduct(controller.products[index]);
                              },
                              // background: Container(
                              //   color: Colors.transparent,
                              //   alignment: Alignment.centerRight,
                              //   padding: EdgeInsets.symmetric(horizontal: 20),
                              //   child: Icon(Icons.delete, color: Colors.white),
                              // ),
                              child: ProductCard(
                                product: controller.products[index],
                                controller: controller,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      left: responsive.wp(30),
                                      right: responsive.wp(30),
                                      bottom: responsive.hp(20)),
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total",
                                        style: AppTextStyle.textStyle(
                                            responsive.sp(40),
                                            AppColors.blackText,
                                            FontWeight.w600),
                                      ),
                                      Text(
                                        "${controller.total}\$",
                                        style: AppTextStyle.textStyle(
                                            responsive.sp(40),
                                            AppColors.primary,
                                            FontWeight.w600),
                                      )
                                    ],
                                  )),
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
                                  child: Text('Checkout',
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
                          "Basket is empty",
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
                          "to start your first order",
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
                            child: Text('Start Order',
                                style: AppTextStyle.textStyle(responsive.sp(35),
                                    AppColors.secondary, FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
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
  String? variantId;
  DateTime? createdAt;
  DateTime? updatedAt;

  CheckoutProduct({
    required this.productId,
    required this.imageUrl,
    required this.name,
    required this.price,
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

  factory CheckoutProduct.fromJson(Map<String, dynamic> json) {
    return CheckoutProduct(
      productId: json['productId'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
      variantId: json['variantId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

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
    int? quantity,
    String? variantId,
    DateTime? updatedAt,
  }) {
    return CheckoutProduct(
      productId: productId ?? this.productId,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      variantId: variantId ?? this.variantId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
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
                    Text("\$${widget.product.price.toStringAsFixed(2)}",
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
                                widget.controller.decreaseQuantity(widget.product);
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
                              widget.controller.increaseQuantity(widget.product);
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
