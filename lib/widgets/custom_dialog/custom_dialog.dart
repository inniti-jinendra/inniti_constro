import 'package:flutter/material.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';

// Dilog pop up for add labor

class CustomDialog extends StatelessWidget {
  final String title;
  final List<Widget> formFields;
  final VoidCallback onSave;
  final VoidCallback onClose;
  final String? saveButtonText;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.formFields,
    required this.onSave,
    required this.onClose,
    this.saveButtonText,  }) : super(key: key);

  static void show(
      BuildContext context, {
        required String title,
        required List<Widget> formFields,
        required VoidCallback onSave,
        required VoidCallback onClose,
        String? saveButtonText,
      }) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Attendance Dialog",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 📌 Title
                        // Padding(
                        //   padding: const EdgeInsets.all(16),
                        //   child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        // ),

                        // 📌 Form Fields
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(children: formFields),
                          ),
                        ),

                        // 📌 Bottom Buttons
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBackground,
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Soft shadow color
                                spreadRadius: 2, // Controls how much the shadow spreads
                                blurRadius: 10, // Smoothness of the shadow
                                offset: const Offset(0, -2), // Moves shadow **above** the container
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: onSave,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(saveButtonText ?? "Save"),

                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextButton(
                                  onPressed: onClose,
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xffebcfcf),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text("Close", style: TextStyle(color: Colors.red)),
                                ),
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
