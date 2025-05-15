// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:inniti_constro/routes/unknown_page.dart';
//
// import '../features/attendance_only/attendance_screen.dart';
// import '../features/authentication/OtpVerification/otp_screen.dart';
// import '../features/authentication/company_code/company_code_screen.dart';
// import '../features/authentication/email_or_phone/phone_login_screen.dart';
// import '../features/drawer/about_us_page.dart';
// import '../features/drawer/contact_us_page.dart';
// import '../features/drawer/drawer_page.dart';
// import '../features/drawer/faq_page.dart';
// import '../features/drawer/help_page.dart';
// import '../features/drawer/terms_and_conditions_page.dart';
//
//
// import '../features/home/home_screen_entry_point/home_screen_entry_point.dart';
// import '../features/home/search_page.dart';
// import '../features/orders/orders_screen.dart';
// import '../features/profile/profile_screen.dart';
// import '../features/splash/splash_screen.dart';
//
// class AppRoutes {
//   static const String splash = '/';
//   static const String companyCode = '/companyCode';
//   static const String emailOrPhone = '/emailOrPhone';
//   static const String otp = '/OtpVerification';
//   static const String home = '/home';
//   static const String attendance_only = '/attendance_only';
//   static const String orders = '/orders';
//   static const String profile = '/profile';
//   static const String drawerPage = '/drawerPage';
//   static const String search = '/search';
//   static const String aboutUs = '/aboutUs'; // Add route for AboutUsPage
//   static const String contactUs = '/contactUs'; // Add route for ContactUsPage
//   static const String faq = '/faq'; // Add route for FAQPage
//   static const String help = '/help'; // Add route for HelpPage
//   static const String termsAndConditions = '/termsAndConditions';
//
//   //static String settingsNotifications; // Add route for TermsAndConditionsPage
//
//   static Route? onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case splash:
//         return _buildRoute(SplashScreen(), settings);
//       case companyCode:
//         return _buildRoute(WelcomeCompanyCode(), settings);
//       case emailOrPhone:
//         return _buildRoute(WelcomeEmailPhone(), settings);
//       case otp:
//         return _buildRoute(OtpVerification(), settings);
//       case home:
//         return _buildRoute(HomePage(), settings);
//       case attendance_only:
//         return _buildRoute(AttendanceScreen(), settings);
//       case orders:
//         return _buildRoute(OrdersScreen(), settings);
//       case profile:
//         return _buildRoute(ProfileScreen(), settings);
//       case drawerPage:
//         return CupertinoPageRoute(builder: (_) =>  DrawerPage());
//       case search:
//         return CupertinoPageRoute(builder: (_) => const SearchPage());
//       case aboutUs:
//         return _buildRoute(AboutUsPage(), settings); // Route for AboutUsPage
//       case contactUs:
//         return _buildRoute(ContactUsPage(), settings); // Route for ContactUsPage
//       case faq:
//         return _buildRoute(FAQPage(), settings); // Route for FAQPage
//       case help:
//         return _buildRoute(HelpPage(), settings); // Route for HelpPage
//       case termsAndConditions:
//         return _buildRoute(TermsAndConditionsPage(), settings); // Route for TermsAndConditionsPage
//       default:
//         return _buildRoute(UnknownPage(), settings); // Default fallback to splash screen
//     }
//   }
//
//   static MaterialPageRoute _buildRoute(Widget screen, RouteSettings settings) {
//     return MaterialPageRoute(
//       builder: (context) => screen,
//       settings: settings,
//     );
//   }
// }

class AppRoutes {

  //static const String splashScreen = '/';

  /// The Initial Page
  static const introLogin = '/intro_login'; //ERP
  static const splashScreen = '/splashScreen' ; //ERP
  static const onboarding = '/onboarding'; //ERP

  /* <---- Login, Signup -----> */


  static const WelcomCompnyCode = '/WelcomCompnyCode';//ERP

  static const SignUpPagePhone = '/signupPhone'; //ERP
  static const SignUpPageEmail = '/signupEmail'; //ERP

  static const numberVerification = '/numberVerification'; //ERP

  static const login = '/login';
  static const loginOrSignup = '/loginOrSignup';
  static const forgotPassword = '/forgotPassword';
  static const passwordReset = '/passwordReset';

  /* <---- ENTRYPOINT -----> */
  static const entryPoint = '/entry_point'; // ERP

  /* <---- Products Order Process -----> */
  static const home = '/home';
  static const newItems = '/newItems';
  static const popularItems = '/popularItems';
  static const bundleProduct = '/bundleProduct';
  static const createMyPack = '/createMyPack';
  static const bundleDetailsPage = '/bundleDetailsPage';
  static const productDetails = '/productDetails';
  static const cartPage = '/cartPage';
  static const savePage = '/favouriteList';
  static const checkoutPage = '/checkoutPage';

  /// Order Status
  static const orderSuccessfull = '/orderSuccessfull';
  static const orderFailed = '/orderFailed';
  static const noOrderYet = '/noOrderYet';

  /// Category
  static const category = '/category';
  static const categoryDetails = '/categoryDetails';

  /// Search Page
  static const search = '/search';
  static const searchResult = '/searchResult';

  /* <---- Profile & Settings -----> */

  static const profile = 'profile';
  static const accessibility = '/accessibility';
  static const menuAccessibility = '/MenuAccessibility';
  static const myOrder = '/myOrder';
  static const orderDetails = '/orderDetails';
  static const coupon = '/coupon';
  static const couponDetails = '/couponDetails';
  static const deliveryAddress = '/deliveryAddress';
  static const newAddress = '/newAddress';
  static const orderTracking = '/orderTracking';
  static const profileEdit = '/profileEdit';
  static const notifications = '/notifications';
  static const settings = '/settings';
  static const settingsLanguage = '/settingsLanguage';
  static const settingsNotifications = '/settingsNotifications';
  static const changePassword = '/changePassword';
  static const changePhoneNumber = '/changePhoneNumber';

  /* <---- Review and Comments -----> */
  static const review = '/review';
  static const submitReview = '/submitReview';
  // Not Needed
  // static const errorPage = '/errorPage';

  /* <---- Drawer Page -----> */
  static const drawerPage = '/drawerPage';
  static const aboutUs = '/aboutUs';
  static const faq = '/faq';
  static const termsAndConditions = '/termsAndConditions';
  static const help = '/help';
  static const contactUs = '/contactUs';

  /* <---- Payment Method -----> */
  static const paymentMethod = '/paymentMethod';
  static const paymentCardAdd = '/paymentCardAdd';

  /* <---- Labour Method -----> */
  static const labourGridPage = "/labourGridPage";
  static const newlabour = '/newlabour';

  /* <---- Purchase Requisition -----> */
  static const prGridPage = "/prGridPage";
  static const newPR = "/newPR";

  /* <---- Purchase Requisition -----> */
  static const selfAttendance = "/selfAttendance";
  static const OnlyselfAttendance = "/OnlySelfAttendance";
  static const LaborAttendanceAdd = "/laborAttendanceadd";

  /* <---- User Profile -----> */
  static const myProfile = "/myProfile";
  static const salarySlip = "/salarySlip";
  static const assignItems = "/assignItems";

  /* <---- DPR Dashboard -----> */
  static const erpDprEntry = "/erpDprEntry";
}
