import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/app_defaults.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../routes/app_routes.dart';


class AddNewCardRow extends StatelessWidget {
  const AddNewCardRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: Row(
        children: [
          Text(
            'My Card',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              //Navigator.pushNamed(context, AppRoutes.paymentCardAdd);
            },
            icon: SvgPicture.asset(AppIcons.cardAdd),
          )
        ],
      ),
    );
  }
}
