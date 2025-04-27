import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/components/app_back_button.dart';
import '../../core/components/appbar_header.dart';
import '../../core/constants/constants.dart';
import '../../core/models/purchase_requisition/pr_items_model.dart';
import '../../core/models/purchase_requisition/pr_master_model.dart';
import '../../core/models/system/dropdown_item.dart';
import '../../core/services/purchase_requisition/pr_api_service.dart';
import '../../core/services/system/system_api_service.dart';
import '../../theme/themes/app_themes.dart';


class PrMasterPage extends StatefulWidget {
  const PrMasterPage({super.key});

  @override
  State<PrMasterPage> createState() => _PrMasterPage();
}

class _PrMasterPage extends State<PrMasterPage> {
  List<Widget> itemFields = [];

  final TextEditingController _dateController = TextEditingController();
  List<ItemsDDL> _itemsDDl = [];

  List<Map<String, dynamic>> itemEntries = [];
  Map<int, List<ItemBrandDDL>> brandsDDLMap = {};
  Map<int, ItemBrandDDL?> selectedBrandMap = {};
  Map<int, ItemUOM?> selectedItemUOMMap = {};

  String _buttonText = "SAVE";

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _fetchItemDDl(); // Moved here from initState()
    _addNewItem(); // UI-related function, can stay in initState
  }

  Future<void> _fetchItemDDl() async {
    try {
      final items = await SystemApiService.fetchItemDDl();
      setState(() {
        _itemsDDl = items;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load contractors')),
        );
      }
    }
  }

  Future<void> _fetchBrandDDl(int itemID, int index) async {
    try {
      final brands = await SystemApiService.fetchBrandDDlUsingItem(itemID);
      setState(() {
        brandsDDLMap[index] = brands;
        selectedBrandMap[index] = null;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load brands')),
        );
      }
    }
  }

  Future<void> _fetchUOMUsingItem(int itemID, int index) async {
    try {
      final uoms = await SystemApiService.fetchUOMUsingItem(itemID);
      setState(() {
        selectedItemUOMMap[index] = uoms;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load UOm')),
        );
      }
    }
  }

  Future<void> _savePR() async {
    if (_dateController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add required by date')),
      );
      return;
    }
    List<PrItemsModel> prItems = [];

    for (var entry in itemEntries) {
      dynamic itemField = entry['item'];
      dynamic qtyField = entry['qty'];
      dynamic brandField = entry['brand'];

      if (itemField != null &&
          itemField.id > 0 &&
          qtyField != null &&
          qtyField != "" &&
          brandField != null &&
          brandField.itemBrandID > 0) {
        final prItemsModel = PrItemsModel(
            itemID: itemField.id.toString(),
            itemBrandID: brandField.itemBrandID.toString(),
            itemDescription: "",
            itemUOMID: "1000",
            quantity: qtyField);
        prItems.add(prItemsModel);
      }
    }

    if (prItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }

    final prMasterModel = PrMasterModel(
        companyCode: "",
        requiredByDate: _dateController.text,
        plantID: 10,
        prItems: prItems,
        requisitionfor: "",
        userID: 10);

    try {
      await PrApiService.savePR(prMasterModel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PR Saved Successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save PR')),
      );
    }
  }

  void _addNewItem() {
    setState(() {
      itemEntries.add({
        'item': null,
        'brand': null,
        'qty': TextEditingController(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title:
            AppbarHeader(headerName: 'New PR', projectName: 'Ganesh Gloary 11'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(AppDefaults.padding),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
            vertical: AppDefaults.padding * 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: AppDefaults.borderRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Date Fields */
              Text(
                "Required By Date *",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppDefaults.padding_2),
              _buildDatePicker(TextInputType.datetime, TextInputAction.next),
              const SizedBox(height: AppDefaults.padding_3),

              /* Item Fields */
              for (int index = 0; index < itemEntries.length; index++)
                _buildItemFields(index),
              const SizedBox(height: AppDefaults.padding_3),

              /* Add More Button */
              OutlinedButton(
                onPressed: _addNewItem,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Adjust padding here
                ),
                child: Text(
                  "Add More",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: AppDefaults.padding_3),

              /* Save Button */
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePR,
                  child: Text(_buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemFields(int index) {
    var entry = itemEntries[index];

    Widget buildItemsDropdown(String label, List<String> items) {
      return SizedBox(
          height: AppDefaults.ddlSizeBoxHeight,
          child: CustomDropdown<String>.search(
            hintText: "Select $label",
            items: items,
            initialItem: entry['item']?.itemName,
            onChanged: (value) {
              final selectedItem =
                  _itemsDDl.firstWhere((item) => item.itemName == value);
              setState(() {
                entry['item'] = selectedItem;
                _fetchBrandDDl(selectedItem.id, index);
                _fetchUOMUsingItem(selectedItem.id, index);
              });
            },
            decoration: AppTheme.mapInputDecorationToDropdown(),
          ));
    }

    Widget buildBrandDropdown(String label) {
      return SizedBox(
          height: AppDefaults.ddlSizeBoxHeight,
          child: CustomDropdown<String>.search(
            hintText: "Select Brand",
            items: brandsDDLMap[index]
                    ?.map((brand) => brand.itemBrandName)
                    .toList() ??
                [],
            initialItem: entry['brand']?.itemBrandName,
            onChanged: (value) {
              setState(() {
                entry['brand'] = brandsDDLMap[index]
                    ?.firstWhere((brand) => brand.itemBrandName == value);
              });
            },
            decoration: AppTheme.mapInputDecorationToDropdown(),
          ));
    }

    buildQtyField(TextInputType keyboardType, TextInputAction textInputAction) {
      return TextFormField(
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: (value) {
          setState(() {
            entry['qty'] = value;
          });
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 2),
        Text(
          "Item ${index + 1}",
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDefaults.padding_2),
        Text(
          "Item Name *",
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDefaults.padding_2),
        buildItemsDropdown(
            "Item *", _itemsDDl.map((item) => item.itemName).toList()),
        const SizedBox(height: AppDefaults.padding_3),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Brand Name",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppDefaults.padding_2),
                  buildBrandDropdown("Brand *"),
                ],
              ),
            ),
            const SizedBox(width: AppDefaults.padding_3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedItemUOMMap[index]?.itemUOMName != null
                        ? "Qty. in (${selectedItemUOMMap[index]?.itemUOMName})"
                        : "Qty.",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppDefaults.padding_2),
                  buildQtyField(TextInputType.number, TextInputAction.next),
                ],
              ),
            ),
          ],
        ),
        // const SizedBox(height: AppDefaults.padding_3),
      ],
    );
  }

  _buildDatePicker(
      TextInputType keyboardType, TextInputAction textInputAction) {
    return TextFormField(
      controller: _dateController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      readOnly: true,
      decoration: const InputDecoration(
          suffixIcon: Icon(
            Icons.calendar_today_outlined,
            size: 20,
          ),
          hintText: "__/__/____"),
      onTap: () => _selectDate(context),
    );
  }
}
