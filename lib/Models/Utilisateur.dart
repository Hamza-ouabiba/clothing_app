import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class Utilisateur {
  final String adress;
  final String birthday;
  final String city;
  final String email;
  final String password;
  final String postalCode;

  Utilisateur({
    required this.adress,
    required this.birthday,
    required this.city,
    required this.email,
    required this.password,
    required this.postalCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'adress': adress,
      'birthday': birthday,
      'city': city,
      'email': email,
      'postalCode': postalCode,
    };
  }

  factory Utilisateur.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    print(data);
    return Utilisateur(
      adress: data['adress'] ?? '',
      birthday: data['birthday'] ?? '',
      city: data['city'] ?? '',
      email: data['email'] ?? '',
      password: data['password'],
      postalCode: data['postalCode'] ?? '',
    );
  }
}
