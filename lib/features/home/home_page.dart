// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:inniti_constro/core/constants/app_colors.dart';
// import '../../core/constants/app_icons.dart';
//
// import '../../core/constants/app_defaults.dart';
//
// import '../../routes/app_routes.dart';
// import 'components/ERP_assigned_tasks_detailes.dart';
// import 'components/ERP_dashboard_lead_project_details.dart';
// import 'components/ERP_project_progress_bar_chart.dart';
// import 'components/ERP_project_progress_pie_chart.dart';
// import 'components/ad_space.dart';
// import 'components/our_new_item.dart';
// import 'components/Category.dart';
// import 'home_screen_entry_point/Widget/CustomAppBar.dart';
//
// class HomePageContent extends StatelessWidget {
//   const HomePageContent({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   automaticallyImplyLeading: false,
//       //   backgroundColor: Colors.white,
//       //   // Set background to white for a clean look
//       //   title: Column(
//       //     crossAxisAlignment: CrossAxisAlignment.start,
//       //     // Align text to the start for better flow
//       //     children: [
//       //       Text(
//       //         "Welcome", // More modern greeting
//       //         style: GoogleFonts.nunitoSans(
//       //           // Use GoogleFonts to apply the font
//       //           fontSize: 14, // Larger font for better visibility
//       //           color: Colors.blue, // Your primary color
//       //           fontWeight: FontWeight.w500, // Slightly bold for emphasis
//       //         ),
//       //       ),
//       //       SizedBox(height: 2), // Space between "Welcome" and username
//       //       Text(
//       //         "Dishant Babariya", // User's name
//       //         style: GoogleFonts.nunitoSans(
//       //           fontSize: 18, // Larger font for the user's name to emphasize it
//       //           fontWeight: FontWeight.w700, // Bold for better emphasis
//       //           color:
//       //           AppColors.primaryBlackFont, // Dark color for the username
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       //   actions: [
//       //     Padding(
//       //       padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
//       //       child: IconButton(
//       //         onPressed: () {
//       //           Navigator.pushNamed(
//       //             context,
//       //             AppRoutes.notifications,
//       //           ); // Navigate to notifications
//       //         },
//       //         icon: SvgPicture.asset(
//       //           'assets/icons/home-iocn/ball-icon.svg',
//       //           // Replace with the actual path to your SVG file
//       //           height: 30, // Adjust size of the SVG
//       //           width: 30,
//       //         ),
//       //         tooltip: 'Notifications',
//       //         // Tooltip for accessibility
//       //         splashColor: Colors.transparent,
//       //         // No splash effect for cleaner interaction
//       //         highlightColor: Colors.transparent, // Clean highlight color
//       //       ),
//       //     ),
//       //   ],
//       // ),
//
//       appBar: CustomAppBar(),
//       body: SafeArea(
//         child: CustomScrollView(
//           physics: BouncingScrollPhysics(),
//           slivers: [
//             // const SliverToBoxAdapter(child: ErpDashboardLeadProjectDetails()),
//
//             // Sliver for ErpDashboardLeadProject widgets
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ErpDashboardLeadProject(
//                   initialProject: "SWAGAT V2",
//                   progressPercent: 0.66, // 30% progress
//                   onSelectionChanged: () {
//                     print("Project selection changed!");
//                   },
//                 ),
//               ),
//             ),
//
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Category',
//                           style: GoogleFonts.nunitoSans(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.primaryBlackFont,
//                           ),
//                         ),
//                         Text(
//                           'See all',
//                           style: GoogleFonts.nunitoSans(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.primaryBlueFont,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildPlanCard('Personal Plan', '3 Plans Remaining'),
//                         _buildPlanCard('Work Plan', '8 Plans Remaining'),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'On Going Task',
//                           style: GoogleFonts.nunitoSans(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.primaryBlackFont,
//                           ),
//                         ),
//                         Text(
//                           'See all',
//                           style: GoogleFonts.nunitoSans(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xff7445BA),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     _buildTaskCard(),
//                     _buildTaskCard(),
//                     _buildTaskCard(),
//                   ],
//                 ),
//               ),
//             ),
//
//             // const SliverToBoxAdapter(child: ErpAssignedTasksDetailes()),
//             // const SliverToBoxAdapter(child: ErpProjectProgressPieChart()),
//             // const SliverToBoxAdapter(child: ErpProjectProgressBarChart()),
//             // const SliverToBoxAdapter(child: AdSpace()),
//             // const SliverToBoxAdapter(child: PopularPacks()),
//             //
//             // const SliverToBoxAdapter(child: PopularPacks()),
//             //
//             // const SliverPadding(
//             //   padding: EdgeInsets.symmetric(vertical: AppDefaults.padding),
//             //   sliver: SliverToBoxAdapter(child: OurNewItem()),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlanCard(String title, String subtitle) {
//     return Container(
//       width: 170,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.primaryWhitebg,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 height: 25,
//                 width: 25,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryBlue,
//                   borderRadius: BorderRadius.circular(
//                     6,
//                   ), // Half of width/height to make it perfectly round
//                 ),
//               ),
//               SizedBox(width: 5),
//               Text(
//                 title,
//                 style: GoogleFonts.nunitoSans(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15,
//                   color: AppColors.primaryBlackFont,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             subtitle,
//             style: GoogleFonts.nunitoSans(
//               fontWeight: FontWeight.w500,
//               fontSize: 15,
//               color: AppColors.primaryLightGrayFont,
//             ),
//           ),
//
//           const SizedBox(height: 12),
//           Text(
//             'Go to Plan  ➜',
//             style: GoogleFonts.nunitoSans(
//               fontWeight: FontWeight.w700, // 700 weight for bold text
//               fontSize: 15, // Font size of 15px
//               color: const Color(0xFF7445BA), // Color code #7445BA
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTaskCard() {
//     return Container(
//       height: 120,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.indigo.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: SingleChildScrollView(
//         // Wrap content with SingleChildScrollView
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Machinery Work',
//               style: GoogleFonts.nunitoSans(
//                 fontWeight: FontWeight.w700, // 700 weight for bold text
//                 fontSize: 18,
//                 color: AppColors.primaryBlackFont, // Font size of 18px
//               ),
//             ),
//             SizedBox(height: 5),
//             Row(
//               children: [
//                 SvgPicture.asset(
//                   "assets/icons/home-iocn/pin-icon.svg",
//                   height: 16,
//                   width: 16,
//                 ),
//                 Text(
//                   'WING A > FLOOR 1 ~ CENTERING WORK PHASE',
//                   style: GoogleFonts.nunitoSans(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                     color: AppColors.primaryLightGrayFont,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 5),
//             Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         SvgPicture.asset(
//                           "assets/icons/home-iocn/not-icon.svg",
//                           height: 16,
//                           width: 16,
//                         ),
//                         SizedBox(width: 5),
//                         Row(
//                           children: [
//                             Text(
//                               '20 Ft Pending',
//                               style: GoogleFonts.nunitoSans(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 12,
//                                 color:
//                                 AppColors
//                                     .primaryBlueFont, // You can change the color as per your requirement
//                               ),
//                             ),
//                             SizedBox(width: 13),
//                             Container(
//                               height: 18,
//                               width: 2,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Color(0xFFC3AFE3), // #C3AFE3
//                                     Color(0xFF5B21B1), // #5B21B1
//                                     Color(0xFFC3AFE3), // #C3AFE3 again
//                                   ],
//                                   begin: Alignment.topCenter,
//                                   // You can adjust this to change the direction of the gradient
//                                   end:
//                                   Alignment
//                                       .bottomCenter, // Direction for vertical gradient
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // This ensures the texts are spaced out
//                       children: [
//                         Text(
//                           'Progress',
//                           style: GoogleFonts.nunitoSans(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 12,
//                             color: AppColors.primaryLightGrayFont,
//                           ),
//                           textAlign:
//                           TextAlign
//                               .start, // Ensures the text aligns to the left
//                         ),
//                         SizedBox(width: 50,),
//                         Text(
//                           '72% Completed',
//                           style: GoogleFonts.nunitoSans(
//                             fontWeight: FontWeight.w700,
//                             fontSize: 12,
//                             color: AppColors.primaryBlueFont,
//                           ),
//                           textAlign:
//                           TextAlign
//                               .end, // Ensures the text aligns to the right
//                         ),
//                       ],
//                     ),
//
//                   ],
//                 ),
//
//                 SizedBox(height: 10),
//                 LinearProgressIndicator(
//                   value: 0.72,
//                   backgroundColor: Colors.grey[300],
//                   color: Colors.purple,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';

import 'components/ERP_dashboard_lead_project_details.dart';

import 'home_screen_entry_point/Widget/CustomAppBar.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.04; // Dynamic padding based on screen width

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // Sliver for ErpDashboardLeadProject widgets
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: ErpDashboardLeadProject(
                  initialProject: "SWAGAT V2",
                  progressPercent: 0.66, // 30% progress
                  onSelectionChanged: () {
                    print("Project selection changed!");
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category',
                          style: GoogleFonts.nunitoSans(
                            fontSize: screenWidth * 0.05, // Dynamic font size
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBlackFont,
                          ),
                        ),
                        Text(
                          'See all',
                          style: GoogleFonts.nunitoSans(
                            fontSize: screenWidth * 0.04, // Dynamic font size
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBlueFont,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPlanCard('Personal Plan', '3 Plans Remaining', screenWidth),
                        _buildPlanCard('Work Plan', '8 Plans Remaining', screenWidth),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'On Going Task',
                          style: GoogleFonts.nunitoSans(
                            fontSize: screenWidth * 0.05, // Dynamic font size
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBlackFont,
                          ),
                        ),
                        Text(
                          'See all',
                          style: GoogleFonts.nunitoSans(
                            fontSize: screenWidth * 0.04, // Dynamic font size
                            fontWeight: FontWeight.w700,
                            color: Color(0xff7445BA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTaskCard(screenWidth),
                    _buildTaskCard(screenWidth),
                    _buildTaskCard(screenWidth),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(String title, String subtitle, double screenWidth) {
    return Container(
      width: screenWidth * 0.45, // Dynamic width based on screen size
      padding: EdgeInsets.all(screenWidth * 0.04), // Dynamic padding
      decoration: BoxDecoration(
        color: AppColors.primaryWhitebg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(width: 5),
              Text(
                title,
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.04, // Dynamic font size
                  color: AppColors.primaryBlackFont,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w500,
              fontSize: screenWidth * 0.04, // Dynamic font size
              color: AppColors.primaryLightGrayFont,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Go to Plan  ➜',
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.04, // Dynamic font size
              color: const Color(0xFF7445BA),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(double screenWidth) {
    return Container(
      height: screenWidth * 0.35, // Dynamic height based on screen size
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.03), // Dynamic margin
      padding: EdgeInsets.all(screenWidth * 0.04), // Dynamic padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Machinery Work',
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.05, // Dynamic font size
                color: AppColors.primaryLightGrayFont,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/home-iocn/pin-icon.svg",
                    height: 16,
                    width: 16,
                  ),
                  SizedBox(width: 5,),
                  Container(
                    padding: EdgeInsets.only(bottom: 2.0), // Adjust bottom padding as needed
                    child: Flexible(
                      child: Text(
                        'WING A > FLOOR 1 ~ CENTERING WORK PHASE',
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * 0.035, // Dynamic font size
                          color: AppColors.primaryLightGrayFont,
                        ),
                        overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                        maxLines: 1, // Limit to a single line
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.035, // Dynamic font size
                    color: AppColors.primaryLightGrayFont,
                  ),
                ),
                Text(
                  '72% Completed',
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.035, // Dynamic font size
                    color: AppColors.primaryBlueFont,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.02),
            LinearProgressIndicator(
              value: 0.72,
              backgroundColor: Colors.grey[300],
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
