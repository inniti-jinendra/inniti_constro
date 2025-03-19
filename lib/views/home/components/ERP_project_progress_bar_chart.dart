import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inniti_constro/core/constants/constants.dart';

import '../../../core/constants/app_defaults.dart';

class ErpProjectProgressBarChart extends StatefulWidget {
  const ErpProjectProgressBarChart({super.key});

  @override
  State<ErpProjectProgressBarChart> createState() =>
      _ErpProjectProgressBarChartState();
}

class _ErpProjectProgressBarChartState
    extends State<ErpProjectProgressBarChart> {
  int? touchedIndex;

  // Static Project Data
  final List<Map<String, dynamic>> projectItems = [
    {"name": "Centering Work", "amount": 150000.0},
    {"name": "Concrete Work", "amount": 325687.0},
    {"name": "Masonry", "amount": 90890.0},
    {"name": "Paint Work", "amount": 87998.0},
    {"name": "Bricks Work", "amount": 23000.0},
    {"name": "Plaster Work", "amount": 50700.0},
    {"name": "Wood Work", "amount": 100000.0},
    {"name": "Steel Work", "amount": 200000.0},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Find the max value for proper scaling
    double maxAmount = projectItems
        .map((e) => e['amount'] as double)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FaIcon(
                FontAwesomeIcons.chartBar, // Best icon for a pie chart
                color: AppColors.primary, // Customize color
                size: 15, // Adjust size as needed
              ),
              const SizedBox(width: AppDefaults.padding_2),
              Text(
                "Project Item Status",
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
              // const Text(
              //   "Project Item Status",
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: screenWidth * 1.5, // Allows scrolling for many items
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxAmount *
                            1.1, // 10% extra space for better visibility
                        barGroups: _getBarGroups(maxAmount),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: maxAmount / 5, // Dynamic spacing
                              reservedSize: 40,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 5), // Adjust padding if needed
                                  child: Text(
                                    '${(value / 1000).toStringAsFixed(0)}K', // Converts to "90K, 30K"
                                    style: const TextStyle(
                                      fontSize:
                                          10, // Adjust font size (default 12)
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .black87, // Change color if needed
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true, // Enable right-side labels
                              interval:
                                  maxAmount / 5, // Adjust based on your data
                              reservedSize: 50, // Increase for more space
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5), // Adjust padding
                                  child: Text(
                                    '${(value / 1000).toStringAsFixed(0)}K',
                                    style: const TextStyle(
                                      fontSize: 10, // Adjust font size
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: _getBottomTitles,
                              reservedSize: 60, // More space for labels
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: true),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        )
      ],
    );
  }

  List<BarChartGroupData> _getBarGroups(double maxAmount) {
    return projectItems.asMap().entries.map((entry) {
      int index = entry.key;
      var item = entry.value;
      double amount = item['amount'] as double;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
            color: AppColors.primary,
            width: 20, // Thicker bars for visibility
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index >= 0 && index < projectItems.length) {
      String name = projectItems[index]['name'];

      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            const Icon(Icons.bar_chart,
                size: 16, color: AppColors.primary), // Small Icon
            Text(
              name.length > 8
                  ? "${name.substring(0, 8)}…"
                  : name, // Shortened name
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
