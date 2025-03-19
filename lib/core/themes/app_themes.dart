import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_defaults.dart';

class AppTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      colorSchemeSeed: AppColors.primary,
      fontFamily: "Gilroy",
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.placeholder),
        bodyMedium: TextStyle(color: AppColors.placeholder),
      ),
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        elevation: 0.3,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "Gilroy",
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(AppDefaults.padding),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppDefaults.borderRadius,
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(AppDefaults.padding),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppDefaults.borderRadius,
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Gilroy',
          ),
        ),
      ),
      inputDecorationTheme: inputDecorationThemeNew,
      sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.always,
        thumbColor: Colors.white,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.placeholder,
        labelPadding: EdgeInsets.all(AppDefaults.padding),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.placeholder,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardColor,
        shadowColor: Colors.black26,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /* <---- Input Decorations Theme -----> */
  // static const defaultInputDecorationTheme = InputDecorationTheme(
  //   fillColor: AppColors.textInputBackground,
  //   floatingLabelBehavior: FloatingLabelBehavior.never,
  //   border: OutlineInputBorder(
  //     borderSide: BorderSide(width: 0.1),
  //     borderRadius: BorderRadius.all(Radius.circular(8)),
  //   ),
  //   enabledBorder: OutlineInputBorder(
  //     borderSide: BorderSide(width: 0.1),
  //     borderRadius: BorderRadius.all(Radius.circular(8)),
  //   ),
  //   focusedBorder: OutlineInputBorder(
  //     borderSide: BorderSide(width: 0.1),
  //     borderRadius: BorderRadius.all(Radius.circular(8)),
  //   ),
  //   suffixIconColor: AppColors.placeholder,
  // );

  static const secondaryInputDecorationTheme = InputDecorationTheme(
    fillColor: AppColors.textInputBackground,
    filled: true,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
  );

  static final otpInputDecorationTheme = InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(
      borderSide: const BorderSide(width: 0.1),
      borderRadius: BorderRadius.circular(25),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 0.1),
      borderRadius: BorderRadius.circular(25),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 0.1),
      borderRadius: BorderRadius.circular(25),
    ),
  );

  static final inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade700, width: 2),
    ),
    labelStyle: TextStyle(fontSize: 16, color: Colors.grey.shade600),
    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
    errorStyle: TextStyle(
        fontSize: 13, color: Colors.red.shade600, fontWeight: FontWeight.w500),
  );

  static final inputDecorationThemeNew = InputDecorationTheme(
    isDense: true, // Reduces height to match dropdown
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 10, vertical: 11), // Adjusted padding

    // Border styles
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.blue.shade600, width: 1),
    ),

    // Adjusted text styles to match dropdown
    hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
    labelStyle: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
    floatingLabelStyle: TextStyle(
        fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade600),
  );

  static CustomDropdownDecoration mapInputDecorationToDropdown() {
    return CustomDropdownDecoration(
      closedFillColor: inputDecorationThemeNew.fillColor ?? Colors.white,
      expandedFillColor: inputDecorationThemeNew.fillColor ?? Colors.white,

      // Border Styles
      closedBorder: Border.all(
        color: (inputDecorationThemeNew.enabledBorder as OutlineInputBorder?)
                ?.borderSide
                .color ??
            Colors.grey.shade300,
        width: 1,
      ),
      closedBorderRadius:
          (inputDecorationThemeNew.enabledBorder as OutlineInputBorder?)
                  ?.borderRadius ??
              BorderRadius.circular(8),

      // Error Border Styles
      closedErrorBorder: Border.all(
        color: (inputDecorationThemeNew.errorBorder as OutlineInputBorder?)
                ?.borderSide
                .color ??
            Colors.red.shade400,
        width: 1.5,
      ),
      closedErrorBorderRadius:
          (inputDecorationThemeNew.errorBorder as OutlineInputBorder?)
                  ?.borderRadius ??
              BorderRadius.circular(8),

      // 🔥 Reduce font size
      hintStyle: TextStyle(fontSize: 10, color: Colors.grey.shade500),
      headerStyle: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
      errorStyle: inputDecorationThemeNew.errorStyle,

      // ✅ Reduce font size for selected item
      listItemStyle: const TextStyle(fontSize: 12, color: Colors.black),

      // ✅ Reduce font size for dropdown list items
      // menuTextStyle: TextStyle(fontSize: 12, color: Colors.black),

      // ✅ Reduce font size for search field text
      searchFieldDecoration: SearchFieldDecoration(
        textStyle: const TextStyle(fontSize: 12, color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
    );
  }

  // static final inputDecorationThemeNew = InputDecorationTheme(
  //   isDense: true, // Reduces the default height
  //   filled: true,
  //   fillColor: Colors.white,
  //   contentPadding: const EdgeInsets.symmetric(
  //       horizontal: 10, vertical: 6), // Compact padding

  //   // Border styles
  //   border: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(8), // Slightly rounded corners
  //     borderSide: BorderSide(color: Colors.grey.shade300),
  //   ),
  //   enabledBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(8),
  //     borderSide: BorderSide(color: Colors.grey.shade300),
  //   ),
  //   focusedBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(8),
  //     borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
  //   ),
  //   errorBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(8),
  //     borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
  //   ),
  //   focusedErrorBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(8),
  //     borderSide: BorderSide(color: Colors.red.shade700, width: 2),
  //   ),

  //   // Text styles
  //   hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
  //   labelStyle: const TextStyle(
  //       fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
  //   floatingLabelStyle: TextStyle(
  //       fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade600),
  //   errorStyle: TextStyle(
  //       fontSize: 10, color: Colors.red.shade600, fontWeight: FontWeight.w500),
  // );

  // static CustomDropdownDecoration mapInputDecorationToDropdown() {
  //   return CustomDropdownDecoration(
  //     closedFillColor: inputDecorationThemeNew.fillColor ?? Colors.white,
  //     expandedFillColor: inputDecorationThemeNew.fillColor ?? Colors.white,
  //     closedBorder: Border.all(
  //       color: (inputDecorationThemeNew.enabledBorder as OutlineInputBorder?)
  //               ?.borderSide
  //               .color ??
  //           Colors.grey,
  //       width: (inputDecorationThemeNew.enabledBorder as OutlineInputBorder?)
  //               ?.borderSide
  //               .width ??
  //           1,
  //     ),
  //     closedBorderRadius:
  //         (inputDecorationThemeNew.enabledBorder as OutlineInputBorder?)
  //                 ?.borderRadius ??
  //             BorderRadius.circular(4),
  //     closedErrorBorder: Border.all(
  //       color: (inputDecorationThemeNew.errorBorder as OutlineInputBorder?)
  //               ?.borderSide
  //               .color ??
  //           Colors.red,
  //       width: (inputDecorationThemeNew.errorBorder as OutlineInputBorder?)
  //               ?.borderSide
  //               .width ??
  //           1,
  //     ),
  //     closedErrorBorderRadius:
  //         (inputDecorationThemeNew.errorBorder as OutlineInputBorder?)
  //                 ?.borderRadius ??
  //             BorderRadius.circular(4),
  //     hintStyle: inputDecorationThemeNew.hintStyle,
  //     headerStyle: inputDecorationThemeNew.labelStyle,
  //     errorStyle: inputDecorationThemeNew.errorStyle,
  //   );
  // }
}
