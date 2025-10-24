# 🚀 App Launcher & State Management

Guide du système de lancement et de gestion d'état de l'application BoxToBikers.

---

## 📁 Architecture

Le système est organisé dans `lib/core/app/` :

```
lib/core/app/
├── app_launcher.dart           # Point d'entrée principal
├── models/
│   └── currency.dart          # Énumération des devises
├── services/
│   └── preferences_service.dart # Service de persistance
└── providers/
    └── app_state_provider.dart  # Provider d'état global
```

---

## 🎯 Composants Principaux

### 1. AppLauncher

**Responsabilité :** Initialiser l'application au démarrage ou au réveil

**Comportements :**
- **Au DÉMARRAGE** : charge les préférences du device (thème, langue) et les préférences sauvegardées
- **Au RÉVEIL** : conserve les préférences utilisateur modifiées (pas d'écrasement)
- **Au REDÉMARRAGE** : réinitialise tout depuis le device

### 2. Currency (Modèle)

**Responsabilité :** Gérer les devises supportées

**Fonctionnalités :**
- Énumération des devises : Euro, Dollar, Pound, Yen
- Mapping automatique langue → devise (FR → Euro, US → Dollar, etc.)
- Conversion depuis symbole ou code

### 3. SettingsService

**Responsabilité :** Gérer la persistance des données avec SharedPreferences

**Données persistées :**
- `ThemeMode` : mode de thème (light/dark/system)
- `Locale` : langue de l'application
- `Currency` : devise choisie par l'utilisateur
- `isFirstLaunch` : indicateur de premier lancement

### 4. AppStateProvider

**Responsabilité :** Gérer l'état global de l'application (ChangeNotifier)

**État géré :**
- Thème actuel
- Langue actuelle
- Devise actuelle
- État d'initialisation

---

## 🔄 Cycle de Vie

### Démarrage de l'Application

```
1. main() → AppLauncher.initialize()
2. Création du SettingsService
3. Création du AppStateProvider
4. Injection dans MaterialApp via Provider
5. initializeFromDevice() depuis le BuildContext
6. Chargement des préférences sauvegardées OU valeurs du device
```

### Réveil de l'Application

```
1. AppLauncher.initialize() détecte l'instance existante
2. Retourne l'instance existante (préférences conservées)
3. L'utilisateur retrouve ses préférences personnalisées
```

### Redémarrage Complet

```
1. AppLauncher.reset()
2. Suppression de toutes les préférences
3. Au prochain démarrage → réinitialisation depuis le device
```

---

## 💻 Utilisation

### Dans main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser l'application
  final appStateProvider = await AppLauncher.initialize();
  
  runApp(MyApp(appStateProvider: appStateProvider));
}
```

### Lire l'État dans un Widget

```dart
final appState = Provider.of<AppStateProvider>(context);
final currentCurrency = appState.currency;
final currentLocale = appState.locale;
final currentTheme = appState.themeMode;
```

### Modifier l'État

```dart
final appState = Provider.of<AppStateProvider>(context, listen: false);

// Changer la devise
await appState.setCurrency(Currency.dollar);

// Changer la langue
await appState.setLocale(Locale('en', 'US'));

// Changer le thème
await appState.setThemeMode(ThemeMode.dark);
```

### Réinitialiser l'Application

```dart
await AppLauncher.reset();
// Au prochain démarrage, tout sera réinitialisé
```

---

## 🎨 Exemple : Page Settings

```dart
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          // Sélecteur de devise
          ListTile(
            title: Text('Devise'),
            trailing: DropdownButton<Currency>(
              value: appState.currency,
              items: Currency.values.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text('${currency.name} (${currency.symbol})'),
                );
              }).toList(),
              onChanged: (currency) {
                if (currency != null) {
                  appState.setCurrency(currency);
                }
              },
            ),
          ),
          
          // Sélecteur de thème
          ListTile(
            title: Text('Thème'),
            trailing: DropdownButton<ThemeMode>(
              value: appState.themeMode,
              items: [
                DropdownMenuItem(value: ThemeMode.light, child: Text('Clair')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Sombre')),
                DropdownMenuItem(value: ThemeMode.system, child: Text('Système')),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  appState.setThemeMode(mode);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 💡 Principes SOLID Appliqués

### Single Responsibility Principle (SRP)
- `Currency` : gère uniquement les devises
- `SettingsService` : gère uniquement la persistance
- `AppStateProvider` : gère uniquement l'état
- `AppLauncher` : gère uniquement l'initialisation

### Open/Closed Principle (OCP)
- `Currency` : extensible (ajout de nouvelles devises) sans modification
- `AppStateProvider` : peut être étendu avec de nouvelles préférences

### Liskov Substitution Principle (LSP)
- `AppStateProvider` hérite correctement de `ChangeNotifier`

### Interface Segregation Principle (ISP)
- Chaque classe expose uniquement les méthodes nécessaires

### Dependency Inversion Principle (DIP)
- `AppStateProvider` dépend de `SettingsService` (abstraction)
- `AppLauncher` dépend de `SettingsService` et `AppStateProvider`

---

## 🔨 Principe DRY

### Centralisation
- Toute la logique de mapping langue → devise est dans `Currency.fromLocale()`
- Toute la logique de persistance est dans `SettingsService`
- Toute la logique d'initialisation est dans `AppLauncher.initialize()`

### Réutilisation
- `Currency.fromLocale()` : utilisé pour déterminer la devise par défaut
- `SettingsService` : utilisé par le provider et peut être utilisé ailleurs
- `AppStateProvider` : accessible partout via Provider

---

## 🔍 Notes Importantes

1. **Persistance** : Les modifications de l'utilisateur persistent jusqu'au redémarrage complet de l'app
2. **Réveil** : Quand l'app revient du background, les préférences sont conservées
3. **Démarrage** : Au démarrage, priorité aux préférences sauvegardées sur celles du device
4. **Thread-safe** : Utilise SharedPreferences qui est thread-safe
5. **Réactivité** : Le ChangeNotifier notifie automatiquement tous les widgets Consumer

---

## ⚙️ Dépendances

Les dépendances suivantes sont utilisées :

```yaml
dependencies:
  shared_preferences: ^2.3.3  # Persistance des données
  provider: ^6.1.2            # Gestion d'état
```

---

## 📚 Ressources

- **[Guide développeur](README.md)** - Guide général
- **[Architecture](../architecture/README.md)** - Vue d'ensemble
- **[Provider Package](https://pub.dev/packages/provider)** - Documentation officielle
- **[SharedPreferences](https://pub.dev/packages/shared_preferences)** - Documentation officielle

---

📖 **[Retour à la documentation →](../README.md)**

