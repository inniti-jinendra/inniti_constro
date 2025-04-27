import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:inniti_constro/widgets/global_loding/global_loader.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:intl/intl.dart'; // For formatting the current time
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/logger.dart';
import '../../widgets/helper/camera_helper_service.dart';
import 'check_in_check_out_provider.dart';  // Import your provider


// class CheckInButton extends ConsumerStatefulWidget {
//   const CheckInButton({super.key});
//
//   @override
//   _CheckInButtonState createState() => _CheckInButtonState();
// }
//
// class _CheckInButtonState extends ConsumerState<CheckInButton> {
//   bool isFinished = false; // Track whether the slide is finished
//   bool isCheckIn = true; // Track whether the user is checking in or checking out
//
//   bool canSwipe = false; // Flag to control swipe functionality
//
//   // Function to handle the swipe action completion
//   // Future<void> handleSlideSubmit() async {
//   //   final currentTime = DateTime.now();
//   //   final formattedTime = DateFormat('HH:mm:ss').format(currentTime);
//   //
//   //   setState(() {
//   //     isFinished = !isFinished;
//   //   });
//   //
//   //   if (isCheckIn) {
//   //     ref.read(checkInTimeProvider.notifier).state = currentTime;
//   //     ref.read(checkInOutProvider.notifier).setCheckInTime(currentTime);
//   //     print('✅ Check-In Completed at $formattedTime');
//   //   } else {
//   //     ref.read(checkInOutProvider.notifier).setCheckOutTime(currentTime);
//   //     print('✅ Check-Out Completed at $formattedTime');
//   //   }
//   //
//   //   setState(() {
//   //     isCheckIn = !isCheckIn;
//   //   });
//   // }
//
//
//   Future<void> handleSlideSubmit() async {
//     final currentTime = DateTime.now();
//     final formattedTime = DateFormat('HH:mm:ss').format(currentTime);
//
//     // Toggle check-in/check-out animation state
//     setState(() {
//       isFinished = !isFinished;
//     });
//
//     final notifier = ref.read(checkInOutProvider.notifier);
//
//     // ✅ Check-In Flow
//     if (isCheckIn) {
//       ref.read(checkInTimeProvider.notifier).state = currentTime;
//       notifier.setCheckInTime(currentTime);
//
//       // Assuming empAttendanceId comes from storage or API (ensure it's valid)
//       final int empAttendanceId = await getEmpAttendanceId();  // Fetch the ID from a valid source
//       ref.read(empAttendanceIdProvider.notifier).state = empAttendanceId;
//
//       print('✅ Check-In Completed at $formattedTime');
//       AppLogger.info('✅ Check-In Completed at $formattedTime');
//       AppLogger.info('💼 EmpAttendanceId for Check-In: $empAttendanceId');  // Log the empAttendanceId
//
//       final imagePath = await CameraHelper().openCamera(context, ref);
//       print('📸 Check-In: Image path retrieved: $imagePath');
//       AppLogger.info('📸 Check-In: Image path retrieved: $imagePath');
//
//       if (imagePath != null && imagePath.isNotEmpty) {
//         ref.read(checkInImagePathProvider.notifier).state = imagePath;
//
//         print('📸 Check-In Image Captured at: $imagePath');
//         AppLogger.info("📸 Check-In Image Captured at: $imagePath");
//
//         final checkInTime = ref.read(checkInTimeProvider);
//         AppLogger.info("🕒 Check-In Time Logged: $checkInTime");
//
//         final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//         final location = await CameraHelper().fetchLocation();
//
//         GlobalLoader.show(context);
//
//         await CameraHelper.uploadImage(
//           context,
//           imagePath,
//           "IN",
//           position.latitude,
//           position.longitude,
//           location,
//           checkInTime,
//           null,
//           empAttendanceId,
//         );
//
//         GlobalLoader.hide();
//
//         // Allow swipe after image is successfully captured
//         setState(() {
//           canSwipe = true;  // Enable swipe for check-out
//         });
//
//       } else {
//         print("❌ Error: No image captured for Check-In.");
//         AppLogger.error("❌ No image captured for Check-In.");
//         setState(() {
//           canSwipe = false;  // Disable swipe if no image is captured
//         });
//         return; // Early exit if image capture failed
//       }
//     }
//
//     // ✅ Check-Out Flow
//     else {
//       final int? empAttendanceId = ref.read(empAttendanceIdProvider);
//
//       if (empAttendanceId == null || empAttendanceId == 0) {
//         print("❌ Error: No valid empAttendanceId found for Check-Out.");
//         AppLogger.error("❌ No valid empAttendanceId found for Check-Out.");
//         return;
//       }
//
//       AppLogger.info('💼 EmpAttendanceId for Check-Out: $empAttendanceId');  // Log the empAttendanceId
//
//       final checkOutTime = currentTime;
//       notifier.setCheckOutTime(checkOutTime);
//
//       print('✅ Check-Out in checkInTime $formattedTime');
//
//       print('✅ Check-Out Completed at $formattedTime');
//       AppLogger.info('✅ Check-Out Completed at $formattedTime');
//
//       // ✅ Await the camera and directly get the imagePath
//       final imagePath = await CameraHelper().openCamera(context, ref);
//
//       print('📸 Check-Out: Image path retrieved: $imagePath');
//       AppLogger.info('📸 Check-Out: Image path retrieved: $imagePath');
//
//       if (imagePath != null && imagePath.isNotEmpty) {
//         ref.read(checkOutImagePathProvider.notifier).state = imagePath;
//
//         print('📸 Check-Out Image Captured at: $imagePath');
//         AppLogger.info("📸 Check-Out Image Captured at: $imagePath");
//
//         final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//         final location = await CameraHelper().fetchLocation();
//
//         GlobalLoader.show(context);
//
//         // Pass the current date and check-out time
//         await CameraHelper.uploadImage(
//           context,
//           imagePath,
//           "OUT",
//           position.latitude,
//           position.longitude,
//           location,
//           null,
//           checkOutTime,  // Pass check-out time
//           empAttendanceId,
//         );
//
//         GlobalLoader.hide();
//
//         // Allow swipe after image is successfully captured
//         setState(() {
//           canSwipe = true;  // Enable swipe for next action
//         });
//
//       } else {
//         print("❌ Error: No image captured for Check-Out.");
//         AppLogger.error("❌ No image captured for Check-Out.");
//         setState(() {
//           canSwipe = false;  // Disable swipe if no image is captured
//         });
//         return; // Early exit if image capture failed
//       }
//     }
//
//     // Toggle for next slide action
//     setState(() {
//       isCheckIn = !isCheckIn;
//     });
//   }
//
//
//   // Future<void> handleSlideSubmit() async {
//   //   final currentTime = DateTime.now();
//   //   final formattedTime = DateFormat('HH:mm:ss').format(currentTime);
//   //
//   //   // Toggle check-in/check-out animation state
//   //   setState(() {
//   //     isFinished = !isFinished;
//   //   });
//   //
//   //   final notifier = ref.read(checkInOutProvider.notifier);
//   //
//   //   // ✅ Check-In Flow
//   //   if (isCheckIn) {
//   //     ref.read(checkInTimeProvider.notifier).state = currentTime;
//   //     notifier.setCheckInTime(currentTime);
//   //
//   //     // Assuming empAttendanceId comes from storage or API (ensure it's valid)
//   //     final int empAttendanceId = await getEmpAttendanceId();  // Fetch the ID from a valid source
//   //     ref.read(empAttendanceIdProvider.notifier).state = empAttendanceId;
//   //
//   //     print('✅ Check-In Completed at $formattedTime');
//   //     AppLogger.info('✅ Check-In Completed at $formattedTime');
//   //     AppLogger.info('💼 EmpAttendanceId for Check-In: $empAttendanceId');  // Log the empAttendanceId
//   //
//   //     final imagePath = await CameraHelper().openCamera(context, ref);
//   //     print('📸 Check-In: Image path retrieved: $imagePath');
//   //     AppLogger.info('📸 Check-In: Image path retrieved: $imagePath');
//   //
//   //     if (imagePath != null && imagePath.isNotEmpty) {
//   //       ref.read(checkInImagePathProvider.notifier).state = imagePath;
//   //
//   //       print('📸 Check-In Image Captured at: $imagePath');
//   //       AppLogger.info("📸 Check-In Image Captured at: $imagePath");
//   //
//   //       final checkInTime = ref.read(checkInTimeProvider);
//   //       AppLogger.info("🕒 Check-In Time Logged: $checkInTime");
//   //
//   //       final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   //       final location = await CameraHelper().fetchLocation();
//   //
//   //       GlobalLoader.show(context);
//   //
//   //       await CameraHelper.uploadImage(
//   //         context,
//   //         imagePath,
//   //         "IN",
//   //         position.latitude,
//   //         position.longitude,
//   //         location,
//   //         checkInTime,
//   //         null,
//   //         empAttendanceId,
//   //       );
//   //
//   //       GlobalLoader.hide();
//   //
//   //       // Allow swipe after image is successfully captured
//   //       setState(() {
//   //         canSwipe = true;  // Enable swipe for check-out
//   //       });
//   //
//   //     } else {
//   //       print("❌ Error: No image captured for Check-In.");
//   //       AppLogger.error("❌ No image captured for Check-In.");
//   //       setState(() {
//   //         canSwipe = false;  // Disable swipe if no image is captured
//   //       });
//   //       return; // Early exit if image capture failed
//   //     }
//   //   }
//   //
//   //   // ✅ Check-Out Flow
//   //   else {
//   //     final int? empAttendanceId = ref.read(empAttendanceIdProvider);
//   //
//   //     if (empAttendanceId == null || empAttendanceId == 0) {
//   //       print("❌ Error: No valid empAttendanceId found for Check-Out.");
//   //       AppLogger.error("❌ No valid empAttendanceId found for Check-Out.");
//   //       return;
//   //     }
//   //
//   //     AppLogger.info('💼 EmpAttendanceId for Check-Out: $empAttendanceId');  // Log the empAttendanceId
//   //
//   //     final checkOutTime = currentTime;
//   //     notifier.setCheckOutTime(checkOutTime);
//   //
//   //     // final checkInTime = currentTime;
//   //     // notifier.setCheckOutTime(checkInTime);
//   //
//   //     print('✅ Check-Out in checkInTime $formattedTime');
//   //
//   //     print('✅ Check-Out Completed at $formattedTime');
//   //     AppLogger.info('✅ Check-Out Completed at $formattedTime');
//   //
//   //     // ✅ Await the camera and directly get the imagePath
//   //     final imagePath = await CameraHelper().openCamera(context, ref);
//   //
//   //     print('📸 Check-Out: Image path retrieved: $imagePath');
//   //     AppLogger.info('📸 Check-Out: Image path retrieved: $imagePath');
//   //
//   //     if (imagePath != null && imagePath.isNotEmpty) {
//   //       ref.read(checkOutImagePathProvider.notifier).state = imagePath;
//   //
//   //       print('📸 Check-Out Image Captured at: $imagePath');
//   //       AppLogger.info("📸 Check-Out Image Captured at: $imagePath");
//   //
//   //       final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   //       final location = await CameraHelper().fetchLocation();
//   //
//   //       GlobalLoader.show(context);
//   //
//   //       // Pass the current date and check-out time
//   //       await CameraHelper.uploadImage(
//   //         context,
//   //         imagePath,
//   //         "OUT",
//   //         position.latitude,
//   //         position.longitude,
//   //         location,
//   //         null,
//   //         checkOutTime,  // Pass check-out time
//   //         empAttendanceId,
//   //       );
//   //
//   //       GlobalLoader.hide();
//   //
//   //       // Allow swipe after image is successfully captured
//   //       setState(() {
//   //         canSwipe = true;  // Enable swipe for next action
//   //       });
//   //
//   //     } else {
//   //       print("❌ Error: No image captured for Check-Out.");
//   //       AppLogger.error("❌ No image captured for Check-Out.");
//   //       setState(() {
//   //         canSwipe = false;  // Disable swipe if no image is captured
//   //       });
//   //       return; // Early exit if image capture failed
//   //     }
//   //   }
//   //
//   //   // Toggle for next slide action
//   //   setState(() {
//   //     isCheckIn = !isCheckIn;
//   //   });
//   // }
//
//
//   // Future<void> handleSlideSubmit() async {
//   //   final currentTime = DateTime.now();
//   //   final formattedTime = DateFormat('HH:mm:ss').format(currentTime);
//   //
//   //   // Toggle check-in/check-out animation state
//   //   setState(() {
//   //     isFinished = !isFinished;
//   //   });
//   //
//   //   final notifier = ref.read(checkInOutProvider.notifier);
//   //
//   //   // ✅ Check-In Flow
//   //   if (isCheckIn) {
//   //     ref.read(checkInTimeProvider.notifier).state = currentTime;
//   //     notifier.setCheckInTime(currentTime);
//   //
//   //     // Assuming empAttendanceId comes from storage or API (ensure it's valid)
//   //     final int empAttendanceId = await getEmpAttendanceId();  // Fetch the ID from a valid source
//   //     ref.read(empAttendanceIdProvider.notifier).state = empAttendanceId;
//   //
//   //     print('✅ Check-In Completed at $formattedTime');
//   //     AppLogger.info('✅ Check-In Completed at $formattedTime');
//   //     AppLogger.info('💼 EmpAttendanceId for Check-In: $empAttendanceId');  // Log the empAttendanceId
//   //
//   //     final imagePath = await CameraHelper().openCamera(context, ref);
//   //     print('📸 Check-In: Image path retrieved: $imagePath');
//   //     AppLogger.info('📸 Check-In: Image path retrieved: $imagePath');
//   //
//   //     if (imagePath != null && imagePath.isNotEmpty) {
//   //       ref.read(checkInImagePathProvider.notifier).state = imagePath;
//   //
//   //       print('📸 Check-In Image Captured at: $imagePath');
//   //       AppLogger.info("📸 Check-In Image Captured at: $imagePath");
//   //
//   //       final checkInTime = ref.read(checkInTimeProvider);
//   //       AppLogger.info("🕒 Check-In Time Logged: $checkInTime");
//   //
//   //       final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   //       final location = await CameraHelper().fetchLocation();
//   //
//   //       await CameraHelper.uploadImage(
//   //         imagePath,
//   //         "IN",
//   //         position.latitude,
//   //         position.longitude,
//   //         location,
//   //         checkInTime,
//   //         null,
//   //         empAttendanceId,
//   //       );
//   //     } else {
//   //       print("❌ Error: No image captured for Check-In.");
//   //       AppLogger.error("❌ No image captured for Check-In.");
//   //     }
//   //   }
//   //
//   //   // ✅ Check-Out Flow
//   //   else {
//   //     final int? empAttendanceId = ref.read(empAttendanceIdProvider);
//   //
//   //     if (empAttendanceId == null || empAttendanceId == 0) {
//   //       print("❌ Error: No valid empAttendanceId found for Check-Out.");
//   //       AppLogger.error("❌ No valid empAttendanceId found for Check-Out.");
//   //       return;
//   //     }
//   //
//   //     AppLogger.info('💼 EmpAttendanceId for Check-Out: $empAttendanceId');  // Log the empAttendanceId
//   //
//   //     final checkOutTime = currentTime;
//   //     notifier.setCheckOutTime(checkOutTime);
//   //
//   //     print('✅ Check-Out Completed at $formattedTime');
//   //     AppLogger.info('✅ Check-Out Completed at $formattedTime');
//   //
//   //     // ✅ Await the camera and directly get the imagePath
//   //     final imagePath = await CameraHelper().openCamera(context, ref);
//   //
//   //     print('📸 Check-Out: Image path retrieved: $imagePath');
//   //     AppLogger.info('📸 Check-Out: Image path retrieved: $imagePath');
//   //
//   //     if (imagePath != null && imagePath.isNotEmpty) {
//   //       ref.read(checkOutImagePathProvider.notifier).state = imagePath;
//   //
//   //       print('📸 Check-Out Image Captured at: $imagePath');
//   //       AppLogger.info("📸 Check-Out Image Captured at: $imagePath");
//   //
//   //       final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   //       final location = await CameraHelper().fetchLocation();
//   //
//   //       // Pass the current date and check-out time
//   //       await CameraHelper.uploadImage(
//   //         imagePath,
//   //         "OUT",
//   //         position.latitude,
//   //         position.longitude,
//   //         location,
//   //         null,
//   //         checkOutTime,  // Pass check-out time
//   //         empAttendanceId,
//   //       );
//   //     } else {
//   //       print("❌ Error: No image captured for Check-Out.");
//   //       AppLogger.error("❌ No image captured for Check-Out.");
//   //     }
//   //   }
//   //
//   //   // Toggle for next slide action
//   //   setState(() {
//   //     isCheckIn = !isCheckIn;
//   //   });
//   // }
//
// // Example method to get empAttendanceId (replace with your actual logic)
//   Future<int> getEmpAttendanceId() async {
//     // Fetch the empAttendanceId from storage, API, or another source
//     // For example:
//     final storage = ref.read(flutterSecureStorageProvider);
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     final idString = await storage.read(key: 'empAttendanceId_$today');
//
//     if (idString != null) {
//       final id = int.tryParse(idString);
//       if (id != null) {
//         return id;
//       }
//     }
//
//     // Return a default or error value if ID is not found
//     return 0;
//   }
//
//
//
//
//
//
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10), // Rounded corners
//       child: Padding(
//         padding: const EdgeInsets.all(8.0), // Padding inside the container
//         child: SlideAction(
//           borderRadius: 10, // Rounded corners for the slider
//           innerColor: Color(0xffe1d6f2), // Color of the inner slider
//           outerColor: Color(0xff7339c8), // Transparent outer color for a clean look
//           reversed: isFinished,
//           sliderButtonIcon:SvgPicture.asset(
//             'assets/icons/attendance/user-tick.svg',
//             color: AppColors.primaryBlueFont, // Set the color here if needed
//             height: 24.0, // Adjust size as needed
//             width: 24.0, // Adjust size as needed
//           ),
//           textStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 16.sp, // Responsive font size
//           ),
//           sliderRotate: false,
//           onSubmit: handleSlideSubmit, // Trigger the function when the slide is finished
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Depending on the state, display different text and icons
//               isCheckIn
//                   ? Row(
//                 children: [
//                   Text(
//                     "Check In",
//                     style: TextStyle(
//                       color: Color(0xffb798e3),
//                       fontSize: 16.sp, // Responsive font size
//                     ),
//                   ),
//                   SizedBox(width: 8), // Space between text and icon
//                   Icon(Icons.keyboard_double_arrow_right, color: Colors.white),
//                 ],
//               )
//                   : Row(
//                 children: [
//                   Icon(Icons.keyboard_double_arrow_left, color: Colors.white),
//                   SizedBox(width: 8), // Space between icon and text
//                   Text(
//                     "Check Out",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16.sp, // Responsive font size
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkInTimeProvider = StateProvider<DateTime?>((ref) => null); // For check-in time

final checkOutTimeProvider = StateProvider<DateTime?>((ref) => null); // For check-out time



class CheckInButton extends ConsumerStatefulWidget {
  const CheckInButton({Key? key}) : super(key: key);

  @override
  _CheckInButtonState createState() => _CheckInButtonState();
}

class _CheckInButtonState extends ConsumerState<CheckInButton> {
  bool isFinished = false;
  bool isCheckInPhase = true;
  bool canSwipe = false;
  bool isAttendanceFilled = false; // To track if both check-in and check-out times are filled.

  @override
  void initState() {
    super.initState();
    _initializeAttendanceStatus();
  }

  // Define the _getCheckInStatus method
  Future<bool> _getCheckInStatus() async {
    final storage = ref.read(flutterSecureStorageProvider);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final key = 'attendanceStatus_$today';

    AppLogger.info('🔍 Checking storage for key: $key');
    final status = await storage.read(key: key);

    if (status != null) {
      AppLogger.info('📦 Retrieved phase from storage: $status');
      return status == 'checkIn';
    }

    AppLogger.info('📦 No stored phase found. Defaulting to Check-In.');
    return true;
  }

  // Define the _getEmpAttendanceId method
  Future<int> _getEmpAttendanceId() async {
    final storage = ref.read(flutterSecureStorageProvider);
    final idString = await storage.read(key: 'empAttendanceId');

    if (idString != null) {
      final id = int.tryParse(idString) ?? 0;
      AppLogger.info('🆔 Fetched EmpAttendanceId from storage: $id');
      return id;
    }

    AppLogger.warn('❌ empAttendanceId not found in storage');
    return 0;
  }

  Future<void> _initializeAttendanceStatus() async {
    AppLogger.info('🚀 Initializing Check-In/Check-Out phase from API or storage...');
    try {
      final userInCheckInPhase = await _getCheckInStatus();
      AppLogger.info('🔁 User is currently in: ${userInCheckInPhase ? "Check-In" : "Check-Out"} phase');
      setState(() {
        isCheckInPhase = userInCheckInPhase;
      });

      // Check if both check-in and check-out are filled in the API response or local storage.
      final checkInTime = ref.read(checkInTimeProvider);
      final checkOutTime = ref.read(checkOutTimeProvider);

      if (checkInTime != null && checkOutTime != null) {
        setState(() {
          isAttendanceFilled = true; // Both check-in and check-out are filled.
        });
      } else {
        setState(() {
          isAttendanceFilled = false; // One or both of check-in or check-out are missing.
        });
      }
    } catch (e) {
      AppLogger.error('❌ Failed to fetch attendance phase: $e');
    }
  }


  Future<void> _handleAttendanceSlide() async {
    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm:ss').format(now);
    final notifier = ref.read(checkInOutProvider.notifier);

    setState(() => isFinished = !isFinished);

    if (isCheckInPhase) {
      AppLogger.info('🚪 Starting Check-In process...');
      ref.read(checkInTimeProvider.notifier).state = now;
      notifier.setCheckInTime(now);

      final empId = await _getEmpAttendanceId();
      ref.read(empAttendanceIdProvider.notifier).state = empId;

      AppLogger.info('⏱️ Check-In Time: $formattedTime | 🆔 EmpId: $empId');

      final imagePath = await CameraHelper().openCamera(context, ref);
      if (imagePath?.isNotEmpty ?? false) {
        AppLogger.info('📸 Check-In image captured: $imagePath');
        ref.read(checkInImagePathProvider.notifier).state = imagePath!;

        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        final location = await CameraHelper().fetchLocation();

        GlobalLoader.show(context);
        await CameraHelper.uploadImage(
          context, imagePath, "IN", position.latitude, position.longitude, location,
          now, null, empId,
        );
        GlobalLoader.hide();

        AppLogger.info('✅ Check-In upload complete!');
        setState(() => canSwipe = true);
      } else {
        AppLogger.error('❌ No image taken during Check-In.');
        setState(() => canSwipe = false);
        return;
      }

    } else {


      AppLogger.info('🚪 Starting Check-Out process...');

      final empId = ref.read(empAttendanceIdProvider);
      if (empId == null || empId == 0) {
        AppLogger.error('❌ Invalid empAttendanceId for Check-Out.');
        return;
      }

      notifier.setCheckOutTime(now);
      AppLogger.info('⏱️ Check-Out Time: $formattedTime | 🆔 EmpId: $empId');

      final imagePath = await CameraHelper().openCamera(context, ref);
      if (imagePath?.isNotEmpty ?? false) {
        AppLogger.info('📸 Check-Out image captured: $imagePath');
        ref.read(checkOutImagePathProvider.notifier).state = imagePath!;

        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        final location = await CameraHelper().fetchLocation();

        GlobalLoader.show(context);
        await CameraHelper.uploadImage(
          context, imagePath, "OUT", position.latitude, position.longitude, location,
          null, now, empId,
        );
        GlobalLoader.hide();

        AppLogger.info('✅ Check-Out upload complete!');
        setState(() => canSwipe = true);
      } else {
        AppLogger.error('❌ No image taken during Check-Out.');
        setState(() => canSwipe = false);
        return;
      }

    }

    // Toggle phase after successful action
    setState(() {
      isCheckInPhase = !isCheckInPhase;
    });

    final storage = ref.read(flutterSecureStorageProvider);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final key = 'attendanceStatus_$today';
    await storage.write(key: key, value: isCheckInPhase ? 'checkIn' : 'checkOut');

    AppLogger.info('🔄 Phase toggled to: ${isCheckInPhase ? "Check-In" : "Check-Out"} and saved in secure storage');
  }

  @override
  Widget build(BuildContext context) {
    if (isAttendanceFilled) {
      // If both Check-In and Check-Out are filled, display attendance info.
      AppLogger.info('📊 Attendance details are filled. Displaying attendance info.');

      return Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.blueAccent,
          child: Text(
            'Attendance Details Filled!',
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ),
      );
    } else {
      // If not both Check-In and Check-Out are filled, display the SlideAction widget.
      AppLogger.info('📅 Attendance details are not fully filled. Displaying SlideAction widget.');

      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SlideAction(
            key: ValueKey(isCheckInPhase),
            borderRadius: 10,
            innerColor: const Color(0xffe1d6f2),
            outerColor: const Color(0xff7339c8),
            reversed: !isCheckInPhase, // ⬅️ Check-In: L ➡ R, Check-Out: R ➡ L
            sliderButtonIcon: SvgPicture.asset(
              'assets/icons/attendance/user-tick.svg',
              color: AppColors.primaryBlueFont,
              height: 24.0,
              width: 24.0,
            ),
            textStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
            sliderRotate: false,
            onSubmit: () {
              AppLogger.info('🚪 SlideAction submitted, handling attendance slide...');
              _handleAttendanceSlide();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: isCheckInPhase
                  ? [
                Text("Check In", style: TextStyle(color: const Color(0xffb798e3), fontSize: 16.sp)),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_double_arrow_right, color: Colors.white),
              ]
                  : [
                const Icon(Icons.keyboard_double_arrow_left, color: Colors.white),
                const SizedBox(width: 8),
                Text("Check Out", style: TextStyle(color: Colors.white, fontSize: 16.sp)),
              ],
            ),
          ),
        ),
      );
    }
  }
}



