import 'package:clothing_app/Models/Vetement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clothing_app/Controllers/userController.dart';

class PanierController {
  final CollectionReference utilisateursCollection =
      FirebaseFirestore.instance.collection('users');
  final User? _auth = FirebaseAuth.instance.currentUser;
  final Usercontroller userController = Usercontroller();

  Future<bool> ajouterAuPanier(Vetement vetement) async {
    if (_auth == null) {
      print('User is not authenticated');
      return false;
    }

    try {
      String userId = await userController.fetchUser();

      DocumentSnapshot existingItem = await utilisateursCollection
          .doc(userId)
          .collection('panier')
          .doc(vetement.id)
          .get();

      if (!existingItem.exists) {
        await utilisateursCollection
            .doc(userId)
            .collection('panier')
            .doc(vetement.id)
            .set({
          'titre': vetement.titre,
          'categorie': vetement.categorie,
          'marque': vetement.marque,
          'taille': vetement.taille,
          'prix': vetement.prix,
          'image': vetement.image,
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Error adding Vetement to panier: $e');
      return false;
    }
  }

  Future<void> deleteFromPanier(String vetementId) async {
    if (_auth == null) {
      print('User is not authenticated');
      return;
    }

    try {
      String userId = await userController.fetchUser();
      await utilisateursCollection
          .doc(userId)
          .collection('panier')
          .doc(vetementId)
          .delete();
      print('Vetement removed from panier successfully');
    } catch (e) {
      print('Error removing Vetement from panier: $e');
    }
  }

  Future<void> updateQuantity(String vetementId, int quantity) async {
    if (_auth == null) {
      print('User is not authenticated');
      return;
    }

    try {
      String userId = await userController.fetchUser();
      await utilisateursCollection
          .doc(userId)
          .collection('panier')
          .doc(vetementId)
          .update({'quantity': quantity});
      print('Quantity updated successfully');
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<List<Vetement>> getPanier() async {
    List<Vetement> vetementsList = [];

    if (_auth == null) {
      print('User is not authenticated');
      return vetementsList;
    }

    try {
      String userId = await userController.fetchUser();
      QuerySnapshot panierSnapshot =
          await utilisateursCollection.doc(userId).collection('panier').get();

      if (panierSnapshot.docs.isNotEmpty) {
        for (var doc in panierSnapshot.docs) {
          Vetement vetement = Vetement.fromDocument(doc);
          vetementsList.add(vetement);
        }
        print('Panier retrieved: ${vetementsList.length} items');
      } else {
        print('No items found in panier for this user.');
      }
    } catch (e) {
      print('Error retrieving panier: $e');
    }

    return vetementsList;
  }

  Future<double> getTotalPanier() async {
    double total = 0.0;

    if (_auth == null) {
      print('User is not authenticated');
      return total;
    }

    try {
      String userId = await userController.fetchUser();
      QuerySnapshot panierSnapshot =
          await utilisateursCollection.doc(userId).collection('panier').get();

      if (panierSnapshot.docs.isNotEmpty) {
        for (var doc in panierSnapshot.docs) {
          double prix = doc['prix'];

          total += prix;
        }
      } else {
        print('No items found in panier for this user.');
      }
    } catch (e) {
      print('Error calculating total panier: $e');
    }

    return total;
  }
}
