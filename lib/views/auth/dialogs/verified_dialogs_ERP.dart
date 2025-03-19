import 'package:flutter/material.dart';

import '../../../core/components/network_image.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/shared_preferences_util.dart';

class VerifiedDialog extends StatefulWidget {
  final dynamic users;
  const VerifiedDialog({super.key, required this.users});

  @override
  State<VerifiedDialog> createState() => _VerifiedDialogState();
}

class _VerifiedDialogState extends State<VerifiedDialog> {
  _goToHomePage() async {
    await SharedPreferencesUtil.setSharedPreferenceData("LoggedIn", "true");
    await SharedPreferencesUtil.setSharedPreferenceData(
        "CompanyCode", widget.users.companyCode);
    await SharedPreferencesUtil.setSharedPreferenceData(
        "ActiveUserID", widget.users.userId);
    await SharedPreferencesUtil.setSharedPreferenceData(
        "ActiveEmailID", widget.users.emailId);
    await SharedPreferencesUtil.setSharedPreferenceData(
        "ActiveMobileNo", widget.users.mobileNo);
    await SharedPreferencesUtil.setSharedPreferenceData(
        "ActiveProjectID", widget.users.activeProjectId);

    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     AppRoutes.entryPoint, (Route<dynamic> route) => false);

    Navigator.pushNamed(context, AppRoutes.entryPoint);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppDefaults.borderRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDefaults.padding * 3,
          horizontal: AppDefaults.padding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: const AspectRatio(
                aspectRatio: 1 / 1,
                child: NetworkImageWithLoader(
                  AppImages.verified,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: AppDefaults.padding),
            Text(
              'Verified!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text(
              'Hurrah!!  You have successfully\nverified the account.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDefaults.padding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goToHomePage,
                child: const Text('Browse Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
