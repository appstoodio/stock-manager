// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      // Query the collection to get the documents to delete
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('due_payment')
          .where('user', isEqualTo: user)
          .where('imei', isEqualTo: documentId)
          .get();

      // Iterate over the documents in the QuerySnapshot and delete each one
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }

      // Delete transaction with same imei
      final transaction = await FirebaseFirestore.instance
          .collection('transaction')
          .where('user', isEqualTo: user)
          .where('imei', isEqualTo: documentId)
          .where('transactionType', isEqualTo: 'Out')
          .get();

      for (final transactionDoc in transaction.docs) {
        await transactionDoc.reference.delete();
      }
      // Get.snackbar('Success', 'Successfuly delted.');
      Get.offAll(const HomeScreen());
    } catch (e) {
      Get.snackbar('Error', 'Error deleting document: $e');
      // Handle errors if needed
    }
  }

  void editPayment(String price, String imei, BuildContext context, double pricePaiddd, DocumentSnapshot doc) {
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
                    double pricePaid = double.parse(priceController.text);
                    // double updatedPrice = initialPrice - newPrice;
                    // double updatedDuePrice = initialPrice - updatedPrice;

                    // Update transaction
                    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                        .collection('transaction')
                        .where('imei', isEqualTo: imei)
                        .where('transactionType', isEqualTo: 'Out')
                        .get();

                    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                     
                      await documentSnapshot.reference.update({
                        'price': FieldValue.increment(pricePaid),
                      });
                    }

                    // Update Due payment
                    QuerySnapshot duePaymentRef = await FirebaseFirestore
                        .instance
                        .collection('due_payment')
                        .where('user', isEqualTo: user)
                        .where('imei', isEqualTo: imei)
                        .get();

                    if (duePaymentRef.docs.isNotEmpty) {
                      for (QueryDocumentSnapshot documentSnapshot
                          in duePaymentRef.docs) {
                        //  double currentDuePrice = documentSnapshot['price'].toDouble();
                        // double updatedDuePrice = currentDuePrice - initialPrice;
                        await documentSnapshot.reference.update({
                          'pricePaid': FieldValue.increment(pricePaid),
                         
                        });
                      }
                    }

                    Get.offAll(const HomeScreen());
                  } catch (e) {
                    Get.snackbar('Error', 'Error updating payment: $e');
                  }
                },
                child: const Text('Update'),
              ),
               TextButton(
                onPressed: () async {
                  try {
                    double pricePaid = double.parse(priceController.text);
                    // double updatedPrice = initialPrice - newPrice;
                    // double updatedDuePrice = initialPrice - updatedPrice;

                    // Update transaction
                    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                        .collection('transaction')
                        .where('imei', isEqualTo: imei)
                        .where('transactionType', isEqualTo: 'Out')
                        .get();

                    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                    
                      await documentSnapshot.reference.update({
                        'price': FieldValue.increment( double.parse(price) - pricePaiddd),
                      });
                    }

                    // Update Due payment
                    QuerySnapshot duePaymentRef = await FirebaseFirestore
                        .instance
                        .collection('due_payment')
                        .where('user', isEqualTo: user)
                        .where('imei', isEqualTo: imei)
                        .get();

                    if (duePaymentRef.docs.isNotEmpty) {
                      for (QueryDocumentSnapshot documentSnapshot
                          in duePaymentRef.docs) {
                        //  double currentDuePrice = documentSnapshot['price'].toDouble();
                        // double updatedDuePrice = currentDuePrice - initialPrice;
                         await documentSnapshot.reference.update({
                          'priceDone':FieldValue.increment(pricePaiddd),
                         
                        });
                        await documentSnapshot.reference.update({
                          'priceDone':FieldValue.increment( double.parse(price) - pricePaiddd) ,
                          'paid' : true
                         
                        });
                      }
                    }

                 

                    Get.offAll(const HomeScreen());
                  } catch (e) {
                    Get.snackbar('Error', 'Error updating payment: $e');
                  }
                },
                child: const Text('Paid'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
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
          title: const Text('Due payment'),
          backgroundColor: Colors.amber,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('due_payment')
              .where('user', isEqualTo: user)
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
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
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
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                    editPayment(
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
