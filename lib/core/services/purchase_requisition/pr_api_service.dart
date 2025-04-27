import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';
import '../../models/purchase_requisition/pr_grid_model.dart';
import '../../models/purchase_requisition/pr_master_model.dart';
import '../../utils/shared_preferences_util.dart';

class PrApiService {
  static Future<List<PrGrid>> fetchPRGrid(
      {required int pageNumber,
      required int pageSize,
      required String requisitionNumber,
      required String requisitionDate,
      required String status,
      required String requestedBy,
      required String itemName}) async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
    final projectID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveProjectID');
    final userID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');

    final url = Uri.parse(
            '${Constants.baseUrl}/PurchaseRequisition/GetPurchaseRequisitionGrid')
        .replace(queryParameters: {
      'companyCode': companyCode,
      'userID': userID,
      'plantID': projectID,
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
      'requisitionNumber': requisitionNumber.toString(),
      'requisitionDate': requisitionDate.toString(),
      'status': status.toString(),
      'requestedBy': requestedBy.toString(),
      'itemName': itemName.toString(),
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => PrGrid.fromJson(json)).toList();
        } else {
          throw const FormatException("Invalid response format from server");
        }
      } else {
        throw HttpException(
          'Failed to fetch PR data: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  // static Future<Labour> fatchLabourByID({required int id}) async {
  //   final companyCode =
  //       await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

  //   final url = Uri.parse('${Constants.baseUrl}/Labour/GetLabourByID').replace(
  //       queryParameters: {'companyCode': companyCode, 'Id': id.toString()});

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);
  //       return Labour.fromJson(data); // Ensure Labour has a fromJson method
  //     } else {
  //       throw HttpException(
  //         'Failed to fetch labour data: ${response.statusCode} ${response.reasonPhrase}',
  //       );
  //     }
  //   } catch (e) {
  //     throw Exception('Unexpected error occurred: $e');
  //   }
  // }

  // static Future<String> createUpdateLabour(Labour labour) async {
  //   final companyCode =
  //       await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
  //   final activeUserID =
  //       await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
  //   labour.companyCode = companyCode;
  //   Uri uri;
  //   if (labour.labourID > 0) {
  //     labour.lastUpdatedBy = int.parse(activeUserID);
  //     uri = Uri.parse('${Constants.baseUrl}/Labour/UpdateLabour');
  //   } else {
  //     labour.createdBy = int.parse(activeUserID);
  //     uri = Uri.parse('${Constants.baseUrl}/Labour/AddLabour');
  //   }

  //   final body = json.encode(labour.toJson());
  //   final headers = {
  //     "Content-Type": "application/json",
  //     "Accept": "application/json",
  //   };
  //   final response = await http.post(uri, headers: headers, body: body);

  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body)['message'];
  //     return responseData.toString();
  //   } else {
  //     return "Error";
  //   }
  // }

  // static Future<String> deleteLabour(int id) async {
  //   final companyCode =
  //       await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
  //   final activeUserID =
  //       await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');

  //   Uri uri = Uri.parse('${Constants.baseUrl}/Labour/DeleteLabour').replace(
  //       queryParameters: {
  //         'companyCode': companyCode,
  //         'labourID': id.toString(),
  //         'deletedBy': activeUserID
  //       });

  //   final headers = {
  //     "Content-Type": "application/json",
  //     "Accept": "application/json",
  //   };
  //   final response = await http.post(uri, headers: headers);

  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body)['message'];
  //     return responseData.toString();
  //   } else {
  //     return "Error";
  //   }
  // }

  static Future<String> savePR(PrMasterModel prMaster) async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
    final activeUserID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
    final projectID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveProjectID');

    prMaster.companyCode = companyCode;
    Uri uri;
    prMaster.userID = int.parse(activeUserID);
    prMaster.plantID = int.parse(projectID);
    prMaster.requisitionfor = "PR";
    uri = Uri.parse(
        '${Constants.baseUrl}/PurchaseRequisition/AddPurchaseRequisition');

    final body = json.encode(prMaster.toJson());
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
}
