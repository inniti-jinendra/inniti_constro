import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/global_loding/global_loader.dart';
import '../../models/auth/user_authentication_model.dart';
import '../../network/api_endpoints.dart';
import '../../network/logger.dart';
import '../../network/network_helper.dart';

// ✅ Ensure correct imports with alias
import '../../utils/secure_storage_util.dart' as SecureStorage;
import '../../utils/secure_storage_util.dart';
import '../../utils/shared_preferences_util.dart' as SharedPrefs;

/// **Authentication Service**
class AuthenticationApiService {
  /// **Verify Company Code**
  static Future<bool> verifyCompanyCode(BuildContext context, String companyCode) async {
    final url = '${ApiEndpoints.verifyCompany}?companyCode=$companyCode';

    AppLogger.info('🔹 API Request [GET]');
    AppLogger.debug('➡️ URL: $url');
    AppLogger.debug('➡️ Query Parameters: {companyCode: $companyCode}');

    GlobalLoader.show(context); // ✅ Show loader before API call

    try {
      final response = await NetworkHelper.get(url: url);

      AppLogger.info('✅ API Response [GET]');
      AppLogger.debug('➡️ Status Code: ${response['StatusCode'] ?? 'Unknown'}');
      AppLogger.debug('➡️ Response Body: $response');

      final bool exists = (response['Data'] as bool?) ?? false;

      AppLogger.info('✅ Company Exists: $exists');
      return exists;
    } catch (e) {
      AppLogger.error('❌ Failed to verify company code: $e');
      return false;
    } finally {
      GlobalLoader.hide(); // ✅ Hide loader after API call
    }
  }

  /// **Verify Mobile or Email**
  static Future<UserAuthenticationModel?> verifyMobileOrEmail({
    required BuildContext context,
    String? email,
    String? phoneNumber,
  }) async {
    final companyCode = await SharedPreferencesUtil.getString("CompanyCode", defaultValue: "CONSTRO");
    final url = ApiEndpoints.generateOtp;

    // final Map<String, dynamic> requestBody = {"CompanyCode": companyCode};
    //
    // if (email != null && email.isNotEmpty) {
    //   requestBody["EmailID"] = email;
    // } else if (phoneNumber != null && phoneNumber.isNotEmpty) {
    //   requestBody["MobileNumber"] = phoneNumber;
    // }

    final Map<String, dynamic> requestBody = {
      "CompanyCode": companyCode,
      "EmailID": email ?? "",         // ✅ Ensure "EmailID" is always included
      "MobileNumber": phoneNumber ?? ""
    };

    AppLogger.info('🔹 API Request: [POST] $url');
    AppLogger.debug('➡️ Request Body: ${jsonEncode(requestBody)}');

    GlobalLoader.show(context);

    try {
      final response = await NetworkHelper.post(
        url: url,
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      if (response['StatusCode'] == 200 && response['Data'] != null) {
        final user = UserAuthenticationModel.fromJson(response['Data']);
        await _storeUserSession(user);
        return user;
      } else {
        AppLogger.error('❌ User authentication failed');
        return null;
      }
    } catch (e) {
      AppLogger.error('Failed to verify mobile/email: $e');
      throw e;
    } finally {
      GlobalLoader.hide(); // ✅ Hide loader after API call
    }
  }

  /// ✅ Store User Session Securely
  static Future<void> _storeUserSession(UserAuthenticationModel user) async {
    await SharedPreferencesUtil.setBool('isLoggedIn', true);
    await SharedPreferencesUtil.setString("GeneratedToken", "Bearer ${user.token}");

    await SecureStorageUtil.writeSecureData("UserID", user.userId);
    await SecureStorageUtil.writeSecureData("ActiveProjectID", user.activeProjectId);
    await SecureStorageUtil.writeSecureData("EmailID", user.email);

    /// 🔹 Fix: Corrected field name for phone number
    await SecureStorageUtil.writeSecureData("MobileNo", user.mobile);

    await SecureStorageUtil.writeSecureData("UserFullName", user.fullName);
    await SecureStorageUtil.writeSecureData('userData', jsonEncode(user.toJson()));

    AppLogger.info('✅ User session stored securely');
  }
}
