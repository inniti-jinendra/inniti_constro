import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inniti_constro/core/network/api_endpoints.dart';

import '../../models/LabourAttendance/LabourAttendance.dart';
import '../../network/logger.dart'; // Importing the logger
import '../../utils/secure_storage_util.dart';

class LabourAttendanceApiService {
  // Add your actual base URL here
  //final String baseUrl = "http://192.168.1.28:1010/api/LabourAttendance/Fetch-All-LabourAttendance";

  Future<List<LabourAttendance>> fetchLabourAttendance({
    required int pageNumber,
    required int pageSize,
    String? labourName,
    String? contractorName,
    String? date,
  }) async {
    AppLogger.info("🛠️ Fetching Labour Attendance Data...");

    // Fetch the token and company code
    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
    final String? companyCode = await SecureStorageUtil.readSecureData("CompanyCode");
    final String? userID = await SecureStorageUtil.readSecureData("UserID");
    final String? plantID = await SecureStorageUtil.readSecureData("ActiveProjectID");

    // Log the retrieved token and company code for debugging
    AppLogger.debug("🔑 AuthToken: $authToken");
    AppLogger.debug("🏢 CompanyCode: $companyCode");

    if (authToken == null || companyCode == null) {
      AppLogger.error('❌ Failed to retrieve authToken or CompanyCode');
      return [];
    }

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authToken, // Add your token here
    };

    final Map<String, dynamic> body = {
      "CompanyCode": companyCode,
      "UserID": userID,
      "PageNumber": pageNumber,
      "PageSize": pageSize,
      "PlantID": plantID,
      "Date": date,
      "LabourName": labourName,
      "ContractorName": contractorName,


      // "CompanyCode": "CONSTRO",
      // "UserID": 13125,
      // "PageNumber": 1,
      // "PageSize": 10,
      // "PlantID": 1000,
      // "Date": "2025-04-11",
      // "LabourName": null,
      // "ContractorName": null

    };

    // Log the request URL, headers, and body for debugging
    AppLogger.debug("➡️ API Request URL: $ApiEndpoints.fetchAllLabourAttendance");
    AppLogger.debug("➡️ Request Headers: $headers");
    AppLogger.debug("➡️ Request Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.fetchAllLabourAttendance),
        headers: headers,
        body: jsonEncode(body),
      );

      AppLogger.debug("🔹 Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Log the raw response body for debugging
        AppLogger.debug("🔹 Response Body: ${response.body}");

        if (responseData['Data'] is List) {
          // Mapping the dynamic list to a list of LabourAttendance objects
          List<LabourAttendance> labourList = (responseData['Data'] as List)
              .map((item) => LabourAttendance.fromJson(item))
              .toList();

          AppLogger.info("✅ Successfully fetched ${labourList.length} Labour Attendance records.");
          return labourList;
        } else {
          AppLogger.warn("⚠️ Invalid data format received: ${responseData['Data']}");
          return [];
        }
      } else {
        AppLogger.error("❌ Failed to fetch data: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      AppLogger.error("❌ Error fetching data: $e");
      return [];
    }
  }




  /// Fetches add labour attendance details for a specific labour on today's date
  Future<Map<String, dynamic>?> fetchLabourAttendanceadd({
    required int labourID,
  }) async {
    AppLogger.info("📥 [START] Fetching editable attendance data for LabourID: $labourID");

    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
    final String? companyCode = await SecureStorageUtil.readSecureData("CompanyCode");
    final String? plantID = await SecureStorageUtil.readSecureData("ActiveProjectID");

    AppLogger.debug("🔑 Retrieved Credentials => Token: $authToken, CompanyCode: $companyCode, PlantID: $plantID");

    if (authToken == null || companyCode == null || plantID == null) {
      AppLogger.error('❌ [AUTH] Missing authToken, CompanyCode or PlantID');
      return null;
    }


    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authToken,
    };

    final body = {
      // "CompanyCode": companyCode,
      // "PlantID": plantID,
      // "LabourID": labourID,
      // "Date": DateTime.now().toIso8601String(),

      "CompanyCode": companyCode,
      "LabourID": labourID,
      "PlantID": int.tryParse(plantID) ?? 0,
      "Date": DateTime.now().toIso8601String().split('T').first, // Today's date

    };

    AppLogger.debug("📤 [REQUEST] POST to ${ApiEndpoints.fetchLabourAttendanceAdd}");
    AppLogger.debug("📝 Headers: $headers");
    AppLogger.debug("📦 Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.fetchLabourAttendanceAdd),
        headers: headers,
        body: jsonEncode(body),
      );

      AppLogger.debug("📬 [RESPONSE] Status Code: ${response.statusCode}");
      AppLogger.debug("📨 Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        if (responseJson['Data'] is List && responseJson['Data'].isNotEmpty) {
          final record = responseJson['Data'][0];
          AppLogger.info("✅ [SUCCESS] Editable attendance record fetched: $record");
          return record;
        } else {
          AppLogger.warn("⚠️ [EMPTY] No editable attendance record found for LabourID: $labourID");
        }
      } else {
        AppLogger.error("❌ [FAIL] API failed with status ${response.statusCode}: ${response.body}");
      }
    } catch (e, stackTrace) {
      AppLogger.error("❌ [EXCEPTION] While fetching editable attendance: $e\n$stackTrace");
    }

    AppLogger.warn("🚫 [END] Returning null for LabourID: $labourID");
    return null;
  }


  /// Get labour attendance edit details for a specific LabourAttendanceID on a specific date
  Future<Map<String, dynamic>?> GetLabourAttendanceeditDetails({
    required int labourAttendanceID,
    required String date,  // Use a string for date like "2025-04-12"
  }) async {
    AppLogger.info("📥 [START] Fetching attendance data for LabourAttendanceID: $labourAttendanceID on date: $date");

    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
    final String? companyCode = await SecureStorageUtil.readSecureData("CompanyCode");
    final String? plantID = await SecureStorageUtil.readSecureData("ActiveProjectID");

    AppLogger.debug("🔑 Retrieved Credentials => Token: $authToken, CompanyCode: $companyCode, PlantID: $plantID");

    if (authToken == null || companyCode == null || plantID == null) {
      AppLogger.error('❌ [AUTH] Missing authToken, CompanyCode or PlantID');
      return null;
    }

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authToken,
    };

    final body = {
      "CompanyCode": companyCode,  // Set CompanyCode to "CONSTRO" as per the request
      "LabourAttendanceID": labourAttendanceID,
      "Date": date,  // Use the provided date string (e.g., "2025-04-12")
      "PlantID": int.tryParse(plantID) ?? 0,
    };

    AppLogger.debug("📤 [REQUEST] POST to http://192.168.1.28:1010/api/LabourAttendance/Get-LabourAttendance-Data");
    AppLogger.debug("📝 Headers: $headers");
    AppLogger.debug("📦 Body Get labour attendance edit details: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.getLabourAttendanceData),
        headers: headers,
        body: jsonEncode(body),
      );

      AppLogger.debug("📬 [RESPONSE] Status Code: ${response.statusCode}");
      AppLogger.debug("📨 Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        if (responseJson['Data'] is List && responseJson['Data'].isNotEmpty) {
          final record = responseJson['Data'][0];
          AppLogger.info("✅ [SUCCESS] Attendance record fetched: $record");
          return record;
        } else {
          AppLogger.warn("⚠️ [EMPTY] No attendance record found for LabourAttendanceID: $labourAttendanceID on date: $date");
        }
      } else {
        AppLogger.error("❌ [FAIL] API failed with status ${response.statusCode}: ${response.body}");
      }
    } catch (e, stackTrace) {
      AppLogger.error("❌ [EXCEPTION] While fetching attendance: $e\n$stackTrace");
    }

    AppLogger.warn("🚫 [END] Returning null for LabourAttendanceID: $labourAttendanceID on date: $date");
    return null;
  }


  /// Save labour attendance
  Future<Map<String, dynamic>?> saveLabourAttendance({
    required int labourID,
    required String status,
    required double overTime,
    required String overTimeRate,
    required String inTime,
    required String outTime,
    required double totalHours,
    required String base64Image,
    required String fileName,
    required double latitude,
    required double longitude,
    required String? currentLocation,
    required String labourName,
    required String labourCategory,
    required String contractorName,
    required String activityName,
    required String remark,
    required int? projectItemTypeId,
  }) async {
    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
    final String? companyCode = await SecureStorageUtil.readSecureData("CompanyCode");
    final String? plantID = await SecureStorageUtil.readSecureData("ActiveProjectID");
    final String? userID = await SecureStorageUtil.readSecureData("UserID");

    AppLogger.debug("🔑 Retrieved Credentials => Token: $authToken, CompanyCode: $companyCode, PlantID: $plantID");

    if (authToken == null || companyCode == null || plantID == null || userID == null) {
      AppLogger.error('❌ [AUTH] Missing authToken, CompanyCode or PlantID or userID');
      return null;
    }

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authToken,
    };


    final body = {
      "LABOUR_ATTENDANCEID": 0,
      "PLANT_ID": plantID,
      "LABOUR_ID": labourID,
      "DATE": DateTime.now().toIso8601String().split('T').first,
      "IS_PRESENT": status,
      "OVER_TIME": overTime,
      "OVERTIME_RATE": overTimeRate,
      "IN_TIME": inTime,
      //"OUT_TIME": outTime,
      "OUT_TIME": null,
      "TOTAL_HRS": totalHours,
      "IN_LATITUDE": latitude.toString(),
      "OUT_LONGITUDE": null,
      "IN_LONGITUDE": longitude.toString(),
      "IN_PICTURE": base64Image,
      "OUT_PICTURE": null,
      "CREATED_BY": userID,
      //"CREATED_BY": 13125,
      //"CREATED_DATE": DateTime.now().toIso8601String(),
      "CREATED_DATE": DateTime.now().toIso8601String(),
      "LAST_UPDATED_BY": 13125,
      "LAST_UPDATED_DATE": DateTime.now().toIso8601String(),
      "IS_DELETED": false,
      "IS_APPROVED": false,
      "APPROVED_BY": 0,
      "APPROVED_DATE": null,
      "IS_PAID": false,
      "REMARK": remark,
      "OUT_LATITUDE": null,
      "IN_GEOADDRESS": currentLocation,
      "OUT_GEOADDRESS": null,
      "ACTIVITY_NAME": activityName,
      "PROJECT_ITEM_TYPEID": projectItemTypeId,
      "STATUS": "PENDING",
      "CONTRACTORID": 1001,
      "companyCode": companyCode,
      "ContractorName": contractorName,
      "LabourName": labourName,
      "LabourCategory": labourCategory,
      "Base64Image": base64Image ?? "",
      "FileName": fileName,
    };

    AppLogger.debug("📤 [REQUEST] POST to Save Labor Attedance${ApiEndpoints.addLabourAttendance}");
    AppLogger.debug("📝 Headers: $headers");
    AppLogger.debug("📦 Body for Save Labor Attedance: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.addLabourAttendance),
        headers: headers,
        body: jsonEncode(body),
      );

      AppLogger.debug("📬 [RESPONSE] Status Code: ${response.statusCode}");
      AppLogger.debug("📨 Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        if (responseJson['StatusCode'] == 200) {
          AppLogger.info("✅ Attendance saved with ID: ${responseJson['Data']}");
          return {"Status": "Success", "Data": responseJson['Data']};
        } else {
          AppLogger.warn("⚠️ API Error: ${responseJson['Message']}");
        }
      } else {
        AppLogger.error("❌ API failed: ${response.statusCode} ${response.body}");
      }
    } catch (e, stackTrace) {
      AppLogger.error("❌ Exception while saving attendance: $e\n$stackTrace");
    }

    return null;
  }




  /// Edits labour attendance details for a specific labour
  Future<Map<String, dynamic>?> editLabourAttendance({
    required int labourAttendanceID,
    required int labourID,
    required String status,
    required String overtime,
    required String overtimeRate,
    required String inTime, // must be full ISO DateTime
    required String outTime, // must be full ISO DateTime
    required double totalHours,
    required int contractorID,
    required String fileName,
    required String base64Image,
    required double? latitude,
    required double? longitude,
    required String currentLocation,
    required String activityName,
    required String remark,
    required String labourName,
    required String labourCategory,
    required bool isDeleted,
    required bool isApproved,
    required dynamic approvedBy, // can be int? or dynamic depending on your backend
    required dynamic approvedDate, // can be String? or dynamic depending on format
    required bool isPaid,
    required int projectItemTypeId,
  }) async {
    AppLogger.info("📥 [START] Editing attendance data for labourAttendanceID: $labourAttendanceID");

    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
    final String? companyCodeStored = await SecureStorageUtil.readSecureData("CompanyCode");
    final String? plantID = await SecureStorageUtil.readSecureData("ActiveProjectID");
    final String? userID = await SecureStorageUtil.readSecureData("UserID");

    AppLogger.debug("📜 Company Code Stored: $companyCodeStored");


    if (authToken == null || companyCodeStored == null || plantID == null || userID == null ) {
      AppLogger.error("❌ Missing authentication or configuration data");
      return null;
    }

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authToken,
    };

    final body = {
      "LABOUR_ATTENDANCEID": labourAttendanceID,
      "PLANT_ID": int.tryParse(plantID) ?? 0,
      "LABOUR_ID": labourID,
      "DATE": DateTime.now().toIso8601String().split('T').first,
      "IS_PRESENT": status,
      "OVER_TIME": overtime,
      "OVERTIME_RATE": overtimeRate,
      "IN_TIME": inTime,   // Should be ISO8601 full datetime
      "OUT_TIME": outTime, // Should be ISO8601 full datetime
      "TOTAL_HRS": totalHours,
      "CREATED_BY": userID,
      //"CREATED_BY": 13125,
      "CREATED_DATE": DateTime.now().toIso8601String(),
      //"CREATED_DATE": null,
      "LAST_UPDATED_BY": 0,
      "LAST_UPDATED_DATE": DateTime.now().toIso8601String(),
      "STATUS": "PENDING",
      //"CONTRACTORID": 1001,
      "CONTRACTORID": contractorID,
      "companyCode": companyCodeStored,
      // if (base64Image != null && fileName != null) ...{
      //   "Base64Image": base64Image,
      //   "FileName": fileName,
      // }
      "Base64Image": base64Image,
      "FileName": fileName,
      "OUT_LATITUDE": latitude?.toString() ?? 'null',
      "OUT_LONGITUDE": longitude?.toString() ?? 'null',
      "OUT_GEOADDRESS": currentLocation,
      "ACTIVITY_NAME": activityName,
      "REMARK": remark,
      "LabourName": labourName,
      "LabourCategory": labourCategory,
      "IS_DELETED": isDeleted,
      "IS_APPROVED": isApproved,
      "APPROVED_BY": approvedBy,
      "APPROVED_DATE": approvedDate,
      "IS_PAID": isPaid,
      "PROJECT_ITEM_TYPEID": projectItemTypeId,
    };

    // final body = {
    //   "LABOUR_ATTENDANCEID": labourAttendanceID,
    //   "PLANT_ID": int.tryParse(plantID) ?? 0,
    //   "LABOUR_ID": labourID,
    //   "DATE": DateTime.now().toIso8601String().split('T').first,
    //   "IS_PRESENT": status,
    //   "OVER_TIME": overtime,
    //   "OVERTIME_RATE": overtimeRate,
    //   "IN_TIME": inTime,
    //   "OUT_TIME": outTime,
    //   "TOTAL_HRS": totalHours,
    //   "CREATED_BY": 13125,
    //   "CREATED_DATE": DateTime.now().toIso8601String(),
    //   "LAST_UPDATED_BY": 0,
    //   "LAST_UPDATED_DATE": DateTime.now().toIso8601String(),
    //   "STATUS": "PENDING",
    //   "CONTRACTORID": contractorID,
    //   "companyCode": companyCode,
    //   "Base64Image": base64Image,
    //   "FileName": fileName,
    // };


    // Log request body before sending it to the server with each key-value pair on a new line
    AppLogger.debug("📤 [Request Body] for Edit:\n${JsonEncoder.withIndent("  ").convert(body)}");


    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.editLabourAttendance),
        headers: headers,
        body: jsonEncode(body),
      );

      AppLogger.info("📡 [API Response] Status Code for Edit: ${response.statusCode}");
      AppLogger.debug("📦 [Full Response Body] for edit ${response.body}");

      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseJson['Data'] != null) {
          if (responseJson['Data'] is Map<String, dynamic>) {
            AppLogger.info("✅ [SUCCESS] Data edited successfully");
            return responseJson['Data'];
          } else {
            AppLogger.warn("⚠️ Data field is not a map. Value: ${responseJson['Data']}");
            return {"message": responseJson['Data']}; // wrap it in a map to avoid type errors
          }
        } else {
          AppLogger.warn("⚠️ No 'Data' field found in successful response.");
        }


    } else {
        AppLogger.error("❌ API request failed.");
      }
    } catch (e) {
      AppLogger.error("❌ Exception during API call: $e");
    }

    return null;
  }



}
