import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String name;
  final String user;

  Company({
    required this.name,
    required this.user,
  });

  // Convert the object to a map for adding to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
        'user': user,
    };
  }

  // Create a Company object from a DocumentSnapshot
  factory Company.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Company(
      name: snapshot['name'] as String,
       user: snapshot['user'] as String,
    );
  }
}
