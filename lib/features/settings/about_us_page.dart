import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/components/app_back_button.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/font_styles.dart';
import '../../routes/app_routes.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
           // Navigator.pushReplacementNamed(context, AppRoutes.settings);

          Navigator.pop(context, true);
          },
          icon: SvgPicture.asset(
            "assets/icons/setting/LeftArrow.svg",
          ),
          color: AppColors.primaryBlue,
        ),
        title: Text(
          'About Us',
          style: FontStyles.bold700.copyWith(
            color: AppColors.primaryBlackFont,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.primaryWhitebg,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20,),
            SvgPicture.asset(
              "assets/icons/Inniti_Logo.svg",
              height: 90,
              width: 160,
            ),
            SizedBox(height: 10,),
            Text("Inniti Constro",
              style: FontStyles.bold700.copyWith(
                color: AppColors.primaryBlackFont,
                fontSize: 36,
              ),
            ),
            SizedBox(height: 5,),
            Text("Version: 2.1.1",
              style: FontStyles.semiBold600.copyWith(
                color: AppColors.primaryBlackFontWithOpps40,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20,),

        Container(
          width: double.infinity,
          //margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Color(0x405B21B1), // 40 is hex for 25% opacity
                offset: Offset(0, 0),     // Matches 0px 0px
                blurRadius: 14,
                spreadRadius: -6,         // Negative spread like CSS
              ),
            ],
          ),
          child:Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
            child: Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: ()=>launchUrlSite(url: 'https://innitisoftware.com'),
                    child: Row(
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryWhitebg, // Optional: Set a background color if needed
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              "assets/icons/setting/global-search.svg",
                              // height: 24,
                              // width: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(
                          "https://innitisoftware.com",
                          style: FontStyles.semiBold600.copyWith(
                            color: AppColors.primaryBlackFont,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  // Number
                  Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhitebg, // Optional: Set a background color if needed
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            "assets/icons/setting/call-calling.svg",
                            // height: 24,
                            // width: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "+91 72278 06663",
                        style: FontStyles.semiBold600.copyWith(
                          color: AppColors.primaryBlackFont,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  // Email
                  GestureDetector(
                    onTap: () => launchEmailwithsubject(),
                    child: Row(
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryWhitebg, // Optional: Set a background color if needed
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              "assets/icons/setting/sms-notification.svg",
                              // height: 24,
                              // width: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(
                          "info@innitisoftware.com",
                          style: FontStyles.semiBold600.copyWith(
                            color: AppColors.primaryBlackFont,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
            Spacer(),

            Text("©2025 INNITI SOFTWARE. ALL RIGHTS RESEVED.",
              style: FontStyles.semiBold600.copyWith(
                color: AppColors.primaryBlackFontWithOpps40,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }


  Future<void> launchEmailwithsubject() async {
    final String email = Uri.encodeComponent("info@innitisoftware.com");
    final String subject = Uri.encodeComponent("Mail from Constro Mobile App");
    final String body = Uri.encodeComponent("Hello Inniti Software Team,\n\n");
    final Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");

    try {
      final bool launched = await launchUrl(mail);
      if (launched) {
        // email app opened
      } else {
        // email app is not opened
        throw Exception('Could not launch email app');
      }
    } on PlatformException catch (e) {
      throw Exception('Error launching email: $e');
    }
  }

  Future<void> launchUrlSite({required String url}) async {
    final Uri urlParsed = Uri.parse(url);

    if (await canLaunchUrl(urlParsed)) {
      await launchUrl(urlParsed);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchUrlSiteBrowser({required String url}) async {
    final Uri urlParsed = Uri.parse(url);

    if (await canLaunchUrl(urlParsed)) {
      await launchUrl(urlParsed, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

}


