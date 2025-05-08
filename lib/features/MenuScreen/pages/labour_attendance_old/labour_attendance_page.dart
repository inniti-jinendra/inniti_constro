// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:inniti_constro/features/MenuScreen/pages/labour_attendance_old/widget/LabourCard.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/models/LabourAttendance/LabourAttendance.dart';
// import '../../../../core/network/logger.dart';
// import '../../../../core/services/LabourAttendance/labour_attendance_api_service.dart';
//
// class LabourAttendancePage extends StatefulWidget {
//   const LabourAttendancePage({super.key});
//
//   @override
//   State<LabourAttendancePage> createState() => _LabourAttendancePageState();
// }
//
// class _LabourAttendancePageState extends State<LabourAttendancePage> {
//   // Controllers for the text fields
//   TextEditingController labourController = TextEditingController();
//   TextEditingController contractorController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//
//   bool isLoading = false;
//   List<LabourAttendance> labourAttendanceList = []; // Initialize to an empty list
//   List<LabourAttendance> filteredLabours = []; // Initialize to an empty list
//
//   String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   //String selectedDate = '2025-04-11'; // Set a default date or get today's date
//   int totalPresent = 0; // Track total present count
//
//   void _selectDate(BuildContext context) async {
//     final DateTime today = DateTime.now();
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: today, // current date
//       firstDate: DateTime(2000), // allow past dates
//       lastDate: today, // disallow future dates
//     );
//
//     if (picked != null && picked != DateTime.parse(selectedDate)) {
//       setState(() {
//         selectedDate = DateFormat('yyyy-MM-dd').format(picked);
//       });
//
//       AppLogger.info("📅 Date changed to $selectedDate, re-fetching data...");
//       _fetchLabourAttendanceData(); // 🟢 Trigger API call when date changes
//
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLabourAttendanceData(); // Fetch Labour Data as soon as the page is initialized
//   }
//
//   Future<void> _fetchLabourAttendanceData() async {
//     AppLogger.info("🔄 [START] Fetching Labour Attendance Data...");
//
//     if (!mounted) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       AppLogger.debug("📦 Calling LabourAttendanceApiService with PageNumber: 1, PageSize: 100");
//
//       List<LabourAttendance> fetchedLabours = await LabourAttendanceApiService().fetchLabourAttendance(
//         pageNumber: 1,
//         pageSize: 100,
//         labourName: null,
//         contractorName: null,
//         date: selectedDate,
//       );
//
//       AppLogger.debug("📊 Response received with ${fetchedLabours.length} records.");
//
//       if (!mounted) return;
//
//       if (fetchedLabours.isNotEmpty) {
//         setState(() {
//           labourAttendanceList = fetchedLabours;
//           filteredLabours = List.from(fetchedLabours);
//         });
//
//
//         for (int i = 0; i < (fetchedLabours.length > 3 ? 3 : fetchedLabours.length); i++) {
//           final labour = fetchedLabours[i];
//           AppLogger.debug("👷 Labour #${i + 1}: "
//               "ID=${labour.labourID}, "
//               "Name=${labour.labourName}, "
//               "Contractor=${labour.contractorName}, "
//               "Attendance=${labour.attendance_only}, "
//               "Category=${labour.labourCategory}");
//         }
//
//         totalPresent = filteredLabours.where((labour) => labour.attendance_only == "P").length; // Calculate total present
//
//
//         AppLogger.info("✅ [SUCCESS] Labour Attendance Data loaded successfully.");
//       } else {
//         AppLogger.warn("⚠️ [EMPTY] No Labour Attendance Data returned from API.");
//       }
//     } catch (e, stackTrace) {
//       AppLogger.error("❌ [EXCEPTION] Error while fetching Labour Attendance Data: $e");
//       AppLogger.debug("🧯 StackTrace: $stackTrace");
//     } finally {
//       if (!mounted) return;
//       setState(() {
//         isLoading = false;
//       });
//       AppLogger.info("✅ [END] Labour Attendance data load process completed.");
//     }
//   }
//
//   // Filter Labour Attendance based on search inputs
//   void filterLabours() {
//     String labourName = labourController.text.toLowerCase();
//     String contractorName = contractorController.text.toLowerCase();
//     String mobileNumber = mobileController.text.toLowerCase();
//
//     setState(() {
//       filteredLabours = labourAttendanceList.where((labour) {
//         String name = labour.labourName.toLowerCase();
//         String company = labour.contractorName.toLowerCase();
//         String contact = labour.labourID.toString().toLowerCase(); // Adjust as necessary for the contact field
//
//         return (labourName.isEmpty || name.contains(labourName)) &&
//             (contractorName.isEmpty || company.contains(contractorName)) &&
//             (mobileNumber.isEmpty || contact.contains(mobileNumber));
//       }).toList();
//     });
//   }
//
//   // Clear all filters
//   void clearFilters() {
//     setState(() {
//       labourController.clear();
//       contractorController.clear();
//       mobileController.clear();
//       filteredLabours = List.from(labourAttendanceList);
//       totalPresent = filteredLabours.where((labour) => labour.attendance_only == "P").length;
//     });
//   }
//
//   // Refresh Labour Data (simulate reload)
//   Future<void> _refreshLabours() async {
//     setState(() => isLoading = true);
//     await Future.delayed(const Duration(seconds: 1));
//     setState(() => isLoading = false);
//   }
//
//   // Show filter bottom sheet
//   void _showFilterBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           height: 450,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('CANCEL', style: TextStyle(color: Colors.red)),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       if (labourController.text.isEmpty &&
//                           contractorController.text.isEmpty &&
//                           mobileController.text.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Please enter at least one filter value!'), backgroundColor: Colors.red),
//                         );
//                         return;
//                       }
//                       filterLabours();
//                       Navigator.pop(context);
//                     },
//                     child: const Text('SEARCH', style: TextStyle(color: Colors.blue)),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               _buildFilterInputField("Labour Name", labourController),
//               _buildFilterInputField("Contractors Name", contractorController),
//               _buildFilterInputField("Mobile Number", mobileController),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: clearFilters,
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
//                 child: const Text('CLEAR FILTERS', style: TextStyle(color: Colors.black)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to create filter input fields
//   Widget _buildFilterInputField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.nunitoSans(fontSize: 14, fontWeight: FontWeight.w600),
//         ),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: label,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int totalPresent = filteredLabours.where((labour) => labour.attendance_only == "P").toList().length;
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.chevron_left, size: 30),
//           color: AppColors.primaryBlue,
//         ),
//         title: Text('Labour Attendance', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.primaryBlackFont)),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list_alt, color: AppColors.primaryBlue),
//             onPressed: () => _showFilterBottomSheet(context),
//           ),
//         ],
//         backgroundColor: AppColors.primaryWhitebg,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshLabours,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   _buildInfoCard(
//                     Icons.calendar_today,
//                     'Date',
//                     selectedDate,
//                     onTap: () => _selectDate(context),
//                   ),
//                   const SizedBox(width: 10),
//                   _buildInfoCard(
//                     Icons.groups,
//                     'Total Present',
//                     '$totalPresent',
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: filteredLabours.length,
//                   itemBuilder: (context, index) {
//                     final labour = filteredLabours[index];
//
//                     return LabourCard(
//                       id: labour.labourID.toString(),
//                       name: labour.labourName,
//                       company: labour.contractorName,
//                       labourCategory: labour.labourCategory,
//                       attendance_only: labour.attendance_only,
//                       labourID: labour.labourID, // Pass as int
//                       labourAttendanceID : labour.LabourAttendanceID,
//                       selectedDate: selectedDate,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ✅ Info Card Widget (Date & Total Present)
//   Widget _buildInfoCard(IconData icon, String title, String value, {VoidCallback? onTap}) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppColors.primaryWhitebg,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryBlue,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: Colors.white, size: 20),
//               ),
//               const SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.nunitoSans(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primaryBlackFont,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     value,
//                     style: GoogleFonts.nunitoSans(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.primaryBlackFont,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
//
//
//
// //
// // class LabourAttendanceScreen extends StatefulWidget {
// //   @override
// //   _LabourAttendanceScreenState createState() => _LabourAttendanceScreenState();
// // }
// //
// // class _LabourAttendanceScreenState extends State<LabourAttendanceScreen> {
// //   List<LabourAttendance> labourAttendanceList = [];
// //   bool isLoading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchLabourAttendanceData();
// //   }
// //
// //   Future<void> _fetchLabourAttendanceData() async {
// //     AppLogger.info("📦 Fetching Labour Attendance Data...");
// //
// //     try {
// //       final fetchedLabours = await LabourAttendanceApiService().fetchLabourAttendance(
// //         pageNumber: 1,
// //         pageSize: 15,
// //       );
// //
// //       setState(() {
// //         labourAttendanceList = fetchedLabours;
// //         isLoading = false;
// //       });
// //
// //       AppLogger.info("✅ Labour Attendance Data fetched: ${fetchedLabours.length} records");
// //     } catch (e, stackTrace) {
// //       AppLogger.error("❌ Error fetching Labour Attendance: $e\n$stackTrace");
// //       setState(() => isLoading = false);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Labour Attendance")),
// //       body: isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : labourAttendanceList.isEmpty
// //           ? Center(child: Text("No Labour Attendance data found"))
// //           : ListView.builder(
// //         itemCount: labourAttendanceList.length,
// //         itemBuilder: (context, index) {
// //           final item = labourAttendanceList[index];
// //           return ListTile(
// //             onTap: () async {
// //               AppLogger.info("🧾 Labour tapped: ID = ${item.labourID ?? 'Unknown'}");
// //
// //               if (item.labourID != null) {
// //                 final record = await LabourAttendanceApiService().fetchLabourAttendanceadd(
// //                   labourID: item.labourID!,
// //                 );
// //                 if (record != null) {
// //                   AppLogger.info("📝 Ready to edit record: $record");
// //
// //                 }
// //               }
// //             },
// //             title: Text(item.contractorName ?? 'No Name'),
// //             subtitle: Text("${item.labourName ?? 'N/A'} - ${item.attendance_only ?? 'N/A'}"),
// //             trailing: Column(
// //               children: [
// //                 Text(item.labourCode ?? 'N/A'),
// //                 Text(item.labourCategory ?? 'N/A'),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
