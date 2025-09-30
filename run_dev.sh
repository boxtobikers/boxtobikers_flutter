#!/bin/bash
# Script pour lancer Flutter en mode développement avec Hot Reload

echo "🚀 Démarrage de Flutter en mode développement..."

# Nettoie le build précédent
flutter clean

# Récupère les dépendances
flutter pub get

# Lance l'application avec Hot Reload activé
flutter run --hot
