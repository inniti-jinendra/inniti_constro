// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../core/network/logger.dart';
// import '../../core/utils/secure_storage_util.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/CustomToast/custom_snackbar.dart';
// import '../../widgets/global_loding/global_loader.dart';
// import 'animated_splash.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   double _fontSize = 2;
//   double _containerSize = 1.5;
//   double _textOpacity = 0.0;
//   double _containerOpacity = 0.0;
//
//   late AnimationController _animationController;
//   late Animation<double> _textAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     AppLogger.info("🟢 SplashScreen Initialized");
//
//     _animationController =
//         AnimationController(vsync: this, duration: Duration(seconds: 3));
//
//     _textAnimation = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
//         parent: _animationController, curve: Curves.fastLinearToSlowEaseIn))
//       ..addListener(() {
//         setState(() {
//           _textOpacity = 1.0;
//         });
//       });
//
//     _animationController.forward();
//
//     Timer(Duration(seconds: 2), () {
//       setState(() {
//         _fontSize = 1.06;
//       });
//     });
//
//     Timer(Duration(seconds: 2), () {
//       setState(() {
//         _containerSize = 2;
//         _containerOpacity = 1;
//       });
//     });
//
//     Timer(Duration(seconds: 4), () {
//       setState(() {
//         Navigator.pushReplacement(context, CustomPageTransition(NextScreen()));
//       });
//     });
//
//     // ✅ Call `_goToHomePage()` after splash animation
//     Timer(Duration(seconds: 4), () {
//       _goToHomePage();
//     });
//
//   }
//
//   void _goToHomePage() async {
//     try {
//       AppLogger.info("🔹 Retrieving stored session data...");
//
//       // ✅ Show custom global loader
//       GlobalLoader.show(context);
//
//       await Future.delayed(const Duration(milliseconds: 500)); // Small delay for SharedPreferences
//
//       // ✅ Retrieve stored session details
//       String loggedIn = await SharedPreferencesUtil.getString("LoggedIn") ?? "false";
//       String userId = await SharedPreferencesUtil.getString("ActiveUserID") ?? "";
//       String ActiveProjectID = await SharedPreferencesUtil.getString("ActiveProjectID") ?? "";
//
//       AppLogger.info("📌 Retrieved User Session Data:");
//       AppLogger.info("🔹 LoggedIn: $loggedIn");
//       AppLogger.info("🔹 UserID: $userId");
//       AppLogger.info("🔹 UserID: $ActiveProjectID");
//
//       // ✅ Hide the loader once data is retrieved
//       GlobalLoader.hide();
//
//       if (loggedIn == "true" && userId.isNotEmpty) {
//         AppLogger.info("✅ User is authenticated. Redirecting to Home...");
//         Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
//       } else {
//         AppLogger.warn("❌ User session is invalid. Redirecting to Login...");
//         Navigator.pushReplacementNamed(context, AppRoutes.login);
//       }
//     } catch (e) {
//       // ✅ Hide loader on error
//       GlobalLoader.hide();
//       AppLogger.error("❌ Error retrieving session data: $e");
//       CustomSnackbar.show(context, message: "Failed to proceed. Please try again.");
//     }
//   }
//
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               AnimatedContainer(
//                   duration: Duration(milliseconds: 2000),
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   height: _height / _fontSize
//               ),
//               AnimatedOpacity(
//                 duration: Duration(milliseconds: 1000),
//                 opacity: _textOpacity,
//                 child: Text(
//                   'INNITI SOFTWARE',  // Replace with your actual app name
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: _textAnimation.value,
//                     fontFamily: 'Roboto', // Ensure you have added this font in pubspec.yaml
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Center(
//             child: AnimatedOpacity(
//               duration: Duration(milliseconds: 5000),
//               curve: Curves.fastLinearToSlowEaseIn,
//               opacity: _containerOpacity,
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 5000),
//                 curve: Curves.fastLinearToSlowEaseIn,
//                 height: _width / _containerSize,
//                 width: _width / _containerSize,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                  child: Image.asset('assets/images/inniti_logo.png') // Replace with your logo image
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CustomPageTransition extends PageRouteBuilder {
//   final Widget page;
//
//   CustomPageTransition(this.page)
//       : super(
//     pageBuilder: (context, animation, anotherAnimation) => page,
//     transitionDuration: Duration(milliseconds: 2000),
//     transitionsBuilder: (context, animation, anotherAnimation, child) {
//       animation = CurvedAnimation(
//         curve: Curves.fastLinearToSlowEaseIn,
//         parent: animation,
//       );
//       return Align(
//         alignment: Alignment.bottomCenter,
//         child: SizeTransition(
//           sizeFactor: animation,
//           child: page,
//           axisAlignment: 0,
//         ),
//       );
//     },
//   );
// }
//
// class NextScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // appBar: AppBar(
//       //   backgroundColor: Colors.black12,
//       //   centerTitle: true,
//       //   title: Text(
//       //     'INNITI SOFTWARE ERP', // Replace with your app's name
//       //     style: TextStyle(
//       //       color: Colors.white,
//       //       fontWeight: FontWeight.bold,
//       //       fontSize: 20,
//       //       fontFamily: 'Roboto', // Ensure this font is added to your pubspec.yaml
//       //     ),
//       //   ),
//       //   systemOverlayStyle: SystemUiOverlayStyle.light,
//       // ),
//       body: OnboardingScreen(),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';

import '../../core/network/logger.dart';
import '../../core/utils/secure_storage_util.dart';
import '../../routes/app_routes.dart';
import '../../widgets/CustomToast/custom_snackbar.dart';
import '../../widgets/global_loding/global_loader.dart';
import 'animated_splash.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  double _fontSize = 2;
  double _containerSize = 1.5;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  late AnimationController _animationController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    AppLogger.info("🟢 SplashScreen Initialized");

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _textAnimation = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _animationController.forward();

    Timer(Duration(seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        _containerSize = 2;
        _containerOpacity = 1;
      });
    });

    // ✅ Check login status & navigate accordingly
    Timer(Duration(seconds: 4), () {
      _goToHomePage();
    });
  }

  void _goToHomePage() async {
    try {
      AppLogger.info("🔹 Retrieving stored session data...");

      // ✅ Show loader
      GlobalLoader.show(context);

      await Future.delayed(const Duration(milliseconds: 300)); // Slight delay for preference fetch

      // ✅ Retrieve stored session details
      String loggedIn = await SharedPreferencesUtil.getString("LoggedIn") ?? "false";
      String userId = await SharedPreferencesUtil.getString("ActiveUserID") ?? "";
      String token = await SecureStorageUtil.readSecureData("Token") ?? "";
      String activeProjectId = await SharedPreferencesUtil.getString("ActiveProjectID") ?? "";
      String? isAuthorized = await SecureStorageUtil.readSecureData("IsAuthorized") ?? "false";
      String? userType = await SecureStorageUtil.readSecureData("UserType") ?? "REGULAR";

      AppLogger.info("📌 Session Check:");
      AppLogger.info("🔹 LoggedIn: $loggedIn");
      AppLogger.info("🔹 UserID: $userId");
      AppLogger.info("🔹 Token: $token");
      AppLogger.info("🔹 ActiveProjectID: $activeProjectId");
      AppLogger.info("🔹 IsAuthorized: $isAuthorized");
      AppLogger.info("🔹 UserType: $userType");

      // ✅ Hide loader
      GlobalLoader.hide();

      // 🔐 Cross check: Must be logged in, have userID & token
      if (loggedIn == "true" && userId.isNotEmpty && token.isNotEmpty  && isAuthorized == "true") {
        AppLogger.info("✅ Valid session. Redirecting to Home...");

       // Navigator.pushReplacementNamed(context, AppRoutes.OnlyselfAttendance);
       // Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);

        if (userType == "ATTENDANCE ONLY") {
          Navigator.pushReplacementNamed(context, AppRoutes.OnlyselfAttendance);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
        }

      } else {
        AppLogger.warn("❌ Invalid session. Redirecting to Login/Onboarding...");

        // Log if not authorized
        if (isAuthorized != "true") {
          AppLogger.warn("❌ Not Authorized! IsAuthorized: $isAuthorized");
        }
        AppLogger.warn("❌ Invalid session. Redirecting to Login/Onboarding...");

        Navigator.pushReplacement(
          context,
          CustomPageTransition(OnboardingScreen()),
        );
      }
    } catch (e) {
      GlobalLoader.hide();
      AppLogger.error("❌ Session error: $e");
      CustomSnackbar.show(context, message: "Something went wrong. Please try again.");
    }
  }


  // void _goToHomePage() async {
  //   try {
  //     AppLogger.info("🔹 Retrieving stored session data...");
  //
  //     // ✅ Show custom global loader
  //     GlobalLoader.show(context);
  //
  //     await Future.delayed(const Duration(milliseconds: 500)); // Small delay for SharedPreferences
  //
  //     // ✅ Retrieve stored session details
  //     String loggedIn = await SharedPreferencesUtil.getString("LoggedIn") ?? "false";
  //     String userId = await SharedPreferencesUtil.getString("ActiveUserID") ?? "";
  //     String ActiveProjectID = await SharedPreferencesUtil.getString("ActiveProjectID") ?? "";
  //
  //     AppLogger.info("📌 Retrieved User Session Data:");
  //     AppLogger.info("🔹 LoggedIn: $loggedIn");
  //     AppLogger.info("🔹 UserID: $userId");
  //     AppLogger.info("🔹 ActiveProjectID: $ActiveProjectID");
  //
  //     // ✅ Hide the loader once data is retrieved
  //     GlobalLoader.hide();
  //
  //     if (loggedIn == "true" && userId.isNotEmpty) {
  //       AppLogger.info("✅ User is authenticated. Redirecting to Home...");
  //       Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
  //
  //     } else {
  //       AppLogger.warn("❌ User session is invalid. Redirecting to Onboarding...");
  //       Navigator.pushReplacement(
  //         context,
  //         CustomPageTransition(OnboardingScreen()), // ✅ Redirect to Onboarding if not logged in
  //       );
  //     }
  //   } catch (e) {
  //     // ✅ Hide loader on error
  //     GlobalLoader.hide();
  //     AppLogger.error("❌ Error retrieving session data: $e");
  //     CustomSnackbar.show(context, message: "Failed to proceed. Please try again.");
  //   }
  // }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                  duration: Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: _height / _fontSize
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 1000),
                opacity: _textOpacity,
                child: Text(
                  'INNITI SOFTWARE',  // Replace with your actual app name
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: _textAnimation.value,
                    fontFamily: 'Roboto', // Ensure you have added this font in pubspec.yaml
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 5000),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: _containerOpacity,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 5000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: _width / _containerSize,
                  width: _width / _containerSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset('assets/images/animated_splash_images/InnitiLogoWhite.png') // Replace with your logo image
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPageTransition extends PageRouteBuilder {
  final Widget page;

  CustomPageTransition(this.page)
      : super(
    pageBuilder: (context, animation, anotherAnimation) => page,
    transitionDuration: Duration(milliseconds: 2000),
    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(
        curve: Curves.fastLinearToSlowEaseIn,
        parent: animation,
      );
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizeTransition(
          sizeFactor: animation,
          child: page,
          axisAlignment: 0,
        ),
      );
    },
  );
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OnboardingScreen(),
    );
  }
}
