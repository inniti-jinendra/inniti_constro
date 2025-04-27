// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:flutter_svg/flutter_svg.dart';
// // // import 'package:inniti_constro/features/attendance/AttendanceNotifier.dart';  // Correct import
// // // import '../../../core/constants/constants.dart';
// // // import '../../../core/network/logger.dart';
// // // import '../../widgets/helper/camera_helper_service.dart';  // Correct import
// // //
// // // class SwipeToggleButton extends ConsumerWidget {
// // //   final String checkInText;
// // //   final String checkOutText;
// // //   final Color checkInColor;
// // //   final Color checkOutColor;
// // //   final String checkInIcon;
// // //   final String checkOutIcon;
// // //   final Color backgroundColor;
// // //   final Future<void> Function()? onCameraOpen;
// // //
// // //   const SwipeToggleButton({
// // //     Key? key,
// // //     this.checkInText = "Swipe to Check In ->",
// // //     this.checkOutText = "<- Swipe to Check Out",
// // //     this.checkInColor = Colors.green,
// // //     this.checkOutColor = Colors.red,
// // //     this.checkInIcon = 'assets/icons/attendance/user-tick.svg',
// // //     this.checkOutIcon = 'assets/icons/attendance/user-tick.svg',
// // //     this.backgroundColor = AppColors.primaryBlue,
// // //     this.onCameraOpen,
// // //   }) : super(key: key);
// // //
// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final state = ref.watch(attendanceProvider);
// // //     final notifier = ref.read(attendanceProvider.notifier);
// // //     final capturedImagePath = ref.watch(capturedImagePathProvider);
// // //     // final isLoading = ref.watch(loadingProvider); // Watch loading state
// // //
// // //     final isCheckedIn = state.checkInTime != null && state.checkOutTime == null;
// // //
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         // Show loader while capturing the image
// // //         // if (isLoading)
// // //         //   Center(
// // //         //     child: CircularProgressIndicator(),
// // //         //   ),
// // //
// // //         GestureDetector(
// // //           onHorizontalDragEnd: (details) async {
// // //             if (details.primaryVelocity != 0) {
// // //               AppLogger.info("➡️ Swipe detected");
// // //
// // //               // Set loading to true while capturing the image
// // //              // ref.read(loadingProvider.notifier).state = true;
// // //
// // //               // Open the camera if callback is provided
// // //               if (onCameraOpen != null) {
// // //                 await onCameraOpen!();
// // //               }
// // //
// // //               notifier.togglePresent();
// // //
// // //               // Simulate capturing the image and getting the path
// // //               final imagePath = await CameraHelper().getImagePath();
// // //
// // //               if (imagePath != null) {
// // //                 // Update the captured image path after the camera opens and image is captured
// // //                 ref.read(capturedImagePathProvider.notifier).updateCapturedImagePath(imagePath);
// // //               }
// // //
// // //               // Add a delay of 2 seconds before hiding the loading spinner and refreshing the UI
// // //               Future.delayed(const Duration(seconds: 2), () {
// // //                 // Hide loading after the image is captured and path is updated
// // //                 //ref.read(loadingProvider.notifier).state = false;
// // //
// // //                 // Show snack bar with check-in/check-out status
// // //                 ScaffoldMessenger.of(context).showSnackBar(
// // //                   SnackBar(
// // //                     content: Text(isCheckedIn ? "Checked Out" : "Checked In"),
// // //                     backgroundColor: isCheckedIn ? checkOutColor : checkInColor,
// // //                   ),
// // //                 );
// // //               });
// // //             }
// // //           },
// // //           child: AnimatedContainer(
// // //             duration: const Duration(milliseconds: 300),
// // //             curve: Curves.easeInOut,
// // //             width: double.infinity,
// // //             height: 60,
// // //             decoration: BoxDecoration(
// // //               color: backgroundColor,
// // //               borderRadius: BorderRadius.circular(10),
// // //             ),
// // //             child: Stack(
// // //               alignment: Alignment.center,
// // //               children: [
// // //                 Center(
// // //                   child: Text(
// // //                     isCheckedIn ? checkOutText : checkInText,
// // //                     style: TextStyle(
// // //                       color: Colors.white.withOpacity(0.85),
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.w500,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 AnimatedAlign(
// // //                   alignment:
// // //                   isCheckedIn ? Alignment.centerRight : Alignment.centerLeft,
// // //                   duration: const Duration(milliseconds: 300),
// // //                   curve: Curves.easeInOut,
// // //                   child: Padding(
// // //                     padding: const EdgeInsets.all(8.0),
// // //                     child: Container(
// // //                       width: 44,
// // //                       height: 44,
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.white,
// // //                         borderRadius: BorderRadius.circular(10),
// // //                       ),
// // //                       child: Center(
// // //                         child: SvgPicture.asset(
// // //                           isCheckedIn ? checkOutIcon : checkInIcon,
// // //                           color: isCheckedIn ? checkOutColor : checkInColor,
// // //                           width: 24,
// // //                           height: 24,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //         if (capturedImagePath != null) ...[
// // //           const SizedBox(height: 8),
// // //           Text(
// // //             "📸 Captured Image Path:",
// // //             style: TextStyle(
// // //               color: Colors.black87,
// // //               fontWeight: FontWeight.w600,
// // //               fontSize: 12,
// // //             ),
// // //           ),
// // //           Text(
// // //             capturedImagePath,
// // //             style: TextStyle(
// // //               fontSize: 11,
// // //               color: Colors.grey[700],
// // //             ),
// // //             overflow: TextOverflow.ellipsis,
// // //           ),
// // //         ],
// // //       ],
// // //     );
// // //   }
// // // }
// // //
// // // final capturedImagePathProvider =
// // // StateNotifierProvider<CapturedImagePathNotifier, String>((ref) {
// // //   return CapturedImagePathNotifier('');
// // // });
// // //
// // // class CapturedImagePathNotifier extends StateNotifier<String> {
// // //   CapturedImagePathNotifier(String state) : super(state);
// // //
// // //   void updateCapturedImagePath(String newPath) {
// // //     state = newPath; // Update the path
// // //   }
// // // }
// // //
// // // // final loadingProvider = StateProvider<bool>((ref) => false); // Define loading provider
// // //
// // //
// // //
// // //
// // //
// // //
// // //
// // //
// // //
// // // // class SwipeToggleButton extends ConsumerStatefulWidget {
// // // //   final AttendanceNotifier notifier;
// // // //
// // // //   const SwipeToggleButton({Key? key, required this.notifier}) : super(key: key);
// // // //
// // // //   @override
// // // //   ConsumerState<SwipeToggleButton> createState() => _SwipeToggleButtonState();
// // // // }
// // // //
// // // // class _SwipeToggleButtonState extends ConsumerState<SwipeToggleButton> {
// // // //   double _dragPosition = 0;
// // // //   bool _isDragging = false;
// // // //   bool _dragDirectionLeftToRight = true;
// // // //
// // // //   final double _dragThreshold = 150;
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final state = ref.watch(attendanceProvider);
// // // //     final isCheckedIn = state.checkInTime != null && state.checkOutTime == null;
// // // //
// // // //     final containerWidth = MediaQuery.of(context).size.width - 40;
// // // //     final handleWidth = 60.0;
// // // //
// // // //     return GestureDetector(
// // // //       onHorizontalDragUpdate: (details) {
// // // //         setState(() {
// // // //           _isDragging = true;
// // // //
// // // //           if (details.primaryDelta! > 0) {
// // // //             _dragDirectionLeftToRight = true;
// // // //           } else {
// // // //             _dragDirectionLeftToRight = false;
// // // //           }
// // // //
// // // //           _dragPosition += details.primaryDelta!;
// // // //           _dragPosition = _dragPosition.clamp(0.0, containerWidth - handleWidth);
// // // //         });
// // // //       },
// // // //       onHorizontalDragEnd: (details) async {
// // // //         final dragDistance = _dragDirectionLeftToRight
// // // //             ? _dragPosition
// // // //             : (containerWidth - handleWidth - _dragPosition);
// // // //
// // // //         if (dragDistance > _dragThreshold) {
// // // //           // 👉 Always open camera
// // // //           await CameraHelper().openCamera(context);
// // // //
// // // //           // 👉 Toggle attendance
// // // //           widget.notifier.togglePresent();
// // // //
// // // //           await Future.delayed(const Duration(milliseconds: 100));
// // // //
// // // //           final updatedState = ref.read(attendanceProvider);
// // // //           final justCheckedIn = updatedState.checkInTime != null && updatedState.checkOutTime == null;
// // // //
// // // //           final capturedImagePath = CameraHelper().getImagePath();
// // // //           ref.read(capturedImagePathProvider.notifier).updateCapturedImagePath(capturedImagePath!);
// // // //           AppLogger.info("Captured Image Path: $capturedImagePath");
// // // //
// // // //           ScaffoldMessenger.of(context).showSnackBar(
// // // //             SnackBar(
// // // //               content: Text(justCheckedIn ? "Checked In" : "Checked Out"),
// // // //               backgroundColor: justCheckedIn ? Colors.green : Colors.red,
// // // //             ),
// // // //           );
// // // //         }
// // // //
// // // //         setState(() {
// // // //           _dragPosition = _dragDirectionLeftToRight
// // // //               ? containerWidth - handleWidth
// // // //               : 0;
// // // //
// // // //           _isDragging = false;
// // // //         });
// // // //       },
// // // //       child: Container(
// // // //         width: containerWidth,
// // // //         height: 60,
// // // //         decoration: BoxDecoration(
// // // //           color: AppColors.primaryBlue,
// // // //           borderRadius: BorderRadius.circular(12),
// // // //         ),
// // // //         child: Stack(
// // // //           children: [
// // // //             Center(
// // // //               child: Text(
// // // //                 isCheckedIn ? "<- Swipe to Check Out" : "Swipe to Check In ->",
// // // //                 style: TextStyle(
// // // //                   color: Colors.white.withOpacity(0.85),
// // // //                   fontSize: 16,
// // // //                   fontWeight: FontWeight.w600,
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             Positioned(
// // // //               left: _dragPosition,
// // // //               child: AnimatedContainer(
// // // //                 duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
// // // //                 curve: Curves.easeOut,
// // // //                 width: handleWidth,
// // // //                 height: 57,
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.white,
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                 ),
// // // //                 child: Center(
// // // //                   child: SvgPicture.asset(
// // // //                     'assets/icons/attendance/user-tick.svg',
// // // //                     color: isCheckedIn ? Colors.red : Colors.green,
// // // //                     width: 24,
// // // //                     height: 24,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:inniti_constro/features/attendance/AttendanceNotifier.dart';  // Correct import
// // import '../../../core/constants/constants.dart';
// // import '../../../core/network/logger.dart';
// // import '../../core/utils/shared_preferences_util.dart';
// // import '../../widgets/helper/camera_helper_service.dart';  // Correct import
// // import 'package:http/http.dart' as http;
// // import 'dart:convert'; // To decode json
// //
// // class SwipeToggleButton extends ConsumerWidget {
// //   final String checkInText;
// //   final String checkOutText;
// //   final Color checkInColor;
// //   final Color checkOutColor;
// //   final String checkInIcon;
// //   final String checkOutIcon;
// //   final Color backgroundColor;
// //   final Future<void> Function()? onCameraOpen;
// //
// //   const SwipeToggleButton({
// //     Key? key,
// //     this.checkInText = "Swipe to Check In ->",
// //     this.checkOutText = "<- Swipe to Check Out",
// //     this.checkInColor = Colors.green,
// //     this.checkOutColor = Colors.red,
// //     this.checkInIcon = 'assets/icons/attendance/user-tick.svg',
// //     this.checkOutIcon = 'assets/icons/attendance/user-tick.svg',
// //     this.backgroundColor = AppColors.primaryBlue,
// //     this.onCameraOpen,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final state = ref.watch(attendanceProvider);
// //     final notifier = ref.read(attendanceProvider.notifier);
// //     final capturedImagePath = ref.watch(capturedImagePathProvider);
// //
// //     final isCheckedIn = state.checkInTime != null && state.checkOutTime == null;
// //
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         GestureDetector(
// //           onHorizontalDragEnd: (details) async {
// //             if (details.primaryVelocity != 0) {
// //               AppLogger.info("➡️ Swipe detected");
// //
// //               // Log the velocity of the swipe to understand the drag behavior
// //               AppLogger.info("Swipe velocity: ${details.primaryVelocity}");
// //
// //               // Set loading to true while capturing the image (commented out if not needed)
// //               // ref.read(loadingProvider.notifier).state = true;
// //
// //               // Open the camera if callback is provided
// //               if (onCameraOpen != null) {
// //                 AppLogger.info("Opening the camera to capture image...");
// //                 await onCameraOpen!();
// //                 AppLogger.info("Camera opened successfully.");
// //               }
// //
// //               // Toggle attendance state (check-in or check-out)
// //               AppLogger.info("Toggling attendance state...");
// //               notifier.togglePresent();
// //
// //               // Simulate capturing the image and getting the path
// //               AppLogger.info("Capturing image...");
// //               final imagePath = await CameraHelper().getImagePath();
// //              // final imagePath = await CameraHelper().getImagePath();
// //               AppLogger.info("image captured...");
// //
// //
// //               if (imagePath != null) {
// //                 // Update the captured image path after the camera opens and image is captured
// //                 AppLogger.info("Captured image path: $imagePath");
// //                 ref.read(capturedImagePathProvider.notifier).updateCapturedImagePath(imagePath);
// //
// //                 // Log the check-in and check-out times
// //                 final checkInTime = state.checkInTime?.toIso8601String() ?? '';
// //                 final checkOutTime = state.checkOutTime?.toIso8601String() ?? '';
// //                 AppLogger.info("Check-in time: $checkInTime");
// //                 AppLogger.info("Check-out time: $checkOutTime");
// //
// //                 // Make sure that the image path is set and available before making the API call
// //                 if (imagePath.isNotEmpty) {
// //                   try {
// //                     // Call the API to add attendance with the image path
// //                     AppLogger.info("Calling addAttendance API with image path, check-in time: $checkInTime and check-out time: $checkOutTime...");
// //
// //                     // You can pass the image path to the addAttendance API if needed, depending on your backend logic
// //                     final attendanceMessage = await addAttendance(checkInTime, checkOutTime);
// //
// //                     // Log the attendance message
// //                     AppLogger.info("Attendance API response: $attendanceMessage");
// //
// //                     // Add a delay of 2 seconds before hiding the loading spinner and refreshing the UI
// //                     Future.delayed(const Duration(seconds: 2), () {
// //                       // Hide loading after the image is captured and path is updated (if loading is used)
// //                       // ref.read(loadingProvider.notifier).state = false;
// //
// //                       // Show snack bar with check-in/check-out status
// //                       // ScaffoldMessenger.of(context).showSnackBar(
// //                       //   SnackBar(
// //                       //     content: Text(attendanceMessage),
// //                       //     backgroundColor: isCheckedIn ? checkOutColor : checkInColor,
// //                       //   ),
// //                       // );
// //
// //
// //                     });
// //                   } catch (e, stackTrace) {
// //                     AppLogger.error("Error in addAttendance API call: $e");
// //                     AppLogger.error("StackTrace: $stackTrace");
// //
// //                     // Show an error message if the API call fails
// //                     // ScaffoldMessenger.of(context).showSnackBar(
// //                     //   SnackBar(
// //                     //     content: Text('Failed to add attendance.'),
// //                     //     backgroundColor: Colors.red,
// //                     //   ),
// //                     // );
// //                   }
// //                 } else {
// //                   AppLogger.info("Image path is empty. Skipping attendance API call.");
// //                   // ScaffoldMessenger.of(context).showSnackBar(
// //                   //   SnackBar(
// //                   //     content: Text('No image captured. Unable to proceed with attendance.'),
// //                   //     backgroundColor: Colors.red,
// //                   //   ),
// //                   // );
// //                 }
// //               } else {
// //                 AppLogger.info("No image captured.");
// //               }
// //             } else {
// //               AppLogger.info("No horizontal swipe detected. Swipe velocity is zero.");
// //             }
// //           },
// //
// //
// //
// //
// //           child: AnimatedContainer(
// //             duration: const Duration(milliseconds: 300),
// //             curve: Curves.easeInOut,
// //             width: double.infinity,
// //             height: 60,
// //             decoration: BoxDecoration(
// //               color: backgroundColor,
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 Center(
// //                   child: Text(
// //                     isCheckedIn ? checkOutText : checkInText,
// //                     style: TextStyle(
// //                       color: Colors.white.withOpacity(0.85),
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ),
// //                 AnimatedAlign(
// //                   alignment:
// //                   isCheckedIn ? Alignment.centerRight : Alignment.centerLeft,
// //                   duration: const Duration(milliseconds: 300),
// //                   curve: Curves.easeInOut,
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Container(
// //                       width: 44,
// //                       height: 44,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       child: Center(
// //                         child: SvgPicture.asset(
// //                           isCheckedIn ? checkOutIcon : checkInIcon,
// //                           color: isCheckedIn ? checkOutColor : checkInColor,
// //                           width: 24,
// //                           height: 24,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         if (capturedImagePath != null) ...[
// //           const SizedBox(height: 8),
// //           Text(
// //             "📸 Captured Image Path:",
// //             style: TextStyle(
// //               color: Colors.black87,
// //               fontWeight: FontWeight.w600,
// //               fontSize: 12,
// //             ),
// //           ),
// //           Text(
// //             capturedImagePath,
// //             style: TextStyle(
// //               fontSize: 11,
// //               color: Colors.grey[700],
// //             ),
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //         ],
// //       ],
// //     );
// //   }
// //
// //   // Method to call API for attendance submission
// //   Future<String> addAttendance(String checkInTime, String checkOutTime) async {
// //     try {
// //       AppLogger.info("Starting addAttendance function");
// //
// //       final companyCode =
// //       await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
// //       final activeUserID =
// //       await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
// //       final activeProjectID =
// //       await SharedPreferencesUtil.getSharedPreferenceData('ActiveProjectID');
// //
// //       AppLogger.info("Fetched SharedPreferences - CompanyCode: $companyCode, UserID: $activeUserID, ProjectID: $activeProjectID");
// //
// //       final apiUrl = Uri.parse('http://192.168.1.25:1016/api/SelfAttendance/Save-Self-Attendance');
// //
// //       final Map<String, dynamic> body = {
// //         "CompanyCode": "CONSTRO",
// //         "EmpAttendanceID": 0,
// //         "Date": DateTime.now().toIso8601String(),
// //         "UserID": int.tryParse(activeUserID ?? '0') ?? 0,
// //         "CreatedUpdateDate": DateTime.now().toIso8601String(),
// //         "InOutTime": checkInTime.isNotEmpty ? checkInTime : checkOutTime,
// //         "InOutTime_Base64Image": "your-base64-encoded-image", // Replace with actual base64 image
// //         "InOutTime_Latitude": "0.00",
// //         "InOutTime_Longitude": "0.00",
// //         "InOutTime_GeoAddress": "Gota",
// //         "ProjectID": int.tryParse(activeProjectID ?? '0') ?? 0,
// //         "FileName": "demo.png",
// //         "SelfAttendanceType": checkInTime.isNotEmpty ? "IN" : "OUT"
// //       };
// //
// //       AppLogger.info("Sending POST request to $apiUrl");
// //       AppLogger.info("Request body: ${jsonEncode(body)}");
// //
// //       final response = await http.post(
// //         apiUrl,
// //         headers: {
// //           "Content-Type": "application/json",
// //         },
// //         body: jsonEncode(body),
// //       );
// //
// //       AppLogger.info("Received response with status code: ${response.statusCode}");
// //
// //       if (response.statusCode == 200) {
// //         final responseData = jsonDecode(response.body);
// //         AppLogger.info("Response body: $responseData");
// //         return responseData['message'] ?? 'Attendance added successfully';
// //       } else {
// //         AppLogger.info("Failed to add attendance. Status code: ${response.statusCode}");
// //         return 'Failed to add attendance. Error: ${response.statusCode}';
// //       }
// //     } catch (e, stackTrace) {
// //       AppLogger.info("Exception in addAttendance: $e\nStackTrace: $stackTrace");
// //       return 'Something went wrong while submitting attendance.';
// //     }
// //   }
// // }
// //
// // final capturedImagePathProvider =
// // StateNotifierProvider<CapturedImagePathNotifier, String>((ref) {
// //   return CapturedImagePathNotifier('');
// // });
// //
// // class CapturedImagePathNotifier extends StateNotifier<String> {
// //   CapturedImagePathNotifier(String state) : super(state);
// //
// //   void updateCapturedImagePath(String newPath) {
// //     state = newPath; // Update the path
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
//
// import '../../core/constants/app_colors.dart';
// import '../../core/network/logger.dart';
// import '../../widgets/helper/camera_helper_service.dart';
// import 'AttendanceNotifier.dart';
//
// // class SwipeToggleButton extends ConsumerWidget {
// //   final AttendanceNotifier notifier;
// //
// //   const SwipeToggleButton({Key? key, required this.notifier}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final state = ref.watch(attendanceProvider);
// //     final isCheckedIn = state.checkInTime != null && state.checkOutTime == null;
// //
// //     // Access the Captured Image Path provider
// //     final capturedImagePathState = ref.watch(capturedImagePathProvider);
// //
// //     return GestureDetector(
// //       onHorizontalDragEnd: (details) async {
// //         if (details.primaryVelocity != 0) {
// //           await CameraHelper().openCamera(context); // Open the camera
// //
// //           // After taking the photo, toggle the attendance state
// //           notifier.togglePresent();
// //
// //           await Future.delayed(const Duration(milliseconds: 100));
// //
// //           final updatedState = ref.read(attendanceProvider);
// //           final justCheckedIn =
// //               updatedState.checkInTime != null &&
// //                   updatedState.checkOutTime == null;
// //
// //           // Use the captured image path
// //           String? capturedImagePath = CameraHelper().getImagePath();
// //
// //           // Update the captured image path in the provider
// //           if (capturedImagePath != null) {
// //             ref
// //                 .read(capturedImagePathProvider.notifier)
// //                 .updateCapturedImagePath(capturedImagePath);
// //
// //             // Log the captured image path for better understanding
// //             AppLogger.info("Captured Image Path: $capturedImagePath");
// //
// //             AppLogger.info("justCheckedIn: $justCheckedIn");
// //             AppLogger.info(justCheckedIn ? "Checked In" : "Checked Out");
// //
// //             // Fetch the location for the current attendance status
// //             Position position = await Geolocator.getCurrentPosition(
// //               desiredAccuracy: LocationAccuracy.high,
// //             );
// //             String location = await CameraHelper().fetchLocation();
// //
// //             // Log the fetched location for better understanding
// //             AppLogger.info(
// //               "Location fetched - Latitude: ${position.latitude}, Longitude: ${position.longitude}, Address: $location",
// //             );
// //
// //             // Call the API to upload the attendance with image, location, and checked-in status
// //             await CameraHelper.uploadImage(
// //               capturedImagePath,
// //               justCheckedIn ? "IN" : "OUT", // Attendance type: IN or OUT
// //               position.latitude,
// //               position.longitude,
// //               location,
// //             );
// //           } else {
// //             AppLogger.error("No captured image found!");
// //           }
// //         }
// //       },
// //
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeInOut,
// //         width: double.infinity,
// //         height: 60,
// //         decoration: BoxDecoration(
// //           color: AppColors.primaryBlue,
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //         child: Stack(
// //           alignment: Alignment.center,
// //           children: [
// //             Center(
// //               child: Text(
// //                 isCheckedIn ? "<- Swipe to Check Out" : "Swipe to Check In ->",
// //                 style: TextStyle(
// //                   color: Colors.white.withOpacity(0.8),
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ),
// //             AnimatedAlign(
// //               alignment:
// //               isCheckedIn ? Alignment.centerRight : Alignment.centerLeft,
// //               duration: const Duration(milliseconds: 300),
// //               curve: Curves.easeInOut,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Container(
// //                   width: 44,
// //                   height: 44,
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: Center(
// //                     child: SvgPicture.asset(
// //                       isCheckedIn
// //                           ? 'assets/icons/attendance/user-tick.svg'
// //                           : 'assets/icons/attendance/user-tick.svg',
// //                       color: isCheckedIn ? Colors.red : Colors.green,
// //                       width: 24,
// //                       height: 24,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class SwipeToggleButton extends ConsumerWidget {
//   final AttendanceNotifier notifier;
//
//   const SwipeToggleButton({Key? key, required this.notifier}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(attendanceProvider);
//     final isCheckedIn = state.checkInTime != null && state.checkOutTime == null;
//
//     return GestureDetector(
//       onHorizontalDragEnd: (details) async {
//         if (details.primaryVelocity == null || details.primaryVelocity == 0) return;
//
//         final isSwipeRight = details.primaryVelocity! > 0;
//
//         // ✅ Check-in Swipe
//         if (isSwipeRight) {
//           await CameraHelper().openCamera(context);
//           final imagePath = CameraHelper().getImagePath();
//
//           if (imagePath != null) {
//             ref.read(checkInImagePathProvider.notifier).state = imagePath;
//             notifier.checkIn(DateTime.now());
//
//             AppLogger.info("Check-In Image Path: $imagePath");
//
//             final position = await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high,
//             );
//             final location = await CameraHelper().fetchLocation();
//
//             await CameraHelper.uploadImage(
//               imagePath,
//               "IN",
//               position.latitude,
//               position.longitude,
//               location,
//             );
//           } else {
//             AppLogger.error("No image captured for Check-In.");
//           }
//         }
//
//         // ✅ Check-out Swipe
//         else {
//           final current = ref.read(attendanceProvider);
//
//           if (current.checkInTime == null || current.checkOutTime != null) {
//             AppLogger.error("Invalid Check-Out attempt.");
//             return;
//           }
//
//           await CameraHelper().openCamera(context);
//           final imagePath = CameraHelper().getImagePath();
//
//           if (imagePath != null) {
//             ref.read(checkOutImagePathProvider.notifier).state = imagePath;
//             notifier.checkOut(DateTime.now());
//
//             AppLogger.info("Check-Out Image Path: $imagePath");
//
//             final position = await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high,
//             );
//             final location = await CameraHelper().fetchLocation();
//
//             await CameraHelper.uploadImage(
//               imagePath,
//               "OUT",
//               position.latitude,
//               position.longitude,
//               location,
//             );
//           } else {
//             AppLogger.error("No image captured for Check-Out.");
//           }
//         }
//       },
//
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         width: double.infinity,
//         height: 60,
//         decoration: BoxDecoration(
//           color: AppColors.primaryBlue,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Center(
//               child: Text(
//                 isCheckedIn ? "<- Swipe to Check Out" : "Swipe to Check In ->",
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.8),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             AnimatedAlign(
//               alignment: isCheckedIn ? Alignment.centerRight : Alignment.centerLeft,
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: 44,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Center(
//                     child: SvgPicture.asset(
//                       'assets/icons/attendance/user-tick.svg',
//                       color: isCheckedIn ? Colors.red : Colors.green,
//                       width: 24,
//                       height: 24,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
// // Assume these providers exist
// final checkInImagePathProvider = StateProvider<String?>((ref) => null);
// final checkOutImagePathProvider = StateProvider<String?>((ref) => null);
