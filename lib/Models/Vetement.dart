import 'package:cloud_firestore/cloud_firestore.dart';

class Vetement {
  final String id;
  final String image;
  final String titre;
  final String categorie;
  final String taille;
  final String marque;
  final double prix;

  Vetement(
      {required this.image,
      required this.titre,
      required this.categorie,
      required this.taille,
      required this.marque,
      required this.prix,
      required this.id});

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'titre': titre,
      'categorie': categorie,
      'taille': taille,
      'marque': marque,
      'prix': prix,
    };
  }

  factory Vetement.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Vetement(
        id: doc.id,
        titre: data['titre'] ?? 'Unknown',
        taille: data['taille'] ?? 'N/A',
        prix: data['prix'] ?? 0.0,
        image: data['image'] ?? '',
        categorie: data['categorie'] ?? '',
        marque: data['marque'] ?? '');
  }
}
