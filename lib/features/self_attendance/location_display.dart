import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationDisplay extends StatelessWidget {
  const LocationDisplay({super.key});

  Future<String> _fetchLocation(BuildContext context) async {
    // Simulate fetching the location; replace this with actual location logic.
    await Future.delayed(Duration(seconds: 2));
    return "Ganesh Glory 11, Jagatpur Road, Gota, Ahmedabad, Gujarat, India";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_pin, color: Colors.purple, size: 20.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: FutureBuilder<String>(
            future: _fetchLocation(context),
            builder: (context, snapshot) {
              double screenWidth = MediaQuery.of(context).size.width;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              } else if (snapshot.hasError) {
                return Tooltip(
                  message: "Error fetching location",
                  child: Container(
                    width: screenWidth * 0.8,
                    child: Text(
                      "Error fetching location",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 13.sp, color: Colors.red),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                return Container(
                  width: screenWidth * 0.7,
                  child: Text(
                    snapshot.data!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 13.sp),
                  ),
                );
              } else {
                return const Text("Location not available.");
              }
            },
          ),
        ),
      ],
    );
  }
}
