import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/custom_dialog/custom_dialog.dart';

class AddLabourPage extends StatelessWidget {
  const AddLabourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class AddLabourPersonDialog {
  static void show(BuildContext context) {
    // Controllers for text fields
    TextEditingController dateController = TextEditingController();
    TextEditingController totalPersonsController = TextEditingController();
    TextEditingController amountPerDayController = TextEditingController();
    TextEditingController otPersonsController = TextEditingController();
    TextEditingController otHoursController = TextEditingController();
    TextEditingController amountPerHourController = TextEditingController();
    TextEditingController totalAmountController = TextEditingController();

    // Dropdown values
    String? selectedItemType;
    String? selectedPersonType;
    String? selectedContractor;

    // Function to calculate total amount
    void calculateTotalAmount() {
      double totalPersons = double.tryParse(totalPersonsController.text) ?? 0;
      double amountPerDay = double.tryParse(amountPerDayController.text) ?? 0;
      double otPersons = double.tryParse(otPersonsController.text) ?? 0;
      double otHours = double.tryParse(otHoursController.text) ?? 0;
      double amountPerHour = double.tryParse(amountPerHourController.text) ?? 0;

      double total = (totalPersons * amountPerDay) + (otPersons * otHours * amountPerHour);
      totalAmountController.text = total.toStringAsFixed(2);
    }

    // Date Picker Function
    void _showCustomDatePicker(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        dateController.text = formattedDate;
      }
    }

    // List of form fields
    List<Widget> formFields = [
      _buildLabel("Date"),
      TextField(
        controller: dateController,
        decoration: const InputDecoration(
          labelText: 'Select Date *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () => _showCustomDatePicker(context),
      ),
      const SizedBox(height: 20),

      // Dropdowns
      Row(
        children: [
          Expanded(child: _buildDropdown("Item Types", ["Type 1", "Type 2", "Type 3"], selectedItemType)),
          const SizedBox(width: 10),
          Expanded(child: _buildDropdown("Person Type", ["Type A", "Type B", "Type C"], selectedPersonType)),
        ],
      ),
      const SizedBox(height: 20),

      _buildDropdown("Contractor *", ["Contractor 1", "Contractor 2", "Contractor 3"], selectedContractor),
      const SizedBox(height: 20),

      // Person and Amount Fields
      Row(
        children: [
          Expanded(child: _buildTextField("Total Persons *", totalPersonsController)),
          const SizedBox(width: 10),
          Expanded(child: _buildTextField("Amount/Day *", amountPerDayController)),
        ],
      ),
      const SizedBox(height: 20),

      // Overtime Fields
      Row(
        children: [
          Expanded(child: _buildTextField("Total Persons (OT)", otPersonsController)),
          const SizedBox(width: 10),
          Expanded(child: _buildTextField("Total Hrs. (OT)", otHoursController)),
        ],
      ),
      const SizedBox(height: 20),

      // Amount per hour and total amount
      Row(
        children: [
          Expanded(child: _buildTextField("Amount Per/Hrs.", amountPerHourController)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: totalAmountController,
              decoration: const InputDecoration(
                labelText: 'Total Amount',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ),
        ],
      ),
      const SizedBox(height: 30),
    ];

    // Show CustomDialog
    CustomDialog.show(
      context,
      title: "Add Labour Person",
      formFields: formFields,
      onSave: () {
        calculateTotalAmount();
        Navigator.pop(context); // Close dialog after saving
      },
      onClose: () => Navigator.pop(context),
    );
  }

  // Helper Method: Label
  static Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // Helper Method: Custom TextField
  static Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Helper Method: Custom Dropdown
  static Widget _buildDropdown(String label, List<String> items, String? selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          value: selectedValue,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }
}
