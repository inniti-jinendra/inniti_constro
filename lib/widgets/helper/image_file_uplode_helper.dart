// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:inniti_constro/core/constants/app_colors.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../core/network/logger.dart'; // Adjust the import path as per your project
//
//
// // State provider to manage the image file name
// final imageFileNameProvider = StateProvider<String?>((ref) => null);
//
//
// // CameraHelper class to handle camera and gallery selection
// class CameraHelper {
//   static final ImagePicker _picker = ImagePicker();
//
//   // Open camera to capture image
//   static Future<XFile?> openCamera(BuildContext context) async {
//     AppLogger.info("Opening camera...");
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       AppLogger.info("Image captured from camera: ${image.path}");
//     } else {
//       AppLogger.error("No image captured from camera.");
//     }
//     return image;
//   }
//
//   // Open gallery to pick an image
//   static Future<XFile?> openGallery(BuildContext context) async {
//     AppLogger.info("Opening gallery...");
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       AppLogger.info("Image selected from gallery: ${image.path}");
//     } else {
//       AppLogger.error("No image selected from gallery.");
//     }
//     return image;
//   }
// }
//
// // Camera Source Selection Dialog
// Future<ImageSource?> showImageSourceDialog(BuildContext context) async {
//   AppLogger.info("Displaying image source selection dialog...");
//   return showDialog<ImageSource>(
//     context: context,
//     builder: (context) => SimpleDialog(
//       title: const Text('Select Image Source'),
//       children: [
//         SimpleDialogOption(
//           child: const Text('Camera'),
//           onPressed: () {
//             AppLogger.info("Camera option selected.");
//             Navigator.pop(context, ImageSource.camera);
//           },
//         ),
//         SimpleDialogOption(
//           child: const Text('Gallery'),
//           onPressed: () {
//             AppLogger.info("Gallery option selected.");
//             Navigator.pop(context, ImageSource.gallery);
//           },
//         ),
//       ],
//     ),
//   );
// }
//
// // Updated Upload Button with Image Path Update and Validation
// class UploadButton extends ConsumerStatefulWidget {
//   final Function(bool) onUploadSuccess;
//   final bool isImageUploaded;
//
//   const UploadButton({
//     required this.onUploadSuccess,
//     required this.isImageUploaded,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _UploadButtonState createState() => _UploadButtonState();
// }
//
// class _UploadButtonState extends ConsumerState<UploadButton> {
//   // Method to trigger the camera or gallery selection
//   Future<void> _openImagePicker(BuildContext context) async {
//     try {
//       AppLogger.info("Opening image picker...");
//
//       // Show dialog for selecting image source
//       final ImageSource? source = await showImageSourceDialog(context);
//
//       if (source == null) {
//         AppLogger.info("No source selected, exiting image picker.");
//         return; // If no source is selected, exit
//       }
//
//       // Log the selected source
//       AppLogger.info("Image source selected: ${source == ImageSource.camera ? 'Camera' : 'Gallery'}");
//
//       // Based on the source, either open the camera or gallery
//       final XFile? image = source == ImageSource.camera
//           ? await CameraHelper.openCamera(context)
//           : await CameraHelper.openGallery(context);
//
//       if (image != null) {
//         // Log and store the file name using Riverpod
//         AppLogger.info("Image picked successfully: ${image.path}");
//         ref.read(imageFileNameProvider.state).state = image.name; // Update the file name in the state provider
//
//         // Simulate an image upload process after the image is picked
//         AppLogger.info("Simulating image upload...");
//         await Future.delayed(const Duration(seconds: 2)); // Simulate the upload process
//
//         // Notify the parent widget that the upload was successful
//         widget.onUploadSuccess(true);
//
//         AppLogger.info("Image uploaded successfully.");
//       } else {
//         AppLogger.error("Image selection failed or was canceled.");
//         widget.onUploadSuccess(false);
//       }
//     } catch (error) {
//       // Handle any errors that occur during image picking or upload
//       AppLogger.error("Image upload failed: $error");
//       widget.onUploadSuccess(false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Watch the image file name from Riverpod (This is the key part for UI updates)
//     final imageFileName = ref.watch(imageFileNameProvider.state).state;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         children: [
//           InkWell(
//             onTap: () {
//               AppLogger.info("Upload button tapped.");
//               _openImagePicker(context);
//             },
//             child: Container(
//               height: 70,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryWhitebg,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: const Color(0xffE6E0EF),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: SvgPicture.asset(
//                         "assets/icons/attendance/Upload-cam-svg.svg",
//                         height: 24,
//                         width: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       widget.isImageUploaded
//                           ? "Image Uploaded: ${imageFileName ?? 'Unknown'}"
//                           : "Upload Image",
//                       style: GoogleFonts.nunitoSans(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.primaryBlackFont,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if (widget.isImageUploaded)
//             Text(
//               "Image Uploaded: ${imageFileName ?? 'Unknown'}",
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.primaryBlackFont,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';  // For Base64 encoding
import 'dart:io';  // For handling file I/O
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inniti_constro/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/logger.dart'; // Adjust the import path as per your project


// State provider to manage the image file name
final imageFileNameProvider = StateProvider<String?>((ref) => null);


// CameraHelper class to handle camera and gallery selection
class CameraHelper {
  static final ImagePicker _picker = ImagePicker();

  // Open camera to capture image
  static Future<XFile?> openCamera(BuildContext context) async {
    AppLogger.info("Opening camera...");
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      AppLogger.info("Image captured from camera: ${image.path}");
    } else {
      AppLogger.error("No image captured from camera.");
    }
    return image;
  }

  // Open gallery to pick an image
  static Future<XFile?> openGallery(BuildContext context) async {
    AppLogger.info("Opening gallery...");
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      AppLogger.info("Image selected from gallery: ${image.path}");
    } else {
      AppLogger.error("No image selected from gallery.");
    }
    return image;
  }
}

// Camera Source Selection Dialog
Future<ImageSource?> showImageSourceDialog(BuildContext context) async {
  AppLogger.info("Displaying image source selection dialog...");
  return showDialog<ImageSource>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Select Image Source'),
      children: [
        SimpleDialogOption(
          child: const Text('Camera'),
          onPressed: () {
            AppLogger.info("Camera option selected.");
            Navigator.pop(context, ImageSource.camera);
          },
        ),
        SimpleDialogOption(
          child: const Text('Gallery'),
          onPressed: () {
            AppLogger.info("Gallery option selected.");
            Navigator.pop(context, ImageSource.gallery);
          },
        ),
      ],
    ),
  );
}

// Updated Upload Button with Image Path Update and Validation
class UploadButton extends ConsumerStatefulWidget {
  final Function(bool) onUploadSuccess;
  final bool isImageUploaded;

  const UploadButton({
    required this.onUploadSuccess,
    required this.isImageUploaded,
    Key? key,
  }) : super(key: key);

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends ConsumerState<UploadButton> {
  // Method to trigger the camera or gallery selection
  Future<void> _openImagePicker(BuildContext context) async {
    try {
      AppLogger.info("Opening image picker...");

      // Show dialog for selecting image source
      final ImageSource? source = await showImageSourceDialog(context);

      if (source == null) {
        AppLogger.info("No source selected, exiting image picker.");
        return; // If no source is selected, exit
      }

      // Log the selected source
      AppLogger.info("Image source selected: ${source == ImageSource.camera ? 'Camera' : 'Gallery'}");

      // Based on the source, either open the camera or gallery
      final XFile? image = source == ImageSource.camera
          ? await CameraHelper.openCamera(context)
          : await CameraHelper.openGallery(context);

      if (image != null) {
        // Log and store the file name using Riverpod
        AppLogger.info("Image picked successfully: ${image.path}");

        // Store the image path temporarily in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('imagePath', image.path); // Save the file path temporarily
        AppLogger.info("Image path stored in SharedPreferences: ${image.path}");

        // Convert image to Base64
        String base64Image = await _convertImageToBase64(image);

        // Log the Base64 string (You can use this string for upload or storage)
        AppLogger.info("Base64 Image: $base64Image");

        // Simulate an image upload process after the image is picked
        AppLogger.info("Simulating image upload...");
        await Future.delayed(const Duration(seconds: 2)); // Simulate the upload process

        // Notify the parent widget that the upload was successful
        widget.onUploadSuccess(true);

        AppLogger.info("Image uploaded successfully.");
      } else {
        AppLogger.error("Image selection failed or was canceled.");
        widget.onUploadSuccess(false);
      }
    } catch (error) {
      // Handle any errors that occur during image picking or upload
      AppLogger.error("Image upload failed: $error");
      widget.onUploadSuccess(false);
    }
  }

  // Convert image file to Base64 string
  Future<String> _convertImageToBase64(XFile image) async {
    try {
      // Read the image file as bytes
      final bytes = await File(image.path).readAsBytes();

      // Convert the bytes to Base64 string
      String base64Image = base64Encode(bytes);

      return base64Image;
    } catch (e) {
      AppLogger.error("Error converting image to Base64: $e");
      return ''; // Return an empty string in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the image file name from Riverpod (This is the key part for UI updates)
    final imageFileName = ref.watch(imageFileNameProvider.state).state;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              AppLogger.info("Upload button tapped.");
              _openImagePicker(context);
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primaryWhitebg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xffE6E0EF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/attendance/Upload-cam-svg.svg",
                        height: 24,
                        width: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.isImageUploaded
                          ? "Image Uploaded: ${imageFileName ?? 'Unknown'}"
                          : "Upload Image",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlackFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.isImageUploaded)
            Text(
              "Image Uploaded: ${imageFileName ?? 'Unknown'}",
              style: GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlackFont,
              ),
            ),
        ],
      ),
    );
  }
}
