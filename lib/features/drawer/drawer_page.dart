import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inniti_constro/features/drawer/terms_and_conditions_page.dart';

import '../../core/components/app_back_button.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/app_icons.dart';
import '../../core/components/app_settings_tile.dart';
import '../../routes/app_routes.dart';
import '../authentication/company_code/company_code_screen.dart';
import 'about_us_page.dart';
import 'contact_us_page.dart';
import 'faq_page.dart';
import 'help_page.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Column(
          children: [
            _buildListTile(context, 'Invite Friend', AppRoutes.drawerPage),
            _buildListTile(context, 'About Us', AppRoutes.aboutUs),
            _buildListTile(context, 'FAQs', AppRoutes.faq),
            _buildListTile(context, 'Terms & Conditions', AppRoutes.termsAndConditions),
            _buildListTile(context, 'Help Center', AppRoutes.help),
            _buildListTile(context, 'Rate This App', null),
            _buildListTile(context, 'Privacy Policy', null),
            _buildListTile(context, 'Contact Us', AppRoutes.contactUs),
            const SizedBox(height: AppDefaults.padding * 3),
            _buildListTile(context, 'Logout', AppRoutes.loginOrSignup),
          ],
        ),
      ),
    );
  }

  // Helper function to create a ListTile with animation for navigation
  Widget _buildListTile(BuildContext context, String label, String? route) {
    return AppSettingsListTile(
      label: label,
      trailing: SvgPicture.asset(AppIcons.right),
      onTap: () {
        if (route != null) {
          // Add smooth page transition animation
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => _getRoutePage(route),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        }
      },
    );
  }

  // Returns the page widget based on the route name
  Widget _getRoutePage(String route) {
    switch (route) {
      case AppRoutes.aboutUs:
        return AboutUsPage();
      case AppRoutes.faq:
        return FAQPage();
      case AppRoutes.termsAndConditions:
        return TermsAndConditionsPage();
      case AppRoutes.help:
        return HelpPage();
      case AppRoutes.contactUs:
        return ContactUsPage();
      case AppRoutes.contactUs:
        return IntroLoginPage();
      default:
        return const SizedBox.shrink(); // Default fallback page
    }
  }
}
