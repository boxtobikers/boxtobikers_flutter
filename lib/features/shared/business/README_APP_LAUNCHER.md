# App Launcher & State Management

## 📁 Architecture

Le système de lancement et de gestion d'état de l'application est organisé dans `lib/features/shared/business/` :

```
lib/features/shared/business/
├── app_launcher.dart           # Point d'entrée principal
├── models/
│   └── currency.dart          # Énumération des devises
├── services/
│   └── preferences_service.dart # Service de persistance
└── providers/
    └── app_state_provider.dart  # Provider d'état global
```

## 🎯 Fonctionnalités

### 1. AppLauncher
**Responsabilité** : Initialiser l'application au démarrage ou au réveil

**Comportements** :
- **Au DÉMARRAGE** : charge les préférences du device (thème, langue) et les préférences sauvegardées
- **Au RÉVEIL** : conserve les préférences utilisateur modifiées (pas d'écrasement)
- **Au REDÉMARRAGE** : réinitialise tout depuis le device

### 2. Currency (Modèle)
**Responsabilité** : Gérer les devises supportées

**Fonctionnalités** :
- Énumération des devises : Euro, Dollar, Pound, Yen
- Mapping automatique langue → devise (FR → Euro, US → Dollar, etc.)
- Conversion depuis symbole ou code

### 3. PreferencesService
**Responsabilité** : Gérer la persistance des données avec SharedPreferences

**Données persistées** :
- `ThemeMode` : mode de thème (light/dark/system)
- `Locale` : langue de l'application
- `Currency` : devise choisie par l'utilisateur
- `isFirstLaunch` : indicateur de premier lancement

### 4. AppStateProvider
**Responsabilité** : Gérer l'état global de l'application (ChangeNotifier)

**État géré** :
- Thème actuel
- Langue actuelle
- Devise actuelle
- État d'initialisation

## 🔄 Cycle de vie

### Démarrage de l'application
```
1. main() → AppLauncher.initialize()
2. Création du PreferencesService
3. Création du AppStateProvider
4. Injection dans MaterialApp via Provider
5. initializeFromDevice() depuis le BuildContext
6. Chargement des préférences sauvegardées OU valeurs du device
```

### Réveil de l'application
```
1. AppLauncher.initialize() détecte l'instance existante
2. Retourne l'instance existante (préférences conservées)
3. L'utilisateur retrouve ses préférences personnalisées
```

### Redémarrage complet
```
1. AppLauncher.reset()
2. Suppression de toutes les préférences
3. Au prochain démarrage → réinitialisation depuis le device
```

## 💡 Principes SOLID appliqués

### Single Responsibility Principle (SRP)
- `Currency` : gère uniquement les devises
- `PreferencesService` : gère uniquement la persistance
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
- `AppStateProvider` dépend de `PreferencesService` (abstraction)
- `AppLauncher` dépend de `PreferencesService` et `AppStateProvider`

## 🔨 Principe DRY

### Centralisation
- Toute la logique de mapping langue → devise est dans `Currency.fromLocale()`
- Toute la logique de persistance est dans `PreferencesService`
- Toute la logique d'initialisation est dans `AppLauncher.initialize()`

### Réutilisation
- `Currency.fromLocale()` : utilisé pour déterminer la devise par défaut
- `PreferencesService` : utilisé par le provider et peut être utilisé ailleurs
- `AppStateProvider` : accessible partout via Provider

## 📖 Utilisation

### Dans main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser l'application
  final appStateProvider = await AppLauncher.initialize();
  
  runApp(MyApp(appStateProvider: appStateProvider));
}
```

### Dans un widget (lecture)
```dart
final appState = Provider.of<AppStateProvider>(context);
final currentCurrency = appState.currency;
final currentLocale = appState.locale;
```

### Dans un widget (modification)
```dart
final appState = Provider.of<AppStateProvider>(context, listen: false);

// Changer la devise
await appState.setCurrency(Currency.dollar);

// Changer la langue
await appState.setLocale(Locale('en', 'US'));

// Changer le thème
await appState.setThemeMode(ThemeMode.dark);
```

### Réinitialiser l'application
```dart
await AppLauncher.reset();
// Au prochain démarrage, tout sera réinitialisé
```

## 🎨 Exemple : Page Settings

La page Settings utilise maintenant le provider global :

```dart
final appState = Provider.of<AppStateProvider>(context);

DropdownButton<Currency>(
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
)
```

## 🔍 Notes importantes

1. **Persistance** : Les modifications de l'utilisateur persistent jusqu'au redémarrage complet de l'app
2. **Réveil** : Quand l'app revient du background, les préférences sont conservées
3. **Démarrage** : Au démarrage, priorité aux préférences sauvegardées sur celles du device
4. **Thread-safe** : Utilise SharedPreferences qui est thread-safe
5. **Réactivité** : Le ChangeNotifier notifie automatiquement tous les widgets Consumer

## ⚙️ Installation

Les dépendances suivantes ont été ajoutées dans `pubspec.yaml` :

```yaml
dependencies:
  shared_preferences: ^2.3.3  # Persistance des données
  provider: ^6.1.2            # Gestion d'état
```

Exécutez :
```bash
flutter pub get
```

