import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inniti_constro/core/network/api_endpoints.dart';

import '../../constants/constants.dart';
import '../../models/account/user_details.dart';
import '../../network/logger.dart';
import '../../utils/shared_preferences_util.dart';

class ProfileAccountApiService {
  static Future<ProfileUserDetails?> fetchUserAccountDetails() async {
    try {
      final companyCode = await SharedPreferencesUtil.getString("CompanyCode");
      final userIdStr = await SharedPreferencesUtil.getString("ActiveUserID");
      final authToken = await SharedPreferencesUtil.getString("GeneratedToken");

      if (authToken == null || authToken.isEmpty) {
        AppLogger.error("❌ Auth token is missing");
        return null;
      }

      if (companyCode == null || userIdStr == null) {
        AppLogger.error("❌ Missing CompanyCode or ActiveUserID");
        return null;
      }

      final userId = int.tryParse(userIdStr);
      if (userId == null) {
        AppLogger.error("❌ Invalid UserID format");
        return null;
      }

      final url = Uri.parse(ApiEndpoints.fetchUserAccountDetails);
      final body = jsonEncode({
        'CompanyCode': companyCode,
        'UserID': userId,
      });

      AppLogger.info("🌐 API URL: $url");
      AppLogger.info("📦 Request Body: $body");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authToken,
        },
        body: body,
      );

      AppLogger.info("📡 Response Status Code: ${response.statusCode}");
      AppLogger.info("📄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['StatusCode'] == 200 &&
            decoded['Data'] != null &&
            decoded['Data'] is List &&
            decoded['Data'].isNotEmpty) {
          final userDataJson = decoded['Data'][0];
          AppLogger.info("✅ User data successfully fetched and parsed.");
          return ProfileUserDetails.fromJson(userDataJson);
        } else {
          AppLogger.error("⚠️ API responded without valid data: ${decoded['Message']}");
          return null;
        }
      } else {
        AppLogger.error("❌ HTTP error ${response.statusCode}: ${response.body}");
        return null;
      }
    } catch (e) {
      AppLogger.error("❌ Exception in fetchUserAccountDetails: $e");
      return null;
    }
  }
}
