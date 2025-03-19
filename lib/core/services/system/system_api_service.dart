import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';
import '../../models/profile/employee_leave_details.dart';
import '../../models/profile/item_assigned_details.dart';
import '../../models/profile/salary_slip_details.dart';
import '../../models/system/dropdown_item.dart';
import '../../utils/shared_preferences_util.dart';

class SystemApiService {
  static Future<List<SuppliersDDL>> fetchContractors() async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final url = Uri.parse('${Constants.baseUrl}/System/GetContractorsDDL')
        .replace(queryParameters: {'companyCode': companyCode});
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        var contractors =
            jsonData.map((json) => SuppliersDDL.fromJson(json)).toList();
        return contractors;
      } else {
        throw Exception('Failed to load Contractors');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  static Future<List<LabourCategoryDLL>> fetchLabourCategories() async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final url = Uri.parse('${Constants.baseUrl}/System/GetGeneralDropDown')
        .replace(queryParameters: {
      'companyCode': companyCode,
      'type': 'LABOURCATEGORY'
    });
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        var categories =
            jsonData.map((json) => LabourCategoryDLL.fromJson(json)).toList();
        return categories;
      } else {
        throw Exception('Failed to load labour categories');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  static Future<List<CurrencyDDL>> fetchCurrencies() async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final url = Uri.parse('${Constants.baseUrl}/System/GetCurrencyDDL')
        .replace(queryParameters: {'companyCode': companyCode});
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
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final url = Uri.parse('${Constants.baseUrl}/System/GetItemDDL')
        .replace(queryParameters: {'companyCode': companyCode});
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
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final url = Uri.parse('${Constants.baseUrl}/System/GetItemBrandDDL')
        .replace(queryParameters: {
      'companyCode': companyCode,
      'itemID': itemID.toString()
    });
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
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
    final activeUserID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');

    final url =
        Uri.parse('${Constants.baseUrl}/Account/GetUserDetailsLeavesByUserID')
            .replace(queryParameters: {
      'companyCode': companyCode,
      'Id': activeUserID
    });

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
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
    final activeUserID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');

    final url = Uri.parse(
            '${Constants.baseUrl}/Account/GetUserDetailsSalarySlipListByUserID')
        .replace(
            queryParameters: {'companyCode': companyCode, 'Id': activeUserID});

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
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
    final activeUserID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');

    final url = Uri.parse(
            '${Constants.baseUrl}/Account/GetUserDetailsItemAssignedByUserID')
        .replace(
            queryParameters: {'companyCode': companyCode, 'Id': activeUserID});

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
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final url = Uri.parse('${Constants.baseUrl}/System/GetItemUOMDDL').replace(
        queryParameters: {
          'companyCode': companyCode,
          'itemID': itemID.toString()
        });
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
