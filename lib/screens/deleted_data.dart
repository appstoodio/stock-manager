import 'package:Rashdi_Mobile/model/due_payment.dart';
import 'package:Rashdi_Mobile/model/transacation.dart';
import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/connectivity.dart';

class DeletedData extends StatefulWidget {
  const DeletedData({super.key});

  @override
  State<DeletedData> createState() => _DeletedDataState();
}

class _DeletedDataState extends State<DeletedData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Get.offAll(() => const HomeScreen());
                },
                icon: const Icon(Icons.arrow_back_ios)),
            const Text('Deleted Items'),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('backup')
            .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> docss = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docss.length,
            itemBuilder: (context, index) {
              final width = Get.width;
              final height = Get.height;
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                    width: double.maxFinite,
                    height: height * 0.18,
                    decoration: BoxDecoration(
                      color: docss[index]['transactionType'] == 'In'
                          ? Colors.green
                          : Colors.red,
                    ),
                    child: Center(
                        child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              '${docss[index]['model']}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  'price: ${docss[index]['price']}',
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(docss[index]['transactionType'] == 'In'
                                    ? 'disc:  ${docss[index]['discount']}'
                                    : '${docss[index]['cashOrCredit']}'),
                              ],
                            ),
                            trailing: Text(
                              docss[index]["date"].toString(),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    final user =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    GetOptions getSource =
                                        const GetOptions(source: Source.cache);
                                    if (await InternetConnectivity()
                                        .checkConnection()) {
                                      getSource = const GetOptions(
                                          source: Source.server);
                                    }
                                    TransactionModel transactionModel = TransactionModel(
                                        user: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        transactionType:
                                            docss[index]['transactionType'] == 'In'
                                                ? 'In'
                                                : 'Out',
                                        date: docss[index]['date'],
                                        model: docss[index]['model'],
                                        company: docss[index]['company'],
                                        imei: docss[index]['imei'],
                                        price: double.parse(
                                            docss[index]['price'].toString()),
                                        discount:
                                            docss[index]['discount'] != null
                                                ? double.parse(docss[index]
                                                        ['discount']
                                                    .toString())
                                                : 0.0,
                                        promotion: docss[index]['promotion'] !=
                                                null
                                            ? double.parse(
                                                docss[index]['promotion'].toString())
                                            : 0.0,
                                        vendorName: docss[index]['vendorName'] != null ? docss[index]['vendorName'] : '',
                                        cashOrCredit: docss[index]['cashOrCredit'] != null ? docss[index]['cashOrCredit'] : '',
                                        trading: docss[index]['trading'].toString() != null ? docss[index]['trading'] : '',
                                        time: docss[index]['time'].toDate());
                                    FirebaseFirestore.instance
                                        .collection('transaction')
                                        .doc()
                                        .set(transactionModel.toMap());
                                    QuerySnapshot duePaym =
                                        await FirebaseFirestore.instance
                                            .collection('backupDuePaym')
                                            .where('user', isEqualTo: user)
                                            .where('imei',
                                                isEqualTo: docss[index]['imei'])
                                            .get(getSource);
                                    if (duePaym.docs.isNotEmpty) {
                                      DuePayment duePayment = DuePayment(
                                          imei: duePaym.docs.first['imei'],
                                          vendorName:
                                              duePaym.docs.first['vendorName'],
                                          price: duePaym.docs.first['price'],
                                          priceRem:
                                              duePaym.docs.first['priceRem'],
                                          pricePaid:
                                              duePaym.docs.first['pricePaid'],
                                          user: user,
                                          paid: duePaym.docs.first['paid'],
                                          date: duePaym.docs.first['date'],
                                          time: duePaym.docs.first['time']
                                              .toDate());

                                      FirebaseFirestore.instance
                                          .collection('due_payment')
                                          .doc()
                                          .set(duePayment.toMap());
                                      duePaym.docs.first.reference.delete();    
                                    }

                                    FirebaseFirestore.instance
                                        .collection('backup')
                                        .doc(docss[index].id)
                                        .delete();

                                    Get.offAll(() => const HomeScreen());
                                  },
                                  child: const Text('Restore')),
                              ElevatedButton(
                                  onPressed: () async {
                                    final user =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    FirebaseFirestore.instance
                                        .collection('backup')
                                        .doc(docss[index].id)
                                        .delete();

                                    QuerySnapshot trans =
                                        await FirebaseFirestore.instance
                                            .collection('backupDuePaym')
                                            .where('user', isEqualTo: user)
                                            .where('imei',
                                                isEqualTo: docss[index]['imei'])
                                            .get();
                                   if(trans.docs.isNotEmpty){
                                     trans.docs.first.reference.delete();
                                   }
                                  },
                                  child: const Text('Delete'))
                            ],
                          )
                        ],
                      ),
                    ))),
              );
            },
          );
        },
      ),
    );
  }
}
