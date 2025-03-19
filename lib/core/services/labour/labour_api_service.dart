import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
// import '../../../app/constants/constants.dart';
// import '../../models/labour/labour_master.dart';
import '../../constants/constants.dart';
import '../../models/labour/labour_grid_model.dart';
import '../../models/labour/labour_master.dart';
import '../../utils/shared_preferences_util.dart';
// import '../../models/labour/labour_grid_view_model.dart';

class LabourApiService {
  static Future<List<LabourGrid>> fetchLabours({
    required int pageNumber,
    required int pageSize,
  }) async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final url = Uri.parse('${Constants.baseUrl}/Labour/GetLabourGrid')
        .replace(queryParameters: {
      'companyCode': companyCode,
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => LabourGrid.fromJson(json)).toList();
        } else {
          throw const FormatException("Invalid response format from server");
        }
      } else {
        throw HttpException(
          'Failed to fetch labour data: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  static Future<Labour> fatchLabourByID({required int id}) async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final url = Uri.parse('${Constants.baseUrl}/Labour/GetLabourByID').replace(
        queryParameters: {'companyCode': companyCode, 'Id': id.toString()});

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Labour.fromJson(data); // Ensure Labour has a fromJson method
      } else {
        throw HttpException(
          'Failed to fetch labour data: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  static Future<String> createUpdateLabour(Labour labour) async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
    final activeUserID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
    labour.companyCode = companyCode;
    Uri uri;
    if (labour.labourID > 0) {
      labour.lastUpdatedBy = int.parse(activeUserID);
      uri = Uri.parse('${Constants.baseUrl}/Labour/UpdateLabour');
    } else {
      labour.createdBy = int.parse(activeUserID);
      uri = Uri.parse('${Constants.baseUrl}/Labour/AddLabour');
    }

    final body = json.encode(labour.toJson());
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
  }

  static Future<String> deleteLabour(int id) async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
    final activeUserID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');

    Uri uri = Uri.parse('${Constants.baseUrl}/Labour/DeleteLabour').replace(
        queryParameters: {
          'companyCode': companyCode,
          'labourID': id.toString(),
          'deletedBy': activeUserID
        });

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    final response = await http.post(uri, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['message'];
      return responseData.toString();
    } else {
      return "Error";
    }
  }
}
