import 'dart:convert';
import 'package:clothing_app/Controllers/vetementController.dart';
import 'package:clothing_app/Details/vetement_details.dart';
import 'package:clothing_app/Models/Vetement.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app/Controllers/panierController.dart'; // Import the PanierController

class ListeVetementContent extends StatefulWidget {
  @override
  State<ListeVetementContent> createState() => _ListeVetementContentState();
}

class _ListeVetementContentState extends State<ListeVetementContent> {
  final VetementController vetementController = VetementController();
  final PanierController panierController = PanierController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vetement>>(
      future: vetementController.fetchVetements(),
      builder: (BuildContext context, AsyncSnapshot<List<Vetement>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final vetements = snapshot.data ?? [];

        return ListView.builder(
          itemCount: vetements.length,
          itemBuilder: (context, index) {
            final vetement = vetements[index];

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VetementDetails(
                    vetement: vetement,
                    panierController: panierController,
                  ),
                ),
              ),
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    vetement.titre,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Taille: ${vetement.taille}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Prix: \$${vetement.prix.toStringAsFixed(2)}', // Format price
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  leading: vetement.image.isNotEmpty
                      ? Image.memory(base64.decode(vetement.image))
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
