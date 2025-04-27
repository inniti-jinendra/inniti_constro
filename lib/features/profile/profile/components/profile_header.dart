import 'package:flutter/material.dart';

import '../../../../core/components/network_image.dart';
import '../../../../core/constants/app_defaults.dart';

import '../../../../core/network/logger.dart';
import '../../../../core/services/account/account_api_service.dart';
import '../../../../core/utils/secure_storage_util.dart';
import 'profile_header_options.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background
        Image.asset('assets/images/profile_bg_image.jpg'),

        /// Content
        Column(
          children: [
            AppBar(
              centerTitle: true,
              title: const Text('Profile'),
              elevation: 0,
              backgroundColor: Colors.transparent,
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const _UserData(),
            const ProfileHeaderOptions()
          ],
        ),
      ],
    );
  }
}

class UserDetails {
  final String userId;
  final String token;
  final String generatedOtp;
  final String fullName;
  final String activeProjectId;
  final String email;
  final String mobileNo;
  final String profilePhotoUrl;

  UserDetails({
    required this.userId,
    required this.token,
    required this.generatedOtp,
    required this.fullName,
    required this.activeProjectId,
    required this.email,
    required this.mobileNo,
    required this.profilePhotoUrl,
  });

  /// ✅ Convert JSON to a UserDetails object
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['userId'] ?? '',
      token: json['token'] ?? '',
      generatedOtp: json['generatedOtp'] ?? '',
      fullName: json['fullName'] ?? '',
      activeProjectId: json['activeProjectId'] ?? '',
      email: json['email'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
    );
  }

  /// ✅ Convert UserDetails object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'token': token,
      'generatedOtp': generatedOtp,
      'fullName': fullName,
      'activeProjectId': activeProjectId,
      'email': email,
      'mobileNo': mobileNo,
      'profilePhotoUrl': profilePhotoUrl,
    };
  }
}

class _UserData extends StatefulWidget {
  const _UserData();

  @override
  State<_UserData> createState() => _UserDataState();
}

class _UserDataState extends State<_UserData> {
  UserDetails? _userDetails;
  bool _isLoading = true; // Track loading state

  Future<void> _fetchUserData() async {
    try {
      // Retrieve data from SecureStorage
      String userId = await SecureStorageUtil.readSecureData("UserID") ?? "";
      String token = await SecureStorageUtil.readSecureData("Token") ?? "";
      String otp = await SecureStorageUtil.readSecureData("otp") ?? "";
      String userName = await SecureStorageUtil.readSecureData("UserName") ?? "Guest";
      String activeProjectId = await SecureStorageUtil.readSecureData("ActiveProjectID") ?? "0";
      String email = await SecureStorageUtil.readSecureData("EmailID") ?? "";
      String mobile = await SecureStorageUtil.readSecureData("MobileNo") ?? "";

      // Update UI with retrieved data
      setState(() {
        _userDetails = UserDetails(
          userId: userId,
          token: token,
          generatedOtp: otp,
          fullName: userName,
          activeProjectId: activeProjectId,
          email: email,
          mobileNo: mobile,
          profilePhotoUrl: "", // Add logic to fetch profile image if available
        );

        AppLogger.debug("User ID: $userId, Token: $token, Name: $userName");

        _isLoading = false; // ✅ Stop loading
      });
    } catch (e) {
      print("❌ Error retrieving session data: $e");
      setState(() => _isLoading = false); // ✅ Stop loading even if an error occurs
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Row(
        children: [
          const SizedBox(width: AppDefaults.padding),

          // ✅ Profile Picture with Placeholder
          SizedBox(
            width: 100,
            height: 100,
            child: ClipOval(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: _isLoading
                    ? const CircularProgressIndicator() // Show loader while fetching
                    : NetworkImageWithLoader(
                  _userDetails?.profilePhotoUrl?.isNotEmpty == true
                      ? _userDetails!.profilePhotoUrl
                      : "https://randomuser.me/api/portraits/men/${DateTime.now().millisecondsSinceEpoch % 99}.jpg",
                ),
              ),
            ),
          ),

          const SizedBox(width: AppDefaults.padding),

          // ✅ User Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isLoading ? "Loading..." : _userDetails?.fullName ?? "Guest",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLoading ? "Loading..." : 'Mobile: ${_userDetails?.mobileNo ?? "N/A"}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

