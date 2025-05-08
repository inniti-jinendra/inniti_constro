import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Custom tile
import '../../../../core/constants/app_colors.dart';
// Icons you may have
import '../../../../routes/app_routes.dart';
import '../../../core/utils/secure_storage_util.dart';
import '../../../widgets/alert_dialog/custom_alert_dialog.dart';
import '../../../widgets/global_loding/global_loader.dart';



class AppSettingsTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const AppSettingsTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

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
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// class AttendanceOnlySettingsPage extends StatelessWidget {
//   final String profilePhotoUrl;
//   final String userName;
//
//   const AttendanceOnlySettingsPage({
//     Key? key,
//     required this.profilePhotoUrl,
//     required this.userName,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context,true);
//             //Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
//           },
//           icon: Icon(Icons.chevron_left, size: 30),
//           color: AppColors.primaryBlue,
//         ),
//         title: const Text(
//           'Attendance',
//           style: TextStyle(color: AppColors.primaryBlackFont),
//         ),
//         backgroundColor: AppColors.primaryWhitebg,
//       ),
//       backgroundColor: AppColors.primaryWhitebg,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: Stack(
//             alignment: Alignment.topCenter,
//             children:[
//               Container(
//                 margin: const EdgeInsets.only(top: 110), // Adjusted margin for better space
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//
//                   children: [
//                     const SizedBox(height: 80), // Extra space for profile image
//                     const Text(
//                       'Dishant Babariya',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primaryBlackFont,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 20),
//                     //Spacer(),
//
//                     // AppSettingsTile(
//                     //   title: "Accessibility",
//                     //   iconPath: 'assets/icons/key.svg',
//                     //   onTap: () {},
//                     // ),
//                     // AppSettingsTile(
//                     //   title: "Assign Items",
//                     //   iconPath:"assets/icons/clipboard-tick.svg",
//                     //   onTap: () {},
//                     // ),
//                     // AppSettingsTile(
//                     //   title: "Salary Slip",
//                     //   iconPath: "assets/icons/receipt-text.svg",
//                     //   onTap: () {},
//                     // ),
//                     // AppSettingsTile(
//                     //   title: "About Us",
//                     //   iconPath: "assets/icons/warning-2.svg",
//                     //   onTap: () {
//                     //     // Navigator.pushNamedAndRemoveUntil(
//                     //     //   context,
//                     //     //   AppRoutes.login,
//                     //     //       (route) => false,
//                     //     // );
//                     //   },
//                     // ),
//                     // const SizedBox(height: 30),
//
//
//                     GestureDetector(
//                       // onTap: () {
//                       //   // Navigator.pushNamedAndRemoveUntil(
//                       //   //   context,
//                       //   //   AppRoutes.login, // Navigate to login page
//                       //   //       (route) => false, // Remove all previous routes
//                       //   // );
//                       // },
//                       onTap: ()=>  _showLogoutConfirmation(context),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryWhitebg, // Using primary color
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 10,
//                               offset: Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SvgPicture.asset(
//                               'assets/icons/logout.svg',
//                               height: 22,
//                               width: 22,
//                             ),
//                             SizedBox(width: 15,),
//                             const Center(
//                               child: Text(
//                                 'Logout', // Text displayed on the button
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: AppColors.primaryBlackFont, // White text color
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 170, // Height with space for the border
//                 width: 170,  // Width with space for the border
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30.0), // Rounded corners for the outer container
//                   border: Border.all(color: Color(0xffC3AFE3), width: 2), // Border with thickness of 4
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(30.0), // Apply same rounded corners inside as well
//                   child: Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(25.0), // Rounded corners for the inner container
//                         border: Border.all(color: Color(0xffC3AFE3), width: 4),
//                         image: DecorationImage(
//                           fit: BoxFit.cover,
//                           image: NetworkImage(
//                             // Random user profile image URL with dynamic number
//                             'https://randomuser.me/api/portraits/men/18.jpg',
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showLogoutConfirmation(BuildContext context) {
//     CustomAlertDialog.show(
//       context: context,
//       title: "Logout",
//       message: "Are you sure you want to log out?",
//       confirmText: "Logout",
//       cancelText: "Cancel",
//       onConfirm: () async {
//         try {
//           // ✅ Show global loader before logout
//           GlobalLoader.show(context);
//
//           // ✅ Perform logout actions (Clearing SecureStorage & SharedPreferences)
//           await SecureStorageUtil.clearAll();
//           await SharedPreferencesUtil.clearAll();
//
//           // ✅ Clear Secure Storage Data
//           await _clearSecureStorage();
//
//           // ✅ Clear SharedPreferences Data
//           await _clearSharedPreferences();
//
//           // ✅ Hide loader and navigate to login screen
//           GlobalLoader.hide();
//           Navigator.pushNamedAndRemoveUntil(
//               context, AppRoutes.WelcomCompnyCode, (route) => false
//           );
//         } catch (e) {
//
//           // Show error if the logout fails
//           GlobalLoader.hide();
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Logout failed! Please try again.")),
//           );
//         }
//       },
//     );
//   }
//
//   Future<void> _clearSharedPreferences() async {
//     try {
//       // Clear all shared preferences data
//       await SharedPreferencesUtil.remove("LoggedIn");
//       await SharedPreferencesUtil.remove("CompanyCode");
//       await SharedPreferencesUtil.remove("ActiveUserID");
//       await SharedPreferencesUtil.remove("ActiveEmailID");
//       await SharedPreferencesUtil.remove("ActiveMobileNo");
//       await SharedPreferencesUtil.remove("ActiveProjectID");
//       await SharedPreferencesUtil.remove("GeneratedToken");
//     } catch (e) {
//       throw Exception("Error clearing shared preferences");
//     }
//   }
//
//   Future<void> _clearSecureStorage() async {
//     try {
//       // Clear all secure storage data
//       await SecureStorageUtil.deleteSecureData("UserID");
//       await SecureStorageUtil.deleteSecureData("Token");
//       await SecureStorageUtil.deleteSecureData("otp");
//       await SecureStorageUtil.deleteSecureData("UserName");
//       await SecureStorageUtil.deleteSecureData("ActiveProjectID");
//       await SecureStorageUtil.deleteSecureData("EmailID");
//       await SecureStorageUtil.deleteSecureData("MobileNo");
//     } catch (e) {
//       throw Exception("Error clearing secure storage");
//     }
//   }
//
//
//
// }


class AttendanceOnlySettingsPage extends StatelessWidget {
  final String profilePhotoUrl;
  final String userName;

  const AttendanceOnlySettingsPage({
    Key? key,
    required this.profilePhotoUrl,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: Icon(Icons.chevron_left, size: 30),
          color: AppColors.primaryBlue,
        ),
        title: const Text(
          'Attendance',
          style: TextStyle(color: AppColors.primaryBlackFont),
        ),
        backgroundColor: AppColors.primaryWhitebg,
      ),
      backgroundColor: AppColors.primaryWhitebg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
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
                      userName, // Dynamic user name
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlackFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _showLogoutConfirmation(context),
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
                            SizedBox(width: 15),
                            const Center(
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primaryBlackFont,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
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
                    child: CachedNetworkImage(
                      imageUrl: profilePhotoUrl.isNotEmpty ? profilePhotoUrl : 'https://example.com/default-image.jpg',
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.network(
                        'https://randomuser.me/api/portraits/men/18.jpg', // Default avatar if image fails to load
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
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
          // Show global loader before logout
          GlobalLoader.show(context);

          // Perform logout actions (Clearing SecureStorage & SharedPreferences)
          await SecureStorageUtil.clearAll();
          await SharedPreferencesUtil.clearAll();

          // Clear Secure Storage Data
          await _clearSecureStorage();

          // Clear SharedPreferences Data
          await _clearSharedPreferences();

          // Hide loader and navigate to login screen
          GlobalLoader.hide();
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.WelcomCompnyCode, (route) => false);
        } catch (e) {
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
      throw Exception("Error clearing secure storage");
    }
  }
}
