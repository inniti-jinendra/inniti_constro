import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../core/components/appbar_header.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/network/logger.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/themes/app_themes.dart';
import 'CheckInOutNotifier.dart';
import 'live_time_provider.dart';
import '../../../core/network/connectivity_status_notifier.dart';

void main() {
  runApp(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: Size(375, 812), // Use the reference screen size
        builder: (context, child) {
          return MyApp();
        },
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);

    // Log the current connectivity status
    AppLogger.info("🔹 Connectivity Status in MyApp: $connectivityStatus");

    return MaterialApp(
      key: ValueKey(connectivityStatus),
      // Forces a rebuild when connectivity changes
      debugShowCheckedModeBanner: false,
      title: 'Inniti ERP',
      theme: AppTheme.defaultTheme,
      home: SelfAttendanceScreen(),
    );
  }
}

class SelfAttendanceScreen extends ConsumerWidget {
// Helper function to calculate time difference (HH:mm:ss) between check-in and check-out
  String _calculateTimeDifference(DateTime checkInTime, DateTime checkOutTime) {
    final duration = checkOutTime.difference(checkInTime);
    return _formatTimeFromSeconds(duration.inSeconds);
  }

// Helper function to format seconds into HH:mm:ss
  String _formatTimeFromSeconds(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInOutState = ref.watch(checkInOutStateProvider);
    final checkInOutNotifier = ref.watch(checkInOutStateProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
          },
          icon: Icon(Icons.chevron_left, size: 30),
          color: AppColors.primaryBlue,
        ),
        title: AppbarHeader(
          headerName: 'Self Attendance',
          projectName: '',
          //projectName: 'Ganesh Gloary 11',
        ),
        backgroundColor: AppColors.primaryWhitebg,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Logic to refresh the UI (e.g., fetch new data)
          await ref.refresh(currentLocationProvider);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
                      // Stack(
                      //   children: [
                      //     Container(
                      //       decoration: BoxDecoration(
                      //           boxShadow: AppDefaults.boxShadow,
                      //           borderRadius: AppDefaults.borderRadius),
                      //       height: MediaQuery.of(context).size.height *
                      //           0.25, // Set a fixed height
                      //       width: double.infinity,
                      //       child: GoogleMap(
                      //         initialCameraPosition: CameraPosition(
                      //           target: _currentPosition,
                      //           zoom: 14,
                      //         ),
                      //         markers: {
                      //           Marker(
                      //             markerId: const MarkerId("currentLocation"),
                      //             position: _currentPosition,
                      //             infoWindow: const InfoWindow(title: "Your Location"),
                      //           ),
                      //         },
                      //         myLocationEnabled: true,
                      //         myLocationButtonEnabled: true,
                      //         onMapCreated: (GoogleMapController controller) {
                      //           _controller = controller;
                      //         },
                      //       ),
                      //     ),
                      //     Positioned(
                      //       bottom: 10,
                      //       left: 20,
                      //       right: 20,
                      //       child: Container(
                      //         padding: const EdgeInsets.all(12),
                      //         decoration: BoxDecoration(
                      //             color: Colors.white,
                      //             borderRadius: BorderRadius.circular(8),
                      //             boxShadow: AppDefaults.boxShadow),
                      //         child: Text(
                      //           _currentAddress,
                      //           textAlign: TextAlign.center,
                      //           style: const TextStyle(
                      //               fontSize: 12, fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

              _buildTopCard(context, ref, checkInOutState, checkInOutNotifier),
              SizedBox(height: 16),
              _buildInOutCard(checkInOutState),
              // SizedBox(height: 16),
              SizedBox(height: 16),
              _buildAttendanceTable(checkInOutState),
            ],
          ),
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
            locationAsync.when(
              data: (locationDetails) {
                return Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/attendance/location.svg',
                          // Path to your SVG file
                          height: 24, // Set the desired size
                          width: 24, // Set the desired size
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Address: ${locationDetails.address}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(height: 4),
                    // Row(
                    //   children: [
                    //     Icon(Icons.map, size: 20, color: Colors.grey),
                    //     SizedBox(width: 8),
                    //     Expanded(
                    //       child: Text(
                    //         "Lat: ${locationDetails.latitude}, Lon: ${locationDetails.longitude}",
                    //         overflow: TextOverflow.ellipsis,
                    //         style: TextStyle(color: Colors.grey),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                );
              },
              loading: () {
                return Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/attendance/location.svg',
                      // Path to your SVG file
                      height: 24, // Set the desired size
                      width: 24, // Set the desired size
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Loading location...",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) {
                print("Error fetching location: $error");
                print("Stack trace: $stackTrace");

                return Row(
                  children: [
                    Icon(Icons.location_on, size: 20, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Error fetching location: $error",
                        // Show the error message
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInOutCard(checkInOutState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white, // Set the color of the container
        borderRadius: BorderRadius.circular(12),
        //borderRadius: BorderRadius.circular(16), // Set the corner radius
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.2),
            offset: Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildTimeRow(
                'assets/icons/attendance/white-clock.svg',
                "In Time",
                checkInOutState.checkInTime,
                checkInOutState.checkInImage),
          ),
          // Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildTimeRow(
                'assets/icons/attendance/white-clock.svg',
                "Out Time",
                checkInOutState.checkOutTime,
                checkInOutState.checkOutImage),
          ),
          Container(
            height: 50,
            width: double.infinity,
            // color: AppColors.primaryWhitebg,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5), // Rounded bottom-left corner
                bottomRight: Radius.circular(5), // Rounded bottom-right corner
              ),
            ),
            child: _buildPresentHours(checkInOutState),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String icon, String label, DateTime? time, File? image) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Icon(icon, color: Colors.deepPurple, size: 24),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            // Set rounded corners with a radius of 4
            color: AppColors.primaryBlue
                .withOpacity(0.9), // Optional background color for the icon
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              icon, // Path to your SVG file
              height: 24, // Set the desired size
              width: 24, // Set the desired size
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                time != null ? DateFormat('hh:mm:ss a').format(time) : '--:--',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        if (image != null)
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                image,
                width: 80.w,
                height: 60.h,
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          Expanded(
            flex: 2,
            child: Container(
              width: 80.w,
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: Icon(Icons.camera_alt, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  Widget _buildPresentHours(checkInOutState) {
    // Format time as HH:mm:ss
    final timeDifference = checkInOutState.timeDifference;
    final timeParts = timeDifference.split(":");
    final hours = timeParts[0]; // Extract hours
    final minutes = timeParts[1]; // Extract minutes
    final seconds = timeParts[2]; // Extract seconds

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhitebg.withOpacity(0.9),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8), // Rounded bottom-left corner
          bottomRight: Radius.circular(8), // Rounded bottom-right corner
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            // Light indigo shadow with opacity
            offset: Offset(4, 4),
            // Shadow offset (horizontal, vertical)
            blurRadius: 8,
            // Blur radius for the shadow
            spreadRadius: 2, // Spread radius to control the shadow's size
          ),
        ],
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: "Present Hours: ",
            style: TextStyle(color: Colors.black, fontSize: 18),
            children: [
              TextSpan(
                text: "$hours Hrs $minutes Min $seconds Sec",
                // Format as "05 Hrs 15 Min"
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceTable(checkInOutState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Current Attendance",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white, // Set the background color (optional)
            borderRadius: BorderRadius.circular(
              16,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09), // very subtle shadow
                blurRadius: 6,
                offset: Offset(0, 2), // downwards shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Set the background color (optional)
                  borderRadius: BorderRadius.circular(
                    14,
                  ), // Set the rounded corners with 16 radius
                ),
                padding: EdgeInsets.all(10),
                // Optional: Adjust padding if necessary
                child: Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.purple, size: 18.sp),
                    SizedBox(width: 8.w),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                    style: TextStyle(fontSize: 16)),
                ),
                    const Spacer(),
                    // Chip(
                    //   label: Text(
                    //     attendanceData!.outTime == null
                    //         ? "Checked In"
                    //         : "Checked Out",
                    //     style: TextStyle(color: Colors.purple, fontSize: 12.sp),
                    //   ),
                    //   backgroundColor: const Color(0xFFEDE7F6),
                    //   side: BorderSide.none,
                    // ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryWhitebg,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                      child: Column(children: [
                        Text("In Time",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(checkInOutState.checkInTime != null
                            ? DateFormat('HH:mm')
                                .format(checkInOutState.checkInTime!)
                            : '--:--'),
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
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                      child: Column(children: [
                        Text("Out Time",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(checkInOutState.checkOutTime != null
                            ? DateFormat('HH:mm')
                                .format(checkInOutState.checkOutTime!)
                            : '--:--'),
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      child: Column(children: [
                        Text("Total Hrs",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(checkInOutState.timeDifference
                            .replaceAll(":", " : ")),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
