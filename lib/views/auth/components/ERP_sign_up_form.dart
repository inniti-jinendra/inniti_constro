import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth/authentication_api_service.dart';
import '../../../core/utils/validators.dart';
// import 'already_have_accout.dart';
import 'ERP_sign_up_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _verifyMobileOrEmail() async {
    final email = _emailController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    if (email.isEmpty && phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter mobile or email')));
      return;
    }

    // Show Progress Indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final user =
          await AuthenticationApiService.verifyMobileOrEmail(phoneNumber);

      if (user != null && user.authorizedUser) {
        Navigator.pushNamed(context, AppRoutes.numberVerification,
            arguments: user);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    } catch (e) {
      // Dismiss Progress Indicator
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
            // const Text("Enter Email"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              validator: Validators.requiredWithFieldName('Email').call,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Enter Email"),
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text(
              "OR",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: AppDefaults.padding),
            // const Text("Enter Phone Number"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneNumberController,
              textInputAction: TextInputAction.next,
              validator: Validators.required.call,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration:
                  const InputDecoration(labelText: "Enter Phone Number"),
            ),
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
            SignUpButton(onPressed: _verifyMobileOrEmail),
            // const AlreadyHaveAnAccount(),
            // const SizedBox(height: AppDefaults.padding),
          ],
        ),
      ),
    );
  }
}
