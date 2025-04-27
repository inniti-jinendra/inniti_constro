// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:inniti_constro/routes/app_routes.dart';
// import 'package:inniti_constro/routes/on_generate_route.dart';
// import 'package:inniti_constro/theme/themes/app_themes.dart';
//
// import 'features/MenuScreen/menu_screen.dart';
// import 'features/home/home_screen_entry_point/home_screen_entry_point.dart';
// import 'features/labour/labour_master_screen.dart';
// import 'features/splash/splash_screen.dart';
//
// void main() {
//   runApp(ProviderScope(child: MyApp()));
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Inniti ERP',
//       theme: AppTheme.defaultTheme,
//       //initialRoute: AppRoutes.splashScreen,
//       home: HomePage(),
//       //home: SplashScreen(),
//       onGenerateRoute: RouteGenerator.onGenerate,
//
//     );
//   }
// }


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inniti_constro/routes/on_generate_route.dart';
import 'package:inniti_constro/theme/themes/app_themes.dart';
import 'core/network/connectivity_status_notifier.dart';
import 'core/network/logger.dart';

import 'features/offline_page/offline_page.dart';
import 'features/splash/splash_screen.dart';

// void main() {
//   runApp(ProviderScope(child: MyApp()));
// }

void main() {
  runApp(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: Size(375, 812), // Use the reference screen size (usually iPhone X resolution or your preferred base)
        builder: (context, child) {
          return MyApp();
        },
      ),
    ),
  );
}

// void main() {
//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode, // Only enable in debug or profile mode
//       builder: (context) => ProviderScope(
//         child: ScreenUtilInit(
//           designSize: Size(375, 812),
//           builder: (context, child) => MyApp(),
//         ),
//       ),
//     ),
//   );
// }

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);

    // Log the current connectivity status
    AppLogger.info("🔹 Connectivity Status in MyApp: $connectivityStatus");

    return MaterialApp(
      key: ValueKey(connectivityStatus),  // ✅ Forces a rebuild when connectivity changes
      debugShowCheckedModeBanner: false,
      title: 'Inniti ERP',
      theme: AppTheme.defaultTheme,
       home: _buildHome(connectivityStatus),
      //home: LabourAttendancePage(),
      onGenerateRoute: RouteGenerator.onGenerate,
    );
  }
  Widget _buildHome(ConnectivityStatus connectivityStatus) {
    if (connectivityStatus == ConnectivityStatus.isDisconnected) {
      return OfflinePage();  // ✅ Show OfflinePage when offline
    } else {
      return SplashScreen();  // ✅ Normal flow
    }
  }

}

// class MyApp extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final connectivityStatus = ref.watch(connectivityStatusProvider);
//
//     // Log the current connectivity status
//     AppLogger.info("🔹 Connectivity Status in MyApp: $connectivityStatus");
//
//     // If the device is disconnected, show the offline page
//     if (connectivityStatus == ConnectivityStatus.isDisconnected) {
//
//       AppLogger.warn("❌ No Internet Connection! Navigating to Offline Page.");
//
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Inniti ERP',
//         theme: AppTheme.defaultTheme,
//         home: OfflinePage(),  // Navigate to the Offline Page
//         onGenerateRoute: RouteGenerator.onGenerate,
//       );
//     }
//
//     // Otherwise, continue with the normal app
//     AppLogger.info("✅ Internet Connected! Navigating to Main App.");
//
//     // Otherwise, continue with the normal app
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Inniti ERP',
//       theme: AppTheme.defaultTheme,
//       initialRoute: AppRoutes.splashScreen,
//       //home: IntroLoginPage(),  // Proceed to the HomePage
//       //home: SignUpPagePhone(),  // Proceed to the HomePage
//       //onGenerateRoute: RouteGenerator.onGenerate,
//       onGenerateRoute: RouteGenerator.onGenerate,
//     );
//   }
// }


//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'core/network/customer_splash_screen.dart';
// import 'core/network/network_info.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Register the NetworkController globally using GetX
//   Get.put(NetworkController()); // Ensure that it's initialized
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const GetMaterialApp(
//       themeMode: ThemeMode.system,
//       debugShowCheckedModeBanner: false,
//       home: CustomerSplashScreen(),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'core/network/connectivity_status_notifier.dart';
//
// void main() {
//   runApp(ProviderScope(child: NetworkConnectivity()));
// }
//
// class NetworkConnectivity extends StatelessWidget {
//   const NetworkConnectivity({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final connectivityStatus = ref.watch(connectivityStatusProvider);
//     final previousConnectivityStatus = ref.watch(connectivityStatusProvider.notifier).previousStatus;
//
//     // Show a SnackBar only if the connectivity status has changed
//     if (connectivityStatus != previousConnectivityStatus) {
//       // Update the previous status with the current one
//       ref.read(connectivityStatusProvider.notifier).updatePreviousStatus(connectivityStatus);
//
//       // Show the Snackbar
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               connectivityStatus == ConnectivityStatus.isConnected
//                   ? 'Connected to Internet'
//                   : 'Disconnected from Internet',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20.0,
//               ),
//             ),
//             backgroundColor: connectivityStatus == ConnectivityStatus.isConnected
//                 ? Colors.green
//                 : Colors.red,
//           ),
//         );
//       });
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.black54,
//       appBar: AppBar(
//         title: const Text(
//           'Network Connectivity',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Connectivity Status',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               connectivityStatus == ConnectivityStatus.isConnected
//                   ? 'Connected to Internet'
//                   : 'Disconnected from Internet',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20.0,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
