// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:inniti_constro/features/attendance/salf_attendance.dart';
// import 'package:intl/intl.dart';
// import '../../core/components/appbar_header.dart';
// import '../../core/components/network_image.dart';
//
// import '../../core/components/app_back_button.dart';
// import '../../core/components/zoomable_image_popup.dart';
// import '../../core/constants/constants.dart';
// import '../../core/models/attendance/emp_attendance.dart';
// import '../../core/models/attendance/self_attendance_data.dart';
// import '../../core/network/logger.dart';
// import '../../core/services/attendance/attendance_api_service.dart';
// import '../../core/utils/secure_storage_util.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/helper/camera_helper_service.dart';
// import 'SwipeToggleButton.dart';
//
// class SelfAttendance extends StatefulWidget {
//   const SelfAttendance({super.key});
//
//   @override
//   State<SelfAttendance> createState() => _SelfAttendanceState();
// }
//
// class _SelfAttendanceState extends State<SelfAttendance> {
//   //SelfAttendanceData? selfAttendanceData;
//   GoogleMapController? _controller;
//   LatLng _currentPosition = const LatLng(0.0, 0.0);
//   String _currentAddress = "Fetching location...";
//   String userName = "Loading...";
//
//   String _currentTime = '';
//   Timer? _timer;
//   File? _clickedImage;
//   String? _latitude;
//   String? _longitude;
//   String? _presentHours;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
//     _fetchSelfAttendanceData();
//     _fetchUserSessionData();
//     //_startLiveClock();
//     _getCurrentLocation();
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _fetchUserSessionData() async {
//     try {
//       String storedUserName = await SecureStorageUtil.readSecureData("UserName") ?? "Flutter Devloper";
//
//       setState(() {
//         userName = storedUserName;
//       });
//
//       AppLogger.info("Fetched username: $storedUserName");
//
//     } catch (e) {
//       AppLogger.error("Error retrieving session data");
//     }
//   }
//
//   Future<void> _fetchSelfAttendanceData() async {
//     try {
//       final data = await AttendanceApiService.fetchSelfAttendanceData();
//
//       if (data != null) {
//         setState(() {
//           //selfAttendanceData = data;
//         });
//
//         AppLogger.debug("✅ Attendance data fetched successfully.");
//         AppLogger.info("📄 Full Attendance Data:");
//         AppLogger.info("🆔 EmpAttendanceId: ${data.empAttendanceId}");
//         AppLogger.info("👤 EmployeeCode: ${data.employeeCode}");
//         AppLogger.info("👨‍💼 EmployeeName: ${data.employeeName}");
//         AppLogger.info("🏷️ Designation: ${data.designationName}");
//         AppLogger.info("🕓 InTime: ${data.inTime}");
//         AppLogger.info("🕔 OutTime: ${data.outTime}");
//         AppLogger.info("⏱️ PresentHours (raw): ${data.presentHours}");
//         AppLogger.info("🖼️ InDocumentPath: ${data.inDocumentPath}");
//         AppLogger.info("🖼️ OutDocumentPath: ${data.outDocumentPath}");
//       } else {
//         AppLogger.warn("⚠️ No attendance data received.");
//       }
//     } catch (e, stack) {
//       AppLogger.error("❌ Failed to fetch self attendance data: $e");
//       AppLogger.debug(stack.toString());
//     }
//   }
//
//
//
//   void _showImagePopup(BuildContext context, String imageUrl) {
//     AppLogger.debug("Showing image popup with URL: $imageUrl");
//     showDialog(
//       context: context,
//       builder: (context) {
//         return ZoomableImagePopup(imageUrl: imageUrl);
//       },
//     );
//   }
//
//   // void _startLiveClock() {
//   //   AppLogger.debug("Starting live clock...");
//   //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//   //     setState(() {
//   //       _currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
//   //       AppLogger.info("Current time updated: $_currentTime");
//   //
//   //       // Calculate Present Hours
//   //       if (selfAttendanceData?.inTime?.isNotEmpty == true) {
//   //         AppLogger.info("In-time detected: ${selfAttendanceData!.inTime}");
//   //
//   //         // Parse the inTime and ensure it has today's date
//   //         DateTime now = DateTime.now();
//   //         DateTime inTime =
//   //         DateFormat('hh:mm a').parse(selfAttendanceData!.inTime);
//   //         inTime = DateTime(
//   //             now.year, now.month, now.day, inTime.hour, inTime.minute);
//   //
//   //         Duration difference = now.difference(inTime);
//   //
//   //         // Format the difference as HH:mm:ss
//   //         _presentHours =
//   //         "${difference.inHours}h ${difference.inMinutes % 60}m ${difference.inSeconds % 60}s";
//   //         AppLogger.debug("Present hours: $_presentHours");
//   //       }
//   //     });
//   //   });
//   // }
//
//   // Get current location
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location service is enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return;
//     }
//
//     // Check for permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.deniedForever) {
//         return;
//       }
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     setState(() {
//       _latitude = position.latitude.toString();
//       _longitude = position.longitude.toString();
//       _currentPosition = LatLng(position.latitude, position.longitude);
//     });
//
//     _controller?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
//
//     _getAddressFromLatLng(position.latitude, position.longitude);
//   }
//
//   // Get address from coordinates
//   Future<void> _getAddressFromLatLng(double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//       Placemark place = placemarks[0];
//
//       setState(() {
//         _currentAddress =
//         "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//       });
//     } catch (e) {
//       _currentAddress = "Failed to get address: $e";
//     }
//   }
//
//   // Future<void> _takePicture() async {
//   //   final picker = ImagePicker();
//   //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
//   //
//   //   if (pickedFile != null) {
//   //     _clickedImage = File(pickedFile.path);
//   //     EmpAttendance empAttendance = EmpAttendance(
//   //      // empAttendanceID: selfAttendanceData?.empAttendanceId,
//   //       inOutTime_Base64Image: _clickedImage != null
//   //           ? base64Encode(_clickedImage!.readAsBytesSync())
//   //           : null,
//   //       inOutTime_Latitude: _latitude.toString(),
//   //       inOutTime_Longitude: _longitude.toString(),
//   //       inOutTime_GeoAddress: "",
//   //       selfAttendanceType: selfAttendanceData?.inTime == "" ? "IN" : "OUT",
//   //       projectID: 0, // Will be set in service
//   //       userID: 0, // Will be set in service
//   //       companyCode: "", // Will be set in service
//   //     );
//   //     String response = await AttendanceApiService.addAttendance(empAttendance);
//   //
//   //     if (response == "Success") {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //             content: Text(selfAttendanceData?.inTime == ""
//   //                 ? 'Check-in successfully!'
//   //                 : 'Check-Out successfully!')),
//   //       );
//   //       // Navigator.pop(context);
//   //     } else {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text('Failed to fill attendance.')),
//   //       );
//   //     }
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   leading: const AppBackButton(),
//       //   title: AppbarHeader(
//       //       headerName: 'Self Attendance', projectName: 'Ganesh Gloary 11'),
//       // ),
//       appBar: AppBar(
//         centerTitle: true,
//
//         leading: IconButton(
//           onPressed: () {
//            // Navigator.pop(context);
//             Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
//           },
//           icon: Icon(Icons.chevron_left, size: 30),
//           color: AppColors.primaryBlue,
//         ),
//         title: AppbarHeader(
//             headerName: 'Self Attendance', projectName: 'Ganesh Gloary 11'),
//         backgroundColor: AppColors.primaryWhitebg,
//       ),
//       backgroundColor: AppColors.cardColor,
//       // body: SingleChildScrollView(
//       //   child: Container(
//       //     margin: const EdgeInsets.all(AppDefaults.padding),
//       //     padding: const EdgeInsets.symmetric(
//       //       horizontal: AppDefaults.padding,
//       //       vertical: AppDefaults.padding * 2,
//       //     ),
//       //     decoration: BoxDecoration(
//       //       color: AppColors.scaffoldBackground,
//       //       borderRadius: AppDefaults.borderRadius,
//       //     ),
//       //     child: Column(
//       //       mainAxisSize: MainAxisSize.min,
//       //       children: [
//       //         SizedBox(
//       //           width: 100,
//       //           height: 100,
//       //           child: AspectRatio(
//       //             aspectRatio: 1 / 1,
//       //             child: NetworkImageWithLoader(selfAttendanceData != null
//       //                 ? selfAttendanceData!.inDocumentPath
//       //                 : ''),
//       //           ),
//       //         ),
//       //         Padding(
//       //           padding: const EdgeInsets.all(AppDefaults.padding),
//       //           child: Column(
//       //             children: [
//       //               Text(
//       //                userName ?? 'Loading...',
//       //                // selfAttendanceData?.employeeName ?? 'Loading...',
//       //                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//       //                   color: Colors.black,
//       //                   fontWeight: FontWeight.bold,
//       //                 ),
//       //               ),
//       //               const SizedBox(height: AppDefaults.padding_2),
//       //               Text(
//       //                 selfAttendanceData?.designationName ?? 'Loading...',
//       //                 style: Theme.of(context).textTheme.bodyMedium,
//       //               ),
//       //               const SizedBox(height: AppDefaults.padding_2),
//       //               Text(
//       //                 _currentTime,
//       //                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//       //                   color: Colors.black,
//       //                 ),
//       //               ),
//       //             ],
//       //           ),
//       //         ),
//       //         const SizedBox(height: AppDefaults.padding_3),
//       //         Stack(
//       //           children: [
//       //             Container(
//       //               decoration: BoxDecoration(
//       //                   boxShadow: AppDefaults.boxShadow,
//       //                   borderRadius: AppDefaults.borderRadius),
//       //               height: MediaQuery.of(context).size.height *
//       //                   0.25, // Set a fixed height
//       //               width: double.infinity,
//       //               child: GoogleMap(
//       //                 initialCameraPosition: CameraPosition(
//       //                   target: _currentPosition,
//       //                   zoom: 14,
//       //                 ),
//       //                 markers: {
//       //                   Marker(
//       //                     markerId: const MarkerId("currentLocation"),
//       //                     position: _currentPosition,
//       //                     infoWindow: const InfoWindow(title: "Your Location"),
//       //                   ),
//       //                 },
//       //                 myLocationEnabled: true,
//       //                 myLocationButtonEnabled: true,
//       //                 onMapCreated: (GoogleMapController controller) {
//       //                   _controller = controller;
//       //                 },
//       //               ),
//       //             ),
//       //             Positioned(
//       //               bottom: 10,
//       //               left: 20,
//       //               right: 20,
//       //               child: Container(
//       //                 padding: const EdgeInsets.all(12),
//       //                 decoration: BoxDecoration(
//       //                     color: Colors.white,
//       //                     borderRadius: BorderRadius.circular(8),
//       //                     boxShadow: AppDefaults.boxShadow),
//       //                 child: Text(
//       //                   _currentAddress,
//       //                   textAlign: TextAlign.center,
//       //                   style: const TextStyle(
//       //                       fontSize: 12, fontWeight: FontWeight.bold),
//       //                 ),
//       //               ),
//       //             ),
//       //           ],
//       //         ),
//       //         const SizedBox(height: AppDefaults.padding),
//       //         TextFormField(
//       //           maxLines: 2,
//       //           decoration: const InputDecoration(hintText: "Enter Remarks"),
//       //         ),
//       //         const SizedBox(height: AppDefaults.padding),
//       //         // SizedBox(
//       //         //   width: double.infinity,
//       //         //   child: ElevatedButton(
//       //         //     onPressed: () async {
//       //         //       _takePicture(); // Open the camera on button press
//       //         //     },
//       //         //     child: Text(selfAttendanceData?.inTime == ""
//       //         //         ? "Check-In"
//       //         //         : "Check-Out"),
//       //         //   ),
//       //         // ),
//       //         //SelfAttendanceScreen(),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//       //body: SelfAttendanceScreen(),
//       body: SelfAttendanceScreen(),
//     );
//   }
//
//   Widget _attendanceDetailWithImage(
//       String label, String value, String? imageUrl) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label, style: const TextStyle(fontSize: 13)),
//             Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         GestureDetector(
//           onTap: () => _showImagePopup(context, imageUrl!),
//           child: Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                   color: Theme.of(context)
//                       .dividerColor), // Use theme divider color
//               image: DecorationImage(
//                 image: NetworkImage(imageUrl ?? "~"),
//                 fit: BoxFit.cover,
//
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _attendanceDetail(String label, String? value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label, style: const TextStyle(fontSize: 13)),
//             Text(value ?? 'N/A',
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ],
//     );
//   }
// }
