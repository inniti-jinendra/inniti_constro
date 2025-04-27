// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_defaults.dart';

class ErpProjectProgressPieChart extends StatefulWidget {
  const ErpProjectProgressPieChart({super.key});

  @override
  State<ErpProjectProgressPieChart> createState() =>
      _ErpProjectProgressChartState();
}

class _ErpProjectProgressChartState extends State<ErpProjectProgressPieChart> {
  int? touchedIndex; // Store the tapped section index

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final chartSize = screenWidth * 0.6; // Adjust size based on screen width

    return Column(
      children: [
        SizedBox(height: 16.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FaIcon(
                FontAwesomeIcons.chartPie, // Best icon for a pie chart
                color: AppColors.primary, // Customize color
                size: 15, // Adjust size as needed
              ),
              const SizedBox(width: AppDefaults.padding_2),
              Text(
                "Project Progress",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(AppDefaults.margin),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: AppDefaults.boxShadow,
              border: Border.all(color: AppColors.gray)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              const Text(
                "Project Progress",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: Center(
                  child: SizedBox(
                    width: chartSize.clamp(180, 300),
                    height: chartSize.clamp(180, 300),
                    // child: PieChart(
                    //   PieChartData(
                    //     sections: _getSections(), // Call updated function
                    //     borderData: FlBorderData(show: false),
                    //     centerSpaceRadius: chartSize * 0.2,
                    //     sectionsSpace: 2,
                    //     startDegreeOffset: 270,
                    //     pieTouchData: PieTouchData(
                    //       touchCallback:
                    //           (FlTouchEvent event, pieTouchResponse) {
                    //         if (event is FlTapUpEvent &&
                    //             pieTouchResponse != null) {
                    //           setState(() {
                    //             touchedIndex = pieTouchResponse
                    //                 .touchedSection?.touchedSectionIndex;
                    //           });
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildLegend(screenWidth),
              const SizedBox(height: 15),
            ],
          ),
        )
      ],
    );
  }

  // List<PieChartSectionData> _getSections() {
  //   return List.generate(4, (index) {
  //     final isTouched = index == touchedIndex;
  //     final double radius = isTouched ? 70 : 50; // Expand on click
  //
  //     final List<Map<String, dynamic>> data = [
  //       {
  //         'color': const Color(0xFF5E3EA1),
  //         'value': 35,
  //         'title': '35%\nCompleted'
  //       },
  //       {
  //         'color': const Color(0xFF9B59B6),
  //         'value': 30,
  //         'title': '30%\nIn Progress'
  //       },
  //       {
  //         'color': const Color(0xFFD7BDE2),
  //         'value': 20,
  //         'title': '20%\nIn Planning'
  //       },
  //       {
  //         'color': const Color(0xFFB2A1C8),
  //         'value': 15,
  //         'title': '15%\nNot Started'
  //       },
  //     ];
  //
  //     return PieChartSectionData(
  //       color: data[index]['color'],
  //       value: data[index]['value'].toDouble(),
  //       title: data[index]['title'],
  //       radius: radius, // Adjust radius dynamically
  //       titleStyle: const TextStyle(
  //         fontSize: 8,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.white,
  //       ),
  //     );
  //   });
  // }

  Widget _buildLegend(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          _legendItem(const Color(0xFF5E3EA1), "Completed"),
          _legendItem(const Color(0xFF9B59B6), "In Progress"),
          _legendItem(const Color(0xFFD7BDE2), "In Planning"),
          _legendItem(const Color(0xFFB2A1C8), "Not Started"),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
