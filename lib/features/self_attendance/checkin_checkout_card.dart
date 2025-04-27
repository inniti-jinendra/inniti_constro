// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../core/constants/app_colors.dart';
// import '../../widgets/helper/camera_helper_service.dart';
// import 'check_in_check_out_provider.dart';
// import 'package:intl/intl.dart';
//
// class CheckInCheckOutCard extends ConsumerWidget {
//   const CheckInCheckOutCard({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final checkInOutState = ref.watch(checkInOutProvider);
//     final checkInImagePath = ref.watch(checkInImagePathProvider);
//     final checkOutImagePath = ref.watch(checkOutImagePathProvider);
//
//     String hours = '00';
//     String minutes = '00';
//     String seconds = '00';
//
//     if (checkInOutState.checkInTime != null &&
//         checkInOutState.checkOutTime != null) {
//       try {
//         DateTime checkInTime = checkInOutState.checkInTime!;
//         DateTime checkOutTime = checkInOutState.checkOutTime!;
//         final duration = checkOutTime.difference(checkInTime);
//
//         hours = duration.inHours.toString().padLeft(2, '0');
//         minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
//         seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//       } catch (e) {
//         print('Error calculating duration: $e');
//       }
//     }
//
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.white,  // Set the color of the container
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16),  // Rounded top-left corner
//               topRight: Radius.circular(16), // Rounded top-right corner
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CheckRow(
//                   "In Time  ",
//                   checkInOutState.checkInTime != null
//                       ? DateFormat(
//                         'hh:mm a',
//                       ).format(checkInOutState.checkInTime!)
//                       : "-- 00 --",
//                   checkInImagePath,
//                 ),
//                 SizedBox(height: 12.h),
//                 CheckRow(
//                   "Out Time",
//                   checkInOutState.checkOutTime != null
//                       ? DateFormat(
//                         'hh:mm a',
//                       ).format(checkInOutState.checkOutTime!)
//                       : "-- 00 --",
//                   checkOutImagePath,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           height: 50.h,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: AppColors.primaryWhitebg,
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(16),  // Rounded bottom-left corner
//               bottomRight: Radius.circular(16), // Rounded bottom-right corner
//             ),
//           ),
//           child: Center(
//             child: Text.rich(
//               TextSpan(
//                 text: 'Present Hours: ',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//                 children: [
//                   TextSpan(
//                     text: '$hours:$minutes:$seconds',
//                     style: TextStyle(color: AppColors.primaryBlueFont, fontSize: 18.sp),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//       ],
//     );
//   }
// }
//
// class CheckRow extends StatelessWidget {
//   final String title, time;
//   final String? localImagePath;
//
//   const CheckRow(this.title, this.time, this.localImagePath, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final hasImage = localImagePath != null && localImagePath!.isNotEmpty;
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(Icons.access_time, color: Colors.purple, size: 24.sp),
//             SizedBox(height: 4.h),
//             Text(
//               title,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
//             ),
//             Text(time, style: TextStyle(fontSize: 12.sp)),
//           ],
//         ),
//         SizedBox(width: 16.w),
//         Expanded(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8.r),
//             child:
//                 hasImage
//                     ? Image.file(
//                       File(localImagePath!),
//                       height: 60.h,
//                       width: 100.w,
//                       fit: BoxFit.cover,
//                     )
//                     : Container(
//                       color: Colors.grey.shade300,
//                       height: 60.h,
//                       child: Center(child: Text("No Image")),
//                     ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/helper/camera_helper_service.dart';
import 'check_in_check_out_provider.dart';

class CheckInCheckOutCard extends ConsumerWidget {
  const CheckInCheckOutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInOutState = ref.watch(checkInOutProvider);
    final checkInImagePath = ref.watch(checkInImagePathProvider);
    final checkOutImagePath = ref.watch(checkOutImagePathProvider);

    String hours = '00';
    String minutes = '00';
    String seconds = '00';

    if (checkInOutState.checkInTime != null &&
        checkInOutState.checkOutTime != null) {
      try {
        final duration =
        checkInOutState.checkOutTime!.difference(checkInOutState.checkInTime!);

        hours = duration.inHours.toString().padLeft(2, '0');
        minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
        seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      } catch (e) {
        print('Error calculating duration: $e');
      }
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckRow(
                  "In Time  ",
                  checkInOutState.checkInTime != null
                      ? DateFormat('hh:mm a').format(checkInOutState.checkInTime!)
                      : "-- 00 --",
                  checkInImagePath,
                ),
                SizedBox(height: 12.h),
                CheckRow(
                  "Out Time",
                  checkInOutState.checkOutTime != null
                      ? DateFormat('hh:mm a').format(checkInOutState.checkOutTime!)
                      : "-- 00 --",
                  checkOutImagePath,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 50.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryWhitebg,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Center(
            child: Text.rich(
              TextSpan(
                text: 'Present Hours: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                children: [
                  TextSpan(
                    text: '$hours:$minutes:$seconds',
                    style: TextStyle(
                      color: AppColors.primaryBlueFont,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CheckRow extends StatelessWidget {
  final String title, time;
  final String? localImagePath;

  const CheckRow(this.title, this.time, this.localImagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    final hasImage = localImagePath != null &&
        localImagePath!.isNotEmpty &&
        File(localImagePath!).existsSync();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.access_time, color: Colors.purple, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
            ),
            Text(time, style: TextStyle(fontSize: 12.sp)),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: hasImage
                ? Image.file(
              File(localImagePath!),
              height: 60.h,
              width: 100.w,
              fit: BoxFit.cover,
            )
                : Container(
              color: Colors.grey.shade300,
              height: 60.h,
              child: Center(child: Text("No Image")),
            ),
          ),
        ),
      ],
    );
  }
}
