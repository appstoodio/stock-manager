import 'package:Rashdi_Mobile/screens/stock_out.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String search = '';
  final user = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CupertinoSearchTextField(
        controller: _searchController,
        keyboardType: TextInputType.number,
        onChanged: (String? value) {
         setState(() {
            search = value.toString();
         });
        },
      )),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('transaction')
            .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('transactionType', isEqualTo: 'In')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // double totalPriceIn = 0.0;
          // double totalPriceOut = 0.0;
          // double price = getPrice

          if (snapshot.hasError) {
            return const Center(child:  Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> docss = snapshot.data!.docs;

          return ListView.builder(
  itemCount: docss.length,
  itemBuilder: (context, index) {
    final imei = docss[index]['imei'].toString();
    if (_searchController.text.isEmpty) {
      return Container();
    } else if (imei.toLowerCase().contains(_searchController.text.toLowerCase())) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          title: Text(
            imei,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        onTap: () {
          Get.off(const StockOut(), arguments: imei);
        },
        ),
      );
    }
    return Container(); // Return an empty container if no match is found
  },
);

        },
      ),
    );
  }

 
}
