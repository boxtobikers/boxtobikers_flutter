# 👨‍💻 Guide Développeur - BoxToBikers

Guide pratique pour le développement quotidien sur BoxToBikers.

---

## 🚀 Démarrage Quotidien

### Lancement de l'Application

```bash
# Méthode 1 : Makefile (recommandé)
make dev

# Méthode 2 : Flutter direct
flutter run --dart-define-from-file=config/dev.json

# Méthode 3 : VS Code
# Appuyez sur F5 → "BoxToBikers (Development)"
```

---

## 🔥 Hot Reload

### Raccourcis

| Action | Raccourci | Description |
|--------|-----------|-------------|
| **Hot Reload** | `r` | Recharger le code sans perdre l'état |
| **Hot Restart** | `R` | Redémarrer l'app complètement |
| **Quit** | `q` | Quitter l'application |
| **Help** | `h` | Afficher l'aide |

### Bonnes Pratiques

- ✅ Utilisez **hot reload** (`r`) pour les changements UI
- ✅ Utilisez **hot restart** (`R`) pour les changements de state/providers
- ✅ Redémarrez complètement pour les changements de configuration
- ✅ Hot reload ne fonctionne pas pour :
  - Fichiers de localisation (.arb)
  - Variables d'environnement
  - Modifications du `main()`

---

## 🧰 Commandes Utiles

```bash
# Développement
make dev              # Lancer en dev
make test             # Tests
make clean            # Nettoyer

# Build
make build-android-prod
make build-ios-prod

# Voir toutes les commandes
make help
```

**[Voir le Makefile complet →](../../Makefile)**

---

## 🏗️ Structure du Projet

```
lib/
├── core/              # Code transverse
│   ├── app/          # App launcher, providers
│   ├── config/       # Variables d'env
│   ├── services/     # Services (Supabase, etc.)
│   └── http/         # Client HTTP
│
├── features/         # Modules métier
│   └── home/        # Module Home
│       ├── models/
│       ├── providers/
│       └── ui/
│           ├── pages/
│           └── widgets/
│
├── generated/        # Code généré
└── l10n/            # Internationalisation
```

**[Architecture complète →](../architecture/README.md)**

---

## 📝 Conventions de Code

### Nommage

```text
// Classes : PascalCase
class UserProfile {}

// Méthodes/variables : camelCase
void getUserProfile() {}
String userName = '';

// Constantes : camelCase avec const
const double padding = 16.0;

// Fichiers : snake_case
user_profile_page.dart
```

### Organisation

```text
// Import order
import 'dart:async';                    // Dart SDK
import 'package:flutter/material.dart'; // Flutter
import 'package:provider/provider.dart';// Packages
import 'package:boxtobikers/...';       // Projet

// Class structure
class MyWidget extends StatelessWidget {
  // 1. Constantes statiques
  static const double _padding = 16.0;
  
  // 2. Propriétés
  final String title;
  
  // 3. Constructeur
  const MyWidget({super.key, required this.title});
  
  // 4. Méthodes override
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // 5. Méthodes privées
  void _onTap() {}
}
```

---

## 🧪 Tests

### Lancer les Tests

```bash
# Tous les tests
make test

# Tests spécifiques
flutter test test/core/config/env_config_test.dart

# Avec couverture
make test-coverage
```

### Écrire des Tests

```text
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyClass', () {
    test('should do something', () {
      // Arrange
      final myClass = MyClass();
      
      // Act
      final result = myClass.doSomething();
      
      // Assert
      expect(result, equals(expected));
    });
  });
}
```

---

## 🔧 Outils de Développement

### Analyse du Code

```bash
# Analyser le code
flutter analyze

# Formater le code
flutter format lib/
```

### DevTools

```bash
# Lancer DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 🐛 Debugging

### Logs

```text
import 'package:boxtobikers/core/config/env_config.dart';

// Logs uniquement en dev
if (EnvConfig.isDevelopment) {
  debugPrint('Debug info: $value');
}
```

### Breakpoints

- VS Code : Cliquez à gauche du numéro de ligne
- Lancez en mode debug (`F5`)

---

## 📚 Ressources

- **[App Launcher](app-launcher.md)** - Système de démarrage
- **[Architecture](../architecture/README.md)** - Structure du projet

---

📖 **[Retour à la documentation →](../README.md)**

