import 'package:demoecommerceproduct/models/user.dart';
import 'package:demoecommerceproduct/models/user_address_model.dart';
import 'package:demoecommerceproduct/screens/location_address_screen.dart';
import 'package:demoecommerceproduct/screens/login_screen.dart';
import 'package:demoecommerceproduct/services/apis_service.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/services/location_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<PickedLocation?> _location = Rx<PickedLocation?>(null);
  final Rx<UserAddress?> _defaultAddress = Rx<UserAddress?>(null);
  
  PickedLocation? get location => _location.value;
  set location(PickedLocation? value) => _location.value = value;
  
  UserAddress? get defaultAddress => _defaultAddress.value;
  set defaultAddress(UserAddress? value) => _defaultAddress.value = value;
  
  User? user;

  @override
  void onInit() {
    super.onInit();
    getUser();
    getLocation();
    getDefaultAddress();
  }

  void getUser() async {
    user = await IsarService.instance.getCurrentUser();
  }

  void getLocation() async {
    location = await LocationStorageService.getSavedLocation();
  }

  void getDefaultAddress() async {
    try {
      ApisService.getDefaultAddress(
        (address) {
          defaultAddress = address;
        },
        (error) {
          debugPrint('Failed to load default address: $error');
          defaultAddress = null;
        },
      );
    } catch (e) {
      debugPrint('Error getting default address: $e');
      defaultAddress = null;
    }
  }

  void refreshDefaultAddress() {
    getDefaultAddress();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh data when controller is ready
    getDefaultAddress();
  }

  void logoutUser() async {
    await IsarService.instance.clearUser();
    Get.offAll(const LoginScreen());
  }

  Future<void> pickLocation(BuildContext context) async {
    final picked = await Navigator.of(context).push<PickedLocation>(
      MaterialPageRoute(
        builder: (_) => const OsmLocationPickerPage(
          userAgentPackageName:
              'com.example.demoecommerceproduct', // <-- your app id
          enableSearch: true,
          // searchCountryCodes: 'lb', // bias optional
          // initialCenter: LatLng(33.8938, 35.5018), // optional
        ),
      ),
    );

    if (picked != null) {
      location = picked;
      print(
          'Lat: ${picked.lat}, Lng: ${picked.lng}, Address: ${picked.address}');
      // TODO: send to backend
    }
  }
}
