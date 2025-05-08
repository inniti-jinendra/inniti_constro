// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:inniti_constro/features/MenuScreen/pages/labour_attendance_old/widget/reusable_btn_widget.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/models/LabourAttendance/LabourAttendance.dart';
// import '../../../../../core/network/logger.dart';
// import '../../../../../core/services/LabourAttendance/labour_attendance_api_service.dart';
// import '../../../../../widgets/CustomToast/custom_snackbar.dart';
// import '../../../../../widgets/custom_dialog/custom_confirmation_dialog.dart';
// import '../../../../../widgets/custom_dialog/custom_dialog.dart';
// import '../../../../../widgets/dropdown/custom_dropdown.dart';
// import '../../../../../widgets/global_loding/global_loader.dart';
// import '../../../../../widgets/helper/camera_helper_service.dart';
// import '../../../../../widgets/helper/location_helper_service.dart';
// import 'AttendanceDetailsScreen.dart';
// import '../../labour_attedance_new/TimeDisplay.dart';
// import '../../../../../widgets/dropdown/dropdowen_project_iteams.dart';
//
// class LabourCard extends StatefulWidget {
//   final String id;
//   final String name;
//   final String company;
//   final String attendance_only;
//   final String labourCategory;
//   final int labourID;
//   final int labourAttendanceID;
//   final VoidCallback? onTap;
//   final String selectedDate;
//
//   const LabourCard({
//     super.key,
//     required this.id,
//     required this.name,
//     required this.company,
//     required this.attendance_only,
//     required this.labourCategory,
//     required this.labourID,
//     required this.labourAttendanceID,
//     required this.selectedDate,
//     this.onTap,
//   });
//
//   @override
//   State<LabourCard> createState() => _LabourCardState();
// }
//
// class _LabourCardState extends State<LabourCard> {
//   String? _capturedFilePath;
//   bool isImageUploaded = false;
//
//   //late bool _isActive;
//   TimeOfDay? inTime;
//   TimeOfDay? outTime;
//
//   // Method to calculate the difference between In and Out Time
//   String _calculateTimeDifference(TimeOfDay? inTime, TimeOfDay? outTime) {
//     if (inTime == null || outTime == null) {
//       return '--:--';
//     }
//
//     DateTime inDateTime = DateTime(2025, 1, 1, inTime.hour, inTime.minute);
//     DateTime outDateTime = DateTime(2025, 1, 1, outTime.hour, outTime.minute);
//
//     if (outDateTime.isBefore(inDateTime)) {
//       outDateTime = outDateTime.add(
//         Duration(days: 1),
//       ); // Adjust for overnight shifts
//     }
//
//     Duration difference = outDateTime.difference(inDateTime);
//     int hours = difference.inHours;
//     int minutes = difference.inMinutes % 60;
//
//     return '$hours hr(s) $minutes min(s)';
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     //_isActive = widget.status;
//     // Initialize default values for inTime and outTime
//     // inTime ??= TimeOfDay(hour: 3, minute: 0);  // Default In-Time to 9:00 AM
//     // outTime ??= TimeOfDay(hour: 17, minute: 0); // Default Out-Time to 5:00 PM
//
//   }
//
//
//   Future<String> _encodeImageToBase64(String filePath) async {
//     final file = File(filePath);
//     if (!await file.exists()) {
//       AppLogger.warn("⚠️ Image file does not exist at: $filePath");
//       return "";
//     }
//     final bytes = await file.readAsBytes();
//     return base64Encode(bytes);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       // onLongPress: () {
//       //   // Navigate to the AttendanceDetailsScreen
//       //   Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //       builder: (context) => AttendanceDetailsScreen(
//       //         labourID: 'L123',
//       //         name: 'John Doe',
//       //         labourCategory: 'Electrician',
//       //         company: 'XYZ Ltd.',
//       //       ),
//       //     ),
//       //   );
//       // },
//       onTap: () async {
//         try {
//           AppLogger.info("📝 Tapped card for LabourID: ${widget.labourID}");
//           AppLogger.info("📝 Tapped card for Compny: ${widget.company}");
//           AppLogger.info(
//             "📝 Tapped card for LabourAttendanceID: ${widget.labourAttendanceID}",
//           );
//
//           if (widget.labourAttendanceID == 0) {
//             // ADD MODE
//             AppLogger.info("➕ Add mode detected (LabourAttendanceID == 0)");
//             AppLogger.info(" Date => ${widget.selectedDate}");
//
//             final recordMap = await LabourAttendanceApiService()
//                 .fetchLabourAttendanceadd(labourID: widget.labourID);
//
//             if (recordMap != null && context.mounted) {
//               final editableRecord = LabourAttendance.fromJson(recordMap);
//
//               AppLogger.info(
//                 "📝 Showing for ADD data : ${editableRecord.LabourAttendanceID}",
//               );
//
//               //_getLocationAndShowDialog(); // Open dialog for editing with location
//               _getLocationAndShowDialog(actionButtonText: "Save");
//             } else {
//               AppLogger.warn("⚠️ Record not found or context not mounted.");
//             }
//           } else {
//             // EDIT MODE
//             AppLogger.info("✏️ Edit mode detected (Fetching existing record)");
//
//             final recordMapEdit = await LabourAttendanceApiService()
//                 .GetLabourAttendanceeditDetails(
//                   //date: DateTime.now().toIso8601String().split('T').first, // Format: yyyy-MM-dd
//                   date: widget.selectedDate, // Format: yyyy-MM-dd
//                   labourAttendanceID: widget.labourAttendanceID,
//                 );
//
//             // Log the raw response
//             AppLogger.info("Raw response: $recordMapEdit");
//
//             if (recordMapEdit != null && context.mounted) {
//               final editableRecord = LabourAttendance.fromJson(recordMapEdit);
//
//
//               // Show edit dialog
//              // _getLocationAndShowDialog(actionButtonText: "Edit");
//             } else {
//               AppLogger.warn("⚠️ Record not found or context not mounted.");
//             }
//
//
//             if (recordMapEdit != null && context.mounted) {
//               final editableRecord = LabourAttendanceedit.fromJson(recordMapEdit);
//
//               // Log the parsed data
//               AppLogger.info("Parsed Labour Attendance ID: ${editableRecord.LabourAttendanceID}");
//               AppLogger.info("📝 Showing edit dialog for: ${editableRecord.LabourAttendanceID}");
//
//               // Log each key field (parsed nicely)
//               AppLogger.info("🧾 Parsed LabourAttendance:");
//               AppLogger.info("  ➤ ID: ${editableRecord.LabourAttendanceID}");
//               AppLogger.info("  ➤ Labour Name: ${editableRecord.labourName}");
//               AppLogger.info("  ➤ Contractor Name: ${editableRecord.contractorName}");
//               AppLogger.info("  ➤ In Time: ${editableRecord.inTime}");
//               AppLogger.info("  ➤ Out Time: ${editableRecord.outTime}");
//               AppLogger.info("  ➤ Total Hours: ${editableRecord.totalHrs}");
//               AppLogger.info("  ➤ In Picture: ${editableRecord.inDocumentPath}");
//               AppLogger.info("  ➤ Out Picture: ${editableRecord.outDocumentPath}");
//               AppLogger.info("  ➤ Remarks: ${editableRecord.remark}");
//
//               //Optional: Log full object as JSON
//               AppLogger.info("📦 Full Parsed JSON: ${jsonEncode(editableRecord.toJson())}");
//
//
//               // _getLocationAndShowDialog(); // Open dialog for editing with location
//               _getLocationAndShowDialog(actionButtonText: "Edit");
//             } else {
//               AppLogger.warn("⚠️ Record not found or context not mounted.");
//             }
//
//             // _getLocationAndShowDialog(); // Just open dialog with location for adding new
//           }
//         } catch (e, stackTrace) {
//           AppLogger.error(
//             "❌ Failed to fetch or parse attendance_only: $e\n$stackTrace",
//           );
//         }
//       },
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
//         child: Container(
//           height: 84,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 // Shadow color with opacity
//                 blurRadius: 10,
//                 // Increased blur radius for a softer shadow
//                 spreadRadius: 2,
//                 // Spread radius to make the shadow extend outward
//                 offset: const Offset(0, 4), // Vertical shadow offset
//               ),
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.03),
//                 // Lighter secondary shadow
//                 blurRadius: 2,
//                 // Subtle blur radius for a softer secondary effect
//                 offset: const Offset(
//                   0,
//                   1,
//                 ), // Small offset to make it more dynamic
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 16, left: 18),
//                       child: Text(
//                         widget.company,
//                         style: GoogleFonts.nunitoSans(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.primaryBlackFont,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                         softWrap: false,
//                       ),
//                     ),
//                   ),
//
//                   Row(
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.all(10.0),
//                         height: 20,
//                         width: 50,
//                         decoration: BoxDecoration(
//                           color: AppColors.cardgreenlight,
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         child: Center(
//                           child: Text(
//                             // widget.status.toString(),
//                             widget.attendance_only,
//                             style: GoogleFonts.nunitoSans(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff07614A),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 38,
//                         width: 38,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryWhitebg,
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(12),
//                             bottomLeft: Radius.circular(12),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 4,
//                               spreadRadius: 1,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           widget.id,
//                           style: GoogleFonts.nunitoSans(
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primaryBlueFont,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 10,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         SvgPicture.asset(
//                           'assets/icons/user-icon.svg',
//                           height: 16,
//                           width: 16,
//                           colorFilter: const ColorFilter.mode(
//                             AppColors.primaryBlue,
//                             BlendMode.srcIn,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           widget.name,
//                           style: GoogleFonts.nunitoSans(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.primaryBlackFont,
//                             // _isActive
//                             //     ? AppColors.primaryBlackFont
//                             //     : Colors.grey,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Text(
//                             widget.labourCategory,
//                             style: GoogleFonts.nunitoSans(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.primaryBlackFont,
//                               // _isActive
//                               //     ? AppColors.primaryBlueFont
//                               //     : Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showDetailsDialog(
//     BuildContext context, {
//
//     required String name,
//     required int laborId,
//     required String Category,
//     required String company,
//     required String actionButtonText,
//     double? latitude,
//     double? longitude,
//     String? currentLocation,
//         TimeOfDay? inTime,
//         TimeOfDay? outTime,
//
//
//   }) {
//     final _formKey = GlobalKey<FormState>();
//
//
//     String? selectedActivity;
//     String? selectedProjectItemType;
//     String? remarks;
//     bool isImageUploaded = false;
//     String? _capturedFilePath = "/dummy/path/to/image.jpg"; // Static dummy path
//
//     TextEditingController activityController = TextEditingController();
//     TextEditingController remarksController = TextEditingController();
//     TextEditingController otHoursController = TextEditingController(text: "01");
//     TextEditingController otRateController = TextEditingController(text: "03");
//
//
//     // 💡 Define formatter first
//     String formatToIsoString(DateTime date, TimeOfDay time) {
//       final fullDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
//       return fullDateTime.toIso8601String().split('.').first; // Removes milliseconds
//     }
//
//     // ✅ Safely assign final values with defaults
//     final TimeOfDay finalInTime = inTime ?? TimeOfDay(hour: 10, minute: 0);
//     final TimeOfDay finalOutTime = outTime ?? TimeOfDay(hour: 19, minute: 0);
//
//     // ⏳ Format into ISO strings
//     String formattedInTime = formatToIsoString(DateTime.now(), finalInTime);
//     String formattedOutTime = formatToIsoString(DateTime.now(), finalOutTime);
//
//     Future<void> _saveData({
//       required String name,
//       required String company,
//       required String category,
//       required String activityName,
//       required String otHours,
//       required String otRate,
//       required String inTime,
//       required String outTime,
//       required double totalHours,
//       required double overTime,
//       required String base64Image,
//       required String fileName,
//       double? latitude,
//       double? longitude,
//       String? currentLocation,
//     }) async {
//       AppLogger.info("💾 [Save Data] Starting save process...");
//
//       // 📌 Logging all parameters for better visibility
//       AppLogger.info("📤 [Data Being Sent]");
//       AppLogger.info("👷 Labour Name       : $name");
//       AppLogger.info("🆔 Labour ID       : $laborId");
//       AppLogger.info("🏢 Company           : $company");
//       AppLogger.info("📂 Category          : $category");
//       AppLogger.info("🛠 Activity Name     : $activityName");
//       AppLogger.info("⏱ OT Hours          : $otHours");
//       AppLogger.info("💲 OT Rate           : $otRate");
//       AppLogger.info("🕒 In Time           : $formattedInTime");
//       AppLogger.info("🕓 Out Time          : $formattedOutTime");
//       AppLogger.info("🕰 Total Hours       : $totalHours");
//       AppLogger.info("⏳ OverTime          : $overTime");
//       AppLogger.info("🖼 File Name         : $fileName");
//       AppLogger.info("🧾 Base64Image Length: ${base64Image.length}");
//       AppLogger.info("📍 Latitude          : ${latitude ?? 'Not provided'}");
//       AppLogger.info("📍 Longitude         : ${longitude ?? 'Not provided'}");
//       AppLogger.info("📌 Location Address  : ${currentLocation ?? 'Not provided'}");
//
//       // // Call the actual API to save the data
//       // final response = await LabourAttendanceApiService().saveLabourAttendance(
//       //   labourID: laborId,  // Replace with the actual Labour ID
//       //   plantID: 1,   // Replace with the actual Plant ID
//       //   status: "PRESENT",  // Or any other status
//       //   overTime: overTime,
//       //   inTime: formattedInTime,
//       //   outTime: formattedOutTime,
//       //   totalHours: totalHours,
//       //   base64Image: base64Image,
//       //   fileName: fileName,
//       //   // latitude: latitude,
//       //   // longitude: longitude,
//       //   currentLocation: currentLocation,
//       //   companyCode: company,
//       // );
//
//       // // Handle the response
//       // if (response != null && response['Status'] == "Success") {
//       //   AppLogger.info("✅ Attendance saved successfully.");
//       //   CustomSnackbar.show(context, message: "Attendance saved successfully!");
//       //   Navigator.pop(context);
//       // } else {
//       //   AppLogger.error("❌ Failed to save attendance_only.");
//       //   CustomSnackbar.show(context, message: "Failed to save attendance_only.");
//       // }
//     }
//
//     Future<void> _validateAndSave() async {
//       AppLogger.info("🔍 [Validation] Starting validation process...");
//
//
//       // Form validation
//       if (!_formKey.currentState!.validate()) {
//         AppLogger.warn("⚠️ [Validation] Failed: Some fields have errors.");
//         CustomSnackbar.show(context, message: "Please correct the errors.");
//         return;
//       }
//
//       // Image validation
//       if (!isImageUploaded) {
//         AppLogger.warn("⚠️ [Validation] Image upload missing.");
//         CustomSnackbar.show(context, message: "Please upload an image.");
//         return;
//       }
//
//       // Convert TimeOfDay to String
//       String _formatTimeOfDay(TimeOfDay time) {
//         final hour = time.hour.toString().padLeft(2, '0');
//         final minute = time.minute.toString().padLeft(2, '0');
//         return "$hour:$minute";
//       }
//
//       // Calculate total hours (this is just an example, you might need to adjust based on your logic)
//       double _calculateHours(TimeOfDay? inTime, TimeOfDay? outTime) {
//         if (inTime == null || outTime == null) return 0.0;
//         final inTimeInMinutes = inTime.hour * 60 + inTime.minute;
//         final outTimeInMinutes = outTime.hour * 60 + outTime.minute;
//         return (outTimeInMinutes - inTimeInMinutes) / 60.0;
//       }
//
//       // Logging form values for debugging
//       AppLogger.info("📋 [Form Data] Submitting Attendance Form...");
//       AppLogger.info("👷 Labour Name     : $name");
//       AppLogger.info("🆔 Labour ID       : $laborId");
//       AppLogger.info("🏢 Company         : $company");
//       AppLogger.info("🏷️ Labour Category : $Category");
//       AppLogger.info("🛠 Activity Name   : ${activityController.text}");
//       AppLogger.info("🛠 Ot HRS          : ${otHoursController.text}");
//       AppLogger.info("🛠 Ot Rate         : ${otRateController.text}");
//       AppLogger.info("🕰️ In-Time: ${inTime?.format(context) ?? "Not set"}");
//       AppLogger.info("⏳ Out-Time: ${outTime?.format(context) ?? "Not set"}");
//
//       AppLogger.info(
//         "📸 Image Uploaded: ${isImageUploaded ? "✅ Yes" : "❌ No"}\n"
//             "📁 File Path: ${_capturedFilePath ?? "No file selected"}",
//       );
//
//       // Calculate and log time difference
//       String timeDifference = _calculateTimeDifference(inTime, outTime);
//       AppLogger.info("⏱️ Working Duration: $timeDifference");
//
//       // Location details (if available)
//       if (latitude != null && longitude != null) {
//         AppLogger.info("📍 Coordinates     : Lat: $latitude, Long: $longitude");
//       } else {
//         AppLogger.warn("⚠️ [Location] Coordinates missing.");
//       }
//
//       if (currentLocation != null) {
//         AppLogger.info("📌 Address         : $currentLocation");
//       }
//
//       // Final confirmation and save
//       AppLogger.debug("✅ [Validation] Successful. Proceeding to save form data...");
//       _formKey.currentState!.save();
//
//       // Format TimeOfDay to string for saving
//       String inTimeStr = inTime != null ? _formatTimeOfDay(inTime) : "00:00";
//       String outTimeStr = outTime != null ? _formatTimeOfDay(outTime) : "00:00";
//
// // Calculate total hours and overtime
//       double totalHours = _calculateHours(inTime, outTime);
//       double overTime = double.tryParse(otHoursController.text.trim()) ?? 0.0;
//
// // Base64 image and file name
//       String base64Image = await _encodeImageToBase64(_capturedFilePath!);
//       String fileName = _capturedFilePath?.split("/").last ?? "dummy_image.jpg";
//
//       if (actionButtonText == "Save") {
//         AppLogger.info("💾 Action: Save new attendance_only record");
//         //_saveData(); // Your actual save function
//
//         // Pass all data to the save function
//         await _saveData(
//           name: name,
//           company: company,
//           category: Category,
//           activityName: activityController.text,
//           otHours: otHoursController.text,
//           otRate: otRateController.text,
//           inTime: inTimeStr,
//           outTime: outTimeStr,
//           totalHours: totalHours,
//           overTime: overTime,
//           base64Image: base64Image,
//           fileName: fileName,
//           latitude: latitude,
//           longitude: longitude,
//           currentLocation: currentLocation,
//         );
//
//
//
//       } else if
//       (actionButtonText == "Edit") {
//         // Log action of editing
//         AppLogger.info("✏️ Action: Edit existing attendance_only record");
//
//         // Log action of editing
//         AppLogger.info("✏️ Action: Edit existing attendance_only record");
//
//         // Log all current data before editing
//         AppLogger.info("📋 [Form Data] Editing Attendance Record...");
//         AppLogger.info("👷 Labour Name     : $name");
//         AppLogger.info("🆔 Labour ID       : ${laborId != null ? laborId : 'Not Available'}");  // Handle potential null
//         AppLogger.info("🏢 Company         : $company");
//         AppLogger.info("🏷️ Labour Category : $Category");
//
//         // Activity and overtime data
//         AppLogger.info("🛠 Activity Name   : ${activityController.text.isNotEmpty ? activityController.text : 'No Activity'}");
//         AppLogger.info("🛠 Ot HRS          : ${otHoursController.text.isNotEmpty ? otHoursController.text : '0'}");
//         AppLogger.info("🛠 Ot Rate         : ${otRateController.text.isNotEmpty ? otRateController.text : '0'}");
//
//         // Time-related data (In-Time, Out-Time, Total Hours, OverTime)
//         AppLogger.info("🕰️ In-Time         : ${inTimeStr ?? '--:--'}");  // Check if inTimeStr is null or not
//         AppLogger.info("⏳ Out-Time        : ${outTimeStr ?? '--:--'}");  // Check if outTimeStr is null or not
//         AppLogger.info("⏱️ Total Hours     : ${totalHours ?? '--:--'}");  // Ensure that totalHours is not null
//         AppLogger.info("⏱️ OverTime        : ${overTime ?? '--:--'}");  // Handle missing overtime data
//
// // Image upload data
//         AppLogger.info(
//           "📸 Image Uploaded: ${isImageUploaded ? "✅ Yes" : "❌ No"}\n"
//               "📁 File Path: ${_capturedFilePath ?? "No file selected"}",
//         );
//
//         // Location data (coordinates and address)
//         if (latitude != null && longitude != null) {
//           AppLogger.info("📍 Coordinates     : Lat: $latitude, Long: $longitude");
//         } else {
//           AppLogger.warn("⚠️ [Location] Coordinates missing.");
//         }
//
//         if (currentLocation != null) {
//           AppLogger.info("📌 Address         : $currentLocation");
//         } else {
//           AppLogger.warn("⚠️ [Location] Address missing.");
//         }
//
//
//
//
//         AppLogger.debug("✅ [Validation] Successful. Proceeding to edit data...");
//
//         // await LabourAttendanceApiService().editLabourAttendance(
//         //   labourAttendanceID: labourAttendanceID,
//         //   labourID: labourID,
//         //   status: status,
//         //   overtime: overtime,
//         //   overtimeRate: overtimeRate,
//         //   inTime: inTimeStr,
//         //   outTime: outTimeStr,
//         //   totalHours: totalHours,
//         //   companyCode: companyCode,
//         //   contractorID: contractorID,
//         //   fileName: fileName,
//         //   base64Image: base64Image,
//         // );
//
//       } else {
//         AppLogger.warn("⚠️ Unknown action: $actionButtonText");
//         CustomSnackbar.show(
//           context,
//           message: "Invalid action type. Please try again.",
//         );
//       }
//
//       Navigator.pop(context);
//       AppLogger.info("🔚 [Form Submission] Complete. Navigated back.");
//     }
//
//
//
//
//     CustomDialog.show(
//       context,
//       title: "Labour Attendance Details",
//       formFields: [
//         Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildHeader(name, Category, company),
//               _buildHeaderLocation(latitude, longitude, currentLocation),
//               _buildTextField(
//                 label: "Activity Name",
//                 controller: activityController,
//                 maxLines: 1,
//                 onSave: (value) {
//                   selectedActivity = value;
//                 },
//               ),
//
//               CustomDropdownPage(
//                 label: "Select Project Item Type", // Label for the dropdown
//                 onChanged: (selectedItem) {
//                   if (selectedItem != null) {
//                     // Print the selected item and its ID in the console
//                     print("Selected Item: ${selectedItem.toString()}");
//                   }
//                 },
//                 initialValue:
//                     null, // You can set a default value here if needed
//               ),
//
//               _buildTextField(
//                 label: "Remarks",
//                 controller: remarksController,
//                 maxLines: 3,
//                 onSave: (value) {
//                   remarks = value;
//                 },
//               ),
//               _buildUploadButton(() {
//                 setState(() {
//                   isImageUploaded = true; // 🔄 Wrap with setState
//                 });
//               }),
//             ],
//           ),
//         ),
//       ],
//       saveButtonText: actionButtonText,
//       onSave: _validateAndSave,
//       onClose: () {
//         Navigator.pop(context);
//       },
//     );
//   }
//
//   Widget _buildTextField({
//     required String label,
//     required Function(String?) onSave,
//     TextEditingController? controller,
//     int maxLines = 1,
//   }) {
//     final TextEditingController _internalController =
//         controller ?? TextEditingController();
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: _internalController,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: AppColors.primaryWhitebg,
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         validator: (value) {
//           if (value == null || value.trim().isEmpty) {
//             return "$label is required";
//           }
//           return null;
//         },
//         onChanged: (value) {
//           AppLogger.info("✏️ $label changed: $value");
//         },
//         onSaved: (value) {
//           AppLogger.info("💾 $label saved: $value");
//           onSave(value);
//         },
//       ),
//     );
//   }
//
//   Widget buildDropdown({
//     required String label,
//     required Future<List<String>>
//     itemsFuture, // Changed to Future<List<String>>
//     required Function(String?) onChanged,
//     String? initialValue,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 5),
//           FutureBuilder<List<String>>(
//             future: itemsFuture, // Fetch the data from API
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 ); // Show loading indicator
//               } else if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return Text('No items available');
//               } else {
//                 List<String> items = snapshot.data!; // Data is available
//
//                 // Ensure initialValue is valid
//                 String validInitialValue =
//                     items.contains(initialValue) ? initialValue! : items.first;
//
//                 return FormField<String>(
//                   validator: (value) {
//                     if (value == null || value == "-- Select Items --") {
//                       return "Please select $label";
//                     }
//                     return null;
//                   },
//                   builder: (FormFieldState<String> state) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         DropdownButton<String>(
//                           value: validInitialValue,
//                           onChanged: (value) {
//                             onChanged(value);
//                             state.didChange(value);
//                             print(
//                               "Selected $label: $value",
//                             ); // Log the selected item
//                           },
//                           items:
//                               items.map<DropdownMenuItem<String>>((
//                                 String value,
//                               ) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Text(value),
//                                 );
//                               }).toList(),
//                         ),
//                         if (state.hasError)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 5),
//                             child: Text(
//                               state.errorText!,
//                               style: TextStyle(color: Colors.red, fontSize: 12),
//                             ),
//                           ),
//                       ],
//                     );
//                   },
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 🔽 Updated Upload Button with Validation
//   Widget _buildUploadButton(VoidCallback onUploadSuccess) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: InkWell(
//             onTap: () async {
//               try {
//                 // Open camera and get the image file
//                 final File? imageFile =
//                     await CameraHelperForLaborAttedance.openCamera(context);
//
//                 if (imageFile != null) {
//                   setState(() {
//                     _capturedFilePath =
//                         imageFile.path; // Save the file path in the state
//                   });
//
//                   // Image uploaded successfully, trigger the onUploadSuccess callback
//                   onUploadSuccess();
//                   AppLogger.info("📸 Captured image path: $_capturedFilePath");
//
//                   // Optionally, show a success message
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   SnackBar(content: Text('Image captured successfully!')),
//                   // );
//                   CustomSnackbar.show(
//                     isError: false,
//                     context,
//                     message: "Image captured successfully!",
//                   );
//                 } else {
//                   // Image not captured, show a warning message
//                   AppLogger.warn("❌ No image captured.");
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   SnackBar(
//                   //     content: Text('No image captured, please try again.'),
//                   //   ),
//                   // );
//                   CustomSnackbar.show(
//                     context,
//                     message: "❌ No image captured.",
//                     isError: true,
//                   );
//                 }
//               } catch (e) {
//                 // Handle any errors (e.g., camera permission issues)
//                 AppLogger.error("Error capturing image: $e");
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Error capturing image. Please try again.'),
//                   ),
//                 );
//               }
//             },
//             child: Container(
//               height: 70,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryWhitebg,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Color(0xffE6E0EF),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: SvgPicture.asset(
//                         "assets/icons/attendance_only/Upload-cam-svg.svg",
//                         height: 24,
//                         width: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       "Upload Image",
//                       style: GoogleFonts.nunitoSans(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.primaryBlackFont,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         // UploadButton(
//         //   onUploadSuccess: () {
//         //     // Handle success logic here
//         //     AppLogger.info("Image upload successful!");  // Log the success message
//         //   },
//         // ),
//
//         // If an image has been captured, display it along with its file path
//         if (_capturedFilePath != null)
//           Padding(
//             padding: EdgeInsets.all(1.0),
//             // More generous padding for better spacing
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Display the file path with better styling
//                 Text(
//                   "📁 File path: $_capturedFilePath",
//                   style: TextStyle(fontSize: 14, color: Colors.green[800]),
//                 ),
//                 const SizedBox(height: 12),
//                 // Slightly larger space between text and image
//                 // Container holding the image
//                 Container(
//                   height: 500,
//                   width: double.infinity,
//                   padding: EdgeInsets.all(1.0),
//                   // Padding around the image
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryWhitebg,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     // Matching border radius for smooth edges
//                     child: FutureBuilder<File>(
//                       future: _getImageFile(),
//                       // Custom method to return the file, if needed
//                       builder: (context, snapshot) {
//                         // Check if the file is still being loaded
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(
//                             child:
//                                 CircularProgressIndicator(), // Loading spinner while waiting
//                           );
//                         } else if (snapshot.hasError) {
//                           return Center(
//                             child: Text(
//                               'Error loading image',
//                               // Error handling if the image cannot be loaded
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           );
//                         } else if (snapshot.hasData && snapshot.data != null) {
//                           return Image.file(
//                             snapshot.data!,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           );
//                         } else {
//                           return Center(
//                             child: Image.asset(
//                               'assets/images/defult_constro_img.png',
//                               // Default image path
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildHeader(String name, String labourCategory, String company) {
//
//     TextEditingController otHoursController = TextEditingController(text: "00");
//     TextEditingController otRateController = TextEditingController(text: "00");
//
//
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.primaryWhitebg,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
//         ],
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               SvgPicture.asset(
//                 "assets/icons/home-iocn/pin-icon.svg",
//                 height: 20,
//                 width: 20,
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 company,
//                 style: GoogleFonts.nunitoSans(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.primaryLightGrayFont,
//                 ),
//               ),
//             ],
//           ),
//           const Divider(),
//           _buildInfoRow("Labour Name", name, "Labour Category", labourCategory),
//           _buildInfoRowDW(
//             "Date",
//             DateFormat('dd/MM/yyyy').format(DateTime.now()),
//             "Working Hrs.",
//             _calculateTimeDifference(inTime, outTime),
//             //'Time Difference: ${_calculateTimeDifference()}',
//           ),
//
//           _buildInfoRowTime(
//             "In Time", // Title for In Time
//             inTime,
//
//             "Out Time", // Title for Out Time
//
//             outTime,
//           ),
//
//
//           _buildInfoRowNumber(
//             "OT Hrs.",
//             otHoursController,
//             "OT Rate/Hrs.",
//             otRateController,
//           ),
//
//
//         ],
//       ),
//     );
//   }
//
//   // **Helper method to build the info rows**
//   Widget _buildInfoRow(
//     String title1,
//     String value1,
//     String title2,
//     String value2,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _infoColumn(title1, value1),
//           Container(
//             width: 2, // Thin vertical divider
//             height: 30, // Divider height
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xffe5dcf3), // Transparent at the top
//                   Color(0xff9b79d0), // Stronger in the middle
//                   Color(0xffe5dcf3), // Transparent at the bottom
//                 ],
//               ),
//             ),
//           ),
//           _infoColumn(title2, value2),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildInfoRowNumber(
//       String title1,
//       TextEditingController controller1,
//       String title2,
//       TextEditingController controller2,
//       ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           _infoColumnnumbers(title1, controller1),
//           Container(
//             width: 2,
//             height: 30,
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xffe5dcf3),
//                   Color(0xff9b79d0),
//                   Color(0xffe5dcf3),
//                 ],
//               ),
//             ),
//           ),
//           _infoColumnnumbers(title2, controller2),
//         ],
//       ),
//     );
//   }
//
//
//
//
//   Widget _buildInfoRowDW(
//     String title1,
//     String value1,
//     String title2,
//     String value2,
//   ) {
//     // Log the received titles and values for better understanding
//     AppLogger.info(
//       "Building Info Row: title1=$title1, value1=$value1, title2=$title2, value2=$value2",
//     );
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title1, // "Date"
//                     style: GoogleFonts.nunitoSans(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   Text(
//                     value1, // Current Date
//                     style: GoogleFonts.nunitoSans(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: 2,
//             height: 30,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xffe5dcf3),
//                   Color(0xff9b79d0),
//                   Color(0xffe5dcf3),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title2, // "Working Hrs."
//                     style: GoogleFonts.nunitoSans(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   Consumer(
//                     builder: (context, ref, child) {
//                       final workingHours =
//                           ref
//                               .watch(timeProvider)
//                               .workingHours; // Access workingHours from the provider
//
//                       // Display the dynamically updated working hours
//                       return Text(
//                         workingHours, // Working hours will update automatically
//                         style: GoogleFonts.nunitoSans(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black,
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRowTime(
//     String title1,
//     TimeOfDay? inTime,
//     String title2,
//     TimeOfDay? outTime,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TimePickerWidget(title: 'In Time', timeType: 'inTime'),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: 2,
//             height: 30,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xffe5dcf3),
//                   Color(0xff9b79d0),
//                   Color(0xffe5dcf3),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TimePickerWidget(title: 'Out Time', timeType: 'outTime'),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // **Helper method to display individual columns in the info row**
//   Widget _infoColumn(String title, String value) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.primaryLightGrayFont,
//               ),
//             ),
//             SizedBox(height: 2),
//             Text(
//               value,
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.primaryBlackFont,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _infoColumnnumbers(String title, TextEditingController controller) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.primaryLightGrayFont,
//               ),
//             ),
//             SizedBox(height: 2),
//             TextFormField(
//               controller: controller,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: "Enter $title",
//                 filled: true,
//                 fillColor: AppColors.primaryWhitebg,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return "$title is required";
//                 }
//                 return null;
//               },
//               onChanged: (value) {
//                 AppLogger.info("✏️ $title changed: $value");
//               },
//               onSaved: (value) {
//                 AppLogger.info("💾 $title saved: $value");
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   /// ✅ **Helper function to get location and show dialog**
//   Future<void> _getLocationAndShowDialog({
//     required String
//     actionButtonText, // Add this parameter to determine the action
//   }) async {
//     try {
//
//
//       GlobalLoader.show(context); // Show loader while fetching location
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       double latitude = position.latitude;
//       double longitude = position.longitude;
//
//       AppLogger.info(
//         "Current location: Latitude: $latitude, Longitude: $longitude",
//       );
//
//       String address = await getAddressFromCoordinates(latitude, longitude);
//
//       AppLogger.info("📍 Current location: $address");
//
//       GlobalLoader.hide(); // Hide loader after getting location
//
//       _showDetailsDialog(
//         context,
//         actionButtonText: actionButtonText,
//         laborId: widget.labourID,
//         name: widget.name,
//         Category: widget.labourCategory,
//         // ✅ Use fallback if empty
//         company: widget.company,
//         latitude: latitude,
//         longitude: longitude,
//         currentLocation: address,
//         inTime: inTime,
//         outTime: outTime,
//       );
//
//       // ✅ Add logging (Use print OR AppLogger)
//       print("📝 Showing Details Dialog with:");
//       print("🔹 Name: ${widget.name}");
//       print("🔹 ID: ${widget.labourID}");
//       print("🔹 Category: ${widget.labourCategory}");
//       print("🔹 Company: ${widget.company}");
//       print("🔹 Latitude: $latitude");
//       print("🔹 Longitude: $longitude");
//       print("🔹 Current Location: $address");
//       print("🔹 inTime dilog: $inTime");
//       print("🔹 outTime dilog : $outTime");
//     } catch (e) {
//       GlobalLoader.hide(); // Ensure loader is hidden even if error occurs
//       AppLogger.error("Error fetching location: $e");
//     }
//   }
//
//   Future<String> getAddressFromCoordinates(
//     double latitude,
//     double longitude,
//   ) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         latitude,
//         longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//       } else {
//         return "Address not found";
//       }
//     } catch (e) {
//       return "Error getting address: $e";
//     }
//   }
//
//   Widget _buildHeaderLocation(
//     double? latitude,
//     double? longitude,
//     String? currentLocation,
//   ) {
//     // Log the location data
//     if (latitude != null && longitude != null) {
//       AppLogger.info("📍 Location: Lat:$latitude, Long:$longitude");
//     } else {
//       AppLogger.warn("⚠️ Location data is missing.");
//     }
//
//     if (currentLocation != null) {
//       AppLogger.info("📍 Address: $currentLocation");
//     }
//
//     // Build the location string with latitude and longitude
//     String locationText =
//         (latitude != null && longitude != null)
//             ? "Lat: $latitude, Long: $longitude"
//             : "Location not available";
//
//     // Append the address if available
//     if (currentLocation != null) {
//       locationText += " | $currentLocation";
//     }
//
//     // Returning the widget that will show the location information in one row
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             locationText,
//             style: GoogleFonts.nunitoSans(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: AppColors.primaryLightGrayFont,
//             ),
//             overflow:
//                 TextOverflow.ellipsis, // Ensures long text doesn't break UI
//           ),
//           Text(
//             currentLocation ?? "Location not available",
//             style: GoogleFonts.nunitoSans(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: AppColors.primaryLightGrayFont,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Custom method to return the file as a future
//   Future<File> _getImageFile() async {
//     // Simulating a delay to show loading spinner
//     await Future.delayed(Duration(seconds: 2)); // Adjust delay as needed
//     return File(_capturedFilePath!); // Return the image file
//   }
//
//
// }
