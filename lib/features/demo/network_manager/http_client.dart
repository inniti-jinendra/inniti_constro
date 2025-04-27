import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Prints JSON or regular values with formatted output
void printValue(dynamic value, {String tag = ""}) {
  try {
    if (value is String && value.trim().startsWith('{') && value.trim().endsWith('}')) {
      // Try to decode only if it appears to be JSON
      var decodedJSON = json.decode(value) as Map<String, dynamic>;

      if (kDebugMode) {
        print("✅ JSON OUTPUT: $tag\n${const JsonEncoder.withIndent('  ').convert(decodedJSON)}");
      }
    } else {
      // Print non-JSON values or raw data
      if (kDebugMode) {
        print("📌 PRINT OUTPUT: $tag $value");
      }
    }
  } catch (e) {
    // Handle invalid JSON
    if (kDebugMode) {
      print("❌ ERROR decoding JSON for $tag: $e");
      print("📌 RAW OUTPUT: $tag $value");
    }
  }
}

class HttpHelper {

  /// GET API HANDLE
  Future<dynamic> get({
    required String url,
    bool isRequireAuthorization = false,
    String? userBearerToken,
  }) async {
    // Set default headers
    Map<String, String> apiHeaders = {
      "Content-type": "application/json",
    };

    // Add Authorization header if required
    if (isRequireAuthorization && userBearerToken != null) {
      apiHeaders['Authorization'] = 'Bearer $userBearerToken';
    }

    try {
      final apiResponse = await http.get(Uri.parse(url), headers: apiHeaders);

      // Logging with printValue function
      printValue(url, tag: "API GET URL");
      printValue(apiHeaders, tag: "API HEADERS");
      printValue(apiResponse.body, tag: "API RESPONSE");

      // Return the response using a handler method
      return _returnResponse(response: apiResponse);
    } on SocketException {
      printValue('No Internet connection', tag: "NETWORK ERROR");
      return null;
    } catch (e) {
      printValue('Error: $e', tag: "EXCEPTION");
      return null;
    }
  }

  /// POST API HANDLE
  Future<dynamic> post({
    required String url,
    required Map<String, dynamic> body,
    bool isRequireAuthorization = false,
    String? userBearerToken,
  }) async {
    // Set default headers
    Map<String, String> apiHeaders = {
      "Content-type": "application/json",
    };

    if (isRequireAuthorization && userBearerToken != null) {
      apiHeaders['Authorization'] = 'Bearer $userBearerToken';
    }

    try {
      final apiResponse = await http.post(
        Uri.parse(url),
        headers: apiHeaders,
        body: jsonEncode(body),
      );

      // Logging with printValue function
      printValue(url, tag: "API POST URL");
      printValue(apiHeaders, tag: "API HEADERS");
      printValue(body, tag: "API REQUEST BODY");
      printValue(apiResponse.body, tag: "API RESPONSE");

      return _returnResponse(response: apiResponse);
    } on SocketException {
      printValue('No Internet connection', tag: "NETWORK ERROR");
      return null;
    } catch (e) {
      printValue('Error: $e', tag: "EXCEPTION");
      return null;
    }
  }



  /// RESPONSE HANDLER
  dynamic _returnResponse({required http.Response response}) {
    printValue(response.statusCode, tag: "STATUS CODE");

    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad Request: ${response.body}');
      case 401:
        throw Exception('Unauthorized: ${response.body}');
      case 403:
        throw Exception('Forbidden: ${response.body}');
      case 404:
        throw Exception('Not Found: ${response.body}');
      case 500:
        throw Exception('Internal Server Error: ${response.body}');
      default:
        throw Exception('Failed with status code: ${response.statusCode}');
    }
  }
}
