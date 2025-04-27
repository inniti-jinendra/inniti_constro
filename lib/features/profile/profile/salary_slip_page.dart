import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/components/app_back_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/models/profile/salary_slip_details.dart';
import '../../../core/services/system/pdf_download_api_service.dart';
import '../../../core/services/system/system_api_service.dart';


class SalarySlipPage extends StatefulWidget {
  const SalarySlipPage({super.key});

  @override
  _SalarySlipPageState createState() => _SalarySlipPageState();
}

class _SalarySlipPageState extends State<SalarySlipPage> {
  List<SalarySlipDetails>? _salarySlipDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetailsSalarySlipListByUserID();
  }

  Future<void> _fetchUserDetailsSalarySlipListByUserID() async {
    try {
      final salarySlipDetails =
          await SystemApiService.fatchUserDetailsSalarySlipListByUserID();
      setState(() {
        _salarySlipDetails = salarySlipDetails;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load salary slips')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadPdf(String slipId) async {
    try {
      await PdfDownloadApiService.downloadAndOpenPdf(context, slipId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF Downloaded Successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Salary Slips',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchUserDetailsSalarySlipListByUserID,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _salarySlipDetails == null || _salarySlipDetails!.isEmpty
              ? const Center(
                  child: Text(
                    'No Salary Slips Available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEmployeeHeader(),
                      const SizedBox(height: AppDefaults.padding),
                      Expanded(child: _buildSalarySlipList()),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmployeeHeader() {
    return Container(
        padding: const EdgeInsets.all(AppDefaults.padding),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            boxShadow: AppDefaults.boxShadow),
        child: Row(children: [
          const Icon(
            Icons.person,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDefaults.padding_2),
          Text(
            _salarySlipDetails?.first.employeeName ?? "Employee",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          )
        ]));
  }

  Widget _buildSalarySlipList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.1),
      itemCount: _salarySlipDetails!.length,
      itemBuilder: (context, index) {
        final slip = _salarySlipDetails![index];
        return Container(
          margin: const EdgeInsets.all(AppDefaults.padding_2),
          padding: const EdgeInsets.all(AppDefaults.padding),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: AppDefaults.boxShadow),
          child: Column(children: [
            Text(
              slip.month,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDefaults.padding_2),
            Text(
              slip.year,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.fileArrowDown,
                  color: AppColors.primary),
              onPressed: () {
                _downloadPdf(slip.employeeSalaryDetailsID);
              },
            ),
          ]),
        );
      },
    );
  }
}
