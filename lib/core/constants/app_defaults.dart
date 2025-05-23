import 'package:flutter/material.dart';

class AppDefaults {
  static const double radius = 15;
  static const double margin = 15;
  static const double padding = 15;
  static const double padding_2 = 5; //between Textbox and lable
  static const double padding_3 = 7; //between Textbox and lable
  static const double ddlSizeBoxHeight = 47;
  static const double projectNameSize = 9;

  /// Used For Border Radius
  static BorderRadius borderRadius = BorderRadius.circular(radius);

  /// Used For Bottom Sheet
  static BorderRadius bottomSheetRadius = const BorderRadius.only(
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  );

  /// Used For Top Sheet
  static BorderRadius topSheetRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(radius),
    bottomRight: Radius.circular(radius),
  );

  /// Default Box Shadow used for containers
  static List<BoxShadow> boxShadow = [
    BoxShadow(
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(0, 5),
      color: Colors.black.withOpacity(0.09),
    ),
  ];

  static Duration duration = const Duration(milliseconds: 300);
}
