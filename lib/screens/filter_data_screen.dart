import 'package:Rashdi_Mobile/controller/filtering_controller.dart';
import 'package:Rashdi_Mobile/controller/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FilteringScreen extends StatefulWidget {
  const FilteringScreen({super.key});

  @override
  _FilteringScreenState createState() => _FilteringScreenState();
}

class _FilteringScreenState extends State<FilteringScreen> {
  final FilteringController filteringController =
      Get.put(FilteringController());
  final HomeController homeController = Get.put(HomeController());
  final user = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _compController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  String compSearch = '';
  String modelSearch= '';
  int inCount = 0;
  int outCount = 0;
  double promPrice = 0.0;
  final height = Get.height;
  final width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.1,
        title: Column(
          children: [
            SizedBox(
              height: height * 0.01,
            ),
            CupertinoSearchTextField(
              backgroundColor: Colors.white,
              placeholder: 'Company',
              controller: _compController,
              onChanged: (String? value) {
                setState(() {
                  compSearch = value.toString();
                });
              },
            ),
            SizedBox(
              height: height * 0.01,
            ),
            CupertinoSearchTextField(
              controller: _modelController,
              placeholder: 'Model',
              backgroundColor: Colors.white,
              onChanged: (String? value) {
                setState(() {
                  modelSearch = value.toString();
                });
              },
            ),
            SizedBox(
              height: height * 0.01,
            ),
          ],
        ),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              await _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: _buildStreamBuilder(),
    );
  }

  StreamBuilder<QuerySnapshot> _buildStreamBuilder() {
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transaction');

    // Build query based on selected filters
    Query filteredQuery = transactions;

    try {
      if (compSearch.isNotEmpty && modelSearch.isEmpty) {
        filteredQuery = filteredQuery.where(
              'company',
              isEqualTo: _compController.text,
            );
           
      }
       if (compSearch.isEmpty && modelSearch.isNotEmpty) {
        filteredQuery = filteredQuery.where('model', isEqualTo: _modelController.text);
      }
      if (compSearch.isNotEmpty &&  modelSearch.isNotEmpty) {
        filteredQuery = filteredQuery
            .where(
              'company',
              isEqualTo: _compController.text,
            )
            .where('model', isEqualTo: _modelController.text);
      }
      if (filteringController.selectedTransactionType.isNotEmpty) {
        filteredQuery = filteredQuery.where('transactionType',
            isEqualTo: filteringController.selectedTransactionType);
      }

      if (filteringController.selectedTrading != null) {
        filteredQuery = filteredQuery.where('trading',
            isEqualTo: filteringController.selectedTrading);
      }
      if (filteringController.selectedPromotion != null) {
        filteredQuery = filteredQuery.where('promotion', isGreaterThan: 0.0);
      }

       if (filteringController.todayDateFilter != null) {
        filteredQuery = filteredQuery.where('date',
            isEqualTo: filteringController.todayDateFilter);
      }
      if (filteringController.dateFilter != null) {
        filteredQuery = filteredQuery.where('date',
            isGreaterThanOrEqualTo: filteringController.dateFilter);
      }

      if (filteringController.selectedFromDate != null &&
          filteringController.selectedToDate != null) {
        // Filter by date range

        filteredQuery = filteredQuery.where('date',
            isGreaterThanOrEqualTo: filteringController.selectedFromDate,
            isLessThanOrEqualTo: filteringController.selectedToDate);
      }
   } on FirebaseException catch (e) {
      // Check if the error is due to network unavailability
      if (e.code == 'unavailable') {
        // Handle the case where Firestore is unreachable (e.g., no internet connection)
        // For example, display a message to the user indicating the network issue
        print(
            'Error: Firestore is unreachable. Please check your internet connection.');
      } else {
        // Handle other Firebase-related errors
        print('Firebase Error: ${e.message}');
      }
    } catch (e) {
      print("error in ExpensesController init");
    }

    return StreamBuilder<QuerySnapshot>(
      stream: filteredQuery.where('user', isEqualTo: user).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text('ERROR: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data.'));
        }

        var docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('No filtered data.'));
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          // Calculate stock in and out counts
          int stockInCount = 0;
          int stockOutCount = 0;
          double promotionPrice = 0.0;
          for (DocumentSnapshot doc in snapshot.data!.docs) {
            var transactionType = doc['transactionType'];
            if (transactionType == 'In') {
              stockInCount++;
            } else if (transactionType == 'Out') {
              stockOutCount++;
              promotionPrice += doc['promotion'];
            }

            inCount = stockInCount;
            outCount = stockOutCount;
            promPrice = promotionPrice;
          }
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Stock In",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          inCount.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.red[200],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Stock Out",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          outCount.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var data = docs[index];
                  final width = Get.width;
                  final height = Get.height;

                  int stockInCount = 0;
                  int stockOutCount = 0;

                  // Iterate through filtered documents
                  for (var doc in docs) {
                    var transactionType = doc['transactionType'];
                    if (transactionType == 'In') {
                      stockInCount++;
                    } else if (transactionType == 'Out') {
                      stockOutCount++;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        docs[index]['transactionType'] == 'In'
                            ? homeController.editStockIn(data, context)
                            : homeController.editStockOut(data, context);
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: height * 0.12,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(8.0), // Add rounded corners
                          color: Colors.white, // Set background color
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                                spreadRadius: 0.0)
                          ], // Add subtle shadow
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Transaction type box
                                Container(
                                  width: width * 0.1,
                                  height:
                                      height * 0.05, // Specify a fixed height
                                  decoration: BoxDecoration(
                                    color:
                                        docs[index]['transactionType'] == 'In'
                                            ? Colors.green
                                            : Colors.red,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      docs[index]['transactionType'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                  ),
                                ),

                                // Model, price, and details section
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0), // Add padding inside
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${docs[index]['company'].split('_')[0]} ${docs[index]['model']}',
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          '${docs[index]['imei']}',
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'price: ${docs[index]['price']}',
                                              style: const TextStyle(
                                                  fontSize: 14.0),
                                            ),
                                            // const SizedBox(width: 10.0),
                                            Text(
                                              docs[index]['transactionType'] ==
                                                      'In'
                                                  ? ' disc: ${docs[index]['discount']}'
                                                  : ' ${docs[index]['cashOrCredit']} Prom: ${docs[index]['promotion']}',
                                              style: const TextStyle(
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                                docs[index][
                                                            'trading'] ==
                                                        true
                                                    ? ' TR'
                                                    : '',
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Date section
                                Text(
                                  docs[index]["date"].toString(),
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: GetBuilder<FilteringController>(
            builder: (controller) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRadioButtons(),
                _buildDateRangePickers(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                filteringController.clearFilters();
              },
              child: const Text('Clear Filters'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  // Update filters based on user selection
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date:'),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  value:
                      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                  groupValue: filteringController.todayDateFilter,
                  onChanged: (val) {
                    filteringController.setTodayDate(val);
                  },
                ),
                const Text('Today'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value:
                      "${DateTime.now().subtract(const Duration(days: 1)).year}-${DateTime.now().subtract(const Duration(days: 1)).month}-${DateTime.now().subtract(const Duration(days: 1)).day}",
                  groupValue: filteringController.todayDateFilter,
                  onChanged: (val) {
                    // String val =
                    //     "${DateTime.now().subtract(Duration(days: 2)).year}-${DateTime.now().subtract(Duration(days: 2)).month}-${DateTime.now().subtract(Duration(days: 2)).day}";
                    filteringController.setYesterdayDate(val);
                  },
                ),
                const Text('yesterday'),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  value:
                      "${DateTime.now().subtract(const Duration(days: 8)).year}-${DateTime.now().subtract(const Duration(days: 8)).month}-${DateTime.now().subtract(const Duration(days: 8)).day}",
                  groupValue: filteringController.dateFilter,
                  onChanged: (val) {
                    // String formattedDate =
                    //  ;
                    filteringController.setWeekAgoDate(val);
                  },
                ),
                const Text('Week ago'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value:
                      "${DateTime.now().subtract(const Duration(days: 30)).year}-${DateTime.now().subtract(const Duration(days: 30)).month}-${DateTime.now().subtract(const Duration(days: 30)).day}",
                  groupValue: filteringController.dateFilter,
                  onChanged: (val) {
                    filteringController.setMonthAgoDate(val);
                  },
                ),
                const Text('Month ago'),
              ],
            ),
          ],
        ),
        const Text('Transaction Type:'),
        Row(
          children: [
            _buildRadioButton('In', 'In'),
            _buildRadioButton('Out', 'Out'),
            _buildRadioButton('', 'All'),
          ],
        ),
        const SizedBox(height: 10),
        const Text('Trading Status:'),
        Row(
          children: [
            _buildTradingRadioButton(true, 'Trading'),
          ],
        ),
        const SizedBox(height: 10),
        const Text('Promotion Status:'),
        Row(
          children: [
            _buildPromotionRadioButton(0.0, 'On'),

            // _buildPromotionRadioButton(false, 'Off'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButton(String value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: filteringController.selectedTransactionType,
          onChanged: (val) {
            filteringController.setSelectedTransactionType(val.toString());
          },
        ),
        Text(label),
      ],
    );
  }

  Widget _buildTradingRadioButton(bool value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: filteringController.selectedTrading,
          onChanged: (val) {
            filteringController.setSelectedTrading(val);
          },
        ),
        Text(label),
      ],
    );
  }

  Widget _buildPromotionRadioButton(double value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: filteringController.selectedPromotion,
          onChanged: (val) {
            filteringController.setSelectedPromotion(val);
          },
        ),
        Text(label),
      ],
    );
  }

  Widget _buildDateRangePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Date Range:'),
        Row(
          children: [
            TextButton(
              onPressed: () => _selectFromDate(context),
              child: Text(
                filteringController.selectedFromDate != null
                    ? filteringController.selectedFromDate!
                    : 'From Date',
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () => _selectToDate(context),
              child: Text(
                filteringController.selectedToDate != null
                    ? filteringController.selectedToDate!
                    : 'To Date',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    // DateTime dateTime = selectedDate ?? DateTime.now();

    if (selectedDate != null) {
      // Format the selected date
      String formattedDate =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

      // Set the formatted date to filteringController
      filteringController.setSelectedFromDate(formattedDate);
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      // Format the selected date
      // Format the selected date
      String formattedDate =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

      // Set the parsed date to filteringController
      filteringController.setSelectedToDate(formattedDate);
    }
  }
}
