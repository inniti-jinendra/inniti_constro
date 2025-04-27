// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// // Time provider for managing inTime and outTime
// final timeProvider = StateNotifierProvider<TimeNotifier, TimeData>((ref) {
//   return TimeNotifier();
// });
//
//
// class TimeData {
//   final TimeOfDay? inTime;
//   final TimeOfDay? outTime;
//   final String workingHours;
//
//   TimeData({
//     this.inTime,
//     this.outTime,
//     this.workingHours = "Select both In Time and Out Time",
//   });
//
//   TimeData copyWith({
//     TimeOfDay? inTime,
//     TimeOfDay? outTime,
//     String? workingHours,
//   }) {
//     return TimeData(
//       inTime: inTime ?? this.inTime,
//       outTime: outTime ?? this.outTime,
//       workingHours: workingHours ?? this.workingHours,
//     );
//   }
// }
//
//
// class TimeNotifier extends StateNotifier<TimeData> {
//   TimeNotifier() : super(TimeData());
//
//   // Method to update In Time or Out Time
//   void updateTime(String timeType, TimeOfDay time) {
//     final newInTime = timeType == 'inTime' ? time : state.inTime;
//     final newOutTime = timeType == 'outTime' ? time : state.outTime;
//
//     // Calculate the working hours difference when inTime or outTime changes
//     String newWorkingHours = _calculateTimeDifference(newInTime, newOutTime);
//
//     state = TimeData(
//       inTime: newInTime,
//       outTime: newOutTime,
//       workingHours: newWorkingHours,
//     );
//   }
//
//   String _calculateTimeDifference(TimeOfDay? inTime, TimeOfDay? outTime) {
//     if (inTime != null && outTime != null) {
//       final now = DateTime.now();
//       final inTimeDateTime = DateTime(now.year, now.month, now.day, inTime.hour, inTime.minute);
//       final outTimeDateTime = DateTime(now.year, now.month, now.day, outTime.hour, outTime.minute);
//
//       final difference = outTimeDateTime.difference(inTimeDateTime);
//
//       final hours = difference.inHours;
//       final minutes = (difference.inMinutes % 60);
//
//       return '$hours hours and $minutes minutes';
//     } else {
//       return "Select both In Time and Out Time";
//     }
//   }
// }
//
// // Reusable TimePickerWidget for displaying time
// class TimePickerWidget extends ConsumerWidget {
//   final String title; // Label like "In Time" or "Out Time"
//   final String timeType; // Key to differentiate between "inTime" and "outTime"
//
//   TimePickerWidget({required this.title, required this.timeType});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Access the current time value from the Riverpod provider
//     final time = timeType == 'inTime'
//         ? ref.watch(timeProvider).inTime // Access inTime directly
//         : ref.watch(timeProvider).outTime; // Access outTime directly
//
//     return InkWell(
//       onTap: () async {
//         TimeOfDay? selectedTime = await showTimePicker(
//           context: context,
//           initialTime: time ?? TimeOfDay.now(), // Default to current time
//         );
//
//         if (selectedTime != null) {
//           ref
//               .read(timeProvider.notifier)
//               .updateTime(timeType, selectedTime); // Update time in provider
//         }
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(left: 1),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title, // "In Time" or "Out Time"
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey, // Change color as needed
//               ),
//             ),
//             AnimatedSwitcher(
//               duration: Duration(milliseconds: 300),
//               child: Text(
//                 time != null ? time.format(context) : '-- : --',
//                 // Display the time or placeholder
//                 key: ValueKey(time),
//                 style: GoogleFonts.nunitoSans(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black, // Change color as needed
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
// class TimePickerExample extends StatefulWidget {
//   @override
//   _TimePickerExampleState createState() => _TimePickerExampleState();
// }
//
// class _TimePickerExampleState extends State<TimePickerExample> {
//   TimeOfDay? inTime;
//   TimeOfDay? outTime;
//
//   // Function to pick time (either inTime or outTime)
//   Future<void> _selectTime(BuildContext context, bool isInTime) async {
//     final TimeOfDay initialTime =
//         isInTime ? inTime ?? TimeOfDay.now() : outTime ?? TimeOfDay.now();
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: initialTime,
//     );
//     if (picked != null) {
//       setState(() {
//         if (isInTime) {
//           inTime = picked;
//         } else {
//           outTime = picked;
//         }
//       });
//     }
//   }
//
//   // Function to calculate the time difference between inTime and outTime
//   String _calculateTimeDifference() {
//     if (inTime != null && outTime != null) {
//       // Convert TimeOfDay to DateTime for calculation
//       final now = DateTime.now();
//       final inTimeDateTime = DateTime(now.year, now.month, now.day, inTime!.hour, inTime!.minute);
//       final outTimeDateTime = DateTime(now.year, now.month, now.day, outTime!.hour, outTime!.minute);
//
//       // Calculate the difference
//       final difference = outTimeDateTime.difference(inTimeDateTime);
//
//       // Format the difference into hours and minutes
//       final hours = difference.inHours;
//       final minutes = (difference.inMinutes % 60);
//
//       // Return the formatted string
//       return '$hours hours and $minutes minutes';
//     } else {
//       return "Select both In Time and Out Time";
//     }
//   }
//
//   // _buildTimePickerRow used inside _buildInfoRow for rendering time pickers with a label
//   Widget _buildTimePickerRow(
//     String label,
//     TimeOfDay? time,
//     VoidCallback onTap,
//   ) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.nunitoSans(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey, // You can use your custom color
//             ),
//           ),
//           AnimatedSwitcher(
//             duration: Duration(milliseconds: 300),
//             child: Text(
//               time != null
//                   ? time.format(context) // Format the time
//                   : "-- : --", // Default when time is null
//               key: ValueKey(time?.format(context)),
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black, // You can use your custom color
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // _buildInfoRow to display two time pickers with a vertical divider
//   Widget _buildInfoRow(
//     String title1,
//     String value1,
//     String title2,
//     String value2,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildTimePickerRow(title1, inTime, () => _selectTime(context, true)),
//           Container(
//             width: 2, // Thin vertical divider
//             height: 30, // Divider height
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xffe5dcf3), // Transparent at the top
//                   Color(0xff9b79d0), // Stronger in the middle
//                   Color(0xffe5dcf3), // Transparent at the bottom
//                 ],
//               ),
//             ),
//           ),
//           _buildTimePickerRow(
//             title2,
//             outTime,
//             () => _selectTime(context, false),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Time Picker Example')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildInfoRow("In Time", "", "Out Time", ""),
//             SizedBox(height: 20),
//             Text(
//               'Time Difference: ${_calculateTimeDifference()}',
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/logger.dart';

// Time provider for managing inTime and outTime
final timeProvider = StateNotifierProvider<TimeNotifier, TimeData>((ref) {
  return TimeNotifier();
});

class TimeData {
  final TimeOfDay? inTime;
  final TimeOfDay? outTime;
  final String workingHours;

  TimeData({
    this.inTime,
    this.outTime,
    this.workingHours = " -- : -- ",
  });

  TimeData copyWith({
    TimeOfDay? inTime,
    TimeOfDay? outTime,
    String? workingHours,
  }) {
    return TimeData(
      inTime: inTime ?? this.inTime,
      outTime: outTime ?? this.outTime,
      workingHours: workingHours ?? this.workingHours,
    );
  }
}

class TimeNotifier extends StateNotifier<TimeData> {
  TimeNotifier() : super(TimeData());

  // Method to update In Time or Out Time
  void updateTime(String timeType, TimeOfDay time) {
    final newInTime = timeType == 'inTime' ? time : state.inTime;
    final newOutTime = timeType == 'outTime' ? time : state.outTime;

    // Calculate the working hours difference with logging
    String newWorkingHours = _calculateTimeDifference(newInTime, newOutTime);

    state = TimeData(
      inTime: newInTime,
      outTime: newOutTime,
      workingHours: newWorkingHours,
    );
  }

  // ✅ New method to clear all fields
  void reset() {
    AppLogger.info('Resetting inTime, outTime, and working hours');
    state = TimeData(); // All fields go back to initial default
  }

  // Logger-enabled method to calculate time difference
  String _calculateTimeDifference(TimeOfDay? inTime, TimeOfDay? outTime) {
    if (inTime == null || outTime == null) {
      AppLogger.info('Time not selected: In Time or Out Time is null.');
      return '--:--';
    }

    DateTime inDateTime = DateTime(2025, 1, 1, inTime.hour, inTime.minute);
    DateTime outDateTime = DateTime(2025, 1, 1, outTime.hour, outTime.minute);

    AppLogger.info('Selected In Time: ${inDateTime.toString()}');
    AppLogger.info('Selected Out Time: ${outDateTime.toString()}');

    if (outDateTime.isBefore(inDateTime)) {
      outDateTime = outDateTime.add(Duration(days: 1)); // Adjust for overnight shifts
    }

    Duration difference = outDateTime.difference(inDateTime);
    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;

    AppLogger.info('Time Difference: $hours hr(s) $minutes min(s)');

    return '$hours hr(s) $minutes min(s)';
  }
}

// class TimeNotifier extends StateNotifier<TimeData> {
//   TimeNotifier() : super(TimeData());
//
//   // Method to update In Time or Out Time
//   void updateTime(String timeType, TimeOfDay time) {
//     final newInTime = timeType == 'inTime' ? time : state.inTime;
//     final newOutTime = timeType == 'outTime' ? time : state.outTime;
//
//     // Calculate the working hours difference with logging
//     String newWorkingHours = _calculateTimeDifference(newInTime, newOutTime);
//
//     state = TimeData(
//       inTime: newInTime,
//       outTime: newOutTime,
//       workingHours: newWorkingHours,
//     );
//   }
//
//   // Logger-enabled method to calculate time difference
//   String _calculateTimeDifference(TimeOfDay? inTime, TimeOfDay? outTime) {
//     if (inTime == null || outTime == null) {
//       AppLogger.info('Time not selected: In Time or Out Time is null.');
//       return '--:--';
//     }
//
//     DateTime inDateTime = DateTime(2025, 1, 1, inTime.hour, inTime.minute);
//     DateTime outDateTime = DateTime(2025, 1, 1, outTime.hour, outTime.minute);
//
//     // Log selected In Time and Out Time
//     AppLogger.info('Selected In Time: ${inDateTime.toString()}');
//     AppLogger.info('Selected Out Time: ${outDateTime.toString()}');
//
//     if (outDateTime.isBefore(inDateTime)) {
//       outDateTime = outDateTime.add(Duration(days: 1)); // Adjust for overnight shifts
//     }
//
//     Duration difference = outDateTime.difference(inDateTime);
//     int hours = difference.inHours;
//     int minutes = difference.inMinutes % 60;
//
//     // Log the calculated time difference
//     AppLogger.info('Time Difference: $hours hr(s) $minutes min(s)');
//
//     return '$hours hr(s) $minutes min(s)';
//   }
// }


// Reusable TimePickerWidget for displaying time
class TimePickerWidget extends ConsumerWidget {
  final String title; // Label like "In Time" or "Out Time"
  final String timeType; // Key to differentiate between "inTime" and "outTime"

  TimePickerWidget({required this.title, required this.timeType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the current time value from the Riverpod provider
    final time = timeType == 'inTime'
        ? ref.watch(timeProvider).inTime // Access inTime directly
        : ref.watch(timeProvider).outTime; // Access outTime directly

    return InkWell(
      onTap: () async {
        TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(), // Default to current time
        );

        if (selectedTime != null) {
          ref.read(timeProvider.notifier).updateTime(timeType, selectedTime); // Update time in provider
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title, // "In Time" or "Out Time"
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey, // Change color as needed
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Text(
                time != null ? time.format(context) : '-- : --', // Display time or placeholder
                key: ValueKey(time),
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black, // Change color as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
