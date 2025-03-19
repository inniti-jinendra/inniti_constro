import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/constants.dart';

class AppbarHeader extends StatelessWidget {
  final String headerName;
  final String projectName;
  const AppbarHeader({
    super.key,
    required this.headerName,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          headerName,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Visibility(
          visible: projectName != '',
          child: Text(
            projectName,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.placeholder,
                fontSize: AppDefaults.projectNameSize),
          ),
        )
      ],
    );
  }
}
