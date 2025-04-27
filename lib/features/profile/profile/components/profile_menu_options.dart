import 'package:flutter/material.dart';

import '../../../../core/constants/app_defaults.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/secure_storage_util.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/alert_dialog/custom_alert_dialog.dart';
import '../../../../widgets/global_loding/global_loader.dart';
import 'profile_list_tile.dart';

class ProfileMenuOptions extends StatelessWidget {
  const ProfileMenuOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.padding),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Column(
        children: [
          ProfileListTile(
            title: 'My Profile',
            icon: AppIcons.profilePerson,
            onTap: () => Navigator.pushNamed(context, AppRoutes.home),
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Notification',
            icon: AppIcons.profileNotification,
            onTap: () => Navigator.pushNamed(context, AppRoutes.home),
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Setting',
            icon: AppIcons.profileSetting,
            onTap: () => Navigator.pushNamed(context, AppRoutes.home),
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Payment',
            icon: AppIcons.profilePayment,
            onTap: () => Navigator.pushNamed(context, AppRoutes.home),
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Logout',
            icon: AppIcons.profileLogout,
            onTap: () => _showLogoutConfirmation(context), // ✅ Call logout function
          ),

        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // ✅ Show Global Loader while processing logout
      GlobalLoader.show(context);

      // ✅ Clear Secure Storage Data
      await _clearSecureStorage();

      // ✅ Clear SharedPreferences Data
      await _clearSharedPreferences();

      // ✅ Hide Global Loader and Navigate to Login Screen
      if (context.mounted) {
        GlobalLoader.hide(); // Hide loading indicator
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.login, (route) => false
        );
      }
    } catch (e) {
      print("❌ Error during logout: $e");

      // ✅ Hide Global Loader and Show Error Message
      if (context.mounted) {
        GlobalLoader.hide(); // Hide loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logout failed! Please try again.")),
        );
      }
    }
  }

  Future<void> _clearSecureStorage() async {
    try {
      // Clear all secure storage data
      await SecureStorageUtil.deleteSecureData("UserID");
      await SecureStorageUtil.deleteSecureData("Token");
      await SecureStorageUtil.deleteSecureData("otp");
      await SecureStorageUtil.deleteSecureData("UserName");
      await SecureStorageUtil.deleteSecureData("ActiveProjectID");
      await SecureStorageUtil.deleteSecureData("EmailID");
      await SecureStorageUtil.deleteSecureData("MobileNo");
    } catch (e) {
      print("❌ Error clearing secure storage: $e");
      throw Exception("Error clearing secure storage");
    }
  }

  Future<void> _clearSharedPreferences() async {
    try {
      // Clear all shared preferences data
      await SharedPreferencesUtil.remove("LoggedIn");
      await SharedPreferencesUtil.remove("CompanyCode");
      await SharedPreferencesUtil.remove("ActiveUserID");
      await SharedPreferencesUtil.remove("ActiveEmailID");
      await SharedPreferencesUtil.remove("ActiveMobileNo");
      await SharedPreferencesUtil.remove("ActiveProjectID");
      await SharedPreferencesUtil.remove("GeneratedToken");
    } catch (e) {
      print("❌ Error clearing shared preferences: $e");
      throw Exception("Error clearing shared preferences");
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    CustomAlertDialog.show(
      context: context,
      title: "Logout",
      message: "Are you sure you want to log out?",
      confirmText: "Logout",
      cancelText: "Cancel",
      onConfirm: () async {
        try {
          // ✅ Show global loader before logout
          GlobalLoader.show(context);

          // ✅ Perform logout actions (Clearing SecureStorage & SharedPreferences)
          await SecureStorageUtil.clearAll();
          await SharedPreferencesUtil.clearAll();

          // ✅ Hide loader and navigate to login screen
          GlobalLoader.hide();
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.WelcomCompnyCode, (route) => false
          );
        } catch (e) {
          print("❌ Error during logout confirmation: $e");

          // Show error if the logout fails
          GlobalLoader.hide();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logout failed! Please try again.")),
          );
        }
      },
    );
  }



}
