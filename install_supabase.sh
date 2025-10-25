#!/bin/bash

# Script d'installation rapide de Supabase CLI
# Pour macOS, Linux et Windows (WSL)

set -e

echo "🚀 Installation de Supabase CLI pour BoxToBikers"
echo ""

# Détection de l'OS
OS="$(uname -s)"

case "${OS}" in
    Linux*)
        echo "🐧 Système détecté : Linux"
        if command -v brew &> /dev/null; then
            echo "📦 Installation via Homebrew..."
            brew install supabase/tap/supabase
        else
            echo "📦 Installation via script..."
            curl -sSfL https://cli.supabase.com/install.sh | sh
        fi
        ;;
    Darwin*)
        echo "🍎 Système détecté : macOS"
        if command -v brew &> /dev/null; then
            echo "📦 Installation via Homebrew..."
            brew install supabase/tap/supabase
        else
            echo "❌ Homebrew n'est pas installé"
            echo "Installez Homebrew depuis https://brew.sh puis relancez ce script"
            exit 1
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "🪟 Système détecté : Windows"
        echo "Veuillez installer Supabase CLI via Scoop :"
        echo ""
        echo "  scoop bucket add supabase https://github.com/supabase/scoop-bucket.git"
        echo "  scoop install supabase"
        echo ""
        exit 0
        ;;
    *)
        echo "❌ Système non reconnu : ${OS}"
        exit 1
        ;;
esac

echo ""
echo "✅ Supabase CLI installé avec succès !"
echo ""

# Vérification de Docker
echo "🐳 Vérification de Docker..."
if command -v docker &> /dev/null; then
    if docker ps &> /dev/null 2>&1; then
        echo "✅ Docker est installé et en cours d'exécution"
    else
        echo "⚠️  Docker est installé mais n'est pas démarré"
        echo "→ Démarrez Docker Desktop avant de continuer"
    fi
else
    echo "❌ Docker n'est pas installé"
    echo "→ Installez Docker Desktop : https://www.docker.com/products/docker-desktop/"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎉 Installation terminée !"
echo ""
echo "Prochaines étapes :"
echo "  1. Assurez-vous que Docker Desktop est démarré"
echo "  2. Lancez : make check-supabase"
echo "  3. Lancez : make db-start"
echo "  4. Ouvrez : http://localhost:54323"
echo ""
echo "Documentation : docs/backend/supabase/SETUP_GUIDE.md"
echo ""

