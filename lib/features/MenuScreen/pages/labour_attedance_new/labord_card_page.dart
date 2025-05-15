import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../../core/constants/app_colors.dart';

import '../../../../../core/network/logger.dart';
import '../../../../../core/services/LabourAttendance/labour_attendance_api_service.dart';

import '../../../../../widgets/global_loding/global_loader.dart';
import '../../../../core/constants/font_styles.dart';
import 'attedance_form.dart';
import 'labor_master_attedance_modal.dart';

class LabourCardNew extends StatefulWidget {
  final String id;
  final String name;
  final String company;
  final String attendance;
  final String labourCategory;
  final int labourID;
  final int labourAttendanceID;
  final VoidCallback? onTap;
  final String selectedDate;
  final bool enabled;

  const LabourCardNew({
    super.key,
    required this.id,
    required this.name,
    required this.company,
    required this.attendance,
    required this.labourCategory,
    required this.labourID,
    required this.labourAttendanceID,
    required this.selectedDate,
    this.onTap,
    this.enabled = false,
  });

  @override
  State<LabourCardNew> createState() => _LabourCardState();
}

class _LabourCardState extends State<LabourCardNew> {
  @override
  Widget build(BuildContext context) {
    print("🔍 widget.enabled: ${widget.enabled}");

    return GestureDetector(
      onTap:() async {
        try {
          AppLogger.info("📝 Tapped card for LabourID: ${widget.labourID}");
          AppLogger.info("📝 Tapped card for Company: ${widget.company}");
          AppLogger.info("📝 Tapped card for LabourAttendanceID: ${widget.labourAttendanceID}",);
          AppLogger.info("📅 Date selacted on tap retrive=>> ${widget.selectedDate}");
          AppLogger.info("📋 Attendance on tap retrieve => ${widget.attendance}");

          // 🚫 Skip tap if Unavailable
          if (widget.attendance == 'Unavailable') {
            AppLogger.warn("🚫 Tap ignored: Labour is marked as Unavailable.");
            return;
          }

          if (widget.labourAttendanceID == 0) {
            AppLogger.info("➕ Add mode detected (LabourAttendanceID == 0)");
            AppLogger.info("📅 Date selacted=> ${widget.selectedDate}");

            final recordMap = await LabourAttendanceApiService()
                .fetchLabourAttendanceadd(
              labourID: widget.labourID,
              selectedDate: widget.selectedDate, // Passing selectedDate as a dynamic argument
            );

            if (recordMap != null && context.mounted) {
              final editableRecord = LabourAttendance.fromJson(recordMap);
              AppLogger.info(
                "🆕 Add mode: Parsed LabourAttendanceID: ${editableRecord.labourAttendanceId}",
              );
              AppLogger.info("🆕 Add mode: Parsed contractorId: ${editableRecord.contractorId}",);
              AppLogger.info("🆕 Add mode: Parsed  contractorName: ${editableRecord.contractorName}",);

              // await _getLocationAndShowDialog(actionButtonText: "Add", mode: FormMode.add);
              AppLogger.info("📝 Tapped card for LabourID pass: ${widget.labourID}");

              await _getLocationAndShowDialog(
                labourID: widget.labourID,
                actionButtonText: "Add",
                mode: FormMode.add,
                attendance: editableRecord,
                selectedDate: widget.selectedDate,
              );


            } else {
              AppLogger.warn(
                "⚠️ Add mode: Record not found or context not mounted.",
              );
            }
          } else {
            AppLogger.info("✏️ Edit mode detected (Fetching existing record)");

            final recordMapEdit = await LabourAttendanceApiService()
                .GetLabourAttendanceeditDetails(
                  date: widget.selectedDate,
                  labourAttendanceID: widget.labourAttendanceID,
                );

            AppLogger.info("📨 Raw response: $recordMapEdit");

            if (recordMapEdit != null && context.mounted) {
              final editableRecord = LabourAttendance.fromJson(recordMapEdit);

              AppLogger.info(
                "📝 Edit mode: Parsed LabourAttendanceID: ${editableRecord.labourAttendanceId}",
              );
              AppLogger.info(
                "📦 contractorId pass: ${jsonEncode(editableRecord.contractorId)}",
              );

              // await _getLocationAndShowDialog(actionButtonText: "Edit", mode: FormMode.edit);

              await _getLocationAndShowDialog(
                labourID: widget.labourID,
                actionButtonText: "Edit",
                mode: FormMode.edit,
                attendance: editableRecord, // ✅ pass this in edit
                selectedDate: widget.selectedDate,
              );


              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SimpleAttendanceForm(labourAttendance: editableRecord),
              //   ),
              // );
            } else {
              AppLogger.warn(
                "⚠️ Edit mode: Record not found or context not mounted.",
              );
            }
          }
        } catch (e, stackTrace) {
          AppLogger.error(
            "❌ Failed to fetch or parse attendance_only: $e\n$stackTrace",
          );
        }
      },
      child: _buildCardUI(isUnavailable: widget.attendance == 'Unavailable'),
    );
  }

  Widget _buildCardUI({required bool isUnavailable}) {

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12,),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow( // 5B21B1
              //color: Color(0x33000000),
              color: Color(0x405B21B1), // 40 is hex for 25% opacity
              //color: Color(0x1A5B21B1), // 40 is hex for 25% opacity
              offset: Offset(0, 0),     // Matches 0px 0px
              blurRadius: 7,
              spreadRadius: -4,         // Negative spread like CSS
            ),
          ],
        ),
        child: Container(
          //height: 85,
          decoration: BoxDecoration(
           // color: Colors.red,
           // color: isUnavailable ? Color(0xfffafafa) :Colors.white,
            color: isUnavailable ? Color(0xffEFE9F7) : Colors.white,
//color:  Color(0xff5B21B1).withOpacity(0.2),

            borderRadius: BorderRadius.circular(12),

          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopRow(isUnavailable),
              _buildBottomRow(isUnavailable)],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(bool isUnavailable) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 15),
            // child: Text(
            //   widget.company,
            //   style: FontStyles.bold700.copyWith(
            //     fontSize: 18,
            //     color: AppColors.primaryBlackFont,
            //   ),
            //   overflow: TextOverflow.ellipsis,
            //   maxLines: 1,
            //   softWrap: false,
            // ),
            child:   Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/attendance/Profile-Check.svg',
                  height: 16,
                  width: 16,
                    color:isUnavailable ? Color(0xff000000).withOpacity(0.5) : null
                ),
                const SizedBox(width: 5),
                Text(
                  widget.name,
                  style: FontStyles.medium500.copyWith(
                    fontSize: 12,
                    color:isUnavailable ? Color(0xff000000).withOpacity(0.5) : AppColors.primaryBlackFontWithOpps60,
                    //color: AppColors.primaryBlackFontWithOpps60,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.labourCategory,
                    style: FontStyles.bold700.copyWith(
                      fontSize: 12,
                     // color: AppColors.primaryBlueFont,
                      color:isUnavailable ? Color(0xff000000).withOpacity(0.5) :AppColors.primaryBlueFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [



            // Container(
            //   height: 40,
            //   width: 40,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     color: AppColors.primaryWhitebg,
            //     borderRadius: const BorderRadius.only(
            //       topRight: Radius.circular(12),
            //       bottomLeft: Radius.circular(12),
            //     ),
            //     // boxShadow: [
            //     //   BoxShadow(
            //     //     color: Colors.black.withOpacity(0.1),
            //     //     blurRadius: 4,
            //     //     spreadRadius: 1,
            //     //     offset: const Offset(0, 2),
            //     //   ),
            //     // ],
            //   ),
            //   child: Text(
            //     widget.id,
            //     style: GoogleFonts.nunitoSans(
            //       fontSize: 10,
            //       fontWeight: FontWeight.bold,
            //       color: AppColors.primaryBlueFont,
            //     ),
            //   ),
            // ),
            Container(
              // height: 38,
              // // ✅ Slightly smaller for better proportion
              // width: 38,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primaryWhitebg,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 08,
                ),
                child: Text(
                  widget.id,
                  // "111",
                  style: FontStyles.bold700.copyWith(
                    // fontSize: 10,
                    fontSize: 13, // ✅ Adjusted for readability
                     color: AppColors.primaryBlueFont,
                    //color: _isActive ? AppColors.primaryBlue : AppColors.primaryBlueWithOps60,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),

          ],
        ),
      ],
    );
  }

  Widget _buildBottomRow(bool isUnavailable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Company name (left side)
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 5),
              child: Text(
                _truncateWithEllipsis(widget.company, 20),
                style: FontStyles.bold700.copyWith(
                  fontSize: 16,
                  color:isUnavailable ? Color(0xff000000).withOpacity(0.5) : AppColors.primaryBlackFont,
                ),
              ),

          ),

          const SizedBox(width: 10),

          // Attendance status container (right side)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getAttendanceBackgroundColor(widget.attendance),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                _getAttendanceEmoji(widget.attendance),
                style: GoogleFonts.nunitoSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _getAttendanceTextColor(widget.attendance),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

// 🔧 Helper methods
  Color _getAttendanceBackgroundColor(String? attendance) {
    switch (attendance) {
      case "A":
      case "Absent":
        return const Color(0xFFFFE9E9);
      case "P":
      case "Present":
        return const Color(0xffC8FAE8);
        //return const Color(0xFFC8FAE8);
      case "U":
      case "Unavailable":
        return const Color(0xffF3E2C9);
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getAttendanceTextColor(String? attendance) {
    switch (attendance) {
      case "A":
      case "Absent":
      return Color(0xff990F0F);
      case "P":
      case "Present":
        return Color(0xff07614A);
      case "U":
      case "Unavailable":
        return Color(0xffC97909);
      default:
        return Colors.grey.shade600;
    }
  }

  String _truncateWithEllipsis(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }




  Future<void> _getLocationAndShowDialog({
    required int labourID,
    required String actionButtonText,
    required FormMode mode, // Pass the mode here (either add or edit)
    LabourAttendance? attendance,
    required String selectedDate,
  }) async {
    try {
      GlobalLoader.show(context); // Show loading indicator

      // Check if the location permission is granted
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // If permission is denied, request for permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // If the user denies the permission again, show a message
          GlobalLoader.hide();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Permission Required"),
              content: Text(
                  "Location permission is needed to proceed. Please allow location access."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          );
          return;
        }
      }

      // If permission is granted, fetch location
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double latitude = position.latitude;
        double longitude = position.longitude;

        // Log current location details
        AppLogger.info(
          "Current location: Latitude: $latitude, Longitude: $longitude",
        );

        // Fetch address from coordinates
        String address = await getAddressFromCoordinates(latitude, longitude);

        AppLogger.info("📍 Current location: $address");

        GlobalLoader.hide(); // Hide loading indicator

        AppLogger.info("📝 $actionButtonText tapped for LabourID: $labourID");

        // Navigate to SimpleAttendanceForm page with the correct mode
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SimpleAttendanceForm(
              labourID: labourID,
              mode: mode,
              attendance: attendance,
              latitude: latitude,       // ✅ pass latitude
              longitude: longitude,     // ✅ pass longitude
              address: address,         // ✅ pass address
              selectedDate: selectedDate,
              // attendance_only: mode == FormMode.edit ? editableRecord : null,
            ),
          ),
        );


        AppLogger.info("📝 Navigating to Full Screen Attendance Form");
      } else {
        // If permission is still not granted after asking, show a dialog to guide the user
        GlobalLoader.hide();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Permission Denied"),
            content: Text(
                "We need location access to continue. Please enable location permissions in your device settings."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      GlobalLoader.hide(); // Hide loading indicator on error
      AppLogger.error("Error fetching location: $e");
    }
  }



// Function to convert coordinates to an address
  Future<String> getAddressFromCoordinates(
      double latitude,
      double longitude,
      ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        return "Address not found";
      }
    } catch (e) {
      return "Error getting address: $e";
    }
  }

  String _getAttendanceEmoji(String status) {
    switch (status) {
      case 'Present':
        return 'Present';
      case 'Absent':
        return 'Absent';
      case 'Unavailable':
        return 'Un-Available';
      default:
        return '';
    }
  }

}
