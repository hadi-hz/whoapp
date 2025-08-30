// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationMapPage extends StatelessWidget {
//   final double latitude;
//   final double longitude;

//   const LocationMapPage({
//     super.key,
//     required this.latitude,
//     required this.longitude,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final LatLng position = LatLng(latitude, longitude);

//     return Scaffold(
//       appBar: AppBar(title: const Text("View on Map")),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: position,
//           zoom: 15,
//         ),
//         markers: {
//           Marker(
//             markerId: const MarkerId("selected_location"),
//             position: position,
//             infoWindow: const InfoWindow(title: "Selected Location"),
//           ),
//         },
//       ),
//     );
//   }
// }