import 'package:flutter/material.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:lottie/lottie.dart';


import '../core/components/app_back_button.dart';
import '../core/components/network_image.dart';
import '../core/constants/app_defaults.dart';
import 'app_routes.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBackButton(),
        title: const Text('Unknown Page'),
      ),
      body: Column(
        children: [
          const Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child:  AspectRatio(
                aspectRatio: 1 / 1,
                child:   Lottie.asset(
                  'assets/loti/loder/animation_man.json', // ✅ Replace with your animation
                 fit: BoxFit.contain,
                  // width: 500,
                  // height: 500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Column(
              children: [
                Text(
                  'oppss!! something wrong',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                  child: Text(
                    'Sorry, something went wrong\nplease try again .',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(AppDefaults.padding * 2),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.pushNamed(context, AppRoutes.entryPoint);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue, // Change to your desired color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 16), // Button height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
