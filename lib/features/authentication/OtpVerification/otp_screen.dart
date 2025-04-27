// import 'package:flutter/material.dart';
//
// class OtpVerification extends StatefulWidget {
//   @override
//   _OtpVerificationState createState() => _OtpVerificationState();
// }
//
// class _OtpVerificationState extends State<OtpVerification> {
//   final TextEditingController _otpController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Enter OTP')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _otpController,
//               decoration: InputDecoration(labelText: 'Enter 5-digit OTP'),
//               keyboardType: TextInputType.number,
//               maxLength: 5,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 if (_otpController.text.length == 5) {
//                   // OTP Verification Logic Here
//                   Navigator.pushReplacementNamed(context, '/home');
//                 }
//               },
//               child: Text('Verify OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/components/network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/network/logger.dart';
import '../../../core/utils/secure_storage_util.dart';
import '../../../theme/themes/app_themes.dart';
import '../../../widgets/CustomToast/custom_snackbar.dart';
import 'dialogs/verified_dialogs_ERP.dart';



class NumberVerificationPage extends StatefulWidget {
  final dynamic users; // Contains OTP and other details

  const NumberVerificationPage({super.key, required this.users});

  @override
  State<NumberVerificationPage> createState() => _NumberVerificationPageState();
}

class _NumberVerificationPageState extends State<NumberVerificationPage> {
  final OTPTextFields _otpTextFields = OTPTextFields();
  String? storedToken;

  @override
  void initState() {
    super.initState();
    _retrieveStoredData();
  }

  /// ✅ Retrieve Token from Secure Storage on init
  Future<void> _retrieveStoredData() async {
    try {
      storedToken = await SecureStorageUtil.readSecureData("Token");
      String? storedUserId = await SecureStorageUtil.readSecureData("UserID");

      AppLogger.info("🔹 Stored Token Retrieved: $storedToken");
      AppLogger.info("🆔 Stored User ID Retrieved: $storedUserId");
    } catch (e) {
      AppLogger.error("❌ Error Retrieving Stored Data: $e");
    }
  }

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
          onPressed: () async {
            AppLogger.info("✅ OTP Matched! Tap event triggered.");

            // 🔹 Get entered OTP
            String enteredOtp = otpTextFields.getEnteredOTP().trim();

            // 🔹 Retrieve stored data
            String? storedToken = await SecureStorageUtil.readSecureData("Token");
            String? generatedOtp = await SecureStorageUtil.readSecureData("otp");

            // 🔹 Log values for debugging
            AppLogger.info("🔹 VerifyButton Pressed!");
            AppLogger.info("📨 Entered OTP: $enteredOtp");
            AppLogger.info("🆔 Expected OTP from API: ${users.generatedOtp}");
            AppLogger.info("🔑 Stored Token: $storedToken");

            // ✅ Ensure both values are non-null & properly compared
            if (enteredOtp.isNotEmpty && users.generatedOtp.isNotEmpty) {
              if (enteredOtp == users.generatedOtp) {
                AppLogger.info("✅ OTP Matched! Opening VerifiedDialog.");

                // ✅ Store session details
                await SecureStorageUtil.writeSecureData("VerifiedUser", users.userId);
                await SecureStorageUtil.writeSecureData("VerifiedToken", users.token);

                AppLogger.info("🔹 Session Verified & Stored Successfully");

                // ✅ Show verification popup
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
                AppLogger.warn("❌ OTP Mismatch! Entered: $enteredOtp, Expected: ${users.generatedOtp}");

                // ✅ Ensure Snackbar is displayed correctly
                Future.microtask(() {
                  CustomSnackbar.show(context, message: ' OTP Mismatch!');
                });
              }
            } else {
              AppLogger.error("❌ OTP is empty or null! Entered: '$enteredOtp', Expected: '${users.generatedOtp}'");

              Future.microtask(() {
                CustomSnackbar.show(context, message: ' OTP field is empty!');
              });
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
    onPressed: (){},
          // onPressed: () {
          //
          //     final phoneNumber = _phoneNumberController.text.trim();
          //     final String email = _emailController.text.trim().isEmpty ? "" : _emailController.text.trim(); // ✅ Ensures blank email
          //
          //     if (phoneNumber.isEmpty) {
          //       CustomSnackbar.show(context, message: 'Please enter mobile number');
          //       AppLogger.warn('❌ User tried to verify without entering a phone number.');
          //       return;
          //     }
          //
          //     // ✅ Retrieve stored company code from SharedPreferences
          //     final String companyCode = await SharedPreferencesUtil.getString(
          //       "CompanyCode",
          //     );
          //     if (companyCode.isEmpty) {
          //       CustomSnackbar.show(
          //         context,
          //         message: 'Company code is missing. Please log in again.',
          //       );
          //       AppLogger.warn('❌ Company code missing in SharedPreferences.');
          //       return;
          //     }
          //
          //     // ✅ Show Progress Indicator
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return const Center(child: CircularProgressIndicator());
          //       },
          //     );
          //
          //     try {
          //       AppLogger.info('🔍 Verifying phone number: $phoneNumber');
          //       AppLogger.info('🔍 Verifying emial : $email');
          //
          //       // ✅ Call API with correct parameters
          //       final user = await AuthenticationApiService.verifyMobileOrEmail(
          //         context: context,
          //         phoneNumber: phoneNumber,
          //         email: email,
          //       );
          //
          //       if (user != null && user.userId.isNotEmpty) {
          //         AppLogger.info(
          //           '✅ User authenticated successfully. UserID: ${user.userId}',
          //         );
          //
          //         // ✅ Store session data in **SecureStorage**
          //         await SecureStorageUtil.writeSecureData("UserID", user.userId);
          //         await SecureStorageUtil.writeSecureData("Token", user.token);
          //         await SecureStorageUtil.writeSecureData("otp", user.generatedOtp);
          //         await SecureStorageUtil.writeSecureData("UserName", user.fullName);
          //         await SecureStorageUtil.writeSecureData("ActiveProjectID", user.activeProjectId);
          //         await SecureStorageUtil.writeSecureData("EmailID", user.email);
          //         await SecureStorageUtil.writeSecureData("MobileNo", user.mobile);
          //
          //         // ✅ Store session data in **SharedPreferences**
          //         await SharedPreferencesUtil.setString("LoggedIn", "true");
          //         await SharedPreferencesUtil.setString("CompanyCode", companyCode);
          //         await SharedPreferencesUtil.setString("ActiveUserID", user.userId);
          //         await SharedPreferencesUtil.setString("ActiveEmailID", user.email);
          //         await SharedPreferencesUtil.setString("ActiveMobileNo", user.mobile);
          //         await SharedPreferencesUtil.setString("ActiveProjectID", user.activeProjectId);
          //         await SharedPreferencesUtil.setString("GeneratedToken", "Bearer ${user.token}");
          //
          //
          //         AppLogger.info('✅ Session Data Stored Successfully');
          //         Navigator.pop(context); // Dismiss the dialog
          //         Navigator.pushNamed(
          //           context,
          //           AppRoutes.numberVerification,
          //           arguments: user,
          //         );
          //       } else {
          //         AppLogger.warn(
          //           '❌ User authentication failed for phone number: $phoneNumber',
          //         );
          //         Navigator.pop(context); // Dismiss the dialog
          //         CustomSnackbar.show(context, message: 'User not found');
          //       }
          //     } catch (e) {
          //       Navigator.pop(context); // Dismiss Progress Indicator
          //       AppLogger.error('❌ Error during phone number verification: $e');
          //       CustomSnackbar.show(context, message: 'Error: $e');
          //     }
          //
          // },

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
