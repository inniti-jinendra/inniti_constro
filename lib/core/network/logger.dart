import 'package:flutter/foundation.dart';  // Import for kDebugMode

/// Simple Logger for debugging (Only logs in debug mode)
class AppLogger {
  static void debug(String message) {
    if (kDebugMode) print("🔹 DEBUG: $message");
  }

  static void info(String message) {
    if (kDebugMode) print("ℹ️ INFO: $message");
  }

  static void warn(String message) {
    if (kDebugMode) print("⚠️ WARNING: $message");
  }

  static void error(String message) {
    if (kDebugMode) print("❌ ERROR: $message");
  }
}



