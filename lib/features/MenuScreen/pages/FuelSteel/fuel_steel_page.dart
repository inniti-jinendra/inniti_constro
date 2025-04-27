import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class FuelSteelPage extends StatelessWidget {
  const FuelSteelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("FuelSteelPage")),
      appBar: AppBar(
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left, size: 30),
          color: AppColors.primaryBlue,
        ),
        title: Text(
          'FuelSteel',
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
      body: Center(child: Text("FuelSteelPage"),),);
  }
}
