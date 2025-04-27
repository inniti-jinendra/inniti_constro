import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/models/LabourAttendance/LabourAttendance.dart';
import '../../../../../core/network/logger.dart';
import '../../../../../core/services/LabourAttendance/labour_attendance_api_service.dart';
import 'labord_card_page.dart';


class LabourAttendancePage extends StatefulWidget {
  const LabourAttendancePage({super.key});

  @override
  State<LabourAttendancePage> createState() => _LabourAttendancePageState();
}

class _LabourAttendancePageState extends State<LabourAttendancePage> {
  // Controllers for the text fields
  TextEditingController labourController = TextEditingController();
  TextEditingController contractorController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  bool isLoading = false;
  bool isEndOfData = false;
  int currentPage = 1;
  int pageSize = 10;
  ScrollController _scrollController = ScrollController();

  List<LabourAttendance> labourAttendanceList = []; // Initialize to an empty list
  List<LabourAttendance> filteredLabours = []; // Initialize to an empty list

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //String selectedDate = '2025-04-11'; // Set a default date or get today's date
  int totalPresent = 0; // Track total present count

  // void _selectDate(BuildContext context) async {
  //   final DateTime today = DateTime.now();
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: today, // current date
  //     firstDate: DateTime(2000), // allow past dates
  //     lastDate: today, // disallow future dates
  //   );
  //
  //   if (picked != null && picked != DateTime.parse(selectedDate)) {
  //     setState(() {
  //       selectedDate = DateFormat('yyyy-MM-dd').format(picked);
  //     });
  //
  //     AppLogger.info("📅 Date changed to $selectedDate, re-fetching data...");
  //     _fetchLabourAttendanceData(); // 🟢 Trigger API call when date changes
  //
  //   }
  // }

  void _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(selectedDate), // keep selected date
      firstDate: DateTime(2000),
      lastDate: today,
    );

    if (picked != null) {
      final String pickedDate = DateFormat('yyyy-MM-dd').format(picked);

      // Only call API if the date actually changed
      if (pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
          currentPage = 1;
          isEndOfData = false;
          filteredLabours.clear(); // clear previous list
        });

        AppLogger.info("📅 Date changed to $selectedDate, fetching new data...");
        _fetchLabourAttendanceData();
      } else {
        AppLogger.info("ℹ️ Same date selected: $selectedDate — keeping existing data.");
      }
    }
  }


  // This is called when the user scrolls to the end of the list
  void _onScroll() {
    if (_scrollController.position.atEdge) {
      // If the scroll is at the bottom, load the next page
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!isLoading && !isEndOfData) {
          _fetchLabourAttendanceData(); // Trigger next page load when reaching bottom
        }
      }
    }
  }

  Future<void> _fetchLabourAttendanceData() async {
    if (isLoading) return; // Avoid multiple simultaneous API calls

    setState(() {
      isLoading = true;
    });

    try {
      AppLogger.debug("📦 Fetching Labour Attendance data for Page: $currentPage");

      List<LabourAttendance> fetchedLabours = await LabourAttendanceApiService().fetchLabourAttendance(
        pageNumber: currentPage,
        pageSize: pageSize,
        labourName: null,
        contractorName: null,
        date: selectedDate,
      );

      if (fetchedLabours.isNotEmpty) {
        setState(() {
          currentPage++; // Increment to fetch the next page in the future
          filteredLabours.addAll(fetchedLabours); // Add new items to the list
        });
      } else {
        setState(() {
          isEndOfData = true; // No more data
        });
      }

      AppLogger.debug("📊 Fetched ${fetchedLabours.length} records. Total records: ${filteredLabours.length}");

    } catch (e) {
      AppLogger.error("❌ Error fetching Labour Attendance data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLabourAttendanceData(); // Fetch Labour Data as soon as the page is initialized
    // Add listener to scroll controller
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    //_scrollController.removeListener(_onScroll); // Remove the listener when disposed
    _scrollController.dispose();
    super.dispose();
  }

  void filterLabours() {
    String labourName = labourController.text.toLowerCase();
    String contractorName = contractorController.text.toLowerCase();
    String mobileNumber = mobileController.text.toLowerCase();

    setState(() {
      filteredLabours = labourAttendanceList.where((labour) {
        String name = labour.labourName.toLowerCase();
        String company = labour.contractorName.toLowerCase();
        String contact = labour.labourID.toString().toLowerCase(); // Adjust as necessary for the contact field

        return (labourName.isEmpty || name.contains(labourName)) &&
            (contractorName.isEmpty || company.contains(contractorName)) &&
            (mobileNumber.isEmpty || contact.contains(mobileNumber));
      }).toList();
    });
  }

  // Clear all filters
  void clearFilters() {
    setState(() {
      labourController.clear();
      contractorController.clear();
      mobileController.clear();
      filteredLabours = List.from(labourAttendanceList);
      totalPresent = filteredLabours.where((labour) => labour.attendance == "P").length;
    });
  }

  // Refresh Labour Data (simulate reload)
  Future<void> _refreshLabours() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
  }

  // Show filter bottom sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (labourController.text.isEmpty &&
                          contractorController.text.isEmpty &&
                          mobileController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter at least one filter value!'), backgroundColor: Colors.red),
                        );
                        return;
                      }
                      filterLabours();
                      Navigator.pop(context);
                    },
                    child: const Text('SEARCH', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildFilterInputField("Labour Name", labourController),
              _buildFilterInputField("Contractors Name", contractorController),
              _buildFilterInputField("Mobile Number", mobileController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: clearFilters,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                child: const Text('CLEAR FILTERS', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create filter input fields
  Widget _buildFilterInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunitoSans(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPresent = filteredLabours.where((labour) => labour.attendance == "P").toList().length;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 30),
          color: AppColors.primaryBlue,
        ),
        title: Text('Labour Attendance', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.primaryBlackFont)),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_alt, color: AppColors.primaryBlue),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
        backgroundColor: AppColors.primaryWhitebg,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshLabours,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  _buildInfoCard(
                    Icons.calendar_today,
                    'Date',
                    selectedDate,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(width: 10),
                  _buildInfoCard(
                    Icons.groups,
                    'Total Present',
                    '$totalPresent',
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,  // Attach the scroll controller here
                  physics: const AlwaysScrollableScrollPhysics(),
                 // physics: const BouncingScrollPhysics(),
                 // itemCount: filteredLabours.length,
                  itemCount: filteredLabours.length + (isLoading ? 1 : 0),
                  // itemBuilder: (context, index) {
                  //   final labour = filteredLabours[index];

                  itemBuilder: (context, index) {
                    // If the index is at the last item, show the loader
                    if (index == filteredLabours.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),  // Loader at the bottom
                      );
                    }

                    final labour = filteredLabours[index];

                    // Map attendance status to text
                    String attendanceText = "";
                    switch (labour.attendance) {
                      case "P":
                        attendanceText = "Present";
                        break;
                      case "A":
                        attendanceText = "Absent";
                        break;
                      case "U":
                        attendanceText = "Unavailable";
                        break;
                      default:
                        attendanceText = "Unknown";
                        break;
                    }

                    return LabourCardNew(
                      id: labour.labourID.toString(),
                      name: labour.labourName,
                      company: labour.contractorName,
                      labourCategory: labour.labourCategory,
                      //attendance: labour.attendance,
                      attendance: _getAttendanceStatus(labour.attendance), // not just labour.attendance
                      labourID: labour.labourID, // Pass as int
                      labourAttendanceID : labour.LabourAttendanceID,
                      selectedDate: selectedDate,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Info Card Widget (Date & Total Present)
  Widget _buildInfoCard(IconData icon, String title, String value, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryWhitebg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlackFont,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlackFont,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAttendanceStatus(String? status) {
    switch (status) {
      case 'P':
        return 'Present';
      case 'A':
        return 'Absent';
      case 'U':
        return 'Unavailable';
      default:
        return 'Unknown';
    }
  }


}


