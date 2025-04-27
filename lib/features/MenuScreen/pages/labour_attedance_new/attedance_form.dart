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
import 'TimeDisplay.dart';
import 'labor_master_attedance_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimpleAttendanceForm extends ConsumerStatefulWidget {
  final FormMode mode;
  final LabourAttendance? attendance;
  final int labourID;
  final double latitude;
  final double longitude;
  final String address;

  const SimpleAttendanceForm(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.labourID,
      required this.mode,
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

  String? contractorName = 'Inniti Software';
  String? labourName;
  String _workingHoursText = '';
  TimeOfDay? _inTime;
  TimeOfDay? _outTime;
  String? projectItem;
  int? projectItemId; // Stores selected ID
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

  // int? _selectedProjectItemTypeId;
  // String? _selectedProjectItemTypeName;

// Function to convert TimeOfDay to DateTime
//   DateTime convertTimeOfDayToDateTime(TimeOfDay timeOfDay) {
//     final now = DateTime.now();
//     return DateTime(
//         now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
//   }

  // String _calculateTimeDifference() {
  //   final inTimeText = _inTimeController.text;
  //   final outTimeText = _outTimeController.text;
  //
  //   if (inTimeText.isEmpty || outTimeText.isEmpty) {
  //     return '0h 0m';
  //   }
  //
  //   try {
  //     // Parse TimeOfDay from formatted string like "2:30 PM"
  //     TimeOfDay parseTime(String time) {
  //       final parts = time.split(' ');
  //       final hm = parts[0].split(':');
  //       int hour = int.parse(hm[0]);
  //       int minute = int.parse(hm[1]);
  //       final isPM = parts[1].toLowerCase() == 'pm';
  //
  //       if (isPM && hour != 12) hour += 12;
  //       if (!isPM && hour == 12) hour = 0;
  //
  //       return TimeOfDay(hour: hour, minute: minute);
  //     }
  //
  //     final inTime = parseTime(inTimeText);
  //     final outTime = parseTime(outTimeText);
  //
  //     final now = DateTime.now();
  //     final inDateTime =
  //         DateTime(now.year, now.month, now.day, inTime.hour, inTime.minute);
  //     DateTime outDateTime =
  //         DateTime(now.year, now.month, now.day, outTime.hour, outTime.minute);
  //
  //     if (outDateTime.isBefore(inDateTime)) {
  //       outDateTime =
  //           outDateTime.add(Duration(days: 1)); // Handle overnight shifts
  //     }
  //
  //     final diff = outDateTime.difference(inDateTime);
  //     final hours = diff.inHours;
  //     final minutes = diff.inMinutes % 60;
  //
  //     return '${hours}h ${minutes}m';
  //   } catch (e) {
  //     return '0h 0m';
  //   }
  // }

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
      AppLogger.info("In time picked: ${picked.format(context)}");
      AppLogger.info("InTime updated: $_inTime");
    }
  }

  _pickOutTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _outTime = picked;
        _outTimeController.text = picked.format(context);
        // Since inTime is still not set, workingHoursText will be '0h 0m'
        _workingHoursText =
            _calculateTimeDifference(); // Recalculate working hours
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

  String _calculateTimeDifference() {
    final inTimeText = _inTimeController.text.trim();
    final outTimeText = _outTimeController.text.trim();

    AppLogger.info("Prefilled InTime text: $inTimeText");
    AppLogger.info("Selected OutTime text: $outTimeText");

    if (inTimeText.isEmpty || outTimeText.isEmpty) {
      AppLogger.warn("InTime or OutTime is empty. Returning default '0h 0m'.");
      _workingHoursController.text = '0h 0m';
      return '0h 0m';
    }

    try {
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
    AppLogger.info(
        "Total hours in decimal: ${totalHoursDecimal.toStringAsFixed(2)}");
    AppLogger.info("Calculated time difference: $result");

    return result;
  }

  TimeOfDay? _parseTimeOfDay(String timeString) {
    try {
      final cleanedTime = timeString
          .replaceAll(
              RegExp(r'[\u00A0\u202F]'), ' ') // Replace NBSP and NARROW NBSP
          .replaceAll(RegExp(r'\s+'), ' ') // Collapse spaces
          .trim();

      AppLogger.info("Sanitized time string: '$cleanedTime'");

      // Try AM/PM format first (e.g., 10:00 AM or 2:40 PM)
      try {
        final amPmTime = DateFormat.jm().parse(cleanedTime);
        return TimeOfDay.fromDateTime(amPmTime);
      } catch (_) {}

      // Try 24-hour format (e.g., 14:00)
      try {
        final time24 = DateFormat("HH:mm").parseStrict(cleanedTime);
        return TimeOfDay.fromDateTime(time24);
      } catch (_) {}

      throw Exception("Time parsing failed.");
    } catch (e) {
      AppLogger.error("Time parsing failed for input '$timeString': $e");
      return null;
    }
  }

  // TimeOfDay? _parseTimeOfDay(String timeString) {
  //   try {
  //     DateTime parsed;
  //
  //     // Try parsing 'h:mm a' format first (e.g. 3:09 PM)
  //     try {
  //       parsed = DateFormat.jm().parse(timeString);
  //     } catch (_) {
  //       // Fallback: Try parsing 'HH:mm' format (e.g. 10:33)
  //       parsed = DateFormat('HH:mm').parse(timeString);
  //     }
  //
  //     return TimeOfDay(hour: parsed.hour, minute: parsed.minute);
  //   } catch (e) {
  //     AppLogger.warn("Failed to parse time string: $timeString");
  //     return null;
  //   }
  // }

  // /// Utility: Get ProjectItemTypeName by ID from projectItems
  // String? _getProjectItemNameById(String? id) {
  //   if (id == null) return null;
  //
  //   int? projectItemId = int.tryParse(id);
  //   if (projectItemId == null) return null;
  //
  //   final item = projectItems.firstWhere(
  //         (element) => element['ProjectItemTypeID'] == projectItemId,
  //     orElse: () => {},
  //   );
  //
  //   if (item.isNotEmpty) {
  //     return item['ProjectItemTypeName'] as String?;
  //   }
  //   return null;
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

  @override
  void initState() {
    super.initState();
    // Fetch project items asynchronously
    _fetchProjectItems();

    AppLogger.info("📍 Latitude: ${widget.latitude}");
    AppLogger.info("📍 Longitude: ${widget.longitude}");
    AppLogger.info("📍 Address: ${widget.address}");

    // If you have the attendance data, use its values; else, handle null cases.
    if (widget.attendance != null) {
      // Log the image URLs.
      String inImageUrl = widget.attendance?.inPicture ?? "No In Picture URL";
      String outImageUrl =
          widget.attendance?.outPicture ?? "No Out Picture URL";
      AppLogger.info('IN_PICTURE URL: $inImageUrl');
      AppLogger.info('OUT_PICTURE URL: $outImageUrl');
    }

    // _workingHoursController = TextEditingController();
    //
    // _inTimeController = TextEditingController(
    //   text:
    //       widget.mode == FormMode.edit && widget.attendance?.inTime != null
    //           ? DateFormat('HH:mm').format(widget.attendance!.inTime!)
    //           : '',
    // );
    //
    // _outTimeController = TextEditingController(
    //   text:
    //       widget.mode == FormMode.edit && widget.attendance?.outTime != null
    //           ? DateFormat('HH:mm').format(widget.attendance!.outTime!)
    //           : '',
    // );
    //
    // _overtimeController = TextEditingController(
    //   text:
    //       widget.mode == FormMode.edit
    //           ? widget.attendance?.overTime?.toString() ?? '0'
    //           : '0',
    // );
    //
    // _overtimeRateController = TextEditingController(
    //   text:
    //       widget.mode == FormMode.edit
    //           ? widget.attendance?.overtimeRate?.toString() ?? ''
    //           : '',
    // );
    //
    // _remarksController = TextEditingController(
    //   text: widget.mode == FormMode.edit ? widget.attendance?.remark ?? '' : '',
    // );
    //
    // _activityController = TextEditingController();

    AppLogger.info("Init mode: ${widget.mode}");
    AppLogger.info("Attendance object: ${widget.attendance}");

    // if (widget.mode == FormMode.edit &&
    //     widget.attendance?.projectItemTypeId != null) {
    //   projectItem = widget.attendance!.projectItemTypeId.toString();
    //   AppLogger.info("projectItem prefilled: $projectItem");
    // }

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

    // _inTimeController = TextEditingController(
    //   text: widget.mode == FormMode.edit && widget.attendance?.inTime != null
    //       ? DateFormat('HH:mm').format(widget.attendance!.inTime!)
    //       : '',
    // );

    _inTimeController = TextEditingController();
    AppLogger.info("In Time prefilled: ${_inTimeController.text}");

    // _outTimeController = TextEditingController(
    //   text: widget.mode == FormMode.edit && widget.attendance?.outTime != null
    //       ? DateFormat('HH:mm').format(widget.attendance!.outTime!)
    //       : '',
    // );

    _outTimeController = TextEditingController();
    AppLogger.info("Out Time prefilled: ${_outTimeController.text}");

    _preFillInOutTimes();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   // Ensure the attendance data is available before attempting to prefill
  //
  //   _activityController.text = widget.attendance?.activityName ?? '';
  //   _remarksController.text = widget.attendance?.remark ?? '';
  //   _overtimeController.text = widget.attendance?.overTime?.toString() ?? '0';
  //   _overtimeRateController.text =
  //       widget.attendance?.overtimeRate?.toString() ?? '';
  //   _inTimeController.text = widget.attendance?.inTime != null
  //       ? DateFormat('HH:mm').format(widget.attendance!.inTime!)
  //       : '';
  //   _outTimeController.text = widget.attendance?.outTime != null
  //       ? DateFormat('HH:mm').format(widget.attendance!.outTime!)
  //       : '';
  //
  //   // Log prefilled data
  //   AppLogger.info("Activity prefilled: ${_activityController.text}");
  //   AppLogger.info("Remarks prefilled: ${_remarksController.text}");
  //   AppLogger.info("OT Hours prefilled: ${_overtimeController.text}");
  //   AppLogger.info("OT Rate prefilled: ${_overtimeRateController.text}");
  //   AppLogger.info("In Time prefilled: ${_inTimeController.text}");
  //   AppLogger.info("Out Time prefilled: ${_outTimeController.text}");
  //
  //   _isFirstLoad = false; // Set flag to false to prevent future overwriting
  // }

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
        title: Text(title),
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
              // CustomDropdownPage(
              //   label: "Select Project Item Type", // Label for the dropdown
              //   onChanged: (String? selectedName){
              //     setState(() {
              //       projectItem = selectedName;
              //
              //       // Optionally find selected ID from static projectItems if needed
              //       final matchedItem = projectItems.firstWhere(
              //             (e) => e['ProjectItemTypeName'] == selectedName,
              //         orElse: () => {},
              //       );
              //       projectItemId = matchedItem['ProjectItemTypeID'];
              //     });
              //
              //     AppLogger.info("Selected ProjectItem Name = $projectItem, ID = $projectItemId");
              //   },
              //   initialValue: projectItem, // Optionally, pass the initial value
              // ),

              // Text(_selectedProjectItemTypeName ?? "-- Select Project Item --"),
              // Text(projectItem ?? "-- Select Project Item --"),

              // ReusableDropdown(
              //   label: "Project Item",
              //   initialValue: initialProjectItemValue,
              //  // initialValue: projectItem ?? _selectedProjectItemTypeName,
              //   onChanged: (name, id) {
              //     AppLogger.debug("📍 Before update - Value in parent: $_selectedProjectItemTypeName, ID: $_selectedProjectItemTypeId");
              //     setState(() {
              //       _selectedProjectItemTypeName = name;
              //       _selectedProjectItemTypeId = id;
              //     });
              //     AppLogger.debug("📍 After update - Value in parent: $_selectedProjectItemTypeName, ID: $_selectedProjectItemTypeId");
              //   },
              // ),

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

              // Image.network(
              //     "http://192.168.1.28:1011/Files/ProfilePic/nopic.png"),
              // Image.network(
              //     "https://th.bing.com/th/id/OIP.U1DF6lM_O0pj_gN3dBpsCwHaFM?rs=1&pid=ImgDetMain"),

              // Image preview for IN_PICTURE URL
              // widget.attendance?.inPicture != null
              //     ? Image.network(widget.attendance!.inPicture!)
              //     : Container(),

              if (widget.attendance?.inPicture != null &&
                  widget.attendance!.inPicture!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the file path
                      Text(
                        "📁 inPicture File path: ${widget.attendance?.inPicture}",
                        style:
                            TextStyle(fontSize: 14, color: Colors.green[800]),
                      ),

                      // Display the image if valid URL
                      widget.attendance!.inPicture!.startsWith('http')
                          ? Image.network(
                              widget.attendance!.inPicture!,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text('Failed to load image');
                              },
                            )
                          : const Text('NO Image URL'),
                    ],
                  ),
                ),

              // Image preview for OUT_PICTURE URL
              // widget.attendance?.outPicture != null
              //     ? Image.network("http://192.168.1.17:1011/Files/ProfilePic/attendance.png")
              //     : Container(),

              if (widget.attendance?.outPicture != null &&
                  widget.attendance!.outPicture!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the file path
                      Text(
                        "📁 inPicture File path: ${widget.attendance?.outPicture}",
                        style:
                        TextStyle(fontSize: 14, color: Colors.green[800]),
                      ),

                      // Display the image if valid URL
                      widget.attendance!.outPicture!.startsWith('http')
                          ? Image.network(
                        widget.attendance!.outPicture!,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Failed to load image');
                        },
                      )
                          : const Text('NO Image URL'),
                    ],
                  ),
                ),

              // if (isImageUploaded != null)
              //   Padding(
              //     padding: EdgeInsets.all(1.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "📁 File path: $_capturedFilePath",
              //           style: TextStyle(fontSize: 14, color: Colors.green[800]),
              //         ),
              //         const SizedBox(height: 12),
              //         Container(
              //           height: 500,
              //           width: double.infinity,
              //           padding: EdgeInsets.all(1.0),
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(8),
              //             child: FutureBuilder<File>(
              //               future: _getImageFile(),
              //               builder: (context, snapshot) {
              //                 if (snapshot.connectionState ==
              //                     ConnectionState.waiting) {
              //                   return Center(child: CircularProgressIndicator());
              //                 } else if (snapshot.hasError) {
              //                   return Center(
              //                     child: Text(
              //                       'Error loading image',
              //                       style: TextStyle(color: Colors.red),
              //                     ),
              //                   );
              //                 } else if (snapshot.hasData && snapshot.data != null) {
              //                   return Image.file(
              //                     snapshot.data!,
              //                     width: double.infinity,
              //                     fit: BoxFit.cover,
              //                   );
              //                 } else {
              //                   return Center(
              //                     child: Image.asset(
              //                       'assets/images/defult_constro_img.png',
              //                       width: double.infinity,
              //                       fit: BoxFit.cover,
              //                     ),
              //                   );
              //                 }
              //               },
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      // onPressed: () async {
                      //   if (_formKey.currentState!.validate()) {
                      //
                      //     // Access the inTime and outTime from the Riverpod provider
                      //     final timeState = ref.read(timeProvider);
                      //     final inTime = timeState.inTime;
                      //     final outTime = timeState.outTime;
                      //
                      //
                      //     // Update the controllers (for example if saving them as strings)
                      //     if (inTime != null) {
                      //       _inTimeController.text = inTime.format(context);
                      //     }
                      //     if (outTime != null) {
                      //       _outTimeController.text = outTime.format(context);
                      //     }
                      //
                      //     // Declare latitude, longitude, and currentLocation before usage
                      //     final latitude = widget.latitude;  // Ensure it's assigned correctly
                      //     final longitude = widget.longitude; // Ensure it's assigned correctly
                      //     final currentLocation = widget.address; // Ensure it's assigned correctly
                      //
                      //
                      //     // Log the form data for debugging
                      //     AppLogger.info('Attendance saved successfully');
                      //     AppLogger.info("🆔 Labour ID       : ${widget.labourID}");
                      //     AppLogger.info("👷 Labour Name     : ${widget.attendance?.labourName ?? 'N/A'}");
                      //     AppLogger.info("🏢 Contractor Name : ${widget.attendance?.contractorName ?? 'N/A'}");
                      //     AppLogger.info("📂 Category        : ${widget.attendance?.labourCategory ?? 'N/A'}");
                      //     AppLogger.info("🔧 Activity        : ${_activityController.text}");
                      //     AppLogger.info("📝 Remarks         : ${_remarksController.text}");
                      //     AppLogger.info("🕒 In Time         : ${_inTimeController.text}");
                      //     AppLogger.info("🕔 Out Time        : ${_outTimeController.text}");
                      //     AppLogger.info("⏱️ Overtime        : ${_overtimeController.text}");
                      //     AppLogger.info("💰 OT Rate         : ${_overtimeRateController.text}");
                      //     AppLogger.info("📍 Latitude        : $latitude");
                      //     AppLogger.info("📍 Longitude       : $longitude");
                      //     AppLogger.info("📍 Address         : $currentLocation");
                      //
                      //
                      //
                      //
                      //     final totalHours = (widget.attendance?.overTime ?? 0).toDouble();
                      //     final overTime = (widget.attendance?.overTime ?? 0).toDouble();
                      //     final imagePath = _capturedFilePath;
                      //
                      //     if (widget.mode == FormMode.edit && widget.attendance != null) {
                      //
                      //       // 🔍 Log existing data before editing
                      //       AppLogger.info("✏️ Editing Existing Attendance Record");
                      //       AppLogger.info("🆔 Labour ID       : ${widget.labourID}");
                      //       AppLogger.info("👷 Labour Name     : ${widget.attendance!.labourName}");
                      //       AppLogger.info("🏢 Contractor Name : ${widget.attendance!.contractorName}");
                      //       AppLogger.info("📂 Category        : ${widget.attendance!.labourCategory}");
                      //       AppLogger.info("🔧 Activity        : ${_activityController.text}");
                      //       AppLogger.info("🕒 In Time         : ${_inTimeController.text}");
                      //       AppLogger.info("🕔 Out Time        : ${_outTimeController.text}");
                      //       AppLogger.info("⏱️ Overtime        : ${_overtimeController.text}");
                      //       AppLogger.info("💰 OT Rate         : ${_overtimeRateController.text}");
                      //       AppLogger.info("📍 Latitude        : $latitude");
                      //       AppLogger.info("📍 Longitude       : $longitude");
                      //       AppLogger.info("📍 Address         : $currentLocation");
                      //       AppLogger.info("📸 In Picture URL  : ${widget.attendance!.inPicture?.toString() ?? 'N/A'}");
                      //       AppLogger.info("📅 Attendance Date : ${widget.attendance!.date}");
                      //
                      //       // Prepare the imagePath, handle null or empty path
                      //       String? imagePath = _capturedFilePath;
                      //       if (imagePath == null || imagePath.isEmpty) {
                      //         AppLogger.warn("⚠️ No image captured for attendance. Using default image or null.");
                      //         imagePath = 'default_image_path'; // Fallback value if no image is captured
                      //       }
                      //
                      //
                      //     // Call the API to Add the existing data (edit mode)
                      //     await _editdata(
                      //     laborId:widget.labourID,
                      //     name: widget.attendance!.labourName,
                      //     company: widget.attendance!.contractorName,
                      //     category: widget.attendance!.labourCategory,
                      //     activityName: _activityController.text,
                      //     otHours: _overtimeController.text,
                      //     otRate: _overtimeRateController.text,
                      //     inTime: _inTimeController.text,
                      //     outTime: _outTimeController.text,
                      //     totalHours: totalHours,  // You may need to calculate or fetch this
                      //     overTime: overTime,   // Adjust accordingly
                      //       imagePath: imagePath ?? '', // Use fallback or null
                      //       // imagePath: _capturedFilePath ?? '',   // If there's a captured image, provide its path
                      //     fileName: 'attendance.png', // Set appropriate file name
                      //     latitude: latitude,  // Adjust with actual value
                      //     longitude: longitude,  // Adjust with actual value
                      //     currentLocation: currentLocation, // Adjust with actual location
                      //     );
                      //
                      //       // Log image file path if captured
                      //       if (imagePath != null && imagePath.isNotEmpty) {
                      //         AppLogger.info('Captured Image File Path: $imagePath');
                      //       }
                      //
                      //     // ✅ Log image file path (if captured)
                      //       if (_capturedFilePath == null || _capturedFilePath!.isEmpty) {
                      //         AppLogger.warn("⚠️ No image captured for attendance");
                      //       }
                      //
                      //
                      //       // ✅ Reset the provider state
                      //     ref.read(timeProvider.notifier).reset();
                      //
                      //     // ✅ Optionally clear time controllers too
                      //     _inTimeController.clear();
                      //     _outTimeController.clear();
                      //
                      //     } else {
                      //       AppLogger.info("🆕 SimpleAttendanceForm in ADD MODE FRO API CALL");
                      //
                      //       // // Prepare the necessary data for saving
                      //       // final totalHours = (widget.attendance!.overTime ?? 0).toDouble();
                      //       // final overTime = (widget.attendance!.overTime ?? 0).toDouble();
                      //
                      //       // Check latitude, longitude, and currentLocation for null, fallback if needed
                      //       final latitude = widget.latitude;
                      //       final longitude = widget.longitude;
                      //       final currentLocation = widget.address;
                      //
                      //
                      //
                      //       // Call the API to Add the existing data (edit mode)
                      //       await _saveData(
                      //         laborId:widget.labourID,
                      //       name: widget.attendance!.labourName,
                      //       company: widget.attendance!.contractorName,
                      //       category: widget.attendance!.labourCategory,
                      //       activityName: _activityController.text,
                      //       remark: _remarksController.text,
                      //       otHours: _overtimeController.text,
                      //       otRate: _overtimeRateController.text,
                      //       inTime: _inTimeController.text,
                      //       outTime: _outTimeController.text,
                      //         totalHours: totalHours,  // You may need to calculate or fetch this
                      //         overTime: overTime,   // Adjust accordingly
                      //         imagePath: _capturedFilePath ?? '',   // If there's a captured image, provide its path
                      //       fileName: 'attendance.png', // Set appropriate file name
                      //       latitude: latitude,  // Adjust with actual value
                      //       longitude: longitude,  // Adjust with actual value
                      //       currentLocation: currentLocation, // Adjust with actual location
                      //       );
                      //     }
                      //
                      //     // ✅ Log image file path (if captured)
                      //     if (_capturedFilePath != null) {
                      //       AppLogger.info('Captured Image File Path: $_capturedFilePath');
                      //     }
                      //
                      //     // ✅ Reset the provider state
                      //     ref.read(timeProvider.notifier).reset();
                      //
                      //     // ✅ Optionally clear time controllers too
                      //     _inTimeController.clear();
                      //     _outTimeController.clear();
                      //
                      //     // Navigate back after saving
                      //     Navigator.pop(context);
                      //   } else {
                      //     // Show error if form is invalid
                      //     CustomSnackbar.show(
                      //       isError: true,
                      //       context,
                      //       message: "Please fill all required fields.",
                      //     );
                      //   }
                      // },

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
                        AppLogger.info(
                            "📅 Attendance Date : ${widget.attendance!.date}");

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

                          await _editdata(
                            laborattedanceId: labourAttendanceId ?? 0,
                            laborId: labourId,
                            name: labourName,
                            company: contractorName,
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
                            fileName: 'attendance.png',
                            latitude: latitude,
                            longitude: longitude,
                            currentLocation: currentLocation,
                            remark: _remarksController.text,
                          );

                          // Log image file path if captured
                          // if (imagePath != null && imagePath.isNotEmpty) {
                          //   AppLogger.info('Captured Image File Path: $imagePath');
                          // }

                          // ✅ Log image file path (if captured)
                          if (_capturedFilePath == null ||
                              _capturedFilePath!.isEmpty) {
                            AppLogger.warn(
                                "⚠️ No image captured for attendance");
                          }

                          // ✅ Reset the provider state
                          ref.read(timeProvider.notifier).reset();

                          // ✅ Optionally clear time controllers too
                          _inTimeController.clear();
                          _outTimeController.clear();

                          // Navigate back after saving
                          Navigator.pop(context);
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
                                  ? 'attendance.png'
                                  : '';
                          imagePath ??= '';

                          await _saveData(
                            laborId: labourId,
                            name: labourName,
                            company: contractorName,
                            category: labourCategory,
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
                        //Navigator.pop(context);
                      },

                      // onPressed: () async {
                      //   // Check for In Time when adding a new attendance record
                      //   if (widget.mode == FormMode.add && _inTimeController.text.isEmpty) {
                      //     CustomSnackbar.show(
                      //       isError: true,
                      //       context,
                      //       message: "Please fill In Time. It is required.",
                      //     );
                      //     return;
                      //   }
                      //
                      //   // Check for Out Time when editing an attendance record
                      //   if (widget.mode == FormMode.edit && _outTimeController.text.isEmpty) {
                      //     CustomSnackbar.show(
                      //       isError: true,
                      //       context,
                      //       message: "Please fill Out Time. It is required for editing.",
                      //     );
                      //     return;
                      //   }
                      //
                      //   final latitude = widget.latitude;
                      //   final longitude = widget.longitude;
                      //   final currentLocation = widget.address;
                      //
                      //   double _parseWorkingHoursToDecimal(
                      //       String workingHoursText) {
                      //     try {
                      //       final regex = RegExp(r'(\d+)h\s+(\d+)m');
                      //       final match = regex.firstMatch(workingHoursText);
                      //
                      //       if (match != null) {
                      //         final hours = int.parse(match.group(1)!);
                      //         final minutes = int.parse(match.group(2)!);
                      //         return hours + (minutes / 60.0);
                      //       } else {
                      //         AppLogger.warn(
                      //             "Invalid working hours format: $workingHoursText");
                      //         return 0.0;
                      //       }
                      //     } catch (e) {
                      //       AppLogger.error(
                      //           "Failed to parse working hours: $e");
                      //       return 0.0;
                      //     }
                      //   }
                      //
                      //   final totalHours = (widget.attendance?.overTime ??
                      //       _parseWorkingHoursToDecimal(
                      //           _workingHoursController.text));
                      //
                      //   // final totalHours =
                      //   //     (widget.attendance?.overTime ?? 0).toDouble();
                      //   final overTime =
                      //       (widget.attendance?.overTime ?? 0).toDouble();
                      //
                      //   final labourAttendanceId =
                      //       widget.attendance?.labourAttendanceId;
                      //   final labourId = widget.labourID;
                      //   final labourName = widget.attendance?.labourName ?? '';
                      //   final contractorName =
                      //       widget.attendance?.contractorName ?? '';
                      //   final labourCategory =
                      //       widget.attendance?.labourCategory ?? '';
                      //
                      //   // Log the form data for debugging
                      //   AppLogger.info('Attendance saved successfully');
                      //   AppLogger.info(
                      //       "🆔 Labour ID       : ${widget.labourID}");
                      //   AppLogger.info(
                      //       "Labour Attedance ID     : ${widget.attendance?.labourAttendanceId ?? 'N/A'}");
                      //   AppLogger.info(
                      //       "👷 Labour Name     : ${widget.attendance?.labourName ?? 'N/A'}");
                      //   AppLogger.info(
                      //       "🏢 Contractor Name : ${widget.attendance?.contractorName ?? 'N/A'}");
                      //   AppLogger.info(
                      //       "📂 Category        : ${widget.attendance?.labourCategory ?? 'N/A'}");
                      //   AppLogger.info(
                      //       "🔧 Activity        : ${_activityController.text}");
                      //   AppLogger.info(
                      //       "📝 Remarks         : ${_remarksController.text}");
                      //   AppLogger.info(
                      //       "🕒 In Time         : ${_inTimeController.text}");
                      //   AppLogger.info(
                      //       "🕔 Out Time        : ${_outTimeController.text}");
                      //   AppLogger.info(
                      //       "🕔 Total hrs Time        : ${_workingHoursController.text}");
                      //   AppLogger.info(
                      //       "⏱️ Overtime        : ${_overtimeController.text}");
                      //   AppLogger.info(
                      //       "💰 OT Rate         : ${_overtimeRateController.text}");
                      //   AppLogger.info("📍 Latitude        : $latitude");
                      //   AppLogger.info("📍 Longitude       : $longitude");
                      //   AppLogger.info("📍 Address         : $currentLocation");
                      //   AppLogger.info(
                      //       "📸 In Picture URL  : ${widget.attendance!.inPicture?.toString() ?? 'N/A'}");
                      //   AppLogger.info(
                      //       "📅 Attendance Date : ${widget.attendance!.date}");
                      //
                      //   if (widget.mode == FormMode.edit &&
                      //       widget.attendance != null) {
                      //     AppLogger.info("Init mode: ${widget.mode}");
                      //     // 🔍 Log existing data before editing
                      //     AppLogger.info(
                      //         "✏️ Editing Existing Attendance Record");
                      //
                      //     // Prepare the imagePath, handle null or empty path
                      //     // String? imagePath = _capturedFilePath;
                      //     // if (imagePath == null || imagePath.isEmpty) {
                      //     //   AppLogger.warn("⚠️ No image captured for attendance. Using default image or null.");
                      //     //   imagePath = 'default_image_path'; // Fallback value if no image is captured
                      //     // }
                      //
                      //     // Log full data going into the API
                      //     AppLogger.info(
                      //         "📤 Calling _editdata API with the following details:");
                      //     AppLogger.info("🆔 Labour ID       : $labourId");
                      //     AppLogger.info("👷 Labour Name     : $labourName");
                      //     AppLogger.info(
                      //         "🏢 Contractor Name : $contractorName");
                      //     AppLogger.info(
                      //         "📂 Category        : $labourCategory");
                      //     AppLogger.info(
                      //         "🔧 Activity        : ${_activityController.text}");
                      //     AppLogger.info(
                      //         "📝 Remarks         : ${_remarksController.text}");
                      //     AppLogger.info(
                      //         "🕒 In Time         : ${_inTimeController.text}");
                      //     AppLogger.info(
                      //         "🕔 Out Time        : ${_outTimeController.text}");
                      //     AppLogger.info(
                      //         "🕐 Working Hours   : ${_workingHoursController.text}");
                      //     AppLogger.info(
                      //         "⏱️ Overtime        : ${_overtimeController.text}");
                      //     AppLogger.info(
                      //         "💰 OT Rate         : ${_overtimeRateController.text}");
                      //     AppLogger.info("📍 Latitude        : $latitude");
                      //     AppLogger.info("📍 Longitude       : $longitude");
                      //     AppLogger.info(
                      //         "📍 Address         : $currentLocation");
                      //
                      //     await _editdata(
                      //       laborattedanceId: labourAttendanceId ?? 0,
                      //       laborId: labourId,
                      //       name: labourName,
                      //       company: contractorName,
                      //       category: labourCategory,
                      //       projectItemTypeId: _selectedProjectItemTypeId,
                      //       activityName: _activityController.text,
                      //       otHours: _overtimeController.text,
                      //       otRate: _overtimeRateController.text,
                      //       inTime: _inTimeController.text,
                      //       outTime: _outTimeController.text,
                      //       totalHours: totalHours.toDouble(),
                      //       overTime: overTime,
                      //       // imagePath: imagePath ?? '', // Use fallback or null
                      //       imagePath: _capturedFilePath ?? '',
                      //       fileName: 'attendance.png',
                      //       latitude: latitude,
                      //       longitude: longitude,
                      //       currentLocation: currentLocation,
                      //       remark: _remarksController.text,
                      //     );
                      //
                      //     // Log image file path if captured
                      //     // if (imagePath != null && imagePath.isNotEmpty) {
                      //     //   AppLogger.info('Captured Image File Path: $imagePath');
                      //     // }
                      //
                      //     // ✅ Log image file path (if captured)
                      //     if (_capturedFilePath == null ||
                      //         _capturedFilePath!.isEmpty) {
                      //       AppLogger.warn(
                      //           "⚠️ No image captured for attendance");
                      //     }
                      //
                      //     // ✅ Reset the provider state
                      //     ref.read(timeProvider.notifier).reset();
                      //
                      //     // ✅ Optionally clear time controllers too
                      //     _inTimeController.clear();
                      //     _outTimeController.clear();
                      //   } else {
                      //     AppLogger.info(
                      //         "🆕 SimpleAttendanceForm in ADD MODE FRO API CALL");
                      //
                      //     // Check latitude, longitude, and currentLocation for null, fallback if needed
                      //     final latitude = widget.latitude;
                      //     final longitude = widget.longitude;
                      //     final currentLocation = widget.address;
                      //
                      //     // Log full data going into the API
                      //     AppLogger.info(
                      //         "📤 Calling _saveData API with the following details:");
                      //     AppLogger.info("🆔 Labour ID       : $labourId");
                      //     AppLogger.info("👷 Labour Name     : $labourName");
                      //     AppLogger.info(
                      //         "🏢 Contractor Name : $contractorName");
                      //     AppLogger.info(
                      //         "📂 Category        : $labourCategory");
                      //     AppLogger.info(
                      //         "🔧 Activity        : ${_activityController.text}");
                      //     AppLogger.info(
                      //         "📝 Remarks         : ${_remarksController.text}");
                      //     AppLogger.info(
                      //         "🕒 In Time         : ${_inTimeController.text}");
                      //     AppLogger.info(
                      //         "🕔 Out Time        : ${_outTimeController.text}");
                      //     AppLogger.info(
                      //         "⏱️ Overtime        : ${_overtimeController.text}");
                      //     AppLogger.info(
                      //         "💰 OT Rate         : ${_overtimeRateController.text}");
                      //     AppLogger.info("📍 Latitude        : $latitude");
                      //     AppLogger.info("📍 Longitude       : $longitude");
                      //     AppLogger.info(
                      //         "📍 Address         : $currentLocation");
                      //
                      //     String? imagePath = _capturedFilePath;
                      //     String fileName =
                      //         (imagePath != null && imagePath.isNotEmpty)
                      //             ? 'attendance.png'
                      //             : '';
                      //     imagePath ??= '';
                      //
                      //     await _saveData(
                      //       laborId: labourId,
                      //       name: labourName,
                      //       company: contractorName,
                      //       category: labourCategory,
                      //       projectItemTypeId: _selectedProjectItemTypeId,
                      //       activityName: _activityController.text,
                      //       remark: _remarksController.text,
                      //       otHours: _overtimeController.text,
                      //       otRate: _overtimeRateController.text,
                      //       inTime: _inTimeController.text,
                      //       outTime: _outTimeController.text,
                      //       totalHours: totalHours.toDouble(),
                      //       overTime: overTime,
                      //       imagePath: imagePath,
                      //       fileName: fileName,
                      //       latitude: latitude,
                      //       longitude: longitude,
                      //       currentLocation: currentLocation,
                      //     );
                      //   }
                      //
                      //   // Reset and finish
                      //   ref.read(timeProvider.notifier).reset();
                      //   _inTimeController.clear();
                      //   _outTimeController.clear();
                      //
                      //   if (_capturedFilePath != null) {
                      //     AppLogger.info('✅ Image Path: $_capturedFilePath');
                      //   }
                      //
                      //
                      // },

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
            DateFormat('dd/MM/yyyy').format(DateTime.now()),
            "Working Hrs.",
            _workingHoursText, // display the dynamic working hours here
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
                    _workingHoursText,
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
        ],
      ),
    );
  }

  // Widget _buildInfoRowTime(
  //   String title1,
  //   TimeOfDay? inTime,
  //   String title2,
  //   TimeOfDay? outTime,
  // ) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: 8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 TimePickerWidget(title: 'In Time', timeType: 'inTime'),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Container(
  //           width: 2,
  //           height: 30,
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               begin: Alignment.topCenter,
  //               end: Alignment.bottomCenter,
  //               colors: [
  //                 Color(0xffe5dcf3),
  //                 Color(0xff9b79d0),
  //                 Color(0xffe5dcf3),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: 8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 TimePickerWidget(title: 'Out Time', timeType: 'outTime'),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
      // onTap: () async {
      //   TimeOfDay? picked = await showTimePicker(
      //     context: context,
      //     initialTime: TimeOfDay.now(),
      //   );
      //   if (picked != null) {
      //     final formattedTime = picked.format(context);
      //     setState(() {
      //       _inTime = picked;
      //       _workingHoursText = _calculateTimeDifference();
      //
      //       controller.text = formattedTime;
      //       _workingHoursText =
      //           _calculateTimeDifference(); // update the working hours text dynamically
      //     });
      //   }
      // },
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
                    message: "❌ No image captured.",
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
                        "assets/icons/attendance/Upload-cam-svg.svg",
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
        if (_capturedFilePath != null)
          Padding(
            padding: EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "📁 File path: $_capturedFilePath",
                  style: TextStyle(fontSize: 14, color: Colors.green[800]),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 500,
                  width: double.infinity,
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FutureBuilder<File>(
                      future: _getImageFile(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading image',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return Image.file(
                            snapshot.data!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Center(
                            child: Image.asset(
                              'assets/images/defult_constro_img.png',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<File> _getImageFile() async {
    await Future.delayed(Duration(seconds: 2));
    return File(_capturedFilePath!);
  }

  Future<void> _saveData({
    required int laborId,
    required String name,
    required String company,
    required String category,
    required int? projectItemTypeId,
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
  }) async {
    try {
      // ✅ Convert image to base64 from path
      String base64Image = "";

      if (imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          base64Image = base64Encode(bytes);
          AppLogger.debug(
              "🖼️ Base64 Image (first 100 chars): ${base64Image.substring(0, 100)}...");
        } else {
          AppLogger.warn("⚠️ Image file does not exist at path: $imagePath");
        }
      } else {
        AppLogger.warn("⚠️ No image path provided. Skipping image encoding.");
      }

      AppLogger.info("📌 [START] Initiating labour attendance save process...");
      AppLogger.debug("🧾 Attendance Details:"
          "\n🔹 Labour ID: $laborId"
          "\n🔹 Name: $name"
          "\n🔹 Company: $company"
          "\n🔹 Category: $category"
          "\n🔹 Activity: $activityName"
          "\n🔹 Remark: $remark"
          "\n🔹 OT Hours: $otHours"
          "\n🔹 OT Rate: $otRate"
          "\n🔹 In Time: $inTime"
          "\n🔹 Out Time: $outTime"
          "\n🔹 Total Hours: $totalHours"
          "\n🔹 OverTime: $overTime"
          "\n🔹 FileName: $fileName"
          "\n🔹 Latitude: ${latitude ?? 'null'}"
          "\n🔹 Longitude: ${longitude ?? 'null'}"
          "\n🔹 Location: $currentLocation");

      String formatTimeToIso(String time) {
        try {
          final now = DateTime.now();
          final inputFormat = DateFormat('hh:mm a'); // 12-hour format
          final parsedTime = inputFormat.parse(time);

          final dateTime = DateTime(
            now.year,
            now.month,
            now.day,
            parsedTime.hour,
            parsedTime.minute,
          );

          // Format to "yyyy-MM-ddTHH:mm:ss"
          final outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
          return outputFormat.format(dateTime);
        } catch (e) {
          AppLogger.error("Invalid time format: $time. Error: $e");
          return '';
        }
      }

      // String formatTimeToIso(String time) {
      //   try {
      //     final now = DateTime.now();
      //     final inputFormat =
      //         DateFormat('hh:mm a'); // 12-hour format with AM/PM
      //     final dateTime = inputFormat.parse(time);
      //     final formatted = DateTime(
      //         now.year, now.month, now.day, dateTime.hour, dateTime.minute);
      //     return formatted.toIso8601String();
      //   } catch (e) {
      //     AppLogger.error("❌ Error in time format: $e");
      //     return DateTime.now().toIso8601String(); // Fallback to current time
      //   }
      // }

      final formattedInTime = formatTimeToIso(inTime); // 'inTime' like "08:30"
      final formattedOutTime = formatTimeToIso(outTime);

      final safeLatitude = latitude ?? 0.0;
      final safeLongitude = longitude ?? 0.0;

      AppLogger.info(
          "📤 [API CALL] Sending data to LabourAttendanceApiService.saveLabourAttendance()");

      final response = await LabourAttendanceApiService().saveLabourAttendance(
        labourID: laborId,
        status: "PRESENT",
        overTime: overTime,
        overTimeRate: otRate,
        inTime: formattedInTime,
        outTime: formattedOutTime,
        totalHours: totalHours,
        base64Image: base64Image,
        fileName: fileName,
        latitude: safeLatitude,
        longitude: safeLongitude,
        currentLocation: currentLocation,
        labourName: name,
        labourCategory: category,
        activityName: activityName,
        remark: remark,
        contractorName: company,
        projectItemTypeId: projectItemTypeId,
      );

      if (response != null && response['Status'] == 'Success') {
        AppLogger.info(
            "✅ [SUCCESS] Attendance saved successfully with ID: ${response['Data']}");

        // Trigger a re-fetch of the data
        // await _fetchLabourAttendanceData();

        // ✅ Refresh UI: You can pop the dialog/screen and pass a flag if needed
        // if (context.mounted) {
        //   _fetchLabourAttendanceData();
        //   Navigator.of(context).pop(true); // This can trigger refresh in parent using `then()`
        //  // Navigator.of(context).pop(true); // This can trigger refresh in parent using `then()`
        // }

        Navigator.pop(context); // Pops the current screen

        // Push the page again using the same route (LaborAttendanceAdd)
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.LaborAttendanceAdd,
        );


      } else {
        AppLogger.warn(
            "⚠️ [FAILURE] Attendance save failed. Response: ${response ?? 'null'}");
      }
    } catch (e, stackTrace) {
      AppLogger.error("❌ [EXCEPTION] Error while saving attendance: $e");
      AppLogger.debug("🪵 Stack Trace:\n$stackTrace");
      CustomSnackbar.show(
        isError: true,
        context,
        message: "An error occurred while saving the data.",
      );
    }
  }

  Future<void> _editdata({
    required int laborId,
    required int laborattedanceId,
    required String name,
    required String company,
    required String category,
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
  }) async {
    try {
      // ✅ Convert image to base64 from path
      // String? base64Image;
      // if (imagePath != null && imagePath.isNotEmpty) {
      //   final bytes = await File(imagePath).readAsBytes();
      //   base64Image = base64Encode(bytes);
      //   AppLogger.debug("🖼️ Base64 Image (first 100 chars): ${base64Image.substring(0, 100)}...");
      // } else {
      //   base64Image = '';  // Send empty base64 string when no image is available
      // }

      // ✅ Time formatters
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final apiTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

      // ✅ Parse inTime and outTime (supports both 24-hour & 12-hour format)
      DateTime parseTime(String timeStr) {
        try {
          if (timeStr.toLowerCase().contains('am') ||
              timeStr.toLowerCase().contains('pm')) {
            return DateFormat("hh:mm a").parse(timeStr);
          } else {
            return DateFormat("HH:mm").parse(timeStr);
          }
        } catch (e) {
          throw FormatException("Time format error: $timeStr");
        }
      }

      final parsedIn = parseTime(inTime.trim());
      final parsedOut = parseTime(outTime.trim());

      final fullInTime = DateTime(
          today.year, today.month, today.day, parsedIn.hour, parsedIn.minute);
      final fullOutTime = DateTime(
          today.year, today.month, today.day, parsedOut.hour, parsedOut.minute);

      final formattedInTime = apiTimeFormat.format(fullInTime);
      final formattedOutTime = apiTimeFormat.format(fullOutTime);
      final calculatedTotalHours = double.parse(
        (fullOutTime.difference(fullInTime).inMinutes / 60).toStringAsFixed(2),
      );

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
          "\n🔹 OverTime: $otHours"
          "\n🔹 FileName: $fileName"
          "\n🔹 Latitude: ${latitude ?? 'null'}"
          "\n🔹 Longitude: ${longitude ?? 'null'}"
          "\n🔹 Location: $currentLocation");

      AppLogger.info("📤 [API CALL] saveLabourAttendance Edit api calling");

      AppLogger.info("🆔 Labour ID       : $laborId");
      AppLogger.info("🆔 Labour AttedanceID       : $laborattedanceId");
      AppLogger.info("👷 Labour Name     : $name");
      AppLogger.info("🏢 Contractor Name : $company");
      AppLogger.info("📂 Category        : $category");
      AppLogger.info("🔧 Activity        : $activityName");
      AppLogger.info("🕒 In Time         : $formattedInTime");
      AppLogger.info("🕔 Out Time        : $formattedOutTime");
      AppLogger.info("⏱️ Overtime        : $otHours");
      AppLogger.info("💰 OT Rate         : $otRate");
      AppLogger.info("📍 Latitude        : $latitude");
      AppLogger.info("📍 Longitude       : $longitude");
      // // ✅ Calculate total hours (difference between inTime and outTime)
      // final totalHours = fullOutTime.difference(fullInTime).inMinutes / 60;

      // Log totalHours before API call
      AppLogger.info("⏱️ Calculated Total Hours: $calculatedTotalHours");

      // ✅ Log and prepare image file path and file name
      AppLogger.info(
          "🖼️ Image Path       : ${imagePath ?? 'No image provided'}");
      AppLogger.info("📁 Image File Name  : $fileName");

      String base64Image = '';
      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        final bytes = await file.readAsBytes();
        base64Image = base64Encode(bytes);
        AppLogger.debug(
            "🖼️ Base64 Image editing (first 100 chars): ${base64Image.substring}...");
      } else {
        AppLogger.warn("⚠️ No image provided. Proceeding without image.");
      }

// ✅ Log full request payload before API call
      final payload = {
        "labourAttendanceID": laborattedanceId,
        "labourID": laborId,
        "status": "PRESENT",
        "overtime": otHours,
        "overtimeRate": otRate,
        "inTime": formattedInTime,
        "outTime": formattedOutTime,
        "totalHours": calculatedTotalHours,
        "contractorID": widget.attendance?.contractorId ?? 0,
        "fileName": fileName,
        "base64Image": base64Image.isNotEmpty
            ? base64Image.substring(0, 50) + "..."
            : "No image",
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
        "projectItemTypeId": projectItemTypeId,
      };
      AppLogger.debug("📦 [Payload to editLabourAttendance]:\n$payload");

      final response = await LabourAttendanceApiService().editLabourAttendance(
        labourAttendanceID: laborattedanceId,
        labourID: laborId,
        status: "PRESENT",
        overtime: otHours,
        //overtimeRate: double.parse(otRate),
        // overtimeRate: double.tryParse(otRate) ?? 0.0,
        overtimeRate: otRate,
        inTime: formattedInTime,
        outTime: formattedOutTime,
        //totalHours: totalHours,
        totalHours: calculatedTotalHours,
        //companyCode: company,
        contractorID: widget.attendance?.contractorId ?? 0,
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
      );

      if (response != null && response['Status'] == 'Success') {
        AppLogger.info(
            "✅ [SUCCESS] Attendance saved successfully with ID: ${response['Data']}");
      } else {
        AppLogger.warn(
            "⚠️ Attendance edit failed. Response: ${response ?? 'null'}");
      }
    } catch (e, stackTrace) {
      AppLogger.error("❌ [EXCEPTION]Exception during edit: $e");
      AppLogger.debug("🪵 Stack Trace:\n$stackTrace");
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
