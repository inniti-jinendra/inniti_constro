import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/constants.dart';

import '../../../../../core/network/logger.dart';
import '../../../../../core/services/auth/authentication_api_service.dart';
import '../../../../../core/utils/secure_storage_util.dart';
import '../../../../../core/utils/validators.dart';
// import 'already_have_accout.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../widgets/CustomToast/custom_snackbar.dart';
import '../../../components/ERP_sign_up_button.dart';
import '../../already_have_accout.dart';

class SignUpFormEmail extends StatefulWidget {
  const SignUpFormEmail({
    super.key,
  });

  @override
  State<SignUpFormEmail> createState() => _SignUpFormEmailState();
}

class _SignUpFormEmailState extends State<SignUpFormEmail> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // void _verifyMobileOrEmail() async {
  //   final email = _emailController.text.trim();
  //   final phoneNumber = _phoneNumberController.text.trim();
  //   if (email.isEmpty && phoneNumber.isEmpty) {
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //     const SnackBar(content: Text('Please enter mobile or email')));
  //     CustomSnackbar.show(context, message: 'Please enter email');
  //     return;
  //   }
  //
  //   // Show Progress Indicator
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );
  //
  //   try {
  //     final user =
  //     await AuthenticationApiService.verifyMobileOrEmail(email);
  //
  //     if (user != null && user.authorizedUser) {
  //       Navigator.pushNamed(context, AppRoutes.numberVerification,
  //           arguments: user);
  //     } else {
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   const SnackBar(content: Text('User not found')),
  //       // );
  //
  //       CustomSnackbar.show(context, message: 'User not found');
  //
  //     }
  //   } catch (e) {
  //     // Dismiss Progress Indicator
  //     Navigator.of(context).pop();
  //
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text('Error: $e')),
  //     // );
  //
  //     CustomSnackbar.show(context, message: 'Error: $e');
  //
  //   }
  // }

  void _verifyEmail() async {
    final String email = _emailController.text.trim();
    final String phoneNumber = _phoneNumberController.text.trim();

    if (email.isEmpty) {
      CustomSnackbar.show(context, message: 'Please enter Email ID');
      AppLogger.warn('❌ User tried to verify without entering an Email ID.');
      return;
    }

    final String companyCode = await SharedPreferencesUtil.getString("CompanyCode");

    if (companyCode.isEmpty) {
      CustomSnackbar.show(context, message: 'Company code is missing. Please log in again.');
      AppLogger.warn('❌ Company code missing in SharedPreferences.');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      AppLogger.info('🔍 Verifying Phone Number: ${phoneNumber.isNotEmpty ? phoneNumber : "Not Provided"}');
      AppLogger.info('🔍 Verifying Email: $email');

      final user = await AuthenticationApiService.verifyMobileOrEmail(
        context: context,
        phoneNumber: phoneNumber.isEmpty ? null : phoneNumber,
        email: email.isEmpty ? null : email,
      );

      if (user != null && user.userId.isNotEmpty) {
        AppLogger.info('✅ User authenticated successfully. UserID: ${user.userId}');

        // ✅ Store session data in **SecureStorage**
        await SecureStorageUtil.writeSecureData("UserID", user.userId);
        await SecureStorageUtil.writeSecureData("Token", user.token);
        await SecureStorageUtil.writeSecureData("otp", user.generatedOtp);
        await SecureStorageUtil.writeSecureData("UserName", user.fullName);
        await SecureStorageUtil.writeSecureData("ActiveProjectID", user.activeProjectId);
        await SecureStorageUtil.writeSecureData("EmailID", user.email);
        await SecureStorageUtil.writeSecureData("MobileNo", user.mobile);

        // ✅ Store session data in **SharedPreferences**
        await SharedPreferencesUtil.setString("LoggedIn", "true");
        await SharedPreferencesUtil.setString("CompanyCode", companyCode);
        await SharedPreferencesUtil.setString("ActiveUserID", user.userId);
        await SharedPreferencesUtil.setString("ActiveEmailID", user.email);
        await SharedPreferencesUtil.setString("ActiveMobileNo", user.mobile);
        await SharedPreferencesUtil.setString("ActiveProjectID", user.activeProjectId);
        await SharedPreferencesUtil.setString("GeneratedToken", "Bearer ${user.token}");

        AppLogger.info('✅ Session Data Stored Successfully');

        Navigator.pop(context); // Dismiss dialog
        Navigator.pushNamed(context, AppRoutes.numberVerification, arguments: user);
      } else {
        AppLogger.warn('❌ User authentication failed for phone number: $phoneNumber');
        Navigator.pop(context); // Dismiss dialog
        CustomSnackbar.show(context, message: 'User not found');
      }
    } catch (e) {
      Navigator.pop(context); // Dismiss Progress Indicator
      AppLogger.error('❌ Error during phone number verification: $e');
      CustomSnackbar.show(context, message: 'Error: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Container(
        margin: const EdgeInsets.all(AppDefaults.margin),
        padding: const EdgeInsets.all(AppDefaults.padding),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppDefaults.boxShadow,
          borderRadius: AppDefaults.borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter Email"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              validator: Validators.requiredWithFieldName('Email').call,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Enter Email"),
            ),
            const SizedBox(height: AppDefaults.padding),
            // const Text(
            //   "OR",
            //   style: TextStyle(fontSize: 20, color: Colors.black),
            // ),
            // const SizedBox(height: AppDefaults.padding),
            // const Text("Enter Phone Number"),
            // const SizedBox(height: 8),
            // TextFormField(
            //   controller: _phoneNumberController,
            //   textInputAction: TextInputAction.next,
            //   validator: Validators.required.call,
            //   keyboardType: TextInputType.number,
            //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   decoration:
            //   const InputDecoration(labelText: "Enter Phone Number"),
            // ),
            // const SizedBox(height: AppDefaults.padding),
            // const Text("Password"),
            // const SizedBox(height: 8),
            // TextFormField(
            //   validator: Validators.required.call,
            //   textInputAction: TextInputAction.next,
            //   obscureText: true,
            //   decoration: InputDecoration(
            //     suffixIcon: Material(
            //       color: Colors.transparent,
            //       child: IconButton(
            //         onPressed: () {},
            //         icon: SvgPicture.asset(
            //           AppIcons.eye,
            //           width: 24,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: AppDefaults.padding),
            SignUpButton(onPressed: _verifyEmail),
           // SignUpButton(onPressed: _verifyMobileOrEmail),


            // 📌 Divider with Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "or",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 📌 "Login with Email" Button

            const AlreadyHaveAnAccountPhone(),
            const SizedBox(height: AppDefaults.padding),

            // SizedBox(
            //   width: double.infinity,
            //   child: OutlinedButton(
            //     onPressed: () {
            //       print("Login with Email clicked");
            //     },
            //     style: OutlinedButton.styleFrom(
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       side: BorderSide(
            //         color: Colors.grey.shade400,
            //       ),
            //     ),
            //     child: const Text(
            //       "Login with email",
            //       style: TextStyle(
            //         fontSize: 18,
            //         color: Colors.grey,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
