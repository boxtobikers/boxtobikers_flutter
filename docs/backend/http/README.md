# 🌐 Client HTTP - Dio

Documentation du service HTTP centralisé utilisant Dio pour BoxToBikers.

---

## 📋 Vue d'Ensemble

Le service HTTP centralisé utilise **Dio** avec le pattern **Singleton** pour gérer toutes les requêtes HTTP de l'application. Il respecte les principes **DRY** et **SOLID**.

---

## 🏗️ Architecture

### Composants Principaux

1. **HttpService** - Service principal avec pattern Singleton
2. **HttpConfig** - Configuration du service
3. **HttpResponse** - Modèle de réponse générique
4. **HttpInterceptor** - Intercepteurs pour auth et logging

### Structure des Fichiers

```
lib/core/http/
├── http_service.dart      # Service principal
├── http_config.dart       # Configuration
├── http_response.dart     # Modèles de réponse
├── http_interceptor.dart  # Intercepteurs
└── index.dart            # Exports
```

---

## 💻 Utilisation

### 1. Initialisation

```dart
import 'package:boxtobikers/core/http/index.dart';

void main() {
  // Initialiser le service HTTP
  HttpService.instance.initialize(HttpConfig.development);
  
  runApp(MyApp());
}
```

### 2. Configuration de l'Authentification

```dart
HttpService.instance.configureAuth(
  getToken: () => 'your-jwt-token',
  refreshToken: () async => 'new-jwt-token',
);
```

### 3. Requêtes HTTP

#### GET
```dart
final response = await HttpService.instance.get<Map<String, dynamic>>('/users');
if (response.success) {
  final data = response.data;
}
```

#### POST
```dart
final response = await HttpService.instance.post<Map<String, dynamic>>(
  '/users',
  data: {'name': 'John', 'email': 'john@example.com'},
);
```

#### PUT
```dart
final response = await HttpService.instance.put<Map<String, dynamic>>(
  '/users/1',
  data: {'name': 'John Updated'},
);
```

#### DELETE
```dart
final response = await HttpService.instance.delete<void>('/users/1');
```

#### Upload de Fichier
```dart
final response = await HttpService.instance.uploadFile<Map<String, dynamic>>(
  '/upload',
  '/path/to/file.jpg',
  fieldName: 'image',
);
```

#### Download de Fichier
```dart
final response = await HttpService.instance.downloadFile(
  '/download/file.pdf',
  '/local/path/file.pdf',
);
```

**[Voir les exemples complets →](examples/example_usage.dart)**

---

## ⚙️ Configuration

### Environnements

```dart
// Développement
HttpConfig.development

// Production
HttpConfig.production

// Configuration personnalisée
HttpConfig(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 30),
  enableLogging: true,
)
```

### Headers par Défaut

```dart
{
  'Content-Type': 'application/json',
  'Accept': 'application/json',
}
```

---

## 🚨 Gestion des Erreurs

Le service gère automatiquement les erreurs et les convertit en `HttpResponse` avec les codes appropriés :

| Code | Description |
|------|-------------|
| **408** | Timeout |
| **401** | Non authentifié |
| **403** | Non autorisé |
| **404** | Non trouvé |
| **500** | Erreur serveur |

---

## 🔌 Intercepteurs

### AuthInterceptor
- Ajoute automatiquement le token d'authentification
- Gère le refresh automatique du token

### LoggingInterceptor
- Log les requêtes et réponses (développement uniquement)
- Affiche les erreurs détaillées

---

## 🎯 Principes SOLID Respectés

1. **Single Responsibility** - Chaque classe a une responsabilité unique
2. **Open/Closed** - Extensible via les intercepteurs
3. **Liskov Substitution** - Les interfaces sont respectées
4. **Interface Segregation** - Interfaces spécifiques
5. **Dependency Inversion** - Dépend d'abstractions

---

## ✨ Avantages

- ✅ Pattern Singleton pour une instance unique
- ✅ Gestion centralisée des requêtes HTTP
- ✅ Configuration flexible par environnement
- ✅ Gestion automatique de l'authentification
- ✅ Logging automatique
- ✅ Gestion d'erreurs robuste
- ✅ Support upload/download
- ✅ Type-safe avec génériques
- ✅ Respect des principes SOLID et DRY

---

## 📚 Ressources

- **[Exemples d'utilisation](examples/example_usage.dart)** - Code d'exemple complet
- **[Documentation Dio](https://pub.dev/packages/dio)** - Package officiel
- **[Guide développeur](../../development/README.md)** - Développement

---

## 🔗 Intégration avec Supabase

Pour les requêtes Supabase, utilisez plutôt le **SupabaseService** qui est optimisé pour ce backend.

**[Guide Supabase →](../supabase/README.md)**

---

📖 **[Retour à la documentation →](../../README.md)**

