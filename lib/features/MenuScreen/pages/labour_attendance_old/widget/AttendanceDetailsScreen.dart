// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class AttendanceDetailsScreen extends StatelessWidget {
//   final String labourID;
//   final String name;
//   final String labourCategory;
//   final String company;
//
//   AttendanceDetailsScreen({
//     required this.labourID,
//     required this.name,
//     required this.labourCategory,
//     required this.company,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Attendance Details"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildInfoRow("Name", name),
//             _buildInfoRow("Labour ID", labourID),
//             _buildInfoRow("Category", labourCategory),
//             _buildInfoRow("Company", company),
//             _buildInfoRowTime("In Time", null, "Out Time", null),
//             _buildInfoRowWorkingHours("Working Hrs."),
//             _buildHeaderLocation(null, null, null),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Action for location retrieval and dialog
//               },
//               child: Text("Get Location"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRowWorkingHours(String title) {
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
//                   Text(
//                     title, // "Working Hrs."
//                     style: GoogleFonts.nunitoSans(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   Text(
//                     "8 hours", // Placeholder for dynamic data
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
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRowTime(
//       String title1, TimeOfDay? inTime, String title2, TimeOfDay? outTime) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Text(
//                 '$title1: ${inTime?.format(context) ?? 'Not Set'}',
//                 style: GoogleFonts.nunitoSans(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Text(
//                 '$title2: ${outTime?.format(context) ?? 'Not Set'}',
//                 style: GoogleFonts.nunitoSans(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeaderLocation(double? latitude, double? longitude, String? currentLocation) {
//     String locationText =
//     (latitude != null && longitude != null)
//         ? "Lat: $latitude, Long: $longitude"
//         : "Location not available";
//
//     if (currentLocation != null) {
//       locationText += " | $currentLocation";
//     }
//
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
//               color: Colors.grey,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             currentLocation ?? "Location not available",
//             style: GoogleFonts.nunitoSans(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
