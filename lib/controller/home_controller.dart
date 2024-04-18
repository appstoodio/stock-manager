// ignore_for_file: avoid_print

import 'package:Rashdi_Mobile/model/due_payment.dart';
import 'package:Rashdi_Mobile/model/transacation.dart';
import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../helper/connectivity.dart';

class HomeController extends GetxController {
//  var stockInCount = 0.obs;
//   var stockOutCount = 0.obs;
//   var inHandCount = 0.obs;
  Map<String, double> dataMap = {};
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.uid;
  // final StockOutController stockOutController = Get.put(StockOutController());

  final RxDouble inPrice = 0.0.obs;
  final RxDouble outPrice = 0.0.obs;
  final RxDouble stockInPriceProfit = 0.0.obs;
  final RxDouble stockOutPriceProfit = 0.0.obs;
  final RxDouble profit = 0.0.obs;
  final RxDouble expensesPrice = 0.0.obs;
  final RxDouble promotionPrice = 0.0.obs;
  final RxInt stockInCount = 0.obs;
  final RxInt stockOutCount = 0.obs;
  final RxInt inHandCount = 0.obs;
  String? fromDate;
   String? toDate;

  @override
  void onInit() {
    super.onInit();
    print("controller init called");
    fetchPrices();
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
      fromDate = formattedDate;
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
      toDate = formattedDate;
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
              TextButton(
                  onPressed: () {
                    fromDateSelect(context);
                    update();
                  },
                  child: Text(fromDate ?? 'Select From Date')),
              TextButton(
                  onPressed: () {
                    toDateSelect(context);
                    update();
                  },
                  child: Text(toDate ?? 'Select To Date'))
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                fromDate = null;
                toDate = null;
              },
              child: const Text('Clear Filters'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                fetchPrices();
                update();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void fetchPrices() async {
    try {
      GetOptions getSource = const GetOptions(source: Source.cache);
      if (await InternetConnectivity().checkConnection()) {
        getSource = const GetOptions(source: Source.server);
      }
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transaction')
          .where('user', isEqualTo: user)
          .get(getSource);
      double totalPriceIn = 0.0;
      double totalPriceOut = 0.0;
      double totalExpensesPrice = 0.0;
      double totalPromotionPrice = 0.0;
      double totalProfit = 0.0;
      // double totalDuePaymentPrice = 0.0;
      int totalStockInCount = 0;
      int totalStockOutCount = 0;
      int totalInHandCount = 0;

      for (DocumentSnapshot doc in snapshot.docs) {
        var transactionType = doc['transactionType'];
        var price = doc['price'];
        var promPrice = doc['promotion'];
        var imei = doc['imei'];

        QuerySnapshot inTransactionSnapshot = await FirebaseFirestore.instance
            .collection('transaction')
            // .where('date',
            //     isGreaterThanOrEqualTo: fromDate, isLessThanOrEqualTo: toDate)
            .where('user', isEqualTo: user)
            .where('transactionType', isEqualTo: 'In')
            .where('imei', isEqualTo: imei)
            .get(getSource);
        QuerySnapshot outTransactionSnapshot = await FirebaseFirestore.instance
            .collection('transaction')
            .where('date',
                isGreaterThanOrEqualTo: fromDate, isLessThanOrEqualTo: toDate)
            .where('user', isEqualTo: user)
            .where('transactionType', isEqualTo: 'Out')
            .where('imei', isEqualTo: imei)
            .get(getSource);

        if (price != null && price is num) {
          if (transactionType == 'In') {
            if (inTransactionSnapshot.docs.isNotEmpty &&
                outTransactionSnapshot.docs.isNotEmpty) {
              totalStockInCount++;
            } else {
              totalPriceIn += price;
              totalStockInCount++;
            }
          } else if (transactionType == 'Out') {
            totalPriceOut += price;
            totalPromotionPrice += promPrice;
            totalStockOutCount++;
          }
        }
        update();
      }

      // Calculate total expenses price

      // Get the current date
      DateTime date = DateTime.now();

      var startDate = "${date.year}-${date.month}-${1}";
      var endDate = "${date.year}-${date.month + 1}-${1}";

      QuerySnapshot expensesSnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('user', isEqualTo: user)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThan: endDate)
          .get(getSource);
      for (DocumentSnapshot doc in expensesSnapshot.docs) {
        var price = doc['price'];
        if (price != null) {
          totalExpensesPrice += double.parse(price);
        }
      }

      totalInHandCount = totalStockInCount - totalStockOutCount;

      inPrice.value = totalPriceIn.toDouble();
      outPrice.value = totalPriceOut.toDouble();
      expensesPrice.value = totalExpensesPrice.toDouble();
      stockInCount.value = totalStockInCount;
      stockOutCount.value = totalStockOutCount;
      inHandCount.value = totalInHandCount;
      promotionPrice.value = totalPromotionPrice;
      update();
      //=======================================

// Fetch 'Out' transactions
      QuerySnapshot outTransactionSnapshot = await FirebaseFirestore.instance
          .collection('transaction')
          .where('date',
              isGreaterThanOrEqualTo: fromDate, isLessThanOrEqualTo: toDate)
          .where('user', isEqualTo: user)
          .where('transactionType', isEqualTo: 'Out')
          .get(getSource);

      double totalPriceInProfit = 0.0;
      double totalPriceOutProfit = 0.0;
      double totalduePrice = 0.0;

// Process 'Out' transactions
      for (DocumentSnapshot outTransactionDoc in outTransactionSnapshot.docs) {
        var price = outTransactionDoc['price'];
        var imei = outTransactionDoc['imei'];

        // Check if the price is valid and add it to totalPriceOut
        if (price != null && price is num) {
          outTransactionDoc['cashOrCredit'] == 'cash'
              ? totalPriceOutProfit += price
              : 0.0;

          // Fetch the corresponding 'In' transaction document
          QuerySnapshot inTransactionSnapshot = await FirebaseFirestore.instance
              .collection('transaction')
              .where('user', isEqualTo: user)
              .where('transactionType', isEqualTo: 'In')
              .where('imei', isEqualTo: imei)
              .get(getSource);
          QuerySnapshot duePaymentSnapshot = await FirebaseFirestore.instance
              .collection('due_payment')
              // .where('date',
              //     isGreaterThanOrEqualTo: fromDate, isLessThanOrEqualTo: toDate)
              .where('user', isEqualTo: user)
              .where('imei', isEqualTo: imei)
              .get(getSource);

          if (duePaymentSnapshot.docs.isNotEmpty) {
            var price = duePaymentSnapshot.docs.first['price'];
            var priceRem = duePaymentSnapshot.docs.first['priceRem'];

            var duePrice = price - priceRem;
            if (price != null && price is num) {
              // Calculate profit only if price and priceDone are equal

              totalduePrice +=
                  priceRem; // Assuming price paid is stored in priceDone
            }
          }

          // If there is a corresponding 'In' transaction document, fetch its price and add it to totalPriceIn
          if (inTransactionSnapshot.docs.isNotEmpty) {
            var inTransactionPrice = inTransactionSnapshot.docs.first['price'];
            if (inTransactionPrice != null && inTransactionPrice is num) {
              totalPriceInProfit += inTransactionPrice;
            }
          }
        }
        update();
      }
      stockInPriceProfit.value = totalPriceInProfit.toDouble();
      stockOutPriceProfit.value =
          totalPriceOutProfit.toDouble() + totalduePrice.toDouble();
      totalProfit =
          stockOutPriceProfit.toDouble() - totalPriceInProfit.toDouble();
      profit.value = totalProfit.toDouble();
      update();

// Now you have totalPriceIn and totalPriceOut containing the cumulative prices of 'In' and 'Out' transactions with the same IMEI.

      //==============================
    } on FirebaseException catch (e) {
      // Check if the error is due to network unavailability
      if (e.code == 'unavailable') {
        print(
            'Error: Firestore is unreachable. Please check your internet connection.');
      } else {
        print('Firebase Error: ${e.message}');
      }
    } catch (e) {
      print('Error fetching prices: $e');
    }
  }

  void editStockIn(DocumentSnapshot document, BuildContext context) {
    var amount = (double.parse(document['discount'].toString()) /
            double.parse(document['price'].toString())) *
        100;

    TextEditingController imeiController =
        TextEditingController(text: document['imei']);
    TextEditingController modelController =
        TextEditingController(text: document['model']);
    TextEditingController priceController =
        TextEditingController(text: document['price'].toString());
    TextEditingController discountController =
        TextEditingController(text: amount.toString());

    DateTime dae = DateTime.now();

    Future<void> selectDate(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        dae = pickedDate;
      } else {
        dae = document['date'];
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Item Details'),
          backgroundColor: Colors.white, // Set a consistent background color
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => selectDate(context),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(dae),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 15), // Add spacing between elements
                ...[
                  _buildTextField(imeiController, 'IMEI'),
                  _buildTextField(modelController, 'Model'),
                  _buildTextField(priceController, 'Price'),
                  _buildTextField(discountController, 'Discount'),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                //  final date =  _selectedDate ?? DateTime.now();

                double parsedPrice = double.parse(priceController.text);
                var formattedDate = "${dae.year}-${dae.month}-${dae.day}";
                double price = double.parse(priceController.text);
                double discount = double.parse(discountController.text);
                double discAmount = (price / 100) * discount;
                // date = formattedDate;
                try {
                  FirebaseFirestore.instance
                      .collection('transaction')
                      .doc(document.id)
                      .update({
                    'imei': imeiController.text,
                    'model': modelController.text,
                    'price': parsedPrice,
                    'discount': discAmount.toString(),
                    'date': formattedDate,
                  });
                  print('disc $discAmount');
                  // Close the dialog
                  Get.offAll(() => const HomeScreen());

                  // Display a success message or snackbar
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
                  // Show an error message to the user
                  Get.snackbar('Error updating transaction', e.toString());
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                try {
                  double parsedPrice = double.parse(priceController.text);
                  double parsedDisc =
                      double.parse(document['discount'].toString());

                  TransactionModel transactionModel = TransactionModel(
                      user: user,
                      transactionType: 'In',
                      date: document['date'],
                      model: modelController.text,
                      company: document['company'],
                      imei: imeiController.text,
                      price: parsedPrice,
                      discount: parsedDisc,
                      time: document['time'].toDate());
                  FirebaseFirestore.instance
                      .collection('backup')
                      .doc()
                      .set(transactionModel.toMap());
                  FirebaseFirestore.instance
                      .collection('transaction')
                      .doc(document.id)
                      .delete();

                  // Close the dialog
                  Get.offAll(() => const HomeScreen());

                  // Display a success message or snackbar
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
                  // Show an error message to the user
                  Get.snackbar('Error deleting transaction', e.toString());
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                update();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void editStockOut(DocumentSnapshot document, BuildContext context) {
    TextEditingController imeiController =
        TextEditingController(text: document['imei']);
    TextEditingController modelController =
        TextEditingController(text: document['model']);
    TextEditingController priceController =
        TextEditingController(text: document['price'].toString());
    // TextEditingController vendorNameController =
    //     TextEditingController(text: document['vendorName']);
    TextEditingController promotionControlle =
        TextEditingController(text: document['promotion'].toString());

    DateTime dae = DateTime.now();

    Future<void> selectDate(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      // ignore: unrelated_type_equality_checks
      if (pickedDate != null) {
        dae = pickedDate;
      } else {
        dae = document['date'];
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Item Details'),
          backgroundColor:
              Colors.white, // Add a background color for the dialog
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => selectDate(context),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(dae),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 15), // Add spacing between elements
                ...[
                  _buildTextField(imeiController, 'IMEI'),
                  _buildTextField(modelController, 'Model'),
                  _buildTextField(promotionControlle, 'Promotion'),
                  _buildTextField(priceController, 'Price'),
                  // Visibility(
                  //   visible: document['cashOrCredit'] == 'credit',
                  //   child: _buildTextField(vendorNameController, 'Vendor Name'),
                  // ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                //  final date =  _selectedDate ?? DateTime.now();

                double parsedPrice = double.parse(priceController.text);
                double parsedPromo = double.parse(promotionControlle.text);
                var formattedDate = "${dae.year}-${dae.month}-${dae.day}";
                GetOptions getSource = const GetOptions(source: Source.cache);
                if (await InternetConnectivity().checkConnection()) {
                  getSource = const GetOptions(source: Source.server);
                }

                try {
                  FirebaseFirestore.instance
                      .collection('transaction')
                      .doc(document.id)
                      .update({
                    'cashOrCredit': document['cashOrCredit'],
                    'imei': imeiController.text,
                    'model': modelController.text,
                    'price': parsedPrice,
                    // 'vendorName': vendorNameController.text,
                    'promotion': parsedPromo,
                    'date': formattedDate,
                  });

                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('due_payment')
                      .where('user', isEqualTo: user)
                      .where('imei', isEqualTo: imeiController.text)
                      .get(getSource);

                  if (querySnapshot.docs.isNotEmpty) {
                    querySnapshot.docs.first.reference.update({
                      'date': formattedDate,
                    });
                  }

                  // Close the dialog
                  Get.offAll(() => const HomeScreen());

                  // Display a success message or snackbar
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
                  // Show an error message to the user
                  Get.snackbar('Error updating transaction', e.toString());
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  GetOptions getSource = const GetOptions(source: Source.cache);
                  if (await InternetConnectivity().checkConnection()) {
                    getSource = const GetOptions(source: Source.server);
                  }
                  double parsedPrice =
                      double.parse(priceController.text.toString());
                  double parsedPromo =
                      double.parse(promotionControlle.text.toString());

                  TransactionModel transactionModel = TransactionModel(
                      user: user,
                      transactionType: 'Out',
                      date: document['date'],
                      model: modelController.text,
                      company: document['company'],
                      imei: imeiController.text,
                      price: parsedPrice,
                      promotion: parsedPromo,
                      cashOrCredit: document['cashOrCredit'],
                      trading: document['trading'],
                      vendorName: document['vendorName'],
                      time: document['time'].toDate());
                  FirebaseFirestore.instance
                      .collection('backup')
                      .doc()
                      .set(transactionModel.toMap());
                  FirebaseFirestore.instance
                      .collection('transaction')
                      .doc(document.id)
                      .delete();
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('due_payment')
                      .where('user', isEqualTo: user)
                      .where('imei', isEqualTo: imeiController.text)
                      .get(getSource);

                 if(querySnapshot.docs.isNotEmpty){
                   DuePayment duePayment = DuePayment(
                      imei: querySnapshot.docs.first['imei'],
                      vendorName: querySnapshot.docs.first['vendorName'],
                      price: querySnapshot.docs.first['price'],
                      priceRem: querySnapshot.docs.first['priceRem'],
                      pricePaid: querySnapshot.docs.first['pricePaid'],
                      user: user,
                      paid: querySnapshot.docs.first['paid'],
                      date: querySnapshot.docs.first['date'],
                      time: querySnapshot.docs.first['time'].toDate());

                  FirebaseFirestore.instance
                      .collection('backupDuePaym')
                      .doc()
                      .set(duePayment.toMap());

                  querySnapshot.docs.first.reference.delete();
                 }

                  // Iterate over the documents in the QuerySnapshot and delete each one
                  // for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                  //   documentSnapshot.reference.delete();
                  // }
                  // Close the dialog
                  Get.offAll(() => const HomeScreen());
                  // Display a success message or snackbar
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
                  // Show an error message to the user
                  Get.snackbar('Error deleting transaction', e.toString());
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                update();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Padding _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: const Border(
              top: BorderSide(
                width: 1,
                color: Colors.blue,
              ),
              bottom: BorderSide(
                width: 1,
                color: Colors.blue,
              ),
              left: BorderSide(
                width: 1,
                color: Colors.blue,
              ),
              right: BorderSide(
                width: 1,
                color: Colors.blue,
              )),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Ex. $label',
              labelText: label,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
