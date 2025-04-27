//
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class AttendanceState {
//   final DateTime? checkInTime;
//   final DateTime? checkOutTime;
//
//   AttendanceState({this.checkInTime, this.checkOutTime});
//
//   AttendanceState copyWith({
//     DateTime? checkInTime,
//     DateTime? checkOutTime,
//   }) {
//     return AttendanceState(
//       checkInTime: checkInTime ?? this.checkInTime,
//       checkOutTime: checkOutTime ?? this.checkOutTime,
//     );
//   }
// }
//
// class AttendanceNotifier extends StateNotifier<AttendanceState> {
//   AttendanceNotifier() : super(AttendanceState());
//
//   void togglePresent() {
//     if (state.checkInTime == null) {
//       state = state.copyWith(checkInTime: DateTime.now());
//     } else if (state.checkOutTime == null) {
//       state = state.copyWith(checkOutTime: DateTime.now());
//     } else {
//       state = AttendanceState(); // reset
//     }
//   }
// }
//
// final attendanceProvider =
// StateNotifierProvider<AttendanceNotifier, AttendanceState>(
//         (ref) => AttendanceNotifier());



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inniti_constro/features/attendance/salf_attendance.dart';

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier() : super(AttendanceState(workingDuration: Duration.zero));

  void togglePresent() {
    if (state.checkInTime == null) {
      state = state.copyWith(checkInTime: DateTime.now());
    } else {
      state = state.copyWith(checkOutTime: DateTime.now());
    }
  }

  void checkIn(DateTime time) {
    state = state.copyWith(checkInTime: time);
  }

  void checkOut(DateTime time) {
    state = state.copyWith(checkOutTime: time);
  }
}


// Provider for attendance state
final attendanceProvider =
StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  return AttendanceNotifier();
});




final capturedImagePathProvider =
StateNotifierProvider<CapturedImagePathNotifier, String>((ref) {
  return CapturedImagePathNotifier('');
});

class CapturedImagePathNotifier extends StateNotifier<String> {
  CapturedImagePathNotifier(String state) : super(state);

  void updateCapturedImagePath(String newPath) {
    state = newPath;
  }
}