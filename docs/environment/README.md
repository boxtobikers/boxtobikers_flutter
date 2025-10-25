# 🔧 Variables d'Environnement - Guide Technique

Documentation technique complète pour la gestion des variables d'environnement dans BoxToBikers.

---

## 📋 Vue d'Ensemble

Ce projet utilise la méthode officielle Flutter `--dart-define-from-file` pour gérer les variables d'environnement de manière sécurisée et professionnelle.

### Avantages

- ✅ **Sécurisé** - Variables compilées dans l'app, pas de fichiers à lire
- ✅ **Officiel** - Support natif Flutter, aucune dépendance externe
- ✅ **Multi-plateformes** - Fonctionne sur iOS, Android, Web, Desktop
- ✅ **Multi-environnements** - local/dev/prod facilement gérables
- ✅ **Type-safe** - Vérification à la compilation
- ✅ **Détection automatique** - Android émulateur géré automatiquement

---

## 📁 Structure des Fichiers

```
config/
├── .gitkeep              # Garde le dossier dans Git
├── example.json          # Template (✅ commité)
├── local.json            # Docker local (✅ commité)
├── dev.json              # Development (❌ ignoré)
└── prod.json             # Production (❌ ignoré)
```

**Note** : `local.json` est commité car il ne contient pas de secrets (utilise Docker local).

---

## 🌍 Environnements

### 1. Local (Docker) ⭐ NOUVEAU

**Usage** : Développement local sans connexion Internet

```bash
make local
```

**Configuration** : `config/local.json`
```json
{
  "ENV": "local"
}
```

**Caractéristiques** :
- ✅ Utilise Docker Supabase (http://localhost:54321)
- ✅ Détection automatique Android (http://10.0.2.2:54321)
- ✅ Clé Supabase hardcodée (sécurisé pour local)
- ✅ Pas besoin de connexion Internet
- ✅ Base de données isolée

### 2. Development (Supabase.io)

**Usage** : Développement sur le cloud

```bash
make dev
```

**Configuration** : `config/dev.json`
```json
{
  "SUPABASE_URL": "https://xxx.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGc...",
  "API_URL": "https://api-dev.boxtobikers.com",
  "ENV": "development"
}
```

### 3. Production (Supabase.io)

**Usage** : Application en production

```bash
make prod
```

**Configuration** : `config/prod.json`
```json
{
  "SUPABASE_URL": "https://prod.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGc...",
  "API_URL": "https://api.boxtobikers.com",
  "ENV": "production"
}
```

---

## 🔑 Variables Disponibles

| Variable | Type | Description | Exemple |
|----------|------|-------------|---------|
| `SUPABASE_URL` | String | URL instance Supabase | `https://xxx.supabase.co` |
| `SUPABASE_ANON_KEY` | String | Clé anonyme publique | `eyJhbGc...` |
| `API_URL` | String | URL API backend | `https://api.example.com` |
| `ENV` | String | Environnement | `development` |

---

## 💻 Utilisation

### Dans le Code

```text
import 'package:boxtobikers/core/config/env_config.dart';

// Accéder aux variables
String url = EnvConfig.supabaseUrl;
String key = EnvConfig.supabaseAnonKey;

// Vérifier l'environnement
if (EnvConfig.isDevelopment) {
  print('Mode dev');
}

// Valider la configuration
EnvConfig.validate(); // Throws si invalide
```

**[Voir l'exemple complet →](examples/main_with_env_example.dart)**

### Lancement

```bash
# Local (Docker)
make local
# ou : flutter run --dart-define-from-file=config/local.json

# Développement (Supabase.io)
make dev
# ou : flutter run --dart-define-from-file=config/dev.json

# Production (Supabase.io)
make prod
# ou : flutter run --dart-define-from-file=config/prod.json
```

### VS Code

Configurations disponibles dans `.vscode/launch.json` :
- BoxToBikers (Local) - Docker
- BoxToBikers (Development) - Supabase.io
- BoxToBikers (Production) - Supabase.io

---

## 🏗️ Build

### Android

```bash
flutter build apk --release --dart-define-from-file=config/prod.json
```

### iOS

```bash
flutter build ios --release --dart-define-from-file=config/prod.json
```

---

## 🔒 Sécurité

### Fichiers Protégés

Le `.gitignore` contient :
```gitignore
# Variables d'environnement
config/*.json
!config/example.json
```

### Validation

L'application vérifie la configuration au démarrage :

```text
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    EnvConfig.validate();
  } catch (e) {
    // L'app refuse de démarrer si config invalide
    debugPrint('❌ Configuration invalide : $e');
    rethrow;
  }
  
  runApp(MyApp());
}
```

---

## 🧪 Tests

### Tests Unitaires

```bash
flutter test test/core/config/env_config_test.dart
```

### Script de Vérification

```bash
./check_env_config.sh
```

---

## 📚 Ressources

- **[Configuration rapide](configuration.md)** - Guide pas à pas
- **[Quick Start](../getting-started/quick-start.md)** - Démarrage rapide
- **[Exemple de code](examples/main_with_env_example.dart)** - Exemple d'utilisation

### Documentation Externe

- [Flutter --dart-define](https://docs.flutter.dev/deployment/flavors)
- [12 Factor App](https://12factor.net/config)

---

## ❗ Troubleshooting

### Variables vides

```text
// Vérifiez que la commande inclut --dart-define-from-file
flutter run --dart-define-from-file=config/dev.json
```

### Erreur de compilation

```bash
# Nettoyez et relancez
flutter clean
flutter pub get
flutter run --dart-define-from-file=config/dev.json
```

---

📖 **[Retour à la documentation →](../README.md)**

