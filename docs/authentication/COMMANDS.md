# 🚀 Commandes pour tester le système d'authentification

## Prérequis

### 1. Vérifier Docker
```bash
docker --version
# Docker doit être installé et en cours d'exécution
```

### 2. Vérifier Supabase CLI
```bash
supabase --version
```

### 3. Vérifier Flutter
```bash
flutter doctor
# Tout doit être ✓
```

## Démarrage

### 1. Redémarrer Supabase (IMPORTANT)
```bash
cd /Users/emmanuelgrenier/Projects/boxtobikers/flutter

# Arrêter Supabase si déjà démarré
supabase stop

# Redémarrer pour prendre en compte la nouvelle config
supabase start
```

**⚠️ IMPORTANT :** Si Supabase était déjà démarré, vous DEVEZ le redémarrer pour que `enable_anonymous_sign_ins = true` soit pris en compte !

**Ce que ça fait :**
- Lance PostgreSQL dans Docker
- Applique toutes les migrations
- Crée les rôles ADMIN, VISITOR, CLIENT
- Configure le trigger handle_new_user()
- **Active l'authentification anonyme** (nouvelle config)

**Résultat attendu :**
```
Started supabase local development setup.

         API URL: http://127.0.0.1:54321
     GraphQL URL: http://127.0.0.1:54321/graphql/v1
          DB URL: postgresql://postgres:postgres@127.0.0.1:54322/postgres
      Studio URL: http://127.0.0.1:54323
    Inbucket URL: http://127.0.0.1:54324
      JWT secret: super-secret-jwt-token-with-at-least-32-characters-long
        anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 2. Lancer l'application Flutter
```bash
# Dans un nouveau terminal
cd /Users/emmanuelgrenier/Projects/boxtobikers/flutter
flutter run
```

**Ou spécifier un device :**
```bash
# Lister les devices disponibles
flutter devices

# Lancer sur un device spécifique
flutter run -d chrome        # Web
flutter run -d macos         # macOS
flutter run -d <device-id>   # iOS/Android
```

### 3. Observer les logs

**Dans le terminal Flutter, vous devriez voir :**
```
🚀 AppLauncher: Démarrage de l'application
✅ AppLauncher: Service HTTP initialisé
✅ AppLauncher: Service de session initialisé
✅ AppLauncher: Repository d'authentification créé
✅ AppLauncher: Provider d'authentification créé
🔐 AuthProvider: Initialisation...
🔐 AuthRepository: Connexion anonyme...
✅ AuthRepository: Connexion anonyme réussie - User ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
✅ AuthRepository: Session anonyme créée - UserSession(id: xxx, role: VISITOR, ...)
✅ SessionService: Session sauvegardée - UserSession(...)
✅ AppLauncher: Authentification initialisée
✅ AppLauncher: Service de préférences initialisé
✅ AppLauncher: Provider d'état créé
```

## Vérifications

### 1. Vérifier dans Supabase Studio
```bash
# Ouvrir dans le navigateur
open http://127.0.0.1:54323
```

**Vérifications à faire :**

1. **Authentication → Users**
   - Vous devriez voir 1 utilisateur
   - Colonne `is_anonymous` = `true`
   - Colonne `email` = vide ou null

2. **Table Editor → roles**
   - 3 rôles : ADMIN, VISITOR, CLIENT

3. **Table Editor → profiles**
   - 1 profil créé automatiquement
   - `role_id` = UUID du rôle VISITOR
   - `first_name` = vide
   - `last_name` = vide

### 2. Vérifier dans l'application

**Dans l'app Flutter :**
1. L'app démarre normalement
2. Pas d'erreur affichée
3. La page Home s'affiche

**Test du widget de session :**
- Si vous avez un Drawer, vérifier qu'il affiche "Visiteur"
- Bouton "Se connecter" devrait être visible

### 3. Vérifier la persistance

```bash
# Arrêter l'app (Ctrl+C dans terminal Flutter)
# Relancer
flutter run
```

**Dans les logs, vous devriez voir :**
```
🚀 AppLauncher: Démarrage de l'application
...
ℹ️ AuthProvider: Initialisation...
ℹ️ AuthRepository: Session Supabase trouvée - User ID: xxx
✅ AuthProvider: Session Supabase trouvée
✅ SessionService: Session sauvegardée - UserSession(...)
```

**Pas de nouvelle création d'utilisateur anonyme !**

## Tests fonctionnels

### Test 1 : Créer un compte

1. **Via Supabase Studio :**
```
http://127.0.0.1:54323
→ Authentication → Users → Add user
Email: test@example.com
Password: password123
Auto Confirm User: ✓
```

2. **Le trigger devrait automatiquement créer un profil VISITOR**

3. **Vérifier dans Table Editor → profiles**
   - Nouveau profil pour test@example.com
   - role = VISITOR

### Test 2 : Se connecter dans l'app

1. **Ajouter la route login dans AppRouter** (si pas déjà fait)
```dart
// Dans lib/core/app/app_router.dart
import 'package:boxtobikers/core/auth/ui/pages/login.page.dart';

static const String login = '/login';

// Dans getRoutes()
login: (context) => const LoginPage(),
```

2. **Naviguer vers /login** (ajouter un bouton temporaire ou via code)
```dart
Navigator.pushNamed(context, '/login');
```

3. **Se connecter avec :**
   - Email: test@example.com
   - Password: password123

4. **Vérifier les logs :**
```
🔐 AuthProvider: Connexion avec email...
🔐 AuthRepository: Connexion avec email: test@example.com
✅ AuthRepository: Connexion réussie - User ID: xxx
✅ AuthRepository: Profil récupéré - Role: VISITOR
✅ AuthRepository: Session créée - UserSession(...)
✅ SessionService: Session sauvegardée
```

### Test 3 : Vérifier le rôle

**Dans n'importe quel widget :**
```dart
import 'package:provider/provider.dart';
import 'package:boxtobikers/core/auth/auth.dart';

// Dans build()
final authProvider = Provider.of<AuthProvider>(context);
print('🔍 Session: ${authProvider.currentSession}');
print('🔍 Role: ${authProvider.currentSession?.role.value}');
print('🔍 Is anonymous: ${authProvider.isAnonymous}');
print('🔍 Is authenticated: ${authProvider.isAuthenticated}');
```

### Test 4 : Tester AuthGuard

**Créer une page de test protégée :**
```dart
// Dans AppRouter
import 'package:boxtobikers/core/auth/auth.dart';

testProtected: (context) => AuthGuard(
  allowedRoles: [UserRole.client, UserRole.admin],
  child: Scaffold(
    appBar: AppBar(title: Text('Page Protégée')),
    body: Center(child: Text('Vous êtes authentifié !')),
  ),
  deniedMessage: 'Vous devez être CLIENT ou ADMIN',
),
```

**Tester :**
1. En tant que VISITOR → devrait voir message "Accès refusé"
2. Promouvoir en CLIENT dans Studio
3. Se reconnecter → devrait voir la page

### Test 5 : Promouvoir un utilisateur

**Via Supabase Studio :**
```sql
-- SQL Editor
UPDATE public.profiles
SET role_id = (SELECT id FROM public.roles WHERE name = 'CLIENT')
WHERE email = 'test@example.com';
```

**Dans l'app :**
1. Se déconnecter
2. Se reconnecter
3. Vérifier le nouveau rôle

## Debugging

### Logs silencieux ?

**Activer les logs Flutter :**
```bash
flutter run --verbose
```

### Supabase ne démarre pas ?

```bash
# Vérifier l'état
supabase status

# Redémarrer complètement
supabase stop
supabase start
```

### App crash au démarrage ?

```bash
# Nettoyer et rebuilder
flutter clean
flutter pub get
flutter run
```

### Session non sauvegardée ?

**Supprimer les données de l'app :**
```bash
# Android
adb shell pm clear com.boxtobikers.app

# iOS
# Désinstaller l'app et réinstaller
```

### Vérifier les données sauvegardées

**Android :**
```bash
adb shell
run-as com.boxtobikers.app
cat shared_prefs/FlutterSharedPreferences.xml
```

## Commandes utiles

### Supabase

```bash
# Status
supabase status

# Logs
supabase db dump -f backup.sql

# Reset (supprime toutes les données)
supabase db reset

# Arrêter
supabase stop
```

### Flutter

```bash
# Analyser le code
flutter analyze

# Formater le code
flutter format lib/

# Tests
flutter test

# Build
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

## Nettoyage

### Arrêter tout

```bash
# Terminal Flutter : Ctrl+C

# Arrêter Supabase
supabase stop

# Arrêter Docker si nécessaire
docker stop $(docker ps -q)
```

### Supprimer les données

```bash
# Supprimer toutes les données Supabase
supabase db reset

# Supprimer les volumes Docker
docker system prune -a --volumes
```

## Prochaines étapes

1. ✅ Vérifier que tout fonctionne
2. Intégrer UserSessionWidget dans le drawer
3. Protéger les pages avec AuthGuard
4. Créer page d'inscription
5. Améliorer l'UX

---

**En cas de problème, consultez :**
- `lib/core/auth/README.md` - Documentation technique
- `docs/authentication/QUICK_START.md` - Guide détaillé
- `docs/authentication/IMPLEMENTATION_COMPLETE.md` - Rapport complet

