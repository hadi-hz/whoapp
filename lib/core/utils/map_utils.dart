// Create this file: lib/core/utils/map_utils.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static Future<void> openDirectionsWithChoice(BuildContext context, LatLng destination) async {
    final availableApps = await _getAvailableMapApps(destination);
    
    if (availableApps.length == 1) {
      await _launchMapApp(availableApps.first);
    } else if (availableApps.length > 1) {
      await _showMapAppChoiceDialog(context, availableApps);
    } else {
      Get.snackbar(
        'error'.tr,
        'no_map_apps_available'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static Future<List<MapApp>> _getAvailableMapApps(LatLng destination) async {
    final apps = <MapApp>[];
    
    if (Platform.isIOS) {
      // Google Maps for iOS
      final googleMapsUrl = 'comgooglemaps://?daddr=${destination.latitude},${destination.longitude}&directionsmode=driving';
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        apps.add(MapApp('Google Maps', googleMapsUrl, Icons.map));
      }
      
      // Apple Maps
      final appleMapsUrl = 'maps://app?daddr=${destination.latitude},${destination.longitude}';
      if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
        apps.add(MapApp('Apple Maps', appleMapsUrl, Icons.navigation));
      }
    } else {
      // Google Maps for Android
      final googleMapsUrl = 'google.navigation:q=${destination.latitude},${destination.longitude}';
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        apps.add(MapApp('Google Maps', googleMapsUrl, Icons.map));
      }
      
      // Waze
      final wazeUrl = 'waze://?ll=${destination.latitude},${destination.longitude}&navigate=yes';
      if (await canLaunchUrl(Uri.parse(wazeUrl))) {
        apps.add(MapApp('Waze', wazeUrl, Icons.traffic));
      }
    }
    
    // Web fallback (always available)
    final webUrl = 'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}';
    apps.add(MapApp('Web Browser', webUrl, Icons.web));
    
    return apps;
  }

  static Future<void> _showMapAppChoiceDialog(BuildContext context, List<MapApp> apps) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        title: Text(
          'choose_map_app'.tr,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: apps.map((app) => 
            ListTile(
              leading: Icon(app.icon, color: isDark ? Colors.white : Colors.black),
              title: Text(
                app.name,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              onTap: () {
                Get.back();
                _launchMapApp(app);
              },
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _launchMapApp(MapApp app) async {
    try {
      if (app.name == 'Web Browser') {
        await launchUrl(Uri.parse(app.url), mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri.parse(app.url));
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'could_not_open_map'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class MapApp {
  final String name;
  final String url;
  final IconData icon;
  
  MapApp(this.name, this.url, this.icon);
}