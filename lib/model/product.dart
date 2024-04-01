import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id; // added for DocumentSnapshot
  final String name;
  final double price;
  final String description;
  

  Product({
   required this.id, // added for DocumentSnapshot, default is an empty string
    required this.name,
    required this.price,
    required this.description,
   
  });

  // Convert the object to a map for adding to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'price': price,
      'description': description,
    };
  }

  // Create a Product object from a DocumentSnapshot
  factory Product.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Product(
      id: snapshot['id'] as String,
      name: snapshot['name'] as String,
      price: snapshot['price'] as double,
      description: snapshot['description'] as String,
    );
  }
}
