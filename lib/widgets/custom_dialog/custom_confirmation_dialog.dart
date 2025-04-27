import 'package:flutter/material.dart';
import 'package:inniti_constro/core/constants/constants.dart';

// home page use for exiet app

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;

  const CustomConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18, // Larger title
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16), // Slightly larger text
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ❌ Cancel Button
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context), // Close dialog
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red[100], // Light red background
                  padding: const EdgeInsets.symmetric(vertical: 12), // Better spacing
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded button
                  ),
                ),
                child: Text(
                  cancelText,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 10), // Space between buttons

            // ✅ Confirm Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  onConfirm(); // Execute confirm action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue, // Custom color
                  padding: const EdgeInsets.symmetric(vertical: 12), // Consistent padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded button
                  ),
                ),
                child: Text(
                  confirmText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ✅ **Reusable Static Method**
  static Future<void> show(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = "Yes",
        String cancelText = "Cancel",
        required VoidCallback onConfirm,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (context) {
        return CustomConfirmationDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirm: onConfirm,
        );
      },
    );
  }
}

