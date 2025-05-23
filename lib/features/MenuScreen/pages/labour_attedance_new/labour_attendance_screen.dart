import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/models/LabourAttendance/LabourAttendance.dart';
import '../../../../../core/network/logger.dart';
import '../../../../../core/services/LabourAttendance/labour_attendance_api_service.dart';
import '../../../../core/constants/font_styles.dart';
import '../../../../core/utils/secure_storage_util.dart';
import 'labord_card_page.dart';

class LabourAttendancePage extends StatefulWidget {
  const LabourAttendancePage({super.key});

  @override
  State<LabourAttendancePage> createState() => _LabourAttendancePageState();
}

class _LabourAttendancePageState extends State<LabourAttendancePage> {
  String? _projectName;

  // Controllers for the text fields
  TextEditingController labourController = TextEditingController();
  TextEditingController contractorController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool isFilterApplied = false;


  bool isLoading = false;
  bool isEndOfData = false;
  int currentPage = 1;
  int pageSize = 10;
  ScrollController _scrollController = ScrollController();

  List<LabourAttendance> labourAttendanceList =
      []; // Initialize to an empty list
  List<LabourAttendance> filteredLabours = []; // Initialize to an empty list

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //String selectedDate = '2025-04-11'; // Set a default date or get today's date
  int totalPresent = 0; // Track total present count

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

        AppLogger.info(
            "📅 Date changed to $selectedDate, fetching new data...");
        _fetchLabourAttendanceData();
      } else {
        AppLogger.info(
            "ℹ️ Same date selected: $selectedDate — keeping existing data.");
      }
    }
  }

  // This is called when the user scrolls to the end of the list
  void _onScroll() {
    if (_scrollController.position.atEdge) {
      // If the scroll is at the bottom, load the next page
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
      AppLogger.debug(
          "📦 Fetching Labour Attendance data for Page: $currentPage");

      List<LabourAttendance> fetchedLabours =
          await LabourAttendanceApiService().fetchLabourAttendance(
        pageNumber: currentPage,
        pageSize: pageSize,
        labourName: null,
        contractorName: null,
        date: selectedDate,
      );

      if (fetchedLabours.isNotEmpty) {
        fetchedLabours.forEach((labour) {
          AppLogger.debug(
              "Fetched Labour: Attendance=${labour.attendance}, presnet =${labour.totalPresent}");
        });

        if (fetchedLabours.isNotEmpty) {
          setState(() {
            if (currentPage == 1) {
              totalPresent =
                  fetchedLabours.first.totalPresent ?? 0; // ✅ Set from 1st item
            }
            currentPage++;
            filteredLabours.addAll(fetchedLabours);
          });
        } else {
          setState(() {
            isEndOfData = true;
          });
        }
      } else {
        setState(() {
          isEndOfData = true; // No more data
        });
      }

      AppLogger.debug(
          "📊 Fetched ${fetchedLabours.length} records. Total records: ${filteredLabours.length}");
    } catch (e) {
      AppLogger.error("❌ Error fetching Labour Attendance data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchLabourAttendanceDataFilter() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      AppLogger.debug(
          "📦 Fetching Labour Attendance data for Page: $currentPage");

      final labourNameFilter =
          labourController.text.isEmpty ? null : labourController.text;
      final contractorNameFilter =
          contractorController.text.isEmpty ? null : contractorController.text;

      List<LabourAttendance> fetchedLabours =
          await LabourAttendanceApiService().fetchLabourAttendance(
        pageNumber: currentPage,
        pageSize: pageSize,
        labourName: labourNameFilter,
        contractorName: contractorNameFilter,
        date: selectedDate,
      );

      if (fetchedLabours.isNotEmpty) {
        for (var labour in fetchedLabours) {
          AppLogger.debug(
              "✅ Fetched Labour: ${labour.labourName}, Attendance=${labour.attendance}, Present=${labour.totalPresent}");
        }

        setState(() {
          if (currentPage == 1) {
            filteredLabours.clear();
            totalPresent = fetchedLabours.first.totalPresent ?? 0;
          }
          currentPage++;
          filteredLabours.addAll(fetchedLabours);
        });
      } else {
        setState(() {
          isEndOfData = true;
        });
      }

      AppLogger.debug(
          "📊 Total records after filter: ${filteredLabours.length}");
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
    _fetchStoredProject();
    _fetchLabourAttendanceData(); // Fetch Labour Data as soon as the page is initialized
    _fetchLabourAttendanceDataFilter(); // Fetch Labour Data as soon as the page is initialized
    // Add listener to scroll controller
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    //_scrollController.removeListener(_onScroll); // Remove the listener when disposed
    _scrollController.dispose();
    super.dispose();
  }

  // Fetch the stored project name and ID
  Future<void> _fetchStoredProject() async {
    try {
      final projectName =
          await SecureStorageUtil.readSecureData("ActiveProjectName");
      setState(() {
        _projectName = projectName;
      });

      // Log the fetched project name (for debugging)
      if (_projectName != null) {
        AppLogger.info(
            "Fetched Active Project on Labor Master Attedance: $_projectName");
      }
    } catch (e) {
      AppLogger.error("Error fetching project from secure storage: $e");
    }
  }

  void filterLabours() {
    String labourName = labourController.text.toLowerCase();
    String contractorName = contractorController.text.toLowerCase();

    setState(() {
      filteredLabours = labourAttendanceList.where((labour) {
        String name = labour.labourName.toLowerCase();
        String company = labour.contractorName.toLowerCase();

        return (labourName.isEmpty || name.contains(labourName)) &&
            (contractorName.isEmpty || company.contains(contractorName));
      }).toList();
    });
  }

  // Clear all filters
  void clearFilters() {
    setState(() {
      currentPage = 1;
      isEndOfData = false;
      filteredLabours.clear();
      labourAttendanceList.clear();
      _fetchLabourAttendanceData(); // Re-fetch default data

      labourController.clear();
      contractorController.clear();

      filteredLabours = List.from(labourAttendanceList);
      totalPresent =
          filteredLabours.where((labour) => labour.attendance == "P").length;
    });
    Navigator.pop(context);
      isFilterApplied = false; // 🔴 Filters are active
  }

  // Refresh Labour Data (simulate reload)
  Future<void> _refreshLabours() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    _fetchLabourAttendanceData();
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
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Color(0x665B21B1), // Semi-transparent purple shadow
                blurRadius: 14,
                spreadRadius: -6,
                offset: Offset(0, 0),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          height: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterInputField("Labour Name", labourController),
              _buildFilterInputField("Contractors Name", contractorController),
              const Spacer(), // Pushes the buttons to the bottom
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (labourController.text.isEmpty &&
                            contractorController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter at least one filter value!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          isFilterApplied = true; // 🔴 Filters are active
                        });

                        setState(() {
                          currentPage = 1;
                          isEndOfData = false;
                          filteredLabours.clear();
                        });

                        _fetchLabourAttendanceDataFilter();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'SEARCH',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: clearFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffebcfcf),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'CLEAR FILTERS',
                        style: TextStyle(color: Color(0xffb55252)),
                      ),
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

// Helper method to create filter input fields
  Widget _buildFilterInputField(String label, TextEditingController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: FontStyles.semiBold600.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlackFont,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              fillColor: AppColors.primaryWhitebg,
              hintText: label,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // int totalPresent = filteredLabours.where((labour) => labour.attendance_only == "P").toList().length;
    //int totalPresent = fetchedLabours.isNotEmpty ? (fetchedLabours.first.totalPresent ?? 0) : 0;

    // int totalPresent = filteredLabours.forEach((labour) => labour.totalPresent.toString();

    filteredLabours.forEach((labour) {
      AppLogger.info("Total Present: ${labour.totalPresent}");
    });

    // Log the total present count
    AppLogger.info("🖨️ Total Present in build: $totalPresent");

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            "assets/icons/setting/LeftArrow.svg",
          ),
          color: AppColors.primaryBlue,
        ),
        title: Column(
          children: [
            Text(
              'Labour Master',
              style: FontStyles.bold700.copyWith(
                color: AppColors.primaryBlackFont,
                fontSize: 18,
              ),
            ),
            Text(
              _projectName ?? 'No Project Selected',
              style: FontStyles.bold700.copyWith(
                color: AppColors.primaryBlackFont,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              isFilterApplied ? 'assets/icons/menu-icon/filter-search-with-mg.svg' : 'assets/icons/menu-icon/filter-search-without-mg.svg',
              color: AppColors.primary,
              height: 30,
              width: 30,
            ),
            onPressed: () => _showFilterBottomSheet(context), // isFilterApplied
          ),
        ],
        backgroundColor: AppColors.primaryWhitebg,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshLabours,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 20, right: 12,),
              child: Row(
                children: [
                  _buildInfoCard(
                   "assets/icons/attendance/date-calendar.svg",
                    'Date',
                    selectedDate,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(width: 10),
                  _buildInfoCard(
                    "assets/icons/attendance/profile-tick-white.svg",
                    'Total Present',
                    '$totalPresent',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                // Attach the scroll controller here
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
                      child: Center(
                          child:
                              CircularProgressIndicator()), // Loader at the bottom
                    );
                  }

                  final labour = filteredLabours[index];

                  // Log each labour item being rendered
                  AppLogger.info(
                      'Rendering Labour: totalPresent=${labour.totalPresent},');
                  AppLogger.info(
                      'Rendering Labour: totalPresent=${labour.totalPresent},');

                  // Map attendance status to text
                  String attendanceText = "";
                  switch (labour.attendance) {
                    case "P":
                      attendanceText = "PRESENT";
                      break;
                    case "A":
                      attendanceText = "ABSENT";
                      break;
                    case "U":
                      attendanceText = "UNAVAILABLE";
                      break;
                    default:
                      attendanceText = "Unknown";
                      break;
                  }

                  final status = _getAttendanceStatus(labour.attendance);
                  AppLogger.info("Rendering Labour:=> ID=${labour.labourID}, AttendanceRaw=${labour.attendance}, Status=$status, Enabled=${status != 'U'}");

                  return LabourCardNew(
                    id: labour.labourID.toString(),
                    name: labour.labourName,
                    company: labour.contractorName,
                    labourCategory: labour.labourCategory,
                    //attendance: labour.attendance,
                    attendance: _getAttendanceStatus(labour.attendance),
                    // not just labour.attendance
                    labourID: labour.labourID,
                    labourAttendanceID: labour.LabourAttendanceID,
                    selectedDate: selectedDate,
                    enabled: _getAttendanceStatus(labour.attendance) != 'U',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Info Card Widget (Date & Total Present)
  Widget _buildInfoCard(String iconPath, String title, String value,
      {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryWhitebg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child:Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    iconPath,
                    height: 20,
                    width: 20,
                  ),
                ),
                //child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FontStyles.semiBold600.copyWith(
                      //color: Color(0xff959497),
                      color: AppColors.primaryBlackFontWithOpps40,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: FontStyles.bold700.copyWith(
                      color: AppColors.primaryBlackFont,
                      fontSize: 12,
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
