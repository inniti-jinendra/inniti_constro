import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inniti_constro/core/models/system/dropdown_item.dart';
import 'package:inniti_constro/core/network/api_endpoints.dart';
import 'package:inniti_constro/core/network/logger.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/labour/labor.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/labour/labour_api_service.dart';
import '../../../../core/services/system/system_api_service.dart';
import '../../../../core/utils/secure_storage_util.dart';
import '../../../../widgets/CustomToast/custom_snackbar.dart';
import '../../../../widgets/alert_dialog/custom_alert_dialog.dart';
import '../../../../widgets/custom_card/custom_card.dart';
import '../../../../widgets/custom_dialog/custom_confirmation_dialog.dart';
import '../../../../widgets/custom_dialog/custom_dialog.dart';
import '../../../../widgets/dropdown/dropdowen_category_iteams.dart';
import '../../../../widgets/global_loding/global_loader.dart';

import 'provider/labour_provider.dart';
import 'widget/dilog_form_screen.dart';

// ✅ Main UI Page
class LaboursPage extends ConsumerStatefulWidget {
  const LaboursPage({super.key});

  @override
  ConsumerState<LaboursPage> createState() => _LaboursPageState();
}

class _LaboursPageState extends ConsumerState<LaboursPage> {
  ScrollController _scrollController = ScrollController();

  //List<Map<String, dynamic>> filteredLabours = [];
  List<Labour> filteredLabours = [];
  bool isLoading = true;
  bool _isLoading = false;
  List<Map<String, String>> categories = [];

  String selectedCategory = '';
  String? selectedGender = "Male"; // Default value for gender

  List<Labour> labours = []; // This should be populated with your labours list

  // Controllers for the filter fields
  TextEditingController labourController = TextEditingController();
  TextEditingController contractorController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.pixels >=
  //         _scrollController.position.maxScrollExtent - 200) {
  //       if (ref.read(labourListProvider.notifier).hasMoreData &&
  //           !ref.read(labourListProvider.notifier).isLoading) {
  //         ref.read(labourListProvider.notifier).loadLabours(
  //               context: context,
  //             );
  //       }
  //     }
  //   });
  //
  //   // Add listener to the scroll controller to detect when to load more data
  //   //_scrollController.addListener(_scrollListener);
  //
  //   filteredLabours = List.from(ref.read(labourListProvider));
  //
  //   Future.microtask(
  //     () => ref.read(labourListProvider.notifier).loadLabours(context: context),
  //   );
  //
  //   _fetchCategories();
  //
  //   // Listen to provider changes to trigger UI refresh if new data is fetched
  //   // ref.listen(labourListProvider, (previous, next) {
  //   //   // This will trigger a UI refresh when the data in the provider changes
  //   //   if (next != previous) {
  //   //     setState(() {
  //   //       filteredLabours = List.from(next); // Update filteredLabours when the provider updates
  //   //     });
  //   //   }
  //   // });
  //
  // }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _initializeScrollListener();
    _loadInitialData();
    _fetchCategories();
  }

  void _initializeScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (ref.read(labourListProvider.notifier).hasMoreData &&
            !ref.read(labourListProvider.notifier).isLoading) {
          _loadMoreLabours();
        }
      }
    });
  }

  void _loadInitialData() {
    filteredLabours = List.from(ref.read(labourListProvider));

    // Fetch labours data asynchronously
    Future.microtask(() => _loadLabours());
  }

  void _loadMoreLabours() {
    ref.read(labourListProvider.notifier).loadLabours(context: context);
  }

  // ✅ Add _loadLabours method that fetches data from the provider
  Future<void> _loadLabours() async {
    await ref.read(labourListProvider.notifier).loadLabours(context: context);
  }



  Future<void> _fetchCategories() async {
    AppLogger.debug("🚀 Starting _fetchCategories...");

    try {
      final url = Uri.parse(
          "http://192.168.1.28:1010/api/DropDownHendler/Fetch-LabourCategory-DDL");
      AppLogger.debug("🌐 API URL: $url");

      final String? authToken =
          await SharedPreferencesUtil.getString("GeneratedToken");
      final String? companyCode =
          await SecureStorageUtil.readSecureData("CompanyCode");

      AppLogger.debug("🔑 Retrieved AuthToken: $authToken");
      AppLogger.debug("🏢 Retrieved CompanyCode: $companyCode");

      if (authToken == null || companyCode == null) {
        AppLogger.error("❌ Missing token or company code");
        setState(() {
          isLoading = false;
        });
        return;
      }

      final headers = {
        'Authorization': '$authToken',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'CompanyCode': companyCode,
      });

      AppLogger.debug("📦 Request Headers: $headers");
      AppLogger.debug("📝 Request Body: $body");

      final response = await http.post(url, headers: headers, body: body);

      AppLogger.debug(
          "📬 Response Status Code for Category: ${response.statusCode}");
      AppLogger.debug("📨 Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('Data') && data['Data'] is List) {
          final List<dynamic> dataList = data['Data'];
          AppLogger.debug("✅ Parsed Data List: $dataList");

          setState(() {
            categories = dataList
                .map<Map<String, String>>((item) {
                  final value = item['LabourCategoryValue']?.toString() ?? '';
                  final text = item['LabourCategoryText']?.toString() ?? '';
                  AppLogger.debug(
                      "🔹 Mapped Category Item: {value: $value, text: $text}");
                  return {"value": value, "text": text};
                })
                .where((map) =>
                    map['value']!.isNotEmpty && map['text']!.isNotEmpty)
                .toList();

            isLoading = false;
          });

          AppLogger.debug("🎯 Categories Set in State: $categories");
        } else {
          AppLogger.error("❗ 'Data' key missing or not a List in response.");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        AppLogger.error(
            "❌ API Error: ${response.statusCode} ${response.reasonPhrase}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        isLoading = false;
      });
      AppLogger.error("🔥 Exception in _fetchCategories: $e");
      AppLogger.error("🧱 Stack Trace: $stackTrace");
    }
  }

  void clearFilters() {
    setState(() {
      labourController.clear();
      contractorController.clear();
      mobileController.clear();
      filteredLabours = List.from(ref.read(labourListProvider));
    });
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final labourNotifier = ref.read(labourListProvider.notifier);

            // Initialize selectedCategory with an empty string
            String selectedCategory = '';

            return StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    height: 450,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cancel & Search Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Check if at least one filter is provided
                                if (labourController.text.isEmpty &&
                                    contractorController.text.isEmpty &&
                                    selectedCategory.isEmpty) {
                                  return; // No action if no filter is provided
                                }

                                // Apply the filter with the selectedCategory
                                labourNotifier.filterLabours(
                                  labourName: labourController.text,
                                  contractorName: contractorController.text,
                                  labourCategory: selectedCategory,
                                );

                                Navigator.pop(context);
                              },
                              child: const Text(
                                'SEARCH',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Labour Name Field
                        TextField(
                          controller: labourController,
                          decoration: InputDecoration(
                            labelText: "Labour Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Contractor Name Field
                        TextField(
                          controller: contractorController,
                          decoration: InputDecoration(
                            labelText: "Contractor Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // DropdownButtonFormField<String>(
                        //   value: selectedCategory.isEmpty ? null : selectedCategory,
                        //   decoration: InputDecoration(
                        //     labelText: "Labour Category",
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //   ),
                        //   items: isLoading
                        //       ? [DropdownMenuItem(value: null, child: Text('Loading...'))]
                        //       : categories.map((categoryMap) {
                        //     return DropdownMenuItem(
                        //       value: categoryMap['value'],
                        //       child: Text(categoryMap['text']!),
                        //     );
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     if (value != null) {
                        //       setState(() {
                        //         selectedCategory = value;
                        //       });
                        //     }
                        //   },
                        // ),

                        ReusableDropdownCategory(
                          label: "Select Labour Category",
                          initialValue: "Electrician",
                          // Preselect value (optional)
                          onChanged: (name, id) {
                            print("Selected Category: $name (ID: $id)");
                            setState(() {
                              selectedCategory = id ?? '';
                            });
                          },
                        ),


                        const SizedBox(height: 16),

                        // Clear Filters Button
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              labourController.clear();
                              contractorController.clear();
                              selectedCategory = ''; // Clear selected category
                            });
                            labourNotifier.clearFilters();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                          ),
                          child: const Text(
                            'CLEAR FILTERS',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void filterLabours({String labourCategory = ''}) {
    // Retrieve filter values from the controllers
    String labourName = labourController.text.toLowerCase();
    String contractorName = contractorController.text.toLowerCase();
    String mobileNumber = mobileController.text.toLowerCase();

    setState(() {
      filteredLabours = ref.read(labourListProvider).where((labour) {
        bool matchesLabour = labourName.isEmpty ||
            labour.labourName.toLowerCase().contains(labourName);
        bool matchesContractor = contractorName.isEmpty ||
            labour.contractorName.toLowerCase().contains(contractorName);
        bool matchesCategory = labourCategory.isEmpty ||
            (labour.labourCategory?.toLowerCase() ?? '')
                .contains(labourCategory.toLowerCase());

        return matchesLabour && matchesContractor && matchesCategory;
      }).toList();
    });
  }

  Future<void> showAddLabourDialog(BuildContext context) async {
    //GlobalLoader.show(context);

    // Controllers for Text Fields
    final firstNameController = TextEditingController();
    final middleNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final ageController = TextEditingController();
    final mobileController = TextEditingController();
    final idController = TextEditingController();
    final workingHoursController = TextEditingController();
    final otRateController = TextEditingController();
    final wagesController = TextEditingController();
    final commissionController = TextEditingController();

    // Form Key for Validation
    final _formKey = GlobalKey<FormState>();

    //final List<SuppliersDDL> contractors;

    List<String> contractorNames = [];
    List<int> ContractorID = [];
    List<String> categoryNames = [];

    String? selectedContractor;
    String? selectedCategory;
    String? selectedGender;
    bool isImageUploaded = false;
    String? _capturedFilePath;

    try {
      final contractors = await SystemApiService.fetchContractors();
      final categories = await SystemApiService.fetchLabourCategories();

      AppLogger.info('Contractors fetched: ${contractors.length}');
      AppLogger.info('Categories fetched: ${categories.length}');

      // Log contractor details with both name and ID
      contractors.forEach((contractor) {
        AppLogger.info('Contractor Name: ${contractor.name}, Contractor ID: ${contractor.id}');
      });


      contractorNames = contractors.map((c) => c.name).toSet().toList();
      ContractorID = contractors.map((c) => c.id).toSet().toList();
      categoryNames = categories.map((c) => c.name).toList();

      AppLogger.info('Contractor names: $contractorNames');
      AppLogger.info('Contractor ID: $ContractorID');
      AppLogger.info('Category names: $categoryNames');

      GlobalLoader.hide();
    } catch (error) {
      CustomSnackbar.show(context, message: 'Failed to load data');
      GlobalLoader.hide();
      return;
    }

    // String? selectedContractor =
    //     contractorNames.isNotEmpty ? contractorNames.first : null;
    //
    // String? selectedCategory =
    //     categoryNames.isNotEmpty ? categoryNames.first : null;
    //
    // String? imagePath;

    GlobalLoader.hide(); // Hide the loader as data is fetched

    //bool isImageUploaded = false;

    CustomDialog.show(
      context,
      title: "Add Labour Person",
      formFields: [
        Form(
          key: _formKey,
          child: Column(
            children: LabourFormFields.buildFormFields(
              context: context,
              formKey: _formKey,
              firstNameController: firstNameController,
              middleNameController: middleNameController,
              lastNameController: lastNameController,
              ageController: ageController,
              mobileController: mobileController,
              idController: idController,
              workingHoursController: workingHoursController,
              otRateController: otRateController,
              wagesController: wagesController,
              commissionController: commissionController,
              contractorNames: contractorNames,
              categoryNames: categoryNames,
              selectedContractor: selectedContractor,
              selectedCategory: selectedCategory,
              selectedGender: selectedGender,
              imagePath: _capturedFilePath,
              onContractorChanged: (value) {
                selectedContractor = value;
              },
              onCategoryChanged: (value) {
                selectedCategory = value;
              },
              onGenderChanged: (value) {
                selectedGender = value;
              },
              isImageUploaded: isImageUploaded,
              onUploadSuccess: (uploadStatus) {
                setState(() {
                  isImageUploaded = uploadStatus;
                });
              },
            ),
          ),
        ),
      ],

      // onSave: () async {
      //   AppLogger.info("Form validation started.");
      //
      //   if (!_formKey.currentState!.validate()) {
      //     AppLogger.warn("Form validation failed.");
      //     CustomSnackbar.show(
      //       context,
      //       message: "Please fix the errors in the form.",
      //       isError: true,
      //     );
      //     return;
      //   }
      //
      //   AppLogger.info("Form validation passed.");
      //   logFormValues(
      //     firstNameController,
      //     middleNameController,
      //     lastNameController,
      //     ageController,
      //     mobileController,
      //     idController,
      //     workingHoursController,
      //     otRateController,
      //     wagesController,
      //     commissionController,
      //     selectedContractor,
      //     selectedCategory,
      //   );
      //
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   String? imagePath = prefs.getString('imagePath');
      //
      //   if (imagePath == null || imagePath.isEmpty) {
      //     AppLogger.warn("No image uploaded. Please upload an image.");
      //     CustomSnackbar.show(
      //       context,
      //       message: "Image upload is required.",
      //       isError: true,
      //     );
      //     return;
      //   } else {
      //     AppLogger.info("Image uploaded successfully. Path: $imagePath");
      //
      //     String base64Image = await _convertImageToBase64(imagePath);
      //
      //     if (base64Image.isEmpty) {
      //       AppLogger.warn("Failed to convert the image to Base64.");
      //       CustomSnackbar.show(
      //         context,
      //         message:
      //             "Failed to convert the image. Please upload a valid image.",
      //         isError: true,
      //       );
      //       return;
      //     } else {
      //       AppLogger.info("Base64 Image conversion successful.");
      //     }
      //   }
      //
      //   bool? confirm = await CustomAlertDialog.show(
      //     context: context,
      //     title: "Confirm Save",
      //     message: "Are you sure you want to save this Labour Person?",
      //     confirmText: "Save",
      //     cancelText: "Cancel",
      //     onConfirm: () async {
      //       AppLogger.info("User confirmed saving the labour person.");
      //
      //       if (_formKey.currentState!.validate()) {
      //         try {
      //           AppLogger.info("Saving labour person started.");
      //           GlobalLoader.show(context);
      //           await Future.delayed(Duration(seconds: 1));
      //           GlobalLoader.hide();
      //           CustomSnackbar.show(
      //             context,
      //             message: "Labour person added successfully",
      //             isError: false,
      //           );
      //           AppLogger.info("Labour person added successfully.");
      //
      //           await prefs.remove('imagePath');
      //           AppLogger.info("Image path removed from SharedPreferences.");
      //
      //           clearForm(
      //             firstNameController,
      //             middleNameController,
      //             lastNameController,
      //             ageController,
      //             mobileController,
      //             idController,
      //             workingHoursController,
      //             otRateController,
      //             wagesController,
      //             commissionController,
      //           );
      //
      //           setState(() {
      //             selectedContractor = null;
      //             selectedCategory = null;
      //             imagePath = null;
      //           });
      //
      //           Navigator.pop(context);
      //         } catch (e) {
      //           AppLogger.error(
      //             "Error occurred while saving the labour person: $e",
      //           );
      //           CustomSnackbar.show(
      //             context,
      //             message: "Failed to add the labour person.",
      //             isError: true,
      //           );
      //         }
      //       }
      //     },
      //   );
      //
      //   if (confirm == null || !confirm) {
      //     AppLogger.info("User canceled the save action.");
      //     return;
      //   }
      // },


      onSave: () async {
        AppLogger.info("Form validation started.");

        // Manual validation for required fields
        if (selectedContractor == null || selectedContractor!.isEmpty) {
          CustomSnackbar.show(context, message: "Please select a contractor.", isError: true);
          return;
        }

        if (firstNameController.text.trim().isEmpty) {
          CustomSnackbar.show(context, message: "First Name is required.", isError: true);
          return;
        }

        if (selectedGender == null || selectedGender!.isEmpty) {
          CustomSnackbar.show(context, message: "Please select a gender.", isError: true);
          return;
        }

        if (workingHoursController.text.trim().isEmpty) {
          CustomSnackbar.show(context, message: "Working Hours are required.", isError: true);
          return;
        }

        if (wagesController.text.trim().isEmpty) {
          CustomSnackbar.show(context, message: "Wages are required.", isError: true);
          return;
        }

        if (commissionController.text.trim().isEmpty) {
          CustomSnackbar.show(context, message: "Commission is required.", isError: true);
          return;
        }


        // ✅ All validations passed — log everything (even optional)
        AppLogger.info("Form validation passed. Logging values:");
        AppLogger.info("First Name: ${firstNameController.text}");
        AppLogger.info("Selected Gender: $selectedGender");
        AppLogger.info("Selected Contractor: $selectedContractor");
        AppLogger.info("Working Hours: ${workingHoursController.text}");
        AppLogger.info("Wages: ${wagesController.text}");
        AppLogger.info("Commission: ${commissionController.text}");
        AppLogger.info("Middle Name: ${middleNameController.text}");
        AppLogger.info("Last Name: ${lastNameController.text}");
        AppLogger.info("Age: ${ageController.text}");
        AppLogger.info("Mobile No: ${mobileController.text}");
        AppLogger.info("Aadhar ID: ${idController.text}");
        AppLogger.info("OT Rate: ${otRateController.text}");
        AppLogger.info("Selected Category: $selectedCategory");
        //AppLogger.info("Labour ID: $labourId");


        // // Get the index of the selected contractor
        // int? selectedContractorIndex = contractorNames.indexOf(selectedContractor!);
        //
        // // Log the corresponding ContractorId
        // if (selectedContractorIndex != -1) {
        //   int contractorId = ContractorID[selectedContractorIndex];
        //   AppLogger.info("Selected Contractor ID: $contractorId");
        //   AppLogger.info("Supplier ID: $contractorId");
        // } else {
        //   AppLogger.warn("Selected contractor not found in the list.");
        // }

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // String? imagePath = prefs.getString('imagePath');
        //
        // String? base64Image;
        //
        // if (imagePath != null && imagePath.isNotEmpty) {
        //   AppLogger.info("Image uploaded successfully. Path: $imagePath");
        //
        //   base64Image = await _convertImageToBase64(imagePath);
        //
        //   if (base64Image.isNotEmpty) {
        //     AppLogger.info("Base64 Image conversion successful.");
        //     AppLogger.info("Base64 Image Length: ${base64Image.length}");
        //   } else {
        //     AppLogger.warn("Base64 conversion returned empty. Possibly invalid image.");
        //   }
        // } else {
        //   AppLogger.info("No image uploaded. Proceeding without image.");
        //   base64Image = null;
        // }



        // CustomSnackbar.show(
        //   context,
        //   message: "Form validated successfully. Check logs for data.",
        //   isError: false,
        // );

        // bool? confirm = await CustomAlertDialog.show(
        //   context: context,
        //   title: "Confirm Save",
        //   message: "Are you sure you want to save this Labour Person?",
        //   confirmText: "Save",
        //   cancelText: "Cancel",
        //   onConfirm: () async {
        //     AppLogger.info("User confirmed saving the labour person.");
        //
        //         AppLogger.info("Saving labour person started.");
        //         GlobalLoader.show(context);
        //         await Future.delayed(Duration(seconds: 1));
        //         GlobalLoader.hide();
        //         CustomSnackbar.show(
        //           context,
        //           message: "Labour person added successfully",
        //           isError: false,
        //         );
        //         AppLogger.info("Labour person added successfully.");
        //
        //         // Clear form
        //         clearForm(
        //           firstNameController,
        //           middleNameController,
        //           lastNameController,
        //           ageController,
        //           mobileController,
        //           idController,
        //           workingHoursController,
        //           otRateController,
        //           wagesController,
        //           commissionController,
        //         );
        //
        //         setState(() {
        //           selectedContractor = null;
        //           selectedCategory = null;
        //           imagePath = null;
        //           //base64Image = '';
        //         });
        //
        //         // ✅ Clear shared prefs image path
        //         await prefs.remove('imagePath');
        //         AppLogger.info("Image path cleared from SharedPreferences.");
        //
        //         Navigator.pop(context);
        //        // Navigator.pop(context);
        //
        //     // Refresh the list of labours after saving
        //     await ref.read(labourListProvider.notifier).loadLabours(context: context);
        //     AppLogger.info("Labours list refreshed.");
        //
        //   },
        // );

        bool? confirm = await CustomAlertDialog.show(
          context: context,
          title: "Confirm Save",
          message: "Are you sure you want to save this Labour Person?",
          confirmText: "Save",
          cancelText: "Cancel",
          onConfirm: () async {
            AppLogger.info("User confirmed saving the labour person.");

            // Ensure contractorId is set based on the selected contractor
            int contractorId = 0;
            if (selectedContractor != null && selectedContractor!.isNotEmpty) {
              // Get the index of the selected contractor and fetch the corresponding contractor ID
              int? selectedContractorIndex = contractorNames.indexOf(selectedContractor!);
              if (selectedContractorIndex != -1) {
                contractorId = ContractorID[selectedContractorIndex];
                AppLogger.info("Selected Contractor ID api caling : $contractorId");
              } else {
                AppLogger.warn("Selected contractor not found in the list.");
                CustomSnackbar.show(context, message: "Invalid contractor selected.", isError: true);
                return;
              }
            } else {
              AppLogger.warn("No contractor selected.");
              CustomSnackbar.show(context, message: "Please select a contractor.", isError: true);
              return;
            }
            // Add the labour data via API
            try {
              AppLogger.info("Saving labour person started.");
              GlobalLoader.show(context);

              // Try parsing the text input to double, fallback to 0.0 if invalid
              double wages = double.tryParse(wagesController.text) ?? 0.0;
              double otRate = double.tryParse(otRateController.text) ?? 0.0;
              double commission = double.tryParse(commissionController.text) ?? 0.0;

              // Log parsed values
              AppLogger.info("Labour Wages: $wages");
              AppLogger.info("Labour OT Rate: $otRate");
              AppLogger.info("Labour Commission: $commission");

              AppLogger.info("Selected Contractor ID api =>  $contractorId");
              AppLogger.info("Selected Contractor =>  $selectedGender");
              AppLogger.info("Selected contractorId =>  $contractorId");

              // Log the data to be sent to the API
              AppLogger.info("Saving new labour person. Logging data:");

              AppLogger.info("Labour First Name: ${firstNameController.text}");
              AppLogger.info("Labour Middle Name: ${middleNameController.text}");
              AppLogger.info("Labour Last Name: ${lastNameController.text}");
              AppLogger.info("Labour Gender: $selectedGender");
              AppLogger.info("Labour Age: ${ageController.text}");
              AppLogger.info("Labour Mobile No: ${mobileController.text}");
              AppLogger.info("Labour Aadhar No: ${idController.text}");
              AppLogger.info("Labour Working Hours: ${workingHoursController.text}");
              AppLogger.info("Labour Wages: ${wagesController.text}");
              AppLogger.info("Labour OT Rate: ${0}");
              AppLogger.info("Labour Commission: ${commissionController.text}");
              AppLogger.info("Labour Category: $selectedCategory");
              AppLogger.info("Labour Supplier ID: $contractorId");
              AppLogger.info("Labour Created By: 13125");
              AppLogger.info("Labour Created Date: ${DateTime.now().toIso8601String()}");
              AppLogger.info("Labour Company Code: CONSTRO");


              // final labourData = {
              //   "labourId": 0,
              //   "supplierId": contractorId,
              //   "labourSex": selectedGender ?? " ",
              //   "labourFirstName": firstNameController.text,
              //   "labourMiddleName": middleNameController.text,
              //   "labourLastName": lastNameController.text,
              //   "labourAge": int.tryParse(ageController.text) ?? 0,
              //   "labourContactNo": mobileController.text,
              //   "labourAadharNo": idController.text,
              //   "labourWorkingHrs": int.tryParse(workingHoursController.text) ?? 0,
              //   "createdBy": 13125,
              //   "createdDate": DateTime.now().toIso8601String(),
              //   "advanceAmount": wages,
              //   "totalWages": double.parse(wagesController.text),
              //   "otRate": double.parse(otRateController.text),
              //   "labourCode": 0 ,
              //   "labourCategory": selectedCategory ?? "",
              //   "commissionPerLabour": double.parse(commissionController.text),
              //   "currencyId": 1001,
              //   "companyCode": "CONSTRO",
              // };
              //
              // AppLogger.info("Labour data to be sent to API for add: $labourData");



              bool isLabourAdded = await LabourApiService().addLabour(
                labourId: 0,
                supplierId: contractorId,
                labourSex: selectedGender ?? " ",
                labourFirstName: firstNameController.text.trim(),
                labourMiddleName: middleNameController.text.trim(),
                labourLastName: lastNameController.text.trim(),
                labourAge: int.tryParse(ageController.text.trim()) ?? 0,
                labourContactNo: mobileController.text.trim(),
                labourAadharNo: idController.text.trim(),
                labourWorkingHrs: int.tryParse(workingHoursController.text.trim()) ?? 0,
                createdBy: 13125,
                createdDate: DateTime.now().toIso8601String(),
                advanceAmount: double.tryParse(wagesController.text.trim()) ?? 0.0,
                totalWages: double.tryParse(wagesController.text.trim()) ?? 0.0,
                otRate: 0,
                labourCode: " ",
                labourCategory: selectedCategory ?? "",
                commissionPerLabour: double.tryParse(commissionController.text.trim()) ?? 0.0,
                currencyId: 1001,
                companyCode: "CONSTRO",
            );

              // // Now call the API method to save the labour person
              // bool isLabourAdded = await LabourApiService().addLabour(
              //   labourId: 0,  // Or fetch the ID if needed
              //   supplierId: contractorId,  // Or fetch the ID if needed
              //   labourSex: selectedGender ?? " ",  // Default to Male if not selected
              //   labourFirstName: firstNameController.text,
              //   labourMiddleName: middleNameController.text,
              //   labourLastName: lastNameController.text,
              //   labourAge: int.parse(ageController.text),
              //   labourContactNo: mobileController.text,
              //   labourAadharNo: idController.text,
              //   labourWorkingHrs: int.parse(workingHoursController.text),
              //   createdBy: 13125,
              //   createdDate: DateTime.now().toIso8601String(),
              //   advanceAmount: double.parse(wagesController.text),
              //   totalWages: double.parse(wagesController.text),
              //   otRate: otRateController.text,  // Make sure to parse if needed
              //   labourCode: " ",  // Or use a relevant code if available
              //   labourCategory: selectedCategory ?? "",
              //   commissionPerLabour: double.parse(commissionController.text),
              //   currencyId: 1001,  // Example, replace if needed
              //   companyCode: "CONSTRO",  // Example, replace if needed
              // );


              GlobalLoader.hide();

              if (isLabourAdded) {
                CustomSnackbar.show(
                  context,
                  message: "Labour person added successfully",
                  isError: false,
                );
                AppLogger.info("Labour person added successfully.");

                // Clear form
                clearForm(
                  firstNameController,
                  middleNameController,
                  lastNameController,
                  ageController,
                  mobileController,
                  idController,
                  workingHoursController,
                  otRateController,
                  wagesController,
                  commissionController,
                );

                setState(() {
                  selectedContractor = null;
                  selectedCategory = null;
                  //imagePath = null;
                 // base64Image = '';
                });

                // ✅ Refresh first
                //await ref.read(labourListProvider.notifier).loadLabours(context: context);
                //AppLogger.info("Labours list refreshed.");
                //Navigator.pop(context);

                await ref.read(labourListProvider.notifier).loadLabours(refresh: true, context: context);
                AppLogger.info("Labours list refreshed.");

                // ✅ THEN pop back to the previous screen
                Navigator.pop(context);
                AppLogger.info("POP OUT FOR BACK ");

              } else {
                CustomSnackbar.show(
                  context,
                  message: "Failed to add the labour person.",
                  isError: true,
                );
                AppLogger.warn("API returned failure when adding labour.");
              }

            } catch (e, stacktrace) {
              GlobalLoader.hide();
              AppLogger.error("Error occurred while saving the labour person: $e");
              AppLogger.error("Stack trace: $stacktrace");  // Log the stack trace to get more details.

              CustomSnackbar.show(
                context,
                message: "Failed to add the labour person.",
                isError: true,
              );
            }

          },
        );

        if (confirm == null || !confirm) {
          AppLogger.info("User canceled the save action.");
          return;
        }
      },







        //     // working
      // onSave: () async {
      //   AppLogger.info("Form validation started.");
      //
      //   if (!_formKey.currentState!.validate()) {
      //     AppLogger.warn("Form validation failed.");
      //     CustomSnackbar.show(
      //       context,
      //       message: "Please fix the errors in the form.",
      //       isError: true,
      //     );
      //     return;
      //   }
      //
      //   AppLogger.info("Form validation passed.");
      //   AppLogger.info("Collected Form Values:");
      //   AppLogger.info("First Name: ${firstNameController.text}");
      //   AppLogger.info("Middle Name: ${middleNameController.text}");
      //   AppLogger.info("Last Name: ${lastNameController.text}");
      //   AppLogger.info("Age: ${ageController.text}");
      //   AppLogger.info("Mobile No: ${mobileController.text}");
      //   AppLogger.info("Aadhar ID: ${idController.text}");
      //   AppLogger.info("Working Hours: ${workingHoursController.text}");
      //   AppLogger.info("OT Rate: ${otRateController.text}");
      //   AppLogger.info("Wages: ${wagesController.text}");
      //   AppLogger.info("Commission: ${commissionController.text}");
      //   AppLogger.info("Selected Contractor: $selectedContractor");
      //   AppLogger.info("Selected Category: $selectedCategory");
      //
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   String? imagePath = prefs.getString('imagePath');
      //   AppLogger.info("Uploaded image retrieved. Path: $imagePath");
      //
      //   if (imagePath == null || imagePath.isEmpty) {
      //     AppLogger.warn(
      //         "No image uploaded. User has not provided an image path.");
      //     CustomSnackbar.show(
      //       context,
      //       message: "Image upload is required.",
      //       isError: true,
      //     );
      //     return;
      //   }
      //
      //   String base64Image = await _convertImageToBase64(imagePath);
      //   if (base64Image.isEmpty) {
      //     AppLogger.warn(
      //         "Failed to convert the image to Base64. Path: $imagePath");
      //     CustomSnackbar.show(
      //       context,
      //       message:
      //           "Failed to convert the image. Please upload a valid image.",
      //       isError: true,
      //     );
      //     return;
      //   }
      //
      //   AppLogger.info(
      //       "Base64 Image conversion successful. Length: ${base64Image.length}");
      //
      //   bool? confirm = await CustomAlertDialog.show(
      //     context: context,
      //     title: "Confirm Save",
      //     message: "Are you sure you want to save this Labour Person?",
      //     confirmText: "Save",
      //     cancelText: "Cancel",
      //     onConfirm: () async {
      //       AppLogger.info("User confirmed saving the labour person.");
      //
      //       try {
      //         GlobalLoader.show(context);
      //
      //         print("${selectedContractor}");
      //         print("selectedContractor...");
      //
      //
      //         bool isLabourAdded = await LabourApiService().addLabour(
      //           labourId: 0,
      //           supplierId: 0,
      //           labourSex: "Male",
      //           labourFirstName: firstNameController.text,
      //           labourMiddleName: middleNameController.text,
      //           labourLastName: lastNameController.text,
      //           labourAge: int.parse(ageController.text),
      //           labourContactNo: mobileController.text,
      //           labourAadharNo: idController.text,
      //           labourWorkingHrs: int.parse(workingHoursController.text),
      //           createdBy: 13125,
      //           createdDate: DateTime.now().toIso8601String(),
      //           advanceAmount: double.parse(wagesController.text),
      //           totalWages: double.parse(wagesController.text),
      //           otRate: double.parse(otRateController.text),
      //           labourCode: "0",
      //           labourCategory: selectedCategory ?? "",
      //           commissionPerLabour: double.parse(commissionController.text),
      //           currencyId: 1001,
      //           companyCode: "CONSTRO",
      //         );
      //
      //         GlobalLoader.hide();
      //
      //         if (isLabourAdded) {
      //
      //           CustomSnackbar.show(
      //             context,
      //             message: "Labour person added successfully",
      //             isError: false,
      //           );
      //
      //           AppLogger.info("Labour person added successfully.");
      //           await prefs.remove('imagePath');
      //
      //           clearForm(
      //             firstNameController,
      //             middleNameController,
      //             lastNameController,
      //             ageController,
      //             mobileController,
      //             idController,
      //             workingHoursController,
      //             otRateController,
      //             wagesController,
      //             commissionController,
      //           );
      //
      //           setState(() {
      //             selectedContractor = null;
      //             selectedCategory = null;
      //           });
      //
      //           Navigator.pop(context);
      //         } else {
      //           CustomSnackbar.show(
      //             context,
      //             message: "Failed to add the labour person.",
      //             isError: true,
      //           );
      //           AppLogger.warn("API returned failure when adding labour.");
      //         }
      //       } catch (e) {
      //         GlobalLoader.hide();
      //         AppLogger.error(
      //             "Error occurred while saving the labour person: $e");
      //         CustomSnackbar.show(
      //           context,
      //           message: "Failed to add the labour person.",
      //           isError: true,
      //         );
      //       }
      //     },
      //   );
      //
      //   if (confirm == null || !confirm) {
      //     AppLogger.info("User canceled the save action.");
      //     return;
      //   }
      // },

      onClose: () async {
        // bool? confirm = await CustomAlertDialog.show(
        //   context: context,
        //   title: "Confirm Cancel",
        //   message:
        //       "Are you sure you want to cancel? Any unsaved changes will be lost.",
        //   confirmText: "Exit",
        //   cancelText: "Stay",
        //   onConfirm: () {
        //     Navigator.pop(context);
        //   },
        // );
        //
        // if (confirm == null || !confirm) return;

        // Your additional logic to handle the closure after confirmation
        Navigator.pop(context); // Close the current screen or action
      },
    );
  }

  Future<void> showLabourEditDialog(
    BuildContext context, {
    String saveButtonText = "Edit",
    LabourModel? existingLabour,
  }) async {
    GlobalLoader.show(context);

    // Controllers for Text Fields
    final firstNameController = TextEditingController();
    final middleNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final ageController = TextEditingController();
    final mobileController = TextEditingController();
    final idController = TextEditingController();
    final workingHoursController = TextEditingController();
    final otRateController = TextEditingController();
    final wagesController = TextEditingController();
    final commissionController = TextEditingController();

    // Form Key for Validation
    final _formKey = GlobalKey<FormState>();

    String? _capturedFilePath;

     List<String> categoryNames = [];
    List<SuppliersDDL> contractorList = [];
    List<String> contractorNames = [];
    Map<String, int> contractorMap = {};

    try {
      final contractors = await SystemApiService.fetchContractors();
      final categories = await SystemApiService.fetchLabourCategories();

      AppLogger.info('Contractors fetched: ${contractors.length}');
      AppLogger.info('Categories fetched: ${categories.length}');


      contractors.forEach((contractor) {
        AppLogger.info('Contractor: Name = ${contractor.name}, ID = ${contractor.id}');
        contractorNames.add(contractor.name);  // Add name to list
        contractorMap[contractor.name] = contractor.id;  // Store name and id in map
      });

      contractorNames = contractors.map((c) => c.name).toSet().toList();
      categoryNames = categories.map((c) => c.name).toList();

      AppLogger.info('Contractor names: $contractorNames');
      AppLogger.info('Category names: $categoryNames');


    } catch (error) {
      CustomSnackbar.show(context, message: 'Failed to load data');
      GlobalLoader.hide();
      return;
    }

    // Pre-fill form if existingLabour is passed
    if (existingLabour != null) {
      AppLogger.info("🛠 Pre-filling form with existing labour data");

      // Print full raw model data for debugging
      debugPrint('📦 Raw LabourModel JSON: ${existingLabour.toString()}');

      // Log key fields for debugging
      debugPrint('🔍 First Name: ${existingLabour.labourFirstName}');
      debugPrint('🔍 Middle Name: ${existingLabour.labourMiddleName}');
      debugPrint('🔍 Last Name: ${existingLabour.labourLastName}');
      debugPrint('🔍 Age: ${existingLabour.labourAge}');
      debugPrint('🔍 Gender: ${existingLabour.labourSex}');
      debugPrint('🔍 Mobile: ${existingLabour.labourContactNo}');
      debugPrint('🔍 Aadhar: ${existingLabour.labourAadharNo}');
      debugPrint('🔍 Working Hours: ${existingLabour.labourWorkingHrs}');
      debugPrint('🔍 OT Rate: ${existingLabour.otRate}');
      debugPrint('🔍 Wages: ${existingLabour.totalWages}');
      debugPrint('🔍 Commission: ${existingLabour.commissionPerLabour}');
      debugPrint('🔍 Contractor Name: ${existingLabour.contractorName}');
      debugPrint('🔍 Labour Category: ${existingLabour.labourCategory}');
      debugPrint('🔍 Labour Contractor ID: ${existingLabour.contractorID}');
      debugPrint('🔍 Labour ID: ${existingLabour.labourID}');
      debugPrint('🔍 Labour Code: ${existingLabour.labourCode}');

      AppLogger.info("✅ Contractor from model: ${existingLabour?.contractorName}");
      AppLogger.info("✅ Labour category from model: ${existingLabour?.labourCategory}");

      // Pre-fill form controllers
      firstNameController.text = existingLabour.labourFirstName ?? '';
      middleNameController.text = existingLabour.labourMiddleName ?? '';
      lastNameController.text = existingLabour.labourLastName ?? '';
      ageController.text = existingLabour.labourAge?.toString() ?? '';
      mobileController.text = existingLabour.labourContactNo ?? '';
      idController.text = existingLabour.labourAadharNo ?? '';
      workingHoursController.text = existingLabour.labourWorkingHrs?.toString() ?? '';
      otRateController.text = existingLabour.otRate?.toString() ?? '';
      wagesController.text = existingLabour.totalWages?.toString() ?? '';
      commissionController.text = existingLabour.commissionPerLabour?.toString() ?? '';
    }

// Pre-fill Gender
    String? selectedGender = existingLabour?.labourSex;
    debugPrint('🔍 Gender=> ${existingLabour?.labourSex}');

// Pre-fill Contractor Name
    String? selectedContractor = existingLabour?.contractorName;
    debugPrint('🔍 selectedContractor existingLabour data :=> ${existingLabour?.contractorID}');

    // Attempt to find contractor name using contractor ID
    if (selectedContractor == null && existingLabour?.contractorID != null) {
      int targetId = existingLabour!.contractorID!;
      selectedContractor = contractorMap.entries
          .firstWhere(
            (entry) => entry.value == targetId,
        orElse: () => const MapEntry('', 0),
      )
          .key;

      if (selectedContractor != '') {
        AppLogger.info('✅ Found Contractor Name $selectedContractor for ID ${existingLabour?.contractorID}');
      } else {
        AppLogger.warn('⚠️ No contractor name found for ID ${existingLabour?.contractorID}');
        selectedContractor = null;
      }
    }


    // Log the selected contractor for debugging
    AppLogger.info('Contractor Name: $selectedContractor');

    // Pre-fill Labour Category
    String? selectedCategory = categoryNames.contains(existingLabour?.labourCategory)
        ? existingLabour?.labourCategory
        : (categoryNames.isNotEmpty ? categoryNames.first : null);


    bool isImageUploaded = false;

    GlobalLoader.hide();

    CustomDialog.show(
      context,
      title: "Add Labour Person",
      formFields: [
        Form(
          key: _formKey,
          child: Column(
            children: LabourFormFields.buildFormFields(
              context: context,
              formKey: _formKey,
              firstNameController: firstNameController,
              middleNameController: middleNameController,
              lastNameController: lastNameController,
              ageController: ageController,
              mobileController: mobileController,
              idController: idController,
              workingHoursController: workingHoursController,
              otRateController: otRateController,
              wagesController: wagesController,
              commissionController: commissionController,
              contractorNames: contractorNames,
              categoryNames: categoryNames,
              selectedContractor: selectedContractor,
              selectedCategory: selectedCategory,
              selectedGender: selectedGender,
              imagePath: _capturedFilePath,
              onContractorChanged: (value) {
                selectedContractor = value;
              },
              onCategoryChanged: (value) {
                selectedCategory = value;
              },
              onGenderChanged: (value) {
                selectedGender = value;
              },
              isImageUploaded: isImageUploaded,
              onUploadSuccess: (uploadStatus) {
                isImageUploaded = uploadStatus;
              },
            ),
          ),
        ),
      ],
      saveButtonText: "Edit",

      onSave: () async {
        AppLogger.info("Form validation started.");


        if (selectedContractor == null || selectedContractor!.isEmpty) {
          CustomSnackbar.show(context, message: "Please select a contractor.", isError: true);
          return;
        }

        if (firstNameController.text.trim().isEmpty) {
          CustomSnackbar.show(context, message: "First Name is required.", isError: true);
          return;
        }

        if (selectedGender == null || selectedGender!.isEmpty) {
          CustomSnackbar.show(context, message: "Please select a gender.", isError: true);
          return;
        }

        if (workingHoursController.text.trim().isEmpty) {
          CustomSnackbar.show(context, message: "Working Hours are required.", isError: true);
          return;
        }

        if (wagesController.text.trim().isEmpty) {
          CustomSnackbar.show(context, message: "Wages are required.", isError: true);
          return;
        }

        if (commissionController.text.trim().isEmpty) {
          CustomSnackbar.show(context, message: "Commission is required.", isError: true);
          return;
        }

        // ✅ All validations passed — log everything (even optional)
        AppLogger.info("Form validation passed Edited. Logging values:");
        AppLogger.info("First Name: ${firstNameController.text}");
        AppLogger.info("Selected Gender: $selectedGender");
        AppLogger.info("Selected Contractor edited: $selectedContractor");
        AppLogger.info("Working Hours: ${workingHoursController.text}");
        AppLogger.info("Wages: ${wagesController.text}");
        AppLogger.info("Commission: ${commissionController.text}");
        AppLogger.info("Middle Name: ${middleNameController.text}");
        AppLogger.info("Last Name: ${lastNameController.text}");
        AppLogger.info("Age: ${ageController.text}");
        AppLogger.info("Mobile No: ${mobileController.text}");
        AppLogger.info("Aadhar ID: ${idController.text}");
        AppLogger.info("OT Rate: ${otRateController.text}");
        AppLogger.info("Selected Category : $selectedCategory");
        //AppLogger.info("Labour ID: $labourId");

        int? contractorId;
        if (selectedContractor != null && contractorMap.containsKey(selectedContractor)) {
          contractorId = contractorMap[selectedContractor]!;
          AppLogger.info("🆔 Contractor ID for '$selectedContractor': $contractorId");
        } else {
          AppLogger.warn("⚠️ Contractor ID not found for name: $selectedContractor");
        }




        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? imagePath = prefs.getString('imagePath');

        String? base64Image;

        if (imagePath != null && imagePath.isNotEmpty) {
          AppLogger.info("Image uploaded successfully. Path: $imagePath");

          base64Image = await _convertImageToBase64(imagePath);

          if (base64Image.isNotEmpty) {
            AppLogger.info("Base64 Image conversion successful.");
            AppLogger.info("Base64 Image Length: ${base64Image.length}");
          } else {
            AppLogger.warn("Base64 conversion returned empty. Possibly invalid image.");
          }
        } else {
          AppLogger.info("No image uploaded. Proceeding without image.");
          base64Image = null;
        }


        AppLogger.info("Form validation passed.");
        logFormValues(
          firstNameController,
          middleNameController,
          lastNameController,
          ageController,
          mobileController,
          idController,
          workingHoursController,
          otRateController,
          wagesController,
          commissionController,
          selectedContractor,
          selectedCategory,
        );

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // String? imagePath = prefs.getString('imagePath');
        // AppLogger.info("Uploaded image retrieved. Path: $imagePath");
        //
        // if (imagePath == null || imagePath.isEmpty) {
        //   AppLogger.warn(
        //     "No image uploaded. User has not provided an image path.",
        //   );
        //   CustomSnackbar.show(
        //     context,
        //     message: "Image upload is required.",
        //     isError: true,
        //   );
        //   return;
        // }
        //
        // String base64Image = await _convertImageToBase64(imagePath);
        // if (base64Image.isEmpty) {
        //   AppLogger.warn("Failed to convert image to Base64.");
        //   CustomSnackbar.show(
        //     context,
        //     message: "Failed to convert image. Please upload a valid image.",
        //     isError: true,
        //   );
        //   return;
        // }

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // String? imagePath = prefs.getString('imagePath');
        //
        // String? base64Image;
        //
        // if (imagePath != null && imagePath.isNotEmpty) {
        //   AppLogger.info("Image uploaded successfully. Path: $imagePath");
        //
        //   base64Image = await _convertImageToBase64(imagePath);
        //
        //   if (base64Image.isNotEmpty) {
        //     AppLogger.info("Base64 Image conversion successful.");
        //     AppLogger.info("Base64 Image Length: ${base64Image.length}");
        //   } else {
        //     AppLogger.warn("Base64 conversion returned empty. Possibly invalid image.");
        //   }
        // } else {
        //   AppLogger.info("No image uploaded. Proceeding without image.");
        //   base64Image = null;
        //
        // }

        bool? confirm = await CustomAlertDialog.show(
          context: context,
          title: "Confirm Save",
          message: "Are you sure you want to save this Labour Person?",
          confirmText: "Save",
          cancelText: "Cancel",
          onConfirm: () async {
            AppLogger.info("Saving labour person started.");
            GlobalLoader.show(context);
            await Future.delayed(Duration(seconds: 1));
            GlobalLoader.hide();

            final labourData = {
              "labourId": existingLabour?.labourID ?? 0,
              "supplierId": contractorId,
              "labourSex": selectedGender ?? " ",
              "labourFirstName": firstNameController.text,
              "labourMiddleName": middleNameController.text,
              "labourLastName": lastNameController.text,
              "labourAge": int.parse(ageController.text),
              "labourContactNo": mobileController.text,
              "labourAadharNo": idController.text,
              "labourWorkingHrs": int.parse(workingHoursController.text),
              "createdBy": 13125,
              "createdDate": DateTime.now().toIso8601String(),
              "advanceAmount": double.parse(wagesController.text),
              "totalWages": double.parse(wagesController.text),
              "otRate": double.parse(otRateController.text),
              "labourCode": existingLabour?.labourCode ?? " ",
              "labourCategory": selectedCategory ?? "",
              "commissionPerLabour": double.parse(commissionController.text),
              "currencyId": 1001,
              "companyCode": "CONSTRO",
            };

            AppLogger.info("Labour data to be sent to API: $labourData");

            bool isEditLabourAdded = await LabourApiService().editLabour(
              labourId: existingLabour?.labourID ?? 0,
              supplierId: contractorId ?? 0 ,
              labourSex: selectedGender ?? " ",
              labourFirstName: firstNameController.text,
              labourMiddleName: middleNameController.text,
              labourLastName: lastNameController.text,
              labourAge: int.parse(ageController.text),
              labourContactNo: mobileController.text,
              labourAadharNo: idController.text,
              labourWorkingHrs: int.parse(workingHoursController.text),
              createdBy: 13125,
              createdDate: DateTime.now().toIso8601String(),
              advanceAmount: double.parse(wagesController.text),
              totalWages: double.parse(wagesController.text),
              otRate: double.parse(otRateController.text),
              labourCode: existingLabour?.labourCode ?? " ",
              labourCategory: selectedCategory ?? "",
              commissionPerLabour: double.parse(commissionController.text),
              currencyId: 1001,
              companyCode: "CONSTRO",
            );

            if (isEditLabourAdded) {
              CustomSnackbar.show(
                context,
                message: "Labour person Edit successfully",
                isError: false,
              );
              AppLogger.info("Labour person Edit successfully.");
              await prefs.remove('imagePath');

              clearForm(
                firstNameController,
                middleNameController,
                lastNameController,
                ageController,
                mobileController,
                idController,
                workingHoursController,
                otRateController,
                wagesController,
                commissionController,
              );

              // ✅ Clear shared prefs image path
              await prefs.remove('imagePath');
              AppLogger.info("Image path cleared from SharedPreferences.");

              // Navigator.pop(context);

              // ✅ Refresh first
              //await ref.read(labourListProvider.notifier).loadLabours(context: context);
              //AppLogger.info("Labours list refreshed.");
              Navigator.pop(context);

              await ref.read(labourListProvider.notifier).loadLabours(refresh: true, context: context);
              AppLogger.info("Labours list refreshed.");

              // ✅ THEN pop back to the previous screen
              Navigator.pop(context);
              AppLogger.info("POP OUT FOR BACK ");



            } else {
              CustomSnackbar.show(
                context,
                message: "Failed to add the labour person.",
                isError: true,
              );
            }
          },
        );

        if (confirm == null || !confirm) {
          AppLogger.info("User canceled the save action.");
          return;
        }
      },
      onClose: () async {
        // bool? confirm = await CustomAlertDialog.show(
        //   context: context,
        //   title: "Confirm Cancel",
        //   message:
        //       "Are you sure you want to cancel? Any unsaved changes will be lost.",
        //   confirmText: "Exit",
        //   cancelText: "Stay",
        //   onConfirm: () {
        //     Navigator.pop(context);
        //   },
        // );
        //
        // if (confirm == null || !confirm) return;

        // Your additional logic to handle the closure after confirmation
        Navigator.pop(context); // Close the current screen or action
      },
    );
  }

  /// Convert image file to Base64 string
  Future<String> _convertImageToBase64(String imagePath) async {
    try {
      // Read the image file as bytes using the image path
      final bytes = await File(imagePath).readAsBytes();

      // Convert the bytes to Base64 string
      String base64Image = base64Encode(bytes);

      return base64Image;
    } catch (e) {
      AppLogger.error("Error converting image to Base64: $e");
      return ''; // Return an empty string in case of error
    }
  }

  void logFormValues(
    TextEditingController firstNameController,
    TextEditingController middleNameController,
    TextEditingController lastNameController,
    TextEditingController ageController,
    TextEditingController mobileController,
    TextEditingController idController,
    TextEditingController workingHoursController,
    TextEditingController otRateController,
    TextEditingController wagesController,
    TextEditingController commissionController,
    String? selectedContractor,
    String? selectedCategory,
  ) {
    AppLogger.info("Form values: ");
    AppLogger.info("First Name: ${firstNameController.text}");
    AppLogger.info("Middle Name: ${middleNameController.text}");
    AppLogger.info("Last Name: ${lastNameController.text}");
    AppLogger.info("Age: ${ageController.text}");
    AppLogger.info("Mobile Number: ${mobileController.text}");
    AppLogger.info("ID: ${idController.text}");
    AppLogger.info("Working Hours: ${workingHoursController.text}");
    AppLogger.info("OT Rate: ${otRateController.text}");
    AppLogger.info("Wages: ${wagesController.text}");
    AppLogger.info("Commission: ${commissionController.text}");
    AppLogger.info("Contractor: $selectedContractor");
    AppLogger.info("Category: $selectedCategory");
  }

  void clearForm(
    TextEditingController firstNameController,
    TextEditingController middleNameController,
    TextEditingController lastNameController,
    TextEditingController ageController,
    TextEditingController mobileController,
    TextEditingController idController,
    TextEditingController workingHoursController,
    TextEditingController otRateController,
    TextEditingController wagesController,
    TextEditingController commissionController,
  ) {
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    ageController.clear();
    mobileController.clear();
    idController.clear();
    workingHoursController.clear();
    otRateController.clear();
    wagesController.clear();
    commissionController.clear();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // This function will be triggered when the user reaches the bottom of the list
  void _scrollListener() {
    final scrollPosition = _scrollController.position;
    if (scrollPosition.pixels == scrollPosition.maxScrollExtent) {
      // Check if we can load more data (pagination)
      if (!ref.read(labourListProvider.notifier).isLoading &&
          ref.read(labourListProvider.notifier).hasMoreData) {
        ref.read(labourListProvider.notifier).loadLabours(
              context: context,
              labourType:
                  'Electrician', // Example: pass a dynamic labour type here
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final labours = ref.watch(labourListProvider);
    final labourNotifier = ref.read(labourListProvider.notifier);
    final isLoading = labourNotifier.isLoading;
    final laboursList = ref.watch(labourListProvider);
    filteredLabours = List.from(laboursList);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 30),
          color: AppColors.primaryBlue,
        ),
        title: Text(
          'Labour Master',
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.primaryBlackFont,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: Icon(Icons.filter_list_alt, color: AppColors.primaryBlue),
              onPressed: () => _showFilterBottomSheet(context),
            ),
          ),
        ],
        backgroundColor: AppColors.primaryWhitebg,
      ),
      // body: RefreshIndicator(
      //   onRefresh: () async {
      //     // await labourNotifier.loadLabours(refresh: true, context: context);
      //     // Trigger refresh and reset state
      //     await ref.read(labourListProvider.notifier).loadLabours(refresh: true, context: context);
      //   },
      //   child:
      //   labours.isEmpty
      //       ? const Center(
      //     child: Text(
      //       "No labour data available",
      //       style: TextStyle(fontSize: 16),
      //     ),
      //   )
      //       : ListView.builder(
      //     controller: _scrollController,
      //     physics: const BouncingScrollPhysics(),
      //     padding: const EdgeInsets.all(16),
      //     // itemCount: labours.length,
      //     itemCount: labours.length + (ref.read(labourListProvider.notifier).isLoading ? 1 : 0),
      //     itemBuilder: (context, index) {
      //       if (index == labours.length) {
      //         return const Center(child: CircularProgressIndicator()); // Show loading at the bottom
      //       }
      //
      //       final labour = labours[index];
      //       return GestureDetector(
      //         onTap: () async {
      //           Labour selectedLabour = labours[index];
      //
      //           AppLogger.info("Tapped on labour at index $index");
      //           AppLogger.info("Labour ID: ${selectedLabour.labourID}");
      //           AppLogger.info("Labour Name: ${selectedLabour.labourName}");
      //
      //           final apiService = LabourApiService();
      //           final result = await apiService.getLabourAttendanceData(
      //             labourAttendanceId: selectedLabour.labourID,
      //             date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      //           );
      //
      //           if (result['status'] == 'error') {
      //             AppLogger.error("❌ Failed to fetch data: ${result['message']}");
      //             CustomSnackbar.show(
      //               context,
      //               message: "Error fetching data: ${result['message']}",
      //             );
      //           } else {
      //             AppLogger.debug("🎯 Final Data: ${result['Data']}");
      //             AppLogger.debug("🎯 API raw data: ${result['Data'].runtimeType} - ${result['Data']}");
      //
      //             final List<dynamic> dataList = result['Data'];
      //             if (dataList.isEmpty) {
      //               AppLogger.warn("⚠️ API returned empty data list.");
      //               CustomSnackbar.show(
      //                 context,
      //                 message: "No data found for selected labour.",
      //               );
      //               return;
      //             }
      //
      //             // Log the first item of the data list
      //             AppLogger.debug("🎯 First Item in Data List: ${jsonEncode(dataList.first)}");
      //
      //             final labourData = LabourModel.fromJson(dataList.first as Map<String, dynamic>);
      //
      //             // Log the parsed model data
      //             AppLogger.debug("✅ Parsed Labour Data: ${jsonEncode(labourData.toJson())}");
      //
      //             // Hide the global loader
      //             GlobalLoader.hide();
      //
      //
      //
      //             // Now show the dialog
      //             await showAddLabourEditDialog(
      //               context,
      //               saveButtonText: "Edit",
      //               existingLabour: labourData,
      //             );
      //
      //
      //             AppLogger.debug("✅ Parsed LabourModel after open calling : ${jsonEncode(labourData.toJson())}");
      //           }
      //         },
      //
      //
      //
      //         onLongPress: () {
      //           // Log the index, id, name, and other details when long-pressed
      //           AppLogger.info(
      //             "Long pressed on labour at index $index",
      //           );
      //           AppLogger.info("Labour ID: ${labour.labourID}");
      //           AppLogger.info("Labour Name: ${labour.labourName}");
      //
      //           // Show the custom confirmation dialog for deletion
      //           CustomConfirmationDialog.show(
      //             context,
      //             title: 'Delete Labour',
      //             message:
      //             'Are you sure you want to delete this labour ${labour.labourName}?',
      //             confirmText: "Delete",
      //             // Confirmation button text
      //             cancelText: "Cancel",
      //             // Cancel button text
      //             onConfirm: () async {
      //               // Handle the delete action
      //               AppLogger.info(
      //                 'Deleting labour ${labour.labourName}',
      //               );
      //
      //               // Call the deleteLabour function and pass necessary data
      //               bool result = await LabourApiService().deleteLabour(
      //                 labourId: labour.labourID,
      //                 userId: 13125,
      //                 // Replace with the logged-in user's ID or other source of user ID
      //                 companyCode:
      //                 "CONSTRO", // Replace with actual company code
      //               );
      //
      //               if (result) {
      //                 // If deletion was successful, log and update the UI
      //                 AppLogger.info(
      //                   "Labour ${labour.labourName} deleted successfully.",
      //                 );
      //
      //                 // Remove the deleted labour from the list (assuming you have a list of labours)
      //                 setState(() {
      //                   // Assuming labourList is the list containing all labour data
      //                   filteredLabours.removeWhere(
      //                         (item) => item.labourID == labour.labourID,
      //                   );
      //                 });
      //
      //                 // Optionally, show a success snackbar or dialog
      //                 CustomSnackbar.show(
      //                   context,
      //                   message:
      //                   "Labour ${labour.labourName} deleted successfully.",
      //                   isError: false,
      //                 );
      //               } else {
      //                 // If deletion failed, log and show error
      //                 AppLogger.error(
      //                   "Failed to delete labour ${labour.labourName}.",
      //                 );
      //
      //                 CustomSnackbar.show(
      //                   context,
      //                   message: "Failed to delete the labour.",
      //                   isError: true,
      //                 );
      //               }
      //             },
      //           );
      //         },
      //
      //         child: LabourCard(
      //           id: labour.labourCode.toString(),
      //           name: labour.labourName,
      //           company: labour.contractorName,
      //           status: labour.isActive == "Active",
      //
      //           onToggle: (bool value) {},
      //         ),
      //       );
      //     },
      //   ),
      // ),

      body: RefreshIndicator(
        onRefresh: () async {
          // await labourNotifier.loadLabours(refresh: true, context: context);
          // Trigger refresh and reset state
          await ref
              .read(labourListProvider.notifier)
              .loadLabours(refresh: true, context: context);
        },
        child: labours.isEmpty
            ? const Center(
                child: Text(
                  "No labour data available",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: labours.length + (isLoading ? 1 : 0),
                // Add 1 extra if loading
                itemBuilder: (context, index) {
                  if (index == labours.length) {
                    // This means we reached the extra loader item
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final labour = labours[index];
                  bool isLabourActive = labour.isActive == "Active"; // Check if the labour is active

                  AppLogger.info("Labour ${labour.labourName} is ${labour.isActive == 'Active' ? 'Active' : 'Inactive'}");

                  return GestureDetector(
                    // onTap: () async {
                    //   Labour selectedLabour = labour;
                    //   AppLogger.info("Tapped on labour at index $index");
                    //   AppLogger.info("Labour ID: ${selectedLabour.labourID}");
                    //   AppLogger.info(
                    //       "Labour Name: ${selectedLabour.labourName}");
                    //
                    //   final apiService = LabourApiService();
                    //   final result = await apiService.getLabourAttendanceData(
                    //     labourAttendanceId: selectedLabour.labourID,
                    //     date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    //   );
                    //
                    //   if (result['status'] == 'error') {
                    //     AppLogger.error(
                    //         "❌ Failed to fetch data: ${result['message']}");
                    //     CustomSnackbar.show(context,
                    //         message:
                    //             "Error fetching data: ${result['message']}");
                    //   } else {
                    //     final List<dynamic> dataList = result['Data'];
                    //     if (dataList.isEmpty) {
                    //       AppLogger.warn("⚠️ API returned empty data list.");
                    //       CustomSnackbar.show(context,
                    //           message: "No data found for selected labour.");
                    //       return;
                    //     }
                    //
                    //     final labourData = LabourModel.fromJson(
                    //         dataList.first as Map<String, dynamic>);
                    //     await showAddLabourEditDialog(
                    //       context,
                    //       saveButtonText: "Edit",
                    //       existingLabour: labourData,
                    //     );
                    //   }
                    // },


                    onTap:  isLabourActive ? () async {
                      Labour selectedLabour = labour;
                      AppLogger.info("Tapped on labour at index $index");
                      AppLogger.info("Labour ID: ${selectedLabour.labourID}");
                      AppLogger.info("Labour labourCode: ${selectedLabour.labourCode}");
                      AppLogger.info("Labour contractorName: ${selectedLabour.contractorName}");
                      AppLogger.info("Labour labourCategory: ${selectedLabour.labourCategory}");
                      AppLogger.info("Labour labourName: ${selectedLabour.labourName}");

                      final apiService = LabourApiService();
                      final result = await apiService.getLabourAttendanceData(
                        labourAttendanceId: selectedLabour.labourID,
                        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      );

                      if (result['status'] == 'error') {
                        AppLogger.error(
                            "❌ Failed to fetch data: ${result['message']}");
                        CustomSnackbar.show(context,
                            message:
                                "Error fetching data: ${result['message']}");
                      } else {
                        final List<dynamic> dataList = result['Data'];
                        if (dataList.isEmpty) {
                          AppLogger.warn("⚠️ API returned empty data list.");
                          CustomSnackbar.show(context,
                              message: "No data found for selected labour.");
                          return;
                        }

                        final labourData = LabourModel.fromJson(
                            dataList.first as Map<String, dynamic>);
                        await showLabourEditDialog(
                          context,
                          saveButtonText: "Edit",
                          existingLabour: labourData,
                        );
                      }
                    } : null,


                    // onLongPress: () {
                    //   CustomConfirmationDialog.show(
                    //     context,
                    //     title: 'Delete Labour',
                    //     message:
                    //         'Are you sure you want to delete this labour ${labour.labourName}?',
                    //     confirmText: "Delete",
                    //     cancelText: "Cancel",
                    //     onConfirm: () async {
                    //       bool result = await LabourApiService().deleteLabour(
                    //         labourId: labour.labourID,
                    //         userId: 13125,
                    //         companyCode: "CONSTRO",
                    //       );
                    //
                    //       if (result) {
                    //         AppLogger.info(
                    //             "Labour ${labour.labourName} deleted successfully.");
                    //         setState(() {
                    //           filteredLabours.removeWhere(
                    //               (item) => item.labourID == labour.labourID);
                    //         });
                    //         CustomSnackbar.show(
                    //           context,
                    //           message:
                    //               "Labour ${labour.labourName} deleted successfully.",
                    //           isError: false,
                    //         );
                    //       } else {
                    //         AppLogger.error(
                    //             "Failed to delete labour ${labour.labourName}.");
                    //         CustomSnackbar.show(
                    //           context,
                    //           message: "Failed to delete the labour.",
                    //           isError: true,
                    //         );
                    //       }
                    //     },
                    //   );
                    // },

                    child:   LabourCard(
                        id: labour.labourCode.toString(),
                        name: labour.labourName,
                        company: labour.contractorName,
                        status: labour.isActive == "Active",  // Active/Inactive based on isActive field
                        onToggle: (bool value) async {
                          if (value) {
                            // Labour is now active, no deletion, but maybe updating status to active
                            bool result = await LabourApiService().deleteLabour(
                              labourId: labour.labourID,
                              userId: 13125,
                              companyCode: "CONSTRO",
                             //newStatus: "Active", // Change status to Active
                            );

                            if (result) {
                              AppLogger.info("✅ Labour ${labour.labourName} status updated to Active.");
                              // setState(() {
                              //   labour.isActive = "Active";  // Update the state to active
                              // });

                              CustomSnackbar.show(
                                context,
                                message: "Labour ${labour.labourName} is now active.",
                                isError: false,
                              );

                              // 🔁 Refresh labour list
                              await ref.read(labourListProvider.notifier).loadLabours(refresh: true, context: context);
                              AppLogger.info("🔁 Labour list refreshed after activation.");

                            } else {
                              AppLogger.error("❌ Failed to update labour ${labour.labourName} status.");
                              CustomSnackbar.show(
                                context,
                                message: "Failed to update labour status.",
                                isError: true,
                              );
                            }
                          } else {
                            // Labour is being deactivated, so we proceed with deletion (inactive)
                            bool result = await LabourApiService().deleteLabour(
                              labourId: labour.labourID,
                              userId: 13125,
                              companyCode: "CONSTRO",
                            );

                            if (result) {
                              AppLogger.info("✅ Labour ${labour.labourName} deleted successfully.");
                              setState(() {
                                filteredLabours.removeWhere((item) => item.labourID == labour.labourID);
                              });

                              CustomSnackbar.show(
                                context,
                                message: "Labour ${labour.labourName} deleted successfully.",
                                isError: true,
                              );

                              // 🔁 Refresh labour list
                              await ref.read(labourListProvider.notifier).loadLabours(refresh: true, context: context);
                              AppLogger.info("🔁 Labour list refreshed after deletion.");

                            } else {
                              AppLogger.error("❌ Failed to delete labour ${labour.labourName}.");
                              CustomSnackbar.show(
                                context,
                                message: "Failed to delete the labour.",
                                isError: true,
                              );
                            }
                          }
                        },
                      ),


                    // child: LabourCard(
                    //   id: labour.labourCode.toString(),
                    //   name: labour.labourName,
                    //   company: labour.contractorName,
                    //   status: labour.isActive == "Active",
                    //     onToggle: (bool value) async {
                    //       if (value) {
                    //         // Labour is now active, no deletion, but maybe updating status to active
                    //         bool result = await LabourApiService().deleteLabour(
                    //           labourId: labour.labourID,
                    //           userId: 13125,
                    //           companyCode: "CONSTRO",
                    //         );
                    //
                    //         if (result) {
                    //           AppLogger.info("✅ Labour ${labour.labourName} deleted successfully.");
                    //           setState(() {
                    //             filteredLabours.removeWhere((item) => item.labourID == labour.labourID);
                    //           });
                    //
                    //           setState(() {
                    //             filteredLabours.removeWhere((item) => item.labourID == labour.labourID);
                    //           });
                    //
                    //           CustomSnackbar.show(
                    //             context,
                    //             message: "Labour ${labour.labourName} deleted successfully.",
                    //             isError: false,
                    //           );
                    //         } else {
                    //           AppLogger.error("❌ Failed to delete labour ${labour.labourName}.");
                    //           CustomSnackbar.show(
                    //             context,
                    //             message: "Failed to delete the labour.",
                    //             isError: true,
                    //           );
                    //         }
                    //       }
                    //     }
                    //
                    // ),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddLabourDialog(context);
        },
        backgroundColor: AppColors.primaryBlue,
        shape: CircleBorder(),
        child: Container(
          width: 56, // Ensures proper size
          height: 56, // Ensures proper size
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ), // Adjust icon size if needed
        ),
      ),
    );
  }

// void showDeleteConfirmationDialog(BuildContext context, Labour labour) {
//   CustomDialog.show(
//     context,
//     title: 'Confirm Deletion',
//     formFields: [
//       Text(
//         'Are you sure you want to delete ${labour.labourName}?',
//         style: TextStyle(fontSize: 16),
//       ),
//     ],
//     onSave: () {
//       Navigator.pop(context); // Close the dialog
//       // Handle the deletion logic here
//       AppLogger.info('Labour deleted: ${labour.labourName}');
//       // Implement actual removal of the item from the list or database
//     },
//     onClose: () {
//       Navigator.pop(context); // Close the dialog
//     },
//   );
// }
}
