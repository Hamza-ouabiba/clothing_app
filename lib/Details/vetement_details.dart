import 'dart:convert';
import 'package:clothing_app/Controllers/panierController.dart';
import 'package:clothing_app/Models/Vetement.dart';
import 'package:flutter/material.dart';

class VetementDetails extends StatelessWidget {
  final Vetement vetement;
  final PanierController panierController;

  const VetementDetails({
    Key? key,
    required this.vetement,
    required this.panierController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vetement.titre),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vetement.image.isNotEmpty)
              Image.memory(
                base64.decode(vetement.image),
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16.0),
            Text(
              'Taille: ${vetement.taille}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Catégorie: ${vetement.categorie}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Marque: ${vetement.marque}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(
              'Prix: \$${vetement.prix.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            bool response = await panierController.ajouterAuPanier(vetement);
            print("Response: $response");

            if (response) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${vetement.titre} ajouté au panier')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('${vetement.titre} déjà existant dans le panier'),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Ajouter au Panier',
              style: TextStyle(fontSize: 18),
            ),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}
