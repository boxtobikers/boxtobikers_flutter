#!/bin/bash
# Script de nettoyage des localisations - à exécuter dans le terminal

echo "🧹 Nettoyage des fichiers de localisation manuels..."

# Supprimer les fichiers de localisation générés manuellement
rm -f lib/l10n/app_localizations_en.dart
rm -f lib/l10n/app_localizations_fr.dart

echo "📦 Régénération des localisations à partir des fichiers ARB..."

# Nettoyer le build
flutter clean

# Récupérer les dépendances
flutter pub get

# Générer les localisations
flutter gen-l10n

echo "✅ Migration vers les fichiers ARB terminée !"
echo "Les localisations sont maintenant gérées uniquement par les fichiers .arb"
