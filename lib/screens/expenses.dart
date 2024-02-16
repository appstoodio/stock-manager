import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/expenses_controller.dart';
import 'add_expenses.dart';

class Expenses extends StatelessWidget {
  final ExpensesController controller = Get.put(ExpensesController());

   Expenses({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
  appBar: AppBar(
    title: const Text('Expenses'),
    backgroundColor: Colors.amber,// Set your preferred app bar color
  ),
  body: Obx(() {
    if (controller.docss.isEmpty) {
      return const Center(child: Text('No expenses found'));
    }
    return ListView.builder(
      itemCount: controller.docss.length,
      itemBuilder: (context, index) {
        final doc = controller.docss[index];
        final width = Get.width;
        final height = Get.height;
        return Padding(
          padding: const EdgeInsets.all(8.0), // Increased padding for better spacing
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Add border for visual separation
              borderRadius: BorderRadius.circular(8.0), // Add rounded corners
            ),
            child: ListTile(
              title: Text(
                'Item: ${doc['name']}',
                style: const TextStyle(
                  fontSize: 20, // Increased font size for better readability
                  fontWeight: FontWeight.bold, // Added bold font weight
                ),
              ),
              subtitle: Text(
                'Price: ${doc["price"]}',
                style: const TextStyle(
                  fontSize: 16, // Adjusted font size
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('dd-MM-yyyy').format(
                      DateTime.parse(doc["date"]),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8), // Added spacing between date and icon
                  IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('expenses')
                          .doc(doc.id)
                          .delete();
                   
                      Get.offAll(const HomeScreen());
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }),
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      Get.to(() => const AddExpenses());
    },
    child: const Icon(Icons.add), // Replaced text with icon for the FloatingActionButton
  ),
)

    );
  }
}