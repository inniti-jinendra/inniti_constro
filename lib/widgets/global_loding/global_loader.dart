import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// **Global Loader Utility with Enhanced UI/UX**
class GlobalLoader {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false; // ✅ Prevent multiple instances

  /// ✅ **Show Loader**
  static void show(BuildContext context) {
    if (_isShowing) return; // Prevent multiple loaders from being displayed

    if (!context.mounted) return; // Ensure context is valid

    _isShowing = true; // Mark loader as showing

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 🔹 Blurred Glassmorphism Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
            child: Container(
              color: Colors.black.withOpacity(0.3), // Semi-transparent overlay
            ),
          ),

          // 🔹 Centered Animated Loader
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              // decoration: BoxDecoration(
              //   color: Colors.white.withOpacity(0.9), // Soft white container
              //   borderRadius: BorderRadius.circular(15),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withOpacity(0.2),
              //       blurRadius: 10,
              //       spreadRadius: 2,
              //     ),
              //   ],
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lottie.asset(
                  //   'assets/loti/loder/animated_loder_hand.json', // ✅ Replace with your animation
                  //   // width: 120,
                  //   // height: 120,
                  // ),
                  CircularProgressIndicator(),
                  // const SizedBox(height: 10),
                  // const Text(
                  //   "Please wait...",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    try {
      // ✅ Ensure Overlay is available before inserting
      if (context.mounted) {
        Overlay.of(context)?.insert(_overlayEntry!);
      }
    } catch (e) {
      print("❌ Error inserting overlay: $e");
    }
  }

  /// ✅ **Hide Loader**
  static void hide() {
    if (_overlayEntry != null && _isShowing) {
      try {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _isShowing = false; // ✅ Reset flag when the loader is hidden
      } catch (e) {
        print("❌ Error hiding overlay: $e");
      }
    }
  }
}
