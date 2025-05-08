import 'dart:convert';
import 'dart:io';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:inniti_constro/core/services/LabourAttendance/labour_attendance_api_service.dart';
import 'package:inniti_constro/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/network/logger.dart';
import '../../../../../widgets/CustomToast/custom_snackbar.dart';
import '../../../../../widgets/dropdown/dropdowen_project_iteams.dart';
import '../../../../../widgets/helper/camera_helper_service.dart';

import '../../../../core/models/dropdownhendler/projectItem_ddl.dart';
import '../../../../core/services/DropDownHandler/drop_down_hendler_api.dart';
import '../../../../core/utils/secure_storage_util.dart';
import 'TimeDisplay.dart';
import 'labor_master_attedance_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'labour_attendance_screen.dart';

class SimpleAttendanceForm extends ConsumerStatefulWidget {
  final FormMode mode;
  final LabourAttendance? attendance;
  final int labourID;
  final double latitude;
  final double longitude;
  final String address;
  final String selectedDate;

  const SimpleAttendanceForm(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.labourID,
      required this.mode,
        required this.selectedDate,
        this.attendance});

  @override
  ConsumerState<SimpleAttendanceForm> createState() =>
      _SimpleAttendanceFormState();
}

class _SimpleAttendanceFormState extends ConsumerState<SimpleAttendanceForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _inTimeController;
  late TextEditingController _outTimeController;
  late TextEditingController _overtimeController;
  late TextEditingController _overtimeRateController;
  late TextEditingController _remarksController;
  late TextEditingController _activityController;
  late TextEditingController _workingHoursController;
  late TextEditingController _dateController;

  String? contractorName = 'Inniti Software';
  String? labourName;
  String _workingHoursText = '';
  TimeOfDay? _inTime;
  TimeOfDay? _outTime;
  String? projectItem;
  int? projectItemId; // Stores selected ID
  String? _projectName;
  String? projectItemName;

  //List<Map<String, dynamic>> projectItems = [];
  List<ProjectItem> projectItems = [];

  List<String> get projectItemNames =>
      _projectItems.map((e) => e.projectItemTypeName).toList();

  bool _isLoading = true;
  String? _selectedProjectItemTypeName;
  int? _selectedProjectItemTypeId;
  List<ProjectItem> _projectItems = [];

  String? _capturedFilePath; // File path for captured image
  bool isImageUploaded = false;
  bool _isFirstLoad = true;


  void _preFillInOutTimes() {
    if (_inTimeController.text.isNotEmpty) {
      _inTime = _parseTimeOfDay(_inTimeController.text);
      AppLogger.info("Parsed InTime from controller: $_inTime");
    }

    if (_outTimeController.text.isNotEmpty) {
      _outTime = _parseTimeOfDay(_outTimeController.text);
      AppLogger.info("Parsed OutTime from controller: $_outTime");
    }

    _workingHoursText = _calculateTimeDifference(); // Recalculate duration
  }

  _pickInTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _inTime = picked;
        _inTimeController.text = picked.format(context);
        // Now that inTime is set, recalculate the working hours with both inTime and outTime
        _workingHoursText =
            _calculateTimeDifference(); // Recalculate working hours
      });
      AppLogger.info("InTime picked: ${picked.format(context)}");
      AppLogger.info("InTime updated: $_inTime");
      AppLogger.info("InTime updated controller: ${ _inTimeController.text.trim()}");
    }
  }

  // _pickOutTime() async {
  //   TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _outTime = picked;
  //       _outTimeController.text = picked.format(context);
  //       // Since inTime is still not set, workingHoursText will be '0h 0m'
  //       _workingHoursText =
  //           _calculateTimeDifference(); // Recalculate working hours
  //     });
  //     AppLogger.info("Out time picked: ${picked.format(context)}");
  //     AppLogger.info("OutTime updated: $_outTime");
  //   }
  // }

  _pickOutTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _outTime = picked;
        _outTimeController.text = picked.format(context);
        // Recalculate working hours after picking the out time, regardless of AM/PM or 24-hour format
        _workingHoursText = _calculateTimeDifference();
      });
      AppLogger.info("Out time picked: ${picked.format(context)}");
      AppLogger.info("OutTime updated: $_outTime");
    }
  }

  String convertIsoTo12Hour(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final outputFormat = DateFormat('hh:mm a');
      return outputFormat.format(dateTime);
    } catch (e) {
      AppLogger.error("Error converting ISO to 12-hour format: $e");
      return '';
    }
  }

  void setInAndOutTimeFromIso(String inIso, String outIso) {
    final inFormatted = convertIsoTo12Hour(inIso); // e.g. "06:23 PM"
    final outFormatted = convertIsoTo12Hour(outIso); // e.g. "07:45 PM"

    _inTimeController.text = inFormatted;
    _outTimeController.text = outFormatted;

    AppLogger.info("Set in time: $inFormatted, out time: $outFormatted");

    _calculateTimeDifference(); // triggers your original logic
  }

  // String _calculateTimeDifference() {
  //   final inTimeText = _inTimeController.text.trim();
  //   final outTimeText = _outTimeController.text.trim();
  //
  //   AppLogger.info("Prefilled InTime text: $inTimeText");
  //   AppLogger.info("Selected OutTime text: $outTimeText");
  //
  //   if (inTimeText.isEmpty || outTimeText.isEmpty || outTimeText== "00:00") {
  //     AppLogger.warn("InTime or OutTime is empty. Returning default '0h 0m'.");
  //     _workingHoursController.text = '0h 0m';
  //     return '0h 0m';
  //   }
  //
  //   try {
  //     _inTime = _parseTimeOfDay(inTimeText);
  //     _outTime = _parseTimeOfDay(outTimeText);
  //
  //     if (_inTime == null || _outTime == null) {
  //       throw Exception("Time parsing failed.");
  //     }
  //
  //     AppLogger.info("Parsed InTime: ${_inTime!.hour}:${_inTime!.minute}");
  //     AppLogger.info("Parsed OutTime: ${_outTime!.hour}:${_outTime!.minute}");
  //   } catch (e) {
  //     AppLogger.error("Failed to parse time: $e");
  //     _workingHoursController.text = '0h 0m';
  //     return '0h 0m';
  //   }
  //
  //   final inMinutes = _inTime!.hour * 60 + _inTime!.minute;
  //   final outMinutes = _outTime!.hour * 60 + _outTime!.minute;
  //
  //   // Ensure the time difference is always positive, handling midnight rollover
  //   int differenceInMinutes = outMinutes >= inMinutes
  //       ? outMinutes - inMinutes
  //       : (24 * 60 - inMinutes) + outMinutes;
  //
  //   // If the difference is negative, we assume it's due to spanning midnight and correct it.
  //   if (differenceInMinutes < 0) {
  //     differenceInMinutes += 24 * 60;
  //   }
  //
  //   final hours = differenceInMinutes ~/ 60;
  //   final minutes = differenceInMinutes % 60;
  //
  //   final totalHoursDecimal = differenceInMinutes / 60.0;
  //
  //   final result = '${hours}h ${minutes}m';
  //   _workingHoursController.text = result;
  //
  //   AppLogger.info("Time difference in minutes: $differenceInMinutes");
  //   AppLogger.info(
  //       "Total hours in decimal: ${totalHoursDecimal.toStringAsFixed(2)}");
  //   AppLogger.info("Calculated time difference: $result");
  //
  //   return result;
  // }

  String _calculateTimeDifference() {
    final inTimeText = _inTimeController.text.trim();
    final outTimeText = _outTimeController.text.trim();

    AppLogger.info("Prefilled InTime text: $inTimeText");
    AppLogger.info("Selected OutTime text: $outTimeText");

    if (inTimeText.isEmpty || outTimeText.isEmpty || outTimeText == "00:00") {
      AppLogger.warn("InTime or OutTime is empty. Returning default '0h 0m'.");
      _workingHoursController.text = '0h 0m';
      return '0h 0m';
    }

    try {
      // Parse both times into TimeOfDay format, regardless of 24-hour or AM/PM format
      _inTime = _parseTimeOfDay(inTimeText);
      _outTime = _parseTimeOfDay(outTimeText);

      if (_inTime == null || _outTime == null) {
        throw Exception("Time parsing failed.");
      }

      AppLogger.info("Parsed InTime: ${_inTime!.hour}:${_inTime!.minute}");
      AppLogger.info("Parsed OutTime: ${_outTime!.hour}:${_outTime!.minute}");
    } catch (e) {
      AppLogger.error("Failed to parse time: $e");
      _workingHoursController.text = '0h 0m';
      return '0h 0m';
    }

    final inMinutes = _inTime!.hour * 60 + _inTime!.minute;
    final outMinutes = _outTime!.hour * 60 + _outTime!.minute;

    // Ensure the time difference is always positive, handling midnight rollover
    int differenceInMinutes = outMinutes >= inMinutes
        ? outMinutes - inMinutes
        : (24 * 60 - inMinutes) + outMinutes;

    // If the difference is negative, we assume it's due to spanning midnight and correct it.
    if (differenceInMinutes < 0) {
      differenceInMinutes += 24 * 60;
    }

    final hours = differenceInMinutes ~/ 60;
    final minutes = differenceInMinutes % 60;

    final totalHoursDecimal = differenceInMinutes / 60.0;

    final result = '${hours}h ${minutes}m';
    _workingHoursController.text = result;

    AppLogger.info("Time difference in minutes: $differenceInMinutes");
    AppLogger.info("Total hours in decimal: ${totalHoursDecimal.toStringAsFixed(2)}");
    AppLogger.info("Calculated time difference: $result");

    return result;
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    try {
      final timeFormat = DateFormat("hh:mm a"); // AM/PM format
      DateTime parsedTime = timeFormat.parse(timeString);
      return TimeOfDay(hour: parsedTime.hour, minute: parsedTime.minute);
    } catch (e) {
      try {
        final timeFormat24 = DateFormat("HH:mm"); // 24-hour format
        DateTime parsedTime24 = timeFormat24.parse(timeString);
        return TimeOfDay(hour: parsedTime24.hour, minute: parsedTime24.minute);
      } catch (e) {
        AppLogger.error("Error parsing time: $e");
        return TimeOfDay(hour: 0, minute: 0); // Default value in case of error
      }
    }
  }

  // TimeOfDay? _parseTimeOfDay(String timeString) {
  //   try {
  //     final cleanedTime = timeString
  //         .replaceAll(
  //             RegExp(r'[\u00A0\u202F]'), ' ') // Replace NBSP and NARROW NBSP
  //         .replaceAll(RegExp(r'\s+'), ' ') // Collapse spaces
  //         .trim();
  //
  //     AppLogger.info("Sanitized time string: '$cleanedTime'");
  //
  //     // Try AM/PM format first (e.g., 10:00 AM or 2:40 PM)
  //     try {
  //       final amPmTime = DateFormat.jm().parse(cleanedTime);
  //       return TimeOfDay.fromDateTime(amPmTime);
  //     } catch (_) {}
  //
  //     // Try 24-hour format (e.g., 14:00)
  //     try {
  //       final time24 = DateFormat("HH:mm").parseStrict(cleanedTime);
  //       return TimeOfDay.fromDateTime(time24);
  //     } catch (_) {}
  //
  //     throw Exception("Time parsing failed.");
  //   } catch (e) {
  //     AppLogger.error("Time parsing failed for input '$timeString': $e");
  //     return null;
  //   }
  // }

  Future<void> _fetchProjectItems() async {
    try {
      AppLogger.info("📡 Fetching project items...");
      final items = await DropDownHendlerApi().fetchProjectItemTypes();

      if (mounted) {
        setState(() {
          _projectItems = items;
          _isLoading = false;

          // Prefill dropdown if in edit mode
          if (widget.mode == FormMode.edit &&
              widget.attendance?.projectItemTypeId != null) {
            final projectItemId = widget.attendance!.projectItemTypeId;
            AppLogger.info("Prefilling ProjectItemTypeID = $projectItemId");

            for (var item in _projectItems) {
              if (item.projectItemTypeId == projectItemId) {
                final projectItemTypeName = item.projectItemTypeName;
                AppLogger.info(
                    "✅ Prefilled ProjectItemTypeName for ID $projectItemId: $projectItemTypeName");

                _selectedProjectItemTypeId = projectItemId;
                _selectedProjectItemTypeName = projectItemTypeName;
                break;
              }
            }
          }
        });
      }
    } catch (e) {
      AppLogger.error("❌ Error fetching project items: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Define _fetchProjectItemNameById method inside _SimpleAttendanceFormState
  Future<String> _fetchProjectItemNameById(int id) async {
    // Simulate the API call by searching the list for the matching ID
    return Future.delayed(const Duration(seconds: 1), () {
      AppLogger.info("🔍 Searching for project item with ID: $id");

      // Search the list for the project item with the exact ID
      for (var item in _projectItems) {
        AppLogger.info(
            "Checking item: ${item.projectItemTypeId} - ${item.projectItemTypeName}");
        if (item.projectItemTypeId == id) {
          AppLogger.info("✅ Found matching item: ${item.projectItemTypeName}");
          return item.projectItemTypeName; // Return name if found
        }
      }

      // If no matching item is found, log this information
      AppLogger.info("❌ No matching item found for ID: $id");
      return "-- Select Project Item"; // Fallback if not found
    });
  }

  // Fetch the stored project name and ID
  Future<void> _fetchStoredProject() async {
    try {
      final projectName = await SecureStorageUtil.readSecureData("ActiveProjectName");
      setState(() {
        _projectName = projectName;
      });

      // Log the fetched project name (for debugging)
      if (_projectName != null) {
        AppLogger.info("Fetched Active Project Labor Attedance Add Pages: $_projectName");
      }
    } catch (e) {
      AppLogger.error("Error fetching project from secure storage: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchStoredProject();
    // Fetch project items asynchronously
    _fetchProjectItems();

    AppLogger.info("📍 Latitude: ${widget.latitude}");
    AppLogger.info("📍 Longitude: ${widget.longitude}");
    AppLogger.info("📍 Address: ${widget.address}");

    _dateController = TextEditingController(
      text: widget.selectedDate, // Directly using passed value
    );

    // If you have the attendance_only data, use its values; else, handle null cases.
    if (widget.attendance != null) {
      // Log the image URLs.
      String inImageUrl = widget.attendance?.inPicture ?? "No In Picture URL";
      String outImageUrl =
          widget.attendance?.outPicture ?? "No Out Picture URL";
      AppLogger.info('IN_PICTURE URL: $inImageUrl');
      AppLogger.info('OUT_PICTURE URL: $outImageUrl');
    }

    AppLogger.info("Init mode: ${widget.mode}");
    AppLogger.info("Attendance object: ${widget.attendance}");
    AppLogger.info("Attendance contractorId: ${widget.attendance!.contractorId}");
    AppLogger.info("Attendance contractorName: ${widget.attendance!.contractorName}");


    _workingHoursController = TextEditingController(
      text: widget.mode == FormMode.edit && widget.attendance?.totalHrs != null
          ? widget.attendance!.totalHrs.toString()
          : '',
    );
    AppLogger.info("working HRS prefilled: ${_workingHoursController.text}");

    _activityController = TextEditingController(
      text: widget.mode == FormMode.edit
          ? widget.attendance?.activityName ?? ''
          : '',
    );

    AppLogger.info("Activity prefilled: ${_activityController.text}");

    _remarksController = TextEditingController(
      text: widget.mode == FormMode.edit ? widget.attendance?.remark ?? '' : '',
    );
    AppLogger.info("Remarks prefilled: ${_remarksController.text}");

    _overtimeController = TextEditingController(
      text: widget.mode == FormMode.edit
          ? widget.attendance?.overTime?.toString() ?? '0'
          : '0',
    );
    AppLogger.info("OT Hours prefilled: ${_overtimeController.text}");

    _overtimeRateController = TextEditingController(
      text: widget.mode == FormMode.edit
          ? widget.attendance?.overtimeRate?.toString() ?? ''
          : '',
    );
    AppLogger.info("OT Rate prefilled: ${_overtimeRateController.text}");


    _inTimeController = TextEditingController();
    AppLogger.info("In Time prefilled: ${_inTimeController.text}");

    _outTimeController = TextEditingController();
    AppLogger.info("Out Time prefilled: ${_outTimeController.text}");

    _preFillInOutTimes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Prefill the dropdown value if projectItemTypeId is available
    if (widget.mode == FormMode.edit &&
        widget.attendance?.projectItemTypeId != null) {
      final projectItemId =
          widget.attendance!.projectItemTypeId; // This is an int? (nullable)
      AppLogger.info(
          "ProjectItem prefilled in didChangeDependencies: ID = $projectItemId");

      // Check if project items are already fetched
      if (_projectItems.isEmpty) {
        // Fetch project items if not already done
        _fetchProjectItems().then((_) {
          AppLogger.info("Fetched project items: ${_projectItems.length}");

          // Ensure projectItemId is not null before calling the method
          if (projectItemId != null) {
            _fetchProjectItemNameById(projectItemId).then((name) {
              AppLogger.info("ProjectItem prefilled: Name = $name");

              if (mounted) {
                setState(() {
                  projectItem = name; // Set the fetched project item name
                  AppLogger.info(
                      "State updated with projectItem: $projectItem");
                });
              }
            });
          }
        });
      } else {
        // If project items are already fetched, fetch the name directly
        if (projectItemId != null) {
          _fetchProjectItemNameById(projectItemId).then((name) {
            AppLogger.info("ProjectItem prefilled: Name = $name");

            if (mounted) {
              setState(() {
                projectItem = name; // Set the fetched project item name
                AppLogger.info("State updated with projectItem: $projectItem");
              });
            }
          });
        }
      }
    }

    // ✅ Prefill working hours controller and sync _workingHoursText
    final prefillWorkingHours = widget.attendance?.totalHrs?.toString() ?? '';
    _workingHoursController.text = prefillWorkingHours;
    _workingHoursText = prefillWorkingHours;
    AppLogger.info("Working Hours prefilled: $_workingHoursText");

    _activityController.text = widget.attendance?.activityName ?? '';
    _remarksController.text = widget.attendance?.remark ?? '';
    _overtimeController.text = widget.attendance?.overTime?.toString() ?? '0';
    _overtimeRateController.text =
        widget.attendance?.overtimeRate?.toString() ?? '';
    _inTimeController.text = widget.attendance?.inTime != null
        ? DateFormat('HH:mm').format(widget.attendance!.inTime!)
        : '';
    _outTimeController.text = widget.attendance?.outTime != null
        ? DateFormat('HH:mm').format(widget.attendance!.outTime!)
        : '';

    AppLogger.info("In Time prefilled: ${_inTimeController.text}");
    AppLogger.info("Out Time prefilled: ${_outTimeController.text}");

    _calculateTimeDifference();

    _isFirstLoad = false;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _inTimeController.dispose();
    _outTimeController.dispose();
    _overtimeController.dispose();
    _overtimeRateController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.mode == FormMode.edit ? 'Edit Attendance' : 'Add Attendance';
    final buttonLabel =
        widget.mode == FormMode.add ? 'Add Attendance' : 'Update Attendance';

    final String? initialProjectItemValue =
        (projectItem != null && projectItem!.isNotEmpty && projectItem != "0")
            ? projectItem
            : _selectedProjectItemTypeName;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(title,
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.primaryBlackFont),

            ),
            Text(
              _projectName ?? "",
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppColors.primaryBlackFont,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 30),
          color: AppColors.primaryBlue,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _buildHeader(
                widget.attendance?.labourName ?? 'Labour Name',
                widget.attendance?.labourCategory ?? 'Labour Category',
                widget.attendance?.contractorName ?? 'Company Name',
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _activityController,
                label: "Activity Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Activity name is required';
                  }
                  return null;
                },
                onSave: (value) {},
              ),
              SizedBox(height: 20),

              CustomFormWidgets.buildDropdown(
                context: context,
                label: "-- Selected Project Item --",
                items: projectItemNames,
                // List of project names
                selectedItem: _selectedProjectItemTypeName,
                onChanged: (value) {
                  setState(() {
                    _selectedProjectItemTypeName = value;

                    // Find the corresponding project item based on selected name
                    final selectedItem = _projectItems.firstWhere(
                      (item) => item.projectItemTypeName == value,
                      orElse: () => ProjectItem(
                          projectItemTypeId: 0, projectItemTypeName: ''),
                    );

                    // Log both the project name and its ID
                    AppLogger.info(
                        "Selected Project Item: ${selectedItem.projectItemTypeName}, ID: ${selectedItem.projectItemTypeId}");

                    // If you need to track the selected ID as well
                    _selectedProjectItemTypeId = selectedItem.projectItemTypeId;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a Projects';
                  }
                  return null;
                },
                isRequired: true,
              ),

              SizedBox(height: 20),
              _buildTextField(
                controller: _remarksController,
                label: "Remarks",
                maxLines: 3, // Allow up to 3 lines
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Remarks are required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildUploadButton(() {
                setState(() {
                  isImageUploaded = true;
                });
              }),


              SizedBox(height: 20),


              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final timeState = ref.read(timeProvider);
                        // final inTime = timeState.inTime;
                        // final outTime = timeState.outTime;

                        final latitude = widget.latitude;
                        final longitude = widget.longitude;
                        final currentLocation = widget.address;

                        double _parseWorkingHoursToDecimal(
                            String workingHoursText) {
                          try {
                            final regex = RegExp(r'(\d+)h\s+(\d+)m');
                            final match = regex.firstMatch(workingHoursText);

                            if (match != null) {
                              final hours = int.parse(match.group(1)!);
                              final minutes = int.parse(match.group(2)!);
                              return hours + (minutes / 60.0);
                            } else {
                              AppLogger.warn(
                                  "Invalid working hours format: $workingHoursText");
                              return 0.0;
                            }
                          } catch (e) {
                            AppLogger.error(
                                "Failed to parse working hours: $e");
                            return 0.0;
                          }
                        }

                        final totalHours = (widget.attendance?.overTime ??
                            _parseWorkingHoursToDecimal(
                                _workingHoursController.text));

                        // final totalHours =
                        //     (widget.attendance?.overTime ?? 0).toDouble();
                        final overTime =
                            (widget.attendance?.overTime ?? 0).toDouble();

                        final labourAttendanceId =
                            widget.attendance?.labourAttendanceId;
                        final labourId = widget.labourID;
                        final labourName = widget.attendance?.labourName ?? '';
                        final contractorName =
                            widget.attendance?.contractorName ?? '';

                        final contractorID=
                            widget.attendance?.contractorId ?? '';

                        final contractorId = widget.attendance?.contractorId is int
                            ? widget.attendance?.contractorId as int
                            : int.tryParse(widget.attendance?.contractorId.toString() ?? '0') ?? 0;

                        final labourCategory =
                            widget.attendance?.labourCategory ?? '';

                        // Log the form data for debugging
                        AppLogger.info('Attendance saved successfully');
                        AppLogger.info(
                            "🆔 Labour ID       : ${widget.labourID}");
                        AppLogger.info(
                            "Labour Attedance ID     : ${widget.attendance?.labourAttendanceId ?? 'N/A'}");
                        AppLogger.info(
                            "👷 Labour Name     : ${widget.attendance?.labourName ?? 'N/A'}");
                        AppLogger.info(
                            "🏢 Contractor Name : ${widget.attendance?.contractorName ?? 'N/A'}");
                        AppLogger.info("🏢 Contractor ID   :${widget.attendance?.contractorId ?? 'N/A'}");
                        AppLogger.info("🏢 contractorID   :${contractorID}");
                        AppLogger.info("🏢 contractorId   :${contractorId}");
                        AppLogger.info(
                            "📂 Category        : ${widget.attendance?.labourCategory ?? 'N/A'}");
                        AppLogger.info(
                            "🔧 Activity        : ${_activityController.text}");
                        AppLogger.info(
                            "📝 Remarks         : ${_remarksController.text}");
                        AppLogger.info(
                            "🕒 In Time         : ${_inTimeController.text}");
                        AppLogger.info(
                            "🕔 Out Time        : ${_outTimeController.text}");
                        AppLogger.info(
                            "🕔 Total hrs Time        : ${_workingHoursController.text}");
                        AppLogger.info(
                            "⏱️ Overtime        : ${_overtimeController.text}");
                        AppLogger.info(
                            "💰 OT Rate         : ${_overtimeRateController.text}");
                        AppLogger.info("📍 Latitude        : $latitude");
                        AppLogger.info("📍 Longitude       : $longitude");
                        AppLogger.info("📍 Address         : $currentLocation");
                        AppLogger.info(
                            "📸 In Picture URL  : ${widget.attendance!.inPicture?.toString() ?? 'N/A'}");
                        AppLogger.info("📅 Attendance Date :=> ${widget.attendance?.date ?? 'N/A'}");
                        AppLogger.info("📅 Selected Date :=> ${widget.attendance?.date ?? DateTime.now()}");


                        if (widget.mode == FormMode.edit &&
                            widget.attendance != null) {
                          AppLogger.info("Init mode: ${widget.mode}");
                          // 🔍 Log existing data before editing
                          AppLogger.info(
                              "✏️ Editing Existing Attendance Record");

                          // Prepare the imagePath, handle null or empty path
                          // String? imagePath = _capturedFilePath;
                          // if (imagePath == null || imagePath.isEmpty) {
                          //   AppLogger.warn("⚠️ No image captured for attendance. Using default image or null.");
                          //   imagePath = 'default_image_path'; // Fallback value if no image is captured
                          // }

                          // Log full data going into the API
                          AppLogger.info(
                              "📤 Calling _editdata API with the following details:");
                          AppLogger.info("🆔 Labour ID       : $labourId");
                          AppLogger.info("🆔 contractor Id       : $contractorId");
                          AppLogger.info("👷 Labour Name     : $labourName");
                          AppLogger.info(
                              "🏢 Contractor Name : $contractorName");
                          AppLogger.info(
                              "📂 Category        : $labourCategory");
                          AppLogger.info(
                              "🔧 Activity        : ${_activityController.text}");
                          AppLogger.info(
                              "📝 Remarks         : ${_remarksController.text}");
                          AppLogger.info(
                              "🕒 In Time         : ${_inTimeController.text}");
                          AppLogger.info(
                              "🕔 Out Time        : ${_outTimeController.text}");
                          AppLogger.info(
                              "🕐 Working Hours   : ${_workingHoursController.text}");
                          AppLogger.info(
                              "⏱️ Overtime        : ${_overtimeController.text}");
                          AppLogger.info(
                              "💰 OT Rate         : ${_overtimeRateController.text}");
                          AppLogger.info("📍 Latitude        : $latitude");
                          AppLogger.info("📍 Longitude       : $longitude");
                          AppLogger.info(
                              "📍 Address         : $currentLocation");

                          final DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(_dateController.text);
                          final String formattedDate = parsedDate.toIso8601String(); // gives '2025-05-01T00:00:00.000'
                          final String finalDate = formattedDate.split('.').first;   // removes milliseconds


                          await _editdata(
                            laborAttendanceId: labourAttendanceId ?? 0,
                            laborId: labourId,
                            name: labourName,
                            company: contractorName,
                            contractorId: contractorId,
                            category: labourCategory,
                            projectItemTypeId: _selectedProjectItemTypeId,
                            activityName: _activityController.text,
                            otHours: _overtimeController.text,
                            otRate: _overtimeRateController.text,
                            inTime: _inTimeController.text,
                            outTime: _outTimeController.text,
                            totalHours: totalHours.toDouble(),
                            overTime: overTime,
                            // imagePath: imagePath ?? '', // Use fallback or null
                            imagePath: _capturedFilePath ?? '',
                            fileName: 'attendance_only.png',
                            latitude: latitude,
                            longitude: longitude,
                            currentLocation: currentLocation,
                            remark: _remarksController.text,
                            date: widget.attendance?.date ?? DateTime.now(), // Pass date to the API
                          );

                          // Log image file path if captured
                          // if (imagePath != null && imagePath.isNotEmpty) {
                          //   AppLogger.info('Captured Image File Path: $imagePath');
                          // }

                          // ✅ Log image file path (if captured)
                          if (_capturedFilePath == null ||
                              _capturedFilePath!.isEmpty) {
                            AppLogger.warn(
                                "⚠️ No image captured for attendance_only");
                          }

                          // ✅ Reset the provider state
                          ref.read(timeProvider.notifier).reset();

                          // ✅ Optionally clear time controllers too
                          _inTimeController.clear();
                          _outTimeController.clear();

                          // Navigate back after saving
                          //Navigator.pop(context, true);
                          //Navigator.pop(context, true);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LabourAttendancePage()),
                                (Route<dynamic> route) => false,
                          );



                          setState(() {});
                        } else {
                          AppLogger.info(
                              "🆕 SimpleAttendanceForm in ADD MODE FRO API CALL");

                          // Check latitude, longitude, and currentLocation for null, fallback if needed
                          final latitude = widget.latitude;
                          final longitude = widget.longitude;
                          final currentLocation = widget.address;

                          // Log full data going into the API
                          AppLogger.info(
                              "📤 Calling _saveData API with the following details:");
                          AppLogger.info("🆔 Labour ID       : $labourId");
                          AppLogger.info("🆔 contractor Id Save Time: $contractorId");
                          AppLogger.info("👷 Labour Name     : $labourName");
                          AppLogger.info(
                              "🏢 Contractor Name : $contractorName");
                          AppLogger.info(
                              "📂 Category        : $labourCategory");
                          AppLogger.info(
                              "🔧 Activity        : ${_activityController.text}");
                          AppLogger.info(
                              "📝 Remarks         : ${_remarksController.text}");
                          AppLogger.info(
                              "🕒 In Time         : ${_inTimeController.text}");
                          AppLogger.info(
                              "🕒 Selcated Date    : ${_dateController.text}");
                          AppLogger.info(
                              "🕔 Out Time        : ${_outTimeController.text}");
                          AppLogger.info(
                              "⏱️ Overtime        : ${_overtimeController.text}");
                          AppLogger.info(
                              "💰 OT Rate         : ${_overtimeRateController.text}");
                          AppLogger.info("📍 Latitude        : $latitude");
                          AppLogger.info("📍 Longitude       : $longitude");
                          AppLogger.info(
                              "📍 Address         : $currentLocation");

                          String? imagePath = _capturedFilePath;
                          String fileName =
                              (imagePath != null && imagePath.isNotEmpty)
                                  ? 'attendance_only.png'
                                  : '';
                          imagePath ??= '';

                          final DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(_dateController.text);
                          final String formattedDate = parsedDate.toIso8601String(); // gives '2025-05-01T00:00:00.000'
                          final String finalDate = formattedDate.split('.').first;   // removes milliseconds


                          await _saveData(
                            laborId: labourId,
                            name: labourName,
                            company: contractorName,
                            category: labourCategory,
                            contractorId: contractorId,
                            projectItemTypeId: _selectedProjectItemTypeId,
                            activityName: _activityController.text,
                            remark: _remarksController.text,
                            otHours: _overtimeController.text,
                            otRate: _overtimeRateController.text,
                            inTime: _inTimeController.text,
                            outTime: _outTimeController.text,
                            totalHours: totalHours.toDouble(),
                            overTime: overTime,
                            imagePath: imagePath,
                            fileName: fileName,
                            latitude: latitude,
                            longitude: longitude,
                            currentLocation: currentLocation,
                            date:finalDate,
                           // date: _inTimeController.text,
                          );
                        }

                        // Reset and finish
                        ref.read(timeProvider.notifier).reset();
                        _inTimeController.clear();
                        _outTimeController.clear();

                        if (_capturedFilePath != null) {
                          AppLogger.info('✅ Image Path: $_capturedFilePath');
                        }

                        setState(() {});

                        // Navigate back after saving
                        //Navigator.pop(context, true); // Pop and optionally return a value
                        //Navigator.pop(context, true); // Pop and optionally return a value



                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => LabourAttendancePage()),
                        //       (Route<dynamic> route) => false,
                        // );

                      },

                      child: Text(buttonLabel),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text("Close"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String labourCategory, String company) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryWhitebg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                "assets/icons/home-iocn/pin-icon.svg",
                height: 20,
                width: 20,
              ),
              const SizedBox(width: 6),
              Text(
                company,
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryLightGrayFont,
                ),
              ),
            ],
          ),
          const Divider(),
          _buildInfoRow("Labour Name", name, "Labour Category", labourCategory),

          _buildInfoRowDW(
            "Date",
            // DateFormat('dd/MM/yyyy').format(DateTime.now()),
            _dateController.text.trim(),
            "Working Hrs.",
            _workingHoursText,
          ),
          _buildInfoRowTime(
              // "In Time", // Title for In Time
              // inTime,

              // "Out Time", // Title for Out Time

              // outTime,
              ),
          _buildInfoRowNumber(
            "OT Hrs.",
            _overtimeController,
            "OT Rate/Hrs.",
            _overtimeRateController,
          ),
        ],
      ),
    );
  }

  // **Helper method to build the info rows**
  Widget _buildInfoRow(
    String title1,
    String value1,
    String title2,
    String value2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoColumn(title1, value1),
          Container(
            width: 2, // Thin vertical divider
            height: 30, // Divider height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffe5dcf3), // Transparent at the top
                  Color(0xff9b79d0), // Stronger in the middle
                  Color(0xffe5dcf3), // Transparent at the bottom
                ],
              ),
            ),
          ),
          _infoColumn(title2, value2),
        ],
      ),
    );
  }

  Widget _buildInfoRowNumber(
    String title1,
    TextEditingController controller1,
    String title2,
    TextEditingController controller2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          _infoColumnnumbers(title1, controller1),
          Container(
            width: 2,
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffe5dcf3),
                  Color(0xff9b79d0),
                  Color(0xffe5dcf3),
                ],
              ),
            ),
          ),
          _infoColumnnumbers(title2, controller2),
        ],
      ),
    );
  }

// Info Row for Date and Working Hours
  Widget _buildInfoRowDW(
    String title1,
    String value1,
    String title2,
    String value2,
  ) {
    // Log the received titles and values for better understanding
    AppLogger.info(
      "Building Info Row: title1=$title1, value1=$value1, title2=$title2, value2=$value2",
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title1, // "Date"
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    value1, // Current Date
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 2,
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffe5dcf3),
                  Color(0xff9b79d0),
                  Color(0xffe5dcf3),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title2, // "Working Hrs."
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  // TextFormField(
                  //   controller: _workingHoursController,
                  //   readOnly: true,
                  //   decoration: InputDecoration(labelText: 'Working Hours'),
                  // ),

                  Text(
                    _workingHoursController.text.trim(),
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  // Text(
                  //   _workingHoursText,
                  //   style: GoogleFonts.nunitoSans(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w700,
                  //     color: Colors.black,
                  //   ),
                  //  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: _buildTimePickerField(
              label: 'In Time',
              controller: _inTimeController,
              onTap: _pickInTime,
            ),
          ),
          Container(
            width: 2,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffe5dcf3),
                  Color(0xff9b79d0),
                  Color(0xffe5dcf3),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildTimePickerField(
              label: 'Out Time',
              controller: _outTimeController,
              onTap: _pickOutTime,
            ),
          ),
        ],
      ),
    );
  }

// Time Picker Field Widget
  Widget _buildTimePickerField({
    required String label,
    required TextEditingController controller,
    required void Function() onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: label,
        fillColor: AppColors.primaryWhitebg,
        suffixIcon: Icon(Icons.access_time),
        border: OutlineInputBorder(),
      ),
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  // **Helper method to display individual columns in the info row**
  Widget _infoColumn(String title, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryLightGrayFont,
              ),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlackFont,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumnnumbers(String title, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryLightGrayFont,
              ),
            ),
            SizedBox(height: 2),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter $title",
                filled: true,
                fillColor: AppColors.primaryWhitebg,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "$title is required";
                }
                return null;
              },
              onChanged: (value) {
                AppLogger.info("✏️ $title changed: $value");
              },
              onSaved: (value) {
                AppLogger.info("💾 $title saved: $value");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String?)? onSave,
    int? maxLines, // Optional parameter to allow multiline input
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint:
            true, // Makes sure the label stays at the top when expanded
      ),
      keyboardType: inputType,
      maxLines: maxLines ?? 1,
      // Default to 1 line, but can be customized
      onSaved: onSave,
      validator: validator,
    );
  }

  // String formatTimeToIso(String timeStr) {
  //   try {
  //     final now = DateTime.now();
  //     final parsedTime = DateFormat('hh:mm a').parse(timeStr.trim());
  //     final dt = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       parsedTime.hour,
  //       parsedTime.minute,
  //     );
  //     return dt.toIso8601String();
  //   } catch (e) {
  //     return '';
  //   }
  // }



  Widget _buildUploadButton(VoidCallback onUploadSuccess) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () async {
              try {
                final File? imageFile =
                    await CameraHelperForLaborAttedance.openCamera(context);

                if (imageFile != null) {
                  setState(() {
                    _capturedFilePath = imageFile.path;
                  });

                  onUploadSuccess();
                  CustomSnackbar.show(
                    isError: false,
                    context,
                    message: "Image captured successfully!",
                  );
                } else {
                  CustomSnackbar.show(
                    context,
                    message: "No image captured.",
                    isError: true,
                  );
                }
              } catch (e) {
                AppLogger.error("Error capturing image: $e");
                CustomSnackbar.show(
                  isError: true,
                  context,
                  message: "Error capturing image. Please try again.",
                );
              }
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xffE6E0EF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/attendance_only/Upload-cam-svg.svg",
                        height: 24,
                        width: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Upload Image",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Future<void> _saveData({
    required int laborId,
    required String name,
    required String company,
    required String category,
    required int? projectItemTypeId,
    required int contractorId,
    required String activityName,
    required String remark,
    required String otHours,
    required String otRate,
    required String inTime,
    required String outTime,
    required double totalHours,
    required double overTime,
    required String imagePath,
    required String fileName,
    double? latitude,
    double? longitude,
    String? currentLocation,
    required String date,
  }) async {
    try {
      // Validate inTime: It must not be empty
      if (inTime.isEmpty) {
        AppLogger.warn("inTime is mandatory and cannot be empty.");
        CustomSnackbar.show(
          isError: true,
          context,
          message: "Please provide a valid In Time.",
        );
        return; // Exit early if inTime is invalid
      }

      // Convert image to base64 if an image is provided
      String base64Image = "";
      if (imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          base64Image = base64Encode(bytes); // Convert image to base64
          AppLogger.debug("Base64 Image (first 100 chars): ${base64Image.substring(0, 100)}...");
        } else {
          AppLogger.warn("Image file does not exist at path: $imagePath");
        }
      } else {
        AppLogger.warn("No image path provided. Skipping image encoding.");
      }

      // Log the attendance_only details for debugging
      AppLogger.info("Initiating labour attendance_only save process...");
      AppLogger.debug("Attendance Details add or Save time:\n"
          "Labour ID: $laborId\n"
          "Name: $name\n"
          "Company: $company\n"
          "Category: $category\n"
          "Activity: $activityName\n"
          "Remark: $remark\n"
          "OT Hours: $otHours\n"
          "OT Rate: $otRate\n"
          "In Time: $inTime\n"
          "Out Time: $outTime\n"
          "Total Hours: $totalHours\n"
          "OverTime: $overTime\n"
          "FileName: $fileName\n"
          "Latitude: ${latitude ?? 'null'}\n"
          "Longitude: ${longitude ?? 'null'}\n"
          "Location: $currentLocation");

      // Helper function to format time (e.g., "08:30 AM" -> "2025-05-01T08:30:00")
      // String formatTimeToIso(String time) {
      //   try {
      //     final now = DateTime.now();
      //     final inputFormat = DateFormat('hh:mm a'); // 12-hour format with AM/PM
      //     final parsedTime = inputFormat.parse(time);
      //     final dateTime = DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
      //     final outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
      //     return outputFormat.format(dateTime);
      //   } catch (e) {
      //     AppLogger.error("Invalid time format: $time. Error: $e");
      //     return ''; // Return an empty string in case of error
      //   }
      // }




      String formatTimeToIso(String timeStr) {
        final now = DateTime.now();

        try {
          DateTime dateTime;

          if (timeStr.toLowerCase().contains('am') || timeStr.toLowerCase().contains('pm')) {
            // 12-hour format with AM/PM
            final inputFormat = DateFormat('hh:mm a');
            final parsedTime = inputFormat.parse(timeStr.trim());
            dateTime = DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
          } else {
            // 24-hour format (e.g., "14:30")
            final parts = timeStr.split(':');
            if (parts.length != 2) return '';

            final hour = int.tryParse(parts[0].trim()) ?? 0;
            final minute = int.tryParse(parts[1].trim()) ?? 0;
            dateTime = DateTime(now.year, now.month, now.day, hour, minute);
          }

          return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
        } catch (e) {
          print("Invalid time format: $timeStr. Error: $e");
          return '';
        }
      }


      // Format inTime and outTime to ISO 8601 string
      final formattedInTime = formatTimeToIso(inTime);
      final formattedOutTime = formatTimeToIso(outTime);


      // Safe fallback for latitude and longitude if null
      final safeLatitude = latitude ?? 0.0;
      final safeLongitude = longitude ?? 0.0;

      // Format date to ISO 8601 string (e.g., "2025-04-30T08:00:00")
      //final formattedDate = date.toIso8601String().split('.')[0];
      //AppLogger.debug("Formatted Attendance Date: $formattedDate");

      // Send the attendance_only data to the API
      final response = await LabourAttendanceApiService().saveLabourAttendance(
        labourID: laborId,
        status: "PRESENT", // Attendance status
        overTime: overTime,
        overTimeRate: otRate,
        inTime: formattedInTime,
        outTime: formattedOutTime,
        totalHours: totalHours,
        base64Image: base64Image,
        fileName: base64Image.isNotEmpty ? fileName : '', // Pass fileName only if base64Image is provided
        latitude: safeLatitude,
        longitude: safeLongitude,
        currentLocation: currentLocation,
        labourName: name,
        labourCategory: category,
        activityName: activityName,
        remark: remark,
        contractorName: company,
        contractorID: contractorId,
        projectItemTypeId: projectItemTypeId,
        date: date,
      );

      // Handle API response
      if (response != null && response['Status'] == 'Success') {
        AppLogger.info("Attendance saved successfully with ID: ${response['Data']}");

        // Refresh the screen and navigate
        // Navigator.pop(context, true); // Close current screen
        //Navigator.pop(context, true); // Close curren
        // t screen


        //AppLogger.info('Navigating to LabourAttendancePage and clearing navigation stack.');
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => const LabourAttendancePage()),
        //      // (Route<dynamic> route) => false,
        // );

        // if (context.mounted) {
        //   AppLogger.info('Context is still mounted, popping current screen.');
        //   Navigator.of(context).pop();
        // } else {
        //   AppLogger.info('Context is no longer mounted, skipping Navigator.pop().');
        // }


        // Navigator.pushReplacementNamed(context, AppRoutes.LaborAttendanceAdd); // Reopen the same screen for new data
        // AppLogger.info("call rotes pushReplacementNamed");

        Navigator.pop(context, true); // ✅ Go back & return success flag
        Navigator.pop(context, true); // ✅ Go back & return success flag
        AppLogger.info(" Go back ");


        if (response == true) {
         setState(() {

          // Navigator.pushReplacementNamed(context, AppRoutes.LaborAttendanceAdd); // Reopen the same screen for new data
          //AppLogger.info("call rotes pushReplacementNamed");


         });
        }

       /////// Navigator.pushNamed(context, AppRoutes.LaborAttendanceAdd); // Reopen the same screen for new data


      // Navigator.pop(context, true); // Close current screen
      //  AppLogger.info("call rotes pop out");

      } else {
        AppLogger.warn("Attendance save failed. Response: ${response ?? 'null'}");
      }
    } catch (e, stackTrace) {
      // Log exception details
      AppLogger.error("Error while saving attendance_only: $e");
      AppLogger.debug("Stack Trace: $stackTrace");

      // Show error message in case of an exception
      CustomSnackbar.show(
        isError: true,
        context,
        message: "An error occurred while saving the data.",
      );
    }
  }


  Future<void> _editdata({
    required int laborId,
    required int laborAttendanceId,
    required String name,
    required String company,
    required String category,
    required int contractorId,
    required int? projectItemTypeId,
    required String activityName,
    required String remark,
    required String otHours,
    required String otRate,
    required String inTime,
    required String outTime,
    required double totalHours,
    required double overTime,
    required String? imagePath,
    required String fileName,
    required double? latitude,
    required double? longitude,
    required String currentLocation,
    required DateTime date,
  }) async {
    try {
      // Validate outTime: it must not be empty
      if (outTime.isEmpty) {
        AppLogger.warn("⚠️ outTime is mandatory and cannot be empty.");
        CustomSnackbar.show(
          isError: true,
          context,
          message: "Please provide a valid Out Time.",
        );
        return; // Exit early if outTime is invalid
      }

      // Time formatter helper function for parsing input time
      DateTime parseTime(String timeStr) {
        try {
          if (timeStr.toLowerCase().contains('am') || timeStr.toLowerCase().contains('pm')) {
            return DateFormat("hh:mm a").parse(timeStr); // 12-hour format
          } else {
            return DateFormat("HH:mm").parse(timeStr); // 24-hour format
          }
        } catch (e) {
          throw FormatException("Time format error: $timeStr");
        }
      }

      // Parsing inTime and outTime strings
      final parsedIn = parseTime(inTime.trim());
      final parsedOut = parseTime(outTime.trim());

      // Creating full DateTime objects from parsed time
      final fullInTime = DateTime(date.year, date.month, date.day, parsedIn.hour, parsedIn.minute);
      final fullOutTime = DateTime(date.year, date.month, date.day, parsedOut.hour, parsedOut.minute);

      // Formatting times to the required API format
      final apiTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
      final formattedInTime = apiTimeFormat.format(fullInTime);
      final formattedOutTime = apiTimeFormat.format(fullOutTime);

      // Calculate total hours worked (difference in minutes converted to hours)
      final calculatedTotalHours = double.parse(
        (fullOutTime.difference(fullInTime).inMinutes / 60).toStringAsFixed(2),
      );

      // Log attendance_only details
      AppLogger.info("📌 [START] Initiating labour edit...");
      AppLogger.debug("🧾 Attendance Details for edit :"
          "\n🔹 Labour ID: $laborId"
          "\n🔹 Name: $name"
          "\n🔹 Company: $company"
          "\n🔹 Category: $category"
          "\n🔹 Activity: $activityName"
          "\n🔹 OT Hours: $otHours"
          "\n🔹 OT Rate: $otRate"
          "\n🔹 In Time: $inTime"
          "\n🔹 Out Time: $outTime"
          "\n🔹 Total Hours..: $calculatedTotalHours"
          "\n🔹 OverTime: $overTime"
          "\n🔹 FileName: $fileName"
          "\n🔹 Latitude: ${latitude ?? 'null'}"
          "\n🔹 Longitude: ${longitude ?? 'null'}"
          "\n🔹 Location: $currentLocation");

      // Log image path and filename
      AppLogger.info("🖼️ Image Path       : ${imagePath ?? 'No image provided'}");
      AppLogger.info("📁 Image File Name  : $fileName");

      // Convert image to base64 if provided
      String base64Image = '';
      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        final bytes = await file.readAsBytes();
        base64Image = base64Encode(bytes); // Convert image to base64
        AppLogger.debug("🖼️ Base64 Image editing (first 100 chars): ${base64Image.substring(0, 100)}...");
      } else {
        AppLogger.warn("⚠️ No image provided. Proceeding without image.");
      }

      // Format the DateTime 'date' to a string
      final formattedDate = DateFormat("yyyy-MM-dd").format(date);

      // Prepare the payload for the API call
      final payload = {
        "labourAttendanceID": laborAttendanceId,
        "labourID": laborId,
        "status": "PRESENT",
        "overtime": overTime,
        "overtimeRate": otRate,
        "inTime": formattedInTime,
        "outTime": formattedOutTime,
        "totalHours": calculatedTotalHours,
        "contractorID": contractorId,
        "fileName": fileName,
        "base64Image": base64Image.isNotEmpty ? base64Image.substring(0, 50) + "..." : "No image",
        "latitude": latitude,
        "longitude": longitude,
        "currentLocation": currentLocation,
        "activityName": activityName,
        "remark": remark,
        "labourName": name,
        "labourCategory": category,
        "isDeleted": false,
        "isApproved": false,
        "approvedBy": null,
        "approvedDate": null,
        "isPaid": false,
        "projectItemTypeId": projectItemTypeId ?? 0,
      };
      AppLogger.debug("📦 [Payload to editLabourAttendance]:\n$payload");

      // Make the API call to edit labour attendance_only
      final response = await LabourAttendanceApiService().editLabourAttendance(
        labourAttendanceID: laborAttendanceId,
        labourID: laborId,
        status: "PRESENT",
        overtime: otHours,
        overtimeRate: otRate,
        inTime: formattedInTime,
        outTime: formattedOutTime,
        totalHours: calculatedTotalHours,
        contractorID: contractorId,
        //contractorID: widget.attendance_only?.contractorId ?? 0,
        fileName: fileName,
        base64Image: base64Image ?? "",
        latitude: latitude,
        longitude: longitude,
        currentLocation: currentLocation,
        activityName: activityName,
        remark: remark,
        labourName: name,
        labourCategory: category,
        isDeleted: false,
        isApproved: false,
        approvedBy: null,
        approvedDate: null,
        isPaid: false,
        projectItemTypeId: projectItemTypeId ?? 0,
        date: formattedDate,
      );

      // Handle the API response
      if (response != null && response['Status'] == 'Success') {
        AppLogger.info("✅ [SUCCESS] Attendance saved successfully with ID: ${response['Data']}");
        // Optionally navigate or perform other actions

        Navigator.pop(context, true); // Close current screen
        // Navigator.pushReplacementNamed(context, AppRoutes.LaborAttendanceAdd);

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => const LabourAttendancePage()),
        // );


      } else {
        AppLogger.warn("⚠️ Attendance edit failed. Response: ${response ?? 'null'}");
      }
    } catch (e, stackTrace) {
      // Log any errors that occur
      AppLogger.error("❌ [EXCEPTION] Exception during edit: $e");
      AppLogger.debug("🪵 Stack Trace:\n$stackTrace");

      // Show error message to the user
      CustomSnackbar.show(
        isError: true,
        context,
        message: "An error occurred while saving the data.",
      );
    }
  }
}

  class CustomFormWidgets {
  static Widget buildDropdown({
    required BuildContext context,
    required String label,
    required List<String> items,
    required String? selectedItem,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField<String>(
          initialValue: selectedItem,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AbsorbPointer(
                  absorbing: items.isEmpty, // disables tap if list is empty
                  child: CustomDropdown<String>.search(
                    hintText: "$label",
                    items: items,
                    initialItem: selectedItem,
                    onChanged: (value) {
                      state.didChange(value);
                      onChanged(value);
                    },
                    decoration: CustomDropdownDecoration(
                      expandedFillColor: AppColors.scaffoldWithBoxBackground,
                      closedFillColor: AppColors.primaryWhitebg,
                      hintStyle: TextStyle(color: AppColors.primaryBlackFont),
                    ),
                  ),
                ),
                if (items.isEmpty && selectedItem != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      selectedItem,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
