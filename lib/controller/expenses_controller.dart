import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpensesController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  
  final RxList<DocumentSnapshot> docss = <DocumentSnapshot>[].obs;
  final RxInt expensePrice = 0.obs;
  final user = FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    // Initialize stream and listen for changes
    FirebaseFirestore.instance
        .collection('expenses').where('user', isEqualTo: user)
        .orderBy('date', descending: true)
        .snapshots()
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
    });
  }
  Future<void> uploadExpenses(DateTime selectedDate, BuildContext context) async {
    try {
      // Format the selectedDate as a string
      String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSS').format(selectedDate);

      // Access Firestore and save the data
      await FirebaseFirestore.instance.collection('expenses').add({
        'user' : user,
        'name': nameController.text,
        'price': priceController.text,
        'date': formattedDate,
      });

     
     Get.off(const HomeScreen());

      // Clear the controllers after successful upload
      nameController.clear();
      priceController.clear();
    } catch (e) {
      // Handle errors
       Get.snackbar('Error', 'Error uploading expenses: $e');
      
    }
  }
}
