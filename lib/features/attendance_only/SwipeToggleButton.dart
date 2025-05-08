
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Attendance {
  String? id;
  DateTime checkInTime;
  DateTime? checkOutTime;
  Duration? elapsedTime;
  String location;
  double latitude;
  double longitude;

  Attendance({
    this.id,
    required this.checkInTime,
    this.checkOutTime,
    this.elapsedTime,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  // Convert Attendance object to a Map
  Map<String, dynamic> toJson() {
    return {
      'checkInTime': checkInTime.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'elapsedTime': elapsedTime?.inMinutes,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Convert Map to Attendance object
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['_id'],
      checkInTime: DateTime.parse(json['checkInTime']),
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'])
          : null,
      elapsedTime: json['elapsedTime'] != null
          ? Duration(minutes: json['elapsedTime'])
          : null,
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class CheckInCard extends StatefulWidget {
  @override
  _CheckInCardState createState() => _CheckInCardState();
}

class _CheckInCardState extends State<CheckInCard> {
  late Timer _timer;
  late DateTime _checkInTime;
  Duration _elapsedTime = Duration.zero;
  bool _isCheckedIn = false;
  String _currentAddress = "Loading address...";
  late GoogleMapController _controller;
  LatLng? _currentPosition;
  bool _isLoading = true;

  // Store the attendance record
  Attendance? _attendance;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
  void dispose() {
    if (_isCheckedIn) {
      _timer.cancel();
    }
    super.dispose();
  }

  String get formattedDate => DateFormat('dd MMM yyyy').format(DateTime.now());
  String get formattedTime => DateFormat('hh:mm a').format(DateTime.now());

  String get formattedElapsedTime {
    final hours = _elapsedTime.inHours.toString().padLeft(2, '0');
    final minutes = (_elapsedTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsedTime.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void startTimer() {
    _checkInTime = DateTime.now();
    _elapsedTime = Duration.zero;
    _isCheckedIn = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = DateTime.now().difference(_checkInTime);
      });
    });
    // Create an attendance record and send check-in data
    _attendance = Attendance(
      checkInTime: _checkInTime,
      location: _currentAddress,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
    );
   //  _createAttendance();
  }

  void stopTimer() {
    _timer.cancel();
    _isCheckedIn = false;
    // Update the attendance record with check-out time and elapsed time
    _attendance?.checkOutTime = DateTime.now();
    _attendance?.elapsedTime = _elapsedTime;
    // _updateAttendance();
  }

  // Future<void> _createAttendance() async {
  //   if (_attendance != null) {
  //     final attendanceData = _attendance!.toJson();
  //     final success = await AttendanceService.createAttendance(attendanceData);
  //     if (success) {
  //       print("Attendance created successfully.");
  //     } else {
  //       print("Failed to create attendance.");
  //     }
  //   }
  // }
  //
  // Future<void> _updateAttendance() async {
  //   if (_attendance != null && _attendance!.id != null) {
  //     final attendanceData = _attendance!.toJson();
  //     final success = await AttendanceService.updateAttendance(_attendance!.id!, attendanceData);
  //     if (success) {
  //       print("Attendance updated successfully.");
  //     } else {
  //       print("Failed to update attendance.");
  //     }
  //   }
  // }


  Widget _timeBox(String time) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(time,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            offset: Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formattedDate, style: GoogleFonts.poppins(fontSize: 14)),
              Text(formattedTime, style: GoogleFonts.poppins(fontSize: 14)),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _timeBox(formattedElapsedTime),
              ],
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text("Your working hour’s will be calculated here",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCheckedIn ? Colors.indigo : Color(0xFF7A5AF8),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            icon: Icon(_isCheckedIn ? Icons.logout  : Icons.login, size: 20),
            label: Text(_isCheckedIn ? "Check Out" : "Check In",
                style: GoogleFonts.poppins(fontSize: 14)),
            onPressed: () {

              if (_isCheckedIn) {
                stopTimer();
              } else {
                startTimer();
              }
            },
          ),
          SizedBox(height: 8),
          _isCheckedIn
              ? Text(
            "Elapsed Time: $formattedElapsedTime",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          )
              : Container(),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_pin, size: 16, color: Colors.indigo),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                    _currentAddress,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey)),
              ),
            ],
          )
        ],
      ),
    );
  }
}


