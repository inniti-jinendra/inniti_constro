import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inniti_constro/core/network/api_endpoints.dart';

import '../../models/dropdownhendler/contractors_ddl.dart';
import '../../models/dropdownhendler/labour_category_ddl.dart';
import '../../models/dropdownhendler/projectItem_ddl.dart';
import '../../models/dropdownhendler/project_ddl.dart';
import '../../network/logger.dart';
import '../../utils/secure_storage_util.dart';

class DropDownHendlerApi {
  //final String baseUrl = "http://192.168.1.28:1010/api/DropDownHendler";

  /// Fetch Project Dropdown List
  Future<List<Project>> fetchProject() async {
    final url = Uri.parse(ApiEndpoints.fetchProjectDDL);

    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
    final String? companyCode = await SecureStorageUtil.readSecureData("CompanyCode");
    final String? plantID = await SecureStorageUtil.readSecureData("ActiveProjectID");
    final String? userID = await SecureStorageUtil.readSecureData("UserID");


    AppLogger.debug("🔑 Retrieved Credentials => Token: $authToken, CompanyCode: $companyCode, PlantID: $plantID");

    if (authToken == null || companyCode == null || plantID == null || userID == null) {
      AppLogger.error('❌ [AUTH] Missing authToken, CompanyCode or PlantID');
      return [];
    }

    // Log tokens and values
    AppLogger.debug("🔑 AuthToken: $authToken");
    AppLogger.debug("🏢 CompanyCode: $companyCode");
    AppLogger.debug("👤 UserID: $userID");
    AppLogger.debug("📍 LocationID: $plantID");

    final headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'CompanyCode': companyCode,
      'UserID': userID,
      //'UserID': 10139,
      'LocationID':  1001,
      //'LocationID':  plantID,
      'BindTanker': 'NO',
    });

    AppLogger.debug("Request Body for Fetch-Project-DDL URL: $url");
    AppLogger.debug("Request Body for Fetch-Project-DDL Headers: $headers");
    AppLogger.debug("Request Body for Fetch-Project-DDL BODY: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      AppLogger.debug("📊 Response Code for Fetch Project DDL: ${response.statusCode}");
      AppLogger.debug("📜 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> dataList = data['Data'];

        AppLogger.debug("📈 Project Dropdown Data: $dataList");

        return dataList.map((item) => Project.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load project dropdown list');
      }
    } catch (e) {
      AppLogger.error("⚠️ Error fetching project list: $e");
      rethrow;
    }
  }


  /// Fetch fetchProjectItemTypes Dropdown List
  Future<List<ProjectItem>> fetchProjectItemTypes() async {
   // final url = Uri.parse('$baseUrl/Fetch-ProjectItemType-DDL');
    final url = Uri.parse(ApiEndpoints.fetchProjectItemTypeDDL);

    // Fetch authToken and CompanyCode from SecureStorageUtil or SharedPreferencesUtil
    final String? authToken = await SharedPreferencesUtil.getString(
        "GeneratedToken");
    final String? companyCode = await SecureStorageUtil.readSecureData(
        "CompanyCode");
    final String? projectID = await SecureStorageUtil.readSecureData(
        "ActiveProjectID");

    // Log the retrieved token and company code for debugging
    AppLogger.debug("🔑 AuthToken: $authToken");
    AppLogger.debug("🏢 CompanyCode: $companyCode");
    AppLogger.debug("🏢 ProjectID: $projectID");

    final headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'CompanyCode': companyCode,
       'ProjectID': projectID,
      //'ProjectID': 3003,
    });

    // Log the request body before making the API call
    AppLogger.debug("🔧 Request Body Fetch-ProjectItemType-DDL URL: $url");
    AppLogger.debug("🔧 Request Body Fetch-ProjectItemType-DDL Headers: $headers");
    AppLogger.debug("🔧 Request Body Fetch-ProjectItemType-DDL BODY: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      // Log the response status code and body
      AppLogger.debug("📊 Response Code for Fetch-ProjectItemType-DDL: ${response.statusCode}");
      AppLogger.debug("📜 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> dataList = data['Data'];

        // Log the fetched data
        AppLogger.debug("📈 Data: $dataList");

        return dataList.map((item) => ProjectItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load project item types');
      }
    } catch (e) {
      // Log any error that occurs during the request
      AppLogger.error("⚠️ Error: $e");
      rethrow;
    }
  }

  /// 👷 Fetch Contractor Dropdown List
  Future<List<ContractorItem>> fetchContractors() async {
    //final url = Uri.parse('$baseUrl/Fetch-Contractors-DDL');
    final url = Uri.parse(ApiEndpoints.fetchContractorsDDL);

    final String? companyCode = await SecureStorageUtil.readSecureData(
        "CompanyCode");

    AppLogger.debug("🏢 CompanyCode for Contractor API: $companyCode");

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'CompanyCode': companyCode,
    });

    AppLogger.debug("🔧 Contractor API Request Body: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      AppLogger.debug("📊 Contractor API Response Code: ${response.statusCode}");
      AppLogger.debug("📜 Contractor API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> dataList = data['Data'];

        AppLogger.debug("📈 Contractor Data: $dataList");

        return dataList.map((item) => ContractorItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load contractor data');
      }
    } catch (e) {
      AppLogger.error("⚠️ Contractor API Error: $e");
      rethrow;
    }
  }


  /// 👷 Fetch Labour Category Dropdown List
  Future<List<LabourCategoryItem>> fetchLabourCategories() async {
   // final url = Uri.parse('$baseUrl/Fetch-LabourCategory-DDL');
    final url = Uri.parse(ApiEndpoints.fetchLabourCategoriesDDL);

    // Fetch authToken and CompanyCode from SecureStorageUtil or SharedPreferencesUtil
    final String? authToken = await SharedPreferencesUtil.getString(
        "GeneratedToken");
    final String? companyCode = await SecureStorageUtil.readSecureData(
        "CompanyCode");
    final String? projectID = await SecureStorageUtil.readSecureData(
        "ActiveProjectID");

    // Log the retrieved token and company code for debugging
    AppLogger.debug("🔑 AuthToken: $authToken");
    AppLogger.debug("🏢 CompanyCode: $companyCode");
    AppLogger.debug("🏢 ProjectID: $projectID");

    final headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'CompanyCode': companyCode,
    });

    AppLogger.debug("🔧 LabourCategory API Request Body: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      AppLogger.debug(
          "📊 LabourCategory API Response Code: ${response.statusCode}");
      AppLogger.debug("📜 LabourCategory API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> dataList = data['Data'];

        AppLogger.debug("📈 Labour Category Data: $dataList");

        return dataList
            .map((item) => LabourCategoryItem.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load labour category data');
      }
    } catch (e) {
      AppLogger.error("⚠️ LabourCategory API Error: $e");
      rethrow;
    }
  }

}
