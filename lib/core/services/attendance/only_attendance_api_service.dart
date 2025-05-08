import 'dart:convert';
import 'package:inniti_constro/core/network/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/global_loding/global_loader.dart';
import '../../constants/constants.dart';
import '../../models/attendance/emp_attendance.dart';
import '../../models/attendance/only_attendance/details_only_self_attendance_data_models.dart';
import '../../models/attendance/only_attendance/list_only_self_attendance_data_models.dart';
import '../../models/attendance/self_attendance/self_attendance_data.dart';
import 'package:http/http.dart' as http;

import '../../network/logger.dart';
import '../../utils/shared_preferences_util.dart';

class OnlyAttendanceApiService {
  static Future<List<FetchAttendanceOnlyDetails>> fetchSelfAttendanceOnlyDetailsData() async {
    try {
      // Get required shared preferences
      final companyCode = await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
      final activeUserID = await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
      final authToken = await SharedPreferencesUtil.getString('GeneratedToken');

      // Log values for debugging
      AppLogger.debug("🔑 AuthToken: $authToken");
      AppLogger.debug("🏢 CompanyCode: $companyCode");
      AppLogger.debug("👤 UserID: $activeUserID");

      // Validate token and inputs
      if (authToken == null || companyCode == null || activeUserID == null) {
        AppLogger.error('❌ Missing token or required credentials');
        return [];
      }

      final Uri apiUrl = Uri.parse(ApiEndpoints.fetchOnlySelfAttendanceData);
      //  final Uri apiUrl = Uri.parse("http://192.168.1.28:1010/api/SelfAttendance/Fetch-SeltAttendance-Data");
      AppLogger.info("API URL: $apiUrl");

      // Define request headers
      final headers = {
        "Content-Type": "application/json",
        "Authorization": authToken,
      };

      // Request body
      final body = {
        "CompanyCode": companyCode,
        "UserID": int.tryParse(activeUserID) ?? 0,
        //"UserID": 13125,
      };

      AppLogger.info("📦 Request Body: ${jsonEncode(body)}");

      // Make the POST request
      final response = await http.post(
        apiUrl,
        headers: headers,
        body: jsonEncode(body),
      );

      AppLogger.info("📥 Response Status Code: ${response.statusCode}");
      AppLogger.debug("📄 Response Body:=> ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['StatusCode'] == 200 && responseData['Data'] != null) {
          final List<dynamic> dataList = responseData['Data'];
          AppLogger.info("✅ Attendance data parsed successfully. Count: ${dataList.length}");


          return dataList
              .map((item) => FetchAttendanceOnlyDetails.fromJson(item))
              .toList();


        } else {
          AppLogger.warn("⚠️ API returned StatusCode: ${responseData['StatusCode']} or null Data");
          return [];
        }
      } else {
        AppLogger.error("❌ HTTP error - StatusCode: ${response.statusCode}");
        throw Exception('Failed to load attendance_only data');
      }
    } catch (e) {
      AppLogger.error("❌ Exception during fetchSelfAttendanceData: $e");
      rethrow;
    }
  }

  static Future<List<FetchAttendanceOnlyList>> fetchSelfAttendanceOnlyListData(int employeeId) async {
    try {
      // Get required shared preferences
      final companyCode = await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
      final activeUserID = await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
      final authToken = await SharedPreferencesUtil.getString('GeneratedToken');

      // Log values for debugging
      AppLogger.debug("🔑 AuthToken: $authToken");
      AppLogger.debug("🏢 CompanyCode: $companyCode");
      AppLogger.debug("👤 UserID: $activeUserID");

      // Validate token and inputs
      if (authToken == null || companyCode == null || activeUserID == null) {
        AppLogger.error('❌ Missing token or required credentials');
        return [];
      }

      final Uri apiUrl = Uri.parse(ApiEndpoints.fetchOnlySelfAttendanceListData);
      //  final Uri apiUrl = Uri.parse("http://192.168.1.28:1010/api/SelfAttendance/Fetch-SeltAttendance-Data");
      AppLogger.info("API URL: $apiUrl");

      // Define request headers
      final headers = {
        "Content-Type": "application/json",
        "Authorization": authToken,
      };

      // Request body
      final body = {
        "CompanyCode": companyCode,
        //"UserID": int.tryParse(activeUserID) ?? 0,
        //"EmployeeID": 8137,
        "EmployeeID": employeeId,
      };

      AppLogger.info("📦 Request Body: ${jsonEncode(body)}");

      // Make the POST request
      final response = await http.post(
        apiUrl,
        headers: headers,
        body: jsonEncode(body),
      );

      AppLogger.info("📥 Response Status Code: ${response.statusCode}");
      AppLogger.debug("📄 Response Body:=> ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['StatusCode'] == 200 && responseData['Data'] != null) {
          final List<dynamic> dataList = responseData['Data'];
          AppLogger.info("✅ Attendance data parsed successfully. Count: ${dataList.length}");


          return dataList
              .map((item) => FetchAttendanceOnlyList.fromJson(item))
              .toList();
        } else {
          AppLogger.warn("⚠️ API returned StatusCode: ${responseData['StatusCode']} or null Data");
          return [];
        }
      } else {
        AppLogger.error("❌ HTTP error - StatusCode: ${response.statusCode}");
        throw Exception('Failed to load attendance_only data');
      }
    } catch (e) {
      AppLogger.error("❌ Exception during fetchSelfAttendanceData: $e");
      rethrow;
    }
  }


  // Add attendance_only with image, latitude, longitude, and address
  static Future<String> addAttendanceWithImage(
      String base64Image,
      String attendanceType,
      double latitude,
      double longitude,
      String geoAddress,
      DateTime? checkInTime, // Accept check-in time
      DateTime? checkOutTime, // Accept check-out time
      int empAttendanceId,    // Accept empAttendanceId
      ) async {
    try {
      // 🔄 Show the global loader
      // GlobalLoader.show(context);

      // Read SharedPreferences values
      final companyCode = await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
      final activeUserID = await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
      final activeProjectID = await SharedPreferencesUtil.getSharedPreferenceData('ActiveProjectID');
      final authToken = await SharedPreferencesUtil.getString('GeneratedToken');

      // Check if required SharedPreferences data exists
      if (companyCode == null || authToken == null || activeUserID == null || activeProjectID == null) {
        AppLogger.error("⚠️ Missing required SharedPreferences data.");
        // GlobalLoader.hide();
        return "Error: Missing required data.";
      }

      // Log the attendance_only type
      AppLogger.info("🟡 Attendance Type: $attendanceType | Attendance ID: $empAttendanceId");

      DateTime? inOutTime;

      // Set inOutTime based on attendanceType
      if (attendanceType == "IN" && checkInTime != null) {
        inOutTime = checkInTime;
      }

      AppLogger.info("📍 InOutTime set to: $inOutTime");

      // Create Attendance object
      Attendance empAttendance = Attendance(
        companyCode: companyCode,
        userID: int.tryParse(activeUserID) ?? 0,
        projectID: int.tryParse(activeProjectID) ?? 0,
        empAttendanceID: empAttendanceId,
        date: DateTime.now(),
        createdUpdateDate: DateTime.now(),
        inOutTime: inOutTime ?? DateTime.now(),
        inOutTimeBase64Image: base64Image,
        inOutTimeLatitude: latitude,
        inOutTimeLongitude: longitude,
        inOutTimeGeoAddress: geoAddress,
        fileName: 'EmpAttendancePlaceIMG.png',
        selfAttendanceType: attendanceType,
      );

      // Prepare request body
      String requestBody = json.encode(empAttendance.toJson());

      // Log request body details
      AppLogger.info("📤 Request Body:");
      AppLogger.info("companyCode: ${empAttendance.companyCode}");
      AppLogger.info("userID: ${empAttendance.userID}");
      AppLogger.info("projectID: ${empAttendance.projectID}");
      AppLogger.info("empAttendanceID: ${empAttendance.empAttendanceID}");
      AppLogger.info("date: ${empAttendance.date}");
      AppLogger.info("createdUpdateDate: ${empAttendance.createdUpdateDate}");
      AppLogger.info("inOutTime: ${empAttendance.inOutTime}");
      AppLogger.info("inOutTimeBase64Image: ${empAttendance.inOutTimeBase64Image?.substring(0, 50)}...");
      AppLogger.info("inOutTimeLatitude: ${empAttendance.inOutTimeLatitude}");
      AppLogger.info("inOutTimeLongitude: ${empAttendance.inOutTimeLongitude}");
      AppLogger.info("inOutTimeGeoAddress: ${empAttendance.inOutTimeGeoAddress}");
      AppLogger.info("fileName: ${empAttendance.fileName}");
      AppLogger.info("selfAttendanceType: ${empAttendance.selfAttendanceType}");

      // Prepare API URL and headers
      final apiUrl = Uri.parse(ApiEndpoints.saveSelfAttendance);
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "$authToken",
      };

      AppLogger.info("🌐 Sending attendance_only data to server");
      AppLogger.info("📍 API URL: $apiUrl");
      AppLogger.info("📩 Request Headers: $headers");
      AppLogger.info("📩 Request Body JSON: $requestBody");

      // Send HTTP PUT request
      final response = await http.put(apiUrl, body: requestBody, headers: headers);

      // Log the response
      AppLogger.info("📥 Response Status: ${response.statusCode}");
      AppLogger.info("📥 Response Body: ${response.body}");

      // 🔽 Hide loader after response
      GlobalLoader.hide();

      if (response.statusCode == 200) {
        AppLogger.info("✅ Attendance uploaded successfully");
        return "Success";
      } else {
        AppLogger.error("❌ Failed to upload attendance_only. Status Code: ${response.statusCode}");
        AppLogger.error("🔴 Response Body: ${response.body}");
        return "Failure";
      }
    } catch (e) {
      AppLogger.error("❌ Error during API call: $e");
      return "Error: $e";
    }
  }




  static Future<String> addAttendance(EmpAttendance empAttendance) async {
    try {
      AppLogger.info("Starting addAttendance function");

      final companyCode =
      await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
      final activeUserID =
      await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
      final activeProjectID =
      await SharedPreferencesUtil.getSharedPreferenceData('ActiveProjectID');

      AppLogger.info("Fetched SharedPreferences - CompanyCode: $companyCode, UserID: $activeUserID, ProjectID: $activeProjectID");

      empAttendance.companyCode = companyCode ?? '';
      empAttendance.userID = int.tryParse(activeUserID ?? '0') ?? 0;
      empAttendance.projectID = int.tryParse(activeProjectID ?? '0') ?? 0;
      empAttendance.empAttendanceID =
      (empAttendance.empAttendanceID?.isEmpty ?? true)
          ? "0"
          : empAttendance.empAttendanceID;

      AppLogger.info("Prepared EmpAttendance object: ${empAttendance.toJson()}");

      final apiUrl = Uri.parse('http://192.168.1.25:1016/api/SelfAttendance/Save-Self-Attendance');

      final Map<String, dynamic> body = {
        "CompanyCode": "CONSTRO",
        "EmpAttendanceID": 0,
        "Date": "2025-04-09T10:33:00",
        "UserID": 13125,
        "CreatedUpdateDate": "2025-04-09T10:33:00",
        "InOutTime": "2025-04-09T10:33:00",
        "InOutTime_Base64Image": "iVBORw0KGgoAAAANSUhEUgAAAfQAAAH0CAYAAADL1t+KAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAEwWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSfvu78nIGlkPSdXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQnPz4KPHg6eG1wbWV0YSB4bWxuczp4PSdhZG9iZTpuczptZXRhLyc+CjxyZGY6UkRGIHhtbG5zOnJkZj0naHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyc+CgogPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICB4bWxuczpBdHRyaWI9J2h0dHA6Ly9ucy5hdHRyaWJ1dGlvbi5jb20vYWRzLzEuMC8nPgogIDxBdHRyaWI6QWRzPgogICA8cmRmOlNlcT4KICAgIDxyZGY6bGkgcmRmOnBhcnNlVHlwZT0nUmVzb3VyY2UnPgogICAgIDxBdHRyaWI6Q3JlYXRlZD4yMDI1LTAzLTE5PC9BdHRyaWI6Q3JlYXRlZD4KICAgICA8QXR0cmliOkV4dElkPmY1ZjBlZDlhLWQzNzYtNDBkYy05MjU1LTM0YTRkMTA2ZjcwODwvQXR0cmliOkV4dElkPgogICAgIDxBdHRyaWI6RmJJZD41MjUyNjU5MTQxNzk1ODA8L0F0dHJpYjpGYklkPgogICAgIDxBdHRyaWI6VG91Y2hUeXBlPjI8L0F0dHJpYjpUb3VjaFR5cGU+CiAgICA8L3JkZjpsaT4KICAgPC9yZGY6U2VxPgogIDwvQXR0cmliOkFkcz4KIDwvcmRmOkRlc2NyaXB0aW9uPgoKIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PScnCiAgeG1sbnM6ZGM9J2h0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvJz4KICA8ZGM6dGl0bGU+CiAgIDxyZGY6QWx0PgogICAgPHJkZjpsaSB4bWw6bGFuZz0neC1kZWZhdWx0Jz5VbnRpdGxlZCBkZXNpZ24gLSAxPC9yZGY6bGk+CiAgIDwvcmRmOkFsdD4KICA8L2RjOnRpdGxlPgogPC9yZGY6RGVzY3JpcHRpb24+CgogPHJkZjpEZXNjcmlwdGlv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",
        "InOutTime_Latitude":"0.00",
        "InOutTime_Longitude":"0.00",
        "InOutTime_GeoAddress": "Gota",
        "ProjectID": 1000,
        "FileName": "demo.png",
        "SelfAttendanceType": "IN"
      };

      AppLogger.info("Sending POST request to $apiUrl");
      AppLogger.info("Request body: ${jsonEncode(body)}");

      final response = await http.post(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      AppLogger.info("Received response with status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        AppLogger.info("Response body: $responseData");
        return responseData['message'] ?? 'Attendance added successfully';
      } else {
        AppLogger.info("Failed to add attendance_only. Status code: ${response.statusCode}");
        return 'Failed to add attendance_only. Error: ${response.statusCode}';
      }
    } catch (e, stackTrace) {
      AppLogger.info("Exception in addAttendance: $e\nStackTrace: $stackTrace");
      return 'Something went wrong while submitting attendance_only.';
    }
  }


}