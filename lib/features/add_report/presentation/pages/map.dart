import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';

class MapPickerPage extends StatefulWidget {
  final double? userLat;
  final double? userLng;

  const MapPickerPage({super.key, this.userLat, this.userLng});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? selectedPosition;
  LatLng? currentUserLocation;
  GoogleMapController? mapController;
  bool showCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.userLat != null && widget.userLng != null) {
      currentUserLocation = LatLng(widget.userLat!, widget.userLng!);
    }
  }

  Marker _buildSelectedMarker() {
    return Marker(
      markerId: const MarkerId('selected'),
      position: selectedPosition!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: 'selected_location'.tr,
        snippet:
            'lat: ${selectedPosition!.latitude.toStringAsFixed(4)}, lng: ${selectedPosition!.longitude.toStringAsFixed(4)}',
      ),
    );
  }

  Marker _buildCurrentLocationMarker() {
    return Marker(
      markerId: const MarkerId('current_location'),
      position: currentUserLocation!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(
        title: 'current_location'.tr,
        snippet: 'your_current_position'.tr,
      ),
    );
  }

  Circle _buildCurrentLocationCircle() {
    return Circle(
      circleId: const CircleId('current_location_circle'),
      center: currentUserLocation!,
      radius: 100,
      fillColor: Colors.blue.withOpacity(0.2),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    );
  }

  void toggleCurrentLocation() {
    if (currentUserLocation != null) {
      setState(() {
        showCurrentLocation = !showCurrentLocation;
      });

      if (showCurrentLocation && mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: currentUserLocation!, zoom: 15.0),
          ),
        );
      }
    } else {
      final theme = Theme.of(context);
      Get.snackbar(
        'location_unavailable'.tr,
        'current_location_not_available'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: theme.colorScheme.onError,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'select_location'.tr,
          style: TextStyle(color: theme.appBarTheme.titleTextStyle?.color),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
        actions: [
          if (selectedPosition != null)
            IconButton(
              icon: Icon(Icons.clear, color: theme.iconTheme.color),
              onPressed: () {
                setState(() {
                  selectedPosition = null;
                });
              },
              tooltip: 'clear_selection'.tr,
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentUserLocation ?? const LatLng(48.8566, 2.3522),
          zoom: currentUserLocation != null ? 15.0 : 12.0,
        ),
        onMapCreated: (controller) => mapController = controller,
        onTap: (LatLng position) {
          setState(() {
            selectedPosition = position;
          });
        },
        markers: {
          if (selectedPosition != null) _buildSelectedMarker(),
          if (showCurrentLocation && currentUserLocation != null)
            _buildCurrentLocationMarker(),
        },
        circles: {
          if (showCurrentLocation && currentUserLocation != null)
            _buildCurrentLocationCircle(),
        },
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "current_location",
            backgroundColor: showCurrentLocation
                ? AppColors.primaryColor
                : theme.disabledColor,
            child: Icon(
              Icons.my_location,
              color: showCurrentLocation
                  ? theme.colorScheme.onPrimary
                  : theme.iconTheme.color,
            ),
            onPressed: toggleCurrentLocation,
            tooltip: showCurrentLocation
                ? 'hide_current_location'.tr
                : 'show_current_location'.tr,
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "confirm_selection",
            backgroundColor: selectedPosition != null
                ? AppColors.primaryColor
                : theme.disabledColor,
            child: Icon(
              Icons.check,
              color: selectedPosition != null
                  ? theme.colorScheme.onPrimary
                  : theme.iconTheme.color,
            ),
            onPressed: () {
              if (selectedPosition != null) {
                Get.back(result: selectedPosition);
              } else {
                Get.snackbar(
                  'no_location_selected'.tr,
                  'tap_map_location'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'map_instructions'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'tap_map_to_select'.tr,
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            if (selectedPosition != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${'selected_coordinates'.tr}: ${selectedPosition!.latitude.toStringAsFixed(4)}, ${selectedPosition!.longitude.toStringAsFixed(4)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
