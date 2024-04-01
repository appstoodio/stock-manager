// ignore_for_file: library_private_types_in_public_api, avoid_print
import 'package:Rashdi_Mobile/helper/connectivity.dart';
import 'package:Rashdi_Mobile/model/transacation.dart';
import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/due_payment.dart';

class DuePaymentScreen extends StatefulWidget {
  const DuePaymentScreen({Key? key}) : super(key: key);

  @override
  _DuePaymentScreenState createState() => _DuePaymentScreenState();
}

class _DuePaymentScreenState extends State<DuePaymentScreen> {
  //variables

  final user = FirebaseAuth.instance.currentUser!.uid;

  //=========================================
  // Function to delete a document by its ID
  Future<void> deleteDocument(String documentId) async {
    try {
      GetOptions getSource = const GetOptions(source: Source.cache);
      if (await InternetConnectivity().checkConnection()) {
        getSource = const GetOptions(source: Source.server);
      }
      // Query the collection to get the documents to delete
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('due_payment')
          .where('user', isEqualTo: user)
          .where('imei', isEqualTo: documentId)
          .get(getSource);

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

      // Delete transaction with same imei
      final transaction = await FirebaseFirestore.instance
          .collection('transaction')
          .where('user', isEqualTo: user)
          .where('imei', isEqualTo: documentId)
          .where('transactionType', isEqualTo: 'Out')
          .get(getSource);

     TransactionModel transactionModel = TransactionModel(
                      user: user,
                      transactionType: 'Out',
                      date:  transaction.docs.first['date'],
                      model:  transaction.docs.first['model'],
                      company:  transaction.docs.first['company'],
                      imei:  transaction.docs.first['imei'],
                      price:  transaction.docs.first['price'],
                      promotion:  transaction.docs.first ['promotion'],
                      cashOrCredit:  transaction.docs.first['cashOrCredit'],
                      trading:  transaction.docs.first['trading'],
                      vendorName:  transaction.docs.first['vendorName'],
                      time:  transaction.docs.first['time'].toDate());

    FirebaseFirestore.instance.collection('backup').doc().set(transactionModel.toMap());
        transaction.docs.first.reference.delete();
     
      // Get.snackbar('Success', 'Successfuly delted.');
      Get.back();
    } on FirebaseException catch (e) {
      // Check if the error is due to network unavailability
      if (e.code == 'unavailable') {
        print(
            'Error: Firestore is unreachable. Please check your internet connection.');
      } else {
        print('Firebase Error: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error deleting document: $e');
      // Handle errors if needed
    }
  }

  void editPayment(BuildContext context, DocumentSnapshot doc) {
    TextEditingController priceController =
        TextEditingController(text: doc['price'].toString());
    // double initialPrice = double.parse(priceController.text);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Edit Payment'),
            content: SizedBox(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter new price',
                        labelText: 'New Price',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    GetOptions getSource =
                        const GetOptions(source: Source.cache);
                    if (await InternetConnectivity().checkConnection()) {
                      getSource = const GetOptions(source: Source.server);
                    }

                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('due_payment')
                        .where('user', isEqualTo: user)
                        .where('imei', isEqualTo: doc['imei'])
                        .get(getSource);

                    for (QueryDocumentSnapshot documentSnapshot
                        in querySnapshot.docs) {
                      documentSnapshot.reference.update({
                        'price': double.parse(priceController.text),
                      });
                    }

                    Get.offAll(() => const DuePaymentScreen());
                  } on FirebaseException catch (e) {
                    // Check if the error is due to network unavailability
                    if (e.code == 'unavailable') {
                      print(
                          'Error: Firestore is unreachable. Please check your internet connection.');
                    } else {
                      // Handle other Firebase-related errors
                      print('Firebase Error: ${e.message}');
                    }
                  } catch (e) {
                    Get.snackbar('Error', 'Error updating payment: $e');
                  }
                },
                child: const Text('Update'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  void editPaymentForProfit(String price, String imei, BuildContext context,
      double pricePaiddd, DocumentSnapshot doc) {
    TextEditingController priceController = TextEditingController(text: price);
    double initialPrice = double.parse(price);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Edit Payment'),
            content: SizedBox(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter new price',
                        labelText: 'New Price',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    GetOptions getSource =
                        const GetOptions(source: Source.cache);
                    if (await InternetConnectivity().checkConnection()) {
                      getSource = const GetOptions(source: Source.server);
                    }
                    double pricePaid = double.parse(priceController.text);
                    print(pricePaid);
                    // double updatedPrice = initialPrice - newPrice;
                    // double updatedDuePrice = initialPrice - updatedPrice;

                    // Update transaction
                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('transaction')
                        .where('imei', isEqualTo: imei)
                        .where('transactionType', isEqualTo: 'Out')
                        .get(getSource);

                    for (QueryDocumentSnapshot documentSnapshot
                        in querySnapshot.docs) {
                      documentSnapshot.reference.update({
                        'price': FieldValue.increment(pricePaid),
                      });
                    }

                    // Update Due payment
                    QuerySnapshot duePaymentRef = await FirebaseFirestore
                        .instance
                        .collection('due_payment')
                        .where('user', isEqualTo: user)
                        .where('imei', isEqualTo: imei)
                        .get(getSource);

                    if (duePaymentRef.docs.isNotEmpty) {
                      for (QueryDocumentSnapshot documentSnapshot
                          in duePaymentRef.docs) {
                        //  double currentDuePrice = documentSnapshot['price'].toDouble();
                        // double updatedDuePrice = currentDuePrice - initialPrice;
                        documentSnapshot.reference.update({
                          'pricePaid': FieldValue.increment(pricePaid),
                        });
                      }
                    }

                    Get.offAll(() => const DuePaymentScreen());
                  } on FirebaseException catch (e) {
                    // Check if the error is due to network unavailability
                    if (e.code == 'unavailable') {
                      print(
                          'Error: Firestore is unreachable. Please check your internet connection.');
                    } else {
                      // Handle other Firebase-related errors
                      print('Firebase Error: ${e.message}');
                    }
                  } catch (e) {
                    Get.snackbar('Error', 'Error updating payment: $e');
                  }
                },
                child: const Text('Update'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    GetOptions getSource =
                        const GetOptions(source: Source.cache);
                    if (await InternetConnectivity().checkConnection()) {
                      getSource = const GetOptions(source: Source.server);
                    }
                    double pricePaid = double.parse(priceController.text);
                    // double updatedPrice = initialPrice - newPrice;
                    // double updatedDuePrice = initialPrice - updatedPrice;

                    // Update transaction
                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('transaction')
                        .where('imei', isEqualTo: imei)
                        .where('transactionType', isEqualTo: 'Out')
                        .get(getSource);

                    QuerySnapshot duePaymentRef = await FirebaseFirestore
                        .instance
                        .collection('due_payment')
                        .where('user', isEqualTo: user)
                        .where('imei', isEqualTo: imei)
                        .get(getSource);

                    for (QueryDocumentSnapshot documentSnapshot
                        in querySnapshot.docs) {
                      if (documentSnapshot['price'] !=
                          duePaymentRef.docs.first['price']) {
                        documentSnapshot.reference.update({
                          'price': FieldValue.increment(
                              double.parse(price) - pricePaiddd),
                        });
                      } else {
                        Get.snackbar('Error', 'Payment already added');
                      }
                    }

                    // Update Due payment

                    if (duePaymentRef.docs.isNotEmpty) {
                      for (QueryDocumentSnapshot documentSnapshot
                          in duePaymentRef.docs) {
                        //  double currentDuePrice = documentSnapshot['price'].toDouble();
                        // double updatedDuePrice = currentDuePrice - initialPrice;
                        documentSnapshot.reference.update({
                          'priceDone': FieldValue.increment(pricePaiddd),
                        });
                        documentSnapshot.reference.update({
                          'priceDone': FieldValue.increment(
                              double.parse(price) - pricePaiddd),
                          'paid': true,
                          'priceRem': double.parse(price)
                        });
                      }
                    }

                    Get.offAll(() => const DuePaymentScreen());
                  } on FirebaseException catch (e) {
                    // Check if the error is due to network unavailability
                    if (e.code == 'unavailable') {
                      print(
                          'Error: Firestore is unreachable. Please check your internet connection.');
                    } else {
                      // Handle other Firebase-related errors
                      print('Firebase Error: ${e.message}');
                    }
                  } catch (e) {
                    Get.snackbar('Error', 'Error updating payment: $e');
                  }
                },
                child: const Text('Paid'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                  onPressed: () => Get.off(const HomeScreen()),
                  icon: const Icon(Icons.arrow_back_ios)),
              const Text('Due Payment')
            ],
          ),
          backgroundColor: Colors.lightBlueAccent,
          automaticallyImplyLeading: false,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('due_payment')
              .where('user', isEqualTo: user)
              .orderBy('paid', descending: false)
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            List<DocumentSnapshot> docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: docs[index]['paid'] == true
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                docs[index]['paid'] == true
                                    ? 'Paid'
                                    : 'Not Paid',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Vendor Name: ${docs[index]['vendorName']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: width * 0.20,
                            ),
                            IconButton(
                                onPressed: () {
                                  editPayment(
                                    context,
                                    docs[index],
                                  );
                                },
                                icon: const Icon(Icons.edit)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Item: ${docs[index]['imei']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Date: ${docs[index]['date']}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Price: ${docs[index]['price']}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          docs[index]['pricePaid'] != 0.0
                                              ? 'Remaining: ${docs[index]['price'] - docs[index]['pricePaid']}'
                                              : 'Remaining: 0.0',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                editPaymentForProfit(
                                  docs[index]['price'].toString(),
                                  docs[index]['imei'],
                                  context,
                                  docs[index]['pricePaid'],
                                  docs[index],
                                );
                              },
                              icon: const Icon(Icons.edit),
                              color: Colors.green,
                            ),
                            IconButton(
                              onPressed: () {
                                deleteDocument(docs[index]['imei']);
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}
