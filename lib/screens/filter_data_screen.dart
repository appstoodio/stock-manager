// ignore_for_file: library_private_types_in_public_api
import 'package:Rashdi_Mobile/controller/filtering_controller.dart';
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
  final user = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _searchController = TextEditingController();
  String search = '';
   int inCount = 0;
     int outCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  CupertinoSearchTextField(
        controller: _searchController,
        onChanged: (String? value) {
         setState(() {
            search = value.toString();
         });
        },
      ),
        backgroundColor: Colors.amber,
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

  // Stream<QuerySnapshot> transactionStream() {
  //   DateTime startDate = DateTime.now();
  //   String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);

  //   return FirebaseFirestore.instance
  //       .collection('transaction')
  //       // .where('date', isGreaterThanOrEqualTo: startDate)
  //       .where('date', isEqualTo: formattedStartDate)
  //       .snapshots();
  // }

  StreamBuilder<QuerySnapshot> _buildStreamBuilder() {
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transaction');

    // Build query based on selected filters
    Query filteredQuery = transactions;

    try {

       if (search.isNotEmpty) {
      filteredQuery = filteredQuery.where('company', isEqualTo: _searchController.text);
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
      if (filteringController.selectedDateFilter != null) {
        filteredQuery = filteredQuery.where('date',
            isGreaterThanOrEqualTo: filteringController.selectedDateFilter);
      }

      if (filteringController.selectedFromDate != null &&
          filteringController.selectedToDate != null) {
        // Filter by date range

        filteredQuery = filteredQuery.where('date',
            isGreaterThanOrEqualTo: filteringController.selectedFromDate,
            isLessThanOrEqualTo: filteringController.selectedToDate);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error while filtering data. ${e.toString()}');
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
      for (DocumentSnapshot doc in snapshot.data!.docs) {
        var transactionType = doc['transactionType'];
        if (transactionType == 'In') {
          stockInCount++;
        } else if (transactionType == 'Out') {
          stockOutCount++;
        }
        
          inCount = stockInCount;
          outCount = stockOutCount;
      
      }}
        

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
                      Text(
                        "Stock In",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        inCount.toString(),
                        style: TextStyle(fontSize: 20),
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
                      Text(
                        "Stock Out",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        outCount.toString(),
                        style: TextStyle(fontSize: 20),
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
                  // Build UI using data
                  // ...
              
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
              
                  return  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  Container(
                      height: 70,
                      width: double.maxFinite,
                      color: data['transactionType'] == 'In'
                          ? const Color.fromARGB(255, 168, 245, 171)
                          : Colors.red,
                      child: ListTile(
                        leading: Text(data['transactionType'], style: const TextStyle(fontSize: 20),),
                        title:  Text( 'Imei: ${data['imei']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['promotion'] != null
                                  ? 'Promotion: ${data['promotion']}'
                                  : 'Discount: ${data['discount'].toString()}',
                            ),
                              Text( 'Price: ${data['price'].toString()}')
                          ],
                        ),
                        trailing: Text(
                          data['trading'] != null
                              ? 'trading: ${data['trading']}'
                              : data['date'],
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
                  groupValue: filteringController.selectedDateFilter,
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
                      "${DateTime.now().subtract(const Duration(days: 2)).year}-${DateTime.now().subtract(const Duration(days: 2)).month}-${DateTime.now().subtract(const Duration(days: 2)).day}",
                  groupValue: filteringController.selectedDateFilter,
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
                  groupValue: filteringController.selectedDateFilter,
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
                  groupValue: filteringController.selectedDateFilter,
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
            _buildTradingRadioButton(false, 'Not Trading'),
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
