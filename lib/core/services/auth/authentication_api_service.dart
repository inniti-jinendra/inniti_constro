import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';
import '../../models/auth/user_authentication_model.dart';
import '../../utils/shared_preferences_util.dart';

class AuthenticationApiService {
  static Future<bool> verifyCompanyCode(String companyCode) async {
    final url = Uri.parse('${Constants.baseUrl}/Account/VerifyCompanyCode')
        .replace(queryParameters: {'companyCode': companyCode});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['Exists'] as bool;
    } else {
      throw Exception('Failed to verify company code');
    }
  }

  static Future<UserAuthenticationViewModel?> verifyMobileOrEmail(
      String emailOrMobile) async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');
    final url =
        Uri.parse('${Constants.baseUrl}/Account/VerifyMobileNumberOrEmailID')
            .replace(queryParameters: {
      'companyCode': companyCode,
      'emailOrMobile': emailOrMobile
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var userdata = UserAuthenticationViewModel.fromJson(data);
      return userdata;
    } else {
      throw Exception('Failed to verify mobile/email');
    }
  }
}
