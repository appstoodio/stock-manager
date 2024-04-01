
class Userr{
  final String name;
  final String password;

  Userr({
    required this.name,
    required this.password,
  });

factory Userr.fromMap(Map<String, dynamic> map) {
    return Userr(
 name: map['name'],
      password :map['password'],
    
    );
  }

  // Convert the object to a map for adding to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
        'password': password,
    };
  }


}
