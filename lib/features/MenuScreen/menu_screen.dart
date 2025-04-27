import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inniti_constro/features/MenuScreen/pages/labour/labours_page.dart';
import 'package:inniti_constro/features/MenuScreen/pages/labour_attedance_new/labour_attendance_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/custom_dialog/custom_confirmation_dialog.dart';
import 'pages/add_labour/add_labour_page.dart';         // Import page files
import 'pages/machinery/machinery_page.dart';
import 'pages/PettyCash/petty_cash_page.dart';


import 'pages/Inwards/inwards_page.dart';
import 'pages/FuelIssue/fuel_issue_page.dart';
import 'pages/FuelSteel/fuel_steel_page.dart';
import 'pages/IssueMaterial/issue_material_page.dart';
import 'pages/AdvanceRequisition/advance_requisition_page.dart';
import 'pages/GatePassPending/gate_pass_pending_page.dart';
import 'pages/GatePassIn/gate_pass_in_page.dart';
import 'pages/ComplaintBook/complaint_book_page.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = -1; // Track selected index

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;

    int columnCount = 3;

    // Project Change options (titles)
    final List<String> options = [
      'Add Labour Persons',
      'Machinery',
      'Petty Cash',
      'Labours',
      'Labours Attendance',
      'Inwards',
      'Fuel Issue',
      'Fuel Inward',
      'Issue Material',
      'Petty Cash Request',
      'Advance Requisition Gate Pass (OUT)',
      'Gate Pass (Pending)',
      'Gate Pass IN',
      'Complaint Book'
    ];

    // Corresponding navigation pages
    final List<Widget> pages = [
      AddLabourPage(),
      MachineryPage(),
      PettyCashPage(),
      LaboursPage(),
      LabourAttendancePage (),
      InwardsPage(),
      FuelIssuePage(),
      FuelSteelPage(),
      IssueMaterialPage(),
      PettyCashPage(),
     // IssueMaterialPage(),
      AdvanceRequisitionPage(),
      GatePassPendingPage(),
      GatePassInPage(),
      ComplaintBookPage(),
    ];

    // Example SVG icon paths for each option
    final List<String> svgIcons = [
      'assets/icons/menu-icon/Add-Labour.svg',
      'assets/icons/menu-icon/Machinery.svg',
      'assets/icons/menu-icon/Petty-Cash.svg',
      'assets/icons/menu-icon/Labours.svg',
      'assets/icons/menu-icon/Labout-Attendances.svg',
      'assets/icons/menu-icon/Inwards.svg',
      'assets/icons/menu-icon/Fuel-Issue.svg',
      'assets/icons/menu-icon/Fuel-Inward.svg',
      'assets/icons/menu-icon/Issue-Meterial.svg',
      'assets/icons/menu-icon/Petty-Cash-Request.svg',
      'assets/icons/menu-icon/Advance-Requisition.svg',
      'assets/icons/menu-icon/Gate-Pass(Pending).svg',
      'assets/icons/menu-icon/Gate-Pass(IN).svg',
      'assets/icons/menu-icon/Complaint-Book.svg',
    ];

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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:  AppColors.primaryWhitebg,
          title: Text("Choose a Menu"),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: SafeArea(
          child: AnimationLimiter(
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              itemCount: options.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: Duration(milliseconds: 500),
                  columnCount: columnCount,
                  child: ScaleAnimation(
                    duration: Duration(milliseconds: 900),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: FadeInAnimation(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? AppColors.primaryWhitebg // Light White background color when selected
                              : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: InkWell(
                          // onTap: () {
                          //   setState(() {
                          //     _selectedIndex = index; // Set the selected index
                          //   });
                          //   // Navigate to the corresponding page
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => pages[index],
                          //     ),
                          //   );
                          // },
                          onTap: () {
                            setState(() {
                              _selectedIndex = index; // Set the selected index
                            });

                            if (index == 0) {  // If "Add Labour Persons" is clicked
                              AddLabourPersonDialog.show(context);
                            } else {
                              // Navigate normally to other pages
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => pages[index],
                                ),
                              );
                            }
                          },

                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    svgIcons[index],
                                    width: 40,
                                    height: 40,
                                    color: AppColors.primaryBlueFont,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    options[index],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style:GoogleFonts.nunitoSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: _selectedIndex == index
                                          ? AppColors.primaryBlueFont
                                          : Colors.black,
      
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PettyCashRequest extends StatelessWidget {
  const PettyCashRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
