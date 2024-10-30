import 'package:clothing_app/Models/Vetement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Panier {
  final String id;
  final List<Vetement> vetements;
  double total;

  Panier({
    required this.id,
    required this.vetements,
    required this.total,
  });

  static Future<Panier> fromDocument(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;

    List<DocumentReference> vetementRefs =
        List<DocumentReference>.from(data['vetements']);

    List<Vetement> vetementsList =
        await Future.wait(vetementRefs.map((ref) async {
      DocumentSnapshot vetementDoc = await ref.get();
      return Vetement.fromDocument(vetementDoc);
    }));

    return Panier(
      id: doc.id,
      vetements: vetementsList,
      total: (data['total'] is double) ? data['total'] : 0.0,
    );
  }
}
