import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// import '../../../core/components/network_image.dart';
import '../../../core/constants/constants.dart';

class ErpDashboardLeadProjectDetails extends StatelessWidget {
  const ErpDashboardLeadProjectDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(AppDefaults.padding),
              decoration: BoxDecoration(
                color: AppColors.cardColor_2,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: AppDefaults.boxShadow,
              ),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ganesh Gloary',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                        Text('47 Days completed',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    CircularPercentIndicator(
                      radius: 35.0,
                      lineWidth: 6.0,
                      animation: true,
                      percent: 0.7,
                      center: const Text(
                        "70.0%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.0),
                      ),
                      animationDuration: 1000,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.purple,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // GridView.count(
            //   crossAxisCount: 2,
            //   crossAxisSpacing: 10,
            //   mainAxisSpacing: 10,
            //   shrinkWrap: true, // ✅ Ensures it does not take infinite space
            //   physics:
            //       const NeverScrollableScrollPhysics(), // ✅ Disables inner scrolling
            //   children: [
            //     buildCard('7h 30m', 'Centering Work', Icons.currency_rupee),
            //     buildCard('3h', 'PAint Work', Icons.currency_rupee),
            //     buildCard('1h 23m', 'Receivables', Icons.timer),
            //     buildCard('15 pcs.', 'Payables', Icons.medical_services),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String time, String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: AppColors.coloredBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon),
              // CircularPercentIndicator(
              //   radius: 30.0,
              //   lineWidth: 4.0,
              //   animation: true,
              //   percent: 0.7,
              //   center: const Text(
              //     "70.0%",
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
              //   ),
              //   circularStrokeCap: CircularStrokeCap.round,
              //   progressColor: Colors.purple,
              // ),
              Text(time,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }
}
