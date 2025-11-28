import 'package:demoecommerceproduct/controllers/basket_controller.dart';
import 'package:demoecommerceproduct/models/user_address_model.dart';
import 'package:demoecommerceproduct/screens/address_selection_screen.dart';
import 'package:demoecommerceproduct/screens/manual_address_input_screen.dart';
import 'package:demoecommerceproduct/screens/pages/basket_page.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CheckoutProduct> items;
  final double subtotal;
  final double deliveryCharge;

  const CheckoutScreen({
    super.key,
    required this.items,
    required this.subtotal,
    this.deliveryCharge = 0.0,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<UserAddress> _addresses = [];
  UserAddress? _selectedAddress;
  bool _isLoading = true;
  bool _isCheckoutExpanded = false; // State for expandable checkout section
  final BasketController _basketController = Get.find<BasketController>();

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses({bool selectNewest = false}) async {
    setState(() => _isLoading = true);
    try {
      ApisService.getUserAddresses(
        (addresses) {
          if (mounted) {
            setState(() {
              _addresses = addresses;

              if (selectNewest && addresses.isNotEmpty) {
                // Select the most recently added address (last in the list)
                _selectedAddress = addresses.last;
                if (_selectedAddress != null) {
                  _basketController.addressId.value =
                      _selectedAddress?.id ?? "";
                }
              } else {
                // Default behavior: select default address or first one
                _selectedAddress = addresses.firstWhere(
                  (addr) => addr.isDefault,
                  orElse: () => addresses.isNotEmpty
                      ? addresses.first
                      : UserAddress(
                          id: '',
                          userId: '',
                          title: '',
                          description: '',
                          phoneNumber: '',
                          longitude: 0.0,
                          latitude: 0.0,
                          isDefault: false,
                          createdAt: '',
                          updatedAt: '',
                        ),
                );
                if (_selectedAddress != null) {
                  _basketController.addressId.value =
                      _selectedAddress?.id ?? "";
                }
              }
              _isLoading = false;
            });
          }
        },
        (error) {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(responsive),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(responsive.wp(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAddressSection(responsive),
                              SizedBox(height: responsive.hp(20)),
                              _buildOrderSummarySection(responsive),
                              SizedBox(height: responsive.hp(20)),
                              _buildOrderItemsSection(responsive),
                              SizedBox(height: responsive.hp(100)),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
          // Floating checkout button
          if (!_isLoading)
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: _buildCheckoutButton(responsive),
                )),
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
                      'Checkout',
                      style: AppTextStyle.textStyle(
                        responsive.sp(50),
                        Colors.white,
                        FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Review your order',
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

  Widget _buildAddressSection(Responsive responsive) {
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
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: responsive.sp(35),
                ),
              ),
              SizedBox(width: responsive.wp(15)),
              Text(
                'Delivery Address',
                style: AppTextStyle.textStyle(
                  responsive.sp(42),
                  AppColors.blackText,
                  FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(20)),
          if (_addresses.isEmpty)
            _buildNoAddressCard(responsive)
          else
            _buildAddressCard(responsive),
          SizedBox(height: responsive.hp(15)),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  responsive,
                  'Add New Address',
                  Icons.add_location_alt_rounded,
                  () async {
                    final result =
                        await Get.to(() => const ManualAddressInputScreen());
                    if (result != null) {
                      // Address was successfully added, reload and select the newest one
                      _loadAddresses(selectNewest: true);
                    }
                  },
                  isSecondary: true,
                ),
              ),
              if (_addresses.isNotEmpty) ...[
                SizedBox(width: responsive.wp(10)),
                Expanded(
                  child: _buildActionButton(
                    responsive,
                    'Choose Address',
                    Icons.list_alt_rounded,
                    () async {
                      final selectedAddress =
                          await Get.to(() => AddressSelectionScreen(
                                currentSelectedAddress: _selectedAddress,
                              ));
                      if (selectedAddress != null &&
                          selectedAddress is UserAddress) {
                        setState(() {
                          _selectedAddress = selectedAddress;
                        });
                      }
                    },
                    isSecondary: true,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoAddressCard(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(20)),
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
          Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: responsive.sp(40),
          ),
          SizedBox(width: responsive.wp(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Address Added',
                  style: AppTextStyle.textStyle(
                    responsive.sp(35),
                    Colors.red,
                    FontWeight.w600,
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
                Text(
                  'Please add a delivery address to continue',
                  style: AppTextStyle.textStyle(
                    responsive.sp(30),
                    AppColors.greyText,
                    FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Responsive responsive) {
    if (_selectedAddress == null || _selectedAddress!.id.isEmpty) {
      return _buildNoAddressCard(responsive);
    }

    return Container(
      padding: EdgeInsets.all(responsive.wp(20)),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: responsive.sp(35),
              ),
              SizedBox(width: responsive.wp(10)),
              Expanded(
                child: Text(
                  _selectedAddress!.title,
                  style: AppTextStyle.textStyle(
                    responsive.sp(38),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_selectedAddress!.isDefault)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(10),
                    vertical: responsive.hp(5),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Default',
                    style: AppTextStyle.textStyle(
                      responsive.sp(25),
                      Colors.white,
                      FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: responsive.hp(10)),
          Text(
            _selectedAddress!.description,
            style: AppTextStyle.textStyle(
              responsive.sp(32),
              AppColors.greyText,
              FontWeight.w400,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (_selectedAddress!.phoneNumber.isNotEmpty) ...[
            SizedBox(height: responsive.hp(8)),
            Row(
              children: [
                Icon(
                  Icons.phone_rounded,
                  color: AppColors.greyText,
                  size: responsive.sp(28),
                ),
                SizedBox(width: responsive.wp(8)),
                Text(
                  _selectedAddress!.phoneNumber,
                  style: AppTextStyle.textStyle(
                    responsive.sp(30),
                    AppColors.greyText,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    Responsive responsive,
    String text,
    IconData icon,
    VoidCallback onTap, {
    bool isSecondary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(15),
          vertical: responsive.hp(12),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSecondary
                ? [
                    AppColors.primary.withOpacity(0.08),
                    AppColors.lightBlue.withOpacity(0.08),
                  ]
                : [
                    AppColors.primary.withOpacity(0.15),
                    AppColors.lightBlue.withOpacity(0.15),
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: responsive.sp(30),
            ),
            SizedBox(width: responsive.wp(8)),
            Expanded(
              child: Text(
                text,
                style: AppTextStyle.textStyle(
                  responsive.sp(20),
                  AppColors.primary,
                  FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummarySection(Responsive responsive) {
    final total = widget.subtotal + widget.deliveryCharge;

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
          SizedBox(height: responsive.hp(20)),
          _buildSummaryRow(responsive, 'Subtotal',
              '\$${widget.subtotal.toStringAsFixed(0)}'),
          SizedBox(height: responsive.hp(10)),
          _buildSummaryRow(
            responsive,
            'Delivery Charge',
            widget.deliveryCharge == 0
                ? 'Free'
                : '\$${widget.deliveryCharge.toStringAsFixed(0)}',
            isDelivery: true,
          ),
          SizedBox(height: responsive.hp(15)),
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
          SizedBox(height: responsive.hp(15)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyle.textStyle(
                  responsive.sp(45),
                  AppColors.blackText,
                  FontWeight.w800,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(15),
                  vertical: responsive.hp(8),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.15),
                      AppColors.lightBlue.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '\$${total.toStringAsFixed(0)}',
                  style: AppTextStyle.textStyle(
                    responsive.sp(45),
                    AppColors.primary,
                    FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(Responsive responsive, String label, String value,
      {bool isDelivery = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.textStyle(
            responsive.sp(35),
            AppColors.greyText,
            FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.textStyle(
            responsive.sp(35),
            isDelivery && widget.deliveryCharge == 0
                ? AppColors.primary
                : AppColors.blackText,
            FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemsSection(Responsive responsive) {
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
                'Order Items (${widget.items.length})',
                style: AppTextStyle.textStyle(
                  responsive.sp(42),
                  AppColors.blackText,
                  FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(20)),
          ...widget.items.map((item) => _buildOrderItem(responsive, item)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Responsive responsive, CheckoutProduct item) {
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
            width: responsive.wp(60),
            height: responsive.wp(60),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.primary,
                    size: responsive.sp(35),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: responsive.wp(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyle.textStyle(
                    responsive.sp(35),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.hp(5)),
                Text(
                  'Qty: ${item.quantity}',
                  style: AppTextStyle.textStyle(
                    responsive.sp(28),
                    AppColors.greyText,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(0)}',
            style: AppTextStyle.textStyle(
              responsive.sp(35),
              AppColors.primary,
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(Responsive responsive) {
    final canCheckout = _addresses.isNotEmpty &&
        _selectedAddress != null &&
        _selectedAddress!.id.isNotEmpty;
    final total = widget.subtotal + widget.deliveryCharge;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(20),
        vertical: responsive.hp(12),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isCheckoutExpanded = !_isCheckoutExpanded;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(20),
              vertical: responsive.hp(15),
            ),
            decoration: BoxDecoration(
              color: _isCheckoutExpanded
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.8),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, -5),
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Collapsed view - Always visible
                _buildCollapsedCheckoutView(responsive, total),

                // Expanded content - Shows when expanded
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      SizedBox(height: responsive.hp(20)),
                      // Order Summary in expanded state
                      _buildCompactOrderSummary(responsive),
                      SizedBox(height: responsive.hp(20)),
                      // Place Order Button
                      _buildPlaceOrderButton(responsive, canCheckout),
                    ],
                  ),
                  crossFadeState: _isCheckoutExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedCheckoutView(Responsive responsive, double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Total and action text
        Expanded(
          child: Row(
            children: [
              // Total label and price
              Text(
                'Total: ',
                style: AppTextStyle.textStyle(
                  responsive.sp(40),
                  AppColors.blackText,
                  FontWeight.bold,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(0)}',
                style: AppTextStyle.textStyle(
                  responsive.sp(38),
                  Colors.white,
                  FontWeight.w500,
                ),
              ),
              SizedBox(width: responsive.wp(8)),
              // Separator
              Container(
                height: responsive.hp(25),
                width: 1.5,
                color: AppColors.blackText.withOpacity(0.8),
              ),
              SizedBox(width: responsive.wp(8)),
              // Press to place order text
              Expanded(
                child: Text(
                  'Press to Place order',
                  style: AppTextStyle.textStyle(
                    responsive.sp(32),
                    AppColors.blackText,
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Expand/Collapse indicator
        Container(
          padding: EdgeInsets.all(responsive.wp(10)),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedRotation(
            turns: _isCheckoutExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Colors.white,
              size: responsive.sp(38),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactOrderSummary(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(20)),
      decoration: BoxDecoration(
        color: AppColors.greyBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildSummaryRow(responsive, 'Subtotal',
              '\$${widget.subtotal.toStringAsFixed(0)}'),
          SizedBox(height: responsive.hp(10)),
          _buildSummaryRow(
            responsive,
            'Delivery Charge',
            widget.deliveryCharge == 0
                ? 'Free'
                : '\$${widget.deliveryCharge.toStringAsFixed(0)}',
            isDelivery: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(Responsive responsive, bool canCheckout) {
    return Container(
      width: double.infinity,
      height: responsive.hp(70),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: canCheckout
              ? [
                  Colors.white,
                  Colors.white.withOpacity(0.8),
                ]
              : [
                  AppColors.greyText.withOpacity(0.5),
                  AppColors.greyText.withOpacity(0.3),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: canCheckout
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: canCheckout && !_basketController.isLoading.value
            ? _handleCheckout
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Obx(() => _basketController.isLoading.value
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment_rounded,
                    color: AppColors.primary,
                    size: responsive.sp(45),
                  ),
                  SizedBox(width: responsive.wp(15)),
                  Text(
                    canCheckout ? 'Place Order' : 'Select Address to Continue',
                    style: AppTextStyle.textStyle(
                      responsive.sp(40),
                      AppColors.primary,
                      FontWeight.w700,
                    ),
                  ),
                ],
              )),
      ),
    );
  }

  void _handleCheckout() async {
    if (!(_addresses.isNotEmpty &&
        _selectedAddress != null &&
        _selectedAddress!.id.isNotEmpty)) {
      Get.snackbar(
        'Address Required',
        'Please select a delivery address to continue',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Call the checkoutOrder function from BasketController
    _basketController.checkoutOrder(context);

    // Navigate back to basket page after successful checkout
    // The BasketController will handle success/error messages
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!_basketController.isLoading.value) {
        Get.back(); // Go back to basket
      }
    });
  }
}
