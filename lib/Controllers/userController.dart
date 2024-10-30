import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Usercontroller {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final User? _auth = FirebaseAuth.instance.currentUser;

  Future<String> fetchUser() async {
    if (_auth == null) {
      throw Exception("User not authenticated");
    }

    try {
      QuerySnapshot userDocs = await usersCollection
          .where('email', isEqualTo: _auth.email)
          .limit(1)
          .get();

      if (userDocs.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userDocs.docs.first;
        print(userDoc.data());
        print(userDoc.id);
        return userDoc.id;
      } else {
        print("No user found with email: ${_auth.email}");
        return "";
      }
    } catch (e) {
      throw Exception("Error fetching user: $e");
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await usersCollection.doc(userId).update(updates);
      print("User $userId updated successfully.");
    } catch (e) {
      throw Exception("Error updating user: $e");
    }
  }
}
