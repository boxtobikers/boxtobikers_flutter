# 📁 Structure du Projet BoxToBikers

Documentation détaillée de l'organisation des dossiers et fichiers.

---

## 🌳 Arborescence Complète

```
boxtobikers/flutter/
├── lib/                          # Code source Dart
│   ├── main.dart                # Point d'entrée
│   ├── core/                    # Code transverse
│   ├── features/                # Modules métier
│   ├── generated/               # Code généré
│   └── l10n/                    # Internationalisation
│
├── docs/                         # 📚 Documentation
│   ├── getting-started/         # Guides de démarrage
│   ├── environment/             # Variables d'env
│   ├── backend/                 # Backend & Services
│   ├── development/             # Guide dev
│   └── architecture/            # Architecture
│
├── config/                       # Configuration
│   ├── example.json            # Template
│   ├── dev.json                # Dev (ignoré)
│   ├── staging.json            # Staging (ignoré)
│   └── prod.json               # Prod (ignoré)
│
├── test/                         # Tests
├── assets/                       # Images, fonts
├── fonts/                        # Polices
├── android/                      # Code Android
├── ios/                          # Code iOS
├── web/                          # Code Web
├── linux/                        # Code Linux
├── macos/                        # Code macOS
├── windows/                      # Code Windows
│
├── pubspec.yaml                 # Dépendances
├── Makefile                     # Commandes
├── README.md                    # Vue d'ensemble
└── .gitignore                   # Fichiers ignorés
```

---

## 📂 Dossier `lib/`

### `lib/core/` - Code Transverse

```
lib/core/
├── app/                         # Application
│   ├── app_launcher.dart       # Démarrage de l'app
│   ├── app_router.dart         # Navigation
│   ├── providers/              # Providers globaux
│   └── utils/                  # Utilitaires
│
├── config/                      # Configuration
│   └── env_config.dart         # Variables d'env
│
├── services/                    # Services
│   ├── supabase_service.dart   # Service Supabase
│   └── ...
│
├── http/                        # Client HTTP
│   └── dio_client.dart         # Configuration Dio
│
└── drawer/                      # Navigation drawer
    └── ...
```

### `lib/features/` - Modules Métier

Organisation par fonctionnalité (feature-first) :

```
lib/features/
└── home/                        # Module Home
    ├── data/                   # Accès aux données
    │   └── repositories/
    ├── models/                 # Modèles de données
    ├── providers/              # State management
    └── ui/                     # Interface utilisateur
        ├── pages/             # Pages complètes
        └── widgets/           # Widgets réutilisables
```

**Pattern recommandé pour chaque feature :**

```
feature_name/
├── data/
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── datasources/
│       └── feature_remote_datasource.dart
│
├── models/
│   └── feature_model.dart
│
├── providers/
│   └── feature_provider.dart
│
└── ui/
    ├── pages/
    │   └── feature_page.dart
    └── widgets/
        └── feature_widget.dart
```

### `lib/generated/` - Code Généré

```
lib/generated/
└── l10n.dart                   # Localisation générée
```

⚠️ **Ne jamais éditer manuellement**

### `lib/l10n/` - Internationalisation

```
lib/l10n/
├── intl_en.arb                 # Anglais
├── intl_fr.arb                 # Français
└── ...
```

---

## 📚 Dossier `docs/`

```
docs/
├── README.md                    # Index principal
├── MIGRATION_PLAN.md           # Plan de migration
│
├── getting-started/            # Démarrage
│   ├── README.md
│   ├── quick-start.md
│   └── setup-complete.md
│
├── environment/                # Variables d'env
│   ├── README.md
│   ├── configuration.md
│   └── examples/
│       └── main_with_env_example.dart
│
├── backend/                    # Backend
│   ├── supabase/
│   │   ├── README.md
│   │   ├── setup.md
│   │   ├── updates.md
│   │   └── examples/
│   └── http/
│       └── README.md
│
├── development/                # Développement
│   ├── README.md
│   ├── app-launcher.md
│   └── features.md
│
├── architecture/               # Architecture
│   ├── README.md
│   ├── project-structure.md  # Ce fichier
│   └── coding-standards.md
│
└── assets/                     # Assets de la doc
    └── screenshots/
```

---

## 🔧 Dossier `config/`

```
config/
├── .gitkeep                    # Garde le dossier
├── README.md                   # Documentation config
├── example.json                # Template (✅ committé)
├── dev.json                    # Dev (❌ ignoré)
├── staging.json                # Staging (❌ ignoré)
└── prod.json                   # Prod (❌ ignoré)
```

---

## 🧪 Dossier `test/`

```
test/
├── core/
│   ├── config/
│   │   └── env_config_test.dart
│   └── services/
│       └── supabase_service_test.dart
│
├── features/
│   └── home/
│       └── home_test.dart
│
└── widget_app_test.dart
```

---

## 📱 Plateformes

### Android (`android/`)
```
android/
├── app/
│   ├── build.gradle.kts        # Configuration build
│   └── src/                    # Code Kotlin/Java
└── build.gradle.kts            # Config projet
```

### iOS (`ios/`)
```
ios/
├── Runner/                     # Code Swift
├── Runner.xcodeproj/          # Projet Xcode
└── Podfile                     # Dépendances CocoaPods
```

---

## 📦 Fichiers Racine

| Fichier | Description |
|---------|-------------|
| `pubspec.yaml` | Dépendances et configuration |
| `Makefile` | Commandes utiles |
| `README.md` | Point d'entrée du projet |
| `analysis_options.yaml` | Règles de linting |
| `.gitignore` | Fichiers ignorés par Git |
| `l10n.yaml` | Configuration l10n |

---

## 🎯 Conventions

### Nommage des Fichiers

- **Dart :** `snake_case.dart`
- **Configs :** `kebab-case.yaml`
- **Docs :** `kebab-case.md`

### Nommage des Dossiers

- **Features :** `snake_case`
- **Docs :** `kebab-case`

### Organisation

- Un fichier = une responsabilité
- Maximum ~300 lignes par fichier
- Widgets complexes dans des fichiers séparés

---

## 📚 Ressources

- **[Architecture](README.md)** - Vue d'ensemble
- **[Standards de code](coding-standards.md)** - Conventions
- **[Guide développeur](../development/README.md)** - Développement

---

📖 **[Retour à la documentation →](../README.md)**

