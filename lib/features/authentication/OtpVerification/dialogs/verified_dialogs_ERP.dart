import 'package:flutter/material.dart';

import '../../../../core/components/network_image.dart';
import '../../../../core/constants/app_defaults.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/network/logger.dart';
import '../../../../core/utils/secure_storage_util.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/CustomToast/custom_snackbar.dart';
import '../../../../widgets/global_loding/global_loader.dart';



class VerifiedDialog extends StatefulWidget {
  final dynamic users;
  const VerifiedDialog({super.key, required this.users});

  @override
  State<VerifiedDialog> createState() => _VerifiedDialogState();
}

class _VerifiedDialogState extends State<VerifiedDialog> {
  void _goToHomePage() async {
    try {
      AppLogger.info("🔹 Navigating to Home Page... Retrieving stored session data.");

      // ✅ Show global loader before logout
      GlobalLoader.show(context);

      // ✅ Small delay to ensure SharedPreferences has stored data
      await Future.delayed(const Duration(milliseconds: 500));

      // ✅ Retrieve stored session details
      String loggedIn = await SharedPreferencesUtil.getString("LoggedIn") ?? "false";
      String companyCode = await SharedPreferencesUtil.getString("CompanyCode") ?? "";
      String userId = await SharedPreferencesUtil.getString("ActiveUserID") ?? "";
      String email = await SharedPreferencesUtil.getString("ActiveEmailID") ?? "";
      String mobile = await SharedPreferencesUtil.getString("ActiveMobileNo") ?? "";
      String activeProjectId = await SharedPreferencesUtil.getString("ActiveProjectID") ?? "0";
      String? userType = await SecureStorageUtil.readSecureData("UserType") ?? "REGULAR";

      AppLogger.info("📌 Retrieved User Session Data:");
      AppLogger.info("🔹 LoggedIn: $loggedIn");
      AppLogger.info("🔹 CompanyCode: $companyCode");
      AppLogger.info("🔹 UserID: $userId");
      AppLogger.info("🔹 Email: $email");
      AppLogger.info("🔹 Mobile: $mobile");
      AppLogger.info("🔹 ActiveProjectID: $activeProjectId");
      AppLogger.info("🔹 UserType: $userType");

      GlobalLoader.hide(); // ✅ Hide loader after API call

      if (loggedIn == "true" && userId.isNotEmpty ) {
        AppLogger.info("✅ User is authenticated. Redirecting to Home...");
        //Navigator.pushNamed(context, AppRoutes.entryPoint);

        if (userType == "ATTENDANCE ONLY") {
          AppLogger.info("ATTENDANCE ONLY user. Navigating to OnlySelfAttendance...");
          Navigator.pushReplacementNamed(context, AppRoutes.OnlyselfAttendance);
        } else {
          AppLogger.info("REGULAR user. Navigating to entryPoint...");
          Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
        }


      } else {
        AppLogger.warn("❌ User session is invalid. Redirecting to Login...");
        Navigator.pushNamed(context, AppRoutes.login);
      }
    } catch (e) {
      Navigator.pop(context); // Remove loading indicator on error
      AppLogger.error("❌ Error retrieving session data: $e");
      CustomSnackbar.show(context, message: "Failed to proceed. Please try again.");
    }
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
