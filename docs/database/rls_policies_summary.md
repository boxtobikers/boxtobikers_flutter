# Résumé des politiques RLS - BoxToBikers

## Tables de l'application

### 1. **destinations** ✅
- **Type** : Table publique
- **user_id** : ❌ Aucun
- **RLS** : Lecture seule pour tous
- **Politique actuelle** : `"Everyone can read destinations"`
- **Statut** : ✅ Correct - Les destinations sont publiques

### 2. **opening_hours** ✅
- **Type** : Table publique
- **user_id** : ❌ Aucun
- **RLS** : Lecture seule pour tous
- **Politique actuelle** : `"Everyone can read opening hours"`
- **Statut** : ✅ Correct - Les horaires sont publics

### 3. **roles** ✅
- **Type** : Table publique
- **user_id** : ❌ Aucun
- **RLS** : Pas de politique (table système)
- **Statut** : ✅ Correct - Les rôles sont publics

### 4. **profiles** ✅ (Corrigé)
- **Type** : Table utilisateur
- **user_id** : ✅ `id` (UUID du profil)
- **RLS** : Chaque utilisateur accède uniquement à son profil
- **Politiques** :
  - ~~`"Anyone can read visitor profile"` (SUPPRIMÉE)~~ ❌ Trop permissive
  - ~~`"Users can view and update their own profile"` (SUPPRIMÉE)~~ ❌ N'incluait pas VISITOR
  - `"Users can read their own profile"` ✅ Nouveau
  - `"Users can update their own profile"` ✅ Nouveau
- **Statut** : ✅ Corrigé par migration `20251030000003`

### 5. **rides** ✅ (Corrigé)
- **Type** : Table utilisateur (jointure user → destination)
- **user_id** : ✅ `user_id` (UUID de l'utilisateur)
- **RLS** : Chaque utilisateur accède uniquement à ses rides
- **Politiques** :
  - ~~`"Users can manage their own rides"` (SUPPRIMÉE)~~ ❌ N'incluait pas VISITOR
  - `"Users can read their own rides"` ✅ Nouveau
  - `"Users can insert their own rides"` ✅ Nouveau
  - `"Users can update their own rides"` ✅ Nouveau
  - `"Users can delete their own rides"` ✅ Nouveau
- **Contraintes** :
  - `UNIQUE (user_id, destination_id)` - Un utilisateur = un ride par destination
- **Statut** : ✅ Corrigé par migration `20251030000001`

### 6. **ratings** ✅ (Corrigé)
- **Type** : Table utilisateur (évaluation d'une destination par un user)
- **user_id** : ✅ `user_id` (UUID de l'utilisateur)
- **RLS** : Chaque utilisateur accède uniquement à ses ratings
- **Politiques** :
  - ~~`"Everyone can read ratings"` (SUPPRIMÉE)~~ ❌ Trop permissive
  - ~~`"Users can manage their own ratings"` (SUPPRIMÉE)~~ ❌ N'incluait pas VISITOR
  - `"Users can read their own ratings"` ✅ Nouveau
  - `"Users can insert their own ratings"` ✅ Nouveau
  - `"Users can update their own ratings"` ✅ Nouveau
  - `"Users can delete their own ratings"` ✅ Nouveau
- **Contraintes** :
  - `UNIQUE (user_id, destination_id)` - Un utilisateur = un rating par destination
- **Statut** : ✅ Corrigé par migration `20251030000002`

## Fonction centrale

### `public.get_current_user_id()` ✅
- **Rôle** : Retourne l'UUID de l'utilisateur courant
- **Logique** :
  - Si `auth.uid() IS NOT NULL` → Retourne `auth.uid()` (utilisateur authentifié)
  - Sinon → Retourne `'00000000-0000-0000-0000-000000000000'` (VISITOR)
- **Utilisée par** : Toutes les politiques RLS des tables `profiles`, `rides`, `ratings`
- **Statut** : ✅ Créée par migration `20251030000001`

## Principe de sécurité respecté

✅ **Isolation totale** : Chaque utilisateur ne peut accéder QU'À ses propres données  
✅ **Support VISITOR** : Les sessions anonymes fonctionnent comme les authentifiées  
✅ **Pas de fuite de données** : Aucun utilisateur ne peut lire les données d'un autre  
✅ **Tables publiques contrôlées** : Seules les destinations et horaires sont publics  

## Vérification de la sécurité

Pour tester la sécurité RLS en SQL :

```sql
-- Simuler une session VISITOR (auth.uid() = NULL)
SELECT public.get_current_user_id();
-- Résultat attendu : 00000000-0000-0000-0000-000000000000

-- Vérifier les rides accessibles en tant que VISITOR
SELECT * FROM rides;
-- Résultat : uniquement les rides avec user_id = '00000000-0000-0000-0000-000000000000'

-- Vérifier les ratings accessibles en tant que VISITOR
SELECT * FROM ratings;
-- Résultat : uniquement les ratings avec user_id = '00000000-0000-0000-0000-000000000000'

-- Vérifier le profil accessible en tant que VISITOR
SELECT * FROM profiles;
-- Résultat : uniquement le profil avec id = '00000000-0000-0000-0000-000000000000'
```

## Checklist pour nouvelles tables

Lors de l'ajout d'une nouvelle table avec relation utilisateur :

- [ ] Ajouter la colonne `user_id uuid NOT NULL`
- [ ] Ajouter la contrainte FK `REFERENCES public.profiles(id) ON DELETE CASCADE`
- [ ] Créer la politique `FOR SELECT` avec `user_id = public.get_current_user_id()`
- [ ] Créer la politique `FOR INSERT` avec `user_id = public.get_current_user_id()`
- [ ] Créer la politique `FOR UPDATE` avec `user_id = public.get_current_user_id()`
- [ ] Créer la politique `FOR DELETE` avec `user_id = public.get_current_user_id()`
- [ ] Ajouter des commentaires explicatifs sur les politiques
- [ ] Tester avec une session VISITOR et une session authentifiée

