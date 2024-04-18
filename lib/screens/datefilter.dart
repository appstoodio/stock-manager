// import 'package:Rashdi_Mobile/controller/filtering_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DateFIlterScreen extends StatelessWidget {
//   const DateFIlterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser!.uid;
//     FilteringController filteringController = Get.put(FilteringController());
//     String fromDate = '2024-4-8';
//     String toDate= '2024-4-10';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Date Filter'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_alt),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => _buildDateFilterDialog(context),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('transaction').where('date', isGreaterThanOrEqualTo: fromDate, isNotEqualTo: toDate
//                   )
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('ERROR: ${snapshot.error}'));
//                 }
//                 if (!snapshot.hasData || snapshot.data == null) {
//                   return const Center(child: Text('No data.'));
//                 }
            
//                 var docs = snapshot.data!.docs;
//                 if (docs.isEmpty) {
//                   return const Center(child: Text('No filtered data.'));
//                 }
            
//                 if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
//                   // Calculate stock in and out counts
//                   int stockInCount = 0;
//                   int stockOutCount = 0;
//                   double promotionPrice = 0.0;
//                   // for (DocumentSnapshot doc in snapshot.data!.docs) {
//                   //   var transactionType = doc['transactionType'];
//                   //   if (transactionType == 'In') {
//                   //     stockInCount++;
//                   //   } else if (transactionType == 'Out') {
//                   //     stockOutCount++;
//                   //     promotionPrice += doc['promotion'];
//                   //   }
            
//                   //   // inCount = stockInCount;
//                   //   // outCount = stockOutCount;
//                   //   // promPrice = promotionPrice;
//                   // }
//                 }
            
//                 return Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             decoration: BoxDecoration(
//                               color: Colors.green[200],
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   "Stock In",
//                                   style: TextStyle(
//                                       fontSize: 16, fontWeight: FontWeight.bold),
//                                 ),
//                                 // Text(
//                                 //   inCount.toString(),
//                                 //   style: const TextStyle(fontSize: 20),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             decoration: BoxDecoration(
//                               color: Colors.red[200],
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   "Stock Out",
//                                   style: TextStyle(
//                                       fontSize: 16, fontWeight: FontWeight.bold),
//                                 ),
//                                 // Text(
//                                 //   // outCount.toString(),
//                                 //   style: const TextStyle(fontSize: 20),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: docs.length,
//                         itemBuilder: (context, index) {
//                           var data = docs[index];
//                           final width = Get.width;
//                           final height = Get.height;
            
//                           int stockInCount = 0;
//                           int stockOutCount = 0;
            
//                           // Iterate through filtered documents
//                           for (var doc in docs) {
//                             var transactionType = doc['transactionType'];
//                             if (transactionType == 'In') {
//                               stockInCount++;
//                             } else if (transactionType == 'Out') {
//                               stockOutCount++;
//                             }
//                           }
            
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 // docs[index]['transactionType'] == 'In'
//                                 //     ? homeController.editStockIn(data, context)
//                                 //     : homeController.editStockOut(data, context);
//                               },
//                               child: Container(
//                                 width: double.maxFinite,
//                                 height: height * 0.12,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(
//                                       8.0), // Add rounded corners
//                                   color: Colors.white, // Set background color
//                                   boxShadow: const [
//                                     BoxShadow(
//                                         color: Colors.grey,
//                                         blurRadius: 2.0,
//                                         spreadRadius: 0.0)
//                                   ], // Add subtle shadow
//                                 ),
//                                 child: Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         // Transaction type box
//                                         Container(
//                                           width: width * 0.1,
//                                           height: height *
//                                               0.05, // Specify a fixed height
//                                           decoration: BoxDecoration(
//                                             color: docs[index]
//                                                         ['transactionType'] ==
//                                                     'In'
//                                                 ? Colors.green
//                                                 : Colors.red,
//                                             borderRadius:
//                                                 BorderRadius.circular(8.0),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               docs[index]['transactionType'],
//                                               style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 16.0),
//                                             ),
//                                           ),
//                                         ),
            
//                                         // Model, price, and details section
//                                         Expanded(
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 10.0), // Add padding inside
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   '${docs[index]['company'].split('_')[0]} ${docs[index]['model']}',
//                                                   style: const TextStyle(
//                                                       fontSize: 18.0,
//                                                       fontWeight:
//                                                           FontWeight.w400),
//                                                 ),
//                                                 Text(
//                                                   '${docs[index]['imei']}',
//                                                   style: const TextStyle(
//                                                       fontSize: 18.0,
//                                                       fontWeight:
//                                                           FontWeight.w400),
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       'price: ${docs[index]['price']}',
//                                                       style: const TextStyle(
//                                                           fontSize: 14.0),
//                                                     ),
//                                                     // const SizedBox(width: 10.0),
//                                                     Text(
//                                                       docs[index]['transactionType'] ==
//                                                               'In'
//                                                           ? ' disc: ${docs[index]['discount']}'
//                                                           : ' ${docs[index]['cashOrCredit']} Prom: ${docs[index]['promotion']}',
//                                                       style: const TextStyle(
//                                                           fontSize: 14.0),
//                                                     ),
//                                                     Text(
//                                                       docs[index]['trading'] ==
//                                                               true
//                                                           ? ' TR'
//                                                           : '',
//                                                       style: const TextStyle(
//                                                           fontSize: 14.0),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
            
//                                         // Date section
//                                         Text(
//                                           docs[index]["date"].toString(),
//                                           style: const TextStyle(
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildDateFilterDialog(BuildContext context) {
//     return AlertDialog(
//       title: Text('Select Date Range'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildDateRangePickers(context),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               // Perform filtering based on selected date range
//               // Call your filtering logic/method here
//             },
//             child: Text('Apply Filter'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateRangePickers(BuildContext context) {
//     FilteringController filteringController = Get.put(FilteringController());
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Select Date Range:'),
//         Row(
//           children: [
//             TextButton(
//               onPressed: () {
//                 Future<void> _selectFromDate(BuildContext context) async {
//                   final selectedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime(2030),
//                   );
//                   // DateTime dateTime = selectedDate ?? DateTime.now();

//                   if (selectedDate != null) {
//                     // Format the selected date
//                     String formattedDate =
//                         "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

//                     // Set the formatted date to filteringController
//                     filteringController.setSelectedFromDate(formattedDate);
//                   }
//                 }
//               },
//               child: Text(
//                 filteringController.selectedFromDate.value != ''
//                     ? filteringController.selectedFromDate.value
//                     : 'From Date',
//               ),
//             ),
//             const SizedBox(width: 10),
//             TextButton(
//               onPressed: (){
//                  Future<void> _selectToDate(BuildContext context) async {
//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );

//     if (selectedDate != null) {
//       // Format the selected date
//       // Format the selected date
//       String formattedDate =
//           "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

//       // Set the parsed date to filteringController
//       filteringController.setSelectedToDate(formattedDate);
//     }
//   }
//               },
//               child: Text(
//                 filteringController.selectedToDate.value != ''
//                     ? filteringController.selectedToDate.value
//                     : 'To Date',
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

 
// }
