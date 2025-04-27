import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:io';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/secure_storage_util.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/alert_dialog/custom_alert_dialog.dart';
import '../../../../widgets/custom_dialog/custom_confirmation_dialog.dart'; // Import for closing the app

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String userName = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUserSessionData();
  }

  Future<void> _fetchUserSessionData() async {
    try {
      String storedUserName = await SecureStorageUtil.readSecureData("UserName") ?? "Guest";

      setState(() {
        userName = storedUserName;
      });
    } catch (e) {
      print("❌ Error retrieving session data: $e");
    }
  }

  // ✅ Handle Back Button Press
  Future<bool> _onWillPop() async {
    CustomConfirmationDialog.show(
      context,
      title: "Exit App",
      message: "Are you sure you want to exit the app?",
      confirmText: "Exit",
      cancelText: "Cancel",
      onConfirm: () {
        exit(0); // Close the app if user confirms
      },
    );
    return false; // Prevent the default back action (app exit)
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope( // ✅ Capture Back Button Press
      onWillPop: _onWillPop,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome",
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2),
            Text(
              userName,
              style: GoogleFonts.nunitoSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlackFont,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.notifications);
              },
              icon: SvgPicture.asset(
                'assets/icons/home-iocn/ball-icon.svg',
                height: 30,
                width: 30,
              ),
              tooltip: 'Notifications',
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
