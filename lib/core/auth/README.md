# Système d'Authentification BoxToBikers

## Architecture

Le système d'authentification suit les principes SOLID et DRY avec une architecture en couches :

```
lib/core/auth/
├── models/              # Modèles de données
│   ├── auth_status.enum.dart
│   ├── user_role.enum.dart
│   └── user_session.model.dart
├── repositories/        # Accès aux données Supabase
│   └── auth.repository.dart
├── services/           # Logique métier et persistance
│   └── session.service.dart
├── providers/          # État réactif de l'application
│   └── auth.provider.dart
├── widgets/            # Composants UI réutilisables
│   └── auth_guard.widget.dart
└── auth.dart           # Export centralisé
```

## Flux d'authentification

### 1. Démarrage de l'application

```
1. AppLauncher.initialize()
   ├─ Initialise Supabase
   ├─ Initialise HttpService (Dio)
   ├─ Crée SessionService
   ├─ Crée AuthRepository
   ├─ Crée AuthProvider
   └─ AuthProvider.initialize()
      ├─ Vérifie session Supabase active
      ├─ Sinon, charge session locale
      └─ Sinon, crée session anonyme (VISITOR)
```

### 2. Session anonyme (par défaut)

- Utilisateur : `auth.users` avec `is_anonymous = true`
- Profil : `public.profiles` avec `role = VISITOR`
- Permissions : Lecture seule sur les destinations

### 3. Connexion utilisateur

```dart
final authProvider = Provider.of<AuthProvider>(context);
await authProvider.signInWithEmail(
  email: 'user@example.com',
  password: 'password123',
);
```

### 4. Inscription utilisateur

```dart
await authProvider.signUpWithEmail(
  email: 'newuser@example.com',
  password: 'password123',
  firstName: 'John',
  lastName: 'Doe',
);
```

## Utilisation

### Accéder à la session actuelle

```dart
// Dans un widget
final authProvider = Provider.of<AuthProvider>(context);
final session = authProvider.currentSession;

if (session != null) {
  print('User: ${session.profile.fullName}');
  print('Role: ${session.role.value}');
  print('Email: ${session.email}');
  print('Is anonymous: ${session.isAnonymous}');
}
```

### Protéger une page avec AuthGuard

```dart
// Méthode 1 : Wrapper direct
AuthGuard(
  allowedRoles: [UserRole.client, UserRole.admin],
  child: MyProtectedPage(),
)

// Méthode 2 : Extension
MyProtectedPage().withAuthGuard(
  allowedRoles: [UserRole.client, UserRole.admin],
  deniedMessage: 'Vous devez être connecté pour accéder à cette page',
)
```

### Vérifier les permissions

```dart
final session = authProvider.currentSession;

if (session?.role.isAdmin ?? false) {
  // Actions administrateur
}

if (session?.role.isAuthenticated ?? false) {
  // Actions utilisateur connecté
}

if (session?.isAnonymous ?? true) {
  // Actions visiteur
}
```

## Rôles

| Rôle | Valeur BDD | Description |
|------|-----------|-------------|
| VISITOR | `VISITOR` | Utilisateur anonyme - lecture seule |
| CLIENT | `CLIENT` | Utilisateur authentifié - fonctionnalités complètes |
| ADMIN | `ADMIN` | Administrateur - accès complet |

## Base de données

### Table `public.roles`
```sql
- id (UUID)
- name (TEXT) : 'ADMIN', 'VISITOR', 'CLIENT'
- created_at (TIMESTAMPTZ)
```

### Table `public.profiles`
```sql
- id (UUID) -> auth.users(id)
- role_id (UUID) -> roles(id)
- first_name (TEXT)
- last_name (TEXT)
- email (TEXT)
- mobile (TEXT)
- address (TEXT)
- created_at (TIMESTAMPTZ)
```

### Trigger automatique

Lors de la création d'un utilisateur (anonyme ou authentifié), le trigger `handle_new_user()` crée automatiquement un profil avec le rôle `VISITOR`.

## Persistance

La session est sauvegardée localement avec `SharedPreferencesWithCache` pour :
- Éviter de recréer une session anonyme à chaque démarrage
- Restaurer la session après un redémarrage de l'app
- Améliorer les performances (cache en mémoire)

## Sécurité

### RLS (Row Level Security)

Les policies Supabase sont configurées pour :
- **Destinations** : Lecture publique (anonymous peut voir)
- **Profiles** : Chaque user voit/modifie son propre profil
- **Rides** : Chaque user gère ses propres trajets
- **Ratings** : Lecture publique, écriture par le propriétaire

### Guards côté client

Les `AuthGuard` protègent les routes mais ne remplacent PAS la sécurité côté serveur (RLS).

## Tests

```dart
// Créer un SessionService pour les tests
final sessionService = await SessionService.createForTesting();

// Créer un AuthProvider mocké
final authProvider = AuthProvider(
  authRepository: MockAuthRepository(),
  sessionService: sessionService,
);
```

## Bonnes pratiques

1. **Toujours vérifier la session** avant d'afficher des données sensibles
2. **Utiliser AuthGuard** pour les pages nécessitant une authentification
3. **Ne jamais stocker de mots de passe** dans la session locale
4. **Écouter les changements** de session avec `Consumer<AuthProvider>`
5. **Gérer les erreurs** d'authentification avec `authProvider.errorMessage`

## Migration anonymous → authenticated

Quand un visiteur se connecte, la session est automatiquement mise à jour :

```dart
// Avant : session anonyme
UserSession(role: VISITOR, supabaseUserId: 'xxx-anonymous')

// L'utilisateur se connecte
await authProvider.signInWithEmail(...)

// Après : session authentifiée
UserSession(role: CLIENT, supabaseUserId: 'yyy-authenticated')
```

Le profil anonyme est remplacé par le profil authentifié chargé depuis Supabase.

