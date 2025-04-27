import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import '../../core/network/logger.dart';
import '../custom_dialog/custom_confirmation_dialog.dart';
import '../global_loding/global_loader.dart';

class LocationHelper {
  // Function to check permissions and request location
  static Future<bool> requestAndFetchLocation({
    required BuildContext context,
    required Function onLocationFetched,
  }) async {
    AppLogger.info("onTap triggered to get current location");

    // 🔹 Check if permission is already granted to avoid unnecessary checks
    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled && (permission == LocationPermission.whileInUse || permission == LocationPermission.always)) {
      onLocationFetched(); // ✅ If permission is already granted, fetch location
      return true; // Return true as permission is granted
    }

    // 🔹 Show Global Loader
    GlobalLoader.show(context);

    // 🔹 1️⃣ **Check if location services are enabled**
    if (!serviceEnabled) {
      AppLogger.warn("Location services are disabled.");
      GlobalLoader.hide(); // Close loading indicator

      CustomConfirmationDialog.show(
        context,
        title: "Location Services Disabled",
        message: "Please enable location services in your device settings.",
        confirmText: "Open Settings",
        cancelText: "Cancel",
        onConfirm: () async {
          await Geolocator.openLocationSettings();
        },
      );
      return false; // Location service is not enabled, return false
    }

    // 🔹 2️⃣ **Check and request permission**
    if (permission == LocationPermission.denied) {
      AppLogger.warn("Location permission denied. Requesting permission...");
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        AppLogger.error("User denied location permission.");
        GlobalLoader.hide(); // Close loading indicator

        CustomConfirmationDialog.show(
          context,
          title: "Permission Denied",
          message: "You need to allow location permission to continue.",
          confirmText: "Allow",
          cancelText: "Cancel",
          onConfirm: () async {
            permission = await Geolocator.requestPermission();
            if (permission != LocationPermission.denied) {
              AppLogger.info("User granted location permission.");
              onLocationFetched(); // ✅ Fetch location immediately
            }
          },
        );
        return false; // Permission denied, return false
      }
    }

    // 🔹 3️⃣ **Handle "Permanently Denied" case**
    if (permission == LocationPermission.deniedForever) {
      AppLogger.error("User permanently denied location permission.");
      GlobalLoader.hide(); // Close loading indicator

      await Geolocator.openAppSettings(); // Open settings directly
      return false; // Permission permanently denied, return false
    }

    // 🔹 4️⃣ **Permission granted – fetch location**
    GlobalLoader.hide(); // Close loading indicator
    onLocationFetched(); // ✅ Fetch location and show dialog
    return true; // Permission granted, return true
  }
}

Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    } else {
      return "Address not found";
    }
  } catch (e) {
    return "Error getting address: $e";
  }
}