import 'dart:convert';
import 'package:clothing_app/Models/Vetement.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app/Controllers/panierController.dart';

class ListePanierContent extends StatefulWidget {
  @override
  State<ListePanierContent> createState() => _ListeVetementContentState();
}

class _ListeVetementContentState extends State<ListePanierContent> {
  final PanierController panierController = PanierController();

  Future<void> _deleteVetement(String vetementId) async {
    try {
      await panierController.deleteFromPanier(vetementId);
      setState(() {});
    } catch (e) {
      print('Error deleting vetement: $e');
    }
  }

  double _calculerTotalPanier(List<Vetement> vetements) {
    double total = 0.0;
    for (var vetement in vetements) {
      total += vetement.prix;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vetement>>(
      future: panierController.getPanier(),
      builder: (BuildContext context, AsyncSnapshot<List<Vetement>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final vetements = snapshot.data ?? [];

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: vetements.length,
                itemBuilder: (context, index) {
                  final vetement = vetements[index];

                  return Card(
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
                            'Prix: \$${vetement.prix.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      leading: vetement.image.isNotEmpty
                          ? Image.memory(base64.decode(vetement.image))
                          : null,
                      trailing: IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _deleteVetement(vetement.id),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total: \$${_calculerTotalPanier(vetements).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
