import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/settings/Accessibility_model.dart';
import '../../network/logger.dart';
import '../../utils/secure_storage_util.dart';

Future<List<AccessibilityItem>> fetchAccessibilityList() async {
  const String apiUrl = 'http://13.233.153.154:2155/api/Accessibility/Fetch-All-Accessibility';

  final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
  final String? companyCode = await SecureStorageUtil.readSecureData("CompanyCode");
  final String? userID = await SecureStorageUtil.readSecureData("UserID");

  AppLogger.debug("🔑 Retrieved => Token: $authToken, CompanyCode: $companyCode, UserID: $userID");

  if (authToken == null || companyCode == null || userID == null) {
    AppLogger.error('❌ Missing Token, CompanyCode or UserID');
    return [];
  }

  final headers = {
    'Authorization': '$authToken',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'CompanyCode': companyCode,
    'UserID': int.tryParse(userID) ?? 0,
  });

  AppLogger.debug("📤 Request to $apiUrl with Body: $body");

  try {
    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    AppLogger.debug("📥 Response Code: ${response.statusCode}");
    AppLogger.debug("📥 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> dataList = data['Data'];

      return dataList.map((item) => AccessibilityItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Accessibility List');
    }
  } catch (e) {
    AppLogger.error("⚠️ Error: $e");
    rethrow;
  }
}

Future<bool> addAccessibilityItem({
  required int appMenuID,
  required bool isAccessible,
}) async {
  const String apiUrl = 'http://13.233.153.154:2155/api/Accessibility/Accessibility-Add';

  final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
  final String? companyCode = await SecureStorageUtil.readSecureData("CompanyCode");
  final String? userID = await SecureStorageUtil.readSecureData("UserID");

  if (authToken == null || companyCode == null || userID == null) {
    AppLogger.error('❌ Missing Token, CompanyCode or UserID');
    return false;
  }

  final headers = {
    'Authorization': '$authToken',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'CompanyCode': companyCode,
    'UserID': int.tryParse(userID) ?? 0,
    'AppMenuID': appMenuID,
    'Is_Accessible': isAccessible,
  });

  AppLogger.debug("📤 Request to $apiUrl with Body: $body");

  try {
    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    AppLogger.debug("📥 Response Code: ${response.statusCode}");
    AppLogger.debug("📥 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['StatusCode'] == 200) {
        AppLogger.debug("✅ Accessibility Item Updated Successfully");
        return true;
      } else {
        AppLogger.error("❌ Failed to Update Accessibility Item: ${data['Message']}");
        return false;
      }
    } else {
      throw Exception('Failed to update Accessibility Item');
    }
  } catch (e) {
    AppLogger.error("⚠️ Error: $e");
    return false;
  }
}
