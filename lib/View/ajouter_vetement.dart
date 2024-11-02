import 'package:clothing_app/Controllers/vetementController.dart';
import 'package:clothing_app/Models/Vetement.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class AjouterVetement extends StatefulWidget {
  @override
  _AjouterVetementState createState() => _AjouterVetementState();
}

class _AjouterVetementState extends State<AjouterVetement> {
  final TextEditingController titreController = TextEditingController();
  final TextEditingController tailleController = TextEditingController();
  final TextEditingController categorieController = TextEditingController();
  final TextEditingController marqueController = TextEditingController();
  final TextEditingController prixController = TextEditingController();

  Uint8List? _imageData; // For storing the image data when picked
  bool _loading = false;
  String? _classificationResult;

  // Instantiate your VetementController
  final VetementController vetementController = VetementController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Read the image as bytes
      _imageData = await pickedFile.readAsBytes();
      setState(() {
        classifyImage(_imageData!);
      });
    }
  }

  Future<void> classifyImage(Uint8List imageData) async {
    setState(() {
      _loading = true;
      _classificationResult = null;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://127.0.0.1:5000/predict'), // Update with your server URL
      );
      request.files.add(http.MultipartFile.fromBytes('file', imageData,
          filename: 'image.png'));

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        // Assuming the server returns a JSON with classification result
        final data = json.decode(responseBody.body);
        print(data);
        // Extract the class with the highest probability
        if (data['prediction'] != null && data['prediction'].isNotEmpty) {
          final prediction = data['prediction'];

          setState(() {
            _classificationResult = prediction['class']; // Get the class name
            // Populate the category field with the top prediction
            categorieController.text =
                _classificationResult ?? ''; // Update the category controller
          });
        }
      } else {
        setState(() {
          _classificationResult = 'Failed to classify image';
        });
      }
    } catch (e) {
      setState(() {
        _classificationResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _saveVetement() {
    if (titreController.text.isNotEmpty &&
        tailleController.text.isNotEmpty &&
        categorieController.text.isNotEmpty &&
        marqueController.text.isNotEmpty &&
        prixController.text.isNotEmpty) {
      // Convert the image data to a Base64 string
      String? base64Image;
      if (_imageData != null) {
        base64Image = base64Encode(_imageData!);
      }

      final newVetement = Vetement(
          titre: titreController.text,
          taille: tailleController.text,
          categorie: categorieController.text,
          marque: marqueController.text,
          prix: double.parse(prixController.text),
          image: base64Image!,
          id: '');

      // Call the method to add the Vetement
      vetementController.addVetement(newVetement);

      // Optionally, show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vêtement enregistré avec succès')),
      );

      // Clear the form after saving
      titreController.clear();
      tailleController.clear();
      categorieController.clear();
      marqueController.clear();
      prixController.clear();
      setState(() {
        _imageData = null; // Reset the image
        _classificationResult = null; // Reset the classification result
      });
    } else {
      // Handle the case where the form is not filled correctly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un vêtement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titreController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: tailleController,
              decoration: InputDecoration(labelText: 'Taille'),
            ),
            TextField(
              controller: categorieController,
              decoration: InputDecoration(labelText: 'Catégorie'),
            ),
            TextField(
              controller: marqueController,
              decoration: InputDecoration(labelText: 'Marque'),
            ),
            TextField(
              controller: prixController,
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextButton.icon(
              icon: Icon(Icons.image),
              label: Text('Sélectionner une image'),
              onPressed: _pickImage,
            ),
            if (_imageData != null)
              Column(
                children: [
                  // Display the image from memory
                  Image.memory(_imageData!, height: 150),
                  if (_loading) CircularProgressIndicator(),
                  if (_classificationResult != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Classification: $_classificationResult",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveVetement, // Call the save logic here
                child: Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
