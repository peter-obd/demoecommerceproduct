import 'package:demoecommerceproduct/models/user_address_model.dart';
import 'package:demoecommerceproduct/screens/location_address_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressSelectionScreen extends StatefulWidget {
  final UserAddress? currentSelectedAddress;

  const AddressSelectionScreen({
    super.key,
    this.currentSelectedAddress,
  });

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  List<UserAddress> _addresses = [];
  UserAddress? _selectedAddress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.currentSelectedAddress;
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    try {
      ApisService.getUserAddresses(
        (addresses) {
          if (mounted) {
            setState(() {
              _addresses = addresses;
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
      body: Column(
        children: [
          _buildHeader(responsive),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : _addresses.isEmpty
                    ? _buildEmptyState(responsive)
                    : _buildAddressList(responsive),
          ),
          if (!_isLoading) _buildBottomButtons(responsive),
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
                      'Choose Address',
                      style: AppTextStyle.textStyle(
                        responsive.sp(50),
                        Colors.white,
                        FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Select where you want your order delivered',
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

  Widget _buildAddressList(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.all(responsive.wp(20)),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          final isSelected = _selectedAddress?.id == address.id;

          return Container(
            margin: EdgeInsets.only(bottom: responsive.hp(15)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.15)
                      : AppColors.primary.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: isSelected ? 3 : 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedAddress = address;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.all(responsive.wp(20)),
                  child: Row(
                    children: [
                      // Selection Radio Button
                      Container(
                        width: responsive.wp(50),
                        height: responsive.wp(50),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.greyText.withOpacity(0.3),
                            width: 2,
                          ),
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: responsive.sp(30),
                              )
                            : null,
                      ),

                      SizedBox(width: responsive.wp(15)),

                      // Address Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    address.title,
                                    style: AppTextStyle.textStyle(
                                      responsive.sp(38),
                                      AppColors.blackText,
                                      FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (address.isDefault) ...[
                                  SizedBox(width: responsive.wp(10)),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: responsive.wp(10),
                                      vertical: responsive.hp(5),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:
                                            AppColors.primary.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'Default',
                                      style: AppTextStyle.textStyle(
                                        responsive.sp(25),
                                        AppColors.primary,
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: responsive.hp(8)),
                            Text(
                              address.description,
                              style: AppTextStyle.textStyle(
                                responsive.sp(32),
                                AppColors.greyText,
                                FontWeight.w400,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (address.phoneNumber.isNotEmpty) ...[
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
                                    address.phoneNumber,
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
                      ),

                      // Location Icon
                      Container(
                        padding: EdgeInsets.all(responsive.wp(12)),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.greyBackground.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.greyText,
                          size: responsive.sp(35),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(40)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
              Icons.location_off_outlined,
              size: responsive.sp(120),
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: responsive.hp(30)),
          Text(
            'No Addresses Found',
            style: AppTextStyle.textStyle(
              responsive.sp(50),
              AppColors.blackText,
              FontWeight.w800,
            ),
          ),
          SizedBox(height: responsive.hp(15)),
          Text(
            'You haven\'t added any delivery addresses yet. Add your first address to continue with checkout.',
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle(
              responsive.sp(35),
              AppColors.greyText,
              FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Add New Address Button
            Container(
              width: double.infinity,
              height: responsive.hp(60),
              margin: EdgeInsets.only(bottom: responsive.hp(15)),
              decoration: BoxDecoration(
                color: AppColors.greyBackground.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.greyText.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Get.to(() => const OsmLocationPickerPage(
                        enableSearch: true,
                        userAgentPackageName: 'com.yourcompany.app',
                      ));
                  if (result == true) {
                    _loadAddresses();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_location_alt_rounded,
                      color: AppColors.greyText,
                      size: responsive.sp(40),
                    ),
                    SizedBox(width: responsive.wp(15)),
                    Text(
                      'Add New Address',
                      style: AppTextStyle.textStyle(
                        responsive.sp(38),
                        AppColors.greyText,
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Confirm Selection Button
            Container(
              width: double.infinity,
              height: responsive.hp(70),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _selectedAddress != null
                      ? [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ]
                      : [
                          AppColors.greyText.withOpacity(0.5),
                          AppColors.greyText.withOpacity(0.3),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: _selectedAddress != null
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
                onPressed: _selectedAddress != null
                    ? () => Get.back(result: _selectedAddress)
                    : null,
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
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: responsive.sp(45),
                    ),
                    SizedBox(width: responsive.wp(15)),
                    Text(
                      _selectedAddress != null
                          ? 'Use This Address'
                          : 'Select an Address',
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
      ),
    );
  }
}
