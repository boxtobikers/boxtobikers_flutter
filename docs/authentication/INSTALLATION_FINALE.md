# ✅ SYSTÈME VISITOR - VERSION FINALE

## 🎯 Solution implémentée

Le système VISITOR utilise maintenant **un utilisateur pré-créé dans auth.users** et un profil correspondant dans `public.profiles`.

### Structure de la base de données

```
auth.users
  └─ id: 00000000-0000-0000-0000-000000000000
     email: visitor@boxtobikers.local
     encrypted_password: Hash fictif (connexion impossible)
     
public.profiles
  └─ id: 00000000-0000-0000-0000-000000000000
     role_id: VISITOR
     first_name: Visiteur
     last_name: Anonyme
```

## 📋 Ce qui a été modifié

### 1. Base de données (`supabase/seed.sql`)

**Ajout de l'utilisateur VISITOR dans auth.users**
```sql
insert into auth.users (
  id,
  email,
  encrypted_password,
  ...
) values (
  '00000000-0000-0000-0000-000000000000'::uuid,
  'visitor@boxtobikers.local',
  '$2a$10$VISITOR_ACCOUNT_NO_PASSWORD_HASH',  -- Hash fictif
  ...
);
```

**Puis création du profil VISITOR**
```sql
insert into public.profiles (
  id,
  role_id,
  first_name,
  last_name,
  email
) values (
  '00000000-0000-0000-0000-000000000000'::uuid,
  (select id from public.roles where name = 'VISITOR'),
  'Visiteur',
  'Anonyme',
  'visitor@boxtobikers.local'
);
```

### 2. Code Flutter

**AuthRepository** (`lib/core/auth/repositories/auth.repository.dart`)
- `signInAnonymously()` : Vérifie le profil VISITOR en BDD
- `_fetchVisitorProfile()` : Récupère les données du profil
- Crée une session locale (pas de session Supabase active)

**UserSession** (`lib/core/auth/models/user_session.model.dart`)
- `createVisitor()` : Factory mise à jour pour accepter les données du profil
- `isVisitorSession` : Identifie les sessions VISITOR locales

## 🚀 Comment tester

### Étape 1 : Réinitialiser la base de données
```bash
cd /Users/emmanuelgrenier/Projects/boxtobikers/flutter
supabase db reset
```

**Ce qui va se passer :**
- ✅ Application des migrations
- ✅ Création des rôles (ADMIN, VISITOR, CLIENT)
- ✅ Création de l'utilisateur VISITOR dans auth.users
- ✅ Création du profil VISITOR dans public.profiles

### Étape 2 : Vérifier dans Supabase Studio

Ouvrir http://127.0.0.1:54323

**Authentication → Users**
```
✅ Vous devez voir 1 utilisateur :
   - Email: visitor@boxtobikers.local
   - ID: 00000000-0000-0000-0000-000000000000
```

**Table Editor → profiles**
```
✅ Vous devez voir 1 profil :
   - id: 00000000-0000-0000-0000-000000000000
   - first_name: Visiteur
   - last_name: Anonyme
   - role: VISITOR
```

**Table Editor → roles**
```
✅ Vous devez voir 3 rôles :
   - ADMIN
   - VISITOR
   - CLIENT
```

### Étape 3 : Lancer l'application
```bash
flutter run
```

**Logs attendus :**
```
🔐 AuthRepository: Création session VISITOR...
✅ AuthRepository: Profil VISITOR trouvé - Visiteur Anonyme
✅ AuthRepository: Session VISITOR créée
✅ SessionService: Session sauvegardée
```

### Étape 4 : Tester les fonctionnalités VISITOR

**✅ Ce que vous POUVEZ faire en mode VISITOR :**
- Naviguer dans l'application
- Voir la liste des destinations
- Consulter les détails des destinations
- Voir les horaires d'ouverture
- Consulter les évaluations

**❌ Ce que vous NE POUVEZ PAS faire en mode VISITOR :**
- Créer un trajet (ride)
- Évaluer une destination (rating)
- Modifier le profil

→ Message affiché : "Connectez-vous pour accéder à cette fonctionnalité"

### Étape 5 : Tester la connexion

1. Créer un utilisateur test via Supabase Studio ou l'interface d'inscription
2. Se connecter avec cet utilisateur
3. Vérifier que le rôle passe de VISITOR à CLIENT
4. Vérifier que les fonctionnalités sont débloquées

### Étape 6 : Tester la déconnexion

1. Se déconnecter
2. Vérifier le retour en mode VISITOR
3. Vérifier que l'application reste accessible en mode lecture

## ✅ Validation

**Checklist de vérification :**

- [ ] `supabase db reset` s'exécute sans erreur
- [ ] Utilisateur VISITOR visible dans Authentication → Users
- [ ] Profil VISITOR visible dans Table Editor → profiles
- [ ] Application démarre en mode VISITOR
- [ ] Logs confirment : "Profil VISITOR trouvé"
- [ ] Navigation possible en mode VISITOR
- [ ] Création rides/ratings impossible en mode VISITOR
- [ ] Message approprié affiché pour actions bloquées
- [ ] Connexion fonctionne (VISITOR → CLIENT)
- [ ] Déconnexion fonctionne (CLIENT → VISITOR)

## 🔧 Dépannage

### Erreur : "insert or update on table profiles violates foreign key constraint"

**Cause** : L'utilisateur auth.users n'existe pas avant le profil

**Solution** : C'est résolu ! Le seed.sql crée maintenant l'utilisateur AVANT le profil.

### Erreur : "Profil VISITOR non trouvé"

**Cause** : Le seed.sql n'a pas été exécuté

**Solution** :
```bash
supabase db reset
```

### L'utilisateur VISITOR apparaît dans la liste des utilisateurs

**C'est normal !** L'utilisateur VISITOR existe dans auth.users mais :
- ✅ Il a un hash de mot de passe fictif
- ✅ Il ne peut PAS être utilisé pour se connecter
- ✅ Il sert uniquement de référence pour le profil
- ✅ Il est unique et partagé par tous les utilisateurs non connectés

## 📚 Documentation

Pour plus de détails, consultez :
- `docs/authentication/README.md` - Index principal
- `docs/authentication/VISITOR_SYSTEM.md` - Guide complet
- `docs/authentication/QUICK_START.md` - Démarrage rapide

## 🎉 Résultat

Vous avez maintenant un système VISITOR fonctionnel avec :
- ✅ Un utilisateur pré-créé dans auth.users
- ✅ Un profil VISITOR pré-créé dans public.profiles
- ✅ Respect des contraintes de clés étrangères
- ✅ Accès immédiat à l'application sans inscription
- ✅ Permissions lecture seule pour VISITOR
- ✅ Transition fluide vers connexion/inscription

**Date** : 28 octobre 2024  
**Version** : 2.0.1 (corrigée avec auth.users)  
**Statut** : ✅ Prêt pour les tests

