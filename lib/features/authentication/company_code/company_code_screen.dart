import 'package:flutter/material.dart';

import '../../../core/constants/app_images.dart';

import '../../../core/utils/shared_preferences_util.dart';
import 'widgets/ERP_intro_page_background_wrapper.dart';
import 'widgets/ERP_intro_page_body_area.dart';

class IntroLoginPage extends StatefulWidget {
  const IntroLoginPage({super.key});

  @override
  State<IntroLoginPage> createState() => _IntroLoginPageState();
}

class _IntroLoginPageState extends State<IntroLoginPage> {
  @override
  void initState() {
    super.initState();
   _makeUserLogOut();
  }

  // Moving the logout operations to run asynchronously and delay to avoid blocking UI
  _makeUserLogOut() async {
    await Future.delayed(Duration(milliseconds: 100), () async {
      await SharedPreferencesUtil.setSharedPreferenceData("LoggedIn", "false");
      await SharedPreferencesUtil.setSharedPreferenceData("CompanyCode", "");
      await SharedPreferencesUtil.setSharedPreferenceData("ActiveUserID", "");
      await SharedPreferencesUtil.setSharedPreferenceData("ActiveEmailID", "");
      await SharedPreferencesUtil.setSharedPreferenceData("ActiveMobileNo", "");
      await SharedPreferencesUtil.setSharedPreferenceData("ActiveProjectID", "0");
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          IntroLoginBackgroundWrapper(imageURL: AppImages.introBackground1),
          IntroPageBodyArea(),
        ],
      ),
    );
  }
}
