import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inniti_constro/features/attendance/widget/SelectableDateWidget.dart';
import 'package:intl/intl.dart';

import '../../core/network/logger.dart';
import 'AttendanceNotifier.dart';
import 'SwipeToggleButton.dart';
import 'widget/LiveClock_widget.dart';

// Assume these providers exist
final checkInImagePathProvider = StateProvider<String?>((ref) => null);
final checkOutImagePathProvider = StateProvider<String?>((ref) => null);

class SelfAttendanceScreen extends ConsumerWidget {
  const SelfAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendance = ref.watch(attendanceProvider);
    final notifier = ref.read(attendanceProvider.notifier);
    final date = DateFormat('dd MMM yyyy').format(DateTime.now());
    final time = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTopCard(context, date, time, attendance, notifier),
            const SizedBox(height: 20),
            _buildTimeInfo(
              duration: attendance.workingDuration,
              checkInTime: attendance.checkInTime,
              checkOutTime: attendance.checkOutTime,
              ref: ref,
            ),
            const SizedBox(height: 20),
            _buildAttendanceHistory(attendance),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard(BuildContext context, String date, String time, AttendanceState state, AttendanceNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SelectableDateWidget(),
              const Spacer(),
              const Icon(Icons.access_time, color: Colors.purple),
              const SizedBox(width: 8),
              const LiveClock(),
            ],
          ),
          const SizedBox(height: 20),
          _buildDurationRow(state.workingDuration),
          const SizedBox(height: 8),
          const Center(child: Text("Your working hour’s will be calculated here")),
          const SizedBox(height: 20),
          //SwipeToggleButton(notifier: notifier),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.purple),
              const SizedBox(width: 8),
              _buildLocation(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocation(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchLocation(context),
      builder: (context, snapshot) {
        double screenWidth = MediaQuery.of(context).size.width;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading..."));
        } else if (snapshot.hasError) {
          return Tooltip(
            message: "Error fetching location",
            child: Container(
              width: screenWidth * 0.8,
              child: Text("Error fetching location", overflow: TextOverflow.ellipsis, maxLines: 1),
            ),
          );
        } else if (snapshot.hasData) {
          return Container(
            width: screenWidth * 0.7,
            child: Center(
              child: Text(snapshot.data!, overflow: TextOverflow.ellipsis, maxLines: 1),
            ),
          );
        } else {
          return const Text("Location not available.");
        }
      },
    );
  }

  Future<String> _fetchLocation(BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        return "Address not found";
      }
    } catch (e) {
      return "$e";
    }
  }

  Widget _buildDurationRow(Duration duration) {
    final hrs = duration.inHours.toString().padLeft(2, '0');
    final mins = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeBox(hrs),
        const SizedBox(width: 8),
        _buildTimeBox(mins),
        const SizedBox(width: 8),
        const Text("HRS", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTimeBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTimeInfo({
    required Duration duration,
    required DateTime? checkInTime,
    required DateTime? checkOutTime,
    required WidgetRef ref,
  }) {
    final checkInImagePath = ref.watch(checkInImagePathProvider);
    final checkOutImagePath = ref.watch(checkOutImagePathProvider);

    AppLogger.info("[_buildTimeInfo] checkInTime: $checkInTime");
    AppLogger.info("[_buildTimeInfo] checkOutTime: $checkOutTime");
    AppLogger.info("[_buildTimeInfo] checkInImagePath: $checkInImagePath");
    AppLogger.info("[_buildTimeInfo] checkOutImagePath: $checkOutImagePath");

    return Column(
      children: [
        if (checkInTime != null)
          _buildTimeRow(
            "In Time",
            DateFormat('hh:mm a').format(checkInTime),
            checkInImagePath,
            isCheckIn: true,
          ),
        const SizedBox(height: 8),
        if (checkOutTime != null)
          _buildTimeRow(
            "Out Time",
            DateFormat('hh:mm a').format(checkOutTime),
            checkOutImagePath,
            isCheckIn: false,
          ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: "Present Hours: ",
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: "${duration.inHours} Hrs ${duration.inMinutes % 60} Min",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTimeRow(String label, String time, String? imageUrl, {required bool isCheckIn}) {
    AppLogger.info("[$label Image] Path: $imageUrl");

    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.purple.withOpacity(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.access_time, color: Colors.purple),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
              Text(time, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            ],
          ),
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(12), left: Radius.circular(12)),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.file(
              File(imageUrl),
              height: 60,
              width: 230,
              fit: BoxFit.cover,
            )
                : Image.asset(
              isCheckIn
                  ? 'assets/images/in-img.svg'
                  : 'assets/images/in-img.svg',
              height: 60,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceHistory(AttendanceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Current Attendance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text(DateFormat('dd/MM/yyyy').format(DateTime.now())),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: state.isLeave
                          ? Colors.red
                          : state.isPresent
                          ? Colors.green
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      state.isLeave
                          ? "Leave"
                          : state.isPresent
                          ? "Present"
                          : "Absent",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAttendanceColumn("In Time", "09:25"),
                  _buildAttendanceColumn("Out Time", "07:55"),
                  _buildAttendanceColumn("Total Hrs.", "10 Hrs. 30 Min"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}





// Attendance state and provider classes
class AttendanceState {
  final Duration workingDuration;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final bool isPresent;
  final bool isLeave;

  AttendanceState({
    required this.workingDuration,
    this.checkInTime,
    this.checkOutTime,
    this.isPresent = false,
    this.isLeave = false,
  });

  AttendanceState copyWith({
    Duration? workingDuration,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    bool? isPresent,
    bool? isLeave,
  }) {
    return AttendanceState(
      workingDuration: workingDuration ?? this.workingDuration,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      isPresent: isPresent ?? this.isPresent,
      isLeave: isLeave ?? this.isLeave,
    );
  }
}

