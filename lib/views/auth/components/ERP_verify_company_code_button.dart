import 'package:flutter/material.dart';

class VerifyCompanyCodeButton extends StatelessWidget {
  const VerifyCompanyCodeButton({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Continue with Email or Phone'),
      ),
    );
  }
}
