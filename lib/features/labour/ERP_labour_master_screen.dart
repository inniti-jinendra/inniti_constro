import 'dart:convert';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inniti_constro/widgets/custom_rounded_rectangle_button/custom_smallest_rounded_rectangle_button.dart';
import '../../core/components/app_back_button.dart';
import '../../core/constants/constants.dart';
import '../../core/constants/font_styles.dart';
import '../../core/models/labour/labour_master.dart';
import '../../core/models/system/dropdown_item.dart';
import '../../core/services/system/system_api_service.dart';
import '../../theme/themes/app_themes.dart';
import '../../widgets/custom_card/custom_card_container.dart';
import '../../widgets/custom_rounded_rectangle_button/custom_small_rounded_rectangle_button.dart';
import '../../widgets/helper/camera_helper_service.dart';
import '../../widgets/helper/image_file_uplode_helper.dart';
import '../../widgets/input-TextField/custom_textfield.dart';

class LabourCategory {
  final String name;
  final int id;

  LabourCategory({required this.name, required this.id});
}

class Supplier {
  final String name;
  final int id;

  Supplier({required this.name, required this.id});
}

class ErpLabourMasterScreen extends StatefulWidget {
  final int id;

  const ErpLabourMasterScreen({super.key, required this.id});

  @override
  State<ErpLabourMasterScreen> createState() => _ErpLabourMasterScreenState();
}

class _ErpLabourMasterScreenState extends State<ErpLabourMasterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labourFirstNameController = TextEditingController();
  final _labourMiddleNameController = TextEditingController();
  final _labourLastNameController = TextEditingController();
  final _labourAgeController = TextEditingController();
  final _labourContactController = TextEditingController();
  final _labourAadharController = TextEditingController();
  final _labourWorkingHrsController = TextEditingController(text: "0");
  final _totalWagesController = TextEditingController(text: "0");
  final _otRateController = TextEditingController(text: "0");

  List<Supplier> _contractors = [];
  List<LabourCategory> _labourCategories = [];

  Supplier? _selectedSupplier;
  LabourCategory? _selectedLabourCategorey;

  // Simulated Async fetch functions
  Future<void> _fetchContractors() async {
    await Future.delayed(Duration(seconds: 2)); // Simulating delay
    setState(() {
      _contractors = [
        Supplier(name: "Contractor A", id: 1),
        Supplier(name: "Contractor B", id: 2),
        Supplier(name: "Contractor C", id: 3),
      ];
    });
  }

  Future<void> _fetchLabourCategories() async {
    await Future.delayed(Duration(seconds: 2)); // Simulating delay
    setState(() {
      _labourCategories = [
        LabourCategory(name: "ELECTRICIAN", id: 1),
        LabourCategory(name: "PLUMBER", id: 2),
        LabourCategory(name: "CARPENTER", id: 3),
        LabourCategory(name: "MASON", id: 4),
        LabourCategory(name: "WELDER", id: 5),
        LabourCategory(name: "PAINTER", id: 6),
        LabourCategory(name: "MASONARY", id: 7),
        LabourCategory(name: "TILER", id: 8),
        LabourCategory(name: "FLOORING", id: 9),
        LabourCategory(name: "CONCRETE", id: 10),
        LabourCategory(name: "ROOFER", id: 11),
        LabourCategory(name: "PLASTERER", id: 12),
        LabourCategory(name: "LABOURER", id: 13),
        LabourCategory(name: "MECHANIC", id: 14),
        LabourCategory(name: "GARDENER", id: 15),
        LabourCategory(name: "IRONWORKER", id: 16),
        LabourCategory(name: "HVAC", id: 17),
        LabourCategory(name: "CLEANER", id: 18),
        LabourCategory(name: "GAS FITTER", id: 19),
        LabourCategory(name: "PAINTER", id: 20),
        LabourCategory(name: "ELECTRICAL HELPER", id: 21),
        LabourCategory(name: "PLUMBING HELPER", id: 22),
        LabourCategory(name: "CARPENTER HELPER", id: 23),
        LabourCategory(name: "STONEMASON", id: 24),
        LabourCategory(name: "SHEETROCKER", id: 25),
        LabourCategory(name: "DRIVER", id: 26),
        LabourCategory(name: "FITTER", id: 27),
        LabourCategory(name: "OPERATOR", id: 28),
        LabourCategory(name: "ELECTRONICS TECHNICIAN", id: 29),
        LabourCategory(name: "WELDER HELPER", id: 30),
        LabourCategory(name: "PLUMBING INSPECTOR", id: 31),
        LabourCategory(name: "ELECTRICIAN APPRENTICE", id: 32),
        LabourCategory(name: "PLUMBING APPRENTICE", id: 33),
        LabourCategory(name: "CARPENTRY APPRENTICE", id: 34),
        LabourCategory(name: "MASONRY APPRENTICE", id: 35),
        LabourCategory(name: "PAINTING APPRENTICE", id: 36),
      ];
    });
  }

  final List<String> _genderDDL = ['Male', 'Female'];
  String? _selectedSex = "Male";
  File? _selectedProfilePic;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchContractors();
    _fetchLabourCategories();
  }


  // Handle the image picked and update the state
  void _onImagePicked(String? fileName) {
    if (fileName != null) {
      print('Selected image: $fileName');
      // Handle the image file name (e.g., upload to server, etc.)
    }
  }
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedProfilePic = File(pickedFile.path);
      });
    }
  }

  Future<void> submitLabour() async {
    if (_formKey.currentState!.validate()) {
      final labour = Labour(
        labourID: widget.id,
        supplierId: _selectedSupplier!.id,
        // Ensuring that this is an int
        labourCategory: _selectedLabourCategorey?.name ?? '',
        // Using name as String
        labourFirstName: _labourFirstNameController.text,
        labourMiddleName:
            _labourMiddleNameController.text.isNotEmpty
                ? _labourMiddleNameController.text
                : null,
        labourLastName:
            _labourLastNameController.text.isNotEmpty
                ? _labourLastNameController.text
                : null,
        labourSex: _selectedSex!,
        labourAge: int.tryParse(_labourAgeController.text),
        labourContactNo:
            _labourContactController.text.isNotEmpty
                ? _labourContactController.text
                : null,
        labourAadharNo:
            _labourAadharController.text.isNotEmpty
                ? _labourAadharController.text
                : null,
        labourProfilePic:
            _selectedProfilePic != null
                ? base64Encode(_selectedProfilePic!.readAsBytesSync())
                : null,
        labourWorkingHrs: int.parse(_labourWorkingHrsController.text),
        totalWages: double.parse(_totalWagesController.text),
        otRate:
            _otRateController.text.isNotEmpty
                ? double.tryParse(_otRateController.text)
                : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.id > 0
                ? 'Labour updated successfully!'
                : 'Labour added successfully!',
          ),
        ),
      );

      _formKey.currentState!.reset();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('New Labour'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColumn(),
                _buildDropdownSection(
                  "Select Contractor *",
                  _buildDropdownContractor(),
                ),
                const SizedBox(height: AppDefaults.padding_3),
                _buildDropdownSection(
                  "Labour Category *",
                  _buildDropdownCategorey(),
                ),
                const SizedBox(height: AppDefaults.padding_3),
                _buildFormField("First Name *", _labourFirstNameController),

                const SizedBox(height: AppDefaults.padding_3),
                CustomTextField(
                  label: "First Name *",
                  controller: _labourFirstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First Name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDefaults.padding_3),

                const SizedBox(height: AppDefaults.padding_3),
                _buildMiddleAndLastName(),
                _buildGenderAndAge(),
                _buildFormField("Mobile Number", _labourContactController),
                _buildFormField("Aadhar Number", _labourAadharController),
                _buildWorkingHoursAndWages(),
                const SizedBox(height: AppDefaults.padding_3),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Save Labour'),
                    onPressed: submitLabour,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _buildTextStyle() {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _buildTextStyle()),
        const SizedBox(height: AppDefaults.padding_2),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: _inputDecoration(label),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.primaryWhitebg,
      hintText: label,
      hintStyle: TextStyle(color: AppColors.primaryLightGrayFont),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildMiddleAndLastName() {
    return Row(
      children: [
        Expanded(
          child: _buildFormField("Middle Name", _labourMiddleNameController),
        ),
        const SizedBox(width: AppDefaults.padding_3),
        Expanded(
          child: _buildFormField("Last Name", _labourLastNameController),
        ),
      ],
    );
  }

  Widget _buildGenderAndAge() {
    return Row(
      children: [
        Expanded(child: _genderDropdown()),
        const SizedBox(width: AppDefaults.padding_3),
        Expanded(child: _buildFormField("Age", _labourAgeController)),
      ],
    );
  }

  Widget _buildWorkingHoursAndWages() {
    return Row(
      children: [
        Expanded(
          child: _buildFormField("Working Hour *", _labourWorkingHrsController),
        ),
        const SizedBox(width: AppDefaults.padding_3),
        Expanded(
          child: _buildFormField("Wages/Per Day", _totalWagesController),
        ),
      ],
    );
  }

  Widget _genderDropdown() {
    return CustomDropdown<String>(
      hintText: 'Select Gender',
      items: _genderDDL,
      initialItem: _selectedSex!,
      onChanged: (value) {
        setState(() {
          _selectedSex = value;
        });
      },
      // Decoration passed here
      decoration: CustomDropdownDecoration(
        expandedFillColor: AppColors.scaffoldWithBoxBackground, // Example color
        closedFillColor: AppColors.primaryWhitebg, // Example color
        hintStyle: TextStyle(
          color: AppColors.primaryBlackFont,
        ), // Example color
      ),
    );
  }

  Widget _buildDropdownContractor() {
    return CustomDropdown<String>.search(
      hintText: "Select Contractor *",
      items: _contractors.map((item) => item.name).toList(),
      initialItem: _selectedSupplier?.name,
      onChanged: (value) {
        setState(() {
          _selectedSupplier = _contractors.firstWhere(
            (item) => item.name == value,
          );
        });
      },
      decoration: _dropdownDecoration(),
    );
  }

  Widget _buildDropdownCategorey() {
    return CustomDropdown<String>.search(
      hintText: "Select Category *",
      items: _labourCategories.map((item) => item.name).toList(),
      initialItem: _selectedLabourCategorey?.name,
      onChanged: (value) {
        setState(() {
          _selectedLabourCategorey = _labourCategories.firstWhere(
            (item) => item.name == value,
          );
        });
      },
      decoration: _dropdownDecoration(),
    );
  }

  CustomDropdownDecoration _dropdownDecoration() {
    return CustomDropdownDecoration(
      expandedFillColor: AppColors.scaffoldWithBoxBackground,
      closedFillColor: AppColors.primaryWhitebg,
      hintStyle: TextStyle(color: AppColors.primaryBlackFont),
    );
  }

  Widget _buildDropdownSection(String label, Widget dropdown) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _buildTextStyle()),
        const SizedBox(height: AppDefaults.padding_2),
        dropdown,
      ],
    );
  }

  // Create a Column widget that applies various font styles and custom colors
  Widget _buildColumn() {


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallRoundedButton(
          buttonText: 'Save', // Button Text
          onPressed: () {
            // Action to be performed when the button is pressed
            print('Small Rounded Button Pressed');
          },
          // backgroundColor: AppColors.primaryBlue, // Button background color
          // textColor: AppColors.scaffoldWithBoxBackground, // Text color
          // fontSize: 14, // Smaller font size
          // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Custom padding
          // borderRadius: BorderRadius.circular(15), // Rounded corners
          // elevation: 4.0, // Button elevation
        ),
        SizedBox(height: 10),
        SmallestRoundedRectangleButton(
          buttonText: 'PRESENT', // Button Text
          onPressed: () {
            print('Button pressed'); // Action when button is pressed
          },
          // backgroundColor: AppColors.primaryBlue, // Custom background color
          // textColor: AppColors.scaffoldWithBoxBackground, // Custom text color
          // fontSize: 08, // Slightly larger font size for readability
         // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Custom padding
         // borderRadius: BorderRadius.circular(8), // Rounded corners with radius 8
        ),

        CustomCard(
          status: "Active",
          id: "1234",
          companyName: "Tech Corp",
          isActive: true,
        ),

        // Use UploadImageWidget as part of the widget tree
        // UploadImageWidget(
        //   title: 'Upload Image',
        //   onImagePicked: _onImagePicked,  // Pass the function that takes a File
        // ),
        SizedBox(height: 20),


        // Show the picked image if it's available
        _imageFile != null
            ? Image.file(_imageFile!, height: 200, width: 200)
            : Text('No image selected'),
        // Additional widgets or UI can be added here

        // InkWell(
        //   onTap: () {
        //     // Use UploadImageWidget as part of the widget tree
        //     UploadImageWidget(
        //       title: 'Upload Image',  // Custom title
        //       onImagePicked: _onImagePicked,  // Handle image picking
        //     );
        //     // Additional widgets or UI can be added here
        //   },
        //   child: Container(
        //     height: 70,
        //     decoration: BoxDecoration(
        //       color: AppColors.primaryWhitebg,
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.all(10.0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: [
        //           Container(
        //             padding: EdgeInsets.all(12),
        //             decoration: BoxDecoration(
        //               color: Color(0xffE6E0EF),
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //             child: SvgPicture.asset(
        //               "assets/icons/attendance/Upload-cam-svg.svg",
        //               height: 24,
        //               width: 24,
        //             ),
        //           ),
        //           const SizedBox(width: 10),
        //           Text(
        //             "Upload Image",
        //             style: GoogleFonts.nunitoSans(
        //               fontSize: 16,
        //               fontWeight: FontWeight.w700,
        //               color: AppColors.primaryBlackFont,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),

        // Text(
        //   'ExtraBold Text',
        //   style: FontStyles.extraBold800.copyWith(
        //     color: Colors.blue, // Adding color
        //     letterSpacing: 1.2, // Adding letter spacing
        //     height: 1.5, // Adjusting line height
        //   ),
        // ),
        // Text(
        //   'Bold Text',
        //   style: FontStyles.bold700.copyWith(
        //     color: Colors.red, // Adding color
        //     letterSpacing: 1.0, // Adding letter spacing
        //     height: 1.3, // Adjusting line height
        //   ),
        // ),
        // Text(
        //   'Medium Text',
        //   style: FontStyles.medium500.copyWith(
        //     color: Colors.green, // Adding color
        //     letterSpacing: 0.8, // Adding letter spacing
        //     height: 1.4, // Adjusting line height
        //   ),
        // ),
        // Text(
        //   'SemiBold Text',
        //   style: FontStyles.semiBold600.copyWith(
        //     color: Colors.orange, // Adding color
        //     letterSpacing: 1.0, // Adding letter spacing
        //     height: 1.4, // Adjusting line height
        //   ),
        // ),
        // Text(
        //   'Regular Text',
        //   style: FontStyles.regular400.copyWith(
        //     color: Colors.purple, // Adding color
        //     letterSpacing: 0.5, // Adding letter spacing
        //     height: 1.2, // Adjusting line height
        //   ),
        // ),
        // Text(
        //   'ExtraLight Text',
        //   style: FontStyles.extraLight200.copyWith(
        //     color: Colors.brown, // Adding color
        //     letterSpacing: 1.3, // Adding letter spacing
        //     height: 1.6, // Adjusting line height
        //   ),
        // ),
        // Text(
        //   'Light Text',
        //   style: FontStyles.light300.copyWith(
        //     color: Colors.black54, // Adding color
        //     letterSpacing: 0.9, // Adding letter spacing
        //     height: 1.3, // Adjusting line height
        //   ),
        // ),
      ],
    );
  }
}
