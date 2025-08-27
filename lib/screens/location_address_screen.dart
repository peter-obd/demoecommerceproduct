import 'dart:async';
import 'dart:convert';
import 'package:demoecommerceproduct/controllers/profile_controller.dart';
import 'package:demoecommerceproduct/values/colors.dart';
import 'package:demoecommerceproduct/values/constants.dart';
import 'package:demoecommerceproduct/values/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:demoecommerceproduct/services/location_storage_service.dart';

class OsmLocationPickerPage extends StatefulWidget {
  /// Optional initial camera center.
  final LatLng? initialCenter;

  /// If true, shows a search icon to search places (Nominatim).
  final bool enableSearch;

  /// App package id for OSM user-agent (e.g. com.yourcompany.app)
  final String userAgentPackageName;

  /// ISO country codes to bias search results (e.g. "lb,ae,sa")
  final String? searchCountryCodes;

  /// Title for the app bar
  final String title;

  const OsmLocationPickerPage({
    Key? key,
    this.initialCenter,
    this.enableSearch = true,
    required this.userAgentPackageName,
    this.searchCountryCodes,
    this.title = 'Pick Location',
  }) : super(key: key);

  @override
  State<OsmLocationPickerPage> createState() => _OsmLocationPickerPageState();
}

class _OsmLocationPickerPageState extends State<OsmLocationPickerPage> {
  final MapController _mapController = MapController();
  final ProfileController profileController = Get.put(ProfileController());
  LatLng _center = const LatLng(33.8889, 35.4944); // Beirut default
  double _zoom = 15;

  String? _address;
  bool _fetchingAddress = false;

  // Search state
  bool _showSearch = false;
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _searchDebounce;
  List<_SearchItem> _searchResults = [];
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _center = widget.initialCenter ?? _center;
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _goToMyLocation() async {
    final hasPermission = await _ensureLocationPermission();
    if (!hasPermission) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    final target = LatLng(pos.latitude, pos.longitude);
    _mapController.move(target, 17);
    setState(() {
      _center = target;
      _zoom = 17;
    });
    _reverseGeocode(target);
  }

  Future<bool> _ensureLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required.')),
        );
      }
      return false;
    }
    return true;
  }

  void _onMapEvent(MapEvent evt) {
    // Update center when the camera stops moving (MoveEnd / FlingEnd / RotateEnd etc.)
    if (evt is MapEventMoveEnd || evt is MapEventFlingAnimationEnd) {
      final cam = _mapController.camera; // read current camera
      final newCenter = cam.center;
      setState(() {
        _center = newCenter;
        _zoom = cam.zoom;
      });
      _reverseGeocode(newCenter);
    }
  }

  Future<void> _reverseGeocode(LatLng target) async {
    setState(() {
      _fetchingAddress = true;
    });
    try {
      final placemarks = await gc.placemarkFromCoordinates(
        target.latitude,
        target.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final line = [
          if ((p.street ?? '').isNotEmpty) p.street,
          if ((p.subLocality ?? '').isNotEmpty) p.subLocality,
          if ((p.locality ?? '').isNotEmpty) p.locality,
          if ((p.administrativeArea ?? '').isNotEmpty) p.administrativeArea,
          if ((p.country ?? '').isNotEmpty) p.country,
        ].whereType<String>().join(', ');
        setState(() => _address = line.isNotEmpty ? line : null);
      } else {
        setState(() => _address = null);
      }
    } catch (_) {
      setState(() => _address = null);
    } finally {
      setState(() => _fetchingAddress = false);
    }
  }

  Future<void> _saveLocationToPrefs(PickedLocation location) async {
    final success = await LocationStorageService.saveLocation(location);
    if (success) {
      profileController.getLocation();
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Location saved successfully!'
              : 'Failed to save location'),
          backgroundColor: success ? AppColors.primary : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // --------- Optional Nominatim search ----------
  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (value.trim().isEmpty) {
        setState(() => _searchResults = []);
        return;
      }
      _searchPlaces(value.trim());
    });
  }

  Future<void> _searchPlaces(String q) async {
    setState(() {
      _searching = true;
    });
    try {
      final params = {
        'q': q,
        'format': 'jsonv2',
        'limit': '8',
        if (widget.searchCountryCodes != null)
          'countrycodes': widget.searchCountryCodes!,
      };
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', params);
      final resp = await http.get(
        uri,
        headers: {
          // Identify your app & include a contact per policy (can be email).
          'User-Agent':
              '${widget.userAgentPackageName} (contact: support@yourapp.com)',
        },
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List<dynamic>;
        final items = data
            .map((e) {
              final lat = double.tryParse(e['lat'] ?? '');
              final lon = double.tryParse(e['lon'] ?? '');
              return (lat != null && lon != null)
                  ? _SearchItem(
                      displayName: (e['display_name'] ?? '') as String,
                      point: LatLng(lat, lon),
                    )
                  : null;
            })
            .whereType<_SearchItem>()
            .toList();
        setState(() => _searchResults = items);
      } else {
        setState(() => _searchResults = []);
      }
    } catch (_) {
      setState(() => _searchResults = []);
    } finally {
      setState(() => _searching = false);
    }
  }
  // ---------------------------------------------

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
          widget.title,
          style: AppTextStyle.textStyle(
            responsive.sp(40),
            AppColors.secondary,
            FontWeight.w600,
          ),
        ),
        actions: [
          if (widget.enableSearch)
            IconButton(
              icon: Icon(Icons.search, color: AppColors.secondary),
              onPressed: () {
                setState(() {
                  _showSearch = !_showSearch;
                  _searchResults = [];
                  _searchCtrl.clear();
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: _zoom,
              onMapEvent: _onMapEvent, // listen to move/zoom end, etc.
            ),
            children: [
              // PRODUCTION CONSIDERATIONS for OpenStreetMap:
              // 1. Attribution is required (see RichAttributionWidget below)
              // 2. Respect tile usage policy - no bulk downloading
              // 3. Use appropriate user agent string
              // 4. Consider using your own tile server in production for high traffic
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: widget.userAgentPackageName,
                maxZoom: 19,
                minZoom: 1,
                // Respect OSM usage policy - limit concurrent requests and enable caching
                tileProvider: NetworkTileProvider(),
                maxNativeZoom: 19,
                // Respect rate limits - don't bulk download
                retinaMode: false,
              ),
            ],
          ),

          // OpenStreetMap Attribution (Required by OSM tile policy) - Top Right
          Positioned(
            top: responsive.hp(20),
            right: responsive.wp(20),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(15),
                vertical: responsive.hp(8),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  debugPrint('OSM attribution tapped');
                },
                child: Text(
                  '© OpenStreetMap contributors',
                  style: TextStyle(
                    fontSize: responsive.sp(20),
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),

          // Center pin (doesn't capture gestures)
          IgnorePointer(
            child: Center(
              child: Icon(
                Icons.location_on,
                size: responsive.wp(70),
                color: AppColors.primary,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          // My location button
          // Positioned(
          //   right: 16,
          //   bottom: 120,
          //   child: FloatingActionButton(
          //     onPressed: _goToMyLocation,
          //     child: const Text('My location'),
          //   ),
          // ),

          // Compact Address preview + confirm
          Positioned(
            left: responsive.wp(20),
            right: responsive.wp(20),
            bottom: responsive.hp(20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(responsive.wp(25)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Address section - more compact
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(20),
                        vertical: responsive.hp(15),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.greyBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: responsive.wp(35),
                          ),
                          SizedBox(width: responsive.wp(15)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _fetchingAddress
                                      ? 'Getting address…'
                                      : (_address ?? 'Unknown address'),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.textStyle(
                                    responsive.sp(28),
                                    AppColors.blackText,
                                    FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: responsive.hp(5)),
                                Text(
                                  '${_center.latitude.toStringAsFixed(4)}, ${_center.longitude.toStringAsFixed(4)}',
                                  style: AppTextStyle.textStyle(
                                    responsive.sp(24),
                                    AppColors.greyText,
                                    FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: responsive.hp(15)),
                    // Buttons row - more compact
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: responsive.hp(42),
                            child: ElevatedButton.icon(
                              onPressed: _goToMyLocation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.lightBlue,
                                foregroundColor: AppColors.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              icon: Icon(
                                Icons.my_location,
                                size: responsive.wp(32),
                              ),
                              label: Text(
                                'My Location',
                                style: AppTextStyle.textStyle(
                                  responsive.sp(26),
                                  AppColors.secondary,
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: responsive.wp(15)),
                        Expanded(
                          child: SizedBox(
                            height: responsive.hp(42),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final location = PickedLocation(
                                  lat: _center.latitude,
                                  lng: _center.longitude,
                                  address: _address,
                                );
                                await _saveLocationToPrefs(location);
                                if (mounted) {
                                  Navigator.of(context).pop(location);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              icon: Icon(
                                Icons.check_circle,
                                size: responsive.wp(32),
                              ),
                              label: Text(
                                'Confirm',
                                style: AppTextStyle.textStyle(
                                  responsive.sp(26),
                                  AppColors.secondary,
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search overlay
          if (_showSearch)
            Positioned(
              left: responsive.wp(30),
              right: responsive.wp(30),
              top: responsive.hp(30),
              child: _SearchBox(
                controller: _searchCtrl,
                onChanged: _onSearchChanged,
                onClear: () {
                  setState(() => _searchResults = []);
                },
              ),
            ),
          if (_showSearch && (_searching || _searchResults.isNotEmpty))
            Positioned(
              left: responsive.wp(30),
              right: responsive.wp(30),
              top: responsive.hp(110),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: responsive.hp(300)),
                  child: _searching
                      ? Padding(
                          padding: EdgeInsets.all(responsive.wp(40)),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(responsive.wp(20)),
                          itemCount: _searchResults.length,
                          itemBuilder: (ctx, i) {
                            final it = _searchResults[i];
                            return Container(
                              margin: EdgeInsets.only(bottom: responsive.hp(5)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(30),
                                  vertical: responsive.hp(10),
                                ),
                                leading: Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: responsive.wp(50),
                                ),
                                title: Text(
                                  it.displayName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.textStyle(
                                    responsive.sp(30),
                                    AppColors.blackText,
                                    FontWeight.w500,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                onTap: () {
                                  _mapController.move(it.point, 17);
                                  setState(() {
                                    _center = it.point;
                                    _zoom = 17;
                                    _searchResults = [];
                                    _showSearch = false;
                                  });
                                  _reverseGeocode(it.point);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const _SearchBox({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        style: AppTextStyle.textStyle(
          responsive.sp(32),
          AppColors.blackText,
          FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search for places, addresses...',
          hintStyle: AppTextStyle.textStyle(
            responsive.sp(32),
            AppColors.greyText,
            FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsive.wp(40),
            vertical: responsive.hp(30),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.primary,
            size: responsive.wp(50),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
              color: AppColors.greyText,
              size: responsive.wp(50),
            ),
            onPressed: () {
              controller.clear();
              onClear();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: AppColors.secondary,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _SearchItem {
  final String displayName;
  final LatLng point;
  _SearchItem({required this.displayName, required this.point});
}
