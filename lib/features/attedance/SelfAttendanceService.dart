import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/network/logger.dart';
import '../../../core/utils/secure_storage_util.dart';

class SelfAttendanceData {
  final String employeeName;
  final String designationName;
  final String empAttendanceId;
  final String employeeCode;
  final DateTime? inTime;
  final DateTime? outTime;
  final Duration presentHours;
  final String inDocumentPath;
  final String outDocumentPath;
  final double? latitude;
  final double? longitude;
  final String? address;

  SelfAttendanceData({
    required this.employeeName,
    required this.designationName,
    required this.empAttendanceId,
    required this.employeeCode,
    this.inTime,
    this.outTime,
    this.presentHours = Duration.zero,
    required this.inDocumentPath,
    required this.outDocumentPath,
    this.latitude,
    this.longitude,
    this.address,
  });

  // Method to convert data to JSON for sending to the server
  Map<String, dynamic> toJson() {
    return {
      'employeeName': employeeName,
      'designationName': designationName,
      'empAttendanceId': empAttendanceId,
      'employeeCode': employeeCode,
      'inTime': inTime?.toIso8601String(),
      'outTime': outTime?.toIso8601String(),
      'presentHours': presentHours.inMilliseconds,
      'inDocumentPath': inDocumentPath,
      'outDocumentPath': outDocumentPath,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  // Method to create an instance from JSON response
  factory SelfAttendanceData.fromJson(Map<String, dynamic> json) {
    return SelfAttendanceData(
      employeeName: json['employeeName'],
      designationName: json['designationName'],
      empAttendanceId: json['empAttendanceId'],
      employeeCode: json['employeeCode'],
      inTime: json['inTime'] != null ? DateTime.parse(json['inTime']) : null,
      outTime: json['outTime'] != null ? DateTime.parse(json['outTime']) : null,
      presentHours: Duration(milliseconds: json['presentHours'] ?? 0),
      inDocumentPath: json['inDocumentPath'],
      outDocumentPath: json['outDocumentPath'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
    );
  }
}



class SelfAttendanceService {
  static const String baseUrl = 'https://crudcrud.com/api/3cce3d0a2c524bb099083ed3a99e8b39/selfattendance';


// ✅ Fetch all attendance_only data
  static Future<List<SelfAttendanceData>> fetchSelfAttendanceData() async {
    try {
      final companyCode = await SharedPreferencesUtil.getString('CompanyCode');
      final activeUserID = await SharedPreferencesUtil.getString('ActiveUserID');

      AppLogger.debug("🏢 CompanyCode: $companyCode");
      AppLogger.debug("👤 UserID: $activeUserID");

      if (companyCode.isEmpty || activeUserID.isEmpty) {
        AppLogger.error('❌ Missing required credentials');
        return [];
      }

      final Uri apiUrl = Uri.parse(baseUrl);
      AppLogger.info("🌐 API URL: $apiUrl");

      final response = await http.get(apiUrl);

      AppLogger.info("📥 Response Status Code: ${response.statusCode}");
      AppLogger.debug("📄 Response Body:=>  ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);

        final filteredList = dataList.where((item) {
          return item['CompanyCode'] == companyCode &&
              item['UserID'] == int.tryParse(activeUserID);
        }).toList();

        AppLogger.info("✅ Filtered attendance_only data count: ${filteredList.length}");

        return filteredList
            .map((item) => SelfAttendanceData.fromJson(item))
            .toList();
      } else {
        AppLogger.error("❌ HTTP Error - Status Code: ${response.statusCode}");
        throw Exception('Failed to load attendance_only data');
      }
    } catch (e) {
      AppLogger.error("❌ Exception in fetchSelfAttendanceData: $e");
      rethrow;
    }
  }

  // ✅ Create (POST) a new attendance_only record
  static Future<bool> createSelfAttendance(SelfAttendanceData data) async {
    try {
      final Uri apiUrl = Uri.parse(baseUrl);

      final response = await http.post(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      AppLogger.info("📤 POST Status Code: ${response.statusCode}");
      AppLogger.debug("📄 POST Response: ${response.body}");

      return response.statusCode == 201;
    } catch (e) {
      AppLogger.error("❌ Exception in createSelfAttendance: $e");
      return false;
    }
  }

  // ✅ Update (PUT) an existing attendance_only record
  static Future<bool> updateSelfAttendance(SelfAttendanceData data) async {
    try {
      if (data.empAttendanceId.isEmpty) {
        AppLogger.error('❌ Missing ID for update');
        return false;
      }

      final Uri apiUrl = Uri.parse('$baseUrl/${data.empAttendanceId}');

      final response = await http.put(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      AppLogger.info("🔄 PUT Status Code: ${response.statusCode}");
      AppLogger.debug("📄 PUT Response: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      AppLogger.error("❌ Exception in updateSelfAttendance: $e");
      return false;
    }
  }

  // ✅ Delete a specific attendance_only record
  static Future<bool> deleteSelfAttendance(String id) async {
    try {
      if (id.isEmpty) {
        AppLogger.error('❌ Missing ID for delete');
        return false;
      }

      final Uri apiUrl = Uri.parse('$baseUrl/$id');

      final response = await http.delete(apiUrl);

      AppLogger.info("🗑️ DELETE Status Code: ${response.statusCode}");

      return response.statusCode == 200;
    } catch (e) {
      AppLogger.error("❌ Exception in deleteSelfAttendance: $e");
      return false;
    }
  }
}
