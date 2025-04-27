import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';

import '../../../../core/network/logger.dart';
import '../../../../core/services/auth/authentication_api_service.dart';
import 'package:inniti_constro/core/utils/shared_preferences_util.dart' as shared_prefs;
import 'package:inniti_constro/core/utils/secure_storage_util.dart' as secure_storage;
import '../../../../core/utils/validators.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/CustomToast/custom_snackbar.dart';
import 'ERP_verify_company_code_button.dart';


class VerifyCompanycodeForm extends StatefulWidget {
  const VerifyCompanycodeForm({
    super.key,
  });

  @override
  State<VerifyCompanycodeForm> createState() => _VerifyCompanycodeForm();
}

class _VerifyCompanycodeForm extends State<VerifyCompanycodeForm> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _companyCodeController = TextEditingController();

  // onLogin() async {
  //   debugPrint('onLogin called');
  //
  //   final bool isFormOkay = _key.currentState?.validate() ?? false;
  //   debugPrint('Form validation result: $isFormOkay');
  //
  //   if (isFormOkay) {
  //     String companyCode = _companyCodeController.text;
  //     debugPrint('Company Code entered: $companyCode');
  //
  //     try {
  //       debugPrint('Attempting to verify company code');
  //
  //       final isValid =
  //           await AuthenticationApiService.verifyCompanyCode(companyCode);
  //       debugPrint('API Response - Company Code Valid: $isValid');
  //
  //       if (!mounted) {
  //         return; // Check if the widget is still mounted, mounted is a property of State that ensures the widget is still part of the widget tree
  //       }
  //
  //       if (isValid) {
  //         debugPrint('Company code valid, saving to SharedPreferences');
  //         await SharedPreferencesUtil.setSharedPreferenceData(
  //             "CompanyCode", companyCode);
  //
  //         debugPrint('Navigating to Sign Up screen');
  //         Navigator.pushNamed(context, AppRoutes.SignUpPagePhone);
  //       } else {
  //         debugPrint('Invalid company code');
  //         // ScaffoldMessenger.of(context).showSnackBar(
  //         //   const SnackBar(content: Text('Invalid company code')),
  //         // );
  //         CustomSnackbar.show(context, message: 'Invalid company code');
  //
  //       }
  //     } catch (e) {
  //       debugPrint('Error verifying company code: $e');
  //
  //       if (!mounted) return;
  //
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content: Text('Error verifying company code: $e')),
  //       // );
  //
  //       CustomSnackbar.show(context, message: 'Error verifying company code: $e');
  //     }
  //   } else {
  // debugPrint('Form is not valid'); // Log when form validation fails
  // }
  // }

  void onLogin() async {
    AppLogger.info('🔹 onLogin() called');

    final bool isFormOkay = _key.currentState?.validate() ?? false;
    AppLogger.debug('Form validation result: $isFormOkay');

    if (isFormOkay) {
      String companyCode = _companyCodeController.text.trim();
      AppLogger.debug('Company Code entered: $companyCode');

      try {
        AppLogger.info('🔍 Verifying company code: $companyCode');

        // ✅ Null-safe API response handling
        final bool isValid = await AuthenticationApiService.verifyCompanyCode(context, companyCode) ?? false;
        AppLogger.debug('API Response - Company Code Valid: $isValid');

        if (!mounted) return;

        if (isValid) {
          AppLogger.info('✅ Company code valid, storing securely');

          // ✅ Store Company Code in SharedPreferences & SecureStorage
          await shared_prefs.SharedPreferencesUtil.setString("CompanyCode", companyCode);
          await secure_storage.SecureStorageUtil.writeSecureData("CompanyCode", companyCode);

          AppLogger.info('🔄 Navigating to SignUpPagePhone');
          Navigator.pushNamed(context, AppRoutes.SignUpPagePhone);
        } else {
          AppLogger.warn('❌ Invalid company code');
          CustomSnackbar.show(context, message: 'Invalid company code');
        }
      } catch (e) {
        AppLogger.error('❌ Error verifying company code: $e');

        if (!mounted) return;

        CustomSnackbar.show(context, message: 'Error verifying company code: $e');
      }
    } else {
      AppLogger.warn('⚠️ Form validation failed');
    }
  }




  @override
  void dispose() {
    _companyCodeController.dispose(); // Dispose controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.margin),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text("Enter Company Code"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyCodeController,
              validator: Validators.requiredWithFieldName('Company Code').call,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(labelText: "Enter Company Code"),
            ),
            const SizedBox(height: AppDefaults.padding),
            // Verify Company Code labelLarge
            VerifyCompanyCodeButton(onPressed: onLogin),
          ],
        ),
      ),
    );
  }
}
