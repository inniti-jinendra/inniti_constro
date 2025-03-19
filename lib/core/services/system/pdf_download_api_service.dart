import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../../constants/constants.dart';
import '../../utils/shared_preferences_util.dart';

class PdfDownloadApiService {
  static Future<void> downloadAndOpenPdf(
      BuildContext context, String id) async {
    final companyCode =
        await SharedPreferencesUtil.getSharedPreferenceData('CompanyCode');

    final url = Uri.parse('${Constants.baseUrl}/Account/DownloadSalarySlip')
        .replace(queryParameters: {
      'companyCode': companyCode,
      'EmployeeSalaryDetailsID': id
    });

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Downloading..."),
          ],
        ),
      ),
    );

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        String base64String = response.body;

        // Decode Base64 to bytes
        Uint8List bytes = base64Decode(base64String);

        // Get local directory
        Directory tempDir = await getApplicationDocumentsDirectory();
        String filePath = "${tempDir.path}/salarySlip.pdf";

        // Save file
        File file = File(filePath);
        await file.writeAsBytes(bytes);

        // Close loading dialog
        Navigator.pop(context);

        // Open the PDF
        await OpenFile.open(filePath);
      } else {
        Navigator.pop(context);
        print("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      Navigator.pop(context);
      print("Error downloading file: $e");
    }
  }
}
