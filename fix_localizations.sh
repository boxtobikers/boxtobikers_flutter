#!/bin/bash
# Script complet pour résoudre les problèmes de localisation

echo "🔧 Résolution des problèmes de localisation..."

# Étape 1: Nettoyer le build
echo "1. Nettoyage du build..."
flutter clean

# Étape 2: Récupérer les dépendances
echo "2. Récupération des dépendances..."
flutter pub get

# Étape 3: Générer les localisations automatiquement
echo "3. Génération des localisations à partir des fichiers ARB..."
flutter gen-l10n

# Étape 4: Vérifier que les fichiers ont été générés
echo "4. Vérification des fichiers générés..."
if [ -f ".dart_tool/flutter_gen/gen_l10n/app_localizations.dart" ]; then
    echo "✅ Fichiers de localisation générés avec succès !"

    # Étape 5: Supprimer le fichier temporaire et mettre à jour main.dart
    echo "5. Suppression du fichier temporaire..."
    rm -f lib/l10n/app_localizations.dart

    echo "6. Mise à jour de main.dart pour utiliser les fichiers générés..."
    # Cette partie sera faite manuellement après

else
    echo "❌ Erreur: Les fichiers de localisation n'ont pas été générés"
    echo "Utilisation du fichier temporaire en attendant..."
fi

echo "7. Lancement de l'application..."
flutter run
