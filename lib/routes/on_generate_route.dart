import 'package:flutter/cupertino.dart';

import '../features/MenuScreen/pages/labour_attedance_new/labour_attendance_screen.dart';
import '../features/attendance_only/attendance_screen.dart';
import '../features/authentication/OtpVerification/otp_screen.dart';
import '../features/authentication/company_code/company_code_screen.dart';
import '../features/authentication/email_or_phone/login_email/email_login_screen.dart';
import '../features/authentication/email_or_phone/login_phone/phone_login_screen.dart';
import '../features/drawer/contact_us_page.dart';
import '../features/drawer/drawer_page.dart';
import '../features/drawer/faq_page.dart';
import '../features/drawer/help_page.dart';
import '../features/drawer/terms_and_conditions_page.dart';

import '../features/home/bundle_details_page.dart';
import '../features/home/bundle_product_details_page.dart';
import '../features/home/components/ERP_dpr_entry.dart';
import '../features/home/home_screen_entry_point/home_screen_entry_point.dart';

import '../features/labour/labour_grid_page.dart';

import '../features/profile/profile/address/address_page.dart';
import '../features/profile/profile/address/new_address_page.dart';
import '../features/profile/profile/assigned_items_page.dart';
import '../features/profile/profile/coupon/coupon_details_page.dart';
import '../features/profile/profile/coupon/coupon_page.dart';
import '../features/profile/profile/notification_page.dart';
import '../features/profile/profile/order/my_order_page.dart';
import '../features/profile/profile/order/order_details.dart';
import '../features/profile/profile/payment_method/add_new_card_page.dart';
import '../features/profile/profile/payment_method/payment_method_page.dart';
import '../features/profile/profile/profile_edit_page.dart';
import '../features/profile/profile/salary_slip_page.dart';
import '../features/profile/profile/settings/change_password_page.dart';
import '../features/profile/profile/settings/change_phone_number_page.dart';
import '../features/profile/profile/settings/language_settings_page.dart';
import '../features/profile/profile/settings/notifications_settings_page.dart';
import '../features/purchase_requisition/pr_grid_page.dart';
import '../features/purchase_requisition/pr_master_page.dart';
import '../features/settings/about_us_page.dart';
import '../features/settings/accessibility_page_screen.dart';
import '../features/settings/menu_accessibility_page_screen.dart';
import '../features/settings/settings_page.dart';
import '../features/splash/splash_screen.dart';
import 'app_routes.dart';
import 'unknown_page.dart';

class RouteGenerator {
  static Route? onGenerate(RouteSettings settings) {
    final route = settings.name;
    final params = settings.arguments;

    switch (route) {
      case AppRoutes.splashScreen:
        return CupertinoPageRoute(builder: (_) =>  SplashScreen());

      case AppRoutes.introLogin:
        return CupertinoPageRoute(builder: (_) => const IntroLoginPage());

      // case AppRoutes.onboarding:
      //   return CupertinoPageRoute(builder: (_) => const OnboardingPage());

      case AppRoutes.entryPoint:
        return CupertinoPageRoute(builder: (_) => const HomePage());

      // case AppRoutes.search:
      //   return CupertinoPageRoute(builder: (_) => const SearchPage());
      //
      // case AppRoutes.searchResult:
      //   return CupertinoPageRoute(builder: (_) => const SearchResultPage());

      // case AppRoutes.cartPage:
      //   return CupertinoPageRoute(builder: (_) => const CartPage());
      //
      // case AppRoutes.savePage:
      //   return CupertinoPageRoute(builder: (_) => const SavePage());
      //
      // case AppRoutes.checkoutPage:
      //   return CupertinoPageRoute(builder: (_) => const CheckoutPage());
      //
      // case AppRoutes.categoryDetails:
      //   return CupertinoPageRoute(builder: (_) => const CategoryProductPage());

      case AppRoutes.WelcomCompnyCode:
        return CupertinoPageRoute(builder: (_) => const IntroLoginPage());

    // case AppRoutes.login:
      //   return CupertinoPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.SignUpPagePhone:
        return CupertinoPageRoute(builder: (_) => const SignUpPagePhone());

        case AppRoutes.SignUpPageEmail:
        return CupertinoPageRoute(builder: (_) => const SignUpPageEmail());

      // case AppRoutes.loginOrSignup:
      //   return CupertinoPageRoute(builder: (_) => const LoginOrSignUpPage());

      case AppRoutes.numberVerification:
        return CupertinoPageRoute(
          builder: (_) => NumberVerificationPage(users: params),
        );

      // case AppRoutes.forgotPassword:
      //   return CupertinoPageRoute(builder: (_) => const ForgetPasswordPage());
      //
      // case AppRoutes.passwordReset:
      //   return CupertinoPageRoute(builder: (_) => const PasswordResetPage());

      // case AppRoutes.newItems:
      //   return CupertinoPageRoute(builder: (_) => const NewItemsPage());

      // case AppRoutes.popularItems:
      //   return CupertinoPageRoute(builder: (_) => const PopularPackPage());

      case AppRoutes.bundleProduct:
        return CupertinoPageRoute(
          builder: (_) => const BundleProductDetailsPage(),
        );

      case AppRoutes.bundleDetailsPage:
        return CupertinoPageRoute(builder: (_) => const BundleDetailsPage());

      // case AppRoutes.productDetails:
      //   return CupertinoPageRoute(builder: (_) => const ProductDetailsPage());

      // case AppRoutes.createMyPack:
      //   return CupertinoPageRoute(builder: (_) => const BundleCreatePage());

      // case AppRoutes.orderSuccessfull:
      //   return CupertinoPageRoute(builder: (_) => const OrderSuccessfullPage());

      // case AppRoutes.orderFailed:
      //   return CupertinoPageRoute(builder: (_) => const OrderFailedPage());

      case AppRoutes.myOrder:
        return CupertinoPageRoute(builder: (_) => const AllOrderPage());

      case AppRoutes.orderDetails:
        return CupertinoPageRoute(builder: (_) => const OrderDetailsPage());

      case AppRoutes.coupon:
        return CupertinoPageRoute(builder: (_) => const CouponAndOffersPage());

      case AppRoutes.couponDetails:
        return CupertinoPageRoute(builder: (_) => const CouponDetailsPage());

      case AppRoutes.profileEdit:
        return CupertinoPageRoute(builder: (_) => const ProfileEditPage());

      case AppRoutes.newAddress:
        return CupertinoPageRoute(builder: (_) => const NewAddressPage());

      case AppRoutes.deliveryAddress:
        return CupertinoPageRoute(builder: (_) => const AddressPage());

      case AppRoutes.notifications:
        return CupertinoPageRoute(builder: (_) => const NotificationPage());

      case AppRoutes.settingsNotifications:
        return CupertinoPageRoute(
          builder: (_) => const NotificationSettingsPage(),
        );

      case AppRoutes.settings:
        return CupertinoPageRoute(builder: (_) => const SettingsPage());

      case AppRoutes.settingsLanguage:
        return CupertinoPageRoute(builder: (_) => const LanguageSettingsPage());

      case AppRoutes.changePassword:
        return CupertinoPageRoute(builder: (_) => const ChangePasswordPage());

      case AppRoutes.changePhoneNumber:
        return CupertinoPageRoute(
          builder: (_) => const ChangePhoneNumberPage(),
        );

      // case AppRoutes.review:
      //   return CupertinoPageRoute(builder: (_) => const ReviewPage());
      //
      // case AppRoutes.submitReview:
      //   return CupertinoPageRoute(builder: (_) => const SubmitReviewPage());

      case AppRoutes.drawerPage:
        return CupertinoPageRoute(builder: (_) => const DrawerPage());

      case AppRoutes.aboutUs:
        return CupertinoPageRoute(builder: (_) => const AboutUsPage());

        case AppRoutes.accessibility:
        return CupertinoPageRoute(builder: (_) => const AccessibilityPageScreen());

        case AppRoutes.menuAccessibility:
        return CupertinoPageRoute(builder: (_) => const MenuAccessibilityPageScreen());

      case AppRoutes.termsAndConditions:
        return CupertinoPageRoute(
          builder: (_) => const TermsAndConditionsPage(),
        );

      case AppRoutes.faq:
        return CupertinoPageRoute(builder: (_) => const FAQPage());

      case AppRoutes.help:
        return CupertinoPageRoute(builder: (_) => const HelpPage());

      case AppRoutes.contactUs:
        return CupertinoPageRoute(builder: (_) => const ContactUsPage());

      case AppRoutes.paymentMethod:
        return CupertinoPageRoute(builder: (_) => const PaymentMethodPage());

      case AppRoutes.paymentCardAdd:
        return CupertinoPageRoute(builder: (_) => const AddNewCardPage());

      case AppRoutes.labourGridPage:
        return CupertinoPageRoute(builder: (_) => const LabourGridPage());

      // case AppRoutes.newlabour:
      //   return CupertinoPageRoute(
      //     builder: (_) => LabourMasterScreen(id: params as int),
      //   );

      case AppRoutes.prGridPage:
        return CupertinoPageRoute(builder: (_) => const PrGridPage());

      case AppRoutes.newPR:
        return CupertinoPageRoute(builder: (_) => const PrMasterPage());

      case AppRoutes.OnlyselfAttendance:
        return CupertinoPageRoute(builder: (_) =>  AttendanceOnly());

      case AppRoutes.LaborAttendanceAdd:
        return CupertinoPageRoute(builder: (_) => const LabourAttendancePage());

      case AppRoutes.salarySlip:
        return CupertinoPageRoute(builder: (_) => SalarySlipPage());

      case AppRoutes.assignItems:
        return CupertinoPageRoute(builder: (_) => const AssignedItemsPage());

      case AppRoutes.erpDprEntry:
        return CupertinoPageRoute(builder: (_) => const ErpDprEntry());
      default:
        return errorRoute();
    }
  }

  static Route? errorRoute() =>
      CupertinoPageRoute(builder: (_) => const UnknownPage());
}
