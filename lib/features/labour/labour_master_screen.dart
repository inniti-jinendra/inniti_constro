// // import 'dart:convert';
// // import 'dart:io';
// //
// // import 'package:animated_custom_dropdown/custom_dropdown.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import '../../core/components/app_back_button.dart';
// // import '../../core/components/appbar_header.dart';
// // import '../../core/constants/constants.dart';
// // import '../../core/models/labour/labour_master.dart';
// // import '../../core/models/system/dropdown_item.dart';
// // import '../../core/services/labour/labour_api_service.dart';
// // import '../../core/services/system/system_api_service.dart';
// // import '../../theme/themes/app_themes.dart';
// //
// //
// // class LabourMasterScreen extends StatefulWidget {
// //   final int id;
// //   const LabourMasterScreen({super.key, required this.id});
// //
// //   @override
// //   State<LabourMasterScreen> createState() => _LabourMasterScreenState();
// // }
// //
// // class _LabourMasterScreenState extends State<LabourMasterScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _labourFirstNameController = TextEditingController();
// //   final _labourMiddleNameController = TextEditingController();
// //   final _labourLastNameController = TextEditingController();
// //   final _labourAgeController = TextEditingController();
// //   final _labourContactController = TextEditingController();
// //   final _labourAadharController = TextEditingController();
// //   final _labourWorkingHrsController = TextEditingController(text: "0");
// //   final _totalWagesController = TextEditingController(text: "0");
// //   final _otRateController = TextEditingController(text: "0");
// //
// //   List<SuppliersDDL> _contractors = [];
// //   SuppliersDDL? _selectedSupplier;
// //
// //   List<LabourCategoryDLL> _labourCategories = [];
// //   LabourCategoryDLL? _selectedLabourCategorey;
// //
// //   final List<String> _genderDDL = [
// //     'Male',
// //     'Female',
// //   ];
// //
// //   String? _selectedSex = "Male";
// //   File? _selectedProfilePic;
// //   String _buttonText = "SAVE";
// //
// //   Future<void> _fetchContractors() async {
// //     try {
// //       final contractors = await SystemApiService.fetchContractors();
// //       setState(() {
// //         _contractors = contractors;
// //         _fetchLabourCategories();
// //       });
// //     } catch (error) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Failed to load contractors')),
// //       );
// //     }
// //   }
// //
// //   Future<void> _fetchLabourCategories() async {
// //     try {
// //       final labourCategories = await SystemApiService.fetchLabourCategories();
// //       setState(() {
// //         _labourCategories = labourCategories;
// //         _bindDataForEdit();
// //       });
// //     } catch (error) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Failed to load labour categories')),
// //       );
// //     }
// //   }
// //
// //   _bindDataForEdit() {
// //     if (widget.id > 0) {
// //       fetchLabourData(widget.id);
// //       setState(() {
// //         _buttonText = "UPDATE";
// //       });
// //     }
// //   }
// //
// //   Future<void> fetchLabourData(int id) async {
// //     var labour = await LabourApiService.fatchLabourByID(id: id);
// //
// //     setState(() {
// //       _labourFirstNameController.text = labour.labourFirstName;
// //       _labourMiddleNameController.text = labour.labourMiddleName ?? '';
// //       _labourLastNameController.text = labour.labourLastName ?? '';
// //       _labourAgeController.text = labour.labourAge.toString();
// //       _labourContactController.text = labour.labourContactNo ?? '';
// //       _labourAadharController.text = labour.labourAadharNo ?? '';
// //       _labourWorkingHrsController.text = labour.labourWorkingHrs.toString();
// //       _totalWagesController.text = labour.totalWages.toString();
// //       _otRateController.text = labour.otRate?.toString() ?? '0';
// //       _selectedSex = labour.labourSex;
// //
// //       SuppliersDDL supplier =
// //           _contractors.firstWhere((item) => item.id == labour.supplierId);
// //       _selectedSupplier = supplier;
// //
// //       LabourCategoryDLL categorey = _labourCategories
// //           .firstWhere((item) => item.id == labour.labourCategory);
// //       _selectedLabourCategorey = categorey;
// //     });
// //   }
// //
// //   Future<void> pickImage() async {
// //     final pickedFile =
// //         await ImagePicker().pickImage(source: ImageSource.gallery);
// //     if (pickedFile != null) {
// //       setState(() {
// //         _selectedProfilePic = File(pickedFile.path);
// //       });
// //     }
// //   }
// //
// //   Future<void> submitLabour() async {
// //     if (_formKey.currentState!.validate()) {
// //       final labour = Labour(
// //         labourID: widget.id,
// //         supplierId: _selectedSupplier!.id,
// //         labourCategory: _selectedLabourCategorey!.id,
// //         labourFirstName: _labourFirstNameController.text,
// //         labourMiddleName: _labourMiddleNameController.text.isNotEmpty
// //             ? _labourMiddleNameController.text
// //             : null,
// //         labourLastName: _labourLastNameController.text.isNotEmpty
// //             ? _labourLastNameController.text
// //             : null,
// //         labourSex: _selectedSex!,
// //         labourAge: int.tryParse(_labourAgeController.text),
// //         labourContactNo: _labourContactController.text.isNotEmpty
// //             ? _labourContactController.text
// //             : null,
// //         labourAadharNo: _labourAadharController.text.isNotEmpty
// //             ? _labourAadharController.text
// //             : null,
// //         labourProfilePic: _selectedProfilePic != null
// //             ? base64Encode(_selectedProfilePic!.readAsBytesSync())
// //             : null,
// //         labourWorkingHrs: int.parse(_labourWorkingHrsController.text),
// //         totalWages: double.parse(_totalWagesController.text),
// //         otRate: _otRateController.text.isNotEmpty
// //             ? double.tryParse(_otRateController.text)
// //             : null,
// //       );
// //
// //       String response = await LabourApiService.createUpdateLabour(labour);
// //
// //       if (response == "Success") {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //               content: Text(widget.id > 0
// //                   ? 'Labour updated successfully!'
// //                   : 'Labour added successfully!')),
// //         );
// //         _formKey.currentState!.reset();
// //         Navigator.pop(context);
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Failed to add labour.')),
// //         );
// //       }
// //     }
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchContractors();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // backgroundColor: AppColors.cardColor,
// //       appBar: AppBar(
// //         leading: const AppBackButton(),
// //         title: AppbarHeader(
// //             headerName: 'Labour Master', projectName: 'Ganesh Gloary 11'),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Form(
// //           key: _formKey,
// //           child: Padding(
// //             padding: const EdgeInsets.all(AppDefaults.padding),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 /* <----  Contractor -----> */
// //                 Text(
// //                   "Select Contractor *",
// //                   style: Theme.of(context).textTheme.labelSmall?.copyWith(
// //                       color: Colors.black, fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: AppDefaults.padding_2),
// //                 _buildDropdownContractor(),
// //                 const SizedBox(height: AppDefaults.padding_3),
// //
// //                 /* <---- Labour Category -----> */
// //                 Text(
// //                   "Labour Category *",
// //                   style: Theme.of(context).textTheme.labelSmall?.copyWith(
// //                       color: Colors.black, fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: AppDefaults.padding_2),
// //                 _buildDropdownCategorey(),
// //                 const SizedBox(height: AppDefaults.padding_3),
// //
// //                 /* <---- First Name -----> */
// //                 Text(
// //                   "First Name *",
// //                   style: Theme.of(context).textTheme.labelSmall?.copyWith(
// //                       color: Colors.black, fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: AppDefaults.padding_2),
// //                 _buildTextField(_labourFirstNameController, TextInputType.text,
// //                     TextInputAction.next),
// //                 const SizedBox(height: AppDefaults.padding_3),
// //
// //                 /* <---- Middle Name -----> */ /* <---- Last Name -----> */
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             "Middle Name",
// //                             style: Theme.of(context)
// //                                 .textTheme
// //                                 .labelSmall
// //                                 ?.copyWith(
// //                                     color: Colors.black,
// //                                     fontWeight: FontWeight.bold),
// //                           ),
// //                           const SizedBox(height: AppDefaults.padding_2),
// //                           _buildTextField(_labourMiddleNameController,
// //                               TextInputType.text, TextInputAction.next),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(width: AppDefaults.padding_3),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             "Last Name",
// //                             style: Theme.of(context)
// //                                 .textTheme
// //                                 .labelSmall
// //                                 ?.copyWith(
// //                                     color: Colors.black,
// //                                     fontWeight: FontWeight.bold),
// //                           ),
// //                           const SizedBox(height: AppDefaults.padding_2),
// //                           _buildTextField(_labourLastNameController,
// //                               TextInputType.text, TextInputAction.next),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             "Gender",
// //                             style: Theme.of(context)
// //                                 .textTheme
// //                                 .labelSmall
// //                                 ?.copyWith(
// //                                     color: Colors.black,
// //                                     fontWeight: FontWeight.bold),
// //                           ),
// //                           const SizedBox(height: AppDefaults.padding_2),
// //                           _genderDropdown(),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(width: AppDefaults.padding_3),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             "Age",
// //                             style: Theme.of(context)
// //                                 .textTheme
// //                                 .labelSmall
// //                                 ?.copyWith(
// //                                     color: Colors.black,
// //                                     fontWeight: FontWeight.bold),
// //                           ),
// //                           const SizedBox(height: AppDefaults.padding_2),
// //                           _buildTextField(_labourAgeController,
// //                               TextInputType.number, TextInputAction.next),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: AppDefaults.padding_3),
// //
// //                 /* <---- Mobile Number -----> */
// //                 Text(
// //                   "Mobile Number",
// //                   style: Theme.of(context).textTheme.labelSmall?.copyWith(
// //                       color: Colors.black, fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: AppDefaults.padding_2),
// //                 _buildTextField(_labourContactController, TextInputType.text,
// //                     TextInputAction.next),
// //                 const SizedBox(height: AppDefaults.padding_3),
// //
// //                 /* <---- Aadhar Number -----> */
// //                 Text(
// //                   "Aadhar Number",
// //                   style: Theme.of(context).textTheme.labelSmall?.copyWith(
// //                       color: Colors.black, fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: AppDefaults.padding_2),
// //                 _buildTextField(_labourAadharController, TextInputType.text,
// //                     TextInputAction.next),
// //                 const SizedBox(height: AppDefaults.padding_3),
// //
// //                 /* <---- Working Hour and Wages Per Day -----> */
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             "Working Hour *",
// //                             style: Theme.of(context)
// //                                 .textTheme
// //                                 .labelSmall
// //                                 ?.copyWith(
// //                                     color: Colors.black,
// //                                     fontWeight: FontWeight.bold),
// //                           ),
// //                           const SizedBox(height: AppDefaults.padding_2),
// //                           _buildTextField(_labourWorkingHrsController,
// //                               TextInputType.number, TextInputAction.next),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(width: AppDefaults.padding_3),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             "Wages/Per Day",
// //                             style: Theme.of(context)
// //                                 .textTheme
// //                                 .labelSmall
// //                                 ?.copyWith(
// //                                     color: Colors.black,
// //                                     fontWeight: FontWeight.bold),
// //                           ),
// //                           const SizedBox(height: AppDefaults.padding_2),
// //                           _buildTextField(_totalWagesController,
// //                               TextInputType.number, TextInputAction.done),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: AppDefaults.padding_3),
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton(
// //                     onPressed: submitLabour,
// //                     child: Text(_buttonText),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   _buildTextField(TextEditingController controller, TextInputType keyboardType,
// //       TextInputAction textInputAction) {
// //     return TextFormField(
// //       controller: controller,
// //       keyboardType: keyboardType,
// //       textInputAction: textInputAction,
// //     );
// //   }
// //
// //   Widget _buildDropdownContractor() {
// //     return SizedBox(
// //       height: AppDefaults.ddlSizeBoxHeight, // Force height to match textbox
// //       child: CustomDropdown<String>.search(
// //         hintText: "Select Contractor *",
// //         items: _contractors.map((item) => item.name).toList(),
// //         initialItem: _selectedSupplier?.name,
// //         onChanged: (value) {
// //           setState(() {
// //             var supplierID =
// //                 _contractors.firstWhere((item) => item.name == value).id;
// //             _selectedSupplier =
// //                 _contractors.firstWhere((item) => item.id == supplierID);
// //           });
// //         },
// //         decoration: AppTheme.mapInputDecorationToDropdown(),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDropdownCategorey() {
// //     return SizedBox(
// //       height: AppDefaults.ddlSizeBoxHeight, // Force height to match textbox
// //       child: CustomDropdown<String>.search(
// //         hintText: "Select Category *",
// //         items: _labourCategories.map((item) => item.name).toList(),
// //         initialItem: _selectedLabourCategorey?.name,
// //         onChanged: (value) {
// //           setState(() {
// //             var categoreyID =
// //                 _labourCategories.firstWhere((item) => item.name == value).id;
// //             _selectedLabourCategorey =
// //                 _labourCategories.firstWhere((item) => item.id == categoreyID);
// //           });
// //         },
// //         decoration: AppTheme.mapInputDecorationToDropdown(),
// //       ),
// //     );
// //   }
// //
// //   Widget _genderDropdown() {
// //     return SizedBox(
// //       height: AppDefaults.ddlSizeBoxHeight,
// //       child: CustomDropdown<String>(
// //         hintText: 'Select Gender',
// //         items: _genderDDL,
// //         initialItem: _genderDDL[0],
// //         onChanged: (value) {
// //           _selectedSex = value.toString();
// //         },
// //         decoration: AppTheme.mapInputDecorationToDropdown(),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import '../../core/components/app_back_button.dart';
// import '../../core/constants/constants.dart';
// import '../../core/models/labour/labour_master.dart';
// import '../../core/models/system/dropdown_item.dart';
// import '../../core/network/logger.dart';
// import '../../core/services/labour/labour_api_service.dart';
// import '../../core/services/system/system_api_service.dart';
// import '../../theme/themes/app_themes.dart';
// import '../../widgets/dropdown/custom_dropdown.dart';
//
// class LabourMasterScreen extends StatefulWidget {
//   final int id;
//   const LabourMasterScreen({super.key, required this.id});
//
//   @override
//   State<LabourMasterScreen> createState() => _LabourMasterScreenState();
// }
//
// class _LabourMasterScreenState extends State<LabourMasterScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _labourFirstNameController = TextEditingController();
//   final _labourLastNameController = TextEditingController();
//   final _labourAgeController = TextEditingController();
//   final _labourContactController = TextEditingController();
//   final _labourAadharController = TextEditingController();
//   final _labourWorkingHrsController = TextEditingController(text: "0");
//   final _totalWagesController = TextEditingController(text: "0");
//   final _otRateController = TextEditingController(text: "0");
//
//   List<SuppliersDDL> _contractors = [];
//   SuppliersDDL? _selectedSupplier;
//
//   List<LabourCategoryDLL> _labourCategories = [];
//   LabourCategoryDLL? _selectedLabourCategorey;
//
//   final List<String> _genderDDL = ['Male', 'Female'];
//   String? _selectedSex = "Male";
//   File? _selectedProfilePic;
//   String _buttonText = "SAVE";
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }
//
//   Future<void> _initializeData() async {
//     try {
//       AppLogger.info('📡 [INIT] Fetching initial data...');
//
//       // Run both fetches in parallel for better performance
//       await Future.wait([
//         _fetchContractors(),
//         _fetchLabourCategories(),
//       ]);
//
//       AppLogger.info('✅ [INIT] Contractors & Labour Categories fetched successfully.');
//
//       // Fetch labour data only if ID > 0
//       if (widget.id > 0) {
//         AppLogger.info('📡 [INIT] Fetching Labour Data for ID: ${widget.id}');
//         await fetchLabourData(widget.id);
//         AppLogger.info('✅ [INIT] Labour Data fetched successfully.');
//       }
//     } catch (error, stackTrace) {
//       AppLogger.error('❌ [INIT ERROR] Failed to initialize data: $error');
//       AppLogger.debug('🛠️ [STACKTRACE] $stackTrace');
//       _showErrorSnackBar('Failed to load initial data');
//     }
//   }
//
//
//   Future<void> _fetchContractors() async {
//     try {
//       final contractors = await SystemApiService.fetchContractors();
//       AppLogger.debug('✅ Contractors fetched: ${contractors.length}');
//
//       if (contractors.isNotEmpty) {
//         setState(() {
//           _contractors = contractors;
//           _selectedSupplier = _contractors.first;
//         });
//       } else {
//         _showErrorSnackBar('⚠️ No contractors found');
//       }
//     } catch (error, stackTrace) {
//       AppLogger.error('❌ Error fetching contractors: $error');
//       AppLogger.debug('🛠️ StackTrace: $stackTrace');
//       _showErrorSnackBar('Failed to load contractors');
//     }
//   }
//
//   Future<void> _fetchLabourCategories() async {
//     try {
//       AppLogger.info('📡 [UI CALL] Fetching labour categories...');
//       final categories = await SystemApiService.fetchLabourCategories();
//
//       AppLogger.debug('✅ [UI RESPONSE] Fetched Categories: ${categories.map((c) => c.name).toList()}');
//
//       setState(() {
//         _labourCategories = categories;
//         _selectedLabourCategorey = _labourCategories.isNotEmpty ? _labourCategories.first : null;
//       });
//
//       if (_labourCategories.isEmpty) {
//         AppLogger.warn('⚠️ [UI WARNING] No labour categories found.');
//         _showErrorSnackBar('⚠️ No labour categories found');
//       } else {
//         AppLogger.info('✅ [UI UPDATE] Dropdown updated with ${_labourCategories.length} categories.');
//       }
//     } catch (error, stackTrace) {
//       AppLogger.error('❌ [UI ERROR] Failed to fetch labour categories: $error');
//       AppLogger.debug('🛠️ [STACKTRACE] $stackTrace');
//       _showErrorSnackBar('Failed to load labour categories');
//     }
//   }
//
//
//
//
//
//   Future<void> fetchLabourData(int id) async {
//     try {
//       final labour = await LabourApiService.fatchLabourByID(id: id);
//       setState(() {
//         _buttonText = "UPDATE";
//         _labourFirstNameController.text = labour.labourFirstName;
//         _labourLastNameController.text = labour.labourLastName ?? '';
//         _labourAgeController.text = labour.labourAge.toString();
//         _labourContactController.text = labour.labourContactNo ?? '';
//         _labourAadharController.text = labour.labourAadharNo ?? '';
//         _labourWorkingHrsController.text = labour.labourWorkingHrs.toString();
//         _totalWagesController.text = labour.totalWages.toString();
//         _otRateController.text = labour.otRate?.toString() ?? '0';
//         _selectedSex = labour.labourSex;
//
//         _selectedSupplier = _contractors.firstWhere(
//               (item) => item.id == labour.supplierId,
//           orElse: () => SuppliersDDL(id: -1, name: 'Unknown'),
//         );
//
//         _selectedLabourCategorey = _labourCategories.firstWhere(
//               (item) => item.id == labour.labourCategory,
//           orElse: () => LabourCategoryDLL(id: " ", name: 'Unknown'),
//         );
//       });
//     } catch (e) {
//       _showErrorSnackBar('Failed to fetch labour data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Labour Master"),
//         leading: const AppBackButton(),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildDropdownContractor(),
//               const SizedBox(height: 10),
//               _buildDropdownCategorey(),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () async {
//                   await submitLabour();
//                 },
//                 child: Text(_buttonText),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDropdownContractor() {
//     return _contractors.isNotEmpty
//         ? CommonDropdown<SuppliersDDL>(
//       hintText: "Select Contractor *",
//       items: _contractors,
//       initialItem: _selectedSupplier,
//       getItemName: (item) => item.name,
//       onChanged: (value) {
//         setState(() {
//           _selectedSupplier = value;
//         });
//       },
//     )
//         : const Center(child: Text('No contractors available'));
//   }
//
//
//   Widget _buildDropdownCategorey() {
//     return _labourCategories.isNotEmpty
//         ? CommonDropdown<LabourCategoryDLL>(
//       hintText: "Select Category *",
//       items: _labourCategories,
//       initialItem: _selectedLabourCategorey,
//       getItemName: (item) => item.name,
//       onChanged: (value) {
//         setState(() {
//           _selectedLabourCategorey = value;
//         });
//         AppLogger.debug('🎯 Selected Labour Category: $_selectedLabourCategorey');
//       },
//     )
//         : const Center(child: Text('No categories available'));
//   }
//
//
//
//
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   Future<void> submitLabour() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         final labourData = {
//           "firstName": _labourFirstNameController.text,
//           "lastName": _labourLastNameController.text,
//           "age": int.tryParse(_labourAgeController.text) ?? 0,
//           "contact": _labourContactController.text,
//           "aadhar": _labourAadharController.text,
//           "workingHours": int.tryParse(_labourWorkingHrsController.text) ?? 0,
//           "totalWages": double.tryParse(_totalWagesController.text) ?? 0.0,
//           "otRate": double.tryParse(_otRateController.text) ?? 0.0,
//           "gender": _selectedSex,
//           "supplierId": _selectedSupplier?.id,
//           "labourCategory": _selectedLabourCategorey?.id,
//         };
//
//         if (widget.id > 0) {
//           await SystemApiService.fetchContractors();
//           _showErrorSnackBar('Labour updated successfully!');
//         } else {
//           await SystemApiService.fetchLabourCategories();
//           _showErrorSnackBar('Labour saved successfully!');
//         }
//       } catch (e) {
//         _showErrorSnackBar('Failed to save labour details.');
//       }
//     }
//   }
// }
