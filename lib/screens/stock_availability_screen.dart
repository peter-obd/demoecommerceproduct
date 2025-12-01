import 'package:demoecommerceproduct/models/stock_availability_model.dart';
import 'package:demoecommerceproduct/screens/checkout_screen.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockAvailabilityScreen extends StatefulWidget {
  final List<UnavailableItem> unavailableItems;
  final List<CheckoutProduct> basketProducts;
  final Function(List<CheckoutProduct> updatedProducts) onContinue;
  final double subtotal;
  final double deliveryCharge;

  const StockAvailabilityScreen({
    super.key,
    required this.unavailableItems,
    required this.basketProducts,
    required this.onContinue,
    required this.subtotal,
    required this.deliveryCharge,
  });

  @override
  State<StockAvailabilityScreen> createState() =>
      _StockAvailabilityScreenState();
}

class _StockAvailabilityScreenState extends State<StockAvailabilityScreen> {
  late List<UnavailableItem> _outOfStockItems;
  late List<UnavailableItem> _limitedStockItems;
  final Map<String, bool> _updateQuantityFlags = {};

  @override
  void initState() {
    super.initState();

    // Separate out of stock and limited stock items
    _outOfStockItems =
        widget.unavailableItems.where((item) => item.isOutOfStock).toList();
    _limitedStockItems =
        widget.unavailableItems.where((item) => item.hasLimitedStock).toList();

    // Initialize flags for limited stock items
    for (var item in _limitedStockItems) {
      String key = _getProductKey(item.productId, item.variantId);
      _updateQuantityFlags[key] = true; // Default to updating quantity
    }
  }

  String _getProductKey(String productId, String? variantId) {
    return variantId != null ? '${productId}_$variantId' : productId;
  }

  CheckoutProduct? _findProduct(String productId, String? variantId) {
    return widget.basketProducts.firstWhereOrNull(
      (p) => p.productId == productId && p.variantId == variantId,
    );
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);

    return PopScope(
      canPop: false, // Prevent back button
      child: Scaffold(
        backgroundColor: AppColors.greyBackground,
        body: Column(
          children: [
            // Header
            // SizedBox(height: responsive.hp(40)),
            _buildHeader(responsive),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(responsive.wp(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Out of Stock Section
                    if (_outOfStockItems.isNotEmpty) ...[
                      _buildSectionTitle(
                        responsive,
                        'Out of Stock',
                        'These items will be removed from your basket',
                        Icons.cancel_outlined,
                        Colors.red,
                      ),
                      SizedBox(height: responsive.hp(15)),
                      ..._outOfStockItems.map(
                        (item) => _buildOutOfStockItem(responsive, item),
                      ),
                      SizedBox(height: responsive.hp(25)),
                    ],

                    // Limited Stock Section
                    if (_limitedStockItems.isNotEmpty) ...[
                      _buildSectionTitle(
                        responsive,
                        'Limited Availability',
                        'Choose to update quantity or remove these items',
                        Icons.warning_amber_rounded,
                        Colors.orange,
                      ),
                      SizedBox(height: responsive.hp(15)),
                      ..._limitedStockItems.map(
                        (item) => _buildLimitedStockItem(responsive, item),
                      ),
                    ],

                    SizedBox(height: responsive.hp(100)),
                  ],
                ),
              ),
            ),

            // Footer with Continue Button
            _buildFooter(responsive),
          ],
        ),
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
                      'Stock Availability',
                      style: AppTextStyle.textStyle(
                        responsive.sp(50),
                        Colors.white,
                        FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Some items need your attention',
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

  Widget _buildSectionTitle(Responsive responsive, String title,
      String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(15)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.wp(10)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: responsive.sp(40)),
          ),
          SizedBox(width: responsive.wp(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.textStyle(
                    responsive.sp(38),
                    color,
                    FontWeight.w700,
                  ),
                ),
                SizedBox(height: responsive.hp(3)),
                Text(
                  subtitle,
                  style: AppTextStyle.textStyle(
                    responsive.sp(30),
                    AppColors.greyText,
                    FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutOfStockItem(Responsive responsive, UnavailableItem item) {
    final product = _findProduct(item.productId, item.variantId);
    if (product == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(12)),
      padding: EdgeInsets.all(responsive.wp(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: responsive.wp(80),
            height: responsive.hp(80),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.1),
                  Colors.red.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported_outlined,
                    size: responsive.sp(40),
                    color: AppColors.greyText,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: responsive.wp(15)),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyle.textStyle(
                    responsive.sp(36),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.hp(8)),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(12),
                        vertical: responsive.hp(6),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: responsive.sp(30),
                          ),
                          SizedBox(width: responsive.wp(5)),
                          Text(
                            'OUT OF STOCK',
                            style: AppTextStyle.textStyle(
                              responsive.sp(28),
                              Colors.white,
                              FontWeight.w700,
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
    );
  }

  Widget _buildLimitedStockItem(Responsive responsive, UnavailableItem item) {
    final product = _findProduct(item.productId, item.variantId);
    if (product == null) return const SizedBox.shrink();

    String key = _getProductKey(item.productId, item.variantId);
    bool updateQuantity = _updateQuantityFlags[key] ?? true;

    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(12)),
      padding: EdgeInsets.all(responsive.wp(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Product Image
              Container(
                width: responsive.wp(80),
                height: responsive.hp(80),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withOpacity(0.1),
                      Colors.orange.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported_outlined,
                        size: responsive.sp(40),
                        color: AppColors.greyText,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: responsive.wp(15)),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyle.textStyle(
                        responsive.sp(36),
                        AppColors.blackText,
                        FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: responsive.hp(8)),
                    Wrap(
                      spacing: responsive.wp(8),
                      runSpacing: responsive.hp(5),
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(12),
                            vertical: responsive.hp(6),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greyText.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Requested quantity: ${product.quantity}',
                            style: AppTextStyle.textStyle(
                              responsive.sp(28),
                              AppColors.blackText,
                              FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(12),
                            vertical: responsive.hp(6),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: responsive.sp(28),
                              ),
                              SizedBox(width: responsive.wp(5)),
                              Text(
                                'Available quantity: ${item.quantity}',
                                style: AppTextStyle.textStyle(
                                  responsive.sp(28),
                                  Colors.white,
                                  FontWeight.w700,
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

          SizedBox(height: responsive.hp(15)),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _updateQuantityFlags[key] = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.hp(15),
                    ),
                    decoration: BoxDecoration(
                      gradient: updateQuantity
                          ? LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0.8),
                              ],
                            )
                          : null,
                      color:
                          updateQuantity ? null : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: updateQuantity
                            ? AppColors.primary
                            : Colors.grey.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.update_rounded,
                          color: updateQuantity
                              ? Colors.white
                              : AppColors.greyText,
                          size: responsive.sp(38),
                        ),
                        SizedBox(width: responsive.wp(10)),
                        Flexible(
                          child: Text(
                            'Update to ${item.quantity}',
                            style: AppTextStyle.textStyle(
                              responsive.sp(32),
                              updateQuantity
                                  ? Colors.white
                                  : AppColors.greyText,
                              FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.wp(12)),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _updateQuantityFlags[key] = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.hp(15),
                    ),
                    decoration: BoxDecoration(
                      color: !updateQuantity
                          ? Colors.red
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: !updateQuantity
                            ? Colors.red
                            : Colors.grey.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: !updateQuantity
                              ? Colors.white
                              : AppColors.greyText,
                          size: responsive.sp(38),
                        ),
                        SizedBox(width: responsive.wp(10)),
                        Text(
                          'Remove',
                          style: AppTextStyle.textStyle(
                            responsive.sp(32),
                            !updateQuantity ? Colors.white : AppColors.greyText,
                            FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: responsive.hp(65),
          child: ElevatedButton(
            onPressed: _handleContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_checkout_rounded,
                  color: Colors.white,
                  size: responsive.sp(42),
                ),
                SizedBox(width: responsive.wp(12)),
                Text(
                  'Continue to Checkout',
                  style: AppTextStyle.textStyle(
                    responsive.sp(38),
                    Colors.white,
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() async {
    List<CheckoutProduct> updatedProducts = [];

    for (var product in widget.basketProducts) {
      String key = _getProductKey(product.productId, product.variantId);

      // Check if product is out of stock (should be removed)
      bool isOutOfStock = _outOfStockItems.any(
        (item) =>
            item.productId == product.productId &&
            item.variantId == product.variantId,
      );

      if (isOutOfStock) {
        // Skip out of stock products (remove them)
        continue;
      }

      // Check if product has limited stock
      UnavailableItem? limitedItem = _limitedStockItems.firstWhereOrNull(
        (item) =>
            item.productId == product.productId &&
            item.variantId == product.variantId,
      );

      if (limitedItem != null) {
        // Check user's choice
        bool shouldUpdate = _updateQuantityFlags[key] ?? true;
        if (shouldUpdate) {
          // Update quantity to available amount
          updatedProducts.add(
            product.copyWith(quantity: limitedItem.quantity),
          );
        }
        // If not updating, skip this product (remove it)
      } else {
        // Product is available, keep it as is
        updatedProducts.add(product);
      }
    }

    // Update basket
    await widget.onContinue(updatedProducts);

    // Navigate to checkout, removing this stock availability screen from stack
    if (updatedProducts.isNotEmpty) {
      Get.off(
        () => CheckoutScreen(
          items: updatedProducts,
          subtotal: widget.subtotal,
          deliveryCharge: widget.deliveryCharge,
        ),
      );
    } else {
      // If no products left, go back to basket
      Get.back();
    }
  }
}
