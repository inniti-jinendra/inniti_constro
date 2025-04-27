// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../core/models/dropdownhendler/projectItem_ddl.dart';
// import '../../core/network/logger.dart';
// import '../../core/services/DropDownHandler/drop_down_hendler_api.dart';
// import 'custom_dropdown.dart';
//
// class CustomDropdownPage extends StatefulWidget {
//   final String label;
//   final Function(String?) onChanged;
//   final String? initialValue;
//
//   CustomDropdownPage({
//     required this.label,
//     required this.onChanged,
//     this.initialValue,
//   });
//
//   @override
//   _CustomDropdownPageState createState() => _CustomDropdownPageState();
// }
//
// class _CustomDropdownPageState extends State<CustomDropdownPage> {
//   List<ProjectItem> _projectItems = []; // holds full item list with ID + Name
//   String? _selectedItemName;
//   int? _selectedItemId;
//
//   @override
//   void initState() {
//     super.initState();
//     AppLogger.info("🚀 Initializing CustomDropdownPage for label: ${widget.label}");
//     _fetchItems();
//   }
//
//   Future<void> _fetchItems() async {
//     try {
//       AppLogger.info("📡 Fetching item types from API...");
//       DropDownHendlerApi api = DropDownHendlerApi();
//       List<ProjectItem> projectItems = await api.fetchProjectItemTypes();
//       AppLogger.info("✅ Fetched ${projectItems.length} item types");
//
//       setState(() {
//         _projectItems = projectItems; // ✅ assign the fetched list properly
//         if (widget.initialValue != null &&
//             projectItems.any((e) => e.projectItemTypeName == widget.initialValue)) {
//           _selectedItemName = widget.initialValue;
//           _selectedItemId = projectItems
//               .firstWhere((e) => e.projectItemTypeName == widget.initialValue)
//               .projectItemTypeId;
//           AppLogger.debug("🟢 Initial selected item: $_selectedItemName (ID: $_selectedItemId)");
//         }
//       });
//
//     } catch (e) {
//       AppLogger.error("❌ Error fetching item types: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildDropdown(
//           label: widget.label,
//           items: _projectItems,
//           initialValue: _selectedItemName,
//           onChanged: (String? name, int? id) {
//             setState(() {
//               _selectedItemName = name;
//               _selectedItemId = id;
//             });
//             widget.onChanged(name); // you can modify this to also pass ID if needed
//             AppLogger.info("📝 User selected: $name (ID: $id)");
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDropdown({
//     required String label,
//     required List<ProjectItem> items,
//     required Function(String? name, int? id) onChanged,
//     String? initialValue,
//   }) {
//     String validInitialValue = (initialValue != null &&
//         items.any((e) => e.projectItemTypeName == initialValue))
//         ? initialValue
//         : (items.isNotEmpty ? items.first.projectItemTypeName : "-- Select Items --");
//
//     AppLogger.debug("🔽 Building dropdown with validInitialValue: $validInitialValue");
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 5),
//           FormField<String>(
//             validator: (value) {
//               if (value == null || value == "-- Select Items --") {
//                 return "Please select $label";
//               }
//               return null;
//             },
//             builder: (FormFieldState<String> state) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CommonDropdown<String>(
//                     hintText: label,
//                     items: items.map((e) => e.projectItemTypeName).toList(),
//                     initialItem: validInitialValue,
//                     getItemName: (item) => item,
//                     onChanged: (value) {
//                       final selectedItem = items.firstWhere(
//                             (item) => item.projectItemTypeName == value,
//                         orElse: () => ProjectItem(projectItemTypeId: -1, projectItemTypeName: "Unknown"),
//                       );
//
//                       onChanged(selectedItem.projectItemTypeName, selectedItem.projectItemTypeId);
//                       state.didChange(value);
//
//                       AppLogger.debug(
//                         "📤 Dropdown changed: ${selectedItem.projectItemTypeName} (ID: ${selectedItem.projectItemTypeId})",
//                       );
//                     },
//                   ),
//                   if (state.hasError)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 5),
//                       child: Text(
//                         state.errorText!,
//                         style: const TextStyle(color: Colors.red, fontSize: 12),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/dropdownhendler/projectItem_ddl.dart';
import '../../core/network/logger.dart';
import '../../core/services/DropDownHandler/drop_down_hendler_api.dart';
import 'custom_dropdown.dart';

class ReusableDropdown extends StatefulWidget {
  final String label;
  final String? initialValue;
  final Function(String? name, int? id) onChanged;

  const ReusableDropdown({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<ReusableDropdown> createState() => _ReusableDropdownState();
}

class _ReusableDropdownState extends State<ReusableDropdown> {
  List<ProjectItem> _projectItems = [];
  String? _selectedName;
  int? _selectedId;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    AppLogger.info("🚀 ReusableDropdown initializing for label: ${widget.label}");
    AppLogger.info("🔑 Prefilling initial value: ${widget.initialValue ?? 'None'}");
    _fetchDropdownItems();
  }

  @override
  void didUpdateWidget(covariant ReusableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null &&
        _projectItems.isNotEmpty) {
      AppLogger.info("🔁 Updating dropdown due to new initialValue: ${widget.initialValue}");

      final selected = _projectItems.firstWhere(
            (item) => item.projectItemTypeName == widget.initialValue,
        orElse: () => ProjectItem(projectItemTypeId: -1, projectItemTypeName: "Unknown"),
      );

      if (selected.projectItemTypeId != -1) {
        setState(() {
          _selectedName = selected.projectItemTypeName;
          _selectedId = selected.projectItemTypeId;
        });

        AppLogger.debug("✅ Prefilled from didUpdateWidget: $_selectedName (ID: $_selectedId)");
      } else {
        AppLogger.warn("⚠️ Provided initialValue not found in project items");
      }
    }
  }

  Future<void> _fetchDropdownItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      AppLogger.info("📡 Fetching dropdown data...");
      final items = await DropDownHendlerApi().fetchProjectItemTypes();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _projectItems = items;

          if (items.isEmpty) {
            _errorMessage = "No items available.";
          } else if (widget.initialValue != null &&
              items.any((e) => e.projectItemTypeName == widget.initialValue)) {
            final selected = items.firstWhere((e) => e.projectItemTypeName == widget.initialValue);
            _selectedName = selected.projectItemTypeName;
            _selectedId = selected.projectItemTypeId;
            AppLogger.debug("🟢 Preselected on load: $_selectedName (ID: $_selectedId)");
          } else {
            _selectedName = items.first.projectItemTypeName;
            _selectedId = items.first.projectItemTypeId;
          }
        });
      }
    } catch (e) {
      AppLogger.error("❌ Error loading dropdown items: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load items. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          FormField<String>(
            validator: (value) {
              if (value == null || value == "-- Select --") {
                return "Please select ${widget.label}";
              }
              return null;
            },
            builder: (FormFieldState<String> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoading)
                    const Text("Loading...")
                  else if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    )
                  else
                    CommonDropdown<String>(
                      hintText: widget.label,
                      items: _projectItems.map((e) => e.projectItemTypeName).toList(),
                      initialItem: _selectedName ?? "-- Select --",
                      getItemName: (item) => item,
                      onChanged: (selectedValue) {
                        final selectedItem = _projectItems.firstWhere(
                              (item) => item.projectItemTypeName == selectedValue,
                          orElse: () => ProjectItem(
                            projectItemTypeId: -1,
                            projectItemTypeName: "Unknown",
                          ),
                        );

                        AppLogger.info("📝 Selected: ${selectedItem.projectItemTypeName} (ID: ${selectedItem.projectItemTypeId})");

                        setState(() {
                          _selectedName = selectedItem.projectItemTypeName;
                          _selectedId = selectedItem.projectItemTypeId;
                        });

                        state.didChange(selectedValue);
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
              );
            },
          ),
        ],
      ),
    );
  }
}
