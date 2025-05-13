import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../../../core/components/appbar_header.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/network/logger.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/themes/app_themes.dart';
import '../../core/constants/font_styles.dart';
import '../../core/services/attendance/attendance_api_service.dart';
import '../../core/utils/secure_storage_util.dart';
import '../self_attendance/emp_self_attendance.dart';
import 'CheckInOutNotifier.dart';
import 'live_time_provider.dart';
import 'map_screen.dart';

class SelfAttendanceScreen extends ConsumerStatefulWidget {
  const SelfAttendanceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelfAttendanceScreen> createState() =>
      _SelfAttendanceScreenState();
}

class _SelfAttendanceScreenState extends ConsumerState<SelfAttendanceScreen> {
  bool _isLoading = true;
  String? _error;
  String? _projectName;
  late Timer _timer; // Timer to trigger regular refresh
  int _refreshInterval = 2; // Time interval in seconds

  // Controllers for form fields
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _empAttendanceIdController = TextEditingController();
  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _inTimeController = TextEditingController();
  final TextEditingController _outTimeController = TextEditingController();
  final TextEditingController _presentHoursController = TextEditingController();
  final TextEditingController _attendanceStatusController = TextEditingController();
  late final TextEditingController _inDocumentPathController;
  late final TextEditingController _outDocumentPathController;

  // Converts milliseconds to HH:mm:ss format
  String formatDuration(int milliseconds) {
    final d = Duration(milliseconds: milliseconds);
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  // Calculates and formats time difference between check-in and check-out
  String _calculateTimeDifference(DateTime checkIn, DateTime checkOut) {
    return _formatTimeFromSeconds(checkOut.difference(checkIn).inSeconds);
  }

  // Converts seconds into HH:mm:ss format
  String _formatTimeFromSeconds(int totalSeconds) {
    final h = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  @override
  void initState() {
    super.initState();
    _fetchStoredProject();
    _inDocumentPathController = TextEditingController();
    _outDocumentPathController = TextEditingController();
    _init();

    _timer = Timer.periodic(Duration(seconds: _refreshInterval), (timer) {
      _init();
    });
  }

  // Fetch the stored project name and ID
  Future<void> _fetchStoredProject() async {
    try {
      final projectName = await SecureStorageUtil.readSecureData("ActiveProjectName");
      setState(() {
        _projectName = projectName;
      });

      // Log the fetched project name (for debugging)
      if (_projectName != null) {
        AppLogger.info("Fetched Active Project ON Self Attedance: $_projectName");
      }
    } catch (e) {
      AppLogger.error("Error fetching project from secure storage: $e");
    }
  }


  Future<void> _init() async {
    AppLogger.info("🔄 Initializing attendance_only screen...");
    final hasPermission = await _checkAndRequestLocationPermission();

    if (hasPermission) {
      AppLogger.info("✅ Location permission granted. Fetching attendance_only data...");
      await _fetchAttendanceData();
    } else {
      AppLogger.warn("❌ Location permission denied. Showing dialog...");
      _showLocationPermissionDialog();
    }
  }

  Future<bool> _checkAndRequestLocationPermission() async {
    AppLogger.info("🔍 Checking location permission...");

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      AppLogger.warn("📛 Permission denied. Requesting permission...");
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      AppLogger.error("🚫 Location permission permanently denied.");
      return false;
    }

    final granted = permission == LocationPermission.always || permission == LocationPermission.whileInUse;
    AppLogger.info(granted
        ? "✅ Location permission granted."
        : "❌ Location permission still not granted.");

    return granted;
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("📍 Location Permission Required"),
        content: const Text("Location access is needed to mark attendance_only. Please allow it in app settings."),
        actions: [
          TextButton(
            onPressed: () {
              AppLogger.info("🔁 Opening app settings for permission...");
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
          TextButton(
            onPressed: () {
              AppLogger.warn("🚫 User cancelled location permission dialog.");
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Future<void> _fetchAttendanceData() async {
  //   AppLogger.info("📡 Starting self-attendance_only data fetch...");
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     final data = await SelfAttendanceApiService.fetchSelfAttendanceData();
  //     AppLogger.info("✅ Fetched ${data.length} self-attendance_only record(s)");
  //
  //
  //     if (data.isEmpty) {
  //       AppLogger.warn("⚠️ No self-attendance_only records found.");
  //       _error = "No attendance_only data available for today.";
  //       return;
  //     }
  //
  //     final first = data.first;
  //
  //     // Log key values from the first record
  //     AppLogger.info("🧾 Attendance Record:");
  //     AppLogger.info(" - Name: ${first.employeeName}");
  //     AppLogger.info(" - Designation: ${first.designationName}");
  //     AppLogger.info(" - In Time: ${first.inTime}");
  //     AppLogger.info(" - Out Time: ${first.outTime}");
  //     AppLogger.info(" - Hours: ${first.presentHours}");
  //     AppLogger.info(" - Status: ${first.presentHours > 0 ? 'Present' : 'Absent'}");
  //     AppLogger.info(" - Attendance ID: ${first.empAttendanceId}");
  //     AppLogger.info(" - Image In Path: ${first.inDocumentPath}");
  //     AppLogger.info(" - Image Out Path: ${first.outDocumentPath}");
  //
  //     // Helpers
  //     final formattedInTime = first.inTime != null
  //         ? DateFormat('HH:mm:ss').format(DateTime.parse(first.inTime!))
  //         : '';
  //     final formattedOutTime = first.outTime != null
  //         ? DateFormat('HH:mm:ss').format(DateTime.parse(first.outTime!))
  //         : '';
  //     final attendanceStatus = first.presentHours > 0 ? 'Present' : 'Absent';
  //     final attendanceDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //
  //     _employeeNameController.text = first.employeeName ?? '';
  //     _designationController.text = first.designationName ?? '';
  //     _empAttendanceIdController.text = first.empAttendanceId.toString();
  //     _employeeCodeController.text = first.employeeCode.toString();
  //     _inTimeController.text = formattedInTime;
  //     _outTimeController.text = formattedOutTime;
  //     _presentHoursController.text = first.presentHours.toString();
  //     _attendanceStatusController.text = attendanceStatus;
  //     _inDocumentPathController.text = first.inDocumentPath ?? 'No Image URL';
  //     _outDocumentPathController.text = first.outDocumentPath ?? 'No Image URL';
  //
  //     ref.read(checkInOutStateProvider.notifier).state = ref.read(checkInOutStateProvider.notifier).state.copyWith(
  //       checkInTime: first.inTime != null ? DateTime.parse(first.inTime!) : null,
  //       checkOutTime: first.outTime != null ? DateTime.parse(first.outTime!) : null,
  //       checkInImage: first.inDocumentPath != null ? File(first.inDocumentPath!) : null,
  //       checkOutImage: first.outDocumentPath != null ? File(first.outDocumentPath!) : null,
  //       timeDifference: (first.inTime != null && first.outTime != null)
  //           ? _calculateTimeDifference(DateTime.parse(first.inTime!), DateTime.parse(first.outTime!))
  //           : '00:00:00',
  //       empAttendanceId: first.empAttendanceId,
  //     );
  //
  //     final state = GlobalState();
  //     state.checkInTime.value = formattedInTime;
  //     state.checkOutTime.value = formattedOutTime;
  //     state.inDocumentPath.value = first.inDocumentPath;
  //     state.outDocumentPath.value = first.outDocumentPath;
  //     state.attendanceStatus.value = attendanceStatus;
  //     state.attendanceDate.value = attendanceDate;
  //     state.totalHours.value = formatDuration(Duration(minutes: first.presentHours).inMilliseconds);
  //     state.attendanceId.value = first.empAttendanceId.toString();
  //
  //     final id = first.empAttendanceId;
  //     if (id > 0) {
  //       final key = 'empAttendanceId_${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
  //       AppLogger.info("💾 Stored empAttendanceId: $id under key: $key");
  //     } else {
  //       _error = "❌ Invalid empAttendanceId: ${first.empAttendanceId}";
  //       AppLogger.error(_error!);
  //     }
  //   } catch (e) {
  //     _error = "❌ Error fetching attendance_only data: $e";
  //     AppLogger.error(_error!);
  //   } finally {
  //     setState(() => _isLoading = false);
  //     AppLogger.info("📴 Data fetch complete. isLoading = false.");
  //   }
  // }

  Future<void> _fetchAttendanceData() async {
    AppLogger.info("📡 Starting self-attendance_only data fetch...");
    setState(() => _isLoading = true);

    try {
      final data = await SelfAttendanceApiService.fetchSelfAttendanceData();
      AppLogger.info("✅ Fetched ${data.length} self-attendance_only record(s)");

      if (data.isEmpty) {
        AppLogger.warn("⚠️ No self-attendance_only records found.");
        _error = "No attendance_only data available for today.";
        return;
      }

      final first = data.first;

      AppLogger.info("🧾 Attendance Record:");
      AppLogger.info(" - Name: ${first.employeeName}");
      AppLogger.info(" - Designation: ${first.designationName}");
      AppLogger.info(" - In Time: ${first.inTime}");
      AppLogger.info(" - Out Time: ${first.outTime}");
      AppLogger.info(" - Hours: ${first.presentHours}");
      AppLogger.info(" - Status: ${first.presentHours != null && first.presentHours! > 0 ? 'Present' : 'Absent'}");
      AppLogger.info(" - Attendance ID: ${first.empAttendanceId}");
      AppLogger.info(" - Image In Path: ${first.inDocumentPath}");
      AppLogger.info(" - Image Out Path: ${first.outDocumentPath}");

      // Helpers
      String formatTime(String? timeStr) {
        try {
          return timeStr != null ? DateFormat('HH:mm:ss').format(DateTime.parse(timeStr)) : '';
        } catch (_) {
          return '';
        }
      }

      File? parseFilePath(String? path) {
        if (path == null || path.isEmpty) return null;
        final file = File(path);
        return file.existsSync() ? file : null;
      }

      String timeDifference = '00:00:00';
      if (first.inTime != null && first.outTime != null) {
        timeDifference = _calculateTimeDifference(
          DateTime.parse(first.inTime!),
          DateTime.parse(first.outTime!),
        );
      }

      final formattedInTime = formatTime(first.inTime);
      final formattedOutTime = formatTime(first.outTime);
      final attendanceStatus = (first.presentHours != null && first.presentHours! > 0) ? 'Present' : 'Absent';
      final attendanceDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      _employeeNameController.text = first.employeeName ?? '';
      _designationController.text = first.designationName ?? '';
      _empAttendanceIdController.text = first.empAttendanceId?.toString() ?? '';
      _employeeCodeController.text = first.employeeCode?.toString() ?? '';
      _inTimeController.text = formattedInTime;
      _outTimeController.text = formattedOutTime;
      _presentHoursController.text = first.presentHours?.toString() ?? '0';
      _attendanceStatusController.text = attendanceStatus;
      _inDocumentPathController.text = first.inDocumentPath ?? 'No Image URL';
      _outDocumentPathController.text = first.outDocumentPath ?? 'No Image URL';

      ref.read(checkInOutStateProvider.notifier).state = ref.read(checkInOutStateProvider.notifier).state.copyWith(
        checkInTime: first.inTime != null ? DateTime.tryParse(first.inTime!) : null,
        checkOutTime: first.outTime != null ? DateTime.tryParse(first.outTime!) : null,
        checkInImage: parseFilePath(first.inDocumentPath),
        checkOutImage: parseFilePath(first.outDocumentPath),
        timeDifference: timeDifference,
        empAttendanceId: first.empAttendanceId ?? 0,
      );

      final state = GlobalState();
      state.checkInTime.value = formattedInTime;
      state.checkOutTime.value = formattedOutTime;
      state.inDocumentPath.value = first.inDocumentPath;
      state.outDocumentPath.value = first.outDocumentPath;
      state.attendanceStatus.value = attendanceStatus;
      state.attendanceDate.value = attendanceDate;
      state.totalHours.value = formatDuration(
        Duration(minutes: first.presentHours ?? 0).inMilliseconds,
      );
      state.attendanceId.value = first.empAttendanceId?.toString() ?? '';

      final id = first.empAttendanceId ?? 0;
      if (id > 0) {
        final key = 'empAttendanceId_${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(key, id);
        AppLogger.info("💾 Stored empAttendanceId: $id under key: $key");
      } else {
        _error = "❌ Invalid empAttendanceId: ${first.empAttendanceId}";
        AppLogger.error(_error!);
      }
    } catch (e, st) {
      _error = "❌ Error fetching attendance_only data: $e";
      AppLogger.error(_error!);
    } finally {
      setState(() => _isLoading = false);
      AppLogger.info("📴 Data fetch complete. isLoading = false.");
    }
  }

  Future<void> _refreshAttendanceData() async {
    AppLogger.info("🔄 Refresh triggered...");
    await _fetchAttendanceData();

  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    _designationController.dispose();
    _empAttendanceIdController.dispose();
    _employeeCodeController.dispose();
    _inTimeController.dispose();
    _outTimeController.dispose();
    _presentHoursController.dispose();
    _attendanceStatusController.dispose();
    _inDocumentPathController.dispose();
    _outDocumentPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkInOutState = ref.watch(checkInOutStateProvider);
    final checkInOutNotifier = ref.watch(checkInOutStateProvider.notifier);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
              },
              icon: Icon(Icons.chevron_left, size: 30),
              color: AppColors.primaryBlue,
            ),
            title: AppbarHeader(
              headerName: 'Self Attendance',
              projectName: "$_projectName",
              //projectName: 'Ganesh Gloary 11',
            ),
            backgroundColor: AppColors.primaryWhitebg,
          ),
          body: RefreshIndicator(
            // onRefresh: () async {
            //   // Logic to refresh the UI (e.g., fetch new data)
            //   await ref.refresh(currentLocationProvider);
            // },
            onRefresh: _refreshAttendanceData,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  MapScreen(),
                  SizedBox(height: 16),
                  _buildTopCard(context, ref, checkInOutState, checkInOutNotifier),
                  SizedBox(height: 16),
                  _buildInOutCard(checkInOutState),
                  // SizedBox(height: 16),
                  SizedBox(height: 16),
                  _buildAttendanceTable(checkInOutState),
                ],
              ),
            ),
          ),
        ),
        // 🔵 Loader only when isLoading is true
        if (checkInOutState.isLoading)
          const Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primaryWhitebg, // More clean & sharp
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38, // Slightly darker shadow
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  //strokeWidth: 3.5, // thinner stroke for modern look
                  color: AppColors.primaryBlue, // You can set custom color
                ),
              ),
            ),
          ),


      ],
    );
  }

  Widget _buildTopCard(BuildContext context, WidgetRef ref, checkInOutState,
      checkInOutNotifier) {
    final currentTime =
        ref.watch(currentTimeProvider); // 🕒 Watch the live time

    // Fetch location as AsyncValue<LocationDetails>
    final locationAsync = ref.watch(currentLocationProvider);

    // Calculate the time difference if both check-in and check-out times are available
    String timeDifference = "00:00:00";

    if (checkInOutState.checkInTime != null) {
      final checkInTime = checkInOutState.checkInTime!;

      // If check-out time is available, stop the live update
      if (checkInOutState.checkOutTime != null) {
        final checkOutTime = checkInOutState.checkOutTime!;
        timeDifference = _calculateTimeDifference(checkInTime, checkOutTime);
      } else {
        // If check-out time is not available, calculate the live time difference
        final timeDifferenceSeconds =
            currentTime.difference(checkInTime).inSeconds;

        if (timeDifferenceSeconds < 0) {
          // Handle case where check-in time is in the future, e.g., error or reset
          timeDifference = "00:00:00";
        } else {
          timeDifference = _formatTimeFromSeconds(timeDifferenceSeconds);
        }
      }
    }

    // Split the time difference into hours, minutes, and seconds
    final timeParts = timeDifference.split(":");
    final hours = timeParts[0]; // Extract hours
    final minutes = timeParts[1]; // Extract minutes
    final seconds = timeParts[2]; // Extract seconds

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white, // Set the color of the container
        borderRadius: BorderRadius.circular(16), // Set the corner radius
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.2),
            // Light indigo shadow with opacity
            offset: Offset(4, 4),
            // Shadow offset (horizontal, vertical)
            blurRadius: 8,
            // Blur radius for the shadow
            spreadRadius: 2, // Spread radius to control the shadow's size
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/attendance/calendar.svg',
                  // Path to your SVG file
                  height: 24, // Set the desired size
                  width: 24, // Set the desired size
                ),
                SizedBox(width: 8),
                Text(DateFormat('dd MMM yyyy').format(currentTime),
                    style: TextStyle(fontSize: 16)),
                Spacer(),
                SvgPicture.asset(
                  'assets/icons/attendance/clock.svg', // Path to your SVG file
                  height: 24, // Set the desired size
                  width: 24, // Set the desired size
                ),
                SizedBox(width: 8),
                Text(DateFormat('hh:mm:ss a').format(currentTime),
                    style: TextStyle(fontSize: 16)), // live clock
              ],
            ),
            SizedBox(height: 30),
            // Time difference display (separate hours, minutes, and seconds)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display hours
                Text(
                  hours,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(':',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                // Display minutes
                Text(
                  minutes,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(':',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                // Display seconds
                Text(
                  seconds,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Your working hour’s will be calculated here",
              style: FontStyles.semiBold600.copyWith(
                color: AppColors.primaryBlackFontWithOpps60,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: checkInOutState.checkInTime == null
                  ? () => checkInOutNotifier.checkIn()
                  : checkInOutState.checkOutTime == null
                      ? () => checkInOutNotifier.checkOut()
                      : null,
              label: Text(
                checkInOutState.checkInTime == null ? "Check In" : "Check Out",
                style: FontStyles.semiBold600.copyWith(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 8),
            // Handling AsyncValue using `when` to manage loading, data, and error states
      // locationAsync.when(
      //   data: (locationDetails) {
      //
      //     AppLogger.info("Location Details: ${locationDetails.address.toString()}");
      //
      //     return Column(
      //       children: [
      //         Row(
      //           children: [
      //             SvgPicture.asset(
      //               'assets/icons/attendance/location.svg', // Path to your SVG file
      //               height: 24, // Set the desired size
      //               width: 24, // Set the desired size
      //             ),
      //             SizedBox(width: 8),
      //             Expanded(
      //               child: Text(
      //                 // Combine name, street, ISO, and country into a single line
      //                // "${locationDetails.address.toString() ?? ''}",
      //                 locationDetails.address ?? "Location not available",
      //                 overflow: TextOverflow.ellipsis,
      //                 style: TextStyle(color: Colors.grey),
      //               ),
      //             ),
      //           ],
      //         ),
      //
      //         SizedBox(height: 4),
      //         // Optionally, show latitude and longitude as well
      //         Row(
      //           children: [
      //             Icon(Icons.map, size: 20, color: Colors.indigo),
      //             SizedBox(width: 8),
      //             Expanded(
      //               child: Text(
      //                 "Lat: ${locationDetails.latitude}, Lon: ${locationDetails.longitude}",
      //                 overflow: TextOverflow.ellipsis,
      //                 style: TextStyle(color: Colors.grey),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     );
      //   },
      //   loading: () {
      //     return Row(
      //       children: [
      //         SvgPicture.asset(
      //           'assets/icons/attendance/location.svg', // Path to your SVG file
      //           height: 24, // Set the desired size
      //           width: 24, // Set the desired size
      //         ),
      //         SizedBox(width: 8),
      //         Expanded(
      //           child: Text(
      //             "Loading location...",
      //             overflow: TextOverflow.ellipsis,
      //             style: TextStyle(color: Colors.grey),
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      //   error: (error, stackTrace) {
      //     print("Error fetching location: $error");
      //     print("Stack trace: $stackTrace");
      //
      //     return Row(
      //       children: [
      //         SvgPicture.asset(
      //           'assets/icons/attendance/location.svg', // Path to your SVG file
      //           height: 24, // Set the desired size
      //           width: 24, // Set the desired size
      //         ),
      //         SizedBox(width: 8),
      //         Expanded(
      //           child: Text(
      //             "Error fetching location: $error",
      //             overflow: TextOverflow.ellipsis,
      //             style: TextStyle(color: Colors.red),
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),

      ],
        ),
      ),
    );
  }

  Widget _buildInOutCard(checkInOutState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.2),
            offset: Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (checkInOutState.checkInTime != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTimeRow(
                'assets/icons/attendance/white-clock.svg',
                "In Time",
                checkInOutState.checkInTime,
                checkInOutState.checkInImage,
              ),
            ),
          if (checkInOutState.checkOutTime != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTimeRow(
                'assets/icons/attendance/white-clock.svg',
                "Out Time",
                checkInOutState.checkOutTime,
                checkInOutState.checkOutImage,
              ),
            ),
          if (checkInOutState.checkInTime != null && checkInOutState.checkOutTime != null)
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: _buildPresentHours(checkInOutState),
            ),
        ],
      ),
    );
  }


//   Widget _buildTimeRow(String icon, String label, DateTime? time, File? image) {
//         // Printing the prefilled data to the console
//     print("Building Time Row for: $label");
//     print("Time: ${time != null ? DateFormat('hh:mm:ss a').format(time) : '--:--'}");
//     print("Image: ${image != null ? image.path : 'No Image'}");
//     print("Imagein: ${_inDocumentPathController.text}");
//     print("ImageOut: ${_outDocumentPathController.text}");
//
//     String? inImagePath = _inDocumentPathController.text.isNotEmpty ? _inDocumentPathController.text : null;
//     String? outImagePath = _outDocumentPathController.text.isNotEmpty ? _outDocumentPathController.text : null;
//
// // Print the image paths
//     print("In Image Path: $inImagePath");
//     print("Out Image Path: $outImagePath");
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         //Icon(icon, color: Colors.deepPurple, size: 24),
//         Container(
//           height: 40,
//           width: 40,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4),
//             // Set rounded corners with a radius of 4
//             color: AppColors.primaryBlue
//                 .withOpacity(0.9), // Optional background color for the icon
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SvgPicture.asset(
//               icon, // Path to your SVG file
//               height: 24, // Set the desired size
//               width: 24, // Set the desired size
//             ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           flex: 1,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 time != null ? DateFormat('hh:mm:ss a').format(time) : '--:--',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//               ),
//             ],
//           ),
//         ),
//
//
//
//         if (inImagePath != null)
//           Expanded(
//             flex: 2,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: inImagePath is String // Check if `image` is a URL (String)
//                   ? Image.network(
//                 inImagePath, // This expects a URL (String)
//                       width: 80.w,
//                       height: 60.h,
//                       fit: BoxFit.cover,
//                     ) : Container(), // Default to empty container if not a valid image type
//             ),
//           )
//         else
//           Expanded(
//             flex: 2,
//             child: Container(
//               width: 80.w,
//               height: 60.h,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.grey[300],
//               ),
//               child: Icon(Icons.camera_alt, color: Colors.grey[600]),
//             ),
//           ),
//
//         if (outImagePath != null)
//           Expanded(
//             flex: 2,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: outImagePath is String // Check if `image` is a URL (String)
//                   ? Image.network(
//                 outImagePath, // This expects a URL (String)
//                 width: 80.w,
//                 height: 60.h,
//                 fit: BoxFit.cover,
//               ) : Container(), // Default to empty container if not a valid image type
//             ),
//           )
//         else
//           Expanded(
//             flex: 2,
//             child: Container(
//               width: 80.w,
//               height: 60.h,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.grey[300],
//               ),
//               child: Icon(Icons.camera_alt, color: Colors.grey[600]),
//             ),
//           ),
//
//         // Image.network("${inImagePath}",
//         // height: 100,
//         //   width: 100,
//         // ),
//
//         // Check if image is not null
//         // Expanded(
//         //   flex: 2,
//         //   child: inImagePath != null
//         //       ? ClipRRect(
//         //     borderRadius: BorderRadius.circular(8),
//         //     child: image is String
//         //         ? Builder(
//         //       builder: (context) {
//         //         AppLogger.info('Loading network image URL: $image');
//         //         return Container(
//         //           width: 80.w,
//         //           height: 60.h,
//         //           color: Colors.grey[200],
//         //           alignment: Alignment.center,
//         //           padding: const EdgeInsets.all(8),
//         //           child: Image.network(
//         //             inImagePath,
//         //             fit: BoxFit.cover,
//         //             width: 80.w,
//         //             height: 60.h,
//         //             loadingBuilder: (context, child, loadingProgress) {
//         //               if (loadingProgress == null) return child;
//         //               return Center(child: CircularProgressIndicator());
//         //             },
//         //             errorBuilder: (context, error, stackTrace) {
//         //               return Center(
//         //                 child: Text(
//         //                   "Image not found",
//         //                   style: TextStyle(fontSize: 12.sp, color: Colors.red),
//         //                   textAlign: TextAlign.center,
//         //                 ),
//         //               );
//         //             },
//         //           ),
//         //         );
//         //       },
//         //     ) : Container(),
//         //   )
//         //       : Container(
//         //     width: 80.w,
//         //     height: 60.h,
//         //     decoration: BoxDecoration(
//         //       borderRadius: BorderRadius.circular(8),
//         //       color: Colors.grey[300],
//         //     ),
//         //     child: Icon(
//         //       Icons.camera_alt,
//         //       color: Colors.grey[600],
//         //     ),
//         //   ),
//         // )
//
//
//
//
//
//
//
//         // if (image != null)
//         //   Expanded(
//         //     flex: 2,
//         //     child: ClipRRect(
//         //       borderRadius: BorderRadius.circular(8),
//         //       child: image != null
//         //           ? (image is File
//         //       // Handle local file image
//         //           ? Image.file(
//         //         image as File,
//         //         width: 80.w,
//         //         height: 60.h,
//         //         fit: BoxFit.cover,
//         //       )
//         //       // Handle network image (string URL)
//         //           : Image.network(
//         //         image as String, // This assumes `image` is a URL (String)
//         //         width: 80.w,
//         //         height: 60.h,
//         //         fit: BoxFit.cover,
//         //         loadingBuilder: (context, child, loadingProgress) {
//         //           if (loadingProgress == null) {
//         //             return child; // Image loaded
//         //           } else {
//         //             return Center(
//         //               child: CircularProgressIndicator(
//         //                 value: loadingProgress.expectedTotalBytes != null
//         //                     ? loadingProgress.cumulativeBytesLoaded /
//         //                     (loadingProgress.expectedTotalBytes ?? 1)
//         //                     : null,
//         //               ),
//         //             );
//         //           }
//         //         },
//         //         errorBuilder: (context, error, stackTrace) {
//         //           return Center(child: Text("No Image"));
//         //         },
//         //       ))
//         //           : Container(
//         //         color: Colors.grey[300],
//         //         width: 80.w,
//         //         height: 60.h,
//         //         child: Icon(Icons.camera_alt, color: Colors.grey[600]),
//         //       ),
//         //     ),
//         //   )
//         //
//         // else
//         //   Expanded(
//         //     flex: 2,
//         //     child: ClipRRect(
//         //       borderRadius: BorderRadius.circular(8),
//         //       child: image != null
//         //           ? (image is File
//         //       // Handle local file image
//         //           ? Image.file(
//         //         image as File,
//         //         width: 80.w,
//         //         height: 60.h,
//         //         fit: BoxFit.cover,
//         //       )
//         //       // Handle network image (string URL)
//         //           : Image.network(
//         //         image as String, // This assumes `image` is a URL (String)
//         //         width: 80.w,
//         //         height: 60.h,
//         //         fit: BoxFit.cover,
//         //         loadingBuilder: (context, child, loadingProgress) {
//         //           if (loadingProgress == null) {
//         //             return child; // Image loaded
//         //           } else {
//         //             return Center(
//         //               child: CircularProgressIndicator(
//         //                 value: loadingProgress.expectedTotalBytes != null
//         //                     ? loadingProgress.cumulativeBytesLoaded /
//         //                     (loadingProgress.expectedTotalBytes ?? 1)
//         //                     : null,
//         //               ),
//         //             );
//         //           }
//         //         },
//         //         errorBuilder: (context, error, stackTrace) {
//         //           return Center(child: Text("No Image"));
//         //         },
//         //       ))
//         //           : Container(
//         //         color: Colors.grey[300],
//         //         width: 80.w,
//         //         height: 60.h,
//         //         child: Icon(Icons.camera_alt, color: Colors.grey[600]),
//         //       ),
//         //     ),
//         //   )
//       ],
//     );
//   }

  Widget _buildTimeRow(String icon, String label, DateTime? time, File? image) {
    // Get correct image path based on label
    String? imagePath;
    if (label == "In Time" && _inDocumentPathController.text.isNotEmpty) {
      imagePath = _inDocumentPathController.text;
    } else if (label == "Out Time" && _outDocumentPathController.text.isNotEmpty) {
      imagePath = _outDocumentPathController.text;
    }

    // ✅ Only show row if BOTH time and imagePath are available
    if (time == null || imagePath == null) {
      return SizedBox.shrink(); // Don't show anything
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon box
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.primaryBlue.withOpacity(0.9),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              icon,
              height: 24,
              width: 24,
            ),
          ),
        ),
        SizedBox(width: 8),

        // Time label + value
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                style: FontStyles.semiBold600.copyWith(
                  color: AppColors.primaryBlackFontWithOpps60,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                DateFormat('hh:mm:ss a').format(time),
                style: FontStyles.bold700.copyWith(
                  color: AppColors.primaryBlackFont,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Image preview
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            // child: Image.network(
            //   imagePath,
            //   width: 80.w,
            //   height: 60.h,
            //   fit: BoxFit.cover,
            //   errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
            // ),
            child: Image.network(
              imagePath,
              width: 80.w,
              height: 60.h,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child; // Image is loaded, return the image.
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  ); // Display a circular progress indicator while loading.
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image); // Display broken image icon on error.
              },
            ),

          ),
        ),
      ],
    );
  }


//   Widget _buildInOutCard(checkInOutState) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.white, // Set the color of the container
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.indigo.withOpacity(0.2),
//             offset: Offset(4, 4),
//             blurRadius: 8,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _buildTimeRow(
//               'assets/icons/attendance_only/white-clock.svg',
//               "In Time",
//               checkInOutState.checkInTime,
//               checkInOutState.checkInImage,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _buildTimeRow(
//               'assets/icons/attendance_only/white-clock.svg',
//               "Out Time",
//               checkInOutState.checkOutTime,
//               checkInOutState.checkOutImage,
//             ),
//           ),
//           Container(
//             height: 50,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: AppColors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(5),
//                 bottomRight: Radius.circular(5),
//               ),
//             ),
//             child: _buildPresentHours(checkInOutState),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimeRow(String icon, String label, DateTime? time, File? image) {
//     // Printing the prefilled data to the console
//     print("Building Time Row for: $label");
//     print("Time: ${time != null ? DateFormat('hh:mm:ss a').format(time) : '--:--'}");
//     print("Image: ${image != null ? image.path : 'No Image'}");
//     print("Imagein: ${_inDocumentPathController.text}");
//     print("ImageOut: ${_outDocumentPathController.text}");
//
//     String? inImagePath = _inDocumentPathController.text.isNotEmpty ? _inDocumentPathController.text : null;
//     String? outImagePath = _outDocumentPathController.text.isNotEmpty ? _outDocumentPathController.text : null;
//
// // Print the image paths
//     print("In Image Path: $inImagePath");
//     print("Out Image Path: $outImagePath");
//
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Icon section
//         Container(
//           height: 40,
//           width: 40,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4),
//             color: AppColors.primaryBlue.withOpacity(0.9),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SvgPicture.asset(
//               icon,
//               height: 24,
//               width: 24,
//             ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           flex: 1,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               SizedBox(height: 4),
//               // Display the time in a readable format
//               Text(
//                 time != null
//                     ? DateFormat('hh:mm:ss a').format(time)
//                     : '--:--',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//               ),
//             ],
//           ),
//         ),
//         // Image or camera placeholder section
//         Expanded(
//           flex: 2,
//           child: inImagePath != null && inImagePath.isNotEmpty
//               ? ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: inImagePath.startsWith('http') // Check if the path is a URL
//                 ? Image.network(
//               inImagePath,
//               fit: BoxFit.cover,
//               width: 80.w,
//               height: 60.h,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) {
//                   return child;
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 // More detailed error handling
//                 print("Error loading image: $error");
//                 print("Stack Trace: $stackTrace"); // Log the stack trace for more detail
//                 return Center(
//                   child: Text(
//                     "Image not found",
//                     //"Image not found\n$error",
//                     style: TextStyle(fontSize: 12.sp, color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                 );
//               },
//             )
//                 : Image.file(
//               File(inImagePath), // Handle file path
//               width: 80.w,
//               height: 60.h,
//               fit: BoxFit.cover,
//             ),
//           )
//               : Container(
//             width: 80.w,
//             height: 60.h,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.grey[300],
//             ),
//             child: Icon(
//               Icons.camera_alt,
//               color: Colors.grey[600],
//             ),
//           ),
//         ),
//
//
//       ],
//     );
//   }




  Widget _buildPresentHours(checkInOutState) {
    // Format time as HH:mm:ss
    final timeDifference = checkInOutState.timeDifference;
    final timeParts = timeDifference.split(":");
    final hours = timeParts[0]; // Extract hours
    final minutes = timeParts[1]; // Extract minutes
    final seconds = timeParts[2]; // Extract seconds

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhitebg.withOpacity(0.9),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8), // Rounded bottom-left corner
          bottomRight: Radius.circular(8), // Rounded bottom-right corner
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            // Light indigo shadow with opacity
            offset: Offset(4, 4),
            // Shadow offset (horizontal, vertical)
            blurRadius: 8,
            // Blur radius for the shadow
            spreadRadius: 2, // Spread radius to control the shadow's size
          ),
        ],
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: "Present Hours: ",
            style: TextStyle(color: Colors.black, fontSize: 18),
            children: [
              TextSpan(
                text: "$hours Hrs $minutes Min $seconds Sec",
                // Format as "05 Hrs 15 Min"
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceTable(checkInOutState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Current Attendance",
          style: FontStyles.semiBold600.copyWith(
            color: AppColors.primaryBlackFont,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
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
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/attendance/blue-calendar.svg',
                      height: 20, // ✅ Adjust size as needed
                      width: 20,
                      // color:  AppColors.primaryBlue,
                      // colorFilter: const ColorFilter.mode(
                      //   Colors.grey,
                      //   BlendMode.srcIn,
                      // ), // ✅ Set color
                    ),
                    SizedBox(width: 8.w),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        style: FontStyles.semiBold600.copyWith(
                          color: AppColors.primaryBlackFont,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Chip(
                    //   label: Text(
                    //     attendanceData!.outTime == null
                    //         ? "Checked In"
                    //         : "Checked Out",
                    //     style: TextStyle(color: Colors.purple, fontSize: 12.sp),
                    //   ),
                    //   backgroundColor: const Color(0xFFEDE7F6),
                    //   side: BorderSide.none,
                    // ),
                  ],
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 5),
                      child: Column(children: [
                        Text("In Time",
                          style: FontStyles.semiBold600.copyWith(
                            color: AppColors.primaryLightGrayFont,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          checkInOutState.checkInTime != null
                              ? DateFormat('HH:mm').format(checkInOutState.checkInTime!)
                              : '--:--',
                          style: FontStyles.bold700.copyWith(
                            color: AppColors.primaryBlackFont,
                            fontSize: 12,
                          ),
                        ),

                      ]),
                    ),
                    Container(
                      width: 2,
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xffe5dcf3),
                            Color(0xff9b79d0),
                            Color(0xffe5dcf3),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      child: Column(children: [
                        Text("Out Time",
                          style: FontStyles.bold700.copyWith(
                            color: AppColors.primaryLightGrayFont,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(checkInOutState.checkOutTime != null
                            ? DateFormat('HH:mm')
                                .format(checkInOutState.checkOutTime!)
                            : '--:--',
                          style: FontStyles.bold700.copyWith(
                            color: AppColors.primaryBlackFont,
                            fontSize: 12,
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      width: 2,
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xffe5dcf3),
                            Color(0xff9b79d0),
                            Color(0xffe5dcf3),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      child: Column(children: [
                        Text("Total Hrs",
                          style: FontStyles.semiBold600.copyWith(
                            color: AppColors.primaryLightGrayFont,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(checkInOutState.timeDifference
                            .replaceAll(":", " : "),
                          style: FontStyles.bold700.copyWith(
                            color: AppColors.primaryBlackFont,
                            fontSize: 12,
                          ),
                        ),
                      ]),
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


}
