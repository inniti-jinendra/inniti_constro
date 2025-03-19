import 'package:flutter/material.dart';
import 'package:inniti_constro/core/services/account/account_api_service.dart';

import '../../../core/components/network_image.dart';
import '../../../core/constants/constants.dart';
import '../../../core/models/account/user_details.dart';
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

class _UserData extends StatefulWidget {
  const _UserData();

  @override
  State<_UserData> createState() => _UserDataState();
}

class _UserDataState extends State<_UserData> {
  UserDetails? _userDetails;

  Future<void> _fetchUserDetailsByID() async {
    try {
      final userDetails = await AccountApiService.fatchUserDetailsByID();
      setState(() {
        _userDetails = userDetails;
      });
    } catch (error) {
      // _showErrorSnackbar('Failed to load user details');
    }
  }

  @override
  void initState() {
    super.initState();
    if (_userDetails == null) {
      _fetchUserDetailsByID();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Row(
        children: [
          const SizedBox(width: AppDefaults.padding),
          SizedBox(
            width: 100,
            height: 100,
            child: ClipOval(
              child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: NetworkImageWithLoader(
                      _userDetails?.profilePhotoUrl ?? "")),
            ),
          ),
          const SizedBox(width: AppDefaults.padding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userDetails?.userName ?? "Loading...",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Mobile: ${_userDetails?.mobileNo ?? "Loading..."}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
