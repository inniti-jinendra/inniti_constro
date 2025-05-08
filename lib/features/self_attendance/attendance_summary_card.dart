// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import '../../core/models/attendance_only/self_attendance_data.dart';
//
// class AttendanceSummaryCard extends StatelessWidget {
//   final SelfAttendanceData? attendanceData;
//   final int? totalAttendanceCount; // Added total attendance_only count
//
//   const AttendanceSummaryCard({super.key, required this.attendanceData, this.totalAttendanceCount});
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
//         child: CircularProgressIndicator(),  // A loader while data is being fetched
//       );
//     }
//
//     // Logging for debug (optional)
//     debugPrint('📊 Attendance Data: ${attendanceData.toString()}');
//     debugPrint('📊 In Time: ${attendanceData?.inTime}');
//     debugPrint('📊 Out Time: ${attendanceData?.outTime}');
//     debugPrint('📊 Total Hours: ${attendanceData?.presentHours}');
//     debugPrint('📊 In Document Path: ${attendanceData?.inDocumentPath}');
//     debugPrint('📊 Out Document Path: ${attendanceData?.outDocumentPath}');
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Current Attendance",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//         ),
//         SizedBox(height: 8.h),
//         Text(
//           " ${attendanceData!.empAttendanceId}",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//         ),
//         SizedBox(height: 8.h),
//         if (totalAttendanceCount != null) // Show total attendance_only count if available
//           Padding(
//             padding: EdgeInsets.only(bottom: 8.h),
//             child: Text(
//               'Total Attendance Count: $totalAttendanceCount', // Display count here
//               style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//             ),
//           ),
//         Card(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
//           child: Padding(
//             padding: EdgeInsets.all(12.w),
//             child: Column(
//               children: [
//                 // Header Row with Date and Status Chip
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, color: Colors.purple, size: 18.sp),
//                     SizedBox(width: 8.w),
//                     Text(
//                       attendanceData!.inTime != null
//                           ? formatDateTime(attendanceData!.inTime, pattern: 'dd/MM/yyyy')
//                           : '--',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
//                     ),
//                     const Spacer(),
//                     Chip(
//                       label: Text(
//                         attendanceData!.outTime == null ? "Checked In" : "Checked Out",
//                         style: TextStyle(color: Colors.purple, fontSize: 12.sp),
//                       ),
//                       backgroundColor: const Color(0xFFEDE7F6),
//                       side: BorderSide.none,
//                     ),
//                   ],
//                 ),
//                 Divider(height: 24.h),
//
//                 // Time Details
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "In Time\n${formatDateTime(attendanceData!.inTime, pattern: 'HH:mm')}",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12.sp),
//                     ),
//                     Text(
//                       "Out Time\n${formatDateTime(attendanceData!.outTime, pattern: 'HH:mm')}",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12.sp),
//                     ),
//                     Text(
//                       "Total Hrs.\n${formatDuration(attendanceData!.presentHours)}",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12.sp),
//                     ),
//                   ],
//                 ),
//
//                 // Photos if available
//                 if ((attendanceData!.inDocumentPath?.isNotEmpty ?? false) ||
//                     (attendanceData!.outDocumentPath?.isNotEmpty ?? false))
//                   Padding(
//                     padding: EdgeInsets.only(top: 16.h),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         if (attendanceData!.inDocumentPath?.isNotEmpty ?? false)
//                           Column(
//                             children: [
//                               Text("In Photo", style: TextStyle(fontSize: 10.sp)),
//                               SizedBox(height: 4.h),
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8.r),
//                                 child: Image.network(
//                                   attendanceData!.inDocumentPath ?? '', // Default to empty string if null
//                                   height: 50.h,
//                                   width: 50.w,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                   const Icon(Icons.broken_image, size: 40),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         if (attendanceData!.outDocumentPath?.isNotEmpty ?? false)
//                           Column(
//                             children: [
//                               Text("Out Photo", style: TextStyle(fontSize: 10.sp)),
//                               SizedBox(height: 4.h),
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8.r),
//                                 child: Image.network(
//                                   attendanceData!.outDocumentPath ?? '', // Default to empty string if null
//                                   height: 50.h,
//                                   width: 50.w,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                   const Icon(Icons.broken_image, size: 40),
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
