// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../../../core/models/labour/labor.dart';
// import '../../../../../core/services/labour/labour_api_service.dart';
// import '../../../../../widgets/global_loding/global_loader.dart';
// import '../labours_page.dart';
//
//
// // ✅ API Provider
// final labourServiceProvider = Provider((ref) => LabourApiService());
//
//
// // ✅ Labour List Provider with Search
// class LabourNotifier extends StateNotifier<List<Labour>> {
//   final LabourApiService _apiService;
//   bool _isLoading = false;
//   List<Labour> _allLabours = []; // Store all labour data
//
//   LabourNotifier(this._apiService) : super([]);
//
//   bool get isLoading => _isLoading;
//
//   Future<void> loadLabours({
//     bool refresh = false,
//     required BuildContext context,
//   }) async {
//     if (_isLoading) return;
//
//     _isLoading = true;
//     GlobalLoader.show(context);
//
//     if (refresh) state = [];
//
//     try {
//       final List<Labour> newLabours = await _apiService.fetchLabours(
//         pageNumber: 1,
//         pageSize: 5,
//       );
//
//       _allLabours = newLabours;
//       state = newLabours; // Update the state with fetched data
//     } catch (e) {
//       debugPrint("Error loading labours: $e");
//     } finally {
//       _isLoading = false;
//       GlobalLoader.hide();
//     }
//   }
//
//   // ✅ New Method to Filter Labours Dynamically
//   void filterLabours({
//     String labourName = '',
//     String contractorName = '',
//     String labourCategory = '',
//   }) {
//     state =
//         _allLabours.where((labour) {
//           bool matchesLabour =
//               labourName.isEmpty ||
//                   labour.labourName.toLowerCase().contains(
//                     labourName.toLowerCase(),
//                   );
//           bool matchesContractor =
//               contractorName.isEmpty ||
//                   labour.contractorName.toLowerCase().contains(
//                     contractorName.toLowerCase(),
//                   );
//           bool matchesCategory =
//               labourCategory.isEmpty ||
//                   labour.labourCategory.toLowerCase().contains(
//                     labourCategory.toLowerCase(),
//                   );
//
//           return matchesLabour && matchesContractor && matchesCategory;
//         }).toList();
//   }
//
//   // ✅ Clear Filters
//   void clearFilters() {
//     state = List.from(_allLabours);
//   }
// }
//
// final labourListProvider = StateNotifierProvider<LabourNotifier, List<Labour>>((
//     ref,
//     ) {
//   return LabourNotifier(ref.read(labourServiceProvider));
// });
//
// // ✅ Search Query Provider
// final searchQueryProvider = StateProvider<String>((ref) => "");



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/labour/labor.dart';
import '../../../../../core/network/logger.dart';
import '../../../../../core/services/labour/labour_api_service.dart';
import '../../../../../core/utils/secure_storage_util.dart';
import '../../../../../widgets/global_loding/global_loader.dart';

// final labourListProvider = StateNotifierProvider<LabourNotifier, List<Labour>>((ref) {
//   final apiService = LabourApiService(); // Replace with your actual API service instance
//   return LabourNotifier(apiService);
// });
//
// class LabourNotifier extends StateNotifier<List<Labour>> {
//   final LabourApiService _apiService;
//   bool _isLoading = false;
//   List<Labour> _allLabours = [];
//   int _currentPage = 1;
//   int _pageSize = 10;
//   bool _hasMoreData = true;
//
//   LabourNotifier(this._apiService) : super([]);
//
//   bool get isLoading => _isLoading;
//   bool get hasMoreData => _hasMoreData;
//
//   // Fetch labours with pagination logic
//   Future<void> loadLabours({
//     bool refresh = false,
//     required BuildContext context,
//     String labourType = '', // Add the labourType parameter
//   }) async {
//     if (_isLoading) return; // Prevent duplicate requests
//
//     _isLoading = true;
//     state = [...state];
//     //GlobalLoader.show(context); // Show loader while fetching
//
//     if (refresh) {
//       state = []; // Reset state when refreshing
//       _currentPage = 1; // Reset to the first page
//       _hasMoreData = true; // Allow fetching more data again
//     }
//
//     try {
//       final String? userFullName = await SecureStorageUtil.readSecureData("UserFullName");
//
//       if (userFullName == null || userFullName.isEmpty) {
//         AppLogger.error('❌ Failed to retrieve User Full Name');
//         return; // Exit if user name is not available
//       }
//
//       AppLogger.info("📤 Fetching labours for user: $userFullName");
//
//       final List<Labour> newLabours = await _apiService.fetchLabours(
//         pageNumber: _currentPage,
//         pageSize: _pageSize,
//         labourName: userFullName,  // Use the dynamically fetched user name
//         labourType: labourType,    // Pass the dynamic labourType value
//       );
//
//       if (newLabours.isNotEmpty) {
//         AppLogger.info("✅ Fetched ${newLabours.length} labours for page $_currentPage");
//
//         _currentPage++; // Move to the next page
//         _allLabours.addAll(newLabours); // Append new labours to the list
//         state = List.from(_allLabours); // Update the state with the new list
//       } else {
//         _hasMoreData = false; // No more data to fetch
//         AppLogger.info("🔚 No more labours to fetch");
//       }
//     } catch (e) {
//       AppLogger.error("Error loading labours: $e");
//     } finally {
//       _isLoading = false;
//       state = List.from(_allLabours); // Ensure state is updated with the latest labours list
//       //GlobalLoader.hide(); // Hide loader after fetching data
//     }
//   }
//
//   // ✅ New Method to Filter Labours Dynamically
//   void filterLabours({
//     String labourName = '',
//     String contractorName = '',
//     String labourCategory = '',
//   }) {
//     AppLogger.info("🔍 Filtering labours with: labourName=$labourName, contractorName=$contractorName, labourCategory=$labourCategory");
//
//     state = _allLabours.where((labour) {
//       bool matchesLabour =
//           labourName.isEmpty ||
//               labour.labourName.toLowerCase().contains(labourName.toLowerCase());
//       bool matchesContractor =
//           contractorName.isEmpty ||
//               labour.contractorName.toLowerCase().contains(contractorName.toLowerCase());
//       bool matchesCategory =
//           labourCategory.isEmpty ||
//               labour.labourCategory.toLowerCase().contains(labourCategory.toLowerCase());
//
//       return matchesLabour && matchesContractor && matchesCategory;
//     }).toList();
//
//     AppLogger.info("📑 Filtered labours count: ${state.length}");
//   }
//
//   // ✅ Clear Filters
//   void clearFilters() {
//     state = List.from(_allLabours);
//     AppLogger.info("🔄 Cleared filters, displaying all labours");
//   }
// }

final labourListProvider = StateNotifierProvider<LabourNotifier, List<Labour>>((ref) {
  final apiService = LabourApiService(); // Replace with your actual API service
  return LabourNotifier(apiService);
});

class LabourNotifier extends StateNotifier<List<Labour>> {
  final LabourApiService _apiService;

  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  int _pageSize = 10;

  List<Labour> _allLabours = [];

  LabourNotifier(this._apiService) : super([]);

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  /// 🔁 Load labours with pagination and optional refresh
  Future<void> loadLabours({
    bool refresh = false,
    required BuildContext context,
    String labourType = '',
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    state = [...state];

    if (refresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _allLabours.clear();
      state = [];
      AppLogger.info("🔄 Refreshing labour list...");
    }

    try {
      final String? userFullName = await SecureStorageUtil.readSecureData("UserFullName");

      if (userFullName == null || userFullName.isEmpty) {
        AppLogger.error("❌ Failed to retrieve User Full Name");
        return;
      }

      AppLogger.info("📤 Fetching labours for user: $userFullName");

      final List<Labour> newLabours = await _apiService.fetchLabours(
        pageNumber: _currentPage,
        pageSize: _pageSize,
        labourName: userFullName,
        labourType: labourType,
      );

      if (newLabours.isNotEmpty) {
        _currentPage++;
        _allLabours.addAll(newLabours);
        state = List.from(_allLabours);
        AppLogger.info("✅ Fetched ${newLabours.length} labours for page $_currentPage");
      } else {
        _hasMoreData = false;
        AppLogger.info("🔚 No more labours to fetch");
      }
    } catch (e) {
      AppLogger.error("❌ Error loading labours: $e");
    } finally {
      _isLoading = false;
      state = List.from(_allLabours); // Always keep state in sync
    }
  }

  /// 🔍 Filter labours by name, contractor, or category
  void filterLabours({
    String labourName = '',
    String contractorName = '',
    String labourCategory = '',
  }) {
    AppLogger.info("🔍 Filtering labours by: "
        "labourName=$labourName, contractorName=$contractorName, labourCategory=$labourCategory");

    state = _allLabours.where((labour) {
      final matchesLabour = labourName.isEmpty ||
          labour.labourName.toLowerCase().contains(labourName.toLowerCase());
      final matchesContractor = contractorName.isEmpty ||
          labour.contractorName.toLowerCase().contains(contractorName.toLowerCase());
      final matchesCategory = labourCategory.isEmpty ||
          labour.labourCategory.toLowerCase().contains(labourCategory.toLowerCase());

      return matchesLabour && matchesContractor && matchesCategory;
    }).toList();

    AppLogger.info("📑 Filtered labour count: ${state.length}");
  }

  /// 🔄 Reset filters and show all labours
  void clearFilters() {
    state = List.from(_allLabours);
    AppLogger.info("🔄 Cleared filters, showing all labours");
  }

  /// 🗑️ Remove a labour from the list by ID and update UI
  void removeLabourById(int id) {
    _allLabours.removeWhere((labour) => labour.labourID == id);
    state = List.from(_allLabours);
    AppLogger.info("🗑️ Removed labour with ID $id from state and _allLabours");
  }
}
