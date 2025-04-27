import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/font_styles.dart';


class SmallRoundedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double elevation;

  // Constructor with default values, but allows customization
  const SmallRoundedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor =AppColors.primaryBlue, // Default background color
    this.textColor = AppColors.scaffoldWithBoxBackground, // Default text color
    this.fontSize = 14, // Default font size for smaller buttons
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Default padding
    this.borderRadius = const BorderRadius.all(Radius.circular(10)), // Default rounded corners
    this.elevation = 2.0, // Default elevation
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        elevation: elevation,
      ),
      child: Text(
        buttonText,
        style: FontStyles.semiBold600.copyWith(
          color: AppColors.scaffoldWithBoxBackground,
          fontSize: 16
        ),
      ),

    );
  }
}
