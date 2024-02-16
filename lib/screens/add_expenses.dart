import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/expenses_controller.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({super.key});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final ExpensesController expensesController = Get.put(ExpensesController());
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expenses'),
         backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text(
                DateFormat('dd-MM-yyyy')
                    .format(_selectedDate ?? DateTime.now()),
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: expensesController.nameController,
              decoration: const InputDecoration(
                hintText: 'Enter product name',
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: expensesController.priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter buy rate',
                labelText: 'Buy Rate',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final date = _selectedDate ?? DateTime.now();
                expensesController.uploadExpenses(date, context);
                expensesController.priceController.clear();
                expensesController.nameController.clear();
                Get.off(const HomeScreen());
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
