// ignore_for_file: avoid_print

import 'package:Rashdi_Mobile/screens/expenses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/connectivity.dart';

class ExpensesController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final RxList<DocumentSnapshot> docss = <DocumentSnapshot>[].obs;
  final RxInt expensePrice = 0.obs;
  final RxInt filteredExpensePrice = 0.obs;
  final user = FirebaseAuth.instance.currentUser!.uid;
  RxInt totalPrice = 0.obs;
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> expenses =
      RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  final RxBool isLoading = RxBool(false);
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize stream and listen for changes
    fetchPrice();
  }

  void fetchPrice() {
    try {
      FirebaseFirestore.instance
          .collection('expenses')
          .where('user', isEqualTo: user)
          .orderBy('date', descending: true)
          .snapshots(includeMetadataChanges: true)
          .listen((snapshot) {
        expensePrice.value = 0; // Reset expensePrice
        docss.assignAll(snapshot.docs);

        // Calculate total expensePrice
        for (var doc in snapshot.docs) {
          var price = doc['price'];
          if (price != null) {
            expensePrice.value += int.parse(price);
          }
        }
        for (var doc in docss) {
          var price = doc['price'];
          if (price != null) {
            filteredExpensePrice.value += int.parse(price);
          }
        }
      });
    } on FirebaseException catch (e) {
      // Check if the error is due to network unavailability
      if (e.code == 'unavailable') {
        // Handle the case where Firestore is unreachable (e.g., no internet connection)
        // For example, display a message to the user indicating the network issue
        print(
            'Error: Firestore is unreachable. Please check your internet connection.');
      } else {
        // Handle other Firebase-related errors
        print('Firebase Error: ${e.message}');
      }
    } catch (e) {
      print("error in ExpensesController init");
    }
  }

  Future<void> fromDateSelect(BuildContext context) async {
    final selectedDate = await showDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      context: context,
    );
    // DateTime dateTime = selectedDate ?? DateTime.now();

    if (selectedDate != null) {
      // Format the selected date
      String formattedDate =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
      fromDate.value = formattedDate;
      update();
    }
  } //=========================================================

  // Select To date
  Future<void> toDateSelect(BuildContext context) async {
    final selectedDate = await showDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      context: context,
    );
    // DateTime dateTime = selectedDate ?? DateTime.now();

    if (selectedDate != null) {
      // Format the selected date
      String formattedDate =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
      toDate.value = formattedDate;
      update();
    }
  } //=====================================

  //Dialog box to show date selecter

  Future<void> showDateFilterDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => TextButton(
                    onPressed: () {
                      fromDateSelect(context);
                      update();
                    },
                    child: Text(fromDate.value == ''
                        ? 'Select From Date'
                        : fromDate.value)),
              ),
              Obx(() => TextButton(
                  onPressed: () {
                    toDateSelect(context);
                    update();
                  },
                  child: Text(
                      toDate.value == '' ? 'Select To Date' : toDate.value)))
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                fromDate.value = '';
                toDate.value = '';
              },
              child: const Text('Clear Filters'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                fetchExpensesForMonth();
                update();
                print(toDate);
                print(fromDate);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fetch expenses from Firestore
  Future<void> fetchExpensesForMonth() async {
    try {
      GetOptions getSource = const GetOptions(source: Source.cache);
      if (await InternetConnectivity().checkConnection()) {
        getSource = const GetOptions(source: Source.server);
      }

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('user', isEqualTo: user)
          .where('date',
              isGreaterThanOrEqualTo: fromDate.value, isLessThanOrEqualTo: toDate.value)
          .get(getSource);

      int total = 0;
      for (var doc in snapshot.docs) {
        total += int.parse(doc['price']);
      }
      totalPrice.value = total;

      docss.value = snapshot.docs;
    } catch (e) {
      print('Error fetching expenses for month: $e');
    }
  }

  Future<void> uploadExpenses(String selectedDate, BuildContext context) async {
    try {
      // Format the selectedDate as a string

      // Access Firestore and save the data
      await FirebaseFirestore.instance.collection('expenses').add({
        'user': user,
        'name': nameController.text,
        'price': priceController.text,
        'date': selectedDate,
      });

      Get.off(const Expenses());

      // Clear the controllers after successful upload
      nameController.clear();
      priceController.clear();
    } on FirebaseException catch (e) {
      // Check if the error is due to network unavailability
      if (e.code == 'unavailable') {
        print(
            'Error: Firestore is unreachable. Please check your internet connection.');
      } else {
        print('Firebase Error: ${e.message}');
      }
    } catch (e) {
      // Handle errors
      Get.snackbar('Error', 'Error uploading expenses: $e');
    }
  }
}
