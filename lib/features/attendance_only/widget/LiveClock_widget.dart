import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveClock extends StatelessWidget {
  const LiveClock({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
            (_) => DateTime.now(),
      ),
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final formattedTime = DateFormat('hh:mm:ss a').format(now); // <-- full time

        return Text(
          formattedTime,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        );
      },
    );
  }
}
