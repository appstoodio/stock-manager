import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DuePaymentController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final String user;

  @override
  void onInit() {
    super.onInit();
    user = _auth.currentUser!.uid;
  }

  // Future<void> deleteDocument(String documentId) async {
  //   try {
  //     // Query the collection to get the documents to delete
  //     QuerySnapshot querySnapshot = await _firestore
  //         .collection('due_payment')
  //         .where('user', isEqualTo: user)
  //         .where('imei', isEqualTo: documentId)
  //         .get();

  //     // Iterate over the documents in the QuerySnapshot and delete each one
  //     for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
  //        documentSnapshot.reference.delete();
  //     }

  //     // Delete transaction with same imei
  //     final transaction = await _firestore
  //         .collection('transaction')
  //         .where('user', isEqualTo: user)
  //         .where('imei', isEqualTo: documentId)
  //         .where('transactionType', isEqualTo: 'Out')
  //         .get();

  //     for (final transactionDoc in transaction.docs) {
  //        transactionDoc.reference.delete();
  //     }

  //     // Get.snackbar('Success', 'Successfully deleted.');
  //     Get.offAll(() =>const HomeScreen());
  //   } catch (e) {
  //     Get.snackbar('Error', 'Error deleting document: $e');
  //     // Handle errors if needed
  //   }
  // }

  // void editPayment(String price, String imei, BuildContext context) {
  //   TextEditingController priceController = TextEditingController();
  

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SingleChildScrollView(
  //         child: AlertDialog(
  //           title: const Text('Item Details'),
  //           content: SizedBox(
  //             height: 400,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Container(
  //                     height: 70,
  //                     width: double.maxFinite,
  //                     color: const Color.fromARGB(153, 142, 255, 146),
  //                     child: Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: TextFormField(
  //                         controller: priceController,
  //                         keyboardType: TextInputType.number,
  //                         decoration: const InputDecoration(
  //                           hintText: 'Ex. 400',
  //                           labelText: 'Price',
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () async {
  //                 try {
  //                   // double pricee = 0.0;
  //                   // Query the Due payment collection
  //                   QuerySnapshot querySnapshot = await _firestore
  //                       .collection('due_payment')
  //                       .where('user', isEqualTo: user)
  //                       .where('imei', isEqualTo: imei)
  //                       .get();

  //                   for (QueryDocumentSnapshot documentSnapshot
  //                       in querySnapshot.docs) {
  //                     // double remainPrice = double.parse(price) - double.parse(priceController.text);                     
                      
               
  //                     // totalPrice += documentSnapshot['price'] as double;
  //                     // Update the price to zero before updating the transaction
  //                     await documentSnapshot.reference.update({
                       
  //                       'pricePaid' : FieldValue.increment(double.parse(priceController.text))
  //                     });
  //                   }
  //                   Navigator.of(context).pop();

  //                   // Get the transaction document with matching IMEI
  //                   // final transactionDoc = await _firestore
  //                   //     .collection('transaction')
  //                   //     .where('user', isEqualTo: user)
  //                   //     .where('imei', isEqualTo: imei)
  //                   //     .where('transactionType', isEqualTo: 'Out')
  //                   //     .get()
  //                   //     .then((snapshot) => snapshot.docs.first);

  //                   // if (transactionDoc.exists) {
  //                   //   // Update the transaction document
  //                   //   await transactionDoc.reference.update({
  //                   //     'price': FieldValue.increment(
  //                   //         double.parse(pricee.toString())),
  //                   //   });
  //                   //   Get.offAll(() =>const HomeScreen());
  //                   // } else {
  //                   //   Get.snackbar('error',
  //                   //       'No matching transaction document found.');
  //                   // }
  //                 } catch (e) {
  //                   Get.snackbar('error', 'Error updating document: $e');
  //                 }
  //               },
  //               child: const Text('Update'),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Get.back();
  //               },
  //               child: const Text('Cancel'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
