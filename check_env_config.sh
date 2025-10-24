#!/bin/bash

# Script de vérification de la configuration des variables d'environnement
# Usage: ./check_env_config.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Vérification de la configuration des variables d'environnement"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Fonction pour vérifier si un fichier existe
check_file() {
    local file=$1
    local required=$2

    if [ -f "$file" ]; then
        echo "✅ $file"
        return 0
    else
        if [ "$required" = "required" ]; then
            echo "❌ $file (MANQUANT - REQUIS)"
            return 1
        else
            echo "⚠️  $file (optionnel)"
            return 0
        fi
    fi
}

# Fonction pour vérifier un dossier
check_dir() {
    local dir=$1

    if [ -d "$dir" ]; then
        echo "✅ $dir/"
        return 0
    else
        echo "❌ $dir/ (MANQUANT)"
        return 1
    fi
}

errors=0

echo "📁 Structure des fichiers :"
echo ""

# Vérifier le dossier config
check_dir "config" || ((errors++))

# Vérifier les fichiers de config
echo ""
echo "🔧 Fichiers de configuration :"
check_file "config/example.json" "required" || ((errors++))
check_file "config/dev.json" "required" || ((errors++))
check_file "config/staging.json" "optional"
check_file "config/prod.json" "optional"
check_file "config/README.md" "required" || ((errors++))

# Vérifier le code source
echo ""
echo "💻 Code source :"
check_file "lib/core/config/env_config.dart" "required" || ((errors++))
check_file "lib/core/services/supabase_service_example.dart" "required" || ((errors++))

# Vérifier les tests
echo ""
echo "🧪 Tests :"
check_file "test/core/config/env_config_test.dart" "required" || ((errors++))

# Vérifier les outils
echo ""
echo "🛠️  Outils & Configuration :"
check_file ".vscode/launch.json" "required" || ((errors++))
check_file "Makefile" "required" || ((errors++))
check_file ".gitignore" "required" || ((errors++))

# Vérifier la documentation
echo ""
echo "📚 Documentation :"
check_file "QUICKSTART_ENV.md" "required" || ((errors++))
check_file "SETUP_COMPLETE.md" "required" || ((errors++))

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $errors -eq 0 ]; then
    echo "✅ Tous les fichiers requis sont présents !"
    echo ""
    echo "🎯 Prochaines étapes :"
    echo "   1. Éditez config/dev.json avec vos clés Supabase"
    echo "   2. Lancez : make dev"
    echo "   3. Consultez QUICKSTART_ENV.md pour plus d'infos"
else
    echo "❌ $errors fichier(s) requis manquant(s)"
    echo ""
    echo "💡 Pour réinstaller la configuration :"
    echo "   Consultez SETUP_COMPLETE.md"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Vérifier le contenu de dev.json
if [ -f "config/dev.json" ]; then
    echo ""
    echo "🔍 Vérification de config/dev.json :"
    echo ""

    # Vérifier si c'est le fichier par défaut
    if grep -q "votre_cle_anon_dev_a_remplacer" "config/dev.json"; then
        echo "⚠️  ATTENTION : config/dev.json contient encore les valeurs par défaut"
        echo "   Vous devez le remplir avec vos vraies clés Supabase !"
        echo ""
        echo "   1. Allez sur https://supabase.com/dashboard"
        echo "   2. Settings → API"
        echo "   3. Copiez vos clés dans config/dev.json"
    else
        echo "✅ config/dev.json semble avoir été personnalisé"

        # Vérifier la syntaxe JSON
        if command -v python3 &> /dev/null; then
            if python3 -m json.tool config/dev.json > /dev/null 2>&1; then
                echo "✅ Syntaxe JSON valide"
            else
                echo "❌ Syntaxe JSON invalide ! Vérifiez le fichier"
                ((errors++))
            fi
        fi
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $errors -eq 0 ]; then
    exit 0
else
    exit 1
fi

