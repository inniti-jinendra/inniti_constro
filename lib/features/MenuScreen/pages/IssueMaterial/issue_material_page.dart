import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class IssueMaterialPage extends StatelessWidget {
  const IssueMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("IssueMaterialPage")),
      appBar: AppBar(
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            "assets/icons/setting/LeftArrow.svg",
          ),
          color: AppColors.primaryBlue,
        ),
        title: Text(
          'IssueMaterial',
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.primaryBlackFont,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: Icon(Icons.filter_list_alt, color: AppColors.primaryBlue),
              //  onPressed: () => _showFilterBottomSheet(context),
              onPressed: (){},
            ),
          ),
        ],
        backgroundColor: AppColors.primaryWhitebg,
      ),
      body: Center(child: Text("IssueMaterialPage"),),);
  }
}
