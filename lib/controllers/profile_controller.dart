import 'package:demoecommerceproduct/screens/location_address_screen.dart';
import 'package:demoecommerceproduct/services/location_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<PickedLocation?> _location = Rx<PickedLocation?>(null);
  PickedLocation? get location => _location.value;
  set location(PickedLocation? value) => _location.value = value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLocation();
  }

  void getLocation() async {
    location = await LocationStorageService.getSavedLocation();
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
