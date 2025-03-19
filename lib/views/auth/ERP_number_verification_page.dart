import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/components/network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/app_images.dart';
import '../../core/themes/app_themes.dart';
import 'dialogs/verified_dialogs_ERP.dart';

class NumberVerificationPage extends StatefulWidget {
  final dynamic users; // Contains OTP and other details

  const NumberVerificationPage({super.key, required this.users});

  @override
  State<NumberVerificationPage> createState() => _NumberVerificationPageState();
}

class _NumberVerificationPageState extends State<NumberVerificationPage> {
  final OTPTextFields _otpTextFields = OTPTextFields();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  margin: const EdgeInsets.all(AppDefaults.margin),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: AppDefaults.borderRadius,
                  ),
                  child: Column(
                    children: [
                      const NumberVerificationHeader(),
                      _otpTextFields, // Use the same instance
                      const SizedBox(height: AppDefaults.padding * 3),
                      const ResendButton(),
                      const SizedBox(height: AppDefaults.padding),
                      VerifyButton(
                        users: widget.users, // Pass OTP
                        otpTextFields: _otpTextFields,
                      ),
                      const SizedBox(height: AppDefaults.padding),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyButton extends StatelessWidget {
  final dynamic users; // Correct OTP from users
  final OTPTextFields otpTextFields; // Instance of OTP fields

  VerifyButton({
    super.key,
    required this.users,
    required this.otpTextFields,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          String enteredOtp = otpTextFields.getEnteredOTP(); // Get entered OTP

          if (enteredOtp == users.otp) {
            // If OTP matches, show popup
            showGeneralDialog(
              barrierLabel: 'Dialog',
              barrierDismissible: true,
              context: context,
              pageBuilder: (ctx, anim1, anim2) => VerifiedDialog(users: users),
              transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
                scale: anim1,
                child: child,
              ),
            );
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid OTP. Please try again!'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const Text('Verify'),
      ),
    );
  }
}

class ResendButton extends StatelessWidget {
  const ResendButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Did you don\'t get code?'),
        TextButton(
          onPressed: () {},
          child: const Text('Resend'),
        ),
      ],
    );
  }
}

class NumberVerificationHeader extends StatelessWidget {
  const NumberVerificationHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppDefaults.padding),
        Text(
          'Entry Your 5 digit code',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppDefaults.padding),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: const AspectRatio(
            aspectRatio: 1 / 1,
            child: NetworkImageWithLoader(
              AppImages.numberVerfication,
            ),
          ),
        ),
        const SizedBox(height: AppDefaults.padding * 3),
      ],
    );
  }
}

class OTPTextFields extends StatefulWidget {
  OTPTextFields({
    super.key,
  });

  final TextEditingController _textbox1Controller = TextEditingController();
  final TextEditingController _textbox2Controller = TextEditingController();
  final TextEditingController _textbox3Controller = TextEditingController();
  final TextEditingController _textbox4Controller = TextEditingController();
  final TextEditingController _textbox5Controller = TextEditingController();

  String getEnteredOTP() {
    return _textbox1Controller.text.toString() +
        _textbox2Controller.text.toString() +
        _textbox3Controller.text.toString() +
        _textbox4Controller.text.toString() +
        _textbox5Controller.text.toString();
  }

  @override
  State<OTPTextFields> createState() => _OTPTextFieldsState();
}

class _OTPTextFieldsState extends State<OTPTextFields> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.defaultTheme.copyWith(
        inputDecorationTheme: AppTheme.otpInputDecorationTheme,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 50,
            height: 70,
            child: TextFormField(
              controller: widget._textbox1Controller,
              onChanged: (v) {
                if (v.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 50,
            height: 70,
            child: TextFormField(
              controller: widget._textbox2Controller,
              onChanged: (v) {
                if (v.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 50,
            height: 70,
            child: TextFormField(
              controller: widget._textbox3Controller,
              onChanged: (v) {
                if (v.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 50,
            height: 70,
            child: TextFormField(
              controller: widget._textbox4Controller,
              onChanged: (v) {
                if (v.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 50,
            height: 70,
            child: TextFormField(
              controller: widget._textbox5Controller,
              onChanged: (v) {
                if (v.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
