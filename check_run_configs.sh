#!/bin/bash

# Script de vérification des configurations de lancement Android Studio
# Ce script vérifie que les configurations sont bien installées

set -e

FLUTTER_DIR="/Users/emmanuelgrenier/Projects/boxtobikers/flutter"
RUN_DIR="${FLUTTER_DIR}/.run"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Vérification des configurations Android Studio"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Vérifier que le dossier .run existe
if [ ! -d "$RUN_DIR" ]; then
    echo "❌ Le dossier .run n'existe pas"
    echo "💡 Les configurations de lancement doivent être créées"
    exit 1
fi

echo "✅ Dossier .run trouvé"
echo ""

# Lister les configurations
echo "📋 Configurations disponibles :"
echo ""

configs=("main.dart.run.xml" "main.dart (local).run.xml" "main.dart (dev).run.xml" "main.dart (prod).run.xml")

for config in "${configs[@]}"; do
    if [ -f "$RUN_DIR/$config" ]; then
        echo "  ✅ ${config%.run.xml}"
    else
        echo "  ❌ ${config%.run.xml} (manquant)"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 Comment utiliser dans Android Studio :"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Ouvrez Android Studio"
echo "2. En haut à droite, cliquez sur le sélecteur de configuration"
echo "3. Sélectionnez 'main.dart (dev)' ou une autre configuration"
echo "4. Cliquez sur Run ▶ ou Debug 🐛"
echo ""
echo "📖 Guide complet : docs/development/ANDROID_STUDIO_LAUNCH.md"
echo ""

