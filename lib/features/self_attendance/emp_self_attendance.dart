import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../core/constants/app_colors.dart';
import '../../core/network/logger.dart';
import '../../core/services/attendance/attendance_api_service.dart';
import '../../routes/app_routes.dart';
import '../../widgets/global_loding/global_loader.dart';
import '../../widgets/helper/camera_helper_service.dart';
import 'check_in_check_out_provider.dart';
import 'location_display.dart';

import 'package:flutter/foundation.dart';

class GlobalState {
  static final GlobalState _instance = GlobalState._internal();

  factory GlobalState() => _instance;

  GlobalState._internal();

  int? empAttendanceId;


  final ValueNotifier<String?> attendanceDate = ValueNotifier(null);
  final ValueNotifier<String?> checkInTime = ValueNotifier(null);
  final ValueNotifier<String?> checkOutTime = ValueNotifier(null);
  final ValueNotifier<String?> attendanceStatus = ValueNotifier(null);
  final ValueNotifier<String?> totalHours = ValueNotifier(null);
  final ValueNotifier<String?> inDocumentPath = ValueNotifier(null);
  final ValueNotifier<String?> outDocumentPath = ValueNotifier(null);

  // New for attendanceId
  final ValueNotifier<String?> attendanceId = ValueNotifier(null);

  // New ValueNotifier to control visibility of the CheckInButton
  final ValueNotifier<bool> shouldHideSlider = ValueNotifier(false);

  // Method to update the shouldHideSlider based on inTime and outTime
  void updateSliderVisibility(String? inTime, String? outTime) {
    shouldHideSlider.value = inTime != null && outTime != null;
  }
}

class SelfAttendanceScreen extends StatefulWidget {
  const SelfAttendanceScreen({super.key});

  @override
  State<SelfAttendanceScreen> createState() => _SelfAttendanceScreenState();
}

class _SelfAttendanceScreenState extends State<SelfAttendanceScreen> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    bool hasPermission = await _checkAndRequestLocationPermission();

    if (hasPermission) {
      AppLogger.info(
          "✅ Location permission confirmed. Fetching attendance data...");
      _fetchAttendanceData(); // Only call API if permission is granted
    } else {
      AppLogger.warn("❌ Location permission denied. Showing dialog...");
      _showLocationPermissionDialog();
    }
  }

  /// Checks location permission and requests if not granted
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

  /// Shows a dialog and forces user to enable permission via settings
  void _showLocationPermissionDialog() {
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
  // Future<void> _fetchAttendanceData() async {
  //   AppLogger.info("📡 Starting self-attendance data fetch...");
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     final data = await AttendanceApiService.fetchSelfAttendanceData();
  //     AppLogger.info("✅ Fetched ${data.length} self-attendance record(s)");
  //
  //     if (data.isNotEmpty) {
  //       final firstRecord = data.first;
  //       AppLogger.info("📦 First record: $firstRecord");
  //       AppLogger.info("➡️ EmployeeName: ${firstRecord.employeeName}");
  //       AppLogger.info("➡️ Designation: ${firstRecord.designationName}");
  //       AppLogger.info("➡️ EmpAttendanceId: ${firstRecord.empAttendanceId}");
  //       AppLogger.info("➡️ EmployeeCode: ${firstRecord.employeeCode}");
  //       AppLogger.info("➡️ InTime: ${firstRecord.inTime}");
  //       AppLogger.info("➡️ OutTime: ${firstRecord.outTime}");
  //       AppLogger.info("➡️ PresentHours: ${firstRecord.presentHours}");
  //       AppLogger.info("➡️ inDocumentPath: ${firstRecord.inDocumentPath}");
  //       AppLogger.info("➡️ outDocumentPath: ${firstRecord.outDocumentPath}");
  //
  //
  //       final empAttendanceIdStr = firstRecord.empAttendanceId;
  //       final inTime = firstRecord.inTime;
  //       final outTime = firstRecord.outTime;
  //       final inDocumentPath = firstRecord.inDocumentPath;
  //       final outDocumentPath = firstRecord.outDocumentPath;
  //
  //
  //       // Check if presentHours is non-zero
  //       final attendanceStatus = firstRecord.presentHours != null && firstRecord.presentHours!.inMinutes > 0 ? 'Present' : 'Absent';
  //       final attendanceDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Assuming today for attendance date
  //       final totalHours = firstRecord.presentHours?.toString() ?? "0 Hrs. 00 Min";
  //
  //       AppLogger.info("🔍 empAttendanceId: $empAttendanceIdStr");
  //       AppLogger.info("🕒 inTime: $inTime");
  //       AppLogger.info("🕔 outTime: $outTime");
  //       AppLogger.info("🕔 totalHours: $totalHours");
  //
  //       // Convert DateTime to String if inTime or outTime are not null
  //       String? formattedInTime = inTime != null ? DateFormat('HH:mm:ss').format(inTime) : null;
  //       String? formattedOutTime = outTime != null ? DateFormat('HH:mm:ss').format(outTime) : null;
  //
  //       String formatOnlyTimeFromTimestamp(int timestamp) {
  //         final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  //         return "${dateTime.hour.toString().padLeft(2, '0')}:"
  //             "${dateTime.minute.toString().padLeft(2, '0')}:";
  //            // "${dateTime.second.toString().padLeft(2, '0')}";
  //       }
  //
  //
  //
  //       // ✅ Update global state variables with formatted strings
  //       // GlobalState().checkInTime = formattedInTime;
  //       // GlobalState().checkOutTime = formattedOutTime;
  //       // GlobalState().inDocumentPath = inDocumentPath;
  //       // GlobalState().outDocumentPath = outDocumentPath;
  //       // GlobalState().attendanceStatus = attendanceStatus;
  //       // GlobalState().attendanceDate = attendanceDate;
  //       // GlobalState().totalHours = totalHours;
  //
  //       final state = GlobalState();
  //       state.checkInTime.value = formattedInTime;
  //       state.checkOutTime.value = formattedOutTime;
  //       state.inDocumentPath.value = inDocumentPath;
  //       state.outDocumentPath.value = outDocumentPath;
  //       state.attendanceStatus.value = attendanceStatus;
  //       state.attendanceDate.value = attendanceDate;
  //       state.totalHours.value = totalHours;
  //
  //       final empAttendanceId = int.tryParse(empAttendanceIdStr);
  //       if (empAttendanceId != null) {
  //         final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //         final storageKey = 'empAttendanceId_$today';
  //
  //         AppLogger.info("💾 Stored empAttendanceId: $empAttendanceId under key: $storageKey");
  //
  //         // ref.read(empAttendanceIdProvider.notifier).state = empAttendanceId;
  //         AppLogger.info("🟢 Updated provider with empAttendanceId: $empAttendanceId");
  //       } else {
  //         _error = "❌ Invalid empAttendanceId format: $empAttendanceIdStr";
  //         AppLogger.error(_error!);
  //       }
  //
  //       // ref.read(selfAttendanceDataProvider.notifier).state = data;
  //     } else {
  //       AppLogger.warn("⚠️ No self-attendance records found.");
  //     }
  //   } catch (e) {
  //     _error = "❌ Error fetching attendance data: ${e.toString()}";
  //     AppLogger.error(_error!);
  //   } finally {
  //     setState(() => _isLoading = false);
  //     AppLogger.info("📴 Data fetch complete. isLoading = false.");
  //   }
  // }

  String formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Future<void> _fetchAttendanceData() async {
    AppLogger.info("📡 Starting self-attendance data fetch...");
    setState(() => _isLoading = true);

    try {
      final data = await AttendanceApiService.fetchSelfAttendanceData();
      AppLogger.info("✅ Fetched ${data.length} self-attendance record(s)");

      if (data.isNotEmpty) {
        final firstRecord = data.first;
        AppLogger.info("📦 First record: $firstRecord");
        AppLogger.info("➡️ EmployeeName: ${firstRecord.employeeName}");
        AppLogger.info("➡️ Designation: ${firstRecord.designationName}");
        AppLogger.info("➡️ EmpAttendanceId: ${firstRecord.empAttendanceId}");
        AppLogger.info("➡️ EmployeeCode: ${firstRecord.employeeCode}");
        AppLogger.info("➡️ InTime: ${firstRecord.inTime}");
        AppLogger.info("➡️ OutTime: ${firstRecord.outTime}");
        AppLogger.info("➡️ PresentHours: ${firstRecord.presentHours}");
        AppLogger.info("➡️ inDocumentPath: ${firstRecord.inDocumentPath}");
        AppLogger.info("➡️ outDocumentPath: ${firstRecord.outDocumentPath}");


        final empAttendanceIdStr = firstRecord.empAttendanceId;
        final inTime = firstRecord.inTime;
        //final inTime = firstRecord.inTime;
        final outTime = firstRecord.outTime;
        final inDocumentPath = firstRecord.inDocumentPath;
        final outDocumentPath = firstRecord.outDocumentPath;

        // Check if both inTime and outTime are not null
        final bool shouldHideSlider = inTime != null && outTime != null;

        // Convert milliseconds to Duration for inTime and outTime
        String formatTimeFromMilliseconds(int milliseconds) {
          final duration = Duration(milliseconds: milliseconds);
          final hours = duration.inHours.toString().padLeft(2, '0');
          final minutes =
              duration.inMinutes.remainder(60).toString().padLeft(2, '0');
          final seconds =
              duration.inSeconds.remainder(60).toString().padLeft(2, '0');
          return "$hours:$minutes:$seconds";
        }

        // Convert DateTime to String if inTime or outTime are not null
        String? formattedInTime =
            inTime != null ? DateFormat('HH:mm:ss').format(inTime) : null;
        String? formattedOutTime =
            outTime != null ? DateFormat('HH:mm:ss').format(outTime) : null;

        // Check if presentHours is non-zero
        final attendanceStatus = firstRecord.presentHours != null &&
                firstRecord.presentHours!.inMinutes > 0
            ? 'Present'
            : 'Absent';
        final attendanceDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.now()); // Assuming today for attendance date

        // Format totalHours without milliseconds
        final totalMilliseconds = firstRecord.presentHours?.inMilliseconds ?? 0;
        final totalHoursFormatted = formatDuration(totalMilliseconds);


        // ✅ Update global state variables with formatted strings
        final state = GlobalState();
        state.checkInTime.value = formattedInTime;
        state.checkOutTime.value = formattedOutTime;
        state.inDocumentPath.value = inDocumentPath;
        state.outDocumentPath.value = outDocumentPath;
        state.attendanceStatus.value = attendanceStatus;
        state.attendanceDate.value = attendanceDate;
        state.totalHours.value = totalHoursFormatted;
        state.attendanceId.value = empAttendanceIdStr;

        final empAttendanceId = int.tryParse(empAttendanceIdStr);
        if (empAttendanceId != null) {
          final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
          final storageKey = 'empAttendanceId_$today';

          AppLogger.info(
              "💾 Stored empAttendanceId: $empAttendanceId under key: $storageKey");

           //ref.read(empAttendanceIdProvider.notifier).state = empAttendanceId;
          AppLogger.info(
              "🟢 Updated provider with empAttendanceId: $empAttendanceId");
        } else {
          _error = "❌ Invalid empAttendanceId format: $empAttendanceIdStr";
          AppLogger.error(_error!);
        }

        // ref.read(selfAttendanceDataProvider.notifier).state = data;
      } else {
        AppLogger.warn("⚠️ No self-attendance records found.");
      }
    } catch (e) {
      _error = "❌ Error fetching attendance data: ${e.toString()}";
      AppLogger.error(_error!);
    } finally {
      setState(() => _isLoading = false);
      AppLogger.info("📴 Data fetch complete. isLoading = false.");
    }
  }

  Future<void> _refreshAttendanceData() async {
    AppLogger.info("🔄 Refresh triggered...");
    await _fetchAttendanceData(); // this already handles loading, errors, logging
  }

  @override
  Widget build(BuildContext context) {
    final state = GlobalState();
    final ValueNotifier<bool> shouldHideSlider = ValueNotifier(false);


    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refreshAttendanceData,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 80.h),
                const AttendanceHeaderCard(),
                SizedBox(height: 80.h),
                //const CheckInButton(),
                // Visibility(
                //   visible: !state.shouldHideSlider.value,
                //   // Check the state value
                //   child: const CheckInButton(),
                // ),
                ValueListenableBuilder<bool>(
                  valueListenable: shouldHideSlider,
                  builder: (context, hide, child) {
                    if (hide) {
                      return const SizedBox.shrink();
                    } else {
                      return CheckInButton();
                    }
                  },
                ),

                SizedBox(height: 50.h),
                const LocationDisplay(),
                SizedBox(height: 50.h),
                const CheckInOutScreen(),
                // const CheckInCheckOutCard(),
                SizedBox(height: 50.h),
                const AttendanceSummaryCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Riverpod provider for the selected date (current date)
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Riverpod provider for the current time (current time)
final timeProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

// Riverpod provider for the check-in time
final checkInTimeProvider = StateProvider<DateTime?>((ref) {
  return null; // Initial state is null (no check-in)
});

final checkOutTimeProvider = StateProvider<DateTime?>((ref) => null);


class AttendanceHeaderCard extends ConsumerWidget {
  const AttendanceHeaderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = ref.watch(selectedDateProvider);
    final currentTimeAsync = ref.watch(timeProvider);
    final checkInTime = ref.watch(checkInTimeProvider);
    final checkOutTime = ref.watch(checkOutTimeProvider);

    String timeDifference = '00:00:00';
    Duration? liveDuration;

    // currentTimeAsync.when(
    //   data: (currentTime) {
    //     if (checkInTime != null) {
    //       final duration = currentTime.difference(checkInTime);
    //       final hours = duration.inHours.toString().padLeft(2, '0');
    //       final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    //       final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    //       timeDifference = '$hours:$minutes:$seconds';
    //       liveDuration = duration;
    //     }
    //   },
    //   loading: () {},
    //   error: (error, stackTrace) {
    //     print("Error fetching time: $error");
    //   },
    // );

    //  If checked out, freeze the timer at 00:00:00
    if (checkOutTime != null) {
      timeDifference = '00:00:00';
      liveDuration = Duration.zero;
    } else {
      currentTimeAsync.when(
        data: (currentTime) {
          if (checkInTime != null) {
            final duration = currentTime.difference(checkInTime);
            final hours = duration.inHours.toString().padLeft(2, '0');
            final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
            final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
            timeDifference = '$hours:$minutes:$seconds';
            liveDuration = duration;
          }
        },
        loading: () {},
        error: (error, stackTrace) {
          print("Error fetching time: $error");
        },
      );
    }

    final inTime = GlobalState().checkInTime.value;

    String inHours = '00';
    String inMinutes = '00';
    String inSeconds = '00';

    if (inTime != null) {
      try {
        final now = DateTime.now();
        final parsedTime = DateFormat("HH:mm:ss").parse(inTime);
        final checkInDateTime = DateTime(now.year, now.month, now.day,
            parsedTime.hour, parsedTime.minute, parsedTime.second);
        final duration = now.difference(checkInDateTime);
        inHours = duration.inHours.toString().padLeft(2, '0');
        inMinutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
        inSeconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      } catch (e) {
        print("Error parsing inTime: $e");
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white, // Set the color of the container
        borderRadius: BorderRadius.circular(16), // Set the corner radius
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.purple, size: 18.sp),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    DateFormat('dd MMM yyyy').format(selectedDate),
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                currentTimeAsync.when(
                  data: (time) {
                    return Row(
                      children: [
                        Icon(Icons.access_time,
                            color: Colors.purple, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          DateFormat('HH:mm:ss').format(time),
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    );
                  },
                  loading: () => CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            /// Live Duration using TimeBox
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     TimeBox(timeDifference.split(':')[0]), // Hours
            //     SizedBox(width: 8),
            //     TimeBox(timeDifference.split(':')[1]), // Minutes
            //     SizedBox(width: 8),
            //     TimeBox(timeDifference.split(':')[2]), // Seconds
            //     SizedBox(width: 8),
            //     Text('HRS', style: TextStyle(fontWeight: FontWeight.bold)),
            //   ],
            // ),
            buildTimeRow(inHours, inMinutes, inSeconds),

            SizedBox(height: 8.h),
            Text("Your working hour’s will be calculated here",
                style: TextStyle(fontSize: 12.sp)),
            SizedBox(height: 16.h),

            /// In-Time and Duration Display
            // Column(
            //   children: [
            //     Text(
            //       'In Time: ${inTime ?? '--:--:--'}',
            //       style: TextStyle(
            //         fontSize: 14.sp,
            //         fontWeight: FontWeight.w600,
            //         color: Colors.black87,
            //       ),
            //     ),
            //     SizedBox(height: 8.h),
            //
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

// class TimeBox extends StatelessWidget {
//   final String value;
//
//   const TimeBox(this.value, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Text(value,
//           style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//     );
//   }
// }

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
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87, // Text color for better visibility
        ),
      ),
    );
  }
}

Row buildTimeRow(String inHours, String inMinutes, String inSeconds) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(width: 8.w),
      TimeBox(inHours),
      SizedBox(width: 4.w),
      Text(
        ":",
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
      SizedBox(width: 4.w),
      TimeBox(inMinutes),
      SizedBox(width: 4.w),
      Text(
        ":",
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
      SizedBox(width: 4.w),
      TimeBox(inSeconds),
    ],
  );
}

class CheckInButton extends ConsumerStatefulWidget {
  const CheckInButton({super.key});

  @override
  _CheckInButtonState createState() => _CheckInButtonState();
}

class _CheckInButtonState extends ConsumerState<CheckInButton> {
  bool isFinished = false;
  bool isCheckIn = true; // Default state (will be overridden by API response)

  bool isCheckInPhase = true;
  bool canSwipe = false;
  bool isAttendanceFilled = false;

  @override
  void initState() {
    super.initState();
    determineCheckInStatusFromApi(); // Determine slider status on startup
    _getEmpAttendanceId();

  }

  Future<void> determineCheckInStatusFromApi() async {
    try {
      AppLogger.info(
          "📡 Checking latest attendance record to determine slider state...");
      final data = await AttendanceApiService.fetchSelfAttendanceData();


      if (data.isNotEmpty) {
        final record = data.first;
        final hasCheckedIn = record.inTime != null;
        final hasCheckedOut = record.outTime != null;


        if (!hasCheckedIn) {
          // User has not checked in
          setState(() {
            isCheckIn = true;
            isFinished = false;
          });
          AppLogger.info("▶️ No inTime. Set slider to Check-In.");
        } else if (hasCheckedIn && !hasCheckedOut) {
          // Checked in but not checked out
          setState(() {
            isCheckIn = false;
            isFinished = true;
          });
          AppLogger.info("🔁 Checked in, not out. Set slider to Check-Out.");
        } else {
          // Checked in and checked out (complete) → reset
          setState(() {
            isCheckIn = true;
            isFinished = false;
          });
          AppLogger.info("✅ Already checked in & out. Resetting to Check-In.");
        }
      } else {
        AppLogger.warn(
            "⚠️ No attendance records found. Defaulting to Check-In.");
      }
    } catch (e) {
      AppLogger.error("❌ Error determining check-in status: ${e.toString()}");
    }
  }

  Future<void> handleSlideSubmit() async {
    final now = DateTime.now();
    final currentTime = DateTime.now();
    final formattedTime = DateFormat('HH:mm:ss').format(currentTime);

    setState(() {
      isFinished = !isFinished;
    });

    // Retrieve empAttendanceId
    final empAttendanceId = await _getEmpAttendanceId(); // Ensure you're getting the correct value
    AppLogger.info("ℹ️ INFO: EmpAttendanceId retrieved: $empAttendanceId"); // Log the EmpAttendanceId

    if (empAttendanceId != null) {
      ref.read(empAttendanceIdProvider.notifier).state = empAttendanceId;
      AppLogger.info('🆔 Updated provider with EmpAttendanceId:=> $empAttendanceId');
    } else {
      AppLogger.error('❌ empAttendanceId is null or invalid');
      return; // Exit if empAttendanceId is invalid
    }

    if (isCheckIn) {
      AppLogger.info('✅ Check-In Completed at $formattedTime');
      ref.read(checkInTimeProvider.notifier).state = currentTime;



      final empId = await _getEmpAttendanceId();
      ref.read(empAttendanceIdProvider.notifier).state = empId;
      AppLogger.info('⏱️ Check-In Time: $formattedTime | 🆔 EmpId: $empId');

      final imagePath = await CameraHelper().openCamera(context, ref);
      if (imagePath?.isNotEmpty ?? false) {
        AppLogger.info('📸 Check-In image captured: $imagePath');
        ref.read(checkInImagePathProvider.notifier).state = imagePath!;

        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final location = await CameraHelper().fetchLocation();

        GlobalLoader.show(context);
        // await CameraHelper.uploadImage(
        //   context,
        //   imagePath,
        //   "IN",
        //   position.latitude,
        //   position.longitude,
        //   location,
        //   now,
        //   null,
        //   empAttendanceId!,
        // );
        GlobalLoader.hide();

        AppLogger.info('✅ Check-In upload complete!');
        setState(() => canSwipe = true);

        Navigator.pop(context);

        if (mounted) {
          setState(() {
            isCheckIn = !isCheckIn; // Toggle only if mounted
          });
          refreshUI(); // 🔥 UI refresh here
        }

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.entryPoint,
        );


      } else {
        AppLogger.error('❌ No image taken during Check-In.');
        setState(() => canSwipe = false);
        return;
      }
    } else {

      AppLogger.info('✅ Check-Out Completed at $formattedTime');
      ref.read(checkInTimeProvider.notifier).state = null;

      final empId = GlobalState().empAttendanceId ?? 0;
      AppLogger.info(' 🆔 EmpId:=> $empId');

     // final empId = await _getEmpAttendanceId();
     //  ref.read(empAttendanceIdProvider.notifier).state = empId;
     //  AppLogger.info('⏱️ Check-Out Time: $formattedTime | 🆔 EmpId: $empId');

      final attendanceId = ref.read(empAttendanceIdProvider);
      AppLogger.info('📋 Attendance ID during Check-Out: $attendanceId');



      final imagePath = await CameraHelper().openCamera(context, ref);
      if (imagePath?.isNotEmpty ?? false) {
        AppLogger.info('📸 Check-Out image captured: $imagePath');
        ref.read(checkOutImagePathProvider.notifier).state = imagePath!;

        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final location = await CameraHelper().fetchLocation();

        GlobalLoader.show(context);
        // await CameraHelper.uploadImage(
        //   context,
        //   imagePath,
        //   "OUT",
        //   position.latitude,
        //   position.longitude,
        //   location,
        //   null,
        //   now,
        //   empAttendanceId,
        // );
        GlobalLoader.hide();

        AppLogger.info('✅ Check-Out upload complete!');
        setState(() => canSwipe = true);

        //Navigator.pop(context);
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.entryPoint,
        );

        if (mounted) {
          setState(() {
            isCheckIn = !isCheckIn; // Toggle only if mounted
          });
          refreshUI(); // 🔥 UI refresh here
        }

      } else {
        AppLogger.error('❌ No image taken during Check-Out.');
        setState(() => canSwipe = false);

        return;
      }
    }

    setState(() {
      isCheckIn = !isCheckIn;
    });
  }

  // Future<void> _handleAttendanceSlide() async {
  //   final now = DateTime.now();
  //   final formattedTime = DateFormat('HH:mm:ss').format(now);
  //   final notifier = ref.read(checkInOutProvider.notifier);
  //
  //   setState(() => isFinished = !isFinished);
  //
  //   if (isCheckInPhase) {
  //     AppLogger.info('🚪 Starting Check-In process...');
  //     ref.read(checkInTimeProvider.notifier).state = now;
  //     notifier.setCheckInTime(now);
  //
  //     final empId = await _getEmpAttendanceId();
  //     ref.read(empAttendanceIdProvider.notifier).state = empId;
  //
  //     AppLogger.info('⏱️ Check-In Time: $formattedTime | 🆔 EmpId: $empId');
  //
  //     final imagePath = await CameraHelper().openCamera(context, ref);
  //     if (imagePath?.isNotEmpty ?? false) {
  //       AppLogger.info('📸 Check-In image captured: $imagePath');
  //       ref.read(checkInImagePathProvider.notifier).state = imagePath!;
  //
  //       final position = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);
  //       final location = await CameraHelper().fetchLocation();
  //
  //       GlobalLoader.show(context);
  //       await CameraHelper.uploadImage(
  //         context,
  //         imagePath,
  //         "IN",
  //         position.latitude,
  //         position.longitude,
  //         location,
  //         now,
  //         null,
  //         empId,
  //       );
  //       GlobalLoader.hide();
  //
  //       AppLogger.info('✅ Check-In upload complete!');
  //       setState(() => canSwipe = true);
  //
  //     } else {
  //       AppLogger.error('❌ No image taken during Check-In.');
  //       setState(() => canSwipe = false);
  //       return;
  //     }
  //   } else {
  //     AppLogger.info('🚪 Starting Check-Out process...');
  //
  //     final empId = ref.read(empAttendanceIdProvider);
  //     if (empId == null || empId == 0) {
  //       AppLogger.error('❌ Invalid empAttendanceId for Check-Out.');
  //       return;
  //     }
  //
  //     notifier.setCheckOutTime(now);
  //     AppLogger.info('⏱️ Check-Out Time: $formattedTime | 🆔 EmpId: $empId');
  //
  //     final imagePath = await CameraHelper().openCamera(context, ref);
  //     if (imagePath?.isNotEmpty ?? false) {
  //       AppLogger.info('📸 Check-Out image captured: $imagePath');
  //       ref.read(checkOutImagePathProvider.notifier).state = imagePath!;
  //
  //       final position = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);
  //       final location = await CameraHelper().fetchLocation();
  //
  //       GlobalLoader.show(context);
  //       await CameraHelper.uploadImage(
  //         context,
  //         imagePath,
  //         "OUT",
  //         position.latitude,
  //         position.longitude,
  //         location,
  //         null,
  //         now,
  //         empId,
  //       );
  //       GlobalLoader.hide();
  //
  //       AppLogger.info('✅ Check-Out upload complete!');
  //       setState(() => canSwipe = true);
  //     } else {
  //       AppLogger.error('❌ No image taken during Check-Out.');
  //       setState(() => canSwipe = false);
  //       return;
  //     }
  //   }
  //
  //   // Toggle phase after successful action
  //   setState(() {
  //     isCheckInPhase = !isCheckInPhase;
  //   });
  //
  //   final storage = ref.read(flutterSecureStorageProvider);
  //   final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   final key = 'attendanceStatus_$today';
  //   await storage.write(
  //       key: key, value: isCheckInPhase ? 'checkIn' : 'checkOut');
  //
  //   AppLogger.info(
  //       '🔄 Phase toggled to: ${isCheckInPhase ? "Check-In" : "Check-Out"} and saved in secure storage');
  // }

  // Define the _getEmpAttendanceId method
  Future<int?> _getEmpAttendanceId() async {
    AppLogger.info("GlobalState().attendanceId ${GlobalState().attendanceId.value.toString()}");
    final empAttendanceId = int.parse(GlobalState().attendanceId.value.toString()) ;
    if (empAttendanceId != null) {
      AppLogger.info("🟢 Retrieved empAttendanceId: $empAttendanceId");
    } else {
      AppLogger.error("❌ Invalid empAttendanceId: null or not found");
    }
    return empAttendanceId;
  }


  void refreshUI() {
    // Example: fetch new data or reset variables
    determineCheckInStatusFromApi(); // your method to fetch or update data

    setState(() {
      // update local state as needed

    });
  }

  @override
  Widget build(BuildContext context) {
    final state = GlobalState();

    return Column(
      children: [
        // ValueListenableBuilder<String?>(
        //   valueListenable: state.attendanceId,
        //   builder: (context, attendanceId, _) {
        //     return attendanceId != null
        //         ? Text('Attendance ID: $attendanceId')
        //         : Text('No Attendance ID yet');
        //   },
        // ),


        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SlideAction(
              borderRadius: 10,
              innerColor: const Color(0xffe1d6f2),
              outerColor: const Color(0xff7339c8),
              reversed: isFinished,
              sliderButtonIcon: SvgPicture.asset(
                'assets/icons/attendance/user-tick.svg',
                color: AppColors.primaryBlueFont,
                height: 24.0,
                width: 24.0,
              ),
              textStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
              sliderRotate: false,
              onSubmit: handleSlideSubmit,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isCheckIn
                      ? Row(
                          children: [
                            Text("Check In",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.sp)),
                            SizedBox(width: 8),
                            Icon(Icons.keyboard_double_arrow_right,
                                color: Colors.white),
                          ],
                        )
                      : Row(
                          children: [
                            Icon(Icons.keyboard_double_arrow_left,
                                color: Colors.white),
                            SizedBox(width: 8),
                            Text("Check Out",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.sp)),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: SlideAction(
        //       key: ValueKey(isCheckInPhase),
        //       borderRadius: 10,
        //       innerColor: const Color(0xffe1d6f2),
        //       outerColor: const Color(0xff7339c8),
        //       reversed: !isCheckInPhase,
        //       // ⬅️ Check-In: L ➡ R, Check-Out: R ➡ L
        //       sliderButtonIcon: SvgPicture.asset(
        //         'assets/icons/attendance/user-tick.svg',
        //         color: AppColors.primaryBlueFont,
        //         height: 24.0,
        //         width: 24.0,
        //       ),
        //       textStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
        //       sliderRotate: false,
        //       onSubmit: () {
        //         AppLogger.info(
        //             '🚪 SlideAction submitted, handling attendance slide...');
        //         _handleAttendanceSlide();
        //       },
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: isCheckInPhase
        //             ? [
        //                 Text("Check In",
        //                     style: TextStyle(
        //                         color: const Color(0xffb798e3),
        //                         fontSize: 16.sp)),
        //                 const SizedBox(width: 8),
        //                 const Icon(Icons.keyboard_double_arrow_right,
        //                     color: Colors.white),
        //               ]
        //             : [
        //                 const Icon(Icons.keyboard_double_arrow_left,
        //                     color: Colors.white),
        //                 const SizedBox(width: 8),
        //                 Text("Check Out",
        //                     style: TextStyle(
        //                         color: Colors.white, fontSize: 16.sp)),
        //               ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class CheckInOutScreen extends StatefulWidget {
  const CheckInOutScreen({super.key});

  @override
  State<CheckInOutScreen> createState() => _CheckInOutScreenState();
}

class _CheckInOutScreenState extends State<CheckInOutScreen> {
  bool _isLoading = false; // For loading indicator (if needed)
  String? _error;

  // Function to format the time for display
  String formatTime(String? dateTimeStr) {
    if (dateTimeStr == null) return "- 00 -";
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(dateTimeStr);
      return DateFormat("HH:mm").format(parsedTime);
    } catch (e) {
      return "- 00 -";
    }
  }

  // Function to simulate fetching data from an API
  Future<void> _fetchDataFromApi() async {
    setState(() => _isLoading = true); // Show loading indicator

    try {
      // Simulate API call (Replace with actual API call)
      await Future.delayed(Duration(seconds: 1));

      // Simulate API response data
      // String checkInTime = "--:--:--";
      // String checkOutTime = "--:--:--";
      // String inDocumentPath = "https://img.freepik.com/premium-photo/building-construction-with-blueprints_190619-1594.jpg";
      // String outDocumentPath =

      setState(() {});

      String checkInTime = "--:--:--";
      String checkOutTime = "--:--:--";
      String inDocumentPath = " NO IMAGES";
      String outDocumentPath = "NO IMAGES";

      // Once data is fetched, update the global state
      GlobalState().checkInTime.value = checkInTime;
      GlobalState().checkOutTime.value = checkOutTime;
      GlobalState().inDocumentPath.value = inDocumentPath;
      GlobalState().outDocumentPath.value = outDocumentPath;

      setState(() {}); // Rebuild UI after state update
    } catch (e) {
      setState(() {
        _error = "Error fetching data: ${e.toString()}"; // Handle error
      });
    } finally {
      setState(() => _isLoading = false); // Hide loading indicator
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isLoading) CircularProgressIndicator(),
        // Loading indicator

        if( GlobalState().checkInTime.value != null)ValueListenableBuilder<String?>(
          valueListenable: GlobalState().checkInTime,
          builder: (context, checkInTime, _) {
            return CheckRow(
              title: "In Time",
              time: formatTime(checkInTime),
              imageUrl: GlobalState().inDocumentPath.value ??
                  'https://img.freepik.com/premium-photo/building-construction-with-blueprints_190619-1594.jpg', // Default image
            );
          },
        ),
        SizedBox(height: 12.h),
        if( GlobalState().checkOutTime.value != null) ValueListenableBuilder<String?>(
          valueListenable: GlobalState().checkOutTime,
          builder: (context, checkOutTime, _) {
            return CheckRow(
              title: "Out Time",
              time: formatTime(checkOutTime),
              imageUrl: GlobalState().outDocumentPath.value ??
                  'https://i.pinimg.com/736x/c3/74/bc/c374bcf2af1deeee10fa2281c5c9b1cc.jpg', // Default image
            );
          },
        ),
        SizedBox(height: 20.h),
        if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
        // Display error if any
      ],
    );
  }
}

class CheckRow extends StatelessWidget {
  final String title;
  final String time;
  final String imageUrl;

  const CheckRow({
    super.key,
    required this.title,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(
              time,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),
          ],
        ),
        SizedBox(width: 12.w),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            imageUrl,
            height: 60.h,
            width: 200.w,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child; // When the image is loaded, return the child widget (the image)
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Text("No Image"));
            },
          ),
        ),
      ],
    );
  }
}

class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GlobalState();
    //final timestamp = _convertTimestampToTime("1666661000");  // Hardcoded test value

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Current Attendance",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        SizedBox(height: 8.h),
        // Card(
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        //   elevation: 2,
        //   child: Padding(
        //     padding: EdgeInsets.all(12.w),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         ValueListenableBuilder<String?>(
        //           valueListenable: state.attendanceDate,
        //           builder: (context, attendanceDate, _) {
        //             return Row(
        //               children: [
        //                 Icon(Icons.calendar_today,
        //                     color: Colors.purple, size: 18.sp),
        //                 SizedBox(width: 8.w),
        //                 Text(attendanceDate ?? "N/A",
        //                     style: TextStyle(
        //                         fontWeight: FontWeight.w600, fontSize: 13.sp)),
        //                 const Spacer(),
        //                 ValueListenableBuilder<String?>(
        //                   valueListenable: state.attendanceStatus,
        //                   builder: (context, status, _) {
        //                     return Chip(
        //                       label: Text(status ?? "Absent",
        //                           style: TextStyle(
        //                               color: Colors.purple, fontSize: 12.sp)),
        //                       backgroundColor: const Color(0xFFEDE7F6),
        //                       side: BorderSide.none,
        //                       padding: EdgeInsets.symmetric(horizontal: 8.w),
        //                     );
        //                   },
        //                 ),
        //               ],
        //             );
        //           },
        //         ),
        //         Divider(height: 24.h, thickness: 1),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             ValueListenableBuilder<String?>(
        //               valueListenable: state.checkInTime,
        //               builder: (context, inTime, _) {
        //                 return _buildTimeColumn("In Time", inTime);
        //               },
        //             ),
        //             Container(
        //                 width: 1, height: 40.h, color: Colors.grey.shade300),
        //             ValueListenableBuilder<String?>(
        //               valueListenable: state.checkOutTime,
        //               builder: (context, outTime, _) {
        //                 return _buildTimeColumn("Out Time", outTime);
        //               },
        //             ),
        //             Container(
        //                 width: 1, height: 40.h, color: Colors.grey.shade300),
        //             ValueListenableBuilder<String?>(
        //               valueListenable: state.totalHours,
        //               builder: (context, totalHours, _) {
        //                 return _buildTimeColumn(
        //                     "Total Hrs.", totalHours ?? "00:00");
        //               },
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // )
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white, // Set the background color (optional)
            borderRadius: BorderRadius.circular(
              16,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09), // very subtle shadow
                blurRadius: 6,
                offset: Offset(0, 2), // downwards shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Set the background color (optional)
                  borderRadius: BorderRadius.circular(
                    14,
                  ), // Set the rounded corners with 16 radius
                ),
                padding: EdgeInsets.all(10),
                // Optional: Adjust padding if necessary
                child: ValueListenableBuilder<String?>(
                  valueListenable: state.attendanceDate,
                  builder: (context, attendanceDate, _) {
                    return Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.purple, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(attendanceDate ?? "N/A",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13.sp)),
                        const Spacer(),
                        ValueListenableBuilder<String?>(
                          valueListenable: state.attendanceStatus,
                          builder: (context, status, _) {
                            return Chip(
                              label: Text(status ?? "Absent",
                                  style: TextStyle(
                                      color: Colors.purple, fontSize: 12.sp)),
                              backgroundColor: const Color(0xFFEDE7F6),
                              side: BorderSide.none,
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryWhitebg,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: state.checkInTime,
                      builder: (context, inTime, _) {
                        return _buildTimeColumn("In Time", inTime);
                      },
                    ),
                    Container(
                        width: 1, height: 40.h, color: Colors.grey.shade300),
                    ValueListenableBuilder<String?>(
                      valueListenable: state.checkOutTime,
                      builder: (context, outTime, _) {
                        return _buildTimeColumn("Out Time", outTime);
                      },
                    ),
                    Container(
                        width: 1, height: 40.h, color: Colors.grey.shade300),
                    ValueListenableBuilder<String?>(
                      valueListenable: state.totalHours,
                      builder: (context, totalHours, _) {
                        return _buildTimeColumn(
                            "Total Hrs.", totalHours ?? "00:00");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // String _convertTimestampToTime(String? timestamp) {
  //   if (timestamp == null || timestamp.isEmpty) return "00:00:00"; // Default to "00:00:00" if null or empty
  //
  //   try {
  //     // Convert the timestamp to an integer (assuming it's in seconds)
  //     final int totalSeconds = int.parse(timestamp);
  //
  //     // Calculate hours, minutes, and seconds
  //     final int hours = totalSeconds ~/ 3600;   // Calculate total hours
  //     final int minutes = (totalSeconds % 3600) ~/ 60;  // Remaining minutes
  //     final int seconds = totalSeconds % 60;  // Remaining seconds
  //
  //     // Return formatted time as hh:mm:ss (with leading zeros)
  //     return "${hours.toString().padLeft(3, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  //   } catch (e) {
  //     return "00:00:00";  // In case of any error, return default format
  //   }
  // }

  Widget _buildTimeColumn(String title, String? time) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey)),
        SizedBox(height: 4.h),
        Text(time ?? "--:--:--",
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
