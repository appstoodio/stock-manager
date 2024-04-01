import 'package:Rashdi_Mobile/controller/home_controller.dart';
import 'package:Rashdi_Mobile/controller/stock_in_controller.dart';
import 'package:Rashdi_Mobile/screens/deleted_data.dart';
import 'package:Rashdi_Mobile/screens/due_payment.dart';
import 'package:Rashdi_Mobile/screens/expenses.dart';
import 'package:Rashdi_Mobile/screens/filter_data_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/stock_out_controller.dart';
import 'auth/login_screen.dart';
import 'stock_in.dart';
import 'stock_out.dart';

// Home screen for app..

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StockInController stockInController = Get.put(StockInController());
  final StockOutController stockOutController = Get.put(StockOutController());
  final HomeController homeController = Get.put(HomeController());
  TextEditingController imeiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("home Screen init called");
    homeController.fetchPrices();
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Stock Manager'),
          backgroundColor: Colors.lightBlueAccent,
          actions: [
            IconButton(
                onPressed: () {
                  homeController.showDateFilterDialog(context);
                },
                icon: const Icon(Icons.calendar_month)),
            IconButton(
                onPressed: () {
                  Get.offAll(() => const DeletedData());
                },
                icon: const Icon(Icons.backup)),
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Get.offAll(()=> LoginScreen());
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => const DuePaymentScreen()),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                          bottom: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                          left: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                          right: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          )),
                      color: Colors.white,

                      
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payment,
                          size: 40,
                          color: Colors.lightBlueAccent,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Due Payment',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () => Get.to(() => const FilteringScreen()),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                          bottom: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                          left: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                          right: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          )),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_list,
                          size: 40,
                          color: Colors.lightBlueAccent,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Transactions',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () => Get.to(() => const Expenses()),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                          bottom: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                          left: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                          right: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          )),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.report,
                          size: 40,
                          color: Colors.lightBlueAccent,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Expenses',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.006,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetBuilder<HomeController>(
              builder: (controller) => Container(
                width: double.maxFinite,
                height: height * 0.147,
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
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1.0,
                      blurRadius: 1.0,
                      offset: const Offset(0, 1.0),
                    )
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: width * 0.01),
                                Text(
                                  '${controller.stockInCount.toString()} In',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: width * 0.01),
                                Text(
                                  '${controller.stockOutCount.toString()} Out',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: width * 0.01),
                                Text(
                                  '${controller.inHandCount.toString()} In Hand',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('In: '),
                                Text(controller.inPrice.value.toString()),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     const Text('Out: '),
                            //     Text(controller.outPrice.value.toString()),
                            //   ],
                            // ),
                            Row(
                              children: [
                                const Text('Expenses: '),
                                Text(controller.expensesPrice.value.toString()),
                              ],
                            ),
                            Divider(
                              height: height * 0.01,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Profit: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  (controller.profit.value.toString()),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: controller.profit.value > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.001,
          ),
          const Text('Last 10 transactions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('transaction')
                  .where('user',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          docss[index]['transactionType'] == 'In'
                              ? homeController.editStockIn(
                                  docss[index], context)
                              : homeController.editStockOut(
                                  docss[index], context);
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: height * 0.09,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                8.0), // Add rounded corners
                            color: Colors.white, // Set background color
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0)
                            ], // Add subtle shadow
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Transaction type box
                                  Container(
                                    width: width * 0.1,
                                    height:
                                        height * 0.05, // Specify a fixed height
                                    decoration: BoxDecoration(
                                      color: docss[index]['transactionType'] ==
                                              'In'
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        docss[index]['transactionType'],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),

                                  // Model, price, and details section
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          10.0), // Add padding inside
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${docss[index]['company']} ${docss[index]['model']}',
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'price: ${docss[index]['price']}',
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                              // const SizedBox(width: 10.0),
                                              Text(
                                                docss[index][
                                                            'transactionType'] ==
                                                        'In'
                                                    ? ' disc: ${docss[index]['discount']}'
                                                    : ' ${docss[index]['cashOrCredit']} Prom: ${docss[index]['promotion']}',
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                              Text(
                                                docss[index][
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
                                    docss[index]["date"].toString(),
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
                );
              },
            ),
          ),
        ]),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            onPressed: () {
              stockInController.scan();
            },
            heroTag: null,
            child: const Text('In'),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
            
              stockOutController.scan();
            },
            heroTag: null,
            child: const Text('Out'),
          )
        ]));
  }
}
