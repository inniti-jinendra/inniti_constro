import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/font_styles.dart';
import '../../theme/themes/app_themes.dart'; // Make sure to use your custom theme

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final bool? obscureText;

  CustomTextField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.primaryWhitebg,
            hintText: label,
            hintStyle:FontStyles.medium500.copyWith(
              fontSize: 16,
              color: AppColors.primaryBlackFont,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: FontStyles.medium500.copyWith(
            fontSize: 16,
            color: AppColors.primaryBlackFont,
          ),
          validator:
              validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return '$label cannot be empty';
                }
                return null;
              },
        ),
      ],
    );
  }
}

// First Name input
// CustomTextField(
//   label: 'First Name',
//   controller: _firstNameController,
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'First Name cannot be empty';
//     }
//     return null;
//   },
// ),
// const SizedBox(height: 16),

// // Last Name input
// CustomTextField(
//   label: 'Last Name',
//   controller: _lastNameController,
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'Last Name cannot be empty';
//     }
//     return null;
//   },
// ),
// const SizedBox(height: 16),

// // Phone Number input (numeric only)
// CustomTextField(
//   label: 'Phone Number',
//   controller: _phoneController,
//   keyboardType: TextInputType.phone,
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'Phone Number cannot be empty';
//     }
//     if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//       return 'Phone Number must be 10 digits';
//     }
//     return null;
//   },
// ),
// const SizedBox(height: 16),

// // Amount input (numeric only with 5 digit limit)
// CustomTextField(
//   label: 'Amount',
//   controller: _amountController,
//   keyboardType: TextInputType.number,
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'Amount cannot be empty';
//     }
//     if (value.length > 5) {
//       return 'Amount cannot exceed 5 digits';
//     }
//     if (!RegExp(r'^\d+$').hasMatch(value)) {
//       return 'Amount must be a valid number';
//     }
//     return null;
//   },
// ),
