import 'package:flutter/material.dart';
import 'package:inniti_constro/core/constants/constants.dart';


// Logout page use

class CustomAlertDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "Yes",
    String cancelText = "Cancel",
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false), // Close dialog
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[100], // Light red background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Rounded button
                      ),
                    ),
                    child: Text(cancelText, style: TextStyle(color: Colors.red)),
                  ),
                ),
                SizedBox(width: 10), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true); // Close dialog first
                      onConfirm(); // Execute confirm action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue, // Custom color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded button
                      ),
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
