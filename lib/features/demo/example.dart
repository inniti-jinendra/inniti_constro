// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
// import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
//
// import '../../core/constants/app_colors.dart';
//
// // Entry point of the app
// void main() => runApp(MyApp());
//
// // Root widget of the app
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // Removes debug banner
//       home: const CustomHomePage(), // Sets the home screen
//     );
//   }
// }
//
// // Stateful widget to handle tab navigation & UI
// class CustomHomePage extends StatefulWidget {
//   const CustomHomePage({super.key});
//
//   @override
//   State<CustomHomePage> createState() => _CustomHomePageState();
// }
//
// // State class with TickerProvider for animations
// class _CustomHomePageState extends State<CustomHomePage> with TickerProviderStateMixin {
//   late MotionTabBarController _tabController; // Controller for tab bar navigation
//
//   // List of pages corresponding to each tab
//   final List<Widget> _pages = const [
//     Center(child: Text('Home Page')),
//     Center(child: Text('Menu Page')),
//     Center(child: Text('Attendance Page')),
//     Center(child: Text('Orders Page')),
//     Center(child: Text('Settings Page')),
//   ];
//
//   // List of SVG asset paths for each tab (selected & unselected)
//   final List<Map<String, String>> _tabIcons = [
//
//     {
//       'selected': 'assets/icons/bottam-navi/home-selected.svg',
//       'unselected': 'assets/icons/bottam-navi/home-unselected.svg',
//     },
//     {
//       'selected': 'assets/icons/bottam-navi/menu-unselected.svg',
//       'unselected': 'assets/icons/bottam-navi/menu-selected.svg',
//     },
//     {
//       'selected': 'assets/icons/bottam-navi/attendance-selected.svg',
//       'unselected': 'assets/icons/bottam-navi/attendance-unselected.svg',
//     },
//     {
//       'selected': 'assets/icons/bottam-navi/order-unselected.svg',
//       'unselected': 'assets/icons/bottam-navi/order-selected.svg',
//     },
//     {
//       'selected': 'assets/icons/bottam-navi/setting-unselected.svg',
//       'unselected': 'assets/icons/bottam-navi/setting-selected.svg',
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     // Initializing the tab controller with 5 tabs and default index 0
//     _tabController = MotionTabBarController(
//       //initialIndex: 0,
//       length: _pages.length,
//       vsync: this,
//     );
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose(); // Dispose controller when not in use
//     super.dispose();
//   }
//
//   // Helper method to build custom SVG icons with selected/unselected assets
//   Widget _customSvgIcon(
//       String selectedAsset,
//       String unselectedAsset,
//       bool isSelected, {
//         double size = 30,
//       }) {
//     return Container(
//       padding: const EdgeInsets.all(4.0),
//       decoration: isSelected
//           ? BoxDecoration(
//         color: Colors.indigo, // Background highlight for selected icon
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.deepPurple, width: 5),
//       ) : null,
//       //     : BoxDecoration(
//       //   color: Colors.red, // Background highlight for selected icon
//       //   shape: BoxShape.circle,
//       //   border: Border.all(color: Colors.pink, width: 5),
//       // ), // No decoration for unselected
//       child: SvgPicture.asset(
//         isSelected ? selectedAsset : unselectedAsset,
//        // height:isSelected ? size : null,
//         color: isSelected ? Colors.red : Colors.white, // White if selected, grey if not
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryWhitebg,
//       // Displaying the selected tab's corresponding page
//       body: _pages[_tabController.index],
//
//       // Floating action button placed in center docked position
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _tabController.index = 2; // Navigate to Attendance tab on FAB click
//           });
//         },
//         backgroundColor: const Color(0xff5B21B1), // Custom purple color
//         shape: const CircleBorder(),
//         child: const Icon(Icons.add, size: 32, color: Colors.white),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//
//       // Bottom navigation bar using MotionTabBar
//       bottomNavigationBar: MotionTabBar(
//         controller: _tabController,
//         initialSelectedTab: "Home", // Initial selected tab label
//         labels: const ["Home", "Menu", "Attendance", "Orders", "Settings"], // Tab labels
//
//         // Icons for each tab with selection highlight
//         iconWidgets: List.generate(_tabIcons.length, (index) {
//           bool isSelected = _tabController.index == index;
//
//           return _customSvgIcon(
//             _tabIcons[index]['selected']!,
//             _tabIcons[index]['unselected']!,
//             isSelected,
//           );
//         }),
//
//         // Tab bar styling properties
//         tabSize: 50,
//         tabBarHeight: 65,
//         textStyle: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//         tabIconSize: 26.0,
//         tabIconSelectedSize: 30.0,
//         tabSelectedColor: Colors.deepPurple,
//         tabBarColor: AppColors.primaryWhitebg,
//
//         // Callback when a tab is selected
//         onTabItemSelected: (int value) {
//           setState(() {
//             _tabController.index = value; // Update selected tab index
//           });
//         },
//       ),
//     );
//   }
// }
