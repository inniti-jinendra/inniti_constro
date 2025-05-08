import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:inniti_constro/features/attedance/map_screen.dart';
import 'package:intl/intl.dart';

import '../../core/models/attendance/only_attendance/details_only_self_attendance_data_models.dart';
import '../../core/models/attendance/only_attendance/list_only_self_attendance_data_models.dart';
import '../../core/network/logger.dart';
import '../../core/services/attendance/attendance_api_service.dart';
import '../../core/services/attendance/only_attendance_api_service.dart';
import '../attedance/live_time_provider.dart';
import '../self_attendance/emp_self_attendance.dart';
import 'AttendanceNotifier.dart';
import 'SwipeToggleButton.dart';
import 'attendance_only_setting/attendance_only_profile_page.dart';

class AttendanceOnly extends ConsumerStatefulWidget {
   AttendanceOnly({super.key});

  @override
  ConsumerState<AttendanceOnly> createState() => _AttendanceOnlyState();
}

class _AttendanceOnlyState extends ConsumerState<AttendanceOnly> {
  List<AttendanceItemList> _attendanceList = [];

  bool _isLoading = true;
  String _currentAddress = "Loading address...";
  late GoogleMapController _controller;
  LatLng? _currentPosition;
  String? _error;

  // Converts milliseconds to HH:mm:ss format
  String formatDuration(int milliseconds) {
    final d = Duration(milliseconds: milliseconds);
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  // Calculates and formats time difference between check-in and check-out
  String _calculateTimeDifference(DateTime checkIn, DateTime checkOut) {
    return _formatTimeFromSeconds(checkOut.difference(checkIn).inSeconds);
  }

  // Converts seconds into HH:mm:ss format
  String _formatTimeFromSeconds(int totalSeconds) {
    final h = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  // Controllers for prefill fields
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _employeeIDController = TextEditingController();
  TextEditingController _profilePhotoUrlController = TextEditingController();
  TextEditingController _presentCountController = TextEditingController();
  TextEditingController _leaveCountController = TextEditingController();
  TextEditingController _absentCountController = TextEditingController();

  TextEditingController _attendanceDateController = TextEditingController();
  TextEditingController _inTimeController = TextEditingController();
  TextEditingController _outTimeController = TextEditingController();
  TextEditingController _presentHoursController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  // Data model for attendance
  late FetchAttendanceOnlyDetails _attendanceDetails;
  late AttendanceItemList _attendanceDetailsList;

  late Timer _timer; // Timer to trigger regular refresh
  int _refreshInterval = 2; // Time interval in seconds

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchAttendanceData();
    _fetchAttendanceDataget();

    // Set up the periodic timer to refresh data
    _timer = Timer.periodic(Duration(seconds: _refreshInterval), (timer) {
      _getCurrentLocation();
      _fetchAttendanceData();
      _fetchAttendanceDataget();
    });
  }


  @override
  void dispose() {
    _userNameController.dispose();
    _addressController.dispose();
    _employeeIDController.dispose();
    _profilePhotoUrlController.dispose();
    _presentCountController.dispose();
    _leaveCountController.dispose();
    _absentCountController.dispose();
    _attendanceDateController.dispose();
    _inTimeController.dispose();
    _outTimeController.dispose();
    _presentHoursController.dispose();
    _statusController.dispose();

    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchAttendanceDataget() async {
    AppLogger.info("📡 Starting self-attendance_only data fetch...");
    setState(() => _isLoading = true);

    try {
      final data = await SelfAttendanceApiService.fetchSelfAttendanceData();
      AppLogger.info("✅ Fetched ${data.length} self-attendance_only record(s)");


      if (data.isEmpty) {
        AppLogger.warn("⚠️ No self-attendance_only records found.");
        _error = "No attendance_only data available for today.";
        return;
      }

      final first = data.first;

      // Log key values from the first record
      AppLogger.info("🧾 Attendance Record:");
      AppLogger.info(" - Name: ${first.employeeName}");
      AppLogger.info(" - Designation: ${first.designationName}");
      AppLogger.info(" - In Time: ${first.inTime}");
      AppLogger.info(" - Out Time: ${first.outTime}");
      AppLogger.info(" - Hours: ${first.presentHours}");
      AppLogger.info(" - Status: ${first.presentHours > 0 ? 'Present' : 'Absent'}");
      AppLogger.info(" - Attendance ID: ${first.empAttendanceId}");
      AppLogger.info(" - Image In Path: ${first.inDocumentPath}");
      AppLogger.info(" - Image Out Path: ${first.outDocumentPath}");

      final formattedInTime = first.inTime != null
          ? DateFormat('HH:mm:ss').format(DateTime.parse(first.inTime!))
          : '';
      final formattedOutTime = first.outTime != null
          ? DateFormat('HH:mm:ss').format(DateTime.parse(first.outTime!))
          : '';
      final attendanceStatus = first.presentHours > 0 ? 'Present' : 'Absent';
      final attendanceDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      _inTimeController.text = formattedInTime;
      _outTimeController.text = formattedOutTime;
      _presentHoursController.text = first.presentHours.toString();

      ref.read(checkInOutStateProvider.notifier).state = ref.read(checkInOutStateProvider.notifier).state.copyWith(
        checkInTime: first.inTime != null ? DateTime.parse(first.inTime!) : null,
        checkOutTime: first.outTime != null ? DateTime.parse(first.outTime!) : null,

        timeDifference: (first.inTime != null && first.outTime != null)
            ? _calculateTimeDifference(DateTime.parse(first.inTime!), DateTime.parse(first.outTime!))
            : '00:00:00',
        empAttendanceId: first.empAttendanceId,
      );

      final state = GlobalState();
      state.checkInTime.value = formattedInTime;
      state.checkOutTime.value = formattedOutTime;
      state.inDocumentPath.value = first.inDocumentPath;
      state.outDocumentPath.value = first.outDocumentPath;
      state.attendanceStatus.value = attendanceStatus;
      state.attendanceDate.value = attendanceDate;
      state.totalHours.value = formatDuration(Duration(minutes: first.presentHours).inMilliseconds);
      state.attendanceId.value = first.empAttendanceId.toString();

      final id = first.empAttendanceId;
      if (id > 0) {
        final key = 'empAttendanceId_${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
        AppLogger.info("💾 Stored empAttendanceId: $id under key: $key");
      } else {
        _error = "❌ Invalid empAttendanceId: ${first.empAttendanceId}";
        AppLogger.error(_error!);
      }
    } catch (e) {
      _error = "❌ Error fetching attendance_only data: $e";
      AppLogger.error(_error!);
    } finally {
      setState(() => _isLoading = false);
      AppLogger.info("📴 Data fetch complete. isLoading = false.");
    }
  }

  // Fetch the attendance data from API
  Future<void> _fetchAttendanceData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Fetching data
      var fetchedDataDetails = await OnlyAttendanceApiService.fetchSelfAttendanceOnlyDetailsData();

      // Assuming you get a list and want the first item for now
      if (fetchedDataDetails.isNotEmpty) {
        _attendanceDetails = fetchedDataDetails[0];

        // Prefill controllers with fetched data
        _userNameController.text = _attendanceDetails.userName;
        _addressController.text = _attendanceDetails.address;
        _employeeIDController.text = _attendanceDetails.employeeId.toString();
        _profilePhotoUrlController.text = _attendanceDetails.profilePhotoUrl.toString();
        _presentCountController.text = _attendanceDetails.presentCount.toString();
        _leaveCountController.text = _attendanceDetails.leaveCount.toString();
        _absentCountController.text = _attendanceDetails.absentCount.toString();

        // Debug the fetched data
        AppLogger.debug("📋 Fetched Attendance Details: ${_attendanceDetails.toString()}");

        // Update UI
        setState(() {});
      }


      // Fetching the attendance list
      // Now, use the employee ID from the first attendance details to fetch the attendance list
      int employeeId = _attendanceDetails.employeeId;  // Get Employee ID from the first response


      var fetchedDataList = await OnlyAttendanceApiService.fetchSelfAttendanceOnlyListData(employeeId);

      if (fetchedDataList.isNotEmpty) {

        _attendanceList = AttendanceItemList.fromList(fetchedDataList);

        // Prefill using first attendance record
        final firstAttendance = _attendanceList[0];
        _attendanceDetailsList = firstAttendance;

        _attendanceDateController.text = firstAttendance.attendanceDate ?? '';
        _inTimeController.text = firstAttendance.inTime ?? '';
        _outTimeController.text = firstAttendance.outTime ?? '';
        _presentHoursController.text = firstAttendance.presentHours.toString() ?? '';
        _statusController.text = firstAttendance.status ?? '';

        AppLogger.debug("📋 First Attendance Record: ${firstAttendance.toString()}");
      }


    } catch (e) {
      AppLogger.error("❌ Error fetching attendance data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;  // Set loading to true when the refresh is triggered
    });

    await _fetchAttendanceData();  // Call the data fetching method

    setState(() {
      _isLoading = false;  // Set loading to false after refresh is complete
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      await _getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _currentAddress = "Failed to get location";
        _isLoading = false;
      });
      print("Error fetching location: $e");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception("Location permissions are denied.");
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _getAddressFromLatLng(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      Placemark place = placemarks.first;

      String address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';

      setState(() {
        _currentAddress = address;
      });
    } catch (e) {
      setState(() {
        _currentAddress = "Address not available";
      });
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkInOutState = ref.watch(checkInOutStateProvider);
    final checkInOutNotifier = ref.watch(checkInOutStateProvider.notifier);

    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.primaryWhitebg,
      body:Stack(
        children: [
          RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text("🆔 Employee ID: ${_employeeIDController.text}", style: TextStyle(fontSize: 16)),

                    SizedBox(height: 20.h),
                    _greetingSection(),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MapScreen(),
                          //_checkInCard(),
                          //CheckInCard(),
                          //SizedBox(height: 20.h),
                          _buildTopCard(context, ref, checkInOutState, checkInOutNotifier),

                          SizedBox(height: 20.h),
                          _attendanceSummary(),
                          SizedBox(height: 20.h),
                          //_currentAttendanceList(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Current Attendance",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp, fontWeight: FontWeight.w600)),
                              SizedBox(height: 12.h),
                              _attendanceList.isNotEmpty
                                  ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _attendanceList.length,
                                itemBuilder: (context, index) {
                                  final attendance = _attendanceList[index];

                                  // Parse and format the date
                                  String formattedDate = "N/A";
                                  if (attendance.attendanceDate != null && attendance.attendanceDate!.isNotEmpty) {
                                    try {
                                      DateTime parsedDate = DateTime.parse(attendance.attendanceDate!);
                                      formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
                                    } catch (e) {
                                      AppLogger.warn('Invalid date format: ${attendance.attendanceDate}');
                                    }
                                  }


                                  return _attendanceTile(
                                    // attendance.attendanceDate ?? "N/A",
                                    formattedDate,
                                    attendance.inTime ?? "00:00",
                                    attendance.outTime ?? "00:00",
                                    attendance.presentHours.toString(),
                                    attendance.status ?? "Absent",
                                  );
                                },
                              )
                                  : Center(child: CircularProgressIndicator()),
                            ],
                          ),
                        ],
                      ),
                    ),




                  ],
                ),
              ),
            ),
          ),
          // Loader overlay (only visible when loading)
          if (checkInOutState.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _greetingSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Color(0xffC3AFE3), width: 2),
            ),
            child: InkWell(
              onTap: () {

                AppLogger.info("image url : ${ _profilePhotoUrlController.text.trim()}");
                AppLogger.info("Name  : ${ _userNameController.text.trim()}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceOnlySettingsPage(
                      profilePhotoUrl: _profilePhotoUrlController.text.trim(),
                      userName: _userNameController.text.trim(),
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: _profilePhotoUrlController.text.trim().isNotEmpty
                      ? _profilePhotoUrlController.text.trim()
                      : 'https://randomuser.me/api/portraits/men/18.jpg',

                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) => Image.network(
                    'https://randomuser.me/api/portraits/men/18.jpg',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),


            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Good Morning, "
                //       "${_userNameController.text}",
                //   style: GoogleFonts.poppins(
                //     fontSize: 18.sp,
                //     color: Colors.indigo,
                //   ),
                // ),
                Text(
                  "Good Morning, ${_userNameController.text.length > 10
                      ? _userNameController.text.substring(0, 10)
                      : _userNameController.text}",
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    color: Colors.indigo,
                  ),
                ),

                SizedBox(height: 4.h),
                Text(
                  "Have a good day with full of productivity and good vibes",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _checkInCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white, // Set the color of the container
        borderRadius: BorderRadius.circular(16), // Set the corner radius
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.1),
            // Light indigo shadow with opacity
            offset: Offset(4, 4),
            // Shadow offset (horizontal, vertical)
            blurRadius: 8,
            // Blur radius for the shadow
            spreadRadius: 2, // Spread radius to control the shadow's size
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("03 Apr 2025", style: GoogleFonts.poppins(fontSize: 14.sp)),
              Text("02:45 PM", style: GoogleFonts.poppins(fontSize: 14.sp)),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _timeBox("09"),
                _timeBox("25"),
                _timeBox("00"),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text("Your working hour’s will be calculated here",
                style:
                    GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey)),
          ),
          SizedBox(height: 10.h),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A5AF8),
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r)),
            ),
            icon: Icon(Icons.login, size: 20.sp),
            label:
                Text("Check In", style: GoogleFonts.poppins(fontSize: 14.sp)),
            onPressed: () {},
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.location_pin, size: 16.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Expanded(
                child: Text("Ganesh Glory 11, Jagatpur Road, Gota.....",
                    style: GoogleFonts.poppins(
                        fontSize: 12.sp, color: Colors.grey)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _timeBox(String time) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(time,
          style: GoogleFonts.poppins(
              fontSize: 16.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _attendanceSummary() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white, // Set the color of the container
        borderRadius: BorderRadius.circular(16), // Set the corner radius
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.1),

            offset: Offset(4, 4),

            blurRadius: 8,

            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Attendance Summery",
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp, fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Icon(Icons.calendar_month, size: 16.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  // Curant Month Name
                  Text( DateFormat.LLLL().format(DateTime.now()), style: GoogleFonts.poppins(fontSize: 12.sp)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem("${_presentCountController.text.toString().trim()}", "Present", Color(0xff5B21B1),Color(0xffF3EFF9) ),
              _summaryItem("${_absentCountController.text.toString().trim()}", "Absent ", Color(0xffFC8100), Color(0xffFFF6ED)),
              _summaryItem("${_leaveCountController.text.toString().trim()}", "Leave  ", Color(0xff3DC9FA), Color(0xffEDFBFE)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String count, String label, Color color, Color Scolor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Scolor,
        //color: Colors.grey.shade200,
        boxShadow: [],
        border: Border(
          top: BorderSide(width: 2, color: color),
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 9),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceTile(
      String date, String inTime, String outTime, String total, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.shade50,
              offset: Offset(6, 4),
              blurRadius: 6,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(date,
                      style: GoogleFonts.poppins(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: status == "Present"
                          ? Colors.purple.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: Text(status,
                        style: GoogleFonts.poppins(fontSize: 12.sp)),
                  )
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.all(5.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    child: Column(children: [
                      Text("In Time",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(inTime), // Dynamic data for In Time
                    ]),
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
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                    child: Column(children: [
                      Text("Out Time",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(outTime), // Dynamic data for Out Time
                    ]),
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
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    child: Column(children: [
                      Text("Total Hrs",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(total),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard(BuildContext context, WidgetRef ref, checkInOutState,
      checkInOutNotifier) {
    final currentTime =
    ref.watch(currentTimeProvider); // 🕒 Watch the live time

    // Fetch location as AsyncValue<LocationDetails>
    final locationAsync = ref.watch(currentLocationProvider);

    // Calculate the time difference if both check-in and check-out times are available
    String timeDifference = "00:00:00";

    if (checkInOutState.checkInTime != null) {
      final checkInTime = checkInOutState.checkInTime!;

      // If check-out time is available, stop the live update
      if (checkInOutState.checkOutTime != null) {
        final checkOutTime = checkInOutState.checkOutTime!;
        timeDifference = _calculateTimeDifference(checkInTime, checkOutTime);
      } else {
        // If check-out time is not available, calculate the live time difference
        final timeDifferenceSeconds =
            currentTime.difference(checkInTime).inSeconds;

        if (timeDifferenceSeconds < 0) {
          // Handle case where check-in time is in the future, e.g., error or reset
          timeDifference = "00:00:00";
        } else {
          timeDifference = _formatTimeFromSeconds(timeDifferenceSeconds);
        }
      }
    }

    // Split the time difference into hours, minutes, and seconds
    final timeParts = timeDifference.split(":");
    final hours = timeParts[0]; // Extract hours
    final minutes = timeParts[1]; // Extract minutes
    final seconds = timeParts[2]; // Extract seconds

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white, // Set the color of the container
        borderRadius: BorderRadius.circular(16), // Set the corner radius
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.2),
            // Light indigo shadow with opacity
            offset: Offset(4, 4),
            // Shadow offset (horizontal, vertical)
            blurRadius: 8,
            // Blur radius for the shadow
            spreadRadius: 2, // Spread radius to control the shadow's size
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/attendance/calendar.svg',
                  // Path to your SVG file
                  height: 24, // Set the desired size
                  width: 24, // Set the desired size
                ),
                SizedBox(width: 8),
                Text(DateFormat('dd MMM yyyy').format(currentTime),
                    style: TextStyle(fontSize: 16)),
                Spacer(),
                SvgPicture.asset(
                  'assets/icons/attendance/clock.svg', // Path to your SVG file
                  height: 24, // Set the desired size
                  width: 24, // Set the desired size
                ),
                SizedBox(width: 8),
                Text(DateFormat('hh:mm:ss a').format(currentTime),
                    style: TextStyle(fontSize: 16)), // live clock
              ],
            ),
            SizedBox(height: 16),
            // Time difference display (separate hours, minutes, and seconds)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display hours
                Text(
                  hours,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(':',
                    style:
                    TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                // Display minutes
                Text(
                  minutes,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(':',
                    style:
                    TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                // Display seconds
                Text(
                  seconds,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Text("Your working hour’s will be calculated here",
                style: TextStyle(fontSize: 14)),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: checkInOutState.checkInTime == null
                  ? () => checkInOutNotifier.checkIn()
                  : checkInOutState.checkOutTime == null
                  ? () => checkInOutNotifier.checkOut()
                  : null,
              icon: Icon(Icons.arrow_forward),
              label: Text(
                checkInOutState.checkInTime == null ? "Check In" : "Check Out",
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 8),
            // Handling AsyncValue using `when` to manage loading, data, and error states
            // locationAsync.when(
            //   data: (locationDetails) {
            //
            //     AppLogger.info("Location Details: ${locationDetails.address.toString()}");
            //
            //     return Column(
            //       children: [
            //         Row(
            //           children: [
            //             // SvgPicture.asset(
            //             //   'assets/icons/attendance/location.svg', // Path to your SVG file
            //             //   height: 24, // Set the desired size
            //             //   width: 24, // Set the desired size
            //             // ),
            //             Icon(Icons.location_pin, size: 24),
            //             SizedBox(width: 8),
            //             Expanded(
            //               child: Text(
            //                 // Combine name, street, ISO, and country into a single line
            //                 // "${locationDetails.address.toString() ?? ''}",
            //                 locationDetails.address ?? "Location not available",
            //                 overflow: TextOverflow.ellipsis,
            //                 style: TextStyle(color: Colors.grey),
            //               ),
            //             ),
            //           ],
            //         ),
            //
            //         SizedBox(height: 4),
            //         // Optionally, show latitude and longitude as well
            //         Row(
            //           children: [
            //             Icon(Icons.map, size: 20, color: Colors.grey),
            //             SizedBox(width: 8),
            //             Expanded(
            //               child: Text(
            //                 "Lat: ${locationDetails.latitude}, Lon: ${locationDetails.longitude}",
            //                 overflow: TextOverflow.ellipsis,
            //                 style: TextStyle(color: Colors.grey),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     );
            //   },
            //   loading: () {
            //     return Row(
            //       children: [
            //         SvgPicture.asset(
            //           'assets/icons/attendance_only/location.svg', // Path to your SVG file
            //           height: 24, // Set the desired size
            //           width: 24, // Set the desired size
            //         ),
            //         SizedBox(width: 8),
            //         Expanded(
            //           child: Text(
            //             "Loading location...",
            //             overflow: TextOverflow.ellipsis,
            //             style: TextStyle(color: Colors.grey),
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            //   error: (error, stackTrace) {
            //     print("Error fetching location: $error");
            //     print("Stack trace: $stackTrace");
            //
            //     return Row(
            //       children: [
            //         Icon(Icons.location_on, size: 20, color: Colors.grey),
            //         SizedBox(width: 8),
            //         Expanded(
            //           child: Text(
            //             "Error fetching location: $error",
            //             overflow: TextOverflow.ellipsis,
            //             style: TextStyle(color: Colors.red),
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            // ),

            SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/attendance/location.svg', // Path to your SVG file
                  height: 24, // Set the desired size
                  width: 24, // Set the desired size
                ),
                //Icon(Icons.location_pin, size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    // Combine name, street, ISO, and country into a single line
                    // "${locationDetails.address.toString() ?? ''}",
                    //locationDetails.address ?? "Location not available",
                    _currentAddress,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
