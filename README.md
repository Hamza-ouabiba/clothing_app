# Application de Gestion de Vêtements

Ce projet est une application de gestion de vêtements développée avec Flutter, intégrant un système de classification d'images basé sur l'IA qui catégorise automatiquement les vêtements en fonction des images téléchargées. 

## Technologies Utilisées

- **Flutter** pour le développement mobile.
- **Dart** comme langage de programmation.
- **Python** et Flask pour le backend du modèle IA.
- **Modèle de Classification d'Images** pour la prédiction de la catégorie des vêtements.
- Package **HTTP** pour la gestion des requêtes.
- Package **Image Picker** pour sélectionner des images depuis la galerie.

## Prise en Main


### Installation

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/Hamza-ouabiba/clothing_app.git
   cd clothing_app
   flutter pub get
3. Accédez au dossier python pour lancer le backend IA:
   ```bash
   cd python
   pip install -r requirements.txt
   python classification.py
4. Lancez l'application
   ```bash
   flutter run
