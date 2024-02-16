import 'package:cloud_firestore/cloud_firestore.dart';

class DailyExpenses {
  final String user;
   final String name;
  final double price;
  final DateTime date;
  

  DailyExpenses({
 required this.user,
    required this.name,
    required this.price,
    required this.date,
   
  });

  // Convert the object to a map for adding to Firestore
  Map<String, dynamic> toMap() {
    return {
     'user': user,
      'name': name,
      'price': price,
      'date': date,
    };
  }

  // Create a DailyExpenses object from a DocumentSnapshot
  factory DailyExpenses.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return DailyExpenses(
      user: snapshot['user'] as String,
      name: snapshot['name'] as String,
      price: snapshot['price'] as double,
      date: snapshot['date'],
    );
  }
}
