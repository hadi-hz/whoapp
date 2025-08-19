import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      appBar: AppBar(title: const Text("Select Location")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(35.6892, 51.3890), 
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
                  markerId: const MarkerId("selected"),
                  position: selectedPosition!,
                )
              }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child:  Icon(Icons.check , color: AppColors.background,),
        onPressed: () {
          if (selectedPosition != null) {
            Navigator.pop(context, selectedPosition);
          }
        },
      ),
    );
  }
}
