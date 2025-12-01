import 'package:demoecommerceproduct/models/stock_availability_model.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockAvailabilityDialog extends StatefulWidget {
  final List<UnavailableItem> unavailableItems;
  final List<CheckoutProduct> basketProducts;
  final Function(List<CheckoutProduct> updatedProducts) onContinue;

  const StockAvailabilityDialog({
    super.key,
    required this.unavailableItems,
    required this.basketProducts,
    required this.onContinue,
  });

  @override
  State<StockAvailabilityDialog> createState() =>
      _StockAvailabilityDialogState();
}

class _StockAvailabilityDialogState extends State<StockAvailabilityDialog> {
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(responsive),

            // Content
            Expanded(
              child: SingleChildScrollView(
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
      padding: EdgeInsets.all(responsive.wp(20)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.wp(10)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: Colors.white,
              size: responsive.sp(40),
            ),
          ),
          SizedBox(width: responsive.wp(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stock Availability',
                  style: AppTextStyle.textStyle(
                    responsive.sp(42),
                    Colors.white,
                    FontWeight.w800,
                  ),
                ),
                Text(
                  'Some items need your attention',
                  style: AppTextStyle.textStyle(
                    responsive.sp(30),
                    Colors.white.withOpacity(0.9),
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

  Widget _buildSectionTitle(Responsive responsive, String title,
      String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(15)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: responsive.sp(40)),
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
                Text(
                  subtitle,
                  style: AppTextStyle.textStyle(
                    responsive.sp(28),
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
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.red.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: responsive.wp(70),
            height: responsive.hp(70),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
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
                    responsive.sp(35),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.hp(5)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(10),
                    vertical: responsive.hp(4),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'OUT OF STOCK',
                    style: AppTextStyle.textStyle(
                      responsive.sp(26),
                      Colors.white,
                      FontWeight.w700,
                    ),
                  ),
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
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.orange.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Product Image
              Container(
                width: responsive.wp(70),
                height: responsive.hp(70),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
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
                        responsive.sp(35),
                        AppColors.blackText,
                        FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: responsive.hp(5)),
                    Row(
                      children: [
                        Text(
                          'Requested: ${product.quantity}',
                          style: AppTextStyle.textStyle(
                            responsive.sp(30),
                            AppColors.greyText,
                            FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: responsive.wp(10)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(10),
                            vertical: responsive.hp(4),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Available: ${item.quantity}',
                            style: AppTextStyle.textStyle(
                              responsive.sp(26),
                              Colors.white,
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: responsive.hp(12)),

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
                      vertical: responsive.hp(12),
                    ),
                    decoration: BoxDecoration(
                      color: updateQuantity
                          ? AppColors.primary
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: updateQuantity
                            ? AppColors.primary
                            : Colors.grey.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.update_rounded,
                          color:
                              updateQuantity ? Colors.white : AppColors.greyText,
                          size: responsive.sp(35),
                        ),
                        SizedBox(width: responsive.wp(8)),
                        Text(
                          'Update to ${item.quantity}',
                          style: AppTextStyle.textStyle(
                            responsive.sp(30),
                            updateQuantity ? Colors.white : AppColors.greyText,
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.wp(10)),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _updateQuantityFlags[key] = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.hp(12),
                    ),
                    decoration: BoxDecoration(
                      color: !updateQuantity
                          ? Colors.red
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !updateQuantity
                            ? Colors.red
                            : Colors.grey.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color:
                              !updateQuantity ? Colors.white : AppColors.greyText,
                          size: responsive.sp(35),
                        ),
                        SizedBox(width: responsive.wp(8)),
                        Text(
                          'Remove',
                          style: AppTextStyle.textStyle(
                            responsive.sp(30),
                            !updateQuantity ? Colors.white : AppColors.greyText,
                            FontWeight.w600,
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
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: responsive.hp(60),
        child: ElevatedButton(
          onPressed: _handleContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: responsive.sp(40),
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
    );
  }

  void _handleContinue() {
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

    widget.onContinue(updatedProducts);
    Get.back();
  }
}
