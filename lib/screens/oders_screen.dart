import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OdersScreen extends StatefulWidget {
  const OdersScreen({super.key});

  @override
  State<OdersScreen> createState() => _OdersScreenState();
}

class _OdersScreenState extends State<OdersScreen> {
  final List<Order> orders = [
    // Order(
    //   orderId: 'ORD12345',
    //   date: '2025-06-28',
    //   total: 75.50,
    //   status: 'Delivered',
    //   items: [
    //     OrderItem(name: 'Sneakers', quantity: 1, price: 50.0),
    //     OrderItem(name: 'Socks', quantity: 2, price: 12.75),
    //   ],
    // ),
    // Order(
    //   orderId: 'ORD67890',
    //   date: '2025-06-25',
    //   total: 45.20,
    //   status: 'Shipped',
    //   items: [
    //     OrderItem(name: 'T-Shirt', quantity: 1, price: 20.0),
    //     OrderItem(name: 'Hat', quantity: 1, price: 25.2),
    //   ],
    // ),
  ];
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.greyBackground,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset("assets/icons/ArrowLeft.png")),
        title: Center(
          child: Text(
            "Orders",
            style: AppTextStyle.textStyle(
                responsive.sp(40), AppColors.blackText, FontWeight.w600),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: responsive.wp(50)),
          )
        ],
      ),
      body: orders.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: orders[index]);
                      },
                    ),
                  ),
                ),
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
                      "assets/images/Saly-11.png",
                      height: responsive.hp(400),
                    ),
                    Text(
                      "No history yet",
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
                      "to start ordering",
                      style: AppTextStyle.textStyle(responsive.sp(30),
                          AppColors.greyText, FontWeight.w600),
                    ),
                    SizedBox(height: responsive.hp(10)),
                    Container(
                      width: responsive.wp(250),
                      height: responsive.hp(45),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text('Start Ordering',
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
  final Order product;

  const ProductCard({required this.product, super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Order Id : ",
                        style: AppTextStyle.textStyle(responsive.sp(30),
                            AppColors.blackText, FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.product.orderId,
                        style: AppTextStyle.textStyle(responsive.sp(30),
                            AppColors.blackText, FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.hp(3)),
                  Row(
                    children: [
                      Text("Order Price : ",
                          style: AppTextStyle.textStyle(
                            responsive.sp(30),
                            AppColors.primary,
                            FontWeight.bold,
                          )),
                      Text("\$${widget.product.total.toStringAsFixed(2)}",
                          style: AppTextStyle.textStyle(
                            responsive.sp(30),
                            AppColors.primary,
                            FontWeight.bold,
                          )),
                    ],
                  ),
                  SizedBox(height: responsive.hp(5)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Order {
  final String orderId;
  final String date;
  final double total;
  final String status;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
