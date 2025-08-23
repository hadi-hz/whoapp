import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? selectedPosition;
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select_location'.tr), 
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(48.8566, 2.3522),
          zoom: 12,
        ),
        onMapCreated: (controller) => mapController = controller,
        onTap: (LatLng position) {
          setState(() {
            selectedPosition = position;
          });
        },
        markers: selectedPosition != null
            ? {
                Marker(
                  markerId: MarkerId('selected'.tr), 
                  position: selectedPosition!,
                ),
              }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.check, color: AppColors.background),
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
            );
          }
        },
      ),
    );
  }
}