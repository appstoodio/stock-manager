import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:Rashdi_Mobile/model/controller/stock_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/stock_in_controller.dart';

class StockIn extends StatefulWidget {
  const StockIn({super.key});

  @override
  State<StockIn> createState() => _StockInState();
}

class _StockInState extends State<StockIn> {
  final StockInController stockInController = Get.put(StockInController());
  String imei = Get.arguments;
  final user = FirebaseAuth.instance.currentUser!.uid;
  // List<String?>? selectedProducts =
  //     Get.arguments != null && Get.arguments is List<String?>
  //         ? Get.arguments as List<String?>
  //         : [];
  String? selectedValue;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    stockInController.imeiController.text = imei;
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
    final CollectionReference compDoc =
        FirebaseFirestore.instance.collection('company');
    final width = Get.width;
    final height = Get.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                  onPressed: () => Get.off(const HomeScreen()),
                  icon: const Icon(Icons.arrow_back_ios)),
              const Text('Stock In')
            ],
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Container(
                      height: height *0.05,
                      width: width *0.37,
                      decoration: BoxDecoration(
                      color: Colors.amber.shade100,
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
                  const SizedBox(width: 8),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        // Use Expanded to ensure the TextFormField takes up the available space
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              controller: stockInController.imeiController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: 'Ex. 986479956533',
                                  labelText: 'IMEI',
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          stockInController.scan();
                        },
                        icon: const Icon(Icons.scanner),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: compDoc.where('user', isEqualTo: user).snapshots(),
                builder: (context, snapshot) {
                  // String? selectedValue;
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Some error occurred ${snapshot.error}"),
                    );
                  }
                  List<DropdownMenuItem> compItems = [];
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    final selectComp = snapshot.data?.docs.toList();

                    if (selectComp != null) {
                      for (var comp in selectComp) {
                        String companyName = comp['name'] +
                            '_' +
                            comp.id; // Unique value combining name and ID
                        compItems.add(
                          DropdownMenuItem(
                              value: companyName,
                              child: Row(
                                children: [
                                  Text(
                                    comp['name'],
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  IconButton(
                                      onPressed: () =>
                                          stockInController.deleteCompany(
                                              comp.id.toString(), context),
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 20,
                                      ))
                                ],
                              )),
                        );
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 70,
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              DropdownButton(
                                underline: const SizedBox(),
                                isExpanded: false,
                                hint: const Text(
                                  "Select items",
                                  style: TextStyle(fontSize: 20),
                                ),
                                value: selectedValue,
                                items: compItems,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                              ),
                              SizedBox(
                                width: width * 0.27,
                              ),
                              TextButton(
                                  onPressed: () {
                                    stockInController.showCustomDialog(context);
                                  },
                                  child: const Text('Add new'))
                            ],
                          )),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        controller: stockInController.modelController,
                        decoration: const InputDecoration(
                            hintText: 'Ex. A9287',
                            labelText: 'Model',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  height: 70,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        controller: stockInController.priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'Ex. 90Rs',
                            labelText: 'Price',
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
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        controller: stockInController.discController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: '%',
                            labelText: 'Discount',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                 decoration: BoxDecoration(
    color: Color.fromARGB(255, 176, 245, 155), // Set the background color to amber
    borderRadius: BorderRadius.circular(10), // Optional: Add border radius
  ),
  
                child: TextButton(
                  
                    onPressed: () {
                      final imeiii = int.parse(stockInController.imeiController.text);
                      DateTime dateTime = _selectedDate ?? DateTime.now();
                      String formatedDate =
                          DateFormat('yyyy-MM-dd').format(dateTime);
                      DateTime date = DateTime.parse(formatedDate);
                      var formattedDate =
                          "${date.year}-${date.month}-${date.day}";
                
                      stockInController.uploadStock(
                          selectedValue.toString(), formattedDate, imeiii);
                      stockInController.imeiController.clear();
                      stockInController.modelController.clear();
                      stockInController.priceController.clear();
                      stockInController.discController.clear();
                    },
                    child: const Text('Save')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
