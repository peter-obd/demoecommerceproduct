import 'package:demoecommerceproduct/models/order_model.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Column(
        children: [
          _buildHeader(responsive),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(responsive.wp(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderSummaryCard(responsive),
                    SizedBox(height: responsive.hp(20)),
                    _buildOrderItemsCard(responsive),
                    SizedBox(height: responsive.hp(20)),
                    // _buildOrderInformationCard(responsive),
                    SizedBox(height: responsive.hp(100)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Responsive responsive) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Order Details',
                      style: AppTextStyle.textStyle(
                        responsive.sp(50),
                        Colors.white,
                        FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Order #${order.id?.substring(0, 8) ?? "N/A"}',
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

  Widget _buildOrderSummaryCard(Responsive responsive) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.wp(25)),
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(responsive.wp(12)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                  size: responsive.sp(35),
                ),
              ),
              SizedBox(width: responsive.wp(15)),
              Text(
                'Order Summary',
                style: AppTextStyle.textStyle(
                  responsive.sp(42),
                  AppColors.blackText,
                  FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(25)),
          Container(
            padding: EdgeInsets.all(responsive.wp(20)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  AppColors.lightBlue.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: AppTextStyle.textStyle(
                        responsive.sp(32),
                        AppColors.greyText,
                        FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: responsive.hp(5)),
                    Text(
                      '\$${order.totalSelling?.toStringAsFixed(0) ?? "0.00"}',
                      style: AppTextStyle.textStyle(
                        responsive.sp(48),
                        AppColors.primary,
                        FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(15),
                    vertical: responsive.hp(8),
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.currentStatus ?? "")
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(order.currentStatus ?? "")
                          .withOpacity(0.3),
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
                          color: _getStatusColor(order.currentStatus ?? ""),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: responsive.wp(8)),
                      Text(
                        order.currentStatus ?? "N/A",
                        style: AppTextStyle.textStyle(
                          responsive.sp(28),
                          _getStatusColor(order.currentStatus ?? ""),
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.hp(20)),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  responsive,
                  'Order Date',
                  order.createdAt != null
                      ? DateFormat('MMM dd, yyyy')
                          .format(DateTime.parse(order.createdAt ?? ""))
                      : 'N/A',
                  Icons.calendar_today_rounded,
                ),
              ),
              SizedBox(width: responsive.wp(15)),
              Expanded(
                child: _buildInfoItem(
                  responsive,
                  'Items',
                  '${order.orderItems?.length ?? 0}',
                  Icons.inventory_2_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      Responsive responsive, String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(15)),
      decoration: BoxDecoration(
        color: AppColors.greyBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: responsive.sp(28),
              ),
              SizedBox(width: responsive.wp(8)),
              Text(
                label,
                style: AppTextStyle.textStyle(
                  responsive.sp(28),
                  AppColors.greyText,
                  FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(8)),
          Text(
            value,
            style: AppTextStyle.textStyle(
              responsive.sp(32),
              AppColors.blackText,
              FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsCard(Responsive responsive) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.wp(25)),
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(responsive.wp(12)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primary,
                  size: responsive.sp(35),
                ),
              ),
              SizedBox(width: responsive.wp(15)),
              Text(
                'Order Items',
                style: AppTextStyle.textStyle(
                  responsive.sp(42),
                  AppColors.blackText,
                  FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(20)),
          if (order.orderItems != null && order.orderItems!.isNotEmpty)
            ...order.orderItems!
                .map((item) => _buildOrderItemRow(responsive, item))
          else
            Container(
              padding: EdgeInsets.all(responsive.wp(20)),
              decoration: BoxDecoration(
                color: AppColors.greyBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'No items found',
                  style: AppTextStyle.textStyle(
                    responsive.sp(32),
                    AppColors.greyText,
                    FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(Responsive responsive, OrderItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(12)),
      padding: EdgeInsets.all(responsive.wp(15)),
      decoration: BoxDecoration(
        color: AppColors.greyBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.greyBackground,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: responsive.wp(50),
            height: responsive.wp(50),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primary,
              size: responsive.sp(30),
            ),
          ),
          SizedBox(width: responsive.wp(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'Unknown Product',
                  style: AppTextStyle.textStyle(
                    responsive.sp(35),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.hp(5)),
                // if (item.variantName != null && item.variantName!.isNotEmpty)
                //   Text(
                //     'Variant: ${item.variantName}',
                //     style: AppTextStyle.textStyle(
                //       responsive.sp(28),
                //       AppColors.greyText,
                //       FontWeight.w400,
                //     ),
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //   ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Qty: ${item.quantity ?? 0}',
                style: AppTextStyle.textStyle(
                  responsive.sp(28),
                  AppColors.greyText,
                  FontWeight.w500,
                ),
              ),
              SizedBox(height: responsive.hp(3)),
              Text(
                '\$${item.unitPrice?.toStringAsFixed(0) ?? "0.00"}',
                style: AppTextStyle.textStyle(
                  responsive.sp(35),
                  AppColors.primary,
                  FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInformationCard(Responsive responsive) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.wp(25)),
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(responsive.wp(12)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: responsive.sp(35),
                ),
              ),
              SizedBox(width: responsive.wp(15)),
              Text(
                'Order Information',
                style: AppTextStyle.textStyle(
                  responsive.sp(42),
                  AppColors.blackText,
                  FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(20)),
          _buildInfoRow(responsive, 'Order ID', order.id ?? 'N/A'),
          _buildInfoRow(responsive, 'User ID', order.userId ?? 'N/A'),
          if (order.couponCode != null && order.couponCode!.isNotEmpty)
            _buildInfoRow(responsive, 'Coupon Code', order.couponCode!),
          if (order.discount != null && order.discount! > 0)
            _buildInfoRow(responsive, 'Discount',
                '\$${order.discount?.toStringAsFixed(0)}'),
          if (order.deliveryCharge != null && order.deliveryCharge! > 0)
            _buildInfoRow(responsive, 'Delivery Charge',
                '\$${order.deliveryCharge?.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(Responsive responsive, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.hp(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: responsive.wp(120),
            child: Text(
              label,
              style: AppTextStyle.textStyle(
                responsive.sp(32),
                AppColors.greyText,
                FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: responsive.wp(10)),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.textStyle(
                responsive.sp(32),
                AppColors.blackText,
                FontWeight.w600,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
      case 'pending':
        return Colors.amber;
      default:
        return AppColors.primary;
    }
  }
}
