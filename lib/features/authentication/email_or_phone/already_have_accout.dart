import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';



class AlreadyHaveAnAccountEmail extends StatelessWidget {
  const AlreadyHaveAnAccountEmail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('I Have Account Email ID ?'),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.SignUpPageEmail),
          child: const Text('Log In'),
        ),
      ],
    );
  }
}

class AlreadyHaveAnAccountPhone extends StatelessWidget {
  const AlreadyHaveAnAccountPhone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('I Have Account Phone Number ?'),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.SignUpPagePhone),
          child: const Text('Log In'),
        ),
      ],
    );
  }
}
