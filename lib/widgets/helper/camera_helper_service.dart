import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/attendance/emp_attendance.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/logger.dart';
import '../../features/attendance/AttendanceNotifier.dart';
import '../custom_dialog/custom_confirmation_dialog.dart';
import '../global_loding/global_loader.dart';

class CameraHelperForLaborAttedance {
  static Future<File?> openCamera(BuildContext context, ) async {
    AppLogger.info("Checking camera permission status...");

    PermissionStatus cameraPermission = await Permission.camera.status;

    if (!cameraPermission.isGranted) {
      AppLogger.warn("Camera permission not granted. Requesting permission...");

      PermissionStatus permissionResult = await Permission.camera.request();

      if (permissionResult.isGranted) {
        AppLogger.info("Camera permission granted. Opening camera...");
        return await _openCameraAndShowPreview(context); // ✅ Return File?
      } else if (permissionResult.isDenied) {
        AppLogger.error("Camera permission denied by user.");
        _showPermissionDeniedDialog(context);
      } else if (permissionResult.isPermanentlyDenied) {
        AppLogger.error("Camera permission permanently denied!");
        _showPermissionPermanentlyDeniedDialog(context);
      }
    } else {
      AppLogger.info("Camera permission already granted. Opening camera...");
      return await _openCameraAndShowPreview(context); // ✅ Return File?
    }

    return null; // ✅ Always return something
  }

  /// 🖼️ **Opens Camera and Shows Image Preview Dialog**
  static Future<File?> _openCameraAndShowPreview(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Ensure dialog is shown after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showImagePreviewDialog(context, File(pickedFile.path));
      });

      return File(pickedFile.path); // Return the file path after capturing
    }

    return null; // Return null if no file was picked
  }


  /// 🖼️ **Shows Image Preview with Retake & Confirm Options**
  static void _showImagePreviewDialog(BuildContext context, File imageFile) {
   AppLogger.info("image file path preview => ${imageFile.toString()}");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Confirm Image", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 300, // Fixed width or dynamic as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(imageFile, height: 250, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRetakeButton(context),
                    const SizedBox(width: 10),
                    _buildConfirmButton(context, imageFile),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildRetakeButton(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          Navigator.pop(context); // Close dialog
          openCamera(context); // Retake the image
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.red[100],
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text("Retake", style: TextStyle(color: Colors.red, fontSize: 16)),
      ),
    );
  }

  static Widget _buildConfirmButton(BuildContext context, File imageFile) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context); // Close dialog
          _uploadImage(imageFile); // Upload image
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue, // Adjust to your primary color
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text("Confirm", style: TextStyle(fontSize: 16)),
      ),
    );
  }

  /// 📤 **Uploads the selected image**
  static void _uploadImage(File imageFile) {
    // Implement your image upload logic here
    AppLogger.info("Image uploaded: ${imageFile.path}");
  }

  /// ❌ **Shows Permission Denied Dialog Using CustomConfirmationDialog**
  static void _showPermissionDeniedDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomConfirmationDialog.show(
        context,
        title: "Permission Denied",
        message: "Camera permission is required to take a photo.",
        confirmText: "OK",
        cancelText: "Close",
        onConfirm: () {
          Navigator.pop(context); // Just close the dialog
        },
      );
    });
  }

  /// ⚠️ **Shows Permission Permanently Denied Dialog Using CustomConfirmationDialog**
  static void _showPermissionPermanentlyDeniedDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomConfirmationDialog.show(
        context,
        title: "Permission Permanently Denied",
        message: "You need to enable camera permission in the settings to take a photo.",
        confirmText: "Open Settings",
        cancelText: "Cancel",
        onConfirm: () async {
          await openAppSettings(); // Open system settings
          Navigator.pop(context); // Close the dialog
        },
      );
    });
  }
}

// with riverpod provider
// class CameraHelperForLaborAttedance {
//   static Future<File?> openCamera(BuildContext context,  WidgetRef ref) async {
//     AppLogger.info("Checking camera permission status...");
//
//     PermissionStatus cameraPermission = await Permission.camera.status;
//
//     if (!cameraPermission.isGranted) {
//       AppLogger.warn("Camera permission not granted. Requesting permission...");
//
//       PermissionStatus permissionResult = await Permission.camera.request();
//
//       if (permissionResult.isGranted) {
//         AppLogger.info("Camera permission granted. Opening camera...");
//         return await _openCameraAndShowPreview(context, ref); // ✅ Return File?
//       } else if (permissionResult.isDenied) {
//         AppLogger.error("Camera permission denied by user.");
//         _showPermissionDeniedDialog(context);
//       } else if (permissionResult.isPermanentlyDenied) {
//         AppLogger.error("Camera permission permanently denied!");
//         _showPermissionPermanentlyDeniedDialog(context);
//       }
//     } else {
//       AppLogger.info("Camera permission already granted. Opening camera...");
//       return await _openCameraAndShowPreview(context, ref ); // ✅ Return File?
//     }
//
//     return null; // ✅ Always return something
//   }
//
//   /// 🖼️ **Opens Camera and Shows Image Preview Dialog**
//   static Future<File?> _openCameraAndShowPreview(BuildContext context, WidgetRef ref) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
//
//     if (pickedFile != null) {
//
//       // Store the captured image in the Riverpod provider
//       final File imageFile = File(pickedFile.path);
//       ref.read(capturedImageProvider.notifier).state = imageFile;  // Save to provider
//
//       // Show image preview dialog after the current frame
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _showImagePreviewDialog(context, imageFile, ref);
//       });
//
//       // Ensure dialog is shown after the current frame
//       // WidgetsBinding.instance.addPostFrameCallback((_) {
//       //   _showImagePreviewDialog(context, File(pickedFile.path));
//       // });
//
//       return imageFile;
//       //return File(pickedFile.path); // Return the file path after capturing
//     }
//
//     return null; // Return null if no file was picked
//   }
//
//
//   /// 🖼️ **Shows Image Preview with Retake & Confirm Options**
//   /// 🖼️ **Shows Image Preview with Retake & Confirm Options**
//   static void _showImagePreviewDialog(BuildContext context, File imageFile, WidgetRef ref) {
//     AppLogger.info("image file path preview => ${imageFile.toString()}");
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//           title: const Text("Confirm Image", style: TextStyle(fontWeight: FontWeight.bold)),
//           content: SizedBox(
//             width: 300, // Fixed width or dynamic as needed
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.file(imageFile, height: 250, width: double.infinity, fit: BoxFit.cover),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildRetakeButton(context, ref),
//                     const SizedBox(width: 10),
//                     _buildConfirmButton(context, imageFile),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   static Widget _buildRetakeButton(BuildContext context, WidgetRef ref) {
//     return Expanded(
//       child: TextButton(
//         onPressed: () {
//           Navigator.pop(context); // Close dialog
//           CameraHelperForLaborAttedance.openCamera(context, ref); // Retake the image
//         },
//         style: TextButton.styleFrom(
//           backgroundColor: Colors.red[100],
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         child: const Text("Retake", style: TextStyle(color: Colors.red, fontSize: 16)),
//       ),
//     );
//   }
//
//   static Widget _buildConfirmButton(BuildContext context, File imageFile) {
//     return Expanded(
//       child: ElevatedButton(
//         onPressed: () {
//           Navigator.pop(context); // Close dialog
//           _uploadImage(imageFile); // Upload image
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primaryBlue, // Adjust to your primary color
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         child: const Text("Confirm", style: TextStyle(fontSize: 16)),
//       ),
//     );
//   }
//
//   /// 📤 **Uploads the selected image**
//   static void _uploadImage(File imageFile) {
//     // Implement your image upload logic here
//     AppLogger.info("Image uploaded: ${imageFile.path}");
//   }
//
//   /// ❌ **Shows Permission Denied Dialog Using CustomConfirmationDialog**
//   static void _showPermissionDeniedDialog(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       CustomConfirmationDialog.show(
//         context,
//         title: "Permission Denied",
//         message: "Camera permission is required to take a photo.",
//         confirmText: "OK",
//         cancelText: "Close",
//         onConfirm: () {
//           Navigator.pop(context); // Just close the dialog
//         },
//       );
//     });
//   }
//
//   /// ⚠️ **Shows Permission Permanently Denied Dialog Using CustomConfirmationDialog**
//   static void _showPermissionPermanentlyDeniedDialog(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       CustomConfirmationDialog.show(
//         context,
//         title: "Permission Permanently Denied",
//         message: "You need to enable camera permission in the settings to take a photo.",
//         confirmText: "Open Settings",
//         cancelText: "Cancel",
//         onConfirm: () async {
//           await openAppSettings(); // Open system settings
//           Navigator.pop(context); // Close the dialog
//         },
//       );
//     });
//   }
// }


// Provider to store image path globally
final checkInImagePathProvider = StateProvider<String?>((ref) => null);
final checkOutImagePathProvider = StateProvider<String?>((ref) => null);

class CameraHelper {
  static final CameraHelper _instance = CameraHelper._internal();

  factory CameraHelper() {
    return _instance;
  }

  CameraHelper._internal();

  String? imagePath;

  // This function opens the camera and allows the user to take a photo
  Future<String?> openCamera(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      AppLogger.info('📸 Camera image captured: ${image.name}');
      final directory = await getApplicationDocumentsDirectory();
      final name = image.name;
      final localPath = '${directory.path}/$name';

      final savedFile = await File(image.path).copy(localPath);
      ref.read(capturedImagePathProvider.notifier).state = savedFile.path;
      AppLogger.info('✅ Image saved locally at: $localPath');
      return savedFile.path;
    } else {
      AppLogger.error('❌ No image captured');
      return null;
    }
  }

  // Function to get the stored image path globally using the provider
  String? getImagePath(WidgetRef ref) {
    final path = ref.read(capturedImagePathProvider);
    AppLogger.info('📥 Retrieved captured image path from provider: $path');
    return path;
  }

  // Fetch the location (latitude, longitude, and address)
  Future<String> fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      AppLogger.info('📍 Current position: Lat=${position.latitude}, Long=${position.longitude}');

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        final address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        AppLogger.info('📍 Resolved address: $address');
        return address;
      } else {
        AppLogger.warn('⚠️ No placemarks found.');
        return "Address not found";
      }
    } catch (e) {
      AppLogger.error('❌ Error fetching location: $e');
      return "Error: $e";
    }
  }


  static Future<void> uploadImage(
      BuildContext context,
      String imagePath,
      String attendanceType,  // Use String for attendance type instead of enum
      double latitude,
      double longitude,
      String geoAddress,
      DateTime? checkInTime,    // Accept check-in time
      DateTime? checkOutTime,   // Accept check-out time
      int empAttendanceId,      // Pass empAttendanceId
      ) async {
    try {
      // Log the attendance type and ID before creating the Attendance object
      AppLogger.info("🟡 Attendance Type: $attendanceType | Attendance ID: $empAttendanceId");

      AppLogger.info("📷 Image path: $imagePath");

      // Create a File instance from the image path
      File imageFile = File(imagePath);

      // Check if the image file exists
      if (!imageFile.existsSync()) {
        AppLogger.error("🚫 Image file does not exist at path: $imagePath");
        return;
      }

      // Read image bytes and encode them to base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Log image details
      AppLogger.info("🧬 Encoded base64 image length: ${base64Image.length}");
      AppLogger.info("📍 Location: Lat=$latitude, Long=$longitude");
      AppLogger.info("🏠 Address: $geoAddress");
      AppLogger.info("💼 EmpAttendanceId: $empAttendanceId");

      // Call API to upload the attendance with the image, time, and location
      final result = await addAttendanceWithImage(
        context,
        base64Image,
        attendanceType, // Pass the String directly
        latitude,
        longitude,
        geoAddress,
        checkInTime,     // Pass check-in time to the API
        checkOutTime,    // Pass check-out time to the API
        empAttendanceId, // Pass empAttendanceId to the API
      );

      // Log the result of the upload attempt
      AppLogger.info("✅ Upload result for $attendanceType: $result");


    } catch (e) {
      // Log any exceptions that occur during the upload process
      AppLogger.error("❌ Exception during uploadImage for $attendanceType: $e");
    }
  }






  // Add attendance with image, latitude, longitude, and address
  static Future<String> addAttendanceWithImage(
      BuildContext context,
      String base64Image,
      String attendanceType,
      double latitude,
      double longitude,
      String geoAddress,
      DateTime? checkInTime, // Accept check-in time
      DateTime? checkOutTime, // Accept check-out time
      int empAttendanceId,    // Accept empAttendanceId
      ) async {
    try {
      // 🔄 Show the global loader
      GlobalLoader.show(context);


      final prefs = await SharedPreferences.getInstance();
      final companyCode = prefs.getString('CompanyCode');
      final activeUserID = prefs.getString('ActiveUserID');
      final activeProjectID = prefs.getString('ActiveProjectID');
      final authToken = prefs.getString('GeneratedToken');

      if (companyCode == null || authToken == null || activeUserID == null || activeProjectID == null) {
        AppLogger.error("⚠️ Missing required SharedPreferences data.");
        GlobalLoader.hide(); // 🔽 Hide loader on early exit
        return "Error: Missing required data.";
      }

      // Log the attendance type before creating the Attendance object
      AppLogger.info("🟡 Attendance Type: $attendanceType | Attendance ID: $empAttendanceId");


      DateTime? inOutTime;

      // Conditionally set inOutTime based on attendanceType
      if (attendanceType == "IN" && checkInTime != null) {
        inOutTime = checkInTime; // Use check-in time for "IN"
      }

      // Log inOutTime before proceeding
      AppLogger.info("📍 InOutTime set to: $inOutTime");

      Attendance empAttendance = Attendance(
        companyCode: companyCode,
        userID: int.tryParse(activeUserID) ?? 0,
        projectID: int.tryParse(activeProjectID) ?? 0,
        empAttendanceID: empAttendanceId,
        date: DateTime.now(),
        createdUpdateDate: DateTime.now(),
        inOutTime: inOutTime ?? DateTime.now(), // Set inOutTime, fallback to current time
        //inOutTimeBase64Image: "https://dummyjson.com/image/400x200?type=webp&text=I+am+a+webp+image",
        inOutTimeBase64Image: base64Image,
        inOutTimeLatitude: latitude,
        inOutTimeLongitude: longitude,
        inOutTimeGeoAddress: geoAddress,
        fileName: 'EmpAttendancePlaceIMG.png',
        selfAttendanceType: attendanceType,
        // checkInTime: checkInTime, // Add check-in time to the model
        // checkOutTime: checkOutTime, // Add check-out time to the model
      );

      // Format the request body for logging each parameter on a new line
      String requestBody = json.encode(empAttendance.toJson());
      AppLogger.info("📤 Request Body:");
      AppLogger.info("companyCode: ${empAttendance.companyCode}");
      AppLogger.info("userID: ${empAttendance.userID}");
      AppLogger.info("projectID: ${empAttendance.projectID}");
      AppLogger.info("empAttendanceID: ${empAttendance.empAttendanceID}");
      AppLogger.info("date: ${empAttendance.date}");
      AppLogger.info("createdUpdateDate: ${empAttendance.createdUpdateDate}");
      AppLogger.info("inOutTime: ${empAttendance.inOutTime}");
      AppLogger.info("inOutTimeBase64Image: ${empAttendance.inOutTimeBase64Image?.substring(0, 50)}..."); // Log a portion of the base64 string for brevity
      AppLogger.info("inOutTimeLatitude: ${empAttendance.inOutTimeLatitude}");
      AppLogger.info("inOutTimeLongitude: ${empAttendance.inOutTimeLongitude}");
      AppLogger.info("inOutTimeGeoAddress: ${empAttendance.inOutTimeGeoAddress}");
      AppLogger.info("fileName: ${empAttendance.fileName}");
      AppLogger.info("selfAttendanceType: ${empAttendance.selfAttendanceType}");

      //final apiUrl = Uri.parse("https://crudcrud.com/api/3cce3d0a2c524bb099083ed3a99e8b39/selfattendance/680dff3d35fa0203e8bb6116");
      final apiUrl = Uri.parse(ApiEndpoints.saveSelfAttendance);
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "$authToken",
      };

      final body = json.encode(empAttendance.toJson());

      AppLogger.info("Sending attendance data to server with API URL: $apiUrl");
      final response = await http.put(apiUrl, body: body, headers: headers);

      // Log the response status code and body
      AppLogger.info(" Response Status: ${response.statusCode}");
      AppLogger.info(" Response Body: ${response.body}");

      // 🔽 Hide loader after getting the response
      GlobalLoader.hide();

      if (response.statusCode == 200) {
        AppLogger.info("✅ Attendance uploaded successfully");
        return "Success";

      } else {
        AppLogger.error("❌ Failed to upload attendance. Status Code: ${response.statusCode}");
        AppLogger.error("🔴 Response Body: ${response.body}");
        return "Failure";
      }
    } catch (e) {
      AppLogger.error("❌ Error during API call: $e");
      return "Error: $e";
    }
  }


}








