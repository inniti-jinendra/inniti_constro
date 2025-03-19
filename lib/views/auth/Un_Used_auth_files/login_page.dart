import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../components/Un_Used/dont_have_account_row.dart';
import '../components/Un_Used/login_header.dart';
import '../components/Un_Used/login_page_form.dart';
import '../components/Un_Used/social_logins.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginPageHeader(),
                LoginPageForm(),
                SizedBox(height: AppDefaults.padding),
                SocialLogins(),
                DontHaveAccountRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
