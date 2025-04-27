import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/components/app_back_button.dart';
import '../../../core/components/appbar_header.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_defaults.dart';

class ErpDprEntry extends StatefulWidget {
  const ErpDprEntry({super.key});

  @override
  _ErpDprEntryPageState createState() => _ErpDprEntryPageState();
}

class _ErpDprEntryPageState extends State<ErpDprEntry> {
  final _dprQty = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: AppbarHeader(headerName: 'Machinery Work', projectName: ''),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Expanded(
              child: Column(
                children: [
                  _bindWorkDetailsQtyWise(context),
                  SizedBox(
                    height: AppDefaults.padding_2,
                  ),
                  _bindProjectLocation(context),
                  SizedBox(
                    height: AppDefaults.padding_2,
                  ),
                  _bindDate(context),
                  SizedBox(
                    height: AppDefaults.padding_2,
                  ),
                  _bindPendingQty(context),
                  SizedBox(
                    height: AppDefaults.padding_2,
                  ),
                  _bindDPRForm(context)
                ],
              ),
            )));
  }

  Widget _bindWorkDetailsQtyWise(context) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppDefaults.boxShadow,
          border: Border.all(color: AppColors.gray)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _bindWorkDetailsQtyWiseDetails(
              context, "Item Qty.", "50,000", "Feet"),
          _bindWorkDetailsQtyWiseDetails(
              context, "Assign Qty.", "4,000", "Feet"),
          _bindWorkDetailsQtyWiseDetails(
              context, "Done Qty.", "13,000", "Feet"),
        ],
      ),
    );
  }

  Widget _bindWorkDetailsQtyWiseDetails(
      context, textLable, textValue, uomName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(textLable,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(fontWeight: FontWeight.w500, color: Colors.grey)),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: textValue,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' $uomName',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bindProjectLocation(context) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppDefaults.boxShadow,
          border: Border.all(color: AppColors.gray)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(AppDefaults.padding_3),
              decoration: BoxDecoration(
                  color: AppColors.coloredBackground,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(
                FontAwesomeIcons.mapPin,
                size: 20,
              )),
          SizedBox(width: AppDefaults.padding_3),
          Text("Wing A > Floor 1 > F101 > Machinery Work",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _bindDate(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _bindDueDate(
            context, FontAwesomeIcons.calendarCheck, "Date", "10 Frb 2025"),
        _bindDueDate(context, FontAwesomeIcons.clock, "Due Date", "28 Frb 2025")
      ],
    );
  }

  Widget _bindDueDate(context, dateIcon, dateLable, dateValue) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppDefaults.boxShadow,
          border: Border.all(color: AppColors.gray)),
      child: SingleChildScrollView(
        child: Row(children: [
          Column(
            children: [
              Container(
                  padding: EdgeInsets.all(AppDefaults.padding_3),
                  decoration: BoxDecoration(
                      color: AppColors.coloredBackground,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    dateIcon,
                    size: 20,
                  )),
            ],
          ),
          SizedBox(width: AppDefaults.padding),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dateLable,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.grey)),
              Text(dateValue,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.w500))
            ],
          ),
          SizedBox(width: AppDefaults.padding_2),
        ]),
      ),
    );
  }

  Widget _bindPendingQty(context) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppDefaults.boxShadow,
          border: Border.all(color: AppColors.gray)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(AppDefaults.padding_3),
              decoration: BoxDecoration(
                  color: AppColors.coloredBackground,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(
                FontAwesomeIcons.exclamation,
                size: 20,
              )),
          SizedBox(width: AppDefaults.padding_3),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pending Qty",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.grey)),
              Text("20,000 Ft",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.w500))
            ],
          ),
        ],
      ),
    );
  }

  Widget _bindDPRForm(context) {
    return Form(
      child: Row(children: [
        Text(
          "Quantity. *",
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppDefaults.padding_2),
        _buildTextField(_dprQty, TextInputType.text, TextInputAction.next),
      ]),
    );
  }

  _buildTextField(TextEditingController controller, TextInputType keyboardType,
      TextInputAction textInputAction) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
    );
  }
}
