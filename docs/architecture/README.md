# 🏗️ Architecture BoxToBikers

Ce document décrit l'architecture globale du projet BoxToBikers.

---

## 📋 Vue d'Ensemble

BoxToBikers est une application Flutter suivant une **architecture en couches** avec séparation claire des responsabilités.

```
┌─────────────────────────────────────────┐
│         Présentation (UI)               │
│  Widgets, Pages, Providers              │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│      Logique Métier (Features)          │
│  Business Logic, Use Cases               │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│         Services & Data                  │
│  Supabase, HTTP, Storage                 │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│         Core & Utils                     │
│  Config, Constants, Helpers              │
└──────────────────────────────────────────┘
```

---

## 📁 Structure du Projet

**[Voir la structure détaillée →](project-structure.md)**

### Principaux Dossiers

```
lib/
├── core/              # Fonctionnalités transverses
│   ├── app/          # Configuration et démarrage de l'app
│   ├── config/       # Variables d'environnement
│   ├── services/     # Services (Supabase, Analytics, etc.)
│   ├── http/         # Client HTTP (Dio)
│   └── drawer/       # Navigation drawer
│
├── features/         # Fonctionnalités métier par module
│   ├── home/        # Module Home
│   ├── auth/        # Module Authentification
│   └── profile/     # Module Profil
│
├── generated/        # Code généré (l10n, etc.)
└── l10n/            # Fichiers d'internationalisation
```

---

## 🎯 Principes de Conception

### 1. **Séparation des Responsabilités**

Chaque couche a sa responsabilité :
- **UI** : Affichage et interactions utilisateur
- **Business Logic** : Règles métier
- **Data** : Accès aux données
- **Core** : Utilitaires transverses

### 2. **Feature-First Organization**

Organisation par fonctionnalité (feature) plutôt que par type de fichier :

```
features/
└── home/
    ├── data/          # Sources de données
    ├── models/        # Modèles de données
    ├── providers/     # State management
    └── ui/
        ├── pages/     # Pages complètes
        └── widgets/   # Widgets réutilisables
```

### 3. **Dependency Injection**

Utilisation de **Provider** pour l'injection de dépendances et le state management.

### 4. **Configuration Centralisée**

Variables d'environnement centralisées dans `lib/core/config/`.

---

## 🔧 Technologies Utilisées

### Framework & Langage

| Technologie | Version | Usage |
|-------------|---------|-------|
| **Flutter** | 3.9.2+ | Framework UI |
| **Dart** | 3.9.2+ | Langage |

### Backend & Data

| Service | Version | Usage |
|---------|---------|-------|
| **Supabase** | 2.10.3 | Backend as a Service |
| **Dio** | 5.9.0 | Client HTTP |

### State Management & UI

| Package | Version | Usage |
|---------|---------|-------|
| **Provider** | 6.1.2 | State Management |
| **FlexColorScheme** | 8.3.0 | Theming |
| **Google Fonts** | 6.3.1 | Typographie |

**[Voir toutes les dépendances →](../../pubspec.yaml)**

---

## 🔄 Flux de Données

### Exemple : Authentification

```
┌─────────────┐
│   Login UI  │  1. L'utilisateur entre ses identifiants
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  AuthProvider   │  2. Provider gère l'état
└──────┬──────────┘
       │
       ▼
┌─────────────────────┐
│  SupabaseService    │  3. Appel au service
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│  Supabase Backend   │  4. API Backend
└──────┬──────────────┘
       │
       ▼
┌─────────────────┐
│  AuthProvider   │  5. Mise à jour de l'état
└──────┬──────────┘
       │
       ▼
┌─────────────┐
│   Home UI   │  6. Navigation vers Home
└─────────────┘
```

---

## 📦 Modules Principaux

### Core Module

**Responsabilité** : Fonctionnalités transverses utilisées par toute l'app

**Contenu** :
- Configuration (EnvConfig)
- Services (Supabase, HTTP)
- Constants
- Utilitaires

### Features Modules

**Responsabilité** : Fonctionnalités métier isolées

**Structure type** :
```
feature_name/
├── data/
│   └── repositories/
├── models/
├── providers/
└── ui/
    ├── pages/
    └── widgets/
```

---

## 🎨 Patterns Utilisés

### 1. **Singleton**

Utilisé pour les services (ex: SupabaseService)

```text
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }
  SupabaseService._();
}
```

### 2. **Provider Pattern**

State management avec ChangeNotifier

```text
class AppStateProvider extends ChangeNotifier {
  // État
  ThemeMode _themeMode = ThemeMode.system;
  
  // Getter
  ThemeMode get themeMode => _themeMode;
  
  // Setter avec notification
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
```

### 3. **Repository Pattern**

Abstraction de l'accès aux données (à implémenter si nécessaire)

---

## 🔐 Sécurité

### Variables d'Environnement

- Stockées dans `config/*.json`
- Chargées via `--dart-define-from-file`
- Jamais committées (sauf example.json)

**[Guide complet →](../environment/README.md)**

### Row Level Security (RLS)

Supabase utilise RLS pour sécuriser les données au niveau de la base.

**[Documentation Supabase →](../backend/supabase/README.md)**

---

## 🧪 Tests

### Structure des Tests

```
test/
├── core/
│   ├── config/
│   └── services/
├── features/
│   └── home/
└── widget_app_test.dart
```

### Types de Tests

- **Unit Tests** : Logique métier
- **Widget Tests** : UI Components
- **Integration Tests** : Flux complets

**[Guide développeur →](../development/README.md)**

---

## 📊 Performance

### Bonnes Pratiques

- ✅ Lazy loading des widgets
- ✅ Const constructors quand possible
- ✅ Optimisation des rebuilds avec Provider
- ✅ Mise en cache des données

---

## 🚀 Déploiement

### Environnements

| Environnement | Config | Usage |
|---------------|--------|-------|
| **Development** | `config/dev.json` | Développement local |
| **Staging** | `config/staging.json` | Tests pré-production |
| **Production** | `config/prod.json` | Application finale |

### Build

```bash
# Android
make build-android-prod

# iOS
make build-ios-prod
```

---

## 📚 Ressources

- **[Structure détaillée](project-structure.md)** - Tous les dossiers expliqués
- **[Guide développeur](../development/README.md)** - Développement quotidien

---

## 🔄 Évolution de l'Architecture

### En cours
- 🚧 Ajout de tests unitaires
- 🚧 Documentation des features
- 🚧 Migration vers Go Router (optionnel)

### Futur
- 📋 Implémentation du Repository Pattern
- 📋 Ajout de tests d'intégration
- 📋 CI/CD complet

---

📖 **[Retour à l'index de la documentation](../README.md)**

---

*Architecture maintenue par l'équipe BoxToBikers*  
*Dernière mise à jour : Octobre 2025*

