// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/font_styles.dart';
// import '../../../../core/models/fuel_inward/fuel_inward_models.dart';
// import '../../../../core/network/logger.dart';
// import '../../../../core/services/FuelInward/fuel_inward_api_service.dart';
// import '../../../../core/utils/secure_storage_util.dart';
//
//
// class FuelInward extends StatefulWidget {
//   @override
//   _FuelInwardState createState() => _FuelInwardState();
// }
//
// class _FuelInwardState extends State<FuelInward> {
//   int _selectedIndex = 0; // This will track the selected month index
//   List<FuelPurchase> fuelPurchases = [];
//   bool isLoading = false;
//   String? _projectName;
//
//   // DateTime variables for FromDate and ToDate
//   late DateTime _fromDate;
//   late DateTime _toDate;
//
//   bool hasMoreData = true;
//   int currentPage = 1;
//   final int pageSize = 10;
//
//   final ScrollController _scrollController = ScrollController();
//
//   TextEditingController supplierNameController = TextEditingController();
//   TextEditingController grnNumberController = TextEditingController();
//   TextEditingController inwardDateController = TextEditingController();
//
//   bool isFilterApplied = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _setDefaultMonth();
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
//           !isLoading &&
//           hasMoreData) {
//         AppLogger.info('Scrolled to bottom -> Fetch more data (page: $currentPage)');
//         fetchFuelPurchases(_fromDate, _toDate, loadMore: true);
//       }
//     });
//
//     _fetchStoredProject();
//   }
//
//   void _setDefaultMonth() {
//     final now = DateTime.now();
//     final firstDayOfMonth = DateTime(now.year, now.month, 1);
//     final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
//
//     _fromDate = firstDayOfMonth;
//     _toDate = lastDayOfMonth;
//     _selectedIndex = now.month - 1;
//
//     AppLogger.info('Setting default month: From ${_fromDate.toIso8601String()} To ${_toDate.toIso8601String()}');
//     fetchFuelPurchases(_fromDate, _toDate);
//   }
//
//   Future<void> fetchFuelPurchases(DateTime fromDate, DateTime toDate, {bool loadMore = false}) async {
//     if (isLoading) return;
//
//     setState(() => isLoading = true);
//
//     if (!loadMore) {
//       currentPage = 1;
//       hasMoreData = true;
//       fuelPurchases.clear();
//     }
//
//     AppLogger.info('Fetching fuel purchases: Page $currentPage | From: ${fromDate.toIso8601String()} | To: ${toDate.toIso8601String()} | Filters - Supplier: ${supplierNameController.text}, GRN: ${grnNumberController.text}, Inward Date: ${inwardDateController.text}');
//
//     try {
//       final data = await FuelInwardApiService().fetchFuelPurchaseList(
//         fromDate: fromDate,
//         toDate: toDate,
//         pageNumber: currentPage,
//         pageSize: pageSize,
//         supplierName: supplierNameController.text.isNotEmpty ? supplierNameController.text : null,
//         grnNumber: grnNumberController.text.isNotEmpty ? grnNumberController.text : null,
//         inwardDate: inwardDateController.text.isNotEmpty
//             ? DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(inwardDateController.text))
//             : null,
//       );
//
//       setState(() {
//         fuelPurchases.addAll(data);
//         isLoading = false;
//         hasMoreData = data.length == pageSize;
//         if (hasMoreData) currentPage++;
//       });
//
//       AppLogger.info('Fetched ${data.length} records. Total loaded: ${fuelPurchases.length}');
//     } catch (e) {
//       AppLogger.info('Failed to fetch fuel purchases: $e');
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _openFilterDialog() async {
//     AppLogger.info('Opening filter dialog...');
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => Padding(
//         padding: MediaQuery.of(context).viewInsets,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: supplierNameController,
//                 decoration: const InputDecoration(labelText: 'Supplier Name'),
//               ),
//               TextField(
//                 controller: grnNumberController,
//                 decoration: const InputDecoration(labelText: 'GRN Number'),
//               ),
//               TextField(
//                 controller: inwardDateController,
//                 readOnly: true,
//                 decoration: const InputDecoration(labelText: 'Inward Date'),
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (pickedDate != null) {
//                     inwardDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
//                     AppLogger.info('Selected Inward Date: ${inwardDateController.text}');
//                   }
//                 },
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     isFilterApplied = supplierNameController.text.isNotEmpty ||
//                         grnNumberController.text.isNotEmpty ||
//                         inwardDateController.text.isNotEmpty;
//                   });
//                   Navigator.pop(context);
//                   AppLogger.info('Applying filters...');
//                   fetchFuelPurchases(_fromDate, _toDate);
//                 },
//                 child: const Text('Apply Filter'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   supplierNameController.clear();
//                   grnNumberController.clear();
//                   inwardDateController.clear();
//                   setState(() {
//                     isFilterApplied = false;
//                   });
//                   Navigator.pop(context);
//                   AppLogger.info('Clearing filters...');
//                   fetchFuelPurchases(_fromDate, _toDate);
//                 },
//                 child: const Text('Clear Filter'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   DateTimeRange _getDateRangeForMonth(int monthIndex) {
//     final year = DateTime.now().year;
//     final firstDay = DateTime(year, monthIndex + 1, 1);
//     final lastDay = DateTime(year, monthIndex + 2, 0);
//     return DateTimeRange(start: firstDay, end: lastDay);
//   }
//
//   int _selectedYear = DateTime.now().year;
//
//   // Fetch the stored project name and ID
//   Future<void> _fetchStoredProject() async {
//     try {
//       final projectName = await SecureStorageUtil.readSecureData("ActiveProjectName");
//       setState(() {
//         _projectName = projectName;
//       });
//
//       // Log the fetched project name (for debugging)
//       if (_projectName != null) {
//         AppLogger.info("Fetched Active Project: $_projectName");
//       }
//     } catch (e) {
//       AppLogger.error("Error fetching project from secure storage: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.chevron_left, size: 30),
//           color: AppColors.primaryBlue,
//         ),
//         title: Column(
//           children: [
//             Text(
//               'FuelInward',
//               style: FontStyles.bold700.copyWith(
//                 color: AppColors.primaryBlackFont,
//                 fontSize: 18,
//               ),
//             ),
//             Text(
//               _projectName ?? 'No Project Selected',
//               style: FontStyles.bold700.copyWith(
//                 color: AppColors.primaryBlackFont,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: IconButton(
//               icon: SvgPicture.asset(
//                 'assets/icons/menu-icon/filter-search-with-mg.svg',
//                 color: AppColors.primary,
//                 height: 30,
//                 width: 30,
//               ),
//               onPressed: _openFilterDialog,
//             ),
//           ),
//         ],
//         backgroundColor: AppColors.primaryWhitebg,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               _buildBalanceCard(),
//               const SizedBox(height: 10),
//               _buildMonthChips(),
//               const SizedBox(height: 10),
//               _buildFuelPurchaseList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Build the balance cards with dynamic values
//   Widget _buildBalanceCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildBalanceCardItem("Available Stock", "11546.00 Ltr."),
//           _buildBalanceCardItem("Total Inwarded", "11546.00 Ltr."),
//         ],
//       ),
//     );
//   }
//
//   // A reusable widget to build individual balance cards
//   Widget _buildBalanceCardItem(String title, String value) {
//     return Container(
//       width: 170,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.primaryWhitebg,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: AppColors.primaryBlue,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Center(
//               child: SvgPicture.asset(
//                 'assets/icons/Petty-Cash-ICON-SVG.svg',
//                 height: 16,
//                 width: 16,
//                 colorFilter: const ColorFilter.mode(
//                   AppColors.white,
//                   BlendMode.srcIn,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: GoogleFonts.nunitoSans(fontSize: 10),
//               ),
//               Text(
//                 value,
//                 style: GoogleFonts.nunitoSans(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Build dynamic month chips
//   Widget _buildMonthChips() {
//     final months = [
//       "Jan", "Feb", "Mar", "Apr", "May", "Jun",
//       "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
//     ];
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: const Offset(0, 4),
//             ),
//             BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 2,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: SizedBox(
//           height: 30,
//           child: ListView.separated(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             scrollDirection: Axis.horizontal,
//             itemCount: months.length,
//             separatorBuilder: (context, index) => const SizedBox(width: 8),
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _selectedIndex = index;
//                   });
//
//                   final dateRange = _getDateRangeForMonth(index);
//                   fetchFuelPurchases(dateRange.start, dateRange.end);
//                 },
//                 child: _buildMonthChip(months[index], index == _selectedIndex),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Build month chip dynamically
//   Widget _buildMonthChip(String month, bool isSelected) {
//     return Container(
//       height: 35,
//       margin: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: isSelected ? AppColors.primaryBlue : const Color(0xFFF5F1FF),
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: const Color(0xFFE5E5E5)),
//       ),
//       child: Text(
//         month,
//         style: GoogleFonts.nunitoSans(
//           color: isSelected ? Colors.white : AppColors.primaryBlue,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   // Dynamically build the fuel purchase list
//   Widget _buildFuelPurchaseList() {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return ListView.builder(
//       itemCount: fuelPurchases.length,
//       shrinkWrap: true,
//       physics: const BouncingScrollPhysics(),
//       itemBuilder: (context, index) {
//        // return FuelPurchaseCard(fuelPurchase: fuelPurchases[index]); // Ensure FuelPurchaseCard is defined properly
//         return  Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(14),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                   offset: const Offset(0, 4),
//                 ),
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.03),
//                   blurRadius: 2,
//                   offset: const Offset(0, 1),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 16, left: 15),
//                         child: Text(
//                          // 'Tds Payable',
//                           fuelPurchases[index].supplierName,
//                           style: FontStyles.bold700.copyWith(
//                             fontSize: 18,
//                             color: AppColors.primaryBlackFont,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Column(
//                       children: [
//                         Container(
//                           // height: 40,
//                           // width: 40,
//                           // alignment: Alignment.center,
//                           // decoration: BoxDecoration(
//                           //   color: AppColors.primaryWhitebg,
//                           //   borderRadius: BorderRadius.only(
//                           //     topRight: Radius.circular(12),
//                           //     bottomLeft: Radius.circular(12),
//                           //   ),
//                           //   boxShadow: [
//                           //     BoxShadow(
//                           //       color: Colors.black.withOpacity(0.1),
//                           //       blurRadius: 4,
//                           //       spreadRadius: 1,
//                           //       offset: Offset(0, 2),
//                           //     ),
//                           //   ],
//                           // ),
//                           child: Text(
//                             //'1',
//                             fuelPurchases[index].grnNumber,
//                             style: FontStyles.bold700.copyWith(
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 10,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/icons/pad-icon.svg',
//                             height: 16,
//                             width: 16,
//                             colorFilter: const ColorFilter.mode(
//                               AppColors.primaryBlue,
//                               BlendMode.srcIn,
//                             ),
//                           ),
//                           const SizedBox(width: 2),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4),
//                             child: Text(
//                               fuelPurchases[index].unit.toString(),
//                               style: FontStyles.medium500.copyWith(
//                                 fontSize: 12,
//                                 color: AppColors.primaryLightGrayFont,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/icons/calendar-right-svg.svg',
//                             height: 16,
//                             width: 16,
//                             colorFilter: const ColorFilter.mode(
//                               AppColors.primaryBlue,
//                               BlendMode.srcIn,
//                             ),
//                           ),
//                           const SizedBox(width: 2),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4),
//                            child: Text(
//                              DateFormat('yyyy-MM-dd HH:mm:ss').format(fuelPurchases[index].purchaseDate),
//                              style: FontStyles.medium500.copyWith(
//                                fontSize: 12,
//                                color: AppColors.primaryLightGrayFont,
//                              ),
//                            ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ); // Ensure FuelPurchaseCard is defined properly
//       },
//     );
//   }
//
//   // Show filter bottom sheet for additional filters
//   void _showFilterBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Select Date Range',
//                 style: GoogleFonts.nunitoSans(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               // Add date range picker or other filter widgets here
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:inniti_constro/core/services/FuelInward/fuel_inward_api_service.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/font_styles.dart';
import '../../../../../core/models/fuel_inward/fuel_inward_models.dart';
import '../../../../../core/network/logger.dart';
import '../../../../../core/utils/secure_storage_util.dart';
import '../FuelInwardMode.dart';
import '../addFuelInwardPage/add_fuel_inwardPage.dart';

class FuelInward extends StatefulWidget {
  const FuelInward({super.key});

  @override
  State<FuelInward> createState() => _FuelInwardState();
}

class _FuelInwardState extends State<FuelInward> {
  late DateTime _fromDate;
  late DateTime _toDate;
  int _selectedIndex = 0;
  String? _projectName;
  List<FuelPurchase> fuelPurchases = [];
  bool isLoading = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final int pageSize = 10;

  final ScrollController _scrollController = ScrollController();

  TextEditingController supplierNameController = TextEditingController();
  TextEditingController grnNumberController = TextEditingController();
  TextEditingController inwardDateController = TextEditingController();

  bool isFilterApplied = false;

  @override
  void initState() {
    super.initState();
    _setDefaultMonth();

    _scrollController.addListener((){
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          hasMoreData) {
        AppLogger.info('Scrolled to bottom -> Fetch more data (page: $currentPage)');
        fetchFuelPurchases(_fromDate, _toDate, loadMore: true);
      }
    });

    _fetchStoredProject();
  }

    // Fetch the stored project name and ID
  Future<void> _fetchStoredProject() async {
    try {
      final projectName = await SecureStorageUtil.readSecureData("ActiveProjectName");
      setState(() {
        _projectName = projectName;
      });

      // Log the fetched project name (for debugging)
      if (_projectName != null) {
        AppLogger.info("Fetched Active Project: $_projectName");
      }
    } catch (e) {
      AppLogger.error("Error fetching project from secure storage: $e");
    }
  }

  void _setDefaultMonth() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    _fromDate = firstDayOfMonth;
    _toDate = lastDayOfMonth;
    _selectedIndex = now.month - 1;

    AppLogger.info('Setting default month: From ${_fromDate.toIso8601String()} To ${_toDate.toIso8601String()}');
    fetchFuelPurchases(_fromDate, _toDate);
  }

  Future<void> fetchFuelPurchases(DateTime fromDate, DateTime toDate, {bool loadMore = false}) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    if (!loadMore) {
      currentPage = 1;
      hasMoreData = true;
      fuelPurchases.clear();
    }

    AppLogger.info('Fetching fuel purchases: Page $currentPage | From: ${fromDate.toIso8601String()} | To: ${toDate.toIso8601String()} | Filters - Supplier: ${supplierNameController.text}, GRN: ${grnNumberController.text}, Inward Date: ${inwardDateController.text}');

    try {
      final data = await FuelInwardApiService().fetchFuelPurchaseList(
        fromDate: fromDate,
        toDate: toDate,
        pageNumber: currentPage,
        pageSize: pageSize,
        supplierName: supplierNameController.text.isNotEmpty ? supplierNameController.text : null,
        grnNumber: grnNumberController.text.isNotEmpty ? grnNumberController.text : null,
        inwardDate: inwardDateController.text.isNotEmpty
            ? DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(inwardDateController.text))
            : null,
      );

      setState(() {
        fuelPurchases.addAll(data);
        isLoading = false;
        hasMoreData = data.length == pageSize;
        if (hasMoreData) currentPage++;
      });

      AppLogger.info('Fetched ${data.length} records. Total loaded: ${fuelPurchases.length}');
    } catch (e) {
      AppLogger.info('Failed to fetch fuel purchases: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _openFilterDialog() async {
    AppLogger.info('Opening filter dialog...');
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Supplier Name",
                style: FontStyles.semiBold600.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlackFont,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: supplierNameController,
                decoration: const InputDecoration(
                    fillColor: AppColors.primaryWhitebg,
                    labelText: 'Supplier Name'),
              ),
              const SizedBox(height: 12),

              Text(
                "GRN Number",
                style: FontStyles.semiBold600.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlackFont,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: grnNumberController,
                decoration: const InputDecoration(
                    fillColor: AppColors.primaryWhitebg,
                    labelText: 'GRN Number'),
              ),
              const SizedBox(height: 12),

              Text(
                "Inward Date",
                style: FontStyles.semiBold600.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlackFont,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: inwardDateController,
                readOnly: true,
                decoration: const InputDecoration(
                    fillColor: AppColors.primaryWhitebg,
                    labelText: 'Inward Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    inwardDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                    AppLogger.info('Selected Inward Date: ${inwardDateController.text}');
                  }
                },
              ),
              const SizedBox(height: 12),

              const Spacer(), // Pushes the buttons to the bottom
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isFilterApplied = supplierNameController.text.isNotEmpty ||
                              grnNumberController.text.isNotEmpty ||
                              inwardDateController.text.isNotEmpty;
                        });
                        Navigator.pop(context);
                        AppLogger.info('Applying filters...');
                        fetchFuelPurchases(_fromDate, _toDate);
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
                      onPressed: () {
                        supplierNameController.clear();
                        grnNumberController.clear();
                        inwardDateController.clear();
                        setState(() {
                          isFilterApplied = false;
                        });
                        Navigator.pop(context);
                        AppLogger.info('Clearing filters...');
                        fetchFuelPurchases(_fromDate, _toDate);
                      },
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


  /// Helper to get start & end date for month/year
  DateTimeRange _getDateRangeForMonth(int monthIndex, int year) {
    final start = DateTime(year, monthIndex + 1, 1);
    final end = DateTime(year, monthIndex + 2, 0); // Last day of month
    return DateTimeRange(start: start, end: end);
  }

  int _selectedYear = DateTime.now().year;
  //int _selectedIndex = DateTime.now().month - 1;

  Widget _buildMonthChips() {
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    final years = List.generate(10, (index) => DateTime.now().year - index); // Last 10 years

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Month Chips (Expandable)
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1A000000), // #0000001A with opacity
                    blurRadius: 4,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: List.generate(months.length, (index) {
                    final isSelected = index == _selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        if (_selectedIndex != index) {
                          setState(() => _selectedIndex = index);
                          final dateRange = _getDateRangeForMonth(index, _selectedYear);
                          _fromDate = dateRange.start;
                          _toDate = dateRange.end;
                          AppLogger.info('Selected Month: ${months[index]} | Year: $_selectedYear | From: ${_fromDate.toIso8601String()} | To: ${_toDate.toIso8601String()}');
                          fetchFuelPurchases(_fromDate, _toDate);
                        }
                      },
                      child: Container(
                        height: 35,

                        margin: const EdgeInsets.symmetric(horizontal: 9),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xffF3EFF9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          months[index],
                          style: FontStyles.bold700.copyWith(
                            color:isSelected ? AppColors.primaryBlue :  AppColors.primaryBlackFont,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Year Dropdown (fixed width)
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1A000000), // #0000001A with opacity
                  blurRadius: 4,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedYear,
                isExpanded: true,     // ✅ Full width for center alignment
                iconSize: 0,          // ✅ Removes icon completely (no default arrow)
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (newYear) {
                  if (newYear != null) {
                    setState(() {
                      _selectedYear = newYear;
                    });
                    final dateRange = _getDateRangeForMonth(_selectedIndex, _selectedYear);
                    _fromDate = dateRange.start;
                    _toDate = dateRange.end;
                    AppLogger.info('Selected Year: $_selectedYear | Month: ${months[_selectedIndex]} | From: ${_fromDate.toIso8601String()} | To: ${_toDate.toIso8601String()}');
                    fetchFuelPurchases(_fromDate, _toDate);
                  }
                },
                selectedItemBuilder: (context) {
                  return years.map((year) {
                    return Center(  // ✅ Center selected item
                      child: Text(
                        year.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _selectedYear == year ? AppColors.primaryBlue : Colors.black87,
                        ),
                      ),
                    );
                  }).toList();
                },
                items: years.map((year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Center(  // ✅ Center dropdown menu item
                      child: Text(
                        year.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _selectedYear == year ? AppColors.primaryBlue : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        ],
      ),
    );
  }



  Widget _buildFuelPurchaseList() {
    if (fuelPurchases.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (fuelPurchases.isEmpty) {
      return const Center(child: Text("No records found."));
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(), // Important to enable pull even when list is short
      itemCount: fuelPurchases.length + (hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < fuelPurchases.length) {
          final item = fuelPurchases[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),


            child: Container(
            //margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x405B21B1), // 40 is hex for 25% opacity
                    offset: Offset(0, 0),     // Matches 0px 0px
                    blurRadius: 14,
                    spreadRadius: -6,         // Negative spread like CSS
                  ),
                ],
              ),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 12, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // height: 40,
                        // width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xffE6E0EF),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(3),
                            bottomLeft: Radius.circular(3),
                            bottomRight:  Radius.circular(3),
                            topLeft:  Radius.circular(3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x405B21B1), // 40 is hex for 25% opacity
                              offset: Offset(0, 0),     // Matches 0px 0px
                              blurRadius: 14,
                              spreadRadius: -6,         // Negative spread like CSS
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                          child: Text(
                            item.grnNumber,
                            style: FontStyles.semiBold600.copyWith(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // height: 40,
                        // width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xffE6E0EF),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(3),
                            bottomLeft: Radius.circular(3),
                            bottomRight:  Radius.circular(3),
                            topLeft:  Radius.circular(3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x405B21B1), // 40 is hex for 25% opacity
                              offset: Offset(0, 0),     // Matches 0px 0px
                              blurRadius: 14,
                              spreadRadius: -6,         // Negative spread like CSS
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Text(
                            item.itemName,
                            style: FontStyles.medium500.copyWith(
                              fontSize: 8,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, left: 15),
                        child: Text(
                          item.supplierName,
                          style: FontStyles.bold700.copyWith(
                            fontSize: 18,
                            color: AppColors.primaryBlackFont,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/continer-icons/clipboard-text.svg',
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(width: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '${item.unit} Ltr.',
                              style: FontStyles.medium500.copyWith(
                                fontSize: 12,
                                color: AppColors.primaryLightGrayFont,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 50,),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/continer-icons/calendar.svg',
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(width: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                           child: Text(
                             DateFormat('yyyy/MM/dd HH:mm:ss').format(item.purchaseDate),
                             style: FontStyles.medium500.copyWith(
                               fontSize: 12,
                               color: AppColors.primaryLightGrayFont,
                             ),
                           ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // onRefresh: () async {
      //   AppLogger.info('Pull to refresh triggered...');
      //   await fetchFuelPurchases(_fromDate, _toDate);
      //
      // },

      onRefresh: () async {
        AppLogger.info('Pull to refresh triggered...');
        try {
          await fetchFuelPurchases(_fromDate, _toDate);

          if (mounted) {
            AppLogger.error('Refresh');
          }
        } catch (e) {

          if (mounted) {
            AppLogger.error('Refresh failed: $e');
          }
        }
      },

      child: Scaffold(
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
              'FuelInward',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: SvgPicture.asset(
                isFilterApplied ? 'assets/icons/menu-icon/filter-search-with-mg.svg' : 'assets/icons/menu-icon/filter-search-without-mg.svg',
                color: AppColors.primary,
                height: 30,
                width: 30,
              ),
              onPressed: _openFilterDialog,
            ),
          ),
        ],
        backgroundColor: AppColors.primaryWhitebg,
      ),

        body: Column(
          children: [
            SizedBox(height: 16,),
            _buildBalanceCard(),
            SizedBox(height: 16,),
            _buildMonthChips(),
            SizedBox(height: 16,),
            Expanded(child: _buildFuelPurchaseList()),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFuelInwardPage(mode: FuelInwardMode.add),
              ),
            );
          },
          backgroundColor: AppColors.primaryBlue,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),

      ),
    );
  }

  // Build the balance cards with dynamic values
  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBalanceCardItem("Available Stock", "11546.00 Ltr."),
          _buildBalanceCardItem("Total Inwarded", "11546.00 Ltr."),
        ],
      ),
    );
  }

  // A reusable widget to build individual balance cards
  Widget _buildBalanceCardItem(String title, String value) {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryWhitebg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/continer-icons/white-clipboard-text.svg',
                height:20,
                width: 20,
                // colorFilter: const ColorFilter.mode(
                //   AppColors.white,
                //   BlendMode.srcIn,
                // ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FontStyles.semiBold600.copyWith(
                  color: AppColors.primaryBlackFontWithOpps40,
                  fontSize: 10,
                ),
              ),
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
    );
  }

}

