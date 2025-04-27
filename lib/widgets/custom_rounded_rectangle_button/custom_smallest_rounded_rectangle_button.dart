import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure to import Google Fonts
import '../../core/constants/app_colors.dart'; // Your custom colors
import '../../core/constants/font_styles.dart'; // Your custom font styles

class SmallestRoundedRectangleButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  // Constructor with default values, but allows customization
  const SmallestRoundedRectangleButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor = AppColors.ColorLightGreenBG, // Default background color
    this.textColor = AppColors.ColorGreenFont, // Default text color
    this.fontSize = 8, // Adjusted font size for better visibility
    this.padding = const EdgeInsets.symmetric(horizontal: 11, vertical: 5), // Adjusted padding
    this.borderRadius = const BorderRadius.all(Radius.circular(5)), // Adjusted border radius for a more standard look
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Execute the passed callback when pressed
      child: Container(
        width: 60, // Fixed width
        height: 20, // Increased height for better text visibility
        padding: padding, // Custom padding for the button
        decoration: BoxDecoration(
          color: backgroundColor, // Background color
          borderRadius: borderRadius, // Rounded corners
        ),
        child: Center(
          child: Text(
            buttonText, // Text to be displayed on the button
            style: FontStyles.medium500.copyWith(
              color: textColor, // Custom text color
              fontSize: fontSize, // Custom font size
            ),
            // overflow: TextOverflow.ellipsis, // Handle overflow
            // maxLines: 1, // Limit to 1 line
          ),
        ),
      ),
    );
  }
}
