import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectableDateWidget extends StatefulWidget {
  const SelectableDateWidget({Key? key}) : super(key: key);

  @override
  _SelectableDateWidgetState createState() => _SelectableDateWidgetState();
}

class _SelectableDateWidgetState extends State<SelectableDateWidget> {
  // Store the current date
  DateTime _currentDate = DateTime.now();

  // Function to show the date picker and allow the user to select a date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _currentDate.subtract(Duration(days: 1)), // Show the previous day as the default value
      firstDate: DateTime(1900), // Set the first selectable date
      lastDate: DateTime.now(), // Set the last selectable date as today
    );

    if (pickedDate != null && pickedDate != _currentDate) {
      setState(() {
        _currentDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the date in the required format
    final formattedDate = DateFormat('dd MMM yyyy').format(_currentDate);

    return GestureDetector(
     // onTap: () => _pickDate(context), // Open the date picker when the user taps on the date
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.purple),
          const SizedBox(width: 8),
          Text(
            formattedDate,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
