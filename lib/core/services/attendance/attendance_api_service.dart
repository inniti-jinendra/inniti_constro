import 'dart:convert';
import '../../constants/constants.dart';
import '../../models/attendance/emp_attendance.dart';
import '../../models/attendance/self_attendance_data.dart';
import 'package:http/http.dart' as http;

import '../../utils/shared_preferences_util.dart';

class AttendanceApiService {
  static Future<SelfAttendanceData?> fatchSelfAttendanceData() async {
    try {
      final companyCode =
          await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
      final activeUserID =
          await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
      final url =
          Uri.parse('${Constants.baseUrl}/SelfAttendance/GetSelfAttendanceData')
              .replace(queryParameters: {
        'companyCode': companyCode,
        'userID': activeUserID,
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SelfAttendanceData.fromJson(data);
      } else {
        throw Exception('Failed to load attendance data');
      }
    } catch (e) {
      rethrow; // Forward the error to be handled at the call site
    }
  }

  static Future<String> addAttendance(EmpAttendance empAttendance) async {
    try {
      final companyCode =
          await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
      final activeUserID =
          await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
      final activeProjectID =
          await SharedPreferencesUtil.getSharedPreferenceData(
              'ActiveProjectID');

      empAttendance.companyCode = companyCode;
      empAttendance.userID = int.parse(activeUserID);
      empAttendance.projectID = int.parse(activeProjectID);
      empAttendance.empAttendanceID = empAttendance.empAttendanceID == ""
          ? "0"
          : empAttendance.empAttendanceID;

      final uri =
          Uri.parse('${Constants.baseUrl}/SelfAttendance/AddAttendance');
      final body = json.encode(empAttendance.toJson());
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['message'];
        return responseData.toString();
      } else {
        return "Error";
      }
    } catch (e) {
      rethrow;
    }
  }
}
