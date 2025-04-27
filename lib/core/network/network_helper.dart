import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'logger.dart';
import 'api_exceptions.dart';

/// **Network Helper** - Handles API Requests with Exception Handling
class NetworkHelper {
  /// **Base Request Method** - Handles all HTTP Requests
  static Future<dynamic> _request({
    required String url,
    required String method,
    Map<String, String>? headers,
    String? body,
  }) async {
    try {
      AppLogger.info('$method Request: $url');

      final uri = Uri.parse(url);
      final defaultHeaders = {'Content-Type': 'application/json'};
      final requestHeaders = {...defaultHeaders, ...?headers};

      /// **HTTP Response**
      http.Response response;

      if (method == 'GET') {
        response = await http.get(uri, headers: requestHeaders);
      } else if (method == 'POST') {
        response = await http.post(uri, headers: requestHeaders, body: body);
      } else {
        throw ApiException("Unsupported HTTP Method: $method");
      }

      /// **Logging Response**
      AppLogger.debug("Response Status: ${response.statusCode}");
      AppLogger.debug("Response Body: ${response.body}");

      /// **Error Handling**
      return _handleResponse(response);

    } on SocketException {
      throw NoInternetException();
    } on FormatException {
      throw InvalidFormatException();
    } on TimeoutException {
      throw RequestTimeoutHttpException("Request timed out.");

    } catch (e) {
      AppLogger.error("Unexpected Error: $e");
      rethrow;
    }
  }

  /// **Handles API Response**
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw HttpErrorException.fromStatusCode(response.statusCode, response.body);
    }
  }

  /// **GET Request**
  static Future<dynamic> get({required String url, Map<String, String>? headers}) {
    return _request(url: url, method: 'GET', headers: headers);
  }

  /// **POST Request**
  static Future<dynamic> post({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    return _request(
      url: url,
      method: 'POST',
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
