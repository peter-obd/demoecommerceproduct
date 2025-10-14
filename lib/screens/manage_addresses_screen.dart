import 'package:demoecommerceproduct/controllers/profile_controller.dart';
import 'package:demoecommerceproduct/models/user_address_model.dart';
import 'package:demoecommerceproduct/screens/location_address_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/location_storage_service.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageAddressesScreen extends StatefulWidget {
  const ManageAddressesScreen({super.key});

  @override
  State<ManageAddressesScreen> createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  List<UserAddress> _addresses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  @override
  void dispose() {
    // Refresh the profile controller when leaving the screen
    try {
      final profileController = Get.find<ProfileController>();
      profileController.refreshDefaultAddress();
    } catch (e) {
      debugPrint('ProfileController not found on dispose: $e');
    }
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    setState(() => _loading = true);
    try {
      ApisService.getUserAddresses(
        (addresses) {
          if (mounted) {
            setState(() {
              _addresses = addresses;
              _loading = false;
            });
          }
        },
        (error) {
          if (mounted) {
            setState(() => _loading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load addresses: $error'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading addresses: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _addNewAddress() async {
    final result = await Get.to(
      () => const OsmLocationPickerPage(
        userAgentPackageName: 'com.demoecommerceproduct.app',
        title: 'Add New Address',
        searchCountryCodes: 'lb,ae,sa',
      ),
    );
    
    if (result != null) {
      // Reload addresses list
      await _loadAddresses();
      
      // Refresh the profile controller to update default address
      try {
        final profileController = Get.find<ProfileController>();
        profileController.refreshDefaultAddress();
      } catch (e) {
        // ProfileController might not be initialized yet
        debugPrint('ProfileController not found: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        elevation: 0,
        title: Text(
          'Manage Addresses',
          style: AppTextStyle.textStyle(
            responsive.sp(40),
            AppColors.secondary,
            FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.secondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _addresses.isEmpty
              ? _buildEmptyState(responsive)
              : _buildAddressList(responsive),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewAddress,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        icon: const Icon(Icons.add_location_alt),
        label: Text(
          'Add Address',
          style: AppTextStyle.textStyle(
            responsive.sp(30),
            AppColors.secondary,
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Responsive responsive) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: responsive.wp(200),
              height: responsive.wp(200),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_rounded,
                size: responsive.wp(100),
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            SizedBox(height: responsive.hp(30)),
            Text(
              'No Addresses Yet',
              style: AppTextStyle.textStyle(
                responsive.sp(50),
                AppColors.blackText,
                FontWeight.w700,
              ),
            ),
            SizedBox(height: responsive.hp(15)),
            Text(
              'Add your first delivery address to start shopping',
              textAlign: TextAlign.center,
              style: AppTextStyle.textStyle(
                responsive.sp(32),
                AppColors.greyText,
                FontWeight.w400,
              ),
            ),
            SizedBox(height: responsive.hp(40)),
            SizedBox(
              width: responsive.wp(200),
              height: responsive.hp(50),
              child: ElevatedButton.icon(
                onPressed: _addNewAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.add_location_alt),
                label: Text(
                  'Add Address',
                  style: AppTextStyle.textStyle(
                    responsive.sp(32),
                    AppColors.secondary,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList(Responsive responsive) {
    return RefreshIndicator(
      onRefresh: _loadAddresses,
      color: AppColors.primary,
      child: ListView.builder(
        padding: EdgeInsets.all(responsive.wp(20)),
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return _buildAddressCard(address, responsive);
        },
      ),
    );
  }

  Widget _buildAddressCard(UserAddress address, Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(15)),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: address.isDefault
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.wp(8)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: responsive.sp(35),
                  ),
                ),
                SizedBox(width: responsive.wp(15)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.title,
                            style: AppTextStyle.textStyle(
                              responsive.sp(36),
                              AppColors.blackText,
                              FontWeight.w600,
                            ),
                          ),
                          if (address.isDefault) ...[
                            SizedBox(width: responsive.wp(10)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(12),
                                vertical: responsive.hp(4),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Default',
                                style: AppTextStyle.textStyle(
                                  responsive.sp(24),
                                  AppColors.secondary,
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: responsive.hp(5)),
                      Text(
                        address.description,
                        style: AppTextStyle.textStyle(
                          responsive.sp(30),
                          AppColors.greyText,
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.greyText,
                    size: responsive.sp(40),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'setDefault':
                        _setDefaultAddress(address);
                        break;
                      case 'delete':
                        _deleteAddress(address);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    if (!address.isDefault)
                      PopupMenuItem<String>(
                        value: 'setDefault',
                        child: Row(
                          children: [
                            Icon(Icons.star, color: AppColors.primary),
                            SizedBox(width: responsive.wp(10)),
                            const Text('Set as Default'),
                          ],
                        ),
                      ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: responsive.wp(10)),
                          const Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: responsive.hp(10)),
            Text(
              'Coordinates: ${address.latitude.toStringAsFixed(4)}, ${address.longitude.toStringAsFixed(4)}',
              style: AppTextStyle.textStyle(
                responsive.sp(26),
                AppColors.greyText,
                FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setDefaultAddress(UserAddress address) async {
    try {
      ApisService.setDefaultAddress(
        address.id,
        (updatedAddress) async {
          if (mounted) {
            // Save the updated address to local storage as well
            final location = PickedLocation(
              lat: updatedAddress.latitude,
              lng: updatedAddress.longitude,
              address: updatedAddress.description,
            );
            await LocationStorageService.saveLocation(location);
            
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${updatedAddress.title} set as default address'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            
            // Reload addresses to update the UI
            await _loadAddresses();
            
            // Refresh the profile controller
            final profileController = Get.find<ProfileController>();
            profileController.refreshDefaultAddress();
          }
        },
        (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to set default address: $error'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting default address: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _deleteAddress(UserAddress address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete "${address.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Delete functionality not implemented yet'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}