import 'package:clothing_app/View/ajouter_vetement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app/Models/Utilisateur.dart';
import 'package:clothing_app/Controllers/userController.dart';
import 'package:clothing_app/main.dart'; // Assume that your Login page is in the main.dart

class UserContent extends StatefulWidget {
  @override
  _UserContentState createState() => _UserContentState();
}

class _UserContentState extends State<UserContent> {
  final Usercontroller userController = Usercontroller();
  Utilisateur? utilisateur;
  String userId = "";
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      this.userId = await userController.fetchUser();

      if (userId.isNotEmpty) {
        DocumentSnapshot userDoc =
            await userController.usersCollection.doc(userId).get();

        if (userDoc.exists) {
          setState(() {
            utilisateur = Utilisateur.fromDocument(userDoc);
            birthdayController.text = utilisateur!.birthday;
            passwordController.text = utilisateur!.password;
            addressController.text = utilisateur!.adress;
            postalCodeController.text = utilisateur!.postalCode;
            cityController.text = utilisateur!.city;
            loginController.text = this.userId!;
          });
        } else {
          print('User document does not exist');
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login(title: 'MiageD')),
    );
  }

  Future<void> _validate() async {
    Map<String, dynamic> userInfo = {
      'birthday': birthdayController.text,
      'adress': addressController.text,
      'postalCode': postalCodeController.text,
      'city': cityController.text,
    };

    try {
      await userController.updateUser(userId, userInfo);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Informations validées et mises à jour')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour: $e')),
      );
    }
  }

  Future<void> _addClothingItem() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AjouterVetement()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return utilisateur == null
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logout button at the top
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: _logout,
                      child: Text('Se déconnecter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Set the button color to red
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: loginController,
                    obscureText: false,
                    decoration: InputDecoration(labelText: 'Login'),
                    readOnly: true,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration:
                        InputDecoration(labelText: 'Mot de passe (offusqué)'),
                    readOnly: false,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: birthdayController,
                    decoration: InputDecoration(labelText: 'Anniversaire'),
                    readOnly: false,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Adresse'),
                    readOnly: false,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: postalCodeController,
                    decoration: InputDecoration(labelText: 'Code Postal'),
                    keyboardType: TextInputType.number,
                    readOnly: false,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(labelText: 'Ville'),
                    readOnly: false,
                  ),
                  SizedBox(height: 32),
                  // Add the buttons at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _validate,
                        child: Text('Valider'),
                      ),
                      ElevatedButton(
                        onPressed: _addClothingItem, // Add clothing item button
                        child: Text('Ajouter un vêtement'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
