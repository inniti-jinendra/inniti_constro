import 'dart:convert';
import 'dart:io';
import '../../constants/constants.dart';
import '../../models/purchase_orders/po_grid_model.dart';
import '../../models/purchase_requisition/pr_grid_model.dart';
import '../../utils/shared_preferences_util.dart';
import 'package:http/http.dart' as http;

class PoApiService {
  static Future<List<PoGrid>> fetchPoGrid(
      {required int pageNumber, required int pageSize}) async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
    final projectID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveProjectID');

    final url =
        Uri.parse('${Constants.baseUrl}/PurchaseOrders/GetPurchaseOrdersGrid')
            .replace(queryParameters: {
      'companyCode': companyCode,
      'plantID': projectID,
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => PoGrid.fromJson(json)).toList();
        } else {
          throw const FormatException("Invalid response format from server");
        }
      } else {
        throw HttpException(
          'Failed to fetch PO data: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  static Future<List<POGridItems>> fetchPoItemsGrid(
      {required int purchaseOrderID}) async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final url = Uri.parse(
            '${Constants.baseUrl}/PurchaseOrders/GetPurchaseOrdersItemsGrid')
        .replace(queryParameters: {
      'companyCode': companyCode,
      'purchaseOrderID': purchaseOrderID.toString()
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => POGridItems.fromJson(json)).toList();
        } else {
          throw const FormatException("Invalid response format from server");
        }
      } else {
        throw HttpException(
          'Failed to fetch PO Items data: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }
}
