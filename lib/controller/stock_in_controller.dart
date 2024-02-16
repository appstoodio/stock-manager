import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Rashdi_Mobile/model/transacation.dart';
import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:Rashdi_Mobile/screens/stock_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/company.dart';

class StockInController extends GetxController {
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference stockCollection =
      FirebaseFirestore.instance.collection('stockIn');

  var dataList = <String>[].obs; // Observable list to store data from Firestore
  // var stockList = <StockInModel>[].obs;
  var selectedItems = <String>[].obs; // Observable list to store selected items
  final TextEditingController priceController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController vendorController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController addNewCompController = TextEditingController();
  final TextEditingController discController = TextEditingController();
  final TextEditingController imeiController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!.uid;

  bool isSearchBarVisible = false;

  int? imei;

  /// Discount formula

  double calculateAmount() {
    double price = double.tryParse(priceController.text) ?? 0.0;
    double discount = double.tryParse(discController.text) ?? 0.0;
    double amount = (price * discount) / 100;
    return amount;
  }

  @override
  void dispose() {
    super.dispose();
    priceController.dispose();
    modelController.dispose();
    addNewCompController.dispose();
  }

  @override
  void onInit() {
    // fetchDataFromFirestore();
    super.onInit();
  }

  void showCustomDialog(BuildContext context) {
    Get.dialog(
      SimpleDialog(
        title: const Text('Add new'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: addNewCompController,
              decoration: const InputDecoration(
                hintText: 'Company name',
              ),
            ),
          ),
          TextButton(
              onPressed: () => saveCompanyToFirestore().then((value) {
                    Navigator.of(context).pop();
                    addNewCompController.clear();
                  }),
              child: const Text('Save'))
        ],
      ),
    );
  }



  Future<void> saveCompanyToFirestore() async {
    try {
      Company company = Company(name: addNewCompController.text, user: user);
      FirebaseFirestore.instance
          .collection('company')
          .doc(addNewCompController.text)
          .set(company.toMap());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteCompany(String doc, BuildContext context) async {
    try {
      FirebaseFirestore.instance.collection('company').doc(doc).delete();
      Navigator.of(context).pop();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> scan() async {
    try {
      var result = await BarcodeScanner.scan();
      final imei = result.rawContent;
      if (result.type == ResultType.Cancelled) {
        Get.offAll(const StockIn(), arguments: imei);
      } else if (imei.length < 15) {
        Get.snackbar('Error', 'Digits are below 15.');
      }
      else{
 Get.offAll(const StockIn(), arguments: imei);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data from Firestore: $e');
    }
  }

  // save stock to firestore
  Future<void> uploadStock(String company, String date, int imei) async {
    double discAmount = calculateAmount();
    try {
      //  if( FirebaseFirestore.instance.collection('stockIn').doc(id.toString()) == null){
      try {
        // Check if any of the fields are empty
        if (modelController.text.isEmpty ||
            priceController.text.isEmpty ||
            company.isEmpty) {
          Get.snackbar('Error', 'Please fill in all fields');
          return;
        }
        TransactionModel transactionModel = TransactionModel(
            user: FirebaseAuth.instance.currentUser!.uid,
            transactionType: 'In',
            date: date,
            model: modelController.text,
            company: company,
            imei: imei.toString(),
            price: double.parse(priceController.text) ?? 0.0,
            discount: discAmount);

              String inName = '$user${imeiController.text}In';

        // Reference to the products collection in Firestore
      //  DocumentSnapshot stockIn =
      //      await FirebaseFirestore.instance.collection('transaction').doc(inName).get();
            

        
        // check if there is already IN doc with same imei

        // Future<QuerySnapshot<Map<String, dynamic>>> resultSnapshotFuture =
        //     FirebaseFirestore.instance.collection('transaction').where('user', isEqualTo: user).where('transactionType', isEqualTo: 'In').where('imei', isEqualTo: imei.toString()).limit(1).get();

      
          // if (stockIn.exists) {
           
            //  Get.snackbar('error', 'stockIn already added');
            Get.offAll(() => const HomeScreen());
          // } else {
            FirebaseFirestore.instance.collection('transaction').doc(inName).set(transactionModel.toMap());
          // }
      
      } catch (e) {
        Get.snackbar('Error', 'Error uploading stockIn: $e');
      }
      //  }else{
      //   Get.snackbar('Error', 'Product already added.');
      //  }
    } catch (e) {
      Get.snackbar('error', e.toString());
    }
  }
}
