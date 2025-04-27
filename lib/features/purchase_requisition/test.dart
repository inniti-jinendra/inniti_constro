import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/components/app_back_button.dart';
import '../../core/constants/constants.dart';
import '../../core/models/system/dropdown_item.dart';
import '../../core/services/system/system_api_service.dart';
import '../../theme/themes/app_themes.dart';


class PrMasterPage extends StatefulWidget {
  const PrMasterPage({super.key});

  @override
  State<PrMasterPage> createState() => _PrMasterPage();
}

class _PrMasterPage extends State<PrMasterPage> {
  List<Map<String, dynamic>> itemEntries = [];
  final TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  List<ItemsDDL> _itemsDDl = [];
  Map<int, List<ItemBrandDDL>> brandsDDLMap = {};
  Map<int, ItemBrandDDL?> selectedBrandMap = {};
  Map<int, TextEditingController> qtyControllers = {};

  @override
  void initState() {
    super.initState();
    _fetchItemDDl();
  }

  Future<void> _fetchItemDDl() async {
    try {
      final items = await SystemApiService.fetchItemDDl();
      setState(() {
        _itemsDDl = items;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load items')),
      );
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

  void _addNewItem() {
    int index = itemEntries.length;
    setState(() {
      itemEntries.add({
        'item': null,
        'brand': null,
        'qty': TextEditingController(),
      });
    });
  }

  Future<void> _savePR() async {
    List<Map<String, dynamic>> itemsToSave = [];

    for (var entry in itemEntries) {
      if (entry['item'] != null && entry['qty'].text.isNotEmpty) {
        itemsToSave.add({
          'itemID': entry['item'].id,
          'brandID': entry['brand']?.id ?? null,
          'quantity': int.parse(entry['qty'].text),
        });
      }
    }

    if (itemsToSave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }

    try {
      // await SystemApiService.savePR({
      //   'requiredDate': _dateController.text,
      //   'items': itemsToSave,
      // });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PR Saved Successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save PR')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('New PR'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Required By Date *"),
            _buildDatePicker(),
            const SizedBox(height: AppDefaults.padding),
            const Text("Request By (Person) *"),
            _buildTextField(TextInputType.text),
            const SizedBox(height: AppDefaults.padding),
            const Text("Delivery Location *"),
            _buildTextField(TextInputType.text),
            const SizedBox(height: AppDefaults.padding),
            for (int index = 0; index < itemEntries.length; index++)
              _buildItemFields(index),
            const SizedBox(height: AppDefaults.padding),
            OutlinedButton(
              onPressed: _addNewItem,
              child: const Text("Add More"),
            ),
            const SizedBox(height: AppDefaults.padding),
            ElevatedButton(
              onPressed: _savePR,
              child: const Text('Save PR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemFields(int index) {
    var entry = itemEntries[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 2),
        Text("Item ${index + 1}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppDefaults.padding_2),
        const Text("Item Name *"),
        CustomDropdown<String>.search(
          hintText: "Select Item",
          items: _itemsDDl.map((item) => item.itemName).toList(),
          initialItem: entry['item'] != null ? entry['item'].itemName : null,
          onChanged: (value) {
            final selectedItem =
                _itemsDDl.firstWhere((item) => item.itemName == value);
            setState(() {
              entry['item'] = selectedItem;
              _fetchBrandDDl(selectedItem.id, index);
            });
          },
          decoration: AppTheme.mapInputDecorationToDropdown(),
        ),
        const SizedBox(height: AppDefaults.padding),
        const Text("Brand Name"),
        CustomDropdown<String>.search(
          hintText: "Select Brand",
          items: brandsDDLMap[index]
                  ?.map((brand) => brand.itemBrandName)
                  .toList() ??
              [],
          initialItem:
              entry['brand'] != null ? entry['brand'].itemBrandName : null,
          onChanged: (value) {
            setState(() {
              entry['brand'] = brandsDDLMap[index]
                  ?.firstWhere((brand) => brand.itemBrandName == value);
            });
          },
          decoration: AppTheme.mapInputDecorationToDropdown(),
        ),
        const SizedBox(height: AppDefaults.padding),
        const Text("Qty"),
        _buildQtyTextField(entry['qty']),
        const SizedBox(height: AppDefaults.padding),
      ],
    );
  }

  Widget _buildTextField(TextInputType keyboardType) {
    return TextFormField(keyboardType: keyboardType);
  }

  Widget _buildQtyTextField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.calendar_today),
        hintText: "__/__/____",
      ),
      onTap: () => _selectDate(context),
    );
  }
}
