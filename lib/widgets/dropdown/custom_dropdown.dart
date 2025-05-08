//
// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:flutter/material.dart';
//
// class CommonDropdown<T> extends StatelessWidget {
//   final String hintText;
//   final List<T> items;
//   final T? initialItem;
//   final String Function(T) getItemName;
//   final void Function(T) onChanged;
//
//   const CommonDropdown({
//     Key? key,
//     required this.hintText,
//     required this.items,
//     required this.getItemName,
//     required this.onChanged,
//     this.initialItem,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomDropdown<String>.search(
//       hintText: hintText,
//       items: items.map(getItemName).toList(),
//       initialItem: initialItem != null ? getItemName(initialItem!) : '',
//       onChanged: (value) {
//         final selectedItem = items.firstWhere(
//               (item) => getItemName(item) == value,
//           orElse: () => items.first,
//         );
//         onChanged(selectedItem);
//       },
//     );
//   }
// }



import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CommonDropdown<T> extends StatelessWidget {
  final String hintText;
  final List<T> items;
  final T? initialItem;
  final String Function(T) getItemName;
  final void Function(T) onChanged;

  const CommonDropdown({
    Key? key,
    required this.hintText,
    required this.items,
    required this.getItemName,
    required this.onChanged,
    this.initialItem,
  }) : super(key: key);

  // Create CustomDropdownDecoration with red accent light gray background
  CustomDropdownDecoration _dropdownDecoration() {
    return CustomDropdownDecoration(
      expandedFillColor: AppColors.scaffoldWithBoxBackground,
      closedFillColor: AppColors.primaryWhitebg,
      hintStyle: TextStyle(color: AppColors.primaryBlackFont),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.search(
      hintText: hintText,
      items: items.map(getItemName).toList(),
      initialItem: initialItem != null ? getItemName(initialItem!) : '',
      onChanged: (value) {
        final selectedItem = items.firstWhere(
              (item) => getItemName(item) == value,
          orElse: () => items.first,
        );
        onChanged(selectedItem);
      },
      decoration: _dropdownDecoration(), // Apply the decoration here
    );
  }
}

class CommonDropdownCustom<T> extends StatelessWidget {
  final String? hintText;
  final List<T> items;
  final T? initialItem;
  final String Function(T) getItemName;
  final void Function(T) onChanged;

  const CommonDropdownCustom({
    Key? key,
    this.hintText,
    required this.items,
    required this.getItemName,
    required this.onChanged,
    this.initialItem,
  }) : super(key: key);

  CustomDropdownDecoration _dropdownDecoration() {
    return CustomDropdownDecoration(
      expandedFillColor: AppColors.scaffoldWithBoxBackground,
      closedFillColor: AppColors.primaryWhitebg,
      hintStyle: TextStyle(color: AppColors.primaryBlackFont),
      prefixIcon: initialItem == null
          ? const SizedBox.shrink() // 🔴 Hide icon if no item selected
          : null, // ✅ Default icon otherwise
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = ['-- Select --', ...items.map(getItemName)];

    return CustomDropdown<String>.search(
      hintText: hintText ?? "-- Select --", // ✅ Show placeholder if nothing selected
      items:  displayItems,
      initialItem: initialItem != null ? getItemName(initialItem!) : "-- Select --", // 🔁 Nothing selected by default

      onChanged: (value) {
        if (value == '-- Select --') return;

        final selectedItem = items.firstWhere(
              (item) => getItemName(item) == value,
          orElse: () => items.first,
        );
        onChanged(selectedItem);
      },
      decoration: _dropdownDecoration(),
    );
  }
}


