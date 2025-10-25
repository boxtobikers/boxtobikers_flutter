# Makefile pour BoxToBikers Flutter

.PHONY: help local dev prod clean build-android build-ios test db-start db-stop db-reset db-push db-diff db-migration db-diff-migration db-login db-link db-types db-status db-dump check-supabase check-run-configs

# Afficher l'aide par défaut
help:
	@echo "📱 BoxToBikers - Commandes disponibles"
	@echo ""
	@echo "🚀 Lancement de l'application :"
	@echo "  make local        - Lancer en mode local (Docker)"
	@echo "  make dev          - Lancer en mode développement (Supabase.io)"
	@echo "  make prod         - Lancer en mode production"
	@echo ""
	@echo "🏗️  Build :"
	@echo "  make build-android-dev   - Build Android en dev"
	@echo "  make build-android-prod  - Build Android en production"
	@echo "  make build-ios-dev       - Build iOS en dev"
	@echo "  make build-ios-prod      - Build iOS en production"
	@echo ""
	@echo "🧪 Tests :"
	@echo "  make test         - Lancer les tests"
	@echo "  make test-coverage - Tests avec couverture"
	@echo ""
	@echo "🧹 Nettoyage :"
	@echo "  make clean        - Nettoyer le projet"
	@echo "  make clean-all    - Nettoyage complet"
	@echo ""
	@echo "📦 Dépendances :"
	@echo "  make install      - Installer les dépendances"
	@echo "  make upgrade      - Mettre à jour les dépendances"
	@echo ""
	@echo "🗄️  Base de données (Supabase) :"
	@echo "  make db-start     - Démarrer Supabase en local"
	@echo "  make db-stop      - Arrêter Supabase"
	@echo "  make db-reset     - Réinitialiser la DB locale"
	@echo "  make db-push      - Pousser les migrations vers le serveur"
	@echo "  make db-diff      - Voir les différences avec le serveur"
	@echo "  make db-migration - Créer une nouvelle migration"
	@echo "  make db-login     - Se connecter à Supabase"
	@echo "  make db-link      - Lier au projet Supabase distant"
	@echo "  make check-supabase - Vérifier l'installation Supabase"
	@echo ""
	@echo "🔍 Vérifications :"
	@echo "  make check-run-configs - Vérifier les configurations Android Studio"

# Lancer l'application en mode local (Docker)
local:
	@echo "🐳 Lancement en mode local (Docker Supabase)..."
	@echo "⚠️  Assurez-vous que Docker est démarré : make db-start"
	flutter run --dart-define-from-file=config/local.json

# Lancer l'application en développement
dev:
	@echo "☁️  Lancement en mode développement (Supabase.io)..."
	flutter run --dart-define-from-file=config/dev.json

# Lancer l'application en production
prod:
	@echo "🚀 Lancement en mode production..."
	flutter run --dart-define-from-file=config/prod.json

# Build Android
build-android-dev:
	flutter build apk --dart-define-from-file=config/dev.json

build-android-prod:
	flutter build apk --release --dart-define-from-file=config/prod.json

# Build iOS
build-ios-dev:
	flutter build ios --dart-define-from-file=config/dev.json

build-ios-prod:
	flutter build ios --release --dart-define-from-file=config/prod.json

# Tests
test:
	flutter test

test-coverage:
	flutter test --coverage
	@echo "📊 Rapport de couverture généré dans coverage/lcov.info"

# Nettoyage
clean:
	flutter clean

clean-all: clean
	rm -rf build/
	rm -rf .dart_tool/
	rm -rf ios/Pods/
	rm -rf ios/.symlinks/
	rm -rf macos/Pods/
	flutter pub get

# Dépendances
install:
	flutter pub get

upgrade:
	flutter pub upgrade

# Configuration initiale
setup:
	@echo "🔧 Configuration initiale du projet..."
	@if [ ! -f config/dev.json ]; then \
		echo "📝 Création de config/dev.json à partir d'example.json..."; \
		cp config/example.json config/dev.json; \
		echo "✅ Fichier créé. N'oubliez pas de le remplir avec vos vraies clés !"; \
	else \
		echo "✓ config/dev.json existe déjà"; \
	fi
	@echo "📦 Installation des dépendances..."
	@make install
	@echo "✅ Configuration terminée !"
	@echo ""
	@echo "⚠️  Pensez à éditer config/dev.json avec vos vraies clés Supabase"
	@echo "💡 Lancez ensuite : make dev"

# ============================================
# Commandes Supabase
# ============================================

# Démarrer Supabase en local (Docker requis)
db-start:
	@echo "🚀 Démarrage de Supabase en local..."
	cd supabase && supabase start
	@echo ""
	@echo "✅ Supabase démarré ! Accédez au Studio : http://localhost:54323"

# Arrêter Supabase
db-stop:
	@echo "🛑 Arrêt de Supabase..."
	cd supabase && supabase stop

# Réinitialiser la base de données locale
db-reset:
	@echo "🔄 Réinitialisation de la base de données locale..."
	cd supabase && supabase db reset
	@echo "✅ Base de données réinitialisée avec les migrations et seeds"

# Pousser les migrations vers le serveur distant
db-push:
	@echo "📤 Envoi des migrations vers Supabase distant..."
	cd supabase && supabase db push
	@echo "✅ Migrations appliquées avec succès"

# Voir les différences entre local et distant
db-diff:
	@echo "🔍 Analyse des différences entre local et distant..."
	cd supabase && supabase db diff

# Créer une nouvelle migration
db-migration:
	@if [ -z "$(name)" ]; then \
		echo "❌ Erreur: Vous devez spécifier un nom de migration"; \
		echo "Usage: make db-migration name=ma_migration"; \
		exit 1; \
	fi
	@echo "📝 Création de la migration: $(name)"
	cd supabase && supabase migration new $(name)
	@echo "✅ Migration créée dans supabase/migrations/"

# Générer une migration depuis les différences
db-diff-migration:
	@if [ -z "$(name)" ]; then \
		echo "❌ Erreur: Vous devez spécifier un nom de migration"; \
		echo "Usage: make db-diff-migration name=ma_migration"; \
		exit 1; \
	fi
	@echo "📝 Génération de la migration depuis les différences: $(name)"
	cd supabase && supabase db diff -f $(name)
	@echo "✅ Migration générée dans supabase/migrations/"

# Se connecter à Supabase
db-login:
	@echo "🔐 Connexion à Supabase..."
	@echo "Votre navigateur va s'ouvrir pour vous authentifier"
	supabase login
	@echo "✅ Connexion réussie !"

# Lier au projet Supabase distant
db-link:
	@if [ -z "$(ref)" ]; then \
		echo "❌ Erreur: Vous devez spécifier la référence du projet"; \
		echo ""; \
		echo "Usage: make db-link ref=VOTRE_PROJECT_REF"; \
		echo ""; \
		echo "Étapes:"; \
		echo "  1. Connectez-vous d'abord: make db-login"; \
		echo "  2. Trouvez votre project ref sur https://app.supabase.com"; \
		echo "     (dans l'URL: https://app.supabase.com/project/XXXXX)"; \
		echo "  3. Lancez: make db-link ref=XXXXX"; \
		exit 1; \
	fi
	@echo "🔗 Liaison au projet Supabase: $(ref)"
	@echo "⚠️  Si vous n'êtes pas connecté, lancez d'abord: make db-login"
	@cd supabase && supabase link --project-ref $(ref) || \
		(echo ""; \
		 echo "❌ Échec de la liaison. Avez-vous lancé 'make db-login' ?"; \
		 echo ""; \
		 echo "Pour vous connecter:"; \
		 echo "  make db-login"; \
		 exit 1)
	@echo "✅ Projet lié avec succès"

# Générer les types Dart depuis le schéma
db-types:
	@echo "🔧 Génération des types Dart depuis le schéma Supabase..."
	cd supabase && supabase gen types typescript --local > ../lib/core/models/supabase_types.dart
	@echo "✅ Types générés dans lib/core/models/supabase_types.dart"

# Status de Supabase
db-status:
	@echo "📊 Status de Supabase local:"
	cd supabase && supabase status

# Dump du schéma actuel
db-dump:
	@echo "💾 Création d'un dump du schéma actuel..."
	cd supabase && supabase db dump -f schema_backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "✅ Dump créé dans supabase/"

# Vérifier l'installation Supabase
check-supabase:
	@chmod +x check_supabase_setup.sh
	@./check_supabase_setup.sh

# Vérifier les configurations de lancement Android Studio
check-run-configs:
	@chmod +x check_run_configs.sh
	@./check_run_configs.sh

