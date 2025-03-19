import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/shared_preferences_util.dart';

class SplashScreen extends StatefulWidget {
  final String notificationRoute;
  const SplashScreen({super.key, required this.notificationRoute});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  Future<void> _checkUserLoggedIn() async {
    // final _companyCode =
    //     await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final _loggedIn =
        await SharedPreferencesUtil.getSharedPreferenceData('LoggedIn');

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (_loggedIn == "true") {
        if (widget.notificationRoute.isNotEmpty) {
          Navigator.pushReplacementNamed(context, widget.notificationRoute);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
        }
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/InnitiLogoGIF.gif'),
        // child: CircularProgressIndicator(),
      ),
    );
  }
}
