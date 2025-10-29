# 👤 Système VISITOR - Utilisateur Anonyme Pré-créé

## 📋 Vue d'ensemble

Le système VISITOR de BoxToBikers permet aux utilisateurs d'accéder à l'application **sans créer de compte**, en utilisant un **profil unique pré-créé** dans la base de données.

### 🎯 Objectif

Permettre à tout nouvel utilisateur d'explorer l'application immédiatement, avec un accès en **lecture seule** aux données publiques, sans friction ni inscription obligatoire.

## 🏗️ Architecture

### Concept clé : Un seul profil VISITOR partagé

```
┌─────────────────────────────────────────────────────┐
│  TOUS les utilisateurs non connectés                │
│                      ↓                               │
│  Utilisent le MÊME profil VISITOR                   │
│  UUID: 00000000-0000-0000-0000-000000000000         │
│                      ↓                               │
│  UN utilisateur pré-créé dans auth.users            │
│  Profil VISITOR correspondant dans public.profiles  │
│  Session locale uniquement (SharedPreferences)      │
└─────────────────────────────────────────────────────┘
```

### Avantages

✅ **Base de données structurée**
- Un seul utilisateur VISITOR dans `auth.users`
- Un seul profil VISITOR dans `public.profiles`
- Respect des contraintes de clés étrangères
- Base de données cohérente et maintenable

✅ **Performance optimale**
- Pas d'appel API Supabase Auth au démarrage
- Chargement instantané de l'application
- Session locale légère

✅ **Expérience utilisateur fluide**
- Accès immédiat sans inscription
- Navigation complète en mode lecture
- Transition douce vers la connexion/inscription

✅ **Sécurité et traçabilité**
- Identification claire des utilisateurs non connectés
- Permissions RLS strictes (lecture seule)
- Impossible de créer des données sensibles sans authentification
- L'utilisateur VISITOR ne peut pas se connecter (hash mot de passe fictif)

## 📊 Base de données

### Profil VISITOR pré-créé

Le profil est créé automatiquement lors de l'exécution de `supabase db reset` via le fichier `seed.sql` :

**Étape 1 : Création de l'utilisateur dans auth.users**
```sql
-- supabase/seed.sql
-- Créer d'abord l'utilisateur dans auth.users
insert into auth.users (
  id,
  instance_id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  is_sso_user
) values (
  '00000000-0000-0000-0000-000000000000'::uuid,  -- UUID fixe
  '00000000-0000-0000-0000-000000000000'::uuid,
  'authenticated',
  'authenticated',
  'visitor@boxtobikers.local',
  '$2a$10$VISITOR_ACCOUNT_NO_PASSWORD_HASH',  -- Hash fictif
  now(),
  '{"provider":"system","providers":["system"]}',
  '{"first_name":"Visiteur","last_name":"Anonyme"}',
  now(),
  now(),
  false
);
```

**Étape 2 : Création du profil dans public.profiles**
```sql
-- Puis créer le profil correspondant
insert into public.profiles (
  id,
  role_id,
  first_name,
  last_name,
  email,
  mobile,
  address
) values (
  '00000000-0000-0000-0000-000000000000'::uuid,  -- Même UUID
  (select id from public.roles where name = 'VISITOR'),
  'Visiteur',
  'Anonyme',
  'visitor@boxtobikers.local',
  '',
  ''
);
```

**Note importante** : L'utilisateur VISITOR existe dans `auth.users` mais ne peut PAS être utilisé pour se connecter (le hash du mot de passe est fictif). Il sert uniquement de référence pour le profil dans `public.profiles`.

### Permissions RLS

```sql
-- Permet à TOUT LE MONDE de lire le profil VISITOR
create policy "Anyone can read visitor profile"
on public.profiles for select
using (
  id = '00000000-0000-0000-0000-000000000000'::uuid -- Profil VISITOR
  or auth.uid() = id -- Ou son propre profil si authentifié
);

-- Données publiques accessibles à tous
create policy "Everyone can read destinations"
on public.destinations for select using (true);

create policy "Everyone can read opening hours"
on public.opening_hours for select using (true);

create policy "Everyone can read ratings"
on public.ratings for select using (true);

-- Actions restreintes aux utilisateurs authentifiés
create policy "Users can manage their own rides"
on public.rides for all
using (auth.uid() = user_id and auth.uid() is not null);

create policy "Users can manage their own ratings"
on public.ratings for all
using (auth.uid() = user_id and auth.uid() is not null);
```

## 💻 Implémentation Flutter

### 1. Modèle UserSession

```dart
// lib/core/auth/models/user_session.model.dart

class UserSession {
  final String id;
  final UserRole role;
  final UserProfileModel profile;
  final String? supabaseUserId;  // NULL pour VISITOR
  final String? supabaseToken;   // NULL pour VISITOR
  
  // Vérifie si c'est une session VISITOR locale
  bool get isVisitorSession => role == UserRole.visitor && supabaseUserId == null;
  
  // Factory pour créer une session VISITOR
  factory UserSession.createVisitor({
    required String profileId,
  }) {
    return UserSession(
      id: profileId, // '00000000-0000-0000-0000-000000000000'
      role: UserRole.visitor,
      profile: UserProfileModel.createVisitor(),
      supabaseUserId: null, // Pas d'utilisateur Supabase
      supabaseToken: null,  // Pas de token
      email: '',
    );
  }
}
```

### 2. Repository d'authentification

```dart
// lib/core/auth/repositories/app_auth.repository.dart

class AuthRepository {
  static const String _visitorProfileId = '00000000-0000-0000-0000-000000000000';
  
  /// Crée une session VISITOR locale (sans utilisateur Supabase)
  Future<UserSession?> signInAnonymously() async {
    // Vérifier que le profil VISITOR existe en BDD
    final visitorProfile = await _fetchVisitorProfile();
    
    if (visitorProfile == null) {
      debugPrint('❌ Profil VISITOR non trouvé - Exécutez: supabase db reset');
      return null;
    }
    
    // Créer session locale uniquement
    return UserSession.createVisitor(profileId: _visitorProfileId);
  }
  
  Future<Map<String, dynamic>?> _fetchVisitorProfile() async {
    final response = await _supabaseService.client
        .from('profiles')
        .select('*, roles!inner(name)')
        .eq('id', _visitorProfileId)
        .maybeSingle();
    
    return response;
  }
}
```

### 3. Provider d'authentification

```dart
// lib/core/auth/providers/app_auth.provider.dart

class AuthProvider extends ChangeNotifier {
  Future<void> initialize() async {
    // 1. Vérifier session Supabase (utilisateur authentifié)
    final supabaseSession = await _authRepository.getCurrentSession();
    if (supabaseSession != null) {
      _currentSession = supabaseSession;
      _setStatus(AuthStatus.authenticated);
      return;
    }
    
    // 2. Vérifier session locale
    final localSession = await _sessionService.loadSession();
    if (localSession != null && localSession.isValid) {
      _currentSession = localSession;
      _setStatus(localSession.isVisitorSession 
          ? AuthStatus.anonymous 
          : AuthStatus.authenticated);
      return;
    }
    
    // 3. Créer session VISITOR locale
    await _createAnonymousSession();
  }
  
  Future<void> _createAnonymousSession() async {
    final session = await _authRepository.signInAnonymously();
    if (session != null) {
      _currentSession = session;
      await _sessionService.saveSession(session);
      _setStatus(AuthStatus.anonymous);
    }
  }
}
```

## 🔄 Flux utilisateur

### Première installation

```
1. User télécharge l'app
2. App démarre
3. AuthProvider.initialize()
4. Aucune session trouvée
5. Appel AuthRepository.signInAnonymously()
6. Vérification du profil VISITOR en BDD
7. Création UserSession.createVisitor()
8. Sauvegarde session en local (SharedPreferences)
9. App accessible immédiatement
```

### Consultation de l'application (VISITOR)

```
User VISITOR peut :
✅ Naviguer dans toutes les pages publiques
✅ Voir la liste des destinations
✅ Voir les détails d'une destination
✅ Voir les horaires d'ouverture
✅ Voir les évaluations (ratings)
✅ Utiliser la carte interactive

User VISITOR ne peut pas :
❌ Créer un trajet (ride)
❌ Évaluer une destination (rating)
❌ Modifier son profil
→ Message affiché : "Connectez-vous pour accéder à cette fonctionnalité"
```

### Passage de VISITOR à CLIENT

```
1. User VISITOR clique "Se connecter"
2. Affichage LoginPage
3. User entre email + password
4. AuthProvider.signInWithEmail()
5. Supabase authentifie
6. Récupération profil CLIENT depuis BDD
7. Mise à jour session (VISITOR → CLIENT)
8. notifyListeners() → rebuild widgets
9. Nouvelles fonctionnalités débloquées
```

### Déconnexion CLIENT → VISITOR

```
1. User CLIENT clique "Se déconnecter"
2. AuthProvider.signOut()
3. Déconnexion Supabase (auth.signOut())
4. Suppression session locale
5. Recréation session VISITOR
6. notifyListeners() → rebuild widgets
7. Retour en mode lecture seule
8. User reste dans l'app (pas de perte d'accès)
```

## 🔒 Sécurité

### Protection des données

**Row Level Security (RLS)**
- Toutes les tables ont RLS activé
- Le profil VISITOR a uniquement accès en lecture aux données publiques
- Impossible de créer/modifier des données sensibles sans authentification

**Validation côté serveur**
```sql
-- Les policies Supabase vérifient auth.uid() is not null
-- Pour toutes les opérations d'écriture
create policy "Users can create rides"
on public.rides for insert
with check (auth.uid() = user_id and auth.uid() is not null);
```

**Validation côté client (UX)**
```dart
// AuthGuard protège les routes sensibles
AuthGuard(
  allowedRoles: [UserRole.client, UserRole.admin],
  child: CreateRidePage(),
  deniedMessage: 'Connectez-vous pour créer un trajet',
)
```

## 📦 Installation et configuration

### 1. Créer le profil VISITOR

```bash
cd /Users/emmanuelgrenier/Projects/boxtobikers/flutter

# Réinitialiser la base de données
# Cela exécute les migrations + seed.sql
supabase db reset
```

### 2. Vérifier la création

Ouvrir Supabase Studio : http://127.0.0.1:54323

```
1. Aller dans Table Editor → profiles
2. Chercher le profil avec id = 00000000-0000-0000-0000-000000000000
3. Vérifier :
   - role_id → VISITOR
   - first_name → "Visiteur"
   - last_name → "Anonyme"
```

### 3. Tester l'application

```bash
flutter run
```

Vérifier les logs :
```
✅ AuthRepository: Profil VISITOR trouvé - Visiteur Anonyme
✅ AuthRepository: Session VISITOR créée
✅ SessionService: Session sauvegardée
```

## 🐛 Dépannage

### Erreur : "Profil VISITOR non trouvé"

**Cause** : Le seed.sql n'a pas été exécuté

**Solution** :
```bash
supabase db reset
```

### Erreur : "Permission denied for table profiles"

**Cause** : RLS policies mal configurées

**Solution** :
Vérifier que la migration `20241028000000_visitor_profile_rls.sql` est appliquée :
```bash
supabase db reset
```

### Session VISITOR ne persiste pas

**Cause** : Problème de sauvegarde SharedPreferences

**Solution** :
Vérifier les logs de SessionService et s'assurer que `saveSession()` est bien appelé.

## 🔄 Migration depuis l'ancien système

Si vous utilisiez l'authentification anonyme Supabase (`signInAnonymously()`), voici comment migrer :

### Changements principaux

**AVANT** (ancien système) :
- Création d'un utilisateur anonyme dans auth.users
- Profil VISITOR créé par le trigger
- Un nouveau compte pour chaque installation

**APRÈS** (nouveau système) :
- Aucun utilisateur dans auth.users
- Un seul profil VISITOR partagé
- Session locale uniquement

### Nettoyer les anciens utilisateurs anonymes

```sql
-- Supprimer les utilisateurs anonymes existants
delete from auth.users where is_anonymous = true;
```

### Mettre à jour les triggers

Le trigger a été modifié pour ne plus créer de profil pour les utilisateurs anonymes :
```sql
-- Voir supabase/migrations/20241025000000_init_schema.sql
-- Le trigger vérifie maintenant : if new.is_anonymous = false
```

## 📚 Ressources

- [Documentation Supabase RLS](https://supabase.com/docs/guides/auth/row-level-security)
- [Flutter SharedPreferences](https://pub.dev/packages/shared_preferences)
- [Provider pattern](https://pub.dev/packages/provider)

## ✅ Checklist de vérification

- [ ] Profil VISITOR créé en BDD (UUID: 00000000-0000-0000-0000-000000000000)
- [ ] RLS policies configurées pour permettre lecture du profil VISITOR
- [ ] Migration `20241028000000_visitor_profile_rls.sql` appliquée
- [ ] Seed data exécuté (`supabase db reset`)
- [ ] Application démarre en mode VISITOR par défaut
- [ ] Logs confirment : "Profil VISITOR trouvé"
- [ ] Impossible de créer rides/ratings en mode VISITOR
- [ ] Transition VISITOR → CLIENT fonctionne
- [ ] Transition CLIENT → VISITOR (logout) fonctionne
- [ ] Aucun utilisateur anonyme créé dans auth.users

---

**Date de création** : 28 octobre 2024  
**Dernière mise à jour** : 28 octobre 2024  
**Version** : 2.0 - Système VISITOR avec profil pré-créé

