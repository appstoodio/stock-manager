import 'package:Rashdi_Mobile/controller/home_controller.dart';
import 'package:Rashdi_Mobile/helper/connectivity.dart';
import 'package:Rashdi_Mobile/model/due_payment.dart';
import 'package:Rashdi_Mobile/model/transacation.dart';
import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:Rashdi_Mobile/screens/stock_out.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockOutController extends GetxController {
  final CollectionReference stockIn =
      FirebaseFirestore.instance.collection('transaction');
  final TextEditingController priceController = TextEditingController();
  final TextEditingController vendorPriceController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  TextEditingController vendorNameController = TextEditingController();
  final TextEditingController imeiController = TextEditingController();
  final TextEditingController promotionControlle = TextEditingController();
  String? scanResult;
  final user = FirebaseAuth.instance.currentUser!.uid;
  final HomeController homeController = Get.put(HomeController());
  final RxDouble innPrice = 0.0.obs;

  Future<void> scan() async {
    var result = await BarcodeScanner.scan(
        options: const ScanOptions(autoEnableFlash: false));
    scanResult = result.rawContent;

    try {
      if (result.type == ResultType.Cancelled) {
        Get.offAll(() =>const StockOut(), arguments: scanResult);
      } else if (scanResult!.length < 15) {
        Get.snackbar('Error', 'Digits are below 15.');
      }
      //   print(scanResult);
      else {
        Get.offAll(() =>const StockOut(), arguments: scanResult);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data from Firestore: $e');
    }
  }

  Future<void> uploadStock(
      {required int imei,
      required bool trading,
      required String cashOrCredit,
      required String date,
      required String vendorName,
      required String modelName,
      required String compName,
      required double price,
      required double promotion
      }) async {
    try {
      GetOptions getSource = const GetOptions(source: Source.cache);
      if (await InternetConnectivity().checkConnection()) {
        getSource = const GetOptions(source: Source.server);
      }
      TransactionModel transactionModel = TransactionModel(
        user: FirebaseAuth.instance.currentUser!.uid,
        transactionType: 'Out',
        date: date,
        model: modelName,
        company: compName,
        imei: imei.toString(),
        price: price,
        cashOrCredit: cashOrCredit,
        trading: trading,
        promotion:promotion ,
        time: DateTime.now(),
      );

      CollectionReference stockOut =
          FirebaseFirestore.instance.collection('transaction');
      CollectionReference<Map<String, dynamic>> querySnapshot =
          FirebaseFirestore.instance.collection('transaction');

      // Now that stockOut has been awaited, perform the query
      QuerySnapshot resultSnapshot = await querySnapshot
          .where('user', isEqualTo: user)
          .where('transactionType', isEqualTo: 'In')
          .where('imei', isEqualTo: imei.toString())
          .get(getSource);

      QuerySnapshot resultSnapshot2 = await querySnapshot
          .where('user', isEqualTo: user)
          .where('transactionType', isEqualTo: 'Out')
          .where('imei', isEqualTo: imei.toString())
          .get(getSource);
      if (resultSnapshot.docs.isNotEmpty && resultSnapshot2.docs.isEmpty) {
        stockOut.doc().set(transactionModel.toMap());

        for (DocumentSnapshot doc in resultSnapshot.docs) {
          // Calculate the updated inPrice (assuming 'price' exists and is a number)
          double newInPrice = doc['price'];

          // Optionally, update inPrice.value in your controller for immediate UI response
          innPrice.value = newInPrice;
          print(innPrice.value);
        }

        // Get.snackbar('Success', 'Stock-Out uploaded successfully!');
        Get.offAll(() =>const HomeScreen());
      } else {
        Get.snackbar('error', 'stock-out already added');
      }
    } on FirebaseException catch (e) {
      // Check if the error is due to network unavailability
      if (e.code == 'unavailable') {
        print(
            'Error: Firestore is unreachable. Please check your internet connection.');
      } else {
        print('Firebase Error: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error uploading stockOut: $e');
    }
  }

  Future<void> uplaodDuePayment(String date, int imei, double price, String vendor, double inPrice) async {
    try {
      //  final double pricePaid = double.parse(priceController.text) - double.parse(vendorPriceController.text);
      GetOptions getSource = const GetOptions(source: Source.cache);
      if (await InternetConnectivity().checkConnection()) {
        getSource = const GetOptions(source: Source.server);
      }
      DuePayment duePayment = DuePayment(
          imei: imei.toString(),
          vendorName: vendor,
          price: price,
          priceRem: inPrice,
          pricePaid: 0.0,
          user: user,
          paid: false,
          time: DateTime.now(),
          date: date);
      CollectionReference duePaym =
          FirebaseFirestore.instance.collection('due_payment');

      CollectionReference<Map<String, dynamic>> querySnapshot =
          FirebaseFirestore.instance.collection('transaction');

      // Now that stockOut has been awaited, perform the query
      QuerySnapshot resultSnapshot = await querySnapshot
          .where('user', isEqualTo: user)
          .where('transactionType', isEqualTo: 'In')
          .where('imei', isEqualTo: imei.toString())
          .get(getSource);

      QuerySnapshot resultSnapshot2 = await querySnapshot
          .where('user', isEqualTo: user)
          .where('transactionType', isEqualTo: 'Out')
          .where('imei', isEqualTo: imei.toString())
          .get(getSource);

      if (resultSnapshot.docs.isNotEmpty && resultSnapshot2.docs.isEmpty) {
        duePaym.doc().set(duePayment.toMap());
      } else {
        Get.off(const HomeScreen());
      }
    } on FirebaseException catch (e) {
      // Check if the error is due to network unavailability
      if (e.code == 'unavailable') {
        print(
            'Error: Firestore is unreachable. Please check your internet connection.');
      } else {
        print('Firebase Error: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('error', e.toString());
    }
  }
}
