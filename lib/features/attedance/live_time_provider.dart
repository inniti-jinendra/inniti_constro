// providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

// This will provide the live current time
final currentTimeProvider = StateNotifierProvider<CurrentTimeNotifier, DateTime>(
      (ref) => CurrentTimeNotifier(),
);

class CurrentTimeNotifier extends StateNotifier<DateTime> {
  Timer? _timer;

  CurrentTimeNotifier() : super(DateTime.now()) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      state = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
