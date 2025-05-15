import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../core/constants/font_styles.dart';
import '../../core/models/account/user_details.dart';
import '../../core/network/logger.dart';
import '../../core/services/profile/ProfileAccountApiService.dart';
import '../../core/utils/secure_storage_util.dart';
import '../../widgets/alert_dialog/custom_alert_dialog.dart';
import '../../widgets/global_loding/global_loader.dart';


class AppSettingsTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const AppSettingsTile({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryWhitebg, // Optional: Set a background color if needed
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            iconPath,
            height: 24,
            width: 24,
          ),
        ),
      ),
      title: Text(
        title,
        style: FontStyles.semiBold600.copyWith(
          color: AppColors.primaryBlackFont,
          fontSize: 18,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ProfileUserDetails? _userDetails;
  String? _projectName;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _fetchStoredProject();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final result = await ProfileAccountApiService.fetchUserAccountDetails();
      if (mounted) {
        setState(() {
          _userDetails = result;
        });
      }
    } catch (e) {
      print("❌ Error fetching user details: $e");
    }
  }

  // Fetch the stored project name and ID
  Future<void> _fetchStoredProject() async {
    try {
      final projectName = await SecureStorageUtil.readSecureData("ActiveProjectName");
      setState(() {
        _projectName = projectName;
      });

      // Log the fetched project name (for debugging)
      if (_projectName != null) {
        AppLogger.info("Fetched Active Project: $_projectName");
      }
    } catch (e) {
      AppLogger.error("Error fetching project from secure storage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
          },
          icon: SvgPicture.asset(
            "assets/icons/setting/LeftArrow.svg",
          ),
          color: AppColors.primaryBlue,
        ),
        title: Text(
         'Profile Details',
          style: FontStyles.bold700.copyWith(
            color: AppColors.primaryBlackFont,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.primaryWhitebg,
      ),
      backgroundColor: AppColors.primaryWhitebg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 110), // Adjusted margin for better space
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [


                    const SizedBox(height: 80), // Extra space for profile image
                    Text(
                      _userDetails != null
                          ? "${_userDetails!.userName}" // Interpolating the userName
                          : "Loading...", // Fallback text if user details are not available
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlackFont,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 4),
                    Text(
                      _userDetails?.mobileNo ?? '+91 7807660896', // Fallback to static number if _userDetails is null
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryLightGrayFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Divider(
                      height: 2,
                      color: Color(0xffF9F7FC)
                    ),
                    AppSettingsTile(
                      title: "Accessibility",
                      iconPath: 'assets/icons/key.svg',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.accessibility);
                      },
                    ),
                    Divider(
                      height: 2,
                      color: Color(0xffF9F7FC)
                    ),
                    AppSettingsTile(
                      title: "Menu Accessibility",
                      iconPath: 'assets/icons/key.svg',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.menuAccessibility);
                      },
                    ),
                    Divider(
                        height: 2,
                        color: Color(0xffF9F7FC)
                    ),
                    AppSettingsTile(
                      title: "Assign Items",
                      iconPath:"assets/icons/clipboard-tick.svg",
                      onTap: () {
                       // Navigator.pushNamed(context, AppRoutes.assignItems);
                      },
                    ),
                    Divider(
                        height: 2,
                        color: Color(0xffF9F7FC)
                    ),
                    AppSettingsTile(
                      title: "Salary Slip",
                      iconPath: "assets/icons/receipt-text.svg",
                      onTap: () {
                       // Navigator.pushNamed(context, AppRoutes.salarySlip);
                      },
                    ),
                    Divider(
                        height: 2,
                        color: Color(0xffF9F7FC)
                    ),
                    AppSettingsTile(
                      title: "About Us",
                      iconPath: "assets/icons/warning-2.svg",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.aboutUs);

                        // Navigator.pushNamedAndRemoveUntil(
                        //   context,
                        //   AppRoutes.login,
                        //       (route) => false,
                        // );
                      },
                    ),
                    Divider(
                        height: 2,
                        color: Color(0xffF9F7FC)
                    ),

                    const SizedBox(height: 60),
                    GestureDetector(
                      // onTap: () {
                      //   // Navigator.pushNamedAndRemoveUntil(
                      //   //   context,
                      //   //   AppRoutes.login, // Navigate to login page
                      //   //       (route) => false, // Remove all previous routes
                      //   // );
                      // },
                      onTap: ()=>  _showLogoutConfirmation(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhitebg, // Using primary color
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/logout.svg',
                              height: 22,
                              width: 22,
                            ),
                            SizedBox(width: 15,),
                            const Center(
                              child: Text(
                                'Logout', // Text displayed on the button
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primaryBlackFont, // White text color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              Container(
                height: 170, // Height with space for the border
                width: 170,  // Width with space for the border
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0), // Rounded corners for the outer container
                  border: Border.all(color: Color(0xffC3AFE3), width: 2), // Border with thickness of 4
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0), // Apply same rounded corners inside as well
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0), // Rounded corners for the inner container
                        border: Border.all(color: Color(0xffC3AFE3), width: 4),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            _userDetails?.profilePhotoUrl ??
                                'https://randomuser.me/api/portraits/men/${DateTime.now().millisecondsSinceEpoch % 99}.jpg', // Fallback to random image if no profile photo
                          ),
                        ),

                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

          // ✅ Clear Secure Storage Data
         await _clearSecureStorage();

          // ✅ Clear SharedPreferences Data
          await _clearSharedPreferences();

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
}
