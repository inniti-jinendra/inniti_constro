// // import 'package:flutter/material.dart';
// // import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// // import 'package:flutter_svg/flutter_svg.dart'; // Import SVG package
// //
// // import '../../MenuScreen/menu_screen.dart';
// // import '../../attendance_only/attendance_screen.dart';
// // import '../../orders/orders_screen.dart';
// // import '../../profile/profile/profile_page.dart';
// // import '../../profile/profile_screen.dart';
// // import '../home_page.dart';
// //
// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});
// //
// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   // Define the selected index for the bottom navigation
// //   int _selectedIndex = 0;
// //
// //   // List of pages for bottom navigation
// //   final List<Widget> _pages = [
// //     HomePageContent(),  // HomePage content widget
// //     MenuScreen(),  // Menu Page
// //     SelfAttendance(),  // Attendance Page
// //     OrdersScreen(),  // Orders Page
// //     ProfilePage(),  // Profile Page
// //   ];
// //
// //   // Handle the navigation item selection
// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: _pages[_selectedIndex],  // Display the selected page
// //       ),
// //       bottomNavigationBar: CurvedNavigationBar(
// //         index: _selectedIndex, // Set the current selected index
// //         height: 60.0, // Height of the navigation bar
// //         color: Color(0xffF3EFF9), // Background color of the curved bar
// //         buttonBackgroundColor: Color(0xffF3EFF9), // Background color of the buttons
// //         backgroundColor: Colors.transparent, // Transparent background for the bar
// //         animationCurve: Curves.easeInOut, // Smooth transition animation
// //         animationDuration: const Duration(milliseconds: 350), // Adjusted smooth animation duration
// //         onTap: _onItemTapped, // Update the selected index on tap
// //         items: <Widget>[
// //           // Home Icon (SVG)
// //           AnimatedSwitcher(
// //             duration: const Duration(milliseconds: 300),
// //             child: SvgPicture.asset(
// //               _selectedIndex == 0 ? 'assets/icons/bottam-navi/home-selected.svg' : 'assets/icons/bottam-navi/home-selected.svg', // Change based on selection
// //               key: ValueKey<int>(_selectedIndex),
// //               height: 30,
// //               width: 30,
// //             ),
// //           ),
// //           // Menu Icon (SVG)
// //           AnimatedSwitcher(
// //             duration: const Duration(milliseconds: 300),
// //             child: SvgPicture.asset(
// //               _selectedIndex == 1 ? 'assets/icons/bottam-navi/menu-selected.svg' : 'assets/icons/bottam-navi/menu-selected.svg',
// //               key: ValueKey<int>(_selectedIndex),
// //               height: 30,
// //               width: 30,
// //             ),
// //           ),
// //           // Attendance Icon (SVG)
// //           AnimatedSwitcher(
// //             duration: const Duration(milliseconds: 300),
// //             child: SvgPicture.asset(
// //               _selectedIndex == 2 ? 'assets/icons/bottam-navi/attendance_only-selected.svg' : 'assets/icons/bottam-navi/attendance_only-selected.svg',
// //               key: ValueKey<int>(_selectedIndex),
// //               height: 30,
// //               width: 30,
// //             ),
// //           ),
// //           // Orders Icon (SVG)
// //           AnimatedSwitcher(
// //             duration: const Duration(milliseconds: 300),
// //             child: SvgPicture.asset(
// //               _selectedIndex == 3 ? 'assets/icons/bottam-navi/order-selected.svg' : 'assets/icons/bottam-navi/order-selected.svg',
// //               key: ValueKey<int>(_selectedIndex),
// //               height: 30,
// //               width: 30,
// //             ),
// //           ),
// //           // Profile Icon (SVG)
// //           AnimatedSwitcher(
// //             duration: const Duration(milliseconds: 300),
// //             child: SvgPicture.asset(
// //               _selectedIndex == 4 ? 'assets/icons/bottam-navi/profile-selected.svg' : 'assets/icons/bottam-navi/profile-selected.svg',
// //               key: ValueKey<int>(_selectedIndex),
// //               height: 30,
// //               width: 30,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:inniti_constro/core/constants/constants.dart';
//
// import '../../../routes/app_routes.dart';
// import '../../../widgets/custom_dialog/custom_confirmation_dialog.dart';
// import '../../MenuScreen/menu_screen.dart';
// import '../../orders/orders_screen.dart';
// import '../../profile/profile/profile_page.dart';
//
// import '../../self_attendance/emp_self_attendance.dart';
// import '../home_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0; // Selected navigation index
//
//   final List<Widget> _pages = [
//     HomePageContent(), // Home Page
//     MenuScreen(), // Menu
//     SelfAttendanceScreen(), // Attendance page
//     OrdersScreen(), // Orders
//     ProfilePage(), // Profile
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }
//
//   // ✅ Handle Back Button Press
//   // Future<bool> _onWillPop() async {
//   //   CustomConfirmationDialog.show(
//   //     context,
//   //     title: "Exit App",
//   //     message: "Are you sure you want to exit the app?",
//   //     confirmText: "Exit",
//   //     cancelText: "Cancel",
//   //     onConfirm: () {
//   //       exit(0); // Close the app if user confirms
//   //     },
//   //   );
//   //   return false; // Prevent the default back action (app exit)
//   // }
//
//   Future<bool> _onWillPop() async {
//     if (_selectedIndex == 2) {
//       // If SelfAttendanceScreen is selected, navigate to the entryPoint route
//       Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
//       return false; // Prevent the default back action (app exit)
//     }
//
//     // Show the confirmation dialog for all other screens
//     CustomConfirmationDialog.show(
//       context,
//       title: "Exit App",
//       message: "Are you sure you want to exit the app?",
//       confirmText: "Exit",
//       cancelText: "Cancel",
//       onConfirm: () {
//         exit(0); // Close the app if user confirms
//       },
//     );
//     return false; // Prevent the default back action (app exit)
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _onWillPop(),
//       child: Scaffold(
//         body: _pages[_selectedIndex], // Render the corresponding page
//
//         // ✅ Floating Action Button (FAB)
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             // When FAB is pressed, set the selected index to 2 (for the Attendance page)
//             setState(() {
//               _selectedIndex =
//                   2; // This will show the Attendance page at index 2
//             });
//           },
//           backgroundColor: Colors.deepPurple,
//           shape: const CircleBorder(),
//           child: const Icon(Icons.add, size: 32, color: Colors.white),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//
//         // ✅ Bottom Navigation Bar
//         // bottomNavigationBar: BottomAppBar(
//         //   color: AppColors.primaryWhitebg, // Background color
//         //   shape: const CircularNotchedRectangle(),
//         //   notchMargin: 10.0,
//         //
//         //   child: Row(
//         //     mainAxisAlignment: MainAxisAlignment.spaceAround,
//         //     children: <Widget>[
//         //       // ✅ Home Icon (SVG)
//         //       Stack(
//         //         alignment: Alignment.center,
//         //         children: [
//         //           _selectedIndex == 0
//         //               ? SvgPicture.asset(
//         //                   'assets/icons/bottam-navi/clip.svg',
//         //                 )
//         //               : Container(),
//         //           IconButton(
//         //             icon: SvgPicture.asset(
//         //               _selectedIndex == 0
//         //                   ? 'assets/icons/bottam-navi/home-selected.svg' // Active icon
//         //                   : 'assets/icons/bottam-navi/home-unselected.svg',
//         //               // Inactive icon
//         //               height: 28,
//         //               width: 28,
//         //             ),
//         //             onPressed: () => _onItemTapped(0),
//         //             splashRadius: 30, // Optional: adjust click area
//         //           ),
//         //         ],
//         //       ),
//         //
//         //       // ✅ Menu Icon (SVG)
//         //       Stack(
//         //         alignment: Alignment.center,
//         //         children: [
//         //           _selectedIndex == 1
//         //               ? SvgPicture.asset(
//         //                   'assets/icons/bottam-navi/clip.svg',
//         //                 )
//         //               : Container(),
//         //           IconButton(
//         //             icon: SvgPicture.asset(
//         //               _selectedIndex == 1
//         //                   ? 'assets/icons/bottam-navi/menu-selected.svg'
//         //                   : 'assets/icons/bottam-navi/menu-unselected.svg',
//         //               height: 28,
//         //               width: 28,
//         //               // color: _selectedIndex == 1 ? Colors.deepPurple : Colors.transparent,
//         //             ),
//         //             onPressed: () => _onItemTapped(1),
//         //           ),
//         //         ],
//         //       ),
//         //
//         //       const SizedBox(width: 40), // Space for FAB
//         //
//         //       // ✅ Orders Icon (SVG)
//         //       Stack(
//         //         alignment: Alignment.center,
//         //         children: [
//         //           _selectedIndex == 3
//         //               ? SvgPicture.asset(
//         //                   'assets/icons/bottam-navi/clip.svg',
//         //                 )
//         //               : Container(),
//         //           IconButton(
//         //             icon: SvgPicture.asset(
//         //               _selectedIndex == 3
//         //                   ? 'assets/icons/bottam-navi/order-selected.svg'
//         //                   : 'assets/icons/bottam-navi/order-unselected.svg',
//         //               height: 28,
//         //               width: 28,
//         //               //   color: _selectedIndex == 3 ? Colors.deepPurple : Colors.transparent,
//         //             ),
//         //             onPressed: () => _onItemTapped(3),
//         //           ),
//         //         ],
//         //       ),
//         //
//         //       // ✅ Profile Icon (SVG)
//         //       Stack(
//         //         alignment: Alignment.center,
//         //         children: [
//         //           _selectedIndex == 4
//         //               ? SvgPicture.asset(
//         //                   'assets/icons/bottam-navi/clip.svg',
//         //                 )
//         //               : Container(),
//         //           IconButton(
//         //             icon: SvgPicture.asset(
//         //               _selectedIndex == 4
//         //                   ? 'assets/icons/bottam-navi/profile-selected.svg'
//         //                   : 'assets/icons/bottam-navi/Profile-unselected.svg',
//         //               height: 28,
//         //               width: 28,
//         //               //  color: _selectedIndex == 4 ? Colors.deepPurple : Colors.transparent,
//         //             ),
//         //             onPressed: () => _onItemTapped(4),
//         //           ),
//         //         ],
//         //       ),
//         //     ],
//         //   ),
//         // ),
//
//         bottomNavigationBar: BottomAppBar(
//           color: AppColors.primaryWhitebg,
//           shape: const CircularNotchedRectangle(),
//           notchMargin: 10.0,
//           child: SizedBox(
//             height: 70, // Fixed height for consistent layout
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 _buildNavItem(0, 'home'),
//                 _buildNavItem(1, 'menu'),
//                 const SizedBox(width: 50), // Space for FAB (Adjusted for better look)
//                 _buildNavItem(3, 'order'),
//                 _buildNavItem(4, 'setting'),
//
//               ],
//             ),
//           ),
//         ),
//
//       ),
//     );
//   }
//
//   Widget _buildNavItem(int index, String iconName) {
//     final bool isSelected = _selectedIndex == index;
//
//     return Expanded(   // Responsive: take equal space
//       child: GestureDetector(
//         onTap: () => _onItemTapped(index),
//         child: SizedBox(
//           height: 70,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               if (isSelected)
//                 SvgPicture.asset(
//                   'assets/icons/bottam-navi/clip.svg',
//                   height: 56,
//                   width: 56,
//                   fit: BoxFit.none, // Prevent movement
//                 ),
//               SvgPicture.asset(
//                 isSelected
//                     ? 'assets/icons/bottam-navi/${iconName}-selected.svg'
//                     : 'assets/icons/bottam-navi/${iconName}-unselected.svg',
//                 height: 28,
//                 width: 28,
//                 fit: BoxFit.none, // Prevent movement
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_dialog/custom_confirmation_dialog.dart';
import '../../MenuScreen/menu_screen.dart';
//import '../../attendance_only/salf_attendance.dart';
import '../../attedance/attedance.dart';
import '../../orders/orders_screen.dart';


import '../../settings/settings_page.dart';
import '../home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePageContent(),
    MenuScreen(),
    SelfAttendanceScreen(),
    OrdersScreen(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) return; // Ignore tap on Attendance (center tab)
    setState(() => _selectedIndex = index);
  }


  Future<bool> _onWillPop() async {
    if (_selectedIndex == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
      return false;
    }

    CustomConfirmationDialog.show(
      context,
      title: "Exit App",
      message: "Are you sure you want to exit the app?",
      confirmText: "Exit",
      cancelText: "Cancel",
      onConfirm: () {
        exit(0);
      },
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        body: _pages[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: AppColors.primaryWhitebg,
          color: Colors.grey,
          activeColor: AppColors.primary,
          height: 70,
          items: [
            TabItem(
              icon: SvgPicture.asset(
                'assets/icons/bottam-navi/home-unselected.svg',
                //color: Colors.grey,
                height: 24,
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/bottam-navi/home-selected.svg',
                 // color: Colors.deepPurple,
                  height: 24,
                ),
              ),
              title: 'Home',
            ),
            TabItem(
              icon: SvgPicture.asset(
                'assets/icons/bottam-navi/menu-unselected.svg',
                //color: Colors.grey,
                height: 24,
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/bottam-navi/menu-selected.svg',
                  //color: Colors.deepPurple,
                  height: 24,
                ),
              ),
              title: 'Menu',
            ),
            const TabItem(
              icon: SizedBox.shrink(),
              title: 'Attendance',
            ),
            TabItem(
              icon: SvgPicture.asset(
                'assets/icons/bottam-navi/order-unselected.svg',
               // color: Colors.grey,
                height: 24,
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/bottam-navi/order-selected.svg',
                  color:AppColors.white,
                  height: 24,
                ),
              ),
              title: 'Orders',
            ),
            TabItem(
              icon: SvgPicture.asset(
                'assets/icons/bottam-navi/setting-unselected.svg',
               // color: Colors.grey,
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/bottam-navi/setting-selected.svg',
                color:AppColors.white,
                height: 24,
              ),
              title: 'Settings',
            ),
          ],
          onTap: _onItemTapped,
          initialActiveIndex: _selectedIndex,
        ),
      ),
    );
  }
}
