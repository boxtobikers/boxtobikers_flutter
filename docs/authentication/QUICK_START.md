# Guide de Démarrage Rapide - Système d'Authentification

## ✅ Ce qui a été fait

### 1. Configuration Supabase
- ✅ Base de données configurée avec rôles (VISITOR, CLIENT, ADMIN)
- ✅ Profil VISITOR pré-créé dans la base de données (seed.sql)
- ✅ Trigger automatique créant un profil CLIENT pour chaque inscription
- ⚠️ Authentification anonyme Supabase DÉSACTIVÉE (non utilisée)

### 2. Architecture Flutter créée
```
lib/core/auth/
├── models/              # ✅ Enums et modèles de données
├── repositories/        # ✅ Accès Supabase
├── services/           # ✅ Persistance locale
├── providers/          # ✅ État réactif
├── widgets/            # ✅ AuthGuard
└── ui/                 # ✅ Pages et widgets exemple
```

### 3. Système VISITOR unique
- ✅ Un seul profil VISITOR partagé par tous les utilisateurs non connectés
- ✅ UUID fixe : `00000000-0000-0000-0000-000000000000`
- ✅ Aucun utilisateur Supabase créé pour les visiteurs
- ✅ Session locale uniquement (SharedPreferences)

### 4. Intégration dans l'application
- ✅ `AppLauncher` mis à jour avec initialisation auth
- ✅ `main.dart` configuré avec MultiProvider
- ✅ Session VISITOR créée automatiquement au démarrage

## 🚀 Comment tester

### Étape 1 : Réinitialiser la base de données (Important!)

```bash
cd /Users/emmanuelgrenier/Projects/boxtobikers/flutter

# Réinitialiser la base de données
# Cela va créer le profil VISITOR pré-créé
supabase db reset
```

Cela va :
- Appliquer toutes les migrations
- Créer les rôles (ADMIN, VISITOR, CLIENT)
- **Créer le profil VISITOR unique** (UUID: 00000000-0000-0000-0000-000000000000)
- Créer le trigger `handle_new_user()`

### Étape 2 : Vérifier que le profil VISITOR existe

Ouvrez http://127.0.0.1:54323 (Supabase Studio)

1. Allez dans **Table Editor** → **profiles**
2. Cherchez le profil avec `id = 00000000-0000-0000-0000-000000000000`
3. Vérifiez :
   - `role` → VISITOR
   - `first_name` → "Visiteur"
   - `last_name` → "Anonyme"

### Étape 3 : Lancer l'application

```bash
flutter run
```

**Que va-t-il se passer ?**
1. Supabase s'initialise
2. AuthProvider s'initialise
3. Aucune session Supabase trouvée
4. Création automatique d'une session VISITOR locale
5. Utilisation du profil VISITOR pré-créé (UUID: 00000000-0000-0000-0000-000000000000)
6. Session sauvegardée localement (SharedPreferences)
7. Application démarre en mode VISITOR (lecture seule)

### Étape 4 : Vérifier les logs

Dans la console Flutter, vous devriez voir :

```
🔐 AuthRepository: Création session VISITOR anonyme...
ℹ️ AuthRepository: Utilisation du profil VISITOR pré-créé (UUID: 00000000-0000-0000-0000-000000000000)
✅ AuthRepository: Profil VISITOR trouvé - Visiteur Anonyme
✅ AuthRepository: Session VISITOR créée - UserSession(role: VISITOR, isAnonymous: true)
✅ SessionService: Session sauvegardée
```

### Étape 5 : Vérifier dans Supabase Studio

Ouvrez http://127.0.0.1:54323

1. Allez dans **Authentication** → **Users**
   - ✅ **Aucun utilisateur anonyme** ne doit être créé
   - Vous ne devriez voir que les utilisateurs réellement inscrits

2. Allez dans **Table Editor** → **profiles**
   - ✅ Un seul profil VISITOR (id: 00000000-0000-0000-0000-000000000000)
   - Pas de nouveaux profils VISITOR créés à chaque démarrage

## 🧪 Tester les fonctionnalités

### Test 1 : Vérifier la session VISITOR

Dans n'importe quel widget :

```dart
import 'package:provider/provider.dart';
import 'package:boxtobikers/core/auth/auth.dart';

// Dans le build
final authProvider = Provider.of<AuthProvider>(context);
final session = authProvider.currentSession;

print('Role: ${session?.role.value}');        // "VISITOR"
print('Is anonymous: ${session?.isAnonymous}');  // true
print('Is visitor: ${session?.isVisitorSession}'); // true
print('Supabase User ID: ${session?.supabaseUserId}'); // null (pas d'utilisateur Supabase)
print('Profile ID: ${session?.id}'); // "00000000-0000-0000-0000-000000000000"
```

### Test 2 : Afficher le widget de session

Dans votre `Drawer` ou `AppBar` :

```dart
import 'package:boxtobikers/core/auth/ui/widgets/user_session.widget.dart';

Drawer(
  child: ListView(
    children: [
      const UserSessionWidget(),  // Affiche "Visiteur" avec bouton "Se connecter"
      // ... autres items du drawer
    ],
  ),
)
```

### Test 3 : Protéger une page

```dart
import 'package:boxtobikers/core/auth/auth.dart';

// Dans AppRouter
settings: (context) => AuthGuard(
  allowedRoles: [UserRole.client, UserRole.admin],
  child: const SettingsPages(),
  deniedMessage: 'Vous devez être connecté pour accéder aux paramètres',
)
```

Si vous essayez d'accéder en tant que VISITOR, vous verrez le message d'erreur.

### Test 4 : Créer un compte et se connecter

1. Ajoutez la route dans `AppRouter` :
```dart
static const String login = '/login';

login: (context) => const LoginPage(),
```

2. Naviguer vers `/login`

3. Créer un compte via Supabase Studio :
   - **Authentication** → **Users** → **Add user**
   - Email: `test@example.com`
   - Password: `password123`

4. Le trigger créera automatiquement le profil VISITOR

5. Dans l'app, utilisez le formulaire de connexion

6. Après connexion, vérifiez :
```dart
print('Role: ${session?.role.value}');  // "VISITOR" (ou CLIENT si vous changez le rôle en BDD)
print('Is anonymous: ${session?.isAnonymous}');  // "false"
print('Email: ${session?.email}');  // "test@example.com"
```

## 🔧 Modifier le rôle d'un utilisateur

### Via Supabase Studio

1. Allez dans **Table Editor** → **profiles**
2. Trouvez le profil de l'utilisateur
3. Changez `role_id` :
   - VISITOR → `<uuid du role VISITOR>`
   - CLIENT → `<uuid du role CLIENT>`
   - ADMIN → `<uuid du role ADMIN>`
4. Déconnectez/reconnectez dans l'app pour recharger le profil

### Via SQL

```sql
-- Promouvoir un utilisateur en CLIENT
UPDATE public.profiles
SET role_id = (SELECT id FROM public.roles WHERE name = 'CLIENT')
WHERE email = 'test@example.com';

-- Promouvoir en ADMIN
UPDATE public.profiles
SET role_id = (SELECT id FROM public.roles WHERE name = 'ADMIN')
WHERE email = 'admin@example.com';
```

## 📱 Utilisation dans vos pages

### Exemple : Page d'accueil

```dart
import 'package:provider/provider.dart';
import 'package:boxtobikers/core/auth/auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final session = authProvider.currentSession;
        
        return Scaffold(
          appBar: AppBar(
            title: Text('Bonjour ${session?.profile.firstName ?? "Visiteur"}'),
          ),
          body: Column(
            children: [
              if (session?.isAnonymous ?? true)
                Card(
                  child: ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Mode visiteur'),
                    subtitle: Text('Connectez-vous pour plus de fonctionnalités'),
                    trailing: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: Text('Se connecter'),
                    ),
                  ),
                ),
              // ... reste du contenu
            ],
          ),
        );
      },
    );
  }
}
```

## 🐛 Debugging

### Voir les logs d'authentification

Tous les logs commencent par des emojis :
- 🚀 Initialisation
- ✅ Succès
- ❌ Erreur
- ℹ️ Information
- ⚠️ Avertissement
- 🔐 Opération d'authentification

Exemple :
```
🚀 AppLauncher: Démarrage de l'application
✅ AppLauncher: Service HTTP initialisé
✅ AppLauncher: Service de session initialisé
🔐 AuthRepository: Connexion anonyme...
✅ AuthRepository: Connexion anonyme réussie - User ID: 12345-67890
✅ SessionService: Session sauvegardée - UserSession(...)
```

### Réinitialiser complètement l'application

```dart
import 'package:boxtobikers/core/app/app_launcher.dart';

// Dans votre code
await AppLauncher.reset();
// L'app va se déconnecter et recréer une session anonyme
```

### Inspecter la session sauvegardée

Sur Android :
```bash
adb shell
run-as com.boxtobikers.app
cat shared_prefs/FlutterSharedPreferences.xml
```

Sur iOS :
Utilisez Xcode → Devices → App Container → Library → Preferences

## 📚 Prochaines étapes

1. **Personnaliser les pages** :
   - Créer une vraie page d'inscription
   - Ajouter mot de passe oublié
   - Améliorer le formulaire de profil

2. **Ajouter plus de guards** :
   - Protéger les pages History, Riding, etc.
   - Créer des guards personnalisés (ex: AdminGuard)

3. **Améliorer l'UX** :
   - Ajouter un splash screen pendant l'init
   - Afficher un loader pendant les opérations auth
   - Ajouter des animations de transition

4. **Sécurité** :
   - Vérifier les RLS policies côté Supabase
   - Ajouter validation côté serveur
   - Implémenter refresh token automatique

## ❓ FAQ

**Q: L'app crée-t-elle toujours une nouvelle session anonyme ?**
R: Non ! La session est sauvegardée localement. Au redémarrage, elle est restaurée si le token Supabase est toujours valide.

**Q: Que se passe-t-il si je me déconnecte ?**
R: L'app crée automatiquement une nouvelle session anonyme. Vous ne perdez jamais l'accès.

**Q: Puis-je désactiver l'authentification anonyme ?**
R: Oui, mais vous devrez forcer la connexion au démarrage. Pas recommandé pour l'expérience utilisateur.

**Q: Comment migrer de VISITOR à CLIENT après connexion ?**
R: C'est automatique ! `AuthProvider.signInWithEmail()` récupère le rôle depuis la BDD et met à jour la session.

**Q: La session persiste combien de temps ?**
R: Le token Supabase expire après 1h par défaut (configurable). Ensuite, l'app recrée une session anonyme.

