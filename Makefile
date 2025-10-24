# Makefile pour BoxToBikers Flutter

.PHONY: help dev staging prod clean build-android build-ios test

# Afficher l'aide par défaut
help:
	@echo "📱 BoxToBikers - Commandes disponibles"
	@echo ""
	@echo "🚀 Lancement de l'application :"
	@echo "  make dev          - Lancer en mode développement"
	@echo "  make staging      - Lancer en mode staging"
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

# Lancer l'application en développement
dev:
	flutter run --dart-define-from-file=config/dev.json

# Lancer l'application en staging
staging:
	flutter run --dart-define-from-file=config/staging.json

# Lancer l'application en production
prod:
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

