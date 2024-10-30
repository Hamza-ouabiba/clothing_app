import 'package:clothing_app/Models/Vetement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VetementController {
  final CollectionReference vetementsCollection =
      FirebaseFirestore.instance.collection('vetement');

  Future<List<Vetement>> fetchVetements() async {
    QuerySnapshot querySnapshot = await vetementsCollection.get();
    return querySnapshot.docs.map((doc) => Vetement.fromDocument(doc)).toList();
  }
}
