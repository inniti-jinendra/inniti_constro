import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';
import '../constants/font_styles.dart';

class AppbarHeader extends StatelessWidget {
  final String headerName;
  final String projectName;
  const AppbarHeader({
    super.key,
    required this.headerName,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          headerName,
          style: FontStyles.bold700.copyWith(
            color: AppColors.primaryBlackFont,
            fontSize: 18,
          ),
        ),
        Visibility(
          visible: projectName != '',
          child: Text(
            projectName,
            style: FontStyles.bold700.copyWith(
              color: AppColors.primaryBlackFont,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
