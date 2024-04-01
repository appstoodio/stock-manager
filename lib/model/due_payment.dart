import 'package:cloud_firestore/cloud_firestore.dart';

class DuePayment {
  final String imei; // added for DocumentSnapshot
  final String vendorName;
  final double price;
  final double priceRem;
  final double pricePaid;
  double? priceDone;
  final String user;
  final bool paid;
  String date;
  final DateTime time;

  DuePayment(
      {required this.imei, // added for DocumentSnapshot, default is an empty string
      required this.vendorName,
      required this.price,
      required this.priceRem,
      required this.pricePaid,
      this.priceDone,
      required this.user,
      required this.paid,
      required this.date,
      required this.time});

  // Convert the object to a map for adding to Firestore
  Map<String, dynamic> toMap() {
    return {
      'imei': imei,
      'vendorName': vendorName,
      'price': price,
      'priceRem': priceRem,
      'pricePaid': pricePaid,
      'priceDone': priceDone,
      'user': user,
      'paid': paid,
      'date': date,
      'time': time,
    };
  }

  // Create a DuePayment object from a DocumentSnapshot
  factory DuePayment.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return DuePayment(
        imei: snapshot['imei'] as String,
        vendorName: snapshot['vendorName'] as String,
        price: snapshot['price'] as double,
        priceRem: snapshot['priceRem'] as double,
        pricePaid: snapshot['pricePaid'] as double,
        priceDone: snapshot['priceDone'] as double,
        user: snapshot['user'],
        paid: snapshot['paid'],
        date: snapshot['date'],
        time: snapshot['time']);
  }
}
