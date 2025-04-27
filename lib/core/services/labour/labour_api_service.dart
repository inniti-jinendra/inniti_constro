import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:inniti_constro/core/network/logger.dart';
// // import '../../../app/constants/constants.dart';
// // import '../../models/labour/labour_master.dart';
// import '../../constants/constants.dart';
// import '../../models/labour/labour_grid_model.dart';
// import '../../models/labour/labour_master.dart';
// import '../../utils/shared_preferences_util.dart';
// // import '../../models/labour/labour_grid_view_model.dart';
//
// class LabourApiService {
//   static Future<List<LabourGrid>> fetchLabours({
//     required int pageNumber,
//     required int pageSize,
//   }) async {
//     final companyCode =
//         await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
//
//     final url = Uri.parse('${Constants.baseUrl}/Labour/GetLabourGrid')
//         .replace(queryParameters: {
//       'companyCode': companyCode,
//       'pageNumber': pageNumber.toString(),
//       'pageSize': pageSize.toString(),
//     });
//
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data is List) {
//           return data.map((json) => LabourGrid.fromJson(json)).toList();
//         } else {
//           throw const FormatException("Invalid response format from server");
//         }
//       } else {
//         throw HttpException(
//           'Failed to fetch labour data: ${response.statusCode} ${response.reasonPhrase}',
//         );
//       }
//     } catch (e) {
//       throw Exception('Unexpected error occurred: $e');
//     }
//   }
//
//   static Future<Labour> fatchLabourByID({required int id}) async {
//     final companyCode =
//         await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
//
//     final url = Uri.parse('${Constants.baseUrl}/Labour/GetLabourByID').replace(
//         queryParameters: {'companyCode': companyCode, 'Id': id.toString()});
//
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         return Labour.fromJson(data); // Ensure Labour has a fromJson method
//       } else {
//         throw HttpException(
//           'Failed to fetch labour data: ${response.statusCode} ${response.reasonPhrase}',
//         );
//       }
//     } catch (e) {
//       throw Exception('Unexpected error occurred: $e');
//     }
//   }
//
//   static Future<String> createUpdateLabour(Labour labour) async {
//     final companyCode =
//         await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
//     final activeUserID =
//         await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
//     labour.companyCode = companyCode;
//     Uri uri;
//     if (labour.labourID > 0) {
//       labour.lastUpdatedBy = int.parse(activeUserID);
//       uri = Uri.parse('${Constants.baseUrl}/Labour/UpdateLabour');
//     } else {
//       labour.createdBy = int.parse(activeUserID);
//       uri = Uri.parse('${Constants.baseUrl}/Labour/AddLabour');
//     }
//
//     final body = json.encode(labour.toJson());
//     final headers = {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };
//     final response = await http.post(uri, headers: headers, body: body);
//
//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body)['message'];
//       return responseData.toString();
//     } else {
//       return "Error";
//     }
//   }
//
//   static Future<String> deleteLabour(int id) async {
//     final companyCode =
//         await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
//     final activeUserID =
//         await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');
//
//     Uri uri = Uri.parse('${Constants.baseUrl}/Labour/DeleteLabour').replace(
//         queryParameters: {
//           'companyCode': companyCode,
//           'labourID': id.toString(),
//           'deletedBy': activeUserID
//         });
//
//     final headers = {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };
//     final response = await http.post(uri, headers: headers);
//
//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body)['message'];
//       return responseData.toString();
//     } else {
//       return "Error";
//     }
//   }
// }



// ✅ API Service
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/labour/labor.dart';
import '../../network/api_endpoints.dart';
import '../../utils/secure_storage_util.dart';

class LabourApiService {
  //final String baseUrl = "http://192.168.1.28:1010/api/Labour";
  final String baseUrl = "http://13.233.153.154:2155/api/Labour";

  /// Fetches a list of labours from the server.
  /// [pageNumber] The page number for pagination.
  /// [pageSize] The number of items per page for pagination.
  Future<List<Labour>> fetchLabours({
    required int pageNumber,
    required int pageSize,
    required String labourName,
    required String labourType,
  }) async {
    //final Uri url = Uri.parse("$baseUrl/Fetch-All-Labours");
    final Uri url = Uri.parse(ApiEndpoints.fetchAllLabours);

    // Fetch authToken and CompanyCode from SecureStorageUtil or SharedPreferencesUtil
    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
    final String? companyCode = await SecureStorageUtil.readSecureData("CompanyCode");
    final String? labourName = await SecureStorageUtil.readSecureData("UserFullName");

    // Log the retrieved token and company code for debugging
    AppLogger.debug("🔑 AuthToken: $authToken");
    AppLogger.debug("🏢 CompanyCode: $companyCode");
    AppLogger.debug("🏢 labourName: $labourName");

    if (authToken == null || companyCode == null) {
      AppLogger.error('❌ Failed to retrieve authToken or CompanyCode');
      return []; // Return empty list if authentication fails or CompanyCode is missing
    }

    // Define headers with the retrieved token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authToken, // "Bearer ${authToken}" if it's a Bearer token
    };

    // Request body containing pagination and filter data
    final Map<String, dynamic> body = {
      "CompanyCode": companyCode,  // Use retrieved CompanyCode
      "PageNumber": pageNumber,
      "PageSize": pageSize,
      "LabourName": labourName, // Example Labour Name
      "LabourType": "Electrician", // Example Labour Type
    };

    // Log the request URL, headers, and body for debugging
    AppLogger.debug("➡️ API Request URL: $url");
    AppLogger.debug("➡️ Request Headers: $headers");
    AppLogger.debug("➡️ Request Body for add Labour: ${jsonEncode(body)}");

    try {
      // Send the POST request to the API
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      // Log the response status code for debugging
      AppLogger.debug("🔹 Response Status Code: ${response.statusCode}");

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Log the raw response body
        AppLogger.debug("🔹 Response Body: ${response.body}");

        // Ensure 'Data' exists and is a list
        if (responseData['Data'] is List) {
          List<dynamic> dataList = responseData['Data'];
          // Log the response data
          AppLogger.debug("🔹 Response Data: $dataList");

          // Return parsed Labour objects
          return dataList.map((json) => Labour.fromJson(json)).toList();
        } else {
          // Log a warning if the response data is not in expected format
          AppLogger.warn("Invalid data format received: ${responseData['Data']}");
          return [];
        }
      } else {
        // Log an error if the status code is not 200
        AppLogger.error("❌ Failed to fetch labours. Status code: ${response.statusCode}");
        throw Exception("Failed to fetch labours");
      }
    } catch (e) {
      // Log error details for debugging
      AppLogger.warn("Error fetching labours: $e");
      return [];
    }
  }


  /// Adds a new labour to the server
    Future<bool> addLabour({
    // required int labourId,
    // required int supplierId,
    // required String labourSex,
    // required String labourFirstName,
    // required String labourMiddleName,
    // required String labourLastName,
    // required String labourAge,
    // required String labourContactNo,
    // required String labourAadharNo,
    // required String labourWorkingHrs,
    // required int createdBy,
    // required String createdDate,
    // required String advanceAmount,
    // required String totalWages,
    // required String otRate,
    // required String labourCode,
    // required String labourCategory,
    // required String commissionPerLabour,
    // required int currencyId,
    // required String companyCode,

      required int labourId,
      required int supplierId,
      required String labourSex,
      required String labourFirstName,
      required String labourMiddleName,
      required String labourLastName,
      required int labourAge,
      required String labourContactNo,
      required String labourAadharNo,
      required int labourWorkingHrs,
      required int createdBy,
      required String createdDate,
      required double advanceAmount,
      required double totalWages,
      required double otRate,
      required String labourCode,
      required String labourCategory,
      required double commissionPerLabour,
      required int currencyId,
      required String companyCode,
  }) async {
   // final Uri url = Uri.parse("$baseUrl/Add-Labour");
    final Uri url = Uri.parse(ApiEndpoints.addLabour);

    // Fetch authToken and CompanyCode from SecureStorageUtil or SharedPreferencesUtil
    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
    final String? userId = await SharedPreferencesUtil.getString("ActiveUserID");

    if (authToken == null || companyCode.isEmpty) {
      AppLogger.error('❌ Failed to retrieve authToken or CompanyCode');
      return false; // Return false if authentication fails or CompanyCode is missing
    }

    // Define headers with the retrieved token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authToken, // "Bearer ${authToken}" if it's a Bearer token
    };

    // Request body for adding a labour
    final Map<String, dynamic> body = {
      "LABOUR_ID": labourId,
      "SUPPLIER_ID": supplierId,
      "LABOUR_SEX": labourSex,
      "LABOUR_FIRSTNAME": labourFirstName,
      "LABOUR_MIDDLENAME": labourMiddleName,
      "LABOUR_LASTNAME": labourLastName,
      "LABOUR_AGE": labourAge,
      "LABOUR_CONTACTNO": labourContactNo,
      "LABOUR_AADHARNO": labourAadharNo,
      "LABOUR_PROFILEPIC": null,  // If you have a profile pic, handle accordingly
      "LABOUR_WORKINGHRS": labourWorkingHrs,
      "CREATED_BY": userId,
      "CREATED_DATE": createdDate,
      "LAST_UPDATED_BY": userId,  // Assuming it will be updated later
      "LAST_UPDATED_DATE": createdDate,  // Assuming it will be updated later
      "ADVANCE_AMOUNT": advanceAmount,
      "TOTALWAGES": totalWages,
      "OTRATE": otRate,
      "LABOUR_CODE": labourCode,
      "LABOUR_CATEGORY": labourCategory,
      "COMMISSION_PER_LABOUR": commissionPerLabour,
      "CURRENCYID": currencyId,
      "companyCode": companyCode,
    };

    // Log headers and body for better insight
    AppLogger.info("Sending POST request to: $url");
    AppLogger.info("Request Headers: $headers");
    AppLogger.info("Request Body add Lbor: $body");
    AppLogger.info("Selected Contractor ID api body reqest =>  $supplierId");

    try {
      // Send the POST request to the API
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      // Log the response status and body
      AppLogger.info("Response Status Code: ${response.statusCode}");
      AppLogger.info("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check the response status message and interpret accordingly
        if (responseData['StatusCode'] == 200 && responseData['Message'] == "Labours Add found") {
          AppLogger.info("Labour added successfully with ID: ${responseData['Data']}");
          return true; // Successfully added the labour
        } else {
          AppLogger.error("❌ Failed to add labour: ${responseData['Message']}");
          return false;
        }
      } else {
        // Handle the case where the status code is not 200
        AppLogger.error("❌ Failed to add labour. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Log error details for debugging
      AppLogger.warn("Error adding labour: $e");
      return false;
    }
  }



  Future<bool> deleteLabour({
    required int labourId,
    required int userId,
    required String companyCode,
  }) async {
    //final Uri url = Uri.parse("${baseUrl}/Delete-Labour");
    final Uri url = Uri.parse(ApiEndpoints.deleteLabour);


    AppLogger.info('Deleting labour ${url.toString()}');
    // Get the current date in "yyyy-MM-dd" format (local date)
    String updateDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    // Prepare the request body
    final Map<String, dynamic> body = {
      "CompanyCode": companyCode,  // Use dynamic input here
      "LabourID": labourId,        // Use dynamic input here
      "UpdateBy": userId,          // Use dynamic input here
      "UpdateDate": updateDate,    // Use dynamic input here
    };

    AppLogger.info('Deleting labour body ${jsonEncode(body)}');
    // Log the request body for debugging
    AppLogger.debug("➡️ Request Body for Delete Labour: ${jsonEncode(body)}");

    // Get the authorization token (if needed)
    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");

    if (authToken == null || authToken.isEmpty) {
      AppLogger.error("❌ Failed to retrieve authToken");
      return false;
    }

    // Log the authorization token for debugging (ensure sensitive information is not logged in production)
    AppLogger.debug("🔑 AuthToken: $authToken");

    // Define headers with the retrieved token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "$authToken", // Pass the Bearer token here
    };

    try {
      // Send the POST request to delete the labour
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body), // Encode the body to raw JSON format
      );

      // Log the response status code for debugging
      AppLogger.debug("🔹 Response Status Code: ${response.statusCode}");

      // Check the response status code for success
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Log the response body for debugging
        AppLogger.debug("🔹 Response Body: ${response.body}");

        // If the response indicates success based on StatusCode and Message
        if (responseData['StatusCode'] == 200 && responseData['Message'] == "Labours Delete found") {
          AppLogger.info("Labour with ID $labourId successfully deleted.");
          return true; // Successfully deleted
        } else {
          // Log the error message in case the deletion was not successful
          AppLogger.error("❌ Failed to delete labour: ${responseData['Message']}");
          return false; // Failure message is not as expected
        }
      } else {
        // If the status code is not 200, log the error
        AppLogger.error("❌ Failed to delete labour. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Log any errors that occur during the request
      AppLogger.warn("Error deleting labour: $e");
      return false;
    }
  }



  Future<Map<String, dynamic>> getLabourAttendanceData({
    required int labourAttendanceId,
    required String date,
  }) async {
    // Retrieve authToken from SharedPreferences
    String? authToken = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getString("GeneratedToken"));

    AppLogger.debug("🔑 Retrieved authToken: $authToken");

    if (authToken == null || authToken.isEmpty) {
      AppLogger.error("❌ Failed to retrieve authToken");
      return {'status': 'error', 'message': 'Failed to retrieve authToken'};
    }

    // Log the Labour ID and Date being passed
    AppLogger.info("🧑‍🔧 Labour ID: $labourAttendanceId");
    AppLogger.info("📅 Date: $date");

    // Define the API endpoint
   // Uri url = Uri.parse("http://192.168.1.28:1010/api/Labour/Get-Labour-Data");

    Uri url = Uri.parse(ApiEndpoints.getLabourData);

    // Define headers
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authToken,
    };

    // Define request body
    final Map<String, dynamic> body = {
      "CompanyCode": "CONSTRO",
      "LabourID": labourAttendanceId,
      "Date": date,
    };

    AppLogger.debug("📦 Request Body Get Labor: ${jsonEncode(body)}");
    AppLogger.debug("📜 Request Headers: ${jsonEncode(headers)}");

    try {
      AppLogger.debug("🚀 Making POST API call...");
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      AppLogger.debug("🔹 Response Status Code: ${response.statusCode}");
      AppLogger.debug("🔹 Response Status Body labor get for edit: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        AppLogger.debug("✅ Successful Response Body: ${response.body}");

        if (responseData.containsKey("Data")) {
          AppLogger.debug("📊 Retrieved Data: ${jsonEncode(responseData["Data"])}");
          List<dynamic> labourData = responseData["Data"];
          for (var labour in labourData) {
            AppLogger.debug("Labour Data: ${jsonEncode(labour)}");
          }
        } else {
          AppLogger.error("❌ No Data found in response.");
        }

        return responseData;
      } else {
        AppLogger.error("❌ API call failed with status: ${response.statusCode}");
        AppLogger.error("❌ Error Response Body: ${response.body}");
        return {'status': 'error', 'message': 'API call failed'};
      }
    } catch (e) {
      AppLogger.error("❌ Error during API call: $e");
      return {'status': 'error', 'message': e.toString()};
    }
  }



  /// Edit labour to the server
  Future<bool> editLabour({
    required int labourId,
    required int supplierId,
    required String labourSex,
    required String labourFirstName,
    required String labourMiddleName,
    required String labourLastName,
    required int labourAge,
    required String labourContactNo,
    required String labourAadharNo,
    required int labourWorkingHrs,
    required int createdBy,
    required String createdDate,
    required double advanceAmount,
    required double totalWages,
    required double otRate,
    required String labourCode,
    required String labourCategory,
    required double commissionPerLabour,
    required int currencyId,
    required String companyCode,
  }) async {
    //final Uri url = Uri.parse("$baseUrl/Edit-Labour");
     final Uri url = Uri.parse(ApiEndpoints.editLabour);

    // Fetch authToken and CompanyCode from SecureStorageUtil or SharedPreferencesUtil
    final String? authToken = await SharedPreferencesUtil.getString("GeneratedToken");
    final String? userId = await SharedPreferencesUtil.getString("ActiveUserID");

    if (authToken == null || companyCode.isEmpty) {
      AppLogger.error('❌ Failed to retrieve authToken or CompanyCode');
      return false; // Return false if authentication fails or CompanyCode is missing
    }

    // Define headers with the retrieved token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authToken, // "Bearer ${authToken}" if it's a Bearer token
    };

    // Request body for adding a labour
    final Map<String, dynamic> body = {
      "LABOUR_ID": labourId,
      "SUPPLIER_ID": supplierId,
      "LABOUR_SEX": labourSex,
      "LABOUR_FIRSTNAME": labourFirstName,
      "LABOUR_MIDDLENAME": labourMiddleName,
      "LABOUR_LASTNAME": labourLastName,
      "LABOUR_AGE": labourAge,
      "LABOUR_CONTACTNO": labourContactNo,
      "LABOUR_AADHARNO": labourAadharNo,
      "LABOUR_PROFILEPIC": null,  // If you have a profile pic, handle accordingly
      "LABOUR_WORKINGHRS": labourWorkingHrs,
      "CREATED_BY": userId,
      "CREATED_DATE": createdDate,
      "LAST_UPDATED_BY": userId,  // Assuming it will be updated later
      "LAST_UPDATED_DATE": createdDate,  // Assuming it will be updated later
      "ADVANCE_AMOUNT": advanceAmount,
      "TOTALWAGES": totalWages,
      "OTRATE": otRate,
      "LABOUR_CODE": labourCode,
      "LABOUR_CATEGORY": labourCategory,
      "COMMISSION_PER_LABOUR": commissionPerLabour,
      "CURRENCYID": currencyId,
      "companyCode": companyCode,
      //"companyCode": companyCode,
    };

    // Log headers and body for better insight
    AppLogger.info("Sending POST request to: $url");
    AppLogger.info("Request Headers: $headers");
    AppLogger.info("Request Body Edit Lbor: $body");

    try {
      // Send the POST request to the API
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      // Log the response status and body
      AppLogger.info("Response Status Code fro Labor Edit: ${response.statusCode}");
      AppLogger.info("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check the response status message and interpret accordingly
        if (responseData['StatusCode'] == 200 && responseData['Message'] == "Labours Edit found") {
          AppLogger.info("Labour Edit successfully with ID: ${responseData['Data']}");
          return true; // Successfully added the labour
        } else {
          AppLogger.error("❌ Failed to Edit labour: ${responseData['Message']}");
          return false;
        }
      } else {
        // Handle the case where the status code is not 200
        AppLogger.error("❌ Failed to Edit labour. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Log error details for debugging
      AppLogger.warn("Error Edit labour: $e");
      return false;
    }
  }


}


