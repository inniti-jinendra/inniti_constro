// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';  // For formatting the time
//
// // Define a state class to hold the check-in and check-out times
// class CheckInOutState {
//   final String? checkInTime;
//   final String? checkOutTime;
//
//   CheckInOutState({this.checkInTime, this.checkOutTime});
//
//   // Copy method to update check-in and check-out times
//   CheckInOutState copyWith({String? checkInTime, String? checkOutTime}) {
//     return CheckInOutState(
//       checkInTime: checkInTime ?? this.checkInTime,
//       checkOutTime: checkOutTime ?? this.checkOutTime,
//     );
//   }
// }
//
// // Define the provider to manage check-in/check-out state
// final checkInOutProvider = StateNotifierProvider<CheckInOutNotifier, CheckInOutState>(
//       (ref) => CheckInOutNotifier(),
// );
//
// // Create a notifier to manage the check-in/check-out times
// class CheckInOutNotifier extends StateNotifier<CheckInOutState> {
//   CheckInOutNotifier() : super(CheckInOutState());
//
//   // Method to set the check-in time
//   void setCheckInTime(String time) {
//     state = state.copyWith(checkInTime: time);
//   }
//
//   // Method to set the check-out time
//   void setCheckOutTime(String time) {
//     state = state.copyWith(checkOutTime: time);
//   }
//
// }
//
// // Riverpod provider for the check-in time (using DateTime instead of String)
// final checkInTimeProvider = StateProvider<DateTime?>((ref) => null);
//
// // Riverpod provider for the current time (every second)
// final currentTimeProvider = StreamProvider<DateTime>((ref) {
//   return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
// });
//
// // Riverpod provider for the calculated time difference (in seconds)
// final timeDifferenceProvider = Provider<int>((ref) {
//   final checkInTime = ref.watch(checkInTimeProvider);
//   final currentTime = DateTime.now();
//
//   if (checkInTime != null) {
//     return currentTime.difference(checkInTime).inSeconds;
//   }
//   return 0;
// });
//
// // Riverpod provider to get the formatted current time (HH:mm:ss)
// final formattedCurrentTimeProvider = Provider<String>((ref) {
//   // Access the currentTimeProvider and handle AsyncValue properly
//   final currentTime = ref.watch(currentTimeProvider);
//
//   return currentTime.when(
//     data: (data) => DateFormat('HH:mm:ss').format(data),
//     loading: () => 'Loading...',  // Show loading text until data is available
//     error: (error, stackTrace) => 'Error',  // Handle error case
//   );
// });
//
// // Flag to avoid repeated logging when checkInTime is null
// final hasLoggedWarningProvider = StateProvider<bool>((ref) => false);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';  // For formatting the time

// Define a state class to hold the check-in and check-out times
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/attendance/self_attendance/self_attendance_data.dart';
import '../../core/network/logger.dart';
import '../../core/services/attendance/attendance_api_service.dart';

class CheckInOutState {
  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  CheckInOutState({this.checkInTime, this.checkOutTime});

  CheckInOutState copyWith({DateTime? checkInTime, DateTime? checkOutTime}) {
    return CheckInOutState(
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
    );
  }
}

class CheckInOutNotifier extends StateNotifier<CheckInOutState> {
  CheckInOutNotifier() : super(CheckInOutState());

  void setCheckInTime(DateTime time) {
    state = state.copyWith(checkInTime: time);
  }

  void setCheckOutTime(DateTime time) {
    state = state.copyWith(checkOutTime: time);
  }

  void clearCheckInOut() {
    state = CheckInOutState();
  }
}

final checkInOutProvider =
StateNotifierProvider<CheckInOutNotifier, CheckInOutState>((ref) {
  return CheckInOutNotifier();
});


// Riverpod provider for the check-in time (using DateTime instead of String)
final checkInTimeProvider = StateProvider<DateTime?>((ref) => null);

// Riverpod provider for the current time (every second)
final currentTimeProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

// Riverpod provider for the calculated time difference (in seconds)
final timeDifferenceProvider = Provider<int>((ref) {
  final checkInTime = ref.watch(checkInTimeProvider);
  final currentTime = DateTime.now();
  ref.read(checkInTimeProvider.notifier).state = currentTime;

  if (checkInTime != null) {
    return currentTime.difference(checkInTime).inSeconds;
  }
  return 0;
});

// Riverpod provider to get the formatted current time (HH:mm:ss)
final formattedCurrentTimeProvider = Provider<String>((ref) {
  final currentTime = ref.watch(currentTimeProvider);

  return currentTime.when(
    data: (data) => DateFormat('HH:mm:ss').format(data),
    loading: () => 'Loading...',  // Show loading text until data is available
    error: (error, stackTrace) => 'Error',  // Handle error case
  );
});

// Flag to avoid repeated logging when checkInTime is null
final hasLoggedWarningProvider = StateProvider<bool>((ref) => false);


final empAttendanceIdProvider = StateProvider<int?>((ref) => null);

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});


final selfAttendanceProvider = FutureProvider<List<SelfAttendanceData>>((ref) async {
  // Fetch the response from the API (which now returns a list)
  final attendanceDataList = await SelfAttendanceApiService.fetchSelfAttendanceData();

  if (attendanceDataList.isEmpty) {
    throw Exception("No attendance_only data available");
  }

  // Log the first object in the list (if available)
  final firstAttendanceRecord = attendanceDataList.first;
  AppLogger.info("📦 First attendance_only record: $firstAttendanceRecord");

  // Log specific fields of the first attendance_only record for better clarity
  AppLogger.info("🔍 First attendance_only record - empAttendanceId: ${firstAttendanceRecord.empAttendanceId}");
  AppLogger.info("🔍 First attendance_only record - inTime: ${firstAttendanceRecord.inTime}");
  AppLogger.info("🔍 First attendance_only record - outTime: ${firstAttendanceRecord.outTime}");

  // Return the list of SelfAttendanceData
  return attendanceDataList;
});
