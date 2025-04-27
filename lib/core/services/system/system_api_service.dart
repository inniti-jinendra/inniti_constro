import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inniti_constro/core/network/api_endpoints.dart';
import '../../constants/constants.dart';
import '../../models/profile/employee_leave_details.dart';
import '../../models/profile/item_assigned_details.dart';
import '../../models/profile/salary_slip_details.dart';
import '../../models/system/dropdown_item.dart';
import '../../network/logger.dart';
import '../../utils/shared_preferences_util.dart';

class SystemApiService {
  /// Fetch Contractors from `192.168.1.24`
  static Future<List<SuppliersDDL>> fetchContractors() async {
    try {
      final companyCode = await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
      final token = await SharedPreferencesUtil.getString("GeneratedToken");

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token missing.');
      }
      if (companyCode == null || companyCode.isEmpty) {
        throw Exception('Company code is missing.');
      }

      final url = Uri.parse(ApiEndpoints.fetchContractorsDDL);
      //final url = Uri.parse('http://192.168.1.28:1010/api/DropDownHendler/Fetch-Contractors-DDL');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      final body = jsonEncode({"companyCode": companyCode});

      final response = await http.post(url, headers: headers, body: body);
      AppLogger.info('📶 Contractors API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          return jsonResponse.map((e) => SuppliersDDL.fromJson(e)).toList();
        } else if (jsonResponse.containsKey("Data")) {
          return (jsonResponse["Data"] as List).map((e) => SuppliersDDL.fromJson(e)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load Contractors. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('❌ Exception in fetchContractors: $e');
      throw Exception('Unexpected error occurred');
    }
  }

  /// Fetch Labour Categories from `192.168.1.25`
  static Future<List<LabourCategoryDLL>> fetchLabourCategories() async {
    try {
      final companyCode = await SharedPreferencesUtil.getString("CompanyCode");
      final token = await SharedPreferencesUtil.getString("GeneratedToken");

      if (token == null || token.isEmpty) {
        AppLogger.error('❌ No Auth Token found! API call aborted.');
        throw Exception('Authentication token missing.');
      }

      if (companyCode == null || companyCode.isEmpty) {
        AppLogger.error('❌ No Company Code found! API call aborted.');
        throw Exception('Company code missing.');
      }

      final url = Uri.parse(ApiEndpoints.fetchLabourCategoriesDDL);
     // final url = Uri.parse('http://192.168.1.28:1010/api/DropDownHendler/Fetch-LabourCategory-DDL');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      final requestBody = jsonEncode({"companyCode": companyCode});

      AppLogger.info('📡 Fetching Labour Categories from: $url');
      AppLogger.debug('📝 Headers: $headers');
      AppLogger.debug('📤 Request Body: $requestBody');

      final response = await http.post(url, headers: headers, body: requestBody);

      AppLogger.info('📶 Response Status Categories: ${response.statusCode}');
      AppLogger.debug('📄 API Response Categories:  ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('Data')) {
          final List<dynamic> jsonData = jsonResponse['Data'];
          AppLogger.debug('🔍 Extracted Labour Categories: ${jsonData.length}');

          return jsonData
              .map((json) => LabourCategoryDLL.fromJson(json))  // ✅ Correctly map API data
              .toList();
        } else {
          AppLogger.warn('⚠️ Unexpected API response format');
          throw Exception('Invalid API response format');
        }
      } else {
        AppLogger.error('❌ Failed to load Labour Categories. Status Code: ${response.statusCode}');
        throw Exception('Failed to load Labour Categories: ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('💥 Exception in fetchLabourCategories: $e');
      AppLogger.debug('🛠️ StackTrace: $stackTrace');
      throw Exception('Unexpected error occurred while fetching Labour Categories.');
    }
  }

  // /// Fetch Project Iteams
  // static Future<List<LabourCategoryDLL>> fetchLabourCategories() async {
  //   try {
  //     final companyCode = await SharedPreferencesUtil.getString("CompanyCode");
  //     final token = await SharedPreferencesUtil.getString("GeneratedToken");
  //
  //     if (token == null || token.isEmpty) {
  //       AppLogger.error('❌ No Auth Token found! API call aborted.');
  //       throw Exception('Authentication token missing.');
  //     }
  //
  //     if (companyCode == null || companyCode.isEmpty) {
  //       AppLogger.error('❌ No Company Code found! API call aborted.');
  //       throw Exception('Company code missing.');
  //     }
  //
  //     final url = Uri.parse(ApiEndpoints.fetchLabourCategoriesDDL);
  //    // final url = Uri.parse('http://192.168.1.28:1010/api/DropDownHendler/Fetch-LabourCategory-DDL');
  //     final headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': token,
  //     };
  //     final requestBody = jsonEncode({"companyCode": companyCode});
  //
  //     AppLogger.info('📡 Fetching Labour Categories from: $url');
  //     AppLogger.debug('📝 Headers: $headers');
  //     AppLogger.debug('📤 Request Body: $requestBody');
  //
  //     final response = await http.post(url, headers: headers, body: requestBody);
  //
  //     AppLogger.info('📶 Response Status Categories: ${response.statusCode}');
  //     AppLogger.debug('📄 API Response Categories:  ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = json.decode(response.body);
  //
  //       if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('Data')) {
  //         final List<dynamic> jsonData = jsonResponse['Data'];
  //         AppLogger.debug('🔍 Extracted Labour Categories: ${jsonData.length}');
  //
  //         return jsonData
  //             .map((json) => LabourCategoryDLL.fromJson(json))  // ✅ Correctly map API data
  //             .toList();
  //       } else {
  //         AppLogger.warn('⚠️ Unexpected API response format');
  //         throw Exception('Invalid API response format');
  //       }
  //     } else {
  //       AppLogger.error('❌ Failed to load Labour Categories. Status Code: ${response.statusCode}');
  //       throw Exception('Failed to load Labour Categories: ${response.reasonPhrase}');
  //     }
  //   } catch (e, stackTrace) {
  //     AppLogger.error('💥 Exception in fetchLabourCategories: $e');
  //     AppLogger.debug('🛠️ StackTrace: $stackTrace');
  //     throw Exception('Unexpected error occurred while fetching Labour Categories.');
  //   }
  // }

  static Future<List<CurrencyDDL>> fetchCurrencies() async {
    final companyCode = await SharedPreferencesUtil.getSharedPreferenceData(
      'CompanyCode',
    );

    final url = Uri.parse('${Constants.baseUrl}/System/GetCurrencyDDL',).replace(queryParameters: {'companyCode': companyCode});
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        var currencyDDL =
            jsonData.map((json) => CurrencyDDL.fromJson(json)).toList();
        return currencyDDL;
      } else {
        throw Exception('Failed to load currencies');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  static Future<List<ItemsDDL>> fetchItemDDl() async {
    final companyCode = await SharedPreferencesUtil.getSharedPreferenceData(
      'CompanyCode',
    );

    final url = Uri.parse(
      '${Constants.baseUrl}/System/GetItemDDL',
    ).replace(queryParameters: {'companyCode': companyCode});
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        var items = jsonData.map((json) => ItemsDDL.fromJson(json)).toList();
        return items;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  static Future<List<ItemBrandDDL>> fetchBrandDDlUsingItem(itemID) async {
    final companyCode = await SharedPreferencesUtil.getSharedPreferenceData(
      'CompanyCode',
    );

    final url = Uri.parse(
      '${Constants.baseUrl}/System/GetItemBrandDDL',
    ).replace(
      queryParameters: {
        'companyCode': companyCode,
        'itemID': itemID.toString(),
      },
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        var items =
            jsonData.map((json) => ItemBrandDDL.fromJson(json)).toList();
        return items;
      } else {
        throw Exception('Failed to load Brand');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  static Future<EmployeeLeaveDetails> fatchLeavesByUserID() async {
    final companyCode = await SharedPreferencesUtil.getSharedPreferenceData(
      'CompanyCode',
    );
    final activeUserID = await SharedPreferencesUtil.getSharedPreferenceData(
      'ActiveUserID',
    );

    final url = Uri.parse(
      '${Constants.baseUrl}/Account/GetUserDetailsLeavesByUserID',
    ).replace(
      queryParameters: {'companyCode': companyCode, 'Id': activeUserID},
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var leavedata = EmployeeLeaveDetails.fromJson(data);
      return leavedata;
    } else {
      throw Exception('Failed to fatch User Details By ID');
    }
  }

  static Future<List<SalarySlipDetails>>
  fatchUserDetailsSalarySlipListByUserID() async {
    final companyCode = await SharedPreferencesUtil.getSharedPreferenceData(
      'CompanyCode',
    );
    final activeUserID = await SharedPreferencesUtil.getSharedPreferenceData(
      'ActiveUserID',
    );

    final url = Uri.parse(
      '${Constants.baseUrl}/Account/GetUserDetailsSalarySlipListByUserID',
    ).replace(
      queryParameters: {'companyCode': companyCode, 'Id': activeUserID},
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map((json) => SalarySlipDetails.fromJson(json)).toList();
      } else {
        throw const FormatException("Invalid response format from server");
      }
    } else {
      throw Exception('Failed to fatch salary slip');
    }
  }

  static Future<List<ItemAssignedDetails>>
  fatchUserDetailsItemAssignedByUserID() async {
    final companyCode = await SharedPreferencesUtil.getSharedPreferenceData(
      'CompanyCode',
    );
    final activeUserID = await SharedPreferencesUtil.getSharedPreferenceData(
      'ActiveUserID',
    );

    final url = Uri.parse(
      '${Constants.baseUrl}/Account/GetUserDetailsItemAssignedByUserID',
    ).replace(
      queryParameters: {'companyCode': companyCode, 'Id': activeUserID},
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map((json) => ItemAssignedDetails.fromJson(json)).toList();
      } else {
        throw const FormatException("Invalid response format from server");
      }
    } else {
      throw Exception('Failed to fatch Item Assigned');
    }
  }

  static Future<ItemUOM> fetchUOMUsingItem(itemID) async {
    final companyCode = await SharedPreferencesUtil.getSharedPreferenceData(
      'CompanyCode',
    );

    final url = Uri.parse('${Constants.baseUrl}/System/GetItemUOMDDL').replace(
      queryParameters: {
        'companyCode': companyCode,
        'itemID': itemID.toString(),
      },
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final items = json.decode(response.body);
        var itemUOMs = ItemUOM.fromJson(items);
        return itemUOMs;
      } else {
        throw Exception('Failed to load UOM');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }
}
