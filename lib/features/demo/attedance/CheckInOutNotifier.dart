import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/scheduler.dart'; // for Ticker
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/logger.dart';
import 'SelfAttendanceService.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


// State Model
class CheckInOutState {
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String timeDifference;
  final File? checkInImage;
  final File? checkOutImage;
  final bool isLoading;

  CheckInOutState({
    this.checkInTime,
    this.checkOutTime,
    this.timeDifference = '00:00:00',
    this.checkInImage,
    this.checkOutImage,
    this.isLoading = false,
  });

  CheckInOutState copyWith({
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? timeDifference,
    File? checkInImage,
    File? checkOutImage,
    bool? isLoading,
  }) {
    return CheckInOutState(
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      timeDifference: timeDifference ?? this.timeDifference,
      checkInImage: checkInImage ?? this.checkInImage,
      checkOutImage: checkOutImage ?? this.checkOutImage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Notifier to manage check-in/out logic
class CheckInOutNotifier extends StateNotifier<CheckInOutState> {
  CheckInOutNotifier() : super(CheckInOutState());

  Ticker? _ticker;

  void checkIn() async {
    state = state.copyWith(isLoading: true);

    final DateTime now = DateTime.now();
    final image = await _captureImage();
    final location = await _getLocation();

    state = state.copyWith(
      checkInTime: now,
      checkInImage: image,
    );

    _startTimeTicker();

    // Send check-in data to the server
    //_sendCheckInDataToServer(now, image, location);

    state = state.copyWith(isLoading: false);
  }

  void checkOut() async {
    state = state.copyWith(isLoading: true);

    final DateTime now = DateTime.now();
    final image = await _captureImage();
    final location = await _getLocation();

    state = state.copyWith(
      checkOutTime: now,
      checkOutImage: image,
      timeDifference: _calculateTimeDifference(state.checkInTime!, now),
    );

    _stopTimeTicker();

    // Send check-out data to the server
    //_sendCheckOutDataToServer(now, image, location);

    state = state.copyWith(isLoading: false);  // Stop loading
  }

  Future<void> _sendCheckInDataToServer(DateTime checkInTime, File? checkInImage, LocationDetails location) async {
    if (checkInImage == null) return;

    // Convert the image to base64
    String checkInImagePath = base64Encode(await checkInImage.readAsBytes());

    final SelfAttendanceData attendanceData = SelfAttendanceData(
      employeeName: "Employee Name",  // Replace with actual data
      designationName: "Designation", // Replace with actual data
      empAttendanceId: "12345",      // Replace with actual data
      employeeCode: "E001",          // Replace with actual data
      inTime: checkInTime,
      outTime: null,
      presentHours: Duration.zero,
      inDocumentPath: checkInImagePath,
      outDocumentPath: '',
      latitude: location.latitude,
      longitude: location.longitude,
      address: location.address,
    );

    final success = await SelfAttendanceService.createSelfAttendance(attendanceData);
    if (success) {
      AppLogger.info("✅ Check-in data sent to server successfully.");
    } else {
      AppLogger.error("❌ Failed to send check-in data.");
    }
  }

  Future<void> _sendCheckOutDataToServer(DateTime checkOutTime, File? checkOutImage, LocationDetails location) async {
    if (checkOutImage == null) return;

    // Convert the image to base64
    String checkOutImagePath = base64Encode(await checkOutImage.readAsBytes());

    final SelfAttendanceData attendanceData = SelfAttendanceData(
      employeeName: "Employee Name",  // Replace with actual data
      designationName: "Designation", // Replace with actual data
      empAttendanceId: "12345",      // Replace with actual data
      employeeCode: "E001",          // Replace with actual data
      inTime: state.checkInTime,
      outTime: checkOutTime,
      presentHours: Duration(
        milliseconds: checkOutTime.difference(state.checkInTime!).inMilliseconds,
      ),
      inDocumentPath: '',
      outDocumentPath: checkOutImagePath,
      latitude: location.latitude,
      longitude: location.longitude,
      address: location.address,
    );

    final success = await SelfAttendanceService.updateSelfAttendance(attendanceData);
    if (success) {
      AppLogger.info("✅ Check-out data sent to server successfully.");
    } else {
      AppLogger.error("❌ Failed to send check-out data.");
    }
  }


  Future<LocationDetails> _getLocation() async {
    // Fetch current location
    final location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final placemarks = await GeocodingPlatform.instance!.placemarkFromCoordinates(location.latitude, location.longitude);
    return LocationDetails(
      latitude: location.latitude,
      longitude: location.longitude,
      address: placemarks.first.name ?? "Location not available",
    );
  }

  Future<File?> _captureImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    return pickedFile != null ? File(pickedFile.path) : null;
  }

  void _startTimeTicker() {
    _ticker = Ticker((elapsed) {
      if (state.checkInTime != null) {
        final DateTime now = DateTime.now();
        final timeDifference = _calculateTimeDifference(state.checkInTime!, now);

        // Update the state with the new time difference
        state = state.copyWith(timeDifference: timeDifference);
      }
    });

    _ticker?.start();
  }

  void _stopTimeTicker() {
    _ticker?.stop();
  }

  String _calculateTimeDifference(DateTime startTime, DateTime endTime) {
    final difference = endTime.difference(startTime);
    final hours = difference.inHours.toString().padLeft(2, '0');
    final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');

    return "$hours:$minutes:$seconds";
  }
}

// Providers for state management
final checkInOutStateProvider = StateNotifierProvider<CheckInOutNotifier, CheckInOutState>((ref) {
  return CheckInOutNotifier();
});


class LocationDetails {
  final double latitude;
  final double longitude;
  final String address;

  LocationDetails({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}


final currentLocationProvider = FutureProvider<LocationDetails>((ref) async {
  // Check and request location permission
  bool hasPermission = await _checkAndRequestLocationPermission();

  // If permission is not granted, return a message indicating the issue
  if (!hasPermission) {
    return LocationDetails(
      latitude: 0.0,
      longitude: 0.0,
      address: "Location permission not granted",
    );
  }

  // Permission granted, proceed to get the location
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  List<Placemark> placemarks = await GeocodingPlatform.instance!.placemarkFromCoordinates(position.latitude, position.longitude);

  return LocationDetails(
    latitude: position.latitude,
    longitude: position.longitude,
    address: placemarks.first.name ?? "Location not available",
  );
});

// Check and request location permission
Future<bool> _checkAndRequestLocationPermission() async {
  AppLogger.info("🔍 Checking location permission...");

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    AppLogger.warn("📛 Permission denied. Requesting permission...");
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    AppLogger.error("🚫 Location permission permanently denied (deniedForever).");
    return false;
  }

  bool granted = permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  AppLogger.info(granted ? "✅ Location permission granted." : "❌ Location permission still not granted.");

  return granted;
}

// Dialog to ask for location permission
void _showLocationPermissionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("📍 Location Permission Required"),
      content: Text(
        "Location access is needed to mark attendance. Please allow it in app settings.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            AppLogger.info("🔁 Opening app settings for permission...");
            Navigator.pop(context);
            Geolocator.openAppSettings(); // 🚀 Open app settings
          },
          child: Text("Open Settings"),
        ),
        TextButton(
          onPressed: () {
            AppLogger.warn("🚫 User cancelled location permission dialog.");
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
    ),
  );
}
