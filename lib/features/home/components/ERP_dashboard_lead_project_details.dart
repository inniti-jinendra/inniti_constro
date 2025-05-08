import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../core/models/dropdownhendler/projectItem_ddl.dart';
import '../../../core/models/dropdownhendler/project_ddl.dart';
import '../../../core/network/logger.dart';
import '../../../core/services/DropDownHandler/drop_down_hendler_api.dart';
import '../../../core/utils/secure_storage_util.dart';

class ErpDashboardLeadProject extends StatefulWidget {
  //final String initialProject; // Initial project name to display
  final double progressPercent; // Progress value
  final Function(String? name, int? id)? onChanged; // Selection callback

  const ErpDashboardLeadProject({
    super.key,
   // required this.initialProject,
    required this.progressPercent,
    this.onChanged,
  });

  @override
  State<ErpDashboardLeadProject> createState() => _ErpDashboardLeadProjectState();
}

class _ErpDashboardLeadProjectState extends State<ErpDashboardLeadProject> {
  late String selectedProject;
  List<Project> _project = [];
  int? _selectedId;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
   // selectedProject = widget.initialProject;
    selectedProject = '';
    //_fetchDropdownItems();

    _fetchDropdownItems(); // Fetch project dropdown items

  }

  // Fetch stored project details from secure storage
  Future<void> _fetchStoredProject() async {
    String? storedProjectName = await SecureStorageUtil.readSecureData("ActiveProjectName");
    String? storedProjectId = await SecureStorageUtil.readSecureData("ActiveProjectID");

    if (storedProjectName != null && storedProjectId != null) {
      setState(() {
        selectedProject = storedProjectName;
        _selectedId = int.tryParse(storedProjectId);
      });
    }
  }

  Future<void> _fetchDropdownItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      AppLogger.info("📡 Fetching dropdown items...");
      final items = await DropDownHendlerApi().fetchProject();

      if (mounted) {
        _project = items;

        if (_project.isEmpty) {
          setState(() {
            _errorMessage = "No items available.";
            _isLoading = false;
          });
          return;
        }

        // ✅ Try to restore selected project from storage
        final storedName = await SecureStorageUtil.readSecureData("ActiveProjectName");
        final storedIdStr = await SecureStorageUtil.readSecureData("ActiveProjectID");
        final storedId = storedIdStr != null ? int.tryParse(storedIdStr) : null;

        final restored = _project.firstWhere(
              (proj) => proj.plantId == storedId,
          orElse: () => _project.first,
        );

        setState(() {
          selectedProject = restored.plantName;
          _selectedId = restored.plantId;
          _isLoading = false;
        });

        AppLogger.debug("✅ Restored selection: $selectedProject (ID: $_selectedId)");

        // Optional: notify parent
        widget.onChanged?.call(selectedProject, _selectedId);
      }
    } catch (e) {
      AppLogger.error("❌ Error fetching dropdown data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load items. Please try again.";
        });
      }
    }
  }



  void _showProjectDialog() {
    if (_project.isEmpty) {
      AppLogger.warn("⚠️ No project items available to show in dropdown.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No projects available.")),
      );
      return;
    }

    DropDownState<String>(
      dropDown: DropDown<String>(
        data: _project
            .map((project) => SelectedListItem<String>(data: project.plantName))
            .toList(),
        onSelected: (selectedItems) {
          if (selectedItems.isNotEmpty) {
            final selectedName = selectedItems.first.data;

            if (selectedName != selectedProject) {
              final selected = _project.firstWhere(
                    (item) => item.plantName == selectedName,
                orElse: () => _project.first,
              );

              setState(() {
                selectedProject = selected.plantName;
                _selectedId = selected.plantId;
              });

              // Trigger callback
              widget.onChanged?.call(selectedProject, _selectedId);

              AppLogger.info("✅ User selected: $selectedProject (ID: $_selectedId)");
            }
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
            // Left: Project Name & Days
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedProject,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlackFont,
                  ),
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

            // Right: Progress Circle
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
