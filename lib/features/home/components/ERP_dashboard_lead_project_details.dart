import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ErpDashboardLeadProject extends StatefulWidget {
  final String initialProject; // Initial project name
  final double progressPercent; // Progress value
  final VoidCallback? onSelectionChanged; // Callback for project selection

  const ErpDashboardLeadProject({
    super.key,
    required this.initialProject,
    required this.progressPercent,
    this.onSelectionChanged,
  });

  @override
  State<ErpDashboardLeadProject> createState() =>
      _ErpDashboardLeadProjectState();
}

class _ErpDashboardLeadProjectState extends State<ErpDashboardLeadProject> {
  late String selectedProject; // Maintain selected project
  final List<String> allProjects = [
    "PROJECT-1",
    "Head Office",
    "Ganesh Glory",
    "SKYBELL",
    "WATER LILY",
    "SWAGAT V2",
  ];

  @override
  void initState() {
    super.initState();
    selectedProject = widget.initialProject;
  }

  /// Shows the project selection dialog with dropdown
  void _showProjectDialog() {
    String tempSelection = selectedProject; // Use selectedProject as the initial value

    // Open the DropDown modal to select projects
    DropDownState<String>(
      dropDown: DropDown<String>(
        data: allProjects
            .map((project) => SelectedListItem<String>(data: project))
            .toList(),
        onSelected: (selectedItems) {
          // Extract the selected project from the items
          List<String> list = [];
          for (var item in selectedItems) {
            list.add(item.data);
          }

          if (list.isNotEmpty) {
            setState(() {
              selectedProject = list.first; // Update selected project
            });

            // Call the callback to notify parent widget about the change
            widget.onSelectionChanged?.call();
          }
        },
      ),
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showProjectDialog,
      child: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xffF3EFF9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Side Text and Icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      selectedProject,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlackFont,
                      ),
                    ),
                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.arrow_drop_down,
                    //     size: 30,
                    //     color: Colors.black54,
                    //   ),
                    //   onPressed: _showProjectDialog,
                    // ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "47 ",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryBlackFont,
                      ),
                    ),
                    Text(
                      "Days Completed",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryBlackFont,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Circular Progress Indicator
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: widget.progressPercent,
              center: Text(
                "${(widget.progressPercent * 100).toInt()}%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: AppColors.primaryBlueFont,
              backgroundColor: const Color(0xffC3AFE3),
            ),
          ],
        ),
      ),
    );
  }
}
