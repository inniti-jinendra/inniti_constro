import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera with Live Location',
      home: CameraAccess(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CameraAccess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CameraAccessState();
}

class CameraAccessState extends State<CameraAccess> {
  File? cameraFile;
  late Timer _timer;
  final Logger _logger = Logger();
  bool isLoadingLocation = false;
  String? latitude;
  String? longitude;
  String? fullAddress;
  bool isWithinRange = false;
  LatLng? currentLatLng;
  GoogleMapController? mapController;
  StreamSubscription<Position>? positionStream;
  DateTime? lastUpdateTime;

  final double targetLatitude = 23.1139882;
  final double targetLongitude = 72.5406397;
  final double allowedRadiusInMeters = 50;

  @override
  void initState() {
    super.initState();
    _logger.i("CameraAccess initialized.");
    _startAutoCloseTimer();
    _startLiveLocationUpdates();
  }

  void _startAutoCloseTimer() {
    _timer = Timer(Duration(minutes: 10), _closeCamera);
    _logger.i("Auto-close timer started for 10 minutes.");
  }

  void _closeCamera() {
    if (mounted) {
      _logger.i("Closing camera screen due to timeout.");
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    positionStream?.cancel();
    super.dispose();
  }

  void _startLiveLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _logger.w("Location services are disabled.");
      setState(() {
        fullAddress = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        _logger.w("Location permission denied.");
        setState(() {
          fullAddress = "Location permission denied.";
        });
        return;
      }
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 1),
    ).listen((Position position) async {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        targetLatitude,
        targetLongitude,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      String address = placemarks.isNotEmpty
          ? [
        placemarks[0].name,
        placemarks[0].street,
        placemarks[0].subLocality,
        placemarks[0].locality,
        placemarks[0].administrativeArea,
        placemarks[0].country,
        placemarks[0].postalCode
      ].where((e) => e != null && e.isNotEmpty).join(', ')
          : "Address not found.";

      DateTime now = DateTime.now();
      if (lastUpdateTime != null) {
        Duration diff = now.difference(lastUpdateTime!);
        _logger.i("Location updated after ${diff.inSeconds} seconds.");
      }
      lastUpdateTime = now;

      _logger.i("Location changed: Lat: ${position.latitude}, Lng: ${position.longitude}");

      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        fullAddress = address;
        isWithinRange = distance <= allowedRadiusInMeters;
        currentLatLng = LatLng(position.latitude, position.longitude);
      });

      if (mapController != null && currentLatLng != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(currentLatLng!));
      }
    });
  }

  Future<void> selectFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        cameraFile = File(pickedFile.path);
      });
      _logger.i("Image captured: ${pickedFile.path}");
    } else {
      _logger.w("No image selected.");
    }

    if (_timer.isActive) _timer.cancel();
    _startAutoCloseTimer();
  }

  void _openCameraModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 300, width: 300, child: Center(child: Text('Camera Preview Placeholder'))),
              ElevatedButton(
                onPressed: selectFromCamera,
                child: Text('Capture Image'),
              ),
            ],
          ),
        );
      },
    );
    _logger.i("Camera dialog shown.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Access"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (latitude != null && longitude != null) ...[
              Text("Latitude: $latitude"),
              Text("Longitude: $longitude"),
              Text("Address:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(fullAddress ?? ''),
              SizedBox(height: 20),
            ],
            SizedBox(
              height: 300,
              child: currentLatLng != null
                  ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLatLng!,
                  zoom: 16,
                ),
                onMapCreated: (controller) {
                  mapController = controller;
                  _logger.i("Google Map created.");
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: {
                  Marker(
                    markerId: MarkerId("current"),
                    position: currentLatLng!,
                    infoWindow: InfoWindow(title: "Your Location"),
                  ),
                  Marker(
                    markerId: MarkerId("target"),
                    position: LatLng(targetLatitude, targetLongitude),
                    infoWindow: InfoWindow(title: "Target Location"),
                  ),
                },
                circles: {
                  Circle(
                    circleId: CircleId("range"),
                    center: LatLng(targetLatitude, targetLongitude),
                    radius: allowedRadiusInMeters,
                    fillColor: Colors.green.withOpacity(0.2),
                    strokeColor: Colors.green,
                    strokeWidth: 2,
                  ),
                },
              )
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 20),
            isWithinRange
                ? ElevatedButton(
              onPressed: _openCameraModal,
              child: Text("Open Camera"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            )
                : Text(
              "You are out of range. Move closer to the target location to enable the camera.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              width: 300,
              child: cameraFile == null
                  ? Center(child: Text('No image captured.'))
                  : Image.file(cameraFile!),
            ),
          ],
        ),
      ),
    );
  }
}
