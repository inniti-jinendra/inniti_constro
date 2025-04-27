import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:inniti_constro/core/network/logger.dart';

import '../../../../../core/constants/font_styles.dart';
import '../../../../../widgets/dropdown/add_dropdowen_category_items.dart';
import '../../../../../widgets/dropdown/dropdowen_category_iteams.dart';
import '../../../../../widgets/helper/image_file_uplode_helper.dart';

class LabourMasterScreen {
  final int labourId;
  final int supplierId;
  final String labourSex;
  final String firstName;
  final String middleName;
  final String lastName;
  final int age;
  final String contactNo;
  final String aadharNo;
  final String profilePic;
  final int workingHrs;
  final int createdBy;
  final DateTime createdDate;
  final int lastUpdatedBy;
  final DateTime lastUpdatedDate;
  final double advanceAmount;
  final double totalWages;
  final double otRate;
  final String labourCode;
  final String labourCategory;
  final double commissionPerLabour;
  final int currencyId;
  final String companyCode;

  LabourMasterScreen({
    required this.labourId,
    required this.supplierId,
    required this.labourSex,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.age,
    required this.contactNo,
    required this.aadharNo,
    required this.profilePic,
    required this.workingHrs,
    required this.createdBy,
    required this.createdDate,
    required this.lastUpdatedBy,
    required this.lastUpdatedDate,
    required this.advanceAmount,
    required this.totalWages,
    required this.otRate,
    required this.labourCode,
    required this.labourCategory,
    required this.commissionPerLabour,
    required this.currencyId,
    required this.companyCode,
  });

  /// **Factory method to create a `Labour` object from JSON**
  factory LabourMasterScreen.fromJson(Map<String, dynamic> json) {
    return LabourMasterScreen(
      labourId: json['LABOUR_ID'] ?? 0,
      supplierId: json['SUPPLIER_ID'] ?? 0,
      labourSex: json['LABOUR_SEX'] ?? '',
      firstName: json['LABOUR_FIRSTNAME'] ?? '',
      middleName: json['LABOUR_MIDDLENAME'] ?? '',
      lastName: json['LABOUR_LASTNAME'] ?? '',
      age: json['LABOUR_AGE'] ?? 0,
      contactNo: json['LABOUR_CONTACTNO'] ?? '',
      aadharNo: json['LABOUR_AADHARNO'] ?? '',
      profilePic: json['LABOUR_PROFILEPIC'] ?? '',
      workingHrs: json['LABOUR_WORKINGHRS'] ?? 0,
      createdBy: json['CREATED_BY'] ?? 0,
      createdDate:
          DateTime.tryParse(json['CREATED_DATE'] ?? '') ?? DateTime.now(),
      lastUpdatedBy: json['LAST_UPDATED_BY'] ?? 0,
      lastUpdatedDate:
          DateTime.tryParse(json['LAST_UPDATED_DATE'] ?? '') ?? DateTime.now(),
      advanceAmount: (json['ADVANCE_AMOUNT'] ?? 0).toDouble(),
      totalWages: (json['TOTALWAGES'] ?? 0).toDouble(),
      otRate: (json['OTRATE'] ?? 0).toDouble(),
      labourCode: json['LABOUR_CODE'] ?? '',
      labourCategory: json['LABOUR_CATEGORY'] ?? '',
      commissionPerLabour: (json['COMMISSION_PER_LABOUR'] ?? 0).toDouble(),
      currencyId: json['CURRENCYID'] ?? 0,
      companyCode: json['companyCode'] ?? '',
    );
  }

  /// **Converts a `Labour` object to JSON**
  Map<String, dynamic> toJson() {
    return {
      "LABOUR_ID": labourId,
      "SUPPLIER_ID": supplierId,
      "LABOUR_SEX": labourSex,
      "LABOUR_FIRSTNAME": firstName,
      "LABOUR_MIDDLENAME": middleName,
      "LABOUR_LASTNAME": lastName,
      "LABOUR_AGE": age,
      "LABOUR_CONTACTNO": contactNo,
      "LABOUR_AADHARNO": aadharNo,
      "LABOUR_PROFILEPIC": profilePic,
      "LABOUR_WORKINGHRS": workingHrs,
      "CREATED_BY": createdBy,
      "CREATED_DATE": createdDate.toIso8601String(),
      "LAST_UPDATED_BY": lastUpdatedBy,
      "LAST_UPDATED_DATE": lastUpdatedDate.toIso8601String(),
      "ADVANCE_AMOUNT": advanceAmount,
      "TOTALWAGES": totalWages,
      "OTRATE": otRate,
      "LABOUR_CODE": labourCode,
      "LABOUR_CATEGORY": labourCategory,
      "COMMISSION_PER_LABOUR": commissionPerLabour,
      "CURRENCYID": currencyId,
      "companyCode": companyCode,
    };
  }

  /// **Helper method to convert a list of JSON objects to a list of `Labour` objects**
  static List<LabourMasterScreen> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LabourMasterScreen.fromJson(json)).toList();
  }

  /// **Helper method to convert a list of `Labour` objects to a list of JSON**
  static List<Map<String, dynamic>> toJsonList(
    List<LabourMasterScreen> labourList,
  ) {
    return labourList.map((labour) => labour.toJson()).toList();
  }
}

class CustomFormWidgets {
  static Widget buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: FontStyles.semiBold600.copyWith(
              color: AppColors.primaryBlackFont,
              fontSize: 13,
            ),
            children: isRequired
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ]
                : [],
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: _inputDecoration(label),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  static Widget buildDropdown({
    required BuildContext context,
    required String label,
    required List<String> items,
    required String? selectedItem,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              //fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 13,
            ),
            children: isRequired
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ]
                : [],
          ),
        ),
        const SizedBox(height: 4),
        FormField<String>(
          initialValue: selectedItem,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdown<String>.search(
                  hintText: "Select $label",
                  items: items,
                  initialItem: selectedItem,
                  onChanged: (value) {
                    state.didChange(value);
                    onChanged(value);
                  },
                  decoration: CustomDropdownDecoration(
                    expandedFillColor: AppColors.scaffoldWithBoxBackground,
                    closedFillColor: AppColors.primaryWhitebg,
                    hintStyle: TextStyle(color: AppColors.primaryBlackFont),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorText ?? '',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  static InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.primaryWhitebg,
      hintText: label,
      hintStyle: TextStyle(color: AppColors.primaryLightGrayFont),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    );
  }
}

// class CustomFormWidgets {
//   static Widget buildTextField({
//     required String label,
//     required String hint,
//     required TextEditingController controller,
//     String? Function(String?)? validator,
//     TextInputType keyboardType = TextInputType.text,
//     bool isRequired = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//          // label,
//           label + (isRequired ? ' *' : ''),
//           style: FontStyles.semiBold600.copyWith(
//             color: AppColors.primaryBlackFont,
//             fontSize: 12,
//           ),
//         ),
//         SizedBox(height: 5),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           validator: validator,
//           decoration: _inputDecoration(label),
//         ),
//         // Displaying the error message
//         // if (validator != null)
//         //   Padding(
//         //     padding: const EdgeInsets.only(top: 8.0),
//         //     child: Text(
//         //       validator(controller.text) ?? '',
//         //       style: FontStyles.semiBold600.copyWith(
//         //         fontSize: 12,
//         //         color: Colors.red, // Adding color
//         //       ),
//         //       overflow: TextOverflow.ellipsis,  // Handle text overflow
//         //       maxLines: 1,  // Ensure the error message doesn't take more than one line
//         //     ),
//         //
//         //   ),
//         SizedBox(height: 10),
//       ],
//     );
//   }
//
//   static Widget buildDropdown({
//     required BuildContext context,
//     required String label,
//     required List<String> items,
//     required String? selectedItem,
//     required Function(String?) onChanged,
//     String? Function(String?)? validator,
//     bool isRequired = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//             // label,
//             label + (isRequired ? ' *' : ''),
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 4),
//         // Using FormField to trigger validation when the dropdown value changes
//         FormField<String>(
//           initialValue: selectedItem,
//           validator: validator,
//           builder: (FormFieldState<String> state) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomDropdown<String>.search(
//                   hintText: "Select $label",
//                   items: items,
//                   initialItem: selectedItem,
//                   onChanged: (value) {
//                     state.didChange(value); // This updates the form field state
//                     onChanged(value); // Callback to notify parent widget
//                   },
//                   decoration: CustomDropdownDecoration(
//                     expandedFillColor: AppColors.scaffoldWithBoxBackground,
//                     closedFillColor: AppColors.primaryWhitebg,
//                     hintStyle: TextStyle(color: AppColors.primaryBlackFont),
//                   ),
//                 ),
//                 // Show error message if the dropdown is invalid
//                 if (state.hasError)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       state.errorText ?? '',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   static InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       filled: true,
//       fillColor: AppColors.primaryWhitebg,
//       hintText: label,
//       hintStyle: TextStyle(color: AppColors.primaryLightGrayFont),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide.none,
//       ),
//       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
//     );
//   }
// }

class LabourFormFields {
  static List<Widget> buildFormFields({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController firstNameController,
    required TextEditingController middleNameController,
    required TextEditingController lastNameController,
    required TextEditingController ageController,
    required TextEditingController mobileController,
    required TextEditingController idController,
    required TextEditingController workingHoursController,
    required TextEditingController otRateController,
    required TextEditingController wagesController,
    required TextEditingController commissionController,
    required List<String> contractorNames,
    required List<String> categoryNames,
    required String? selectedContractor,
    required String? selectedCategory,
    required String? selectedGender,
    required Function(String?) onContractorChanged,
    required Function(String?) onCategoryChanged,
    required Function(String?) onGenderChanged,
    required bool isImageUploaded, // Add isImageUploaded as a parameter
    required String? imagePath,
    required Function(bool)
    onUploadSuccess, // Callback for image upload success
  }) {
    return [
      // CustomFormWidgets.buildDropdown(
      //   context: context,
      //   label: "Contractor Name",
      //   items: contractorNames,
      //   selectedItem: selectedContractor,
      //   onChanged: (value) {
      //     AppLogger.info("Contractor selected: $value");
      //     onContractorChanged(value); // existing logic to update state
      //   },
      //   validator: (value) {
      //     if (value == null || value.isEmpty) {
      //       return 'Contractor Name is required';
      //     }
      //     return null;
      //   },
      // ),

      CustomFormWidgets.buildDropdown(
        context: context,
        label:  "Contractor Name",
        items: contractorNames,
        selectedItem: selectedContractor,
        onChanged: (value) {
          AppLogger.info("Contractor selected: $value");
          AppLogger.info("Contractor selected:=> ${value.toString()} (ID: ${value})");
          onContractorChanged(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Contractor Name is required';
          }
          return null;
        },
        isRequired: true,
      ),

      SizedBox(height: 10),
      CustomFormWidgets.buildDropdown(
        context: context,
        label: "Labour Category",
        items: categoryNames,
        selectedItem: selectedCategory,
        onChanged: onCategoryChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Labour Category is required';
          }
          return null;
        },
       // isRequired: true,
      ),

      // AddReusableDropdownCategory(
      //   label: "Select Labour Category",
      //   initialValue: selectedCategory,
      //   // Preselect value (optional)
      //   onChanged: (name, id) {
      //     print("Selected Category: $name (ID: $id)");
      //     // setState(() {
      //     //   selectedCategory = id ?? '';
      //     // });
      //   },
      // ),

      SizedBox(height: 10),
      CustomFormWidgets.buildTextField(
        label: "First Name",
        hint: "-- Enter First Name --",
        controller: firstNameController,
        validator: (value) {
          if (value == null || value.trim().isEmpty)
            return "First Name is required";
          if (value.length < 3)
            return "First Name must be at least 3 characters";
          return null;
        },
        isRequired: true,
      ),
      Row(
        children: [
          Expanded(
            child: CustomFormWidgets.buildTextField(
              label: "Middle Name",
              hint: "-- Middle Name --",
              controller: middleNameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Middle Name is required";
                return null;
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: CustomFormWidgets.buildTextField(
              label: "Last Name",
              hint: "-- Last Name --",
              controller: lastNameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Last Name is required";
                return null;
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: CustomFormWidgets.buildDropdown(
                context: context,
                label: "Gender",
                items: ["Male", "Female"],
                selectedItem: selectedGender,
                onChanged: onGenderChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gender is required';
                  }
                  return null;
                },
                isRequired: true,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: CustomFormWidgets.buildTextField(
              label: "Age",
              hint: "Age",
              controller: ageController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Age is required";
                if (int.tryParse(value) == null || int.parse(value) <= 0)
                  return "Enter a valid age";
                return null;
              },
            ),
          ),
        ],
      ),

      SizedBox(height: 15),
      Row(
        children: [
          Expanded(
            child: CustomFormWidgets.buildTextField(
              label: "Mobile Number",
              hint: "Mobile Number",
              controller: mobileController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Mobile number is required";
                if (!RegExp(r'^[0-9]{10}$').hasMatch(value))
                  return "Enter a valid 10-digit mobile number";
                return null;
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: CustomFormWidgets.buildTextField(
              label: "Aadhaar ID",
              hint: "Aadhaar Number",
              controller: idController,
              validator:
                  (value) =>
                      value == null || value.isEmpty ? "ID is required" : null,
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: CustomFormWidgets.buildTextField(
              label: "Working Hours",
              hint: "-- Enter Working Hours --",
              controller: workingHoursController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Working Hours are required";
                return null;
              },
              isRequired: true,
            ),

          ),
          SizedBox(width: 10),
          Expanded(
            child: CustomFormWidgets.buildTextField(
              label: "OT Rate/Hrs.",
              hint: "-- Enter OT Rate --",
              controller: otRateController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "OT Rate is required";
                return null;
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: CustomFormWidgets.buildTextField(
              label: "Wages/Per Day",
              hint: "-- Enter Wages --",
              controller: wagesController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Wages/Per Day is required";
                return null;
              },
              isRequired: true,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: CustomFormWidgets.buildTextField(
              label: "Commission Per Labour",
              hint: "-- Enter Commission --",
              controller: commissionController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Commission is required";
                return null;
              },
              isRequired: true,
            ),
          ),
        ],
      ),

      SizedBox(height: 10),

      //_buildUploadButton(context, onUploadSuccess, isImageUploaded),
      _buildUploadButton(context, onUploadSuccess, isImageUploaded, imagePath),


      // if (_capturedFilePath != null)
      //   Padding(
      //     padding: EdgeInsets.all(1.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           "📁 File path: $_capturedFilePath",
      //           style: TextStyle(fontSize: 14, color: Colors.green[800]),
      //         ),
      //         const SizedBox(height: 12),
      //         Container(
      //           height: 500,
      //           width: double.infinity,
      //           padding: EdgeInsets.all(1.0),
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           child: ClipRRect(
      //             borderRadius: BorderRadius.circular(8),
      //             child: FutureBuilder<File>(
      //               future: _getImageFile(),
      //               builder: (context, snapshot) {
      //                 if (snapshot.connectionState ==
      //                     ConnectionState.waiting) {
      //                   return Center(child: CircularProgressIndicator());
      //                 } else if (snapshot.hasError) {
      //                   return Center(
      //                     child: Text(
      //                       'Error loading image',
      //                       style: TextStyle(color: Colors.red),
      //                     ),
      //                   );
      //                 } else if (snapshot.hasData && snapshot.data != null) {
      //                   return Image.file(
      //                     snapshot.data!,
      //                     width: double.infinity,
      //                     fit: BoxFit.cover,
      //                   );
      //                 } else {
      //                   return Center(
      //                     child: Image.asset(
      //                       'assets/images/defult_constro_img.png',
      //                       width: double.infinity,
      //                       fit: BoxFit.cover,
      //                     ),
      //                   );
      //                 }
      //               },
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
    ];
  }

  // 🔽 Updated Upload Button with Image Path Update and Validation
  static Widget _buildUploadButton(
      BuildContext context,
      Function(bool) onUploadSuccess,
      bool isImageUploaded,
      String? imagePath,  // To hold the image file path or URL
      ) {
    // Log the current state of image upload (Initial state)
    AppLogger.info("Initial Image Upload State: $isImageUploaded");

    return Column(
      children: [
        // Display the image if uploaded, or a placeholder otherwise
        isImageUploaded && imagePath != null
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.file(
            File(imagePath),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        )
            : Container(),

        // The actual UploadButton widget
        UploadButton(
          isImageUploaded: isImageUploaded,
          onUploadSuccess: (isUploaded) {
            // Log the success or failure of the upload process
            if (isUploaded) {
              AppLogger.info("Image upload was successful.");
            } else {
              AppLogger.error("Image upload failed.");
            }

            // Update the state based on upload success
            onUploadSuccess(isUploaded);
          },
        ),
      ],
    );
  }


  // Future<File> _getImageFile() async {
  //   await Future.delayed(Duration(seconds: 2));
  //   return File(_capturedFilePath!);
  // }

}
