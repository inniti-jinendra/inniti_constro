import 'dart:convert';
import '../../constants/constants.dart';
import '../../models/account/user_details.dart';
import 'package:http/http.dart' as http;

import '../../utils/shared_preferences_util.dart';

class AccountApiService {
  static Future<UserDetails?> fatchUserDetailsByID() async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
    final activeUserID =
        await SharedPreferencesUtil.getSharedPreferenceData('ActiveUserID');

    final url = Uri.parse('${Constants.baseUrl}/Account/GetUserDetailsByID')
        .replace(
            queryParameters: {'companyCode': companyCode, 'Id': activeUserID});

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var userdata = UserDetails.fromJson(data);
      return userdata;
    } else {
      throw Exception('Failed to fatch User Details By ID');
    }
  }
}
