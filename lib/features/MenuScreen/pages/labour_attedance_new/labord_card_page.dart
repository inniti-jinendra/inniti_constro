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
  });

  @override
  State<LabourCardNew> createState() => _LabourCardState();
}

class _LabourCardState extends State<LabourCardNew> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          AppLogger.info("📝 Tapped card for LabourID: ${widget.labourID}");
          AppLogger.info("📝 Tapped card for Company: ${widget.company}");
          AppLogger.info(
            "📝 Tapped card for LabourAttendanceID: ${widget.labourAttendanceID}",
          );

          if (widget.labourAttendanceID == 0) {
            AppLogger.info("➕ Add mode detected (LabourAttendanceID == 0)");
            AppLogger.info("📅 Date => ${widget.selectedDate}");

            final recordMap = await LabourAttendanceApiService()
                .fetchLabourAttendanceadd(labourID: widget.labourID);

            if (recordMap != null && context.mounted) {
              final editableRecord = LabourAttendance.fromJson(recordMap);
              AppLogger.info(
                "🆕 Add mode: Parsed LabourAttendanceID: ${editableRecord.labourAttendanceId}",
              );

              // await _getLocationAndShowDialog(actionButtonText: "Add", mode: FormMode.add);
              AppLogger.info("📝 Tapped card for LabourID pass: ${widget.labourID}");

              await _getLocationAndShowDialog(
                labourID: widget.labourID,
                actionButtonText: "Add",
                mode: FormMode.add,
                attendance: editableRecord,
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
                "📦 Full Parsed JSON: ${jsonEncode(editableRecord.toString())}",
              );

              // await _getLocationAndShowDialog(actionButtonText: "Edit", mode: FormMode.edit);

              await _getLocationAndShowDialog(
                labourID: widget.labourID,
                actionButtonText: "Edit",
                mode: FormMode.edit,
                attendance: editableRecord, // ✅ pass this in edit
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
            "❌ Failed to fetch or parse attendance: $e\n$stackTrace",
          );
        }
      },
      child: _buildCardUI(),
    );
  }

  Widget _buildCardUI() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildTopRow(), _buildBottomRow()],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 18),
            child: Text(
              widget.company,
              style: GoogleFonts.nunitoSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlackFont,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              height: 20, // Increased from 20
              width: 60,  // Optional: increase width for longer text
              decoration: BoxDecoration(
                color: AppColors.cardgreenlight,
                borderRadius: BorderRadius.circular(3),
              ),
              alignment: Alignment.center, // This alone is enough
              child: Text(
                '${_getAttendanceEmoji(widget.attendance)} ${widget.attendance}',
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: const Color(0xff07614A),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Container(
              height: 38,
              width: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryWhitebg,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.id,
                style: GoogleFonts.nunitoSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlueFont,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/user-icon.svg',
                height: 16,
                width: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryBlue,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                widget.name,
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlackFont,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.labourCategory,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlackFont,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Future<void> _getLocationAndShowDialog({
    required int labourID,
    required String actionButtonText,
    required FormMode mode, // Pass the mode here (either add or edit)
    LabourAttendance? attendance,
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
              // attendance: mode == FormMode.edit ? editableRecord : null,
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
        return 'Unavailable';
      default:
        return '';
    }
  }

}
