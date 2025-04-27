// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../core/models/dropdownhendler/labour_category_ddl.dart';
// import '../../core/network/logger.dart';
// import '../../core/services/DropDownHandler/drop_down_hendler_api.dart';
// import 'custom_dropdown.dart';
//
// class ReusableDropdownCategory extends StatefulWidget {
//   final String label;
//   final String? initialValue;
//   final Function(String? name, String? id) onChanged;
//
//   const ReusableDropdownCategory({
//     super.key,
//     required this.label,
//     required this.onChanged,
//     this.initialValue,
//   });
//
//   @override
//   State<ReusableDropdownCategory> createState() => _ReusableDropdownCategoryState();
// }
//
// class _ReusableDropdownCategoryState extends State<ReusableDropdownCategory> {
//   List<LabourCategoryItem> _categoryItems = [];
//   String? _selectedName;
//   String? _selectedId;
//
//   @override
//   void initState() {
//     super.initState();
//     AppLogger.info("🚀 Initializing: ${widget.label}");
//     _loadCategories();
//   }
//
//   Future<void> _loadCategories() async {
//     try {
//       final items = await DropDownHendlerApi().fetchLabourCategories(); // Fetch data from API
//       if (!mounted) return;
//
//       // Check if initial value matches a category, if so, pre-select it
//       final matchedItem = widget.initialValue != null
//           ? items.firstWhere(
//             (e) => e.labourCategoryText == widget.initialValue,
//         orElse: () => LabourCategoryItem(labourCategoryValue: '', labourCategoryText: ''),
//       )
//           : null;
//
//       setState(() {
//         _categoryItems = items;
//         _selectedName = matchedItem?.labourCategoryText;
//         _selectedId = matchedItem?.labourCategoryValue;
//       });
//
//       if (matchedItem != null && matchedItem.labourCategoryText.isNotEmpty) {
//         AppLogger.debug("🟢 Preselected: $_selectedName (ID: $_selectedId)");
//       }
//     } catch (e) {
//       AppLogger.error("❌ Failed to load categories: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final initialItem = _selectedName != null &&
//         _categoryItems.any((e) => e.labourCategoryText == _selectedName)
//         ? _selectedName!
//         : (_categoryItems.isNotEmpty ? _categoryItems.first.labourCategoryText : "-- Select --");
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(widget.label, style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 5),
//           FormField<String>(
//             validator: (value) =>
//             (value == null || value == "-- Select --") ? "Please select ${widget.label}" : null,
//             builder: (state) => Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CommonDropdown<String>(
//                   hintText: widget.label,
//                   items: _categoryItems.map((e) => e.labourCategoryText).toList(),
//                   initialItem: initialItem,
//                   getItemName: (item) => item,
//                   onChanged: (value) {
//                     final selected = _categoryItems.firstWhere(
//                           (e) => e.labourCategoryText == value,
//                       orElse: () => LabourCategoryItem(
//                         labourCategoryValue: "Unknown",
//                         labourCategoryText: "Unknown",
//                       ),
//                     );
//                     AppLogger.info("📝 Selected: ${selected.labourCategoryText} (ID: ${selected.labourCategoryValue})");
//
//                     setState(() {
//                       _selectedName = selected.labourCategoryText;
//                       _selectedId = selected.labourCategoryValue;
//                     });
//
//                     state.didChange(value);
//                     widget.onChanged(_selectedName, _selectedId);
//                   },
//                 ),
//                 if (state.hasError)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5),
//                     child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/dropdownhendler/labour_category_ddl.dart';
import '../../core/network/logger.dart';
import '../../core/services/DropDownHandler/drop_down_hendler_api.dart';
import 'custom_dropdown.dart'; // Assuming you have this custom dropdown widget.

class ReusableDropdownCategory extends StatefulWidget {
  final String label;
  final String? initialValue;
  final Function(String? name, String? id) onChanged;

  const ReusableDropdownCategory({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue,
  });

  @override
  _ReusableDropdownCategoryState createState() => _ReusableDropdownCategoryState();
}

class _ReusableDropdownCategoryState extends State<ReusableDropdownCategory> {
  List<LabourCategoryItem> _categoryItems = [];
  String? _selectedName;
  String? _selectedId;
  bool _isLoading = true;  // Track loading state

  @override
  void initState() {
    super.initState();
    AppLogger.info("🚀 Initializing: ${widget.label}");
    _loadCategories();
  }

  // Fetch categories from API
  Future<void> _loadCategories() async {
    try {
      final items = await DropDownHendlerApi().fetchLabourCategories();
      if (!mounted) return;  // Check if the widget is still in the tree

      // Preselect the category if initialValue is set
      final matchedItem = widget.initialValue != null
          ? items.firstWhere(
            (e) => e.labourCategoryText == widget.initialValue,
        orElse: () => LabourCategoryItem(labourCategoryValue: '', labourCategoryText: ''),
      )
          : null;

      setState(() {
        _categoryItems = items;
        _selectedName = matchedItem?.labourCategoryText;
        _selectedId = matchedItem?.labourCategoryValue;
        _isLoading = false;  // Loading completed
      });

      if (matchedItem != null && matchedItem.labourCategoryText.isNotEmpty) {
        AppLogger.debug("🟢 Preselected: $_selectedName (ID: $_selectedId)");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;  // Stop loading even in case of error
      });
      AppLogger.error("❌ Failed to load categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialItem = _selectedName != null &&
        _categoryItems.any((e) => e.labourCategoryText == _selectedName)
        ? _selectedName!
        : (_categoryItems.isNotEmpty ? _categoryItems.first.labourCategoryText : "-- Select --");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          if (_isLoading)
          // Show loading indicator while fetching data
            Center(
              child: Text("Loding..."),
            )
          else
            FormField<String>(
              validator: (value) =>
              (value == null || value == "-- Select --") ? "Please select ${widget.label}" : null,
              builder: (state) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonDropdown<String>(

                    hintText: widget.label,
                    items: _categoryItems.map((e) => e.labourCategoryText).toList(),
                    initialItem: initialItem,
                    getItemName: (item) => item,
                    onChanged: (value) {
                      final selected = _categoryItems.firstWhere(
                            (e) => e.labourCategoryText == value,
                        orElse: () => LabourCategoryItem(
                          labourCategoryValue: "Unknown",
                          labourCategoryText: "Unknown",
                        ),
                      );
                      AppLogger.info("📝 Selected: ${selected.labourCategoryText} (ID: ${selected.labourCategoryValue})");

                      setState(() {
                        _selectedName = selected.labourCategoryText;
                        _selectedId = selected.labourCategoryValue;
                      });

                      state.didChange(value);
                      widget.onChanged(_selectedName, _selectedId);
                    },
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
