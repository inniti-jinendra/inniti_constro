// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
//
// import '../../core/components/appbar_header.dart';
// import '../../core/constants/app_colors.dart';
// import '../../core/models/attendance_only/self_attendance_data.dart';
// import '../../core/network/logger.dart';
// import '../../core/services/attendance_only/attendance_api_service.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/global_loding/global_loader.dart';
// import '../../widgets/helper/camera_helper_service.dart';
// import 'attendance_header_card.dart';
//
// import 'check_in_check_out_provider.dart';
//
// import 'checkin_checkout_card.dart';
//
// final checkInTimeProvider = StateProvider<DateTime?>((ref) => null); // For check-in time
//
// final checkOutTimeProvider = StateProvider<DateTime?>((ref) => null); // For check-out time
//
//
// Future<void> restoreEmpAttendanceIdForToday(WidgetRef ref) async {
//   final storage = ref.read(flutterSecureStorageProvider);
//   final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   final idString = await storage.read(key: 'empAttendanceId_$today');
//
//   if (idString != null) {
//     final id = int.tryParse(idString);
//     if (id != null) {
//       ref.read(empAttendanceIdProvider.notifier).state = id;
//       AppLogger.info(
//         "📦 Restored empAttendanceId from storage: $id for $today",
//       );
//     }
//   }
// }
//
// final selfAttendanceDataProvider = StateProvider<List<SelfAttendanceData>>(
//   (ref) => [],
// );
//
// class SelfAttendanceScreen extends ConsumerStatefulWidget {
//   const SelfAttendanceScreen({super.key});
//
//   @override
//   ConsumerState<SelfAttendanceScreen> createState() =>
//       _SelfAttendanceScreenState();
// }
//
// class _SelfAttendanceScreenState extends ConsumerState<SelfAttendanceScreen> {
//   bool _isLoading = true;
//   String? _error;
//   bool isFinished = false;
//   bool isCheckInPhase = true;
//   bool canSwipe = false;
//   bool isAttendanceFilled = false; // To track if both check-in and check-out times are filled.
//
//
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   Future<void> _init() async {
//     AppLogger.info("🔄 Initializing attendance_only screen...");
//     bool hasPermission = await _checkAndRequestLocationPermission();
//
//     if (hasPermission) {
//       AppLogger.info(
//           "✅ Location permission confirmed. Fetching attendance_only data...");
//       //_fetchAttendanceData(); // Only call API if permission is granted
//     } else {
//       AppLogger.warn("❌ Location permission denied. Showing dialog...");
//       _showLocationPermissionDialog();
//     }
//   }
//
//   /// Checks location permission and requests if not granted
//   Future<bool> _checkAndRequestLocationPermission() async {
//     AppLogger.info("🔍 Checking location permission...");
//
//     LocationPermission permission = await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.denied) {
//       AppLogger.warn("📛 Permission denied. Requesting permission...");
//       permission = await Geolocator.requestPermission();
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       AppLogger.error(
//           "🚫 Location permission permanently denied (deniedForever).");
//       return false;
//     }
//
//     bool granted = permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse;
//
//     AppLogger.info(granted
//         ? "✅ Location permission granted."
//         : "❌ Location permission still not granted.");
//
//     return granted;
//   }
//
//   /// Shows a dialog and forces user to enable permission via settings
//   void _showLocationPermissionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("📍 Location Permission Required"),
//         content: Text(
//           "Location access is needed to mark attendance_only. Please allow it in app settings.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               AppLogger.info("🔁 Opening app settings for permission...");
//               Navigator.pop(context);
//               Geolocator.openAppSettings(); // 🚀 Open app settings
//             },
//             child: Text("Open Settings"),
//           ),
//           TextButton(
//             onPressed: () {
//               AppLogger.warn("🚫 User cancelled location permission dialog.");
//               Navigator.pop(context);
//             },
//             child: Text("Cancel"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _fetchAttendanceData();
//   // }
//
//   // Future<void> _fetchAttendanceData() async {
//   //   AppLogger.info("📡 Initiating fetch of self-attendance_only data...");
//   //   setState(() {
//   //     _isLoading = true;
//   //   });
//   //
//   //   try {
//   //     final data = await AttendanceApiService.fetchSelfAttendanceData();
//   //     AppLogger.info(
//   //         "✅ Self-attendance_only data fetched successfully. Count: ${data.length}");
//   //
//   //     // Ensure data is not empty
//   //     if (data.isNotEmpty) {
//   //       // Access the first item in the list
//   //       final firstAttendanceRecord = data.first;
//   //       AppLogger.info("📦 First attendance_only record: $firstAttendanceRecord");
//   //
//   //       // Log specific fields from the first attendance_only record
//   //       AppLogger.info(
//   //           "🔍 First attendance_only record - empAttendanceId: ${firstAttendanceRecord.empAttendanceId}");
//   //       AppLogger.info(
//   //           "🔍 First attendance_only record - inTime: ${firstAttendanceRecord.inTime}");
//   //       AppLogger.info(
//   //           "🔍 First attendance_only record - outTime: ${firstAttendanceRecord.outTime}");
//   //
//   //       // Store and update the empAttendanceId for today if it's valid
//   //       final empAttendanceIdString = firstAttendanceRecord.empAttendanceId;
//   //       AppLogger.info(
//   //           "🔍 Extracted empAttendanceId (string): $empAttendanceIdString");
//   //
//   //       final empAttendanceId = int.tryParse(empAttendanceIdString);
//   //       if (empAttendanceId != null) {
//   //         final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   //         AppLogger.info("📅 Today's date for storage key: $today");
//   //
//   //         final storage = ref.read(flutterSecureStorageProvider);
//   //
//   //         // Store the empAttendanceId for today
//   //         await storage.write(
//   //           key: 'empAttendanceId_$today',
//   //           value: empAttendanceId.toString(),
//   //         );
//   //
//   //         AppLogger.info(
//   //           "💾 Stored empAttendanceId: $empAttendanceId under key: empAttendanceId_$today",
//   //         );
//   //
//   //         // Update provider with empAttendanceId
//   //         ref.read(empAttendanceIdProvider.notifier).state = empAttendanceId;
//   //         AppLogger.info(
//   //             "🟢 Provider updated with empAttendanceId: $empAttendanceId");
//   //       } else {
//   //         _error = "❌ Invalid empAttendanceId format: $empAttendanceIdString";
//   //         AppLogger.error(_error!);
//   //       }
//   //
//   //       // Update the selfAttendanceDataProvider with the fetched data
//   //       ref.read(selfAttendanceDataProvider.notifier).state = data;
//   //     } else {
//   //       AppLogger.warn("⚠️ Attendance data is empty. No records found.");
//   //     }
//   //   } catch (e) {
//   //     _error = e.toString();
//   //     AppLogger.error(
//   //         "❌ Exception occurred while fetching attendance_only data: $_error");
//   //   } finally {
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //     AppLogger.info(
//   //         "📴 Attendance data fetch completed. isLoading set to false.");
//   //   }
//   // }
//
//   Future<void> _refreshAttendanceData() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });
//
//     try {
//       final data = await AttendanceApiService.fetchSelfAttendanceData();
//       AppLogger.info(
//           "✅ Self-attendance_only data fetched (refresh). Count: ${data.length}");
//
//       // ✅ Set the provider so the UI updates
//       ref.read(selfAttendanceDataProvider.notifier).state = data;
//
//       // ✅ Update empAttendanceId if applicable
//       if (data.isNotEmpty) {
//         final firstRecord = data.first;
//         final empAttendanceIdString = firstRecord.empAttendanceId;
//         final empAttendanceId = int.tryParse(empAttendanceIdString);
//         if (empAttendanceId != null) {
//           final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//           final storage = ref.read(flutterSecureStorageProvider);
//           await storage.write(
//             key: 'empAttendanceId_$today',
//             value: empAttendanceId.toString(),
//           );
//           ref.read(empAttendanceIdProvider.notifier).state = empAttendanceId;
//         }
//       }
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//       });
//       AppLogger.error("❌ Refresh error: $_error");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//       AppLogger.info("🔄 Refresh complete.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final attendanceData = ref.watch(selfAttendanceDataProvider);
//     final firstRecord = attendanceData.isNotEmpty ? attendanceData.first : null;
//
//     final empAttendanceId = firstRecord?.empAttendanceId;
//     final inTime = firstRecord?.inTime;
//     final outTime = firstRecord?.outTime;
//
//     AppLogger.info("🕒 inTime: $inTime");
//     AppLogger.info("🕒 outTime: $outTime");
//
//     final shouldShowCheckInCheckOutCard =
//         (empAttendanceId != null && (inTime == null || outTime == null)) ||
//             (inTime == null && outTime == null);
//
//     AppLogger.info(
//         "🧾 Should show CheckInCheckOutCard: $shouldShowCheckInCheckOutCard");
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             // Navigator.pop(context);
//             Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
//           },
//           icon: Icon(Icons.chevron_left, size: 30),
//           color: AppColors.primaryBlue,
//         ),
//         title: AppbarHeader(
//           headerName: 'Self Attendance',
//           projectName: '',
//           //projectName: 'Ganesh Gloary 11',
//         ),
//         backgroundColor: AppColors.primaryWhitebg,
//       ),
//       //backgroundColor: AppColors.white,
//       body: RefreshIndicator(
//         onRefresh: _refreshAttendanceData,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.w),
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               SizedBox(height: 40.h),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => _handleAttendance(isCheckIn: true),
//                     child: const Text("Check-IN"),
//                   ),
//                   shouldShowCheckInCheckOutCard ? ElevatedButton(
//                     onPressed: () => _handleAttendance(isCheckIn: false),
//                     child: const Text("Check-OUT"),
//                   ) : Container(),
//                 ],
//               ),
//
//
//
//               //if (shouldShowCheckInCheckOutCard) const AttendanceHeaderCard(),
//               SizedBox(height: 16.h),
//               AttendanceHeaderCard(),
//               // const CheckInButton(),
//               SizedBox(height: 8.h),
//               // const LocationDisplay(),
//               // SizedBox(height: 8.h),
//               const CheckInCheckOutCard(),
//               SizedBox(height: 16.h),
//               Align(
//                 alignment: Alignment.centerLeft, // Aligns to the left
//                 child: Text(
//                   "Current Attendance",
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//                 ),
//               ),
//
//               SizedBox(height: 8.h),
//               // if (totalAttendanceCount !=
//               //     null) // Show total attendance_only count if available
//               //   Padding(
//               //     padding: EdgeInsets.only(bottom: 8.h),
//               //     child: Text(
//               //       'Total Attendance Count: $totalAttendanceCount',
//               //       // Display count here
//               //       style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//               //     ),
//               //   ),
//
//               if (_isLoading)
//                 const CircularProgressIndicator()
//               else if (_error != null)
//                 Text("Error: $_error")
//               else if (attendanceData.isEmpty)
//                 const Text("No attendance_only data available.")
//               else
//                 AttendanceSummaryCard(
//                   attendanceData: attendanceData.first,
//                   totalAttendanceCount: attendanceData.length,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _handleAttendance({required bool isCheckIn}) async {
//     final now = DateTime.now();
//     final formattedTime = DateFormat('HH:mm:ss').format(now);
//     final notifier = ref.read(checkInOutProvider.notifier);
//
//     setState(() => isFinished = !isFinished);
//
//     if (isCheckIn) {
//       AppLogger.info('🚪 Starting Check-In process...');
//       ref.read(checkInTimeProvider.notifier).state = now;
//       notifier.setCheckInTime(now);
//
//       final empId = await _getEmpAttendanceId();
//       ref.read(empAttendanceIdProvider.notifier).state = empId;
//
//       AppLogger.info('⏱️ Check-In Time: $formattedTime | 🆔 EmpId: $empId');
//
//       final imagePath = await CameraHelper().openCamera(context, ref);
//       if (imagePath?.isNotEmpty ?? false) {
//         AppLogger.info('📸 Check-In image captured: $imagePath');
//         ref.read(checkInImagePathProvider.notifier).state = imagePath!;
//
//         final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//         final location = await CameraHelper().fetchLocation();
//
//         GlobalLoader.show(context);
//         await CameraHelper.uploadImage(
//           context, imagePath, "IN", position.latitude, position.longitude, location,
//           now, null, empId,
//         );
//         GlobalLoader.hide();
//
//         AppLogger.info('✅ Check-In upload complete!');
//         setState(() => canSwipe = true);
//       } else {
//         AppLogger.error('❌ No image taken during Check-In.');
//         setState(() => canSwipe = false);
//         return;
//       }
//     } else {
//       AppLogger.info('🚪 Starting Check-Out process...');
//
//       final empId = ref.read(empAttendanceIdProvider);
//       if (empId == null || empId == 0) {
//         AppLogger.error('❌ Invalid empAttendanceId for Check-Out.');
//         return;
//       }
//
//       notifier.setCheckOutTime(now);
//       AppLogger.info('⏱️ Check-Out Time: $formattedTime | 🆔 EmpId: $empId');
//
//       final imagePath = await CameraHelper().openCamera(context, ref);
//       if (imagePath?.isNotEmpty ?? false) {
//         AppLogger.info('📸 Check-Out image captured: $imagePath');
//         ref.read(checkOutImagePathProvider.notifier).state = imagePath!;
//
//         final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//         final location = await CameraHelper().fetchLocation();
//
//         GlobalLoader.show(context);
//         await CameraHelper.uploadImage(
//           context, imagePath, "OUT", position.latitude, position.longitude, location,
//           null, now, empId,
//         );
//         GlobalLoader.hide();
//
//         AppLogger.info('✅ Check-Out upload complete!');
//         setState(() => canSwipe = true);
//       } else {
//         AppLogger.error('❌ No image taken during Check-Out.');
//         setState(() => canSwipe = false);
//         return;
//       }
//     }
//
//     // Save phase in secure storage (optional)
//     final storage = ref.read(flutterSecureStorageProvider);
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     final key = 'attendanceStatus_$today';
//     await storage.write(key: key, value: isCheckIn ? 'checkIn' : 'checkOut');
//
//     AppLogger.info('🔄 Attendance ${isCheckIn ? "Check-In" : "Check-Out"} saved in secure storage');
//   }
//
//   // Define the _getEmpAttendanceId method
//   Future<int> _getEmpAttendanceId() async {
//     final storage = ref.read(flutterSecureStorageProvider);
//     final idString = await storage.read(key: 'empAttendanceId');
//
//     if (idString != null) {
//       final id = int.tryParse(idString) ?? 0;
//       AppLogger.info('🆔 Fetched EmpAttendanceId from storage: $id');
//       return id;
//     }
//
//     AppLogger.warn('❌ empAttendanceId not found in storage');
//     return 0;
//   }
//
//
//
// }
//
// class AttendanceSummaryCard extends StatelessWidget {
//   final SelfAttendanceData? attendanceData;
//   final int? totalAttendanceCount; // Added total attendance_only count
//
//   const AttendanceSummaryCard({
//     super.key,
//     required this.attendanceData,
//     this.totalAttendanceCount,
//   });
//
//   String formatDateTime(DateTime? dateTime, {String pattern = 'dd/MM/yyyy'}) {
//     if (dateTime == null) return '--';
//     return DateFormat(pattern).format(dateTime);
//   }
//
//   String formatDuration(Duration? duration) {
//     if (duration == null) return '--';
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes.remainder(60);
//     return "$hours Hrs. $minutes Min";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // If attendance_only data is null, show a loading indicator
//     if (attendanceData == null) {
//       return Center(
//         child:
//             CircularProgressIndicator(), // A loader while data is being fetched
//       );
//     }
//
//     // Logging for debug (optional)
//     debugPrint('📊 AttendanceID: ${attendanceData!.empAttendanceId}');
//     debugPrint('📊 Attendance Data: ${attendanceData.toString()}');
//     debugPrint('📊 In Time: ${attendanceData?.inTime}');
//     debugPrint('📊 Out Time: ${attendanceData?.outTime}');
//     debugPrint('📊 Total Hours: ${attendanceData?.presentHours}');
//     debugPrint('📊 In Document Path: ${attendanceData?.inDocumentPath}');
//     debugPrint('📊 Out Document Path: ${attendanceData?.outDocumentPath}');
//
//     // return Column(
//     //   crossAxisAlignment: CrossAxisAlignment.start,
//     //   children: [
//     //     Text(
//     //       "Current Attendance",
//     //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//     //     ),
//     //     SizedBox(height: 8.h),
//     //     if (totalAttendanceCount != null) // Show total attendance_only count if available
//     //       Padding(
//     //         padding: EdgeInsets.only(bottom: 8.h),
//     //         child: Text(
//     //           'Total Attendance Count: $totalAttendanceCount', // Display count here
//     //           style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//     //         ),
//     //       ),
//     //     Card(
//     //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
//     //       child: Padding(
//     //         padding: EdgeInsets.all(12.w),
//     //         child: Column(
//     //           children: [
//     //             // Header Row with Date and Status Chip
//     //             Row(
//     //               children: [
//     //                 Icon(Icons.calendar_today, color: Colors.purple, size: 18.sp),
//     //                 SizedBox(width: 8.w),
//     //                 Text(
//     //                   attendanceData!.inTime != null
//     //                       ? formatDateTime(attendanceData!.inTime, pattern: 'dd/MM/yyyy')
//     //                       : '--',
//     //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
//     //                 ),
//     //                 const Spacer(),
//     //                 Chip(
//     //                   label: Text(
//     //                     attendanceData!.outTime == null ? "Checked In" : "Checked Out",
//     //                     style: TextStyle(color: Colors.purple, fontSize: 12.sp),
//     //                   ),
//     //                   backgroundColor: const Color(0xFFEDE7F6),
//     //                   side: BorderSide.none,
//     //                 ),
//     //               ],
//     //             ),
//     //             Divider(height: 24.h),
//     //
//     //             // Time Details
//     //             Row(
//     //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //               children: [
//     //                 Text(
//     //                   "In Time\n${formatDateTime(attendanceData!.inTime, pattern: 'HH:mm')}",
//     //                   textAlign: TextAlign.center,
//     //                   style: TextStyle(fontSize: 12.sp),
//     //                 ),
//     //                 Text(
//     //                   "Out Time\n${formatDateTime(attendanceData!.outTime, pattern: 'HH:mm')}",
//     //                   textAlign: TextAlign.center,
//     //                   style: TextStyle(fontSize: 12.sp),
//     //                 ),
//     //                 Text(
//     //                   "Total Hrs.\n${formatDuration(attendanceData!.presentHours)}",
//     //                   textAlign: TextAlign.center,
//     //                   style: TextStyle(fontSize: 12.sp),
//     //                 ),
//     //               ],
//     //             ),
//     //
//     //             // Photos if available
//     //             if ((attendanceData!.inDocumentPath?.isNotEmpty ?? false) ||
//     //                 (attendanceData!.outDocumentPath?.isNotEmpty ?? false))
//     //               Padding(
//     //                 padding: EdgeInsets.only(top: 16.h),
//     //                 child: Row(
//     //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //                   children: [
//     //                     if (attendanceData!.inDocumentPath?.isNotEmpty ?? false)
//     //                       Column(
//     //                         children: [
//     //                           Text("In Photo", style: TextStyle(fontSize: 10.sp)),
//     //                           SizedBox(height: 4.h),
//     //                           ClipRRect(
//     //                             borderRadius: BorderRadius.circular(8.r),
//     //                             child: Image.network(
//     //                               attendanceData!.inDocumentPath ?? '', // Default to empty string if null
//     //                               height: 50.h,
//     //                               width: 50.w,
//     //                               fit: BoxFit.cover,
//     //                               errorBuilder: (context, error, stackTrace) =>
//     //                               const Icon(Icons.broken_image, size: 40),
//     //                             ),
//     //                           ),
//     //                         ],
//     //                       ),
//     //                     if (attendanceData!.outDocumentPath?.isNotEmpty ?? false)
//     //                       Column(
//     //                         children: [
//     //                           Text("Out Photo", style: TextStyle(fontSize: 10.sp)),
//     //                           SizedBox(height: 4.h),
//     //                           ClipRRect(
//     //                             borderRadius: BorderRadius.circular(8.r),
//     //                             child: Image.network(
//     //                               attendanceData!.outDocumentPath ?? '', // Default to empty string if null
//     //                               height: 50.h,
//     //                               width: 50.w,
//     //                               fit: BoxFit.cover,
//     //                               errorBuilder: (context, error, stackTrace) =>
//     //                               const Icon(Icons.broken_image, size: 40),
//     //                             ),
//     //                           ),
//     //                         ],
//     //                       ),
//     //                   ],
//     //                 ),
//     //               ),
//     //           ],
//     //         ),
//     //       ),
//     //     ),
//     //   ],
//     // );
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white, // Set the background color (optional)
//         borderRadius: BorderRadius.circular(
//           16,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.09), // very subtle shadow
//             blurRadius: 6,
//             offset: Offset(0, 2), // downwards shadow
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white, // Set the background color (optional)
//               borderRadius: BorderRadius.circular(
//                 14,
//               ), // Set the rounded corners with 16 radius
//             ),
//             padding: EdgeInsets.all(10),
//             // Optional: Adjust padding if necessary
//             child: Row(
//               children: [
//                 Icon(Icons.calendar_today, color: Colors.purple, size: 18.sp),
//                 SizedBox(width: 8.w),
//                 Text(
//                   attendanceData!.inTime != null
//                       ? formatDateTime(
//                           attendanceData!.inTime,
//                           pattern: 'dd/MM/yyyy',
//                         )
//                       : '--',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13.sp,
//                   ),
//                 ),
//                 const Spacer(),
//                 // Chip(
//                 //   label: Text(
//                 //     attendanceData!.outTime == null
//                 //         ? "Checked In"
//                 //         : "Checked Out",
//                 //     style: TextStyle(color: Colors.purple, fontSize: 12.sp),
//                 //   ),
//                 //   backgroundColor: const Color(0xFFEDE7F6),
//                 //   side: BorderSide.none,
//                 // ),
//               ],
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: AppColors.primaryWhitebg,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(12),
//                 bottomRight: Radius.circular(12),
//               ),
//             ),
//             padding: EdgeInsets.all(10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "In Time\n${formatDateTime(attendanceData!.inTime, pattern: 'HH:mm')}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 12.sp),
//                 ),
//                 // First gradient divider
//                 Container(
//                   width: 2,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Color(0xffe5dcf3),
//                         Color(0xff9b79d0),
//                         Color(0xffe5dcf3),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "Out Time\n${formatDateTime(attendanceData!.outTime, pattern: 'HH:mm')}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 12.sp),
//                 ),
//                 // Second gradient divider
//                 Container(
//                   width: 2,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Color(0xffe5dcf3),
//                         Color(0xff9b79d0),
//                         Color(0xffe5dcf3),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "Total Hrs.\n${formatDuration(attendanceData!.presentHours)}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 12.sp),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
