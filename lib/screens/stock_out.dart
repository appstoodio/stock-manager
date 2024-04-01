import 'package:Rashdi_Mobile/controller/stock_out_controller.dart';
import 'package:Rashdi_Mobile/helper/connectivity.dart';
import 'package:Rashdi_Mobile/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'home_screen.dart';

class StockOut extends StatefulWidget {
  const StockOut({super.key});

  @override
  State<StockOut> createState() => _StockOutState();
}

class _StockOutState extends State<StockOut> {
  final StockOutController stockOutController = Get.put(StockOutController());
  // List<String?> selectedProducts = Get.arguments as List<String?>;
  String? selectedValue;
  String dropdownvalue = 'cash';
  var cashOrCredit = ['cash', 'credit'];
  // String dropdownDefaultValue = 'cash'; // Set 'cash' as the default value

  bool isSwitched = false;
  bool promotionOn = false;
  var textValue = 'No';
  String imei = Get.arguments;


  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    stockOutController.imeiController.text = imei;
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Yes';
      });
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'No';
      });
    }
  }

  void toggleSwitchPromotion(bool value) {
    if (promotionOn == false) {
      setState(() {
        promotionOn = true;
        textValue = 'Yes';
      });
    } else {
      setState(() {
        promotionOn = false;
        textValue = 'No';
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    // final CollectionReference compDoc =
    //     FirebaseFirestore.instance.collection('company');
    // List<String?>? selectedProducts =
    //     Get.arguments != null && Get.arguments is List<String?>
    //         ? Get.arguments as List<String?>
    //         : [];

//     // Access data
//     List<String> selectedItems = arguments?['selectedItems'] ?? [];
//     String model = arguments?['model'] ?? '';
//     String company = arguments?['company'] ?? '';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                  onPressed: () => Get.off(const HomeScreen()),
                  icon: const Icon(Icons.arrow_back_ios)),
              const Text('Stock Out')
            ],
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Container(
                  height: height * 0.05,
                  width: width * 0.37,
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
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      DateFormat('dd-MM-yyyy')
                          .format(_selectedDate ?? DateTime.now()),
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 70,
                      width: width * 0.70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
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
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          controller: stockOutController.imeiController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: 'Ex. 78764899422',
                              labelText: 'imei',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => const SearchScreen()),
                      child: const Icon(Icons.search),
                    ),
                    GestureDetector(
                      onTap: () => stockOutController.scan(),
                      child: const Icon(Icons.scanner),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.only(right: 15, left: 15),
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
                      borderRadius: BorderRadius.circular(12)),
                  child: DropdownButton(
                    underline: const SizedBox(),
                    isExpanded: true,
                    hint: Text(
                      dropdownvalue,
                      style: const TextStyle(fontSize: 20),
                    ),
                    value: dropdownvalue,
                    items: cashOrCredit.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              Padding(
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
                      borderRadius: BorderRadius.circular(12)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      controller: stockOutController.priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: 'Ex. 90Rs',
                          labelText: 'Total Price',
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: dropdownvalue == 'credit',
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 70,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
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
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        controller: stockOutController.vendorNameController,
                        decoration: const InputDecoration(
                            hintText: 'Vendor Name',
                            labelText: 'Vendor',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
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
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('Trading'),
                        SizedBox(
                          width: width * 0.6,
                        ),
                        Switch(
                          onChanged: toggleSwitch,
                          value: isSwitched,
                          activeColor: const Color.fromARGB(255, 147, 238, 150),
                          activeTrackColor: Colors.white,
                          inactiveThumbColor: Colors.redAccent,
                          inactiveTrackColor: Colors.white,
                        ),
                        // Text(
                        //   '$textValue',
                        //   style: TextStyle(fontSize: 20),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
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
                      borderRadius: BorderRadius.circular(12)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      controller: stockOutController.promotionControlle,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: 'Ex. 90Rs',
                          labelText: 'Promotion',
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 176, 245, 155), // Set the background color to amber
                  borderRadius:
                      BorderRadius.circular(10), // Optional: Add border radius
                ),
                child: TextButton(
                  onPressed: () async {
                    // final date = _selectedDate ?? DateTime.now();
                    final tradingData = isSwitched;
                    String? modell;
                    String? compp;
                    String? user = FirebaseAuth.instance.currentUser?.uid;

                    try {
                      GetOptions getSource =
                          const GetOptions(source: Source.cache);
                      if (await InternetConnectivity().checkConnection()) {
                        getSource = const GetOptions(source: Source.server);
                      }
                      // Reference to the Firestore collection
                      CollectionReference transactionCollection =
                          FirebaseFirestore.instance.collection('transaction');

                      // DocumentSnapshot documentSnapshot =
                      //     await transactionCollection.doc().get();

                      // Fetch the document based on the imei field
                      QuerySnapshot<Object?> querySnapshot =
                          await transactionCollection
                              .where('transactionType', isEqualTo: 'In')
                              .where('imei',
                                  isEqualTo:
                                      stockOutController.imeiController.text)
                              .where('user', isEqualTo: user)
                              .limit(1)
                              .get(getSource);

                      if (querySnapshot.docs.isNotEmpty) {
                        // Document(s) exist, retrieve model and company from the first document
                        String model = querySnapshot.docs[0]['model'] as String;
                        String company =
                            querySnapshot.docs[0]['company'] as String;

                        setState(() {
                          modell = model;
                          compp = company;
                        });
                      } else {
                        // No document found, show an error message
                        Get.snackbar('Error', 'StockIn for that not found');
                      }

                      // getting price form IN documnet

                      // Check if any documents match the query

                      DateTime dateTime = _selectedDate ?? DateTime.now();
                      String formatedDate =
                          DateFormat('yyyy-MM-dd').format(dateTime);
                      DateTime date = DateTime.parse(formatedDate);
                      String formattedDate =
                          "${date.year}-${date.month}-${date.day}";

                      if (dropdownvalue == 'credit' &&
                          stockOutController
                              .vendorNameController.text.isNotEmpty) {
                        stockOutController.uplaodDuePayment(
                            formattedDate,
                            int.parse(
                                stockOutController.imeiController.text.trim()),
                            double.parse(
                                stockOutController.priceController.text),
                            stockOutController.vendorNameController.text,
                            querySnapshot.docs[0]['price']);
                        stockOutController.uploadStock(
                            modelName: modell!,
                            compName: compp!,
                            imei: int.parse(
                                stockOutController.imeiController.text.trim()),
                            trading: tradingData,
                            cashOrCredit: dropdownvalue,
                            date: formattedDate,
                            promotion: stockOutController
                                    .promotionControlle.text.isEmpty
                                ? 0.0
                                : double.parse(
                                    stockOutController.promotionControlle.text),
                            vendorName:
                                stockOutController.vendorNameController.text,
                            price: dropdownvalue == 'credit'
                                ? 0.0
                                : double.tryParse(stockOutController
                                        .priceController.text) ??
                                    0.0);
                      } else if (dropdownvalue == 'credit' &&
                          stockOutController
                              .vendorNameController.text.isEmpty) {
                        Get.snackbar('Error', 'Fill all fields');
                      }else{
stockOutController.uploadStock(
                          modelName: modell!,
                          compName: compp!,
                          imei: int.parse(
                              stockOutController.imeiController.text.trim()),
                          trading: tradingData,
                          cashOrCredit: dropdownvalue,
                          date: formattedDate,
                          promotion: stockOutController
                                  .promotionControlle.text.isEmpty
                              ? 0.0
                              : double.parse(
                                  stockOutController.promotionControlle.text),
                          vendorName:
                              stockOutController.vendorNameController.text,
                          price: dropdownvalue == 'credit'
                              ? 0.0
                              : double.tryParse(stockOutController
                                      .priceController.text) ??
                                  0.0);
                      }
                      

                      stockOutController.imeiController.clear();
                      stockOutController.priceController.clear();
                      stockOutController.vendorPriceController.clear();
                      stockOutController.vendorNameController.clear();
                      stockOutController.promotionControlle.clear();
                    } on FirebaseException catch (e) {
                      // Check if the error is due to network unavailability
                      if (e.code == 'unavailable') {
                        print(
                            'Error: Firestore is unreachable. Please check your internet connection.');
                      } else {
                        print('Firebase Error: ${e.message}');
                      }
                    } catch (e) {
                      Get.snackbar(
                          'Error', 'Failed to fetch data from Firestore: $e');
                      print(e);
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
