#!/bin/bash

# Script de vérification de l'environnement Supabase
# Vérifie que tout est bien installé et configuré

echo "🔍 Vérification de l'environnement Supabase pour Boxtobikers"
echo ""

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Compteur d'erreurs
ERRORS=0
WARNINGS=0

# Fonction pour afficher un succès
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Fonction pour afficher un avertissement
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

# Fonction pour afficher une erreur
error() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

# Vérifier Supabase CLI
echo "📦 Vérification des outils..."
if command -v supabase &> /dev/null; then
    VERSION=$(supabase --version)
    success "Supabase CLI installé ($VERSION)"
else
    error "Supabase CLI n'est pas installé"
    echo "  → Installez-le avec: brew install supabase/tap/supabase"
fi

# Vérifier Docker
if command -v docker &> /dev/null; then
    if docker ps &> /dev/null; then
        success "Docker installé et en cours d'exécution"
    else
        error "Docker est installé mais n'est pas démarré"
        echo "  → Démarrez Docker Desktop"
    fi
else
    error "Docker n'est pas installé"
    echo "  → Installez Docker Desktop: https://www.docker.com/products/docker-desktop/"
fi

# Vérifier Git
if command -v git &> /dev/null; then
    success "Git installé"
else
    error "Git n'est pas installé"
fi

# Vérifier Make
if command -v make &> /dev/null; then
    success "Make installé"
else
    warning "Make n'est pas installé (optionnel mais recommandé)"
fi

echo ""
echo "📁 Vérification de la structure du projet..."

# Vérifier l'existence des dossiers et fichiers
if [ -d "supabase" ]; then
    success "Dossier supabase/ existe"
else
    error "Dossier supabase/ manquant"
fi

if [ -d "supabase/migrations" ]; then
    success "Dossier supabase/migrations/ existe"
    MIGRATION_COUNT=$(ls -1 supabase/migrations/*.sql 2>/dev/null | wc -l)
    if [ $MIGRATION_COUNT -gt 0 ]; then
        success "$MIGRATION_COUNT migration(s) trouvée(s)"
    else
        warning "Aucune migration trouvée"
    fi
else
    error "Dossier supabase/migrations/ manquant"
fi

if [ -f "supabase/config.toml" ]; then
    success "Fichier supabase/config.toml existe"
else
    error "Fichier supabase/config.toml manquant"
fi

if [ -f "supabase/seed.sql" ]; then
    success "Fichier supabase/seed.sql existe"
else
    warning "Fichier supabase/seed.sql manquant (optionnel)"
fi

if [ -f ".github/workflows/deploy_supabase.yml" ]; then
    success "Workflow GitHub Actions configuré"
else
    warning "Workflow GitHub Actions manquant (optionnel pour déploiement auto)"
fi

if [ -f "Makefile" ]; then
    success "Makefile trouvé"
    if grep -q "db-start" Makefile; then
        success "Commandes Supabase présentes dans le Makefile"
    else
        warning "Commandes Supabase manquantes dans le Makefile"
    fi
else
    warning "Makefile manquant (optionnel)"
fi

echo ""
echo "🔗 Vérification de la configuration Supabase..."

# Vérifier si le projet est lié
if [ -f "supabase/.temp/project-ref" ]; then
    PROJECT_REF=$(cat supabase/.temp/project-ref)
    success "Projet lié à Supabase (ref: $PROJECT_REF)"
else
    warning "Projet non lié à un projet Supabase distant"
    echo "  → Liez-le avec: make db-link ref=VOTRE_PROJECT_REF"
fi

# Vérifier si Supabase est en cours d'exécution localement
if docker ps 2>/dev/null | grep -q "supabase"; then
    success "Supabase est en cours d'exécution localement"
    echo ""
    echo "  📍 URLs locales:"
    echo "     API: http://localhost:54321"
    echo "     Studio: http://localhost:54323"
    echo "     DB: postgresql://postgres:postgres@localhost:54322/postgres"
else
    warning "Supabase n'est pas en cours d'exécution localement"
    echo "  → Démarrez-le avec: make db-start"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Résumé
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ Tout est prêt !${NC} Vous pouvez commencer à développer."
    echo ""
    echo "Commandes utiles:"
    echo "  make db-start   - Démarrer Supabase en local"
    echo "  make help       - Voir toutes les commandes"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Configuration OK avec $WARNINGS avertissement(s)${NC}"
    echo ""
    echo "Vous pouvez continuer, mais vérifiez les avertissements ci-dessus."
    exit 0
else
    echo -e "${RED}✗ $ERRORS erreur(s) et $WARNINGS avertissement(s) trouvé(s)${NC}"
    echo ""
    echo "Veuillez corriger les erreurs avant de continuer."
    echo "Consultez docs/backend/supabase/SETUP_GUIDE.md pour plus d'aide."
    exit 1
fi

