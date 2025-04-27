// import 'package:flutter/material.dart';
//
// import '../OtpVerification/otp_screen.dart';
//
//
// class WelcomeEmailPhone extends StatefulWidget {
//   @override
//   _WelcomeEmailPhoneState createState() => _WelcomeEmailPhoneState();
// }
//
// class _WelcomeEmailPhoneState extends State<WelcomeEmailPhone> {
//   final TextEditingController _emailPhoneController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Enter Email or Phone')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailPhoneController,
//               decoration: InputDecoration(labelText: 'Email or Phone'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 if (_emailPhoneController.text.isNotEmpty) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => OtpVerification()),
//                   );
//                 }
//               },
//               child: Text('Next'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_defaults.dart';
import 'widgets/ERP_sign_up_form_phone.dart';
import '../../components/ERP_sign_up_page_header.dart';



class SignUpPagePhone extends StatelessWidget {
  const SignUpPagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SignUpPageHeader(),
                SizedBox(height: AppDefaults.padding),
                SignUpFormPhone(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
