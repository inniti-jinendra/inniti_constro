import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/font_styles.dart';
import '../../../../../core/network/logger.dart';
import '../../../../../core/utils/secure_storage_util.dart';
import '../FuelInwardMode.dart';



class AddFuelInwardPage extends StatefulWidget {
  final FuelInwardMode mode;

  const AddFuelInwardPage({Key? key, required this.mode}) : super(key: key);

  @override
  State<AddFuelInwardPage> createState() => _AddFuelInwardPageState();
}

class _AddFuelInwardPageState extends State<AddFuelInwardPage> {
  String? _projectName;

  @override
  void initState() {
    super.initState();
    _fetchStoredProject();

    if (widget.mode == FuelInwardMode.edit) {
      AppLogger.info("Edit Mode: Prefill data logic here.");
    }
  }

  // Fetch the stored project name and ID
  Future<void> _fetchStoredProject() async {
    try {
      final projectName =
      await SecureStorageUtil.readSecureData("ActiveProjectName");
      setState(() {
        _projectName = projectName;
      });

      if (_projectName != null) {
        AppLogger.info("Fetched Active Project: $_projectName");
      }
    } catch (e) {
      AppLogger.error("Error fetching project from secure storage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.mode == FuelInwardMode.edit;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 30),
          color: AppColors.primaryBlue,
        ),
        title: Column(
          children: [
            Text(
              isEditMode ? 'Edit Fuel Inward' : 'Add Fuel Inward',
              style: FontStyles.bold700.copyWith(
                color: AppColors.primaryBlackFont,
                fontSize: 18,
              ),
            ),
            Text(
              _projectName ?? 'No Project Selected',
              style: FontStyles.bold700.copyWith(
                color: AppColors.primaryBlackFont,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: isEditMode  ? IconButton(
              icon: SvgPicture.asset(
                'assets/icons/continer-icons/Delete-Primary.svg',
                color: AppColors.primary,
                height: 30,
                width: 30,
              ),
              onPressed: () {
              },
            ) : Container(),
          ),
        ],
        backgroundColor: AppColors.primaryWhitebg,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fuel Inward Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Fuel Quantity
            TextField(
              decoration: const InputDecoration(
                labelText: 'Quantity (Litres)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Vehicle Number
            TextField(
              decoration: const InputDecoration(
                labelText: 'Vehicle Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Date Picker Placeholder
            ElevatedButton(
              onPressed: () {
                // TODO: Implement date picker logic
              },
              child: const Text('Select Date'),
            ),

            const Spacer(),

            // Save / Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isEditMode) {
                    // TODO: Update API call
                    AppLogger.info("Update Fuel Inward Called");
                  } else {
                    // TODO: Save API call
                    AppLogger.info("Save Fuel Inward Called");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isEditMode ? 'Update' : 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
