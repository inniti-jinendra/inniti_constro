import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';

void printValue(dynamic value, {String tag = ""}) {
  try {
    // Attempt to decode the value as JSON
    var decodedJSON = json.decode(value.toString()) as Map<String, dynamic>;

    // If it's valid JSON, print it with indentation
    if (decodedJSON != null) {
      if (kDebugMode) {
        log("JSON OUTPUT: $tag ${const JsonEncoder.withIndent('  ').convert(decodedJSON)}");
      }
    } else {
      // If it's not JSON, print it as a normal value
      if (kDebugMode) {
        print("PRINT OUTPUT: $tag $value");
      }
    }
  } catch (e) {
    // If an error occurs (e.g., the value is not a valid JSON), handle it
    if (kDebugMode) {
      print("Error decoding JSON for $tag: $e");
    }

    // Print the value as-is if decoding fails
    if (kDebugMode) {
      print("PRINT OUTPUT: $tag $value");
    }
  }
}
