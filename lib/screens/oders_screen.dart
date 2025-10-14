import 'package:demoecommerceproduct/models/order_model.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OdersScreen extends StatefulWidget {
  const OdersScreen({super.key});

  @override
  State<OdersScreen> createState() => _OdersScreenState();
}

class _OdersScreenState extends State<OdersScreen> {
  bool isLoading = false;
  final List<OrderModel> orders = [
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
    // Order(
    //   orderId: 'ORD33445',
    //   date: '2025-06-20',
    //   total: 120.75,
    //   status: 'Processing',
    //   items: [
    //     OrderItem(name: 'Smartphone Case', quantity: 1, price: 25.0),
    //     OrderItem(name: 'Wireless Earbuds', quantity: 1, price: 95.75),
    //   ],
    // ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    ApisService.getOrdersHistory((response) async {
      setState(() {
        isLoading = false;
      });
      orders.addAll(response);
    }, (fail) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return isLoading
        ? Container(
            color: Colors.white,
            child: const Center(
                child: CircularProgressIndicator(
              color: AppColors.primary,
            )))
        : Scaffold(
            backgroundColor: AppColors.greyBackground,
            body: Column(
              children: [
                // Enhanced Header
                _buildEnhancedHeader(responsive),

                // Enhanced Body Content
                Expanded(
                  child: orders.isNotEmpty
                      ? _buildOrdersContent(responsive)
                      : _buildEmptyOrdersState(responsive),
                ),
              ],
            ),
          );
  }

  Widget _buildEnhancedHeader(Responsive responsive) {
    return Container(
      height: responsive.hp(137),
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
              // Back Button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(responsive.wp(12)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: responsive.sp(40),
                  ),
                ),
              ),
              SizedBox(width: responsive.wp(15)),

              // Orders Icon
              // Container(
              //   padding: EdgeInsets.all(responsive.wp(12)),
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.2),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: Icon(
              //     Icons.history_rounded,
              //     color: Colors.white,
              //     size: responsive.sp(45),
              //   ),
              // ),
              SizedBox(width: responsive.wp(15)),

              // Title Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Order History',
                      style: AppTextStyle.textStyle(
                        responsive.sp(50),
                        Colors.white,
                        FontWeight.w800,
                      ),
                    ),
                    Text(
                      orders.isNotEmpty
                          ? '${orders.length} orders'
                          : 'No orders yet',
                      style: AppTextStyle.textStyle(
                        responsive.sp(32),
                        Colors.white.withOpacity(0.9),
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersContent(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.only(
        left: responsive.wp(10),
        right: responsive.wp(10),
      ),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: responsive.hp(20)),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return index == orders.length - 1
              ? Column(children: [
                  EnhancedOrderCard(
                    order: orders[index],
                    responsive: responsive,
                  ),
                  SizedBox(height: responsive.hp(70))
                ])
              : EnhancedOrderCard(
                  order: orders[index],
                  responsive: responsive,
                );
        },
      ),
    );
  }

  Widget _buildEmptyOrdersState(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(30)),
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
              Icons.receipt_long_outlined,
              size: responsive.sp(120),
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: responsive.hp(30)),

          Text(
            'No Order History',
            style: AppTextStyle.textStyle(
              responsive.sp(50),
              AppColors.blackText,
              FontWeight.w800,
            ),
          ),

          SizedBox(height: responsive.hp(15)),

          Text(
            'You haven\'t placed any orders yet. Start browsing our amazing products and make your first purchase!',
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
              onPressed: () => Get.back(),
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
      ),
    );
  }
}

class EnhancedOrderCard extends StatelessWidget {
  final OrderModel order;
  final Responsive responsive;

  const EnhancedOrderCard({
    super.key,
    required this.order,
    required this.responsive,
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
            // Handle order tap for details
            _showOrderDetails(context);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(responsive.wp(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Order ID Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID',
                          style: AppTextStyle.textStyle(
                            responsive.sp(28),
                            AppColors.greyText,
                            FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: responsive.hp(2)),
                        SizedBox(
                          width: responsive.wp(150),
                          child: Text(
                            order.id ?? "N/A",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppTextStyle.textStyle(
                              responsive.sp(35),
                              AppColors.blackText,
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Order Status
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(15),
                        vertical: responsive.hp(8),
                      ),
                      decoration: BoxDecoration(
                        color: Colors
                            .white, //_getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors
                              .white, //_getStatusColor(order.status).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: responsive.wp(8),
                            height: responsive.wp(8),
                            decoration: BoxDecoration(
                              color:
                                  Colors.white, //_getStatusColor(order.status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: responsive.wp(8)),
                          Text(
                            order.currentStatus ?? "N/A",
                            style: AppTextStyle.textStyle(
                              responsive.sp(28),
                              AppColors.primary,
                              //  _getStatusColor(order.status),
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: responsive.hp(15)),

                // Order Details Row
                Row(
                  children: [
                    // Order Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Date',
                            style: AppTextStyle.textStyle(
                              responsive.sp(28),
                              AppColors.greyText,
                              FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: responsive.hp(3)),
                          Text(
                            order.createdAt != null
                                ? DateFormat('yyyy-MM-dd').format(
                                    DateTime.parse(order.createdAt ?? ""))
                                : 'N/A',
                            style: AppTextStyle.textStyle(
                              responsive.sp(32),
                              AppColors.blackText,
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Order Total
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total Amount',
                          style: AppTextStyle.textStyle(
                            responsive.sp(28),
                            AppColors.greyText,
                            FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: responsive.hp(3)),
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
                            "\$${order.totalSelling?.toStringAsFixed(2)}",
                            style: AppTextStyle.textStyle(
                              responsive.sp(35),
                              AppColors.primary,
                              FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: responsive.hp(15)),

                // Order Items Summary
                Container(
                  padding: EdgeInsets.all(responsive.wp(15)),
                  decoration: BoxDecoration(
                    color: AppColors.greyBackground.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
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
                          Icons.inventory_2_outlined,
                          color: AppColors.primary,
                          size: responsive.sp(30),
                        ),
                      ),
                      SizedBox(width: responsive.wp(12)),
                      Expanded(
                        child: Text(
                          '${order.orderItems?.length} items ordered',
                          style: AppTextStyle.textStyle(
                            responsive.sp(32),
                            AppColors.blackText,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(responsive.wp(8)),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.primary,
                          size: responsive.sp(25),
                        ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  void _showOrderDetails(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Order Details',
          style: AppTextStyle.textStyle(
            responsive.sp(45),
            AppColors.blackText,
            FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.id}',
              style: AppTextStyle.textStyle(
                responsive.sp(32),
                AppColors.greyText,
                FontWeight.w500,
              ),
            ),
            SizedBox(height: responsive.hp(10)),
            Text(
              'Date: ${order.createdAt ?? "N/A"}',
              style: AppTextStyle.textStyle(
                responsive.sp(32),
                AppColors.greyText,
                FontWeight.w500,
              ),
            ),
            SizedBox(height: responsive.hp(10)),
            Text(
              'Total: \$${order.totalSelling?.toStringAsFixed(2)}',
              style: AppTextStyle.textStyle(
                responsive.sp(32),
                AppColors.primary,
                FontWeight.w700,
              ),
            ),
            SizedBox(height: responsive.hp(15)),
            Text(
              'Items:',
              style: AppTextStyle.textStyle(
                responsive.sp(35),
                AppColors.blackText,
                FontWeight.w600,
              ),
            ),
            SizedBox(height: responsive.hp(2)),
            SizedBox(
              width: responsive.wp(400),
              height: responsive.hp(300),
              child: ListView.builder(
                  itemCount: order.orderItems?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: responsive.hp(5)),
                      child: Text(
                        '• ${order.orderItems?[index].name} x \$${order.orderItems?[index].sellingPrice.toStringAsFixed(2)}',
                        style: AppTextStyle.textStyle(
                          responsive.sp(30),
                          AppColors.greyText,
                          FontWeight.w400,
                        ),
                      ),
                    );
                  }),
            )
            // ...order.orderItems!.map((item) => Padding(
            //       padding: EdgeInsets.only(top: responsive.hp(5)),
            //       child: Text(
            //         '• ${item.name} x \$${item.sellingPrice.toStringAsFixed(2)}',
            //         style: AppTextStyle.textStyle(
            //           responsive.sp(30),
            //           AppColors.greyText,
            //           FontWeight.w400,
            //         ),
            //       ),
            //     )
            //  ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Close',
              style: AppTextStyle.textStyle(
                responsive.sp(32),
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

// class ProductCard extends StatefulWidget {
//   final OrderModel product;

//   const ProductCard({required this.product, super.key});

//   @override
//   State<ProductCard> createState() => _ProductCardState();
// }

// class _ProductCardState extends State<ProductCard> {
//   @override
//   Widget build(BuildContext context) {
//     var responsive = Responsive(context);
//     return EnhancedOrderCard(
//       order: widget.product,
//       responsive: responsive,
//     );
//   }
// }

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
