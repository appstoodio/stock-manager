import 'package:Rashdi_Mobile/screens/add_expenses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/expenses_controller.dart';
import 'home_screen.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final ExpensesController controller = Get.put(ExpensesController());
  final user = FirebaseAuth.instance.currentUser!.uid;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String? selectedMonth;
  int totalPrice = 0; // Total price of filtered expenses

  @override
  void initState() {
    super.initState();
    selectedMonth = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Get.off(const HomeScreen()),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            const Text('Expenses'),
            // Dropdown for selecting month
            IconButton(onPressed: (){controller.showDateFilterDialog(context);}, icon: const Icon(Icons.calendar_month))
            // Container to display total expense price
            // Container(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            //   decoration: BoxDecoration(
            //     color: Colors.amber,
            //     borderRadius: BorderRadius.circular(20.0),
            //   ),
            //   child: Text(
            //     'Total: \$${controller.totalPrice.toString()}',
            //     style: const TextStyle(
            //       fontSize: 16.0,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
          ],
        ),
         backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Obx(() {
              if (controller.docss.isEmpty) {
                return const Center(child: Text('No expenses found'));
              }
              // Calculate total price outside ListView.builder
              totalPrice = 0;
              for (var doc in controller.docss) {
                totalPrice += int.parse(doc['price']);
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.docss.length,
                itemBuilder: (context, index) {
                  final doc = controller.docss[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(
                          'Item: ${doc['name']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Price: ${doc["price"]}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              doc["date"],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('expenses')
                                    .doc(doc.id)
                                    .delete();
                               
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddExpenses());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

