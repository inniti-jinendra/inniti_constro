import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

import '../../core/network/logger.dart';
import 'check_in_check_out_provider.dart';
import 'checkin_button.dart';
import 'location_display.dart';

// Riverpod provider for the selected date (current date)
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Riverpod provider for the current time (live tracker)
final timeProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

// Riverpod provider for the check-in time
final checkInTimeProvider = StateProvider<DateTime?>((ref) {
  return null; // Initial state is null (no check-in)
});

// Provider for warning state to avoid logging multiple times
final checkInNullWarningProvider = StateProvider<bool>((ref) {
  return false; // Initial state is no warning logged
});


// Computed provider for the working duration
final workingDurationProvider = Provider<String>((ref) {
  final checkInOutState = ref.watch(checkInOutProvider);
  final checkInTime = checkInOutState.checkInTime;
  final checkOutTime = checkInOutState.checkOutTime;
  final currentTimeAsync = ref.watch(timeProvider);

  return currentTimeAsync.when(
    data: (currentTime) {
      if (checkInTime != null) {
        // Use check-out time if it's available, otherwise use current time
        final endTime = checkOutTime ?? currentTime;
        final duration = endTime.difference(checkInTime);

        final hours = duration.inHours.toString().padLeft(2, '0');
        final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

        return '$hours:$minutes:$seconds';
      } else {
        return '00:00:00';
      }
    },
    loading: () => '00:00:00',
    error: (error, stackTrace) => '00:00:00',
  );
});

class AttendanceHeaderCard extends ConsumerWidget {
  const AttendanceHeaderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInOutState = ref.watch(checkInOutProvider);
    final currentTimeAsync = ref.watch(timeProvider);
    final timeDifference = ref.watch(workingDurationProvider);

    // Debug log to verify that the timeDifference is being calculated
    AppLogger.debug("Working duration: $timeDifference");

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white, // Set the color of the container
        borderRadius: BorderRadius.circular(16), // Set the corner radius
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.purple, size: 18.sp),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      ref.read(selectedDateProvider.notifier).state =
                          pickedDate;
                    }
                  },
                  child: Text(
                    DateFormat('dd MMM yyyy').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                currentTimeAsync.when(
                  data: (time) {
                    return Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.purple,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          DateFormat('HH:mm:ss').format(time),
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    );
                  },
                  loading: () => Text("Loding..."),
                  //loading: () => CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Time difference between check-in and live tracker time
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimeBox(timeDifference.split(':')[0]), // Hours
              SizedBox(width: 8),
              TimeBox(timeDifference.split(':')[1]), // Minutes
              SizedBox(width: 8),
              TimeBox(timeDifference.split(':')[2]), // Seconds
              SizedBox(width: 8),
              Text('HRS', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            "Your working hour’s will be calculated here",
            style: TextStyle(fontSize: 12.sp),
          ),
          SizedBox(height: 20.h),
          const CheckInButton(),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: const LocationDisplay(),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class TimeBox extends StatelessWidget {
  final String value;

  const TimeBox(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        value,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
