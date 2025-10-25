# BoxToBikers 🏍️

Application Flutter pour la communauté BoxToBikers.

---

## 🚀 Démarrage Rapide

### Installation

```bash
# 1. Installer les dépendances
flutter pub get

# 2. Configurer les variables d'environnement
cp config/example.json config/dev.json
# Éditez config/dev.json avec vos clés Supabase
```

### Lancement

```bash
make dev
```

**IDE :**
- **VS Code :** Appuyez sur `F5` → Sélectionnez "BoxToBikers (Development)"
- **Android Studio :** Sélectionnez "main.dart (dev)" dans le menu déroulant en haut à droite → Run ▶

👉 **[Guide de démarrage complet](docs/getting-started/quick-start.md)** (3 minutes)  
👉 **[Lancement depuis Android Studio](docs/development/ANDROID_STUDIO_LAUNCH.md)** - Résoudre l'erreur "Configuration manquante"

---

## 📚 Documentation

| Section | Description |
|---------|-------------|
| **[🚀 Démarrage](docs/getting-started/)** | Installation et configuration rapide |
| **[🔧 Variables d'env](docs/environment/)** | Configuration des environnements |
| **[🔗 Backend Supabase](docs/backend/supabase/)** | Intégration et utilisation |
| **[👨‍💻 Guide Développeur](docs/development/)** | Développement quotidien |
| **[🏗️ Architecture](docs/architecture/)** | Structure du projet |

📖 **[Index complet de la documentation →](docs/README.md)**

---

## 🧰 Commandes

```bash
make local            # Lancer en mode local (Docker)
make dev              # Lancer en développement (Supabase.io)
make prod             # Lancer en production

make test             # Lancer les tests
make test-coverage    # Tests avec couverture

make build-android-prod  # Build Android production
make build-ios-prod      # Build iOS production

# Base de données Supabase
make db-start         # Démarrer Supabase en local
make db-stop          # Arrêter Supabase
make db-reset         # Réinitialiser la DB locale
make db-migration name=XXX  # Créer une migration
make check-supabase   # Vérifier l'installation

make clean            # Nettoyer le projet
make help             # Voir toutes les commandes
```

👉 **[Guide Supabase complet](docs/backend/supabase/SETUP_GUIDE.md)**

---

## 🏗️ Stack Technique

| Technologie | Version | Usage |
|-------------|---------|-------|
| **Flutter** | 3.9.2+ | Framework |
| **Supabase** | 2.10.3 | Backend as a Service |
| **Provider** | 6.1.2 | State Management |
| **Dio** | 5.9.0 | HTTP Client |
| **FlexColorScheme** | 8.3.0 | Theming |
| **Google Fonts** | 6.3.1 | Typographie |

---

## 📁 Structure du Projet

```
lib/
├── core/              # Fonctionnalités de base
│   ├── app/          # Configuration de l'app
│   ├── config/       # Variables d'environnement
│   ├── services/     # Services (Supabase, etc.)
│   └── http/         # Client HTTP
├── features/         # Fonctionnalités métier
├── generated/        # Fichiers générés
└── l10n/            # Internationalisation

docs/                 # 📚 Documentation complète
├── getting-started/  # Guides de démarrage
├── environment/      # Variables d'env
├── backend/          # Backend & Services
├── development/      # Guide développeur
└── architecture/     # Architecture

config/              # Configuration
├── dev.json        # Développement (à créer)
├── staging.json    # Staging
└── prod.json       # Production
```

**[Structure détaillée →](docs/architecture/project-structure.md)**

---

## 🔒 Sécurité

⚠️ **Important** :
- Les fichiers `config/*.json` ne doivent **jamais** être committés (sauf `example.json`)
- Ils sont déjà protégés par `.gitignore`
- Ne partagez jamais vos clés API publiquement

**[Guide sécurité →](docs/environment/README.md#-sécurité)**

---

## 🧪 Tests

```bash
# Tous les tests
make test

# Avec couverture
make test-coverage

# Tests spécifiques
flutter test test/core/config/env_config_test.dart
```

---

## 📱 Build

```bash
# Android
make build-android-prod

# iOS  
make build-ios-prod
```

---

## 🆘 Besoin d'Aide ?

1. **[Guide de démarrage rapide](docs/getting-started/quick-start.md)** - 3 minutes chrono
2. **[Documentation complète](docs/README.md)** - Tous les guides
3. **[FAQ & Troubleshooting](docs/getting-started/quick-start.md#-problèmes-)** - Problèmes courants

---

## 🤝 Contribuer

Ce projet suit les conventions Flutter standard. Consultez le **[guide développeur](docs/development/README.md)** pour plus d'informations.

---

## 📄 Licence

Projet privé - BoxToBikers © 2025

---

**Pour commencer :** [Guide de démarrage rapide →](docs/getting-started/quick-start.md) 🚀

