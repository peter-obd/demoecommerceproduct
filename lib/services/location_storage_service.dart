import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PickedLocation {
  final double lat;
  final double lng;
  final String? address;
  
  PickedLocation({required this.lat, required this.lng, this.address});
  
  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
    };
  }
  
  factory PickedLocation.fromMap(Map<String, dynamic> map) {
    return PickedLocation(
      lat: map['lat'] ?? 0.0,
      lng: map['lng'] ?? 0.0,
      address: map['address'],
    );
  }
}

class LocationStorageService {
  static const String _latKey = 'saved_location_lat';
  static const String _lngKey = 'saved_location_lng';
  static const String _addressKey = 'saved_location_address';
  static const String _timestampKey = 'saved_location_timestamp';

  static Future<bool> saveLocation(PickedLocation location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_latKey, location.lat);
      await prefs.setDouble(_lngKey, location.lng);
      if (location.address != null) {
        await prefs.setString(_addressKey, location.address!);
      }
      await prefs.setString(_timestampKey, DateTime.now().toIso8601String());
      return true;
    } catch (e) {
      debugPrint('Error saving location: $e');
      return false;
    }
  }

  static Future<PickedLocation?> getSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble(_latKey);
      final lng = prefs.getDouble(_lngKey);
      final address = prefs.getString(_addressKey);
      
      if (lat != null && lng != null) {
        return PickedLocation(lat: lat, lng: lng, address: address);
      }
    } catch (e) {
      debugPrint('Error loading saved location: $e');
    }
    return null;
  }

  static Future<DateTime?> getLocationSaveTimestamp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampStr = prefs.getString(_timestampKey);
      if (timestampStr != null) {
        return DateTime.parse(timestampStr);
      }
    } catch (e) {
      debugPrint('Error loading location timestamp: $e');
    }
    return null;
  }

  static Future<bool> clearSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_latKey);
      await prefs.remove(_lngKey);
      await prefs.remove(_addressKey);
      await prefs.remove(_timestampKey);
      return true;
    } catch (e) {
      debugPrint('Error clearing saved location: $e');
      return false;
    }
  }

  static Future<bool> hasSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_latKey) && prefs.containsKey(_lngKey);
    } catch (e) {
      debugPrint('Error checking for saved location: $e');
      return false;
    }
  }
}