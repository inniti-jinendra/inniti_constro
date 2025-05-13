import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/fuel_inward/fuel_inward_models.dart';
import '../../network/api_endpoints.dart';
import '../../network/logger.dart';
import '../../utils/secure_storage_util.dart';

// class FuelInwardApiService {
//   Future<List<FuelPurchase>> fetchFuelPurchaseList({
//     required int pageNumber,
//     required int fromDate,
//     required int toDate,
//     required int pageSize,
//   }) async {
//     final Uri url = Uri.parse(ApiEndpoints.fetchFuelPurchaseList);
//
//     final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
//     final String? companyCode = await SecureStorageUtil.readSecureData("CompanyCode");
//     final String? userId = await SharedPreferencesUtil.getString("ActiveUserID");
//     final String? plantID = await SecureStorageUtil.readSecureData("ActiveProjectID");
//
//     AppLogger.debug("🔑 AuthToken: $authToken");
//     AppLogger.debug("🏢 CompanyCode: $companyCode");
//
//     if (authToken == null || companyCode == null) {
//       AppLogger.error('❌ Failed to retrieve authToken or CompanyCode');
//       return [];
//     }
//
//     final Map<String, String> headers = {
//       "Content-Type": "application/json",
//       "Authorization": authToken,
//     };
//
//     final Map<String, dynamic> body = {
//       "CompanyCode": companyCode,
//       "PageNumber": pageNumber,
//       "PageSize": pageSize,
//      // "UserID": userId,
//       "UserID": 10139,
//       //"PlantID": plantID,
//       "PlantID": 3003,
//       "FromDate": "2025-04-01",
//       "ToDate": "2025-04-30",
//       "SupplierName": null,
//       "GRNNumber": null,
//       "InwardDate": null
//     };
//
//     AppLogger.debug("➡️ API Request URL: $url");
//     AppLogger.debug("➡️ Request Headers: $headers");
//     AppLogger.debug("➡️ Request Body: ${jsonEncode(body)}");
//
//     try {
//       final response = await http.post(
//         url,
//         headers: headers,
//         body: jsonEncode(body),
//       );
//
//       AppLogger.debug("🔹 Response Status Code: ${response.statusCode}");
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//
//         AppLogger.debug("🔹 Response Body fuel_inward: ${response.body}");
//
//         if (responseData['Data'] is List) {
//           List<dynamic> dataList = responseData['Data'];
//
//           AppLogger.debug("🔹 Response Data: $dataList");
//
//           return dataList.map((json) => FuelPurchase.fromJson(json)).toList();
//         } else {
//           AppLogger.warn("Invalid data format received: ${responseData['Data']}");
//           return [];
//         }
//       } else {
//         AppLogger.error("❌ Failed to fetch fuel purchase list. Status code: ${response.statusCode}");
//         throw Exception("Failed to fetch fuel purchase list");
//       }
//     } catch (e) {
//       AppLogger.warn("Error fetching fuel purchase list: $e");
//       return [];
//     }
//   }
// }

class FuelInwardApiService {
  Future<List<FuelPurchase>> fetchFuelPurchaseList({
    required int pageNumber,
    required int pageSize,
    required DateTime fromDate,
    required DateTime toDate,
    String? supplierName,
    String? grnNumber,
    String? inwardDate,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.fetchFuelPurchaseList);

    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
    final String? companyCode = await SecureStorageUtil.readSecureData("CompanyCode");
    final String? userId = await SharedPreferencesUtil.getString("ActiveUserID");
    final String? plantID = await SecureStorageUtil.readSecureData("ActiveProjectID");

    AppLogger.debug("🔑 AuthToken: $authToken");
    AppLogger.debug("🏢 CompanyCode: $companyCode");

    if (authToken == null || companyCode == null) {
      AppLogger.error('❌ Failed to retrieve authToken or CompanyCode');
      return [];
    }

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authToken,
    };

    final Map<String, dynamic> body = {
      "CompanyCode": companyCode,
      "PageNumber": pageNumber,
      "PageSize": pageSize,
      "UserID": userId ?? 10139,
      //"UserID": 10139,
      //"UserID": 13125,
      "PlantID": plantID ?? 3003,
      //"PlantID": 3003,
      "FromDate": "${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
      //"FromDate":null,
      "ToDate": "${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
     //"ToDate": null,
      "SupplierName": supplierName,
      "GRNNumber": grnNumber,
      "InwardDate": inwardDate
    };

    AppLogger.debug("➡️ API Request URL: $url");
    AppLogger.debug("➡️ Request Headers: $headers");
    AppLogger.debug("➡️ Request Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      AppLogger.debug("🔹 Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        AppLogger.debug("🔹 Response Body fuel_inward: ${response.body}");

        if (responseData['Data'] is List) {
          List<dynamic> dataList = responseData['Data'];

          AppLogger.debug("🔹 Response Data: $dataList");

          return dataList.map((json) => FuelPurchase.fromJson(json)).toList();
        } else {
          AppLogger.warn("Invalid data format received: ${responseData['Data']}");
          return [];
        }
      } else {
        AppLogger.error("❌ Failed to fetch fuel purchase list. Status code: ${response.statusCode}");
        throw Exception("Failed to fetch fuel purchase list");
      }
    } catch (e) {
      AppLogger.warn("Error fetching fuel purchase list: $e");
      return [];
    }
  }
}
