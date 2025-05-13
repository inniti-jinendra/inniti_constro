import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inniti_constro/core/services/attendance/attendance_api_service.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/scheduler.dart'; // for Ticker
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../core/network/logger.dart';
import '../../core/models/attendance/emp_attendance.dart';
import '../../core/network/api_endpoints.dart';
import '../../widgets/global_loding/global_loader.dart';
import 'SelfAttendanceService.dart';

// State Model
class CheckInOutState {
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String timeDifference;
  final File? checkInImage;
  final File? checkOutImage;
  final bool isLoading;
  final int? empAttendanceId;

  CheckInOutState({
    this.checkInTime,
    this.checkOutTime,
    this.timeDifference = '00:00:00',
    this.checkInImage,
    this.checkOutImage,
    this.isLoading = false,
    this.empAttendanceId,
  });

  CheckInOutState copyWith({
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? timeDifference,
    File? checkInImage,
    File? checkOutImage,
    bool? isLoading,
    int? empAttendanceId,
  }) {
    return CheckInOutState(
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      timeDifference: timeDifference ?? this.timeDifference,
      checkInImage: checkInImage ?? this.checkInImage,
      checkOutImage: checkOutImage ?? this.checkOutImage,
      isLoading: isLoading ?? this.isLoading,
      empAttendanceId: empAttendanceId ?? this.empAttendanceId,
    );
  }
}

// Notifier to manage check-in/out logic
// class CheckInOutNotifier extends StateNotifier<CheckInOutState> {
//   CheckInOutNotifier() : super(CheckInOutState());
//
//   Ticker? _ticker;
//
//   /// Starts timer for showing live work duration since check-in.
//   void _startTimeTicker() {
//     _ticker?.dispose();
//     _ticker = Ticker((elapsed) {
//       final checkIn = state.checkInTime;
//       if (checkIn != null) {
//         final duration = DateTime.now().difference(checkIn);
//         final formatted = _formatDuration(duration);
//         state = state.copyWith(timeDifference: formatted);
//       }
//     })..start();
//   }
//
//   /// Stops the running duration ticker.
//   void _stopTimeTicker() {
//     _ticker?.stop();
//     _ticker?.dispose();
//     _ticker = null;
//   }
//
//   /// Checks in the user after capturing image/location and successful API post.
//   Future<void> checkIn() async {
//     state = state.copyWith(isLoading: true);
//
//     final now = DateTime.now();
//     final image = await _captureImage();
//     final location = await _getLocation();
//
//     if (image == null) {
//       AppLogger.error("❌ Image capture failed during check-in.");
//       state = state.copyWith(isLoading: false);
//       return;
//     }
//
//     final success = await _sendCheckInDataToServer(now, image, location);
//     if (success) {
//
//       final now = DateTime.now();
//       final image = await _captureImage();
//
//       if(image != null){
//         state = state.copyWith(checkInTime: now, checkInImage: image);
//         _startTimeTicker();
//       }
//
//     }
//
//     state = state.copyWith(isLoading: false);
//   }
//
//   /// Checks out the user after successful data post and stops timer.
//   Future<void> checkOut() async {
//     state = state.copyWith(isLoading: true);
//
//     final now = DateTime.now();
//     final image = await _captureImage();
//     final location = await _getLocation();
//
//     if (image == null || state.checkInTime == null || state.empAttendanceId == null) {
//       AppLogger.error("❌ Check-out prerequisites missing.");
//       state = state.copyWith(isLoading: false);
//       return;
//     }
//
//     final duration = now.difference(state.checkInTime!);
//     final timeFormatted = _formatDuration(duration);
//
//     final success = await _sendCheckOutDataToServer(now, image, location);
//     if (success) {
//       _stopTimeTicker();
//       state = state.copyWith(
//         checkOutTime: now,
//         checkOutImage: image,
//         timeDifference: timeFormatted,
//       );
//     }
//
//     state = state.copyWith(isLoading: false);
//   }
//
//   String _formatDuration(Duration duration) {
//     final hours = duration.inHours.toString().padLeft(2, '0');
//     final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
//     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     return '$hours:$minutes:$seconds';
//   }
//
//   Future<bool> _sendCheckInDataToServer(DateTime checkInTime, File image, LocationDetails location) async {
//     try {
//       final response = await _postAttendance(
//         time: checkInTime,
//         image: image,
//         location: location,
//         type: "IN",
//         empAttendanceId: 0,
//       );
//
//       if (_isApiSuccess(response)) {
//         final id = _extractAttendanceId(response.body);
//         state = state.copyWith(empAttendanceId: id);
//         return true;
//       }
//     } catch (e) {
//       AppLogger.error("❌ Check-in API error: $e");
//     }
//     return false;
//   }
//
//   Future<bool> _sendCheckOutDataToServer(DateTime checkOutTime, File image, LocationDetails location) async {
//     try {
//       final response = await _postAttendance(
//         time: checkOutTime,
//         image: image,
//         location: location,
//         type: "OUT",
//         //empAttendanceId: 0,
//         empAttendanceId: state.empAttendanceId ?? 0,
//       );
//
//       return _isApiSuccess(response);
//     } catch (e) {
//       AppLogger.error("❌ Check-out API error: $e");
//       return false;
//     }
//   }
//
//   Future<http.Response> _postAttendance({
//     required DateTime time,
//     required File image,
//     required LocationDetails location,
//     required String type,
//     required int empAttendanceId,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('GeneratedToken');
//     final companyCode = prefs.getString('CompanyCode');
//     final userID = int.tryParse(prefs.getString('ActiveUserID') ?? '');
//     final projectID = int.tryParse(prefs.getString('ActiveProjectID') ?? '');
//
//     if ([token, companyCode, userID, projectID].contains(null)) {
//       throw Exception("Missing SharedPreferences data");
//     }
//
//     final base64Image = base64Encode(await image.readAsBytes());
//
//     final attendance_only = Attendance(
//       companyCode: companyCode!,
//       userID: userID!,
//       projectID: projectID!,
//       empAttendanceID: empAttendanceId,
//       date: DateTime.now(),
//       createdUpdateDate: DateTime.now(),
//       inOutTime: time,
//       inOutTimeBase64Image: base64Image,
//       inOutTimeLatitude: location.latitude,
//       inOutTimeLongitude: location.longitude,
//       inOutTimeGeoAddress: location.address,
//       fileName: 'EmpAttendance$type.png',
//       selfAttendanceType: type,
//     );
//
//     final response = await http.post(
//       Uri.parse(ApiEndpoints.saveSelfAttendance),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': token!,
//       },
//       body: json.encode(attendance_only.toJson()),
//     );
//
//     AppLogger.info("📤 $type Attendance Response: ${response.statusCode} - ${response.body}");
//     return response;
//   }
//
//   bool _isApiSuccess(http.Response response) {
//     if (response.statusCode != 200) return false;
//     final jsonBody = json.decode(response.body);
//     return jsonBody['StatusCode'] == 200 &&
//         jsonBody['Data'] == 'Success' &&
//         jsonBody['Message'] == 'SelfAttendance Added';
//   }
//
//   int _extractAttendanceId(String body) {
//     final data = json.decode(body);
//     return int.tryParse(data['EmpAttendanceID']?.toString() ?? '0') ?? 0;
//   }
//
//   Future<LocationDetails> _getLocation() async {
//     final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     final placemarks = await GeocodingPlatform.instance!.placemarkFromCoordinates(pos.latitude, pos.longitude);
//     return LocationDetails(
//       latitude: pos.latitude,
//       longitude: pos.longitude,
//       address: placemarks.first.name ?? "No address found",
//     );
//   }
//
//   Future<File?> _captureImage() async {
//     final picker = ImagePicker();
//     final file = await picker.pickImage(source: ImageSource.camera);
//     return file != null ? File(file.path) : null;
//   }
//
//   @override
//   void dispose() {
//     _stopTimeTicker();
//     super.dispose();
//   }
// }

class CheckInOutNotifier extends StateNotifier<CheckInOutState> {
  CheckInOutNotifier() : super(CheckInOutState());

  Ticker? _ticker;

  /// Starts timer for showing live work duration since check-in.
  void _startTimeTicker(DateTime checkInTime) {
    _ticker?.dispose();
    _ticker = Ticker((elapsed) {
      final duration = DateTime.now().difference(checkInTime);
      final formatted = _formatDuration(duration);
      state = state.copyWith(timeDifference: formatted);
    })..start();
  }

  /// Stops the running duration ticker.
  void _stopTimeTicker() {
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
  }

  /// Checks in the user after capturing image/location and successful API post.
  Future<void> checkIn() async {
    state = state.copyWith(isLoading: true);

    final image = await _captureImage();
    final location = await _getLocation();

    if (image == null) {
      AppLogger.error("❌ Image capture failed during check-in.");
      state = state.copyWith(isLoading: false);
      return;
    }

    final success = await _sendCheckInDataToServer(
      DateTime.now(), // This can be server-side timestamp if needed
      image,
      location,
    );

    if (success) {
      final checkInMoment = DateTime.now(); // ✅ Capture real time after API succeeds

      state = state.copyWith(
        checkInTime: checkInMoment,
        checkInImage: image,
      );

      AppLogger.info("✅ Starting ticker at $checkInMoment");
      _startTimeTicker(checkInMoment);

      // 🔄 Refresh UI
      // await onRefresh();
    }

    state = state.copyWith(isLoading: false);
  }


  /// Checks out the user after successful data post and stops timer.
  Future<void> checkOut() async {
    state = state.copyWith(isLoading: true);

    final image = await _captureImage();
    final location = await _getLocation();
    final empAttendanceId = state.empAttendanceId;


    if (image == null || state.checkInTime == null || state.empAttendanceId == 0) {
      AppLogger.error("❌ Check-out prerequisites missing.");
      state = state.copyWith(isLoading: false);
      return;
    }

    final checkOutMoment = DateTime.now();
    final duration = checkOutMoment.difference(state.checkInTime!);
    final timeFormatted = _formatDuration(duration);

    final success = await _sendCheckOutDataToServer(checkOutMoment, image, location, empAttendanceId!);
    if (success) {
      _stopTimeTicker();
      state = state.copyWith(
        checkOutTime: checkOutMoment,
        checkOutImage: image,
        timeDifference: timeFormatted,
      );

      // 🔄 Refresh UI
      //await onRefresh();

    }

    state = state.copyWith(isLoading: false);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<bool> _sendCheckInDataToServer(DateTime checkInTime, File image, LocationDetails location) async {
    try {
      final response = await _postAttendance(
        time: checkInTime,
        image: image,
        location: location,
        type: "IN",
        empAttendanceId: 0,
      );

      if (_isApiSuccess(response)) {
        final id = _extractAttendanceId(response.body);
        state = state.copyWith(empAttendanceId: id);
        return true;
      }
    } catch (e) {
      AppLogger.error("❌ Check-in API error: $e");
    }
    return false;
  }

  Future<bool> _sendCheckOutDataToServer(DateTime checkOutTime, File image, LocationDetails location, int empAttendanceId) async {
    try {
      final response = await _postAttendance(
        time: checkOutTime,
        image: image,
        location: location,
        type: "OUT",
        empAttendanceId: empAttendanceId,
        //empAttendanceId: state.empAttendanceId ?? 0,
      );

      return _isApiSuccess(response);
    } catch (e) {
      AppLogger.error("❌ Check-out API error: $e");
      return false;
    }
  }

  Future<http.Response> _postAttendance({
    required DateTime time,
    required File image,
    required LocationDetails location,
    required String type,
    required int empAttendanceId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('GeneratedToken');
    final companyCode = prefs.getString('CompanyCode');
    final userID = int.tryParse(prefs.getString('ActiveUserID') ?? '');
    final projectID = int.tryParse(prefs.getString('ActiveProjectID') ?? '');

    if ([token, companyCode, userID, projectID].contains(null)) {
      throw Exception("Missing SharedPreferences data");
    }

    final base64Image = base64Encode(await image.readAsBytes());

    final attendance = Attendance(
      companyCode: companyCode!,
      userID: userID!,
      projectID: projectID!,
      empAttendanceID: empAttendanceId,
      date: DateTime.now(),
      createdUpdateDate: DateTime.now(),
      inOutTime: time,
      inOutTimeBase64Image: base64Image,
      inOutTimeLatitude: location.latitude,
      inOutTimeLongitude: location.longitude,
      inOutTimeGeoAddress: location.address,
      fileName: 'EmpAttendance$type.png',
      selfAttendanceType: type,
    );

    final response = await http.post(
      Uri.parse(ApiEndpoints.saveSelfAttendance),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: json.encode(attendance.toJson()),
    );

    AppLogger.info("📤 $type Attendance Response: ${response.statusCode} - ${response.body}");
    return response;
  }

  bool _isApiSuccess(http.Response response) {
    if (response.statusCode != 200) return false;
    final jsonBody = json.decode(response.body);
    return jsonBody['StatusCode'] == 200 &&
        jsonBody['Data'] == 'Success' &&
        jsonBody['Message'] == 'SelfAttendance Added';
  }

  int _extractAttendanceId(String body) {
    final data = json.decode(body);
    return int.tryParse(data['EmpAttendanceID']?.toString() ?? '0') ?? 0;
  }

  Future<LocationDetails> _getLocation() async {
    // Get the current position
    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get placemarks for the current location (full address components)
    final placemarks = await GeocodingPlatform.instance!
        .placemarkFromCoordinates(pos.latitude, pos.longitude);

    // Extracting the full address components
    final placemark = placemarks.first;
    final fullAddress = [
      placemark.name,
      placemark.thoroughfare,
      placemark.subThoroughfare,
      placemark.locality,
      placemark.subLocality,
      placemark.administrativeArea,
      placemark.subAdministrativeArea,
      placemark.country,
      placemark.postalCode
    ].where((component) => component != null).join(', ');

    // Returning the location details including the full address
    return LocationDetails(
      latitude: pos.latitude,
      longitude: pos.longitude,
      address: fullAddress.isNotEmpty ? fullAddress : "Unknown Location",
    );
  }

  // Future<File?> _captureImage() async {
  //   final picker = ImagePicker();
  //   final file = await picker.pickImage(source: ImageSource.camera);
  //   return file != null ? File(file.path) : null;
  // }

  Future<File?> _captureImage() async {
    final permissionStatus = await Permission.camera.status;

    if (!permissionStatus.isGranted) {
      final result = await Permission.camera.request();
      if (!result.isGranted) {
        AppLogger.error("❌ Camera permission denied.");
        return null;
      }
    }

    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.camera);
      return file != null ? File(file.path) : null;
    } catch (e) {
      AppLogger.error("❌ Error during image capture: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _stopTimeTicker();

    super.dispose();
  }
}


// Providers for state management
final checkInOutStateProvider =
    StateNotifierProvider<CheckInOutNotifier, CheckInOutState>((ref) {
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

// final currentLocationProvider = FutureProvider<LocationDetails>((ref) async {
//   // Check and request location permission
//   bool hasPermission = await _checkAndRequestLocationPermission();
//
//   // If permission is not granted, return a message indicating the issue
//   if (!hasPermission) {
//     return LocationDetails(
//       latitude: 0.0,
//       longitude: 0.0,
//       address: "Location permission not granted",
//     );
//   }
//
//   // Permission granted, proceed to get the location
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//   List<Placemark> placemarks = await GeocodingPlatform.instance!
//       .placemarkFromCoordinates(position.latitude, position.longitude);
//
//   return LocationDetails(
//     latitude: position.latitude,
//     longitude: position.longitude,
//     address: placemarks.toString() ?? "Location not available",
//   );
// });


final currentLocationProvider = FutureProvider<LocationDetails>((ref) async {
  try {
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
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Check if the position is valid
    if (position == null) {
      return LocationDetails(
        latitude: 0.0,
        longitude: 0.0,
        address: "Unable to get position",
      );
    }

    // Get placemarks from the position
    List<Placemark> placemarks = await GeocodingPlatform.instance
        ?.placemarkFromCoordinates(position.latitude, position.longitude) ??
        [];

    // Check if we got any placemarks and return a more readable address
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0]; // Take the first placemark (there can be multiple)

      // Construct a readable address from the placemark
      // String addressParts = [
      //   placemark.name,
      //   placemark.thoroughfare,
      //   placemark.subThoroughfare,
      //   placemark.locality,
      //   placemark.administrativeArea,
      //   placemark.postalCode,
      //   placemark.country,
      // ]
      //     .where((part) => part != null && part.isNotEmpty)
      //     .join(', ');

      String addressParts = [
        placemark.subThoroughfare,   // House number or block (e.g., "C/308")
        placemark.name,              // Building name (e.g., "Ganesh Glory 11")
        placemark.thoroughfare,      // Street/Road (e.g., "Jagatpur Road")
        placemark.subLocality,       // Area within locality (e.g., "Gota")
        placemark.locality,          // City (e.g., "Ahmedabad")
        placemark.administrativeArea, // State (e.g., "Gujarat")
        placemark.postalCode,        // PIN code (e.g., "382470")
        placemark.country,           // Country (e.g., "India")
      ].where((part) => part != null && part.isNotEmpty).join(', ');

      debugPrint('Placemark details: ${placemark.toString()}');

      // Check if there's any address and return a cleaner one
      return LocationDetails(
        latitude: position.latitude,
        longitude: position.longitude,
        address: addressParts.isNotEmpty ? addressParts : "No address found",
      );
    } else {
      return LocationDetails(
        latitude: position.latitude,
        longitude: position.longitude,
        address: "No address found",
      );
    }
  } catch (e) {
    debugPrint("Error in currentLocationProvider: $e");
    return LocationDetails(
      latitude: 0.0,
      longitude: 0.0,
      address: "Error fetching location",
    );
  }
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
    AppLogger.error(
        "🚫 Location permission permanently denied (deniedForever).");
    return false;
  }

  bool granted = permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
  AppLogger.info(granted
      ? "✅ Location permission granted."
      : "❌ Location permission still not granted.");

  return granted;
}

// Dialog to ask for location permission
void _showLocationPermissionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("📍 Location Permission Required"),
      content: Text(
        "Location access is needed to mark attendance_only. Please allow it in app settings.",
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
