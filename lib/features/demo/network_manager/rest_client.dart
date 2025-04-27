import 'package:flutter/foundation.dart';
import 'package:inniti_constro/features/demo/models/user_list_in_objects.dart';
import 'http_client.dart';

class RestClient {
  static final HttpHelper _httpHelper = HttpHelper();

  /// GET API CALL to Fetch User List
  static Future<UserListInObjects?> getUserList() async {
    try {
      // Make the GET request
      Map<String, dynamic>? response = await _httpHelper.get(
        url: 'https://reqres.in/api/users?page=2',
      );

      // Log the response
      if (kDebugMode) {
        print('✅ API Response: $response');
      }

      // Return the mapped model if the response is not null
      if (response != null && response is Map<String, dynamic>) {
        return UserListInObjects.fromJson(response);
      } else {
        print('❌ Failed to parse response or received null response');
        return null;
      }
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }
}
