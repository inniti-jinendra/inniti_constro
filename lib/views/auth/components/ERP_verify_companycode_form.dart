import 'package:flutter/material.dart';
import 'package:inniti_constro/core/services/auth/authentication_api_service.dart';
import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/shared_preferences_util.dart';
import '../../../core/utils/validators.dart';
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

  onLogin() async {
    final bool isFormOkay = _key.currentState?.validate() ?? false;
    if (isFormOkay) {
      String companyCode = _companyCodeController.text;
      try {
        final isValid =
            await AuthenticationApiService.verifyCompanyCode(companyCode);
        if (!mounted) {
          return; // Check if the widget is still mounted, mounted is a property of State that ensures the widget is still part of the widget tree
        }

        if (isValid) {
          await SharedPreferencesUtil.setSharedPreferenceData(
              "CompanyCode", companyCode);
          Navigator.pushNamed(context, AppRoutes.signup);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid company code')),
          );
        }
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error verifying company code: $e')),
        );
      }
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
