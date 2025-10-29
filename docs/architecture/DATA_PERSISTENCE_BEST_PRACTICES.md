# 💾 Bonnes Pratiques - Persistance des Données Utilisateur

## 📋 Vue d'ensemble

Ce document explique comment les données utilisateur sont gérées dans l'application BoxToBikers et comment y accéder depuis n'importe où dans votre code.

## 🏗️ Architecture de Persistance

### Système Hybride (Supabase + SharedPreferences)

```
┌─────────────────────────────────────────────────────────┐
│                    Application Flutter                   │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌─────────────────┐      ┌─────────────────┐          │
│  │  AuthProvider   │◄─────┤ SessionService  │          │
│  │  (State Mgmt)   │      │  (Persistence)  │          │
│  └────────┬────────┘      └────────┬────────┘          │
│           │                        │                     │
│           │                        │                     │
│  ┌────────▼────────┐      ┌───────▼────────┐           │
│  │ AuthRepository  │      │ SharedPrefs    │           │
│  │   (Business)    │      │  WithCache     │           │
│  └────────┬────────┘      └────────────────┘           │
│           │                                              │
└───────────┼──────────────────────────────────────────────┘
            │
    ┌───────▼────────┐
    │    Supabase    │
    │   (Backend)    │
    └────────────────┘
```

## ✅ Pourquoi SharedPreferences est la bonne pratique ?

### Avantages pour votre cas d'usage

1. **✅ Léger et Rapide**
   - Parfait pour des données simples comme un profil utilisateur
   - Pas besoin d'une base de données locale complète

2. **✅ Persiste entre les redémarrages**
   - Les données restent disponibles même après fermeture de l'app
   - Parfait pour maintenir une session VISITOR

3. **✅ SharedPreferencesWithCache (Performance)**
   - Vous utilisez déjà la version optimisée avec cache en mémoire
   - Accès instantané sans I/O après le premier chargement

4. **✅ Synchronisation Automatique**
   - Les données Supabase sont automatiquement sauvegardées localement
   - Disponibles même hors connexion

### Alternatives et Quand les Utiliser

| Solution | Quand l'utiliser | Pourquoi PAS pour vous |
|----------|------------------|------------------------|
| **SQLite/Hive** | Grandes quantités de données, requêtes complexes | Trop lourd pour juste un profil |
| **Secure Storage** | Données sensibles (tokens, mots de passe) | Déjà géré par Supabase |
| **Supabase seul** | Toujours en ligne | Pas de données hors connexion |

## 📦 Comment Accéder aux Données Utilisateur

### 1️⃣ Dans un Widget (Avec Rebuild Automatique)

```dart
import 'package:provider/provider.dart';

class MonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 🔥 context.watch = Le widget se rebuild quand les données changent
    final authProvider = context.watch<AuthProvider>();
    final userSession = authProvider.currentSession;
    final userProfile = userSession?.profile;

    return Text('Bonjour ${userProfile?.firstName ?? "Visiteur"}');
  }
}
```

### 2️⃣ Dans une Méthode (Sans Rebuild)

```dart
void _maMethode(BuildContext context) {
  // 🔥 context.read = Accès ponctuel sans rebuild
  final authProvider = context.read<AuthProvider>();
  final email = authProvider.currentSession?.email ?? '';
  
  print('Email: $email');
}
```

### 3️⃣ Dans un Consumer (Partial Rebuild)

```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    final userName = authProvider.currentSession?.profile.fullName;
    return Text(userName ?? 'Visiteur');
  },
)
```

### 4️⃣ Widget Réutilisable Créé pour Vous

```dart
// Widget prêt à l'emploi
UserInfoDisplayWidget(
  showEmail: true,
  showRole: true,
  compact: false,
)
```

## 🔄 Flux de Données

### Chargement au Démarrage

```
1. App démarre
   ↓
2. AuthProvider.initialize()
   ↓
3. SessionService.loadSession()
   ↓
4. SharedPreferences → UserSession
   ↓
5. Données disponibles partout via Provider
```

### Mise à Jour des Données

```
1. Utilisateur modifie son profil
   ↓
2. authProvider.updateSession(newSession)
   ↓
3. ├─→ Supabase (si authentifié)
   └─→ SharedPreferences (toujours)
   ↓
4. notifyListeners() → Tous les widgets écoutent
   ↓
5. Rebuild automatique des UI concernées
```

## 💡 Exemples Pratiques

### Afficher le nom dans un AppBar

```dart
AppBar(
  title: Consumer<AuthProvider>(
    builder: (context, auth, _) {
      return Text('Bonjour ${auth.currentSession?.profile.firstName ?? ""}');
    },
  ),
)
```

### Afficher le profil dans le Drawer

```dart
// ✅ Déjà implémenté dans app_navigation_drawer.widget.dart
final authProvider = context.watch<AuthProvider>();
final userProfile = authProvider.currentSession?.profile;

UserAccountsDrawerHeader(
  accountName: Text(userProfile?.fullName ?? 'Utilisateur'),
  accountEmail: Text(userSession?.email ?? 'Non connecté'),
  // ...
)
```

### Sauvegarder un profil modifié

```dart
// ✅ Déjà implémenté dans profil.pages.dart
Future<void> _saveProfile() async {
  final authProvider = context.read<AuthProvider>();
  final currentSession = authProvider.currentSession!;
  
  final updatedProfile = UserProfileModel(
    firstName: _firstNameController.text,
    // ...
  );
  
  final updatedSession = currentSession.copyWith(
    profile: updatedProfile,
  );
  
  // 🔥 Cette ligne fait TOUT:
  // - Sauvegarde dans Supabase (si authentifié)
  // - Sauvegarde dans SharedPreferences
  // - Notifie tous les listeners
  await authProvider.updateSession(updatedSession);
}
```

## 🎯 Principes SOLID Respectés

### 1. Single Responsibility Principle (SRP)
- ✅ `SessionService`: Gère UNIQUEMENT la persistance
- ✅ `AuthRepository`: Gère UNIQUEMENT la logique métier
- ✅ `AuthProvider`: Gère UNIQUEMENT l'état

### 2. Open/Closed Principle (OCP)
- ✅ Facile d'ajouter d'autres sources de données sans modifier le code existant

### 3. Dependency Inversion Principle (DIP)
- ✅ `AuthProvider` dépend d'abstractions, pas d'implémentations concrètes

### 4. Don't Repeat Yourself (DRY)
- ✅ Une seule source de vérité: `AuthProvider.currentSession`
- ✅ Pas de duplication de données

## 🚀 Conclusion

Votre architecture actuelle est **EXCELLENTE** et suit toutes les bonnes pratiques Flutter :

1. ✅ SharedPreferences pour la persistance locale
2. ✅ Provider pour la gestion d'état globale
3. ✅ Synchronisation automatique avec Supabase
4. ✅ Principes SOLID respectés
5. ✅ Données disponibles partout dans l'app
6. ✅ Rebuild automatique des widgets concernés

### À Retenir

```dart
// 🔥 Pour accéder aux données utilisateur PARTOUT:
final authProvider = context.watch<AuthProvider>(); // Dans un widget
final authProvider = context.read<AuthProvider>();  // Dans une méthode

// 🔥 Les données sont TOUJOURS synchronisées:
final userProfile = authProvider.currentSession?.profile;

// 🔥 Pour modifier les données:
await authProvider.updateSession(newSession);
// → Sauvegarde automatique dans SharedPreferences + Supabase
```

## 📚 Fichiers Clés à Connaître

```
lib/core/auth/
├── providers/auth.provider.dart          ← État global (Provider)
├── services/session.service.dart         ← Persistance (SharedPrefs)
├── repositories/auth.repository.dart     ← Logique métier (Supabase)
└── models/user_session.model.dart        ← Modèle de données

lib/core/auth/ui/widgets/
└── user_info_display.widget.dart         ← Widget réutilisable

lib/core/drawer/ui/widgets/
└── app_navigation_drawer.widget.dart     ← Exemple d'utilisation

lib/features/profil/ui/pages/
└── profil.pages.dart                     ← Exemple de modification
```

## ❓ Questions Fréquentes

**Q: Les données sont-elles sécurisées dans SharedPreferences ?**
A: SharedPreferences est sûr pour des données non-sensibles comme un profil. Les tokens Supabase sont gérés séparément par le SDK Supabase de manière sécurisée.

**Q: Que se passe-t-il si je suis hors ligne ?**
A: Les données locales restent disponibles via SharedPreferences. À la reconnexion, Supabase se synchronise automatiquement.

**Q: Comment gérer plusieurs utilisateurs sur un même appareil ?**
A: Lors de la déconnexion, `signOut()` efface les données et crée une nouvelle session VISITOR.

**Q: Les données survivent-elles à une mise à jour de l'app ?**
A: Oui, SharedPreferences persiste entre les mises à jour de l'application.

