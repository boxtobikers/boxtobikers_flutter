# Migrations Supabase - BoxToBikers

## Ordre des migrations

Les migrations sont appliquées dans l'ordre chronologique basé sur leur timestamp.

### Migrations principales

1. **20251029072113_remote_schema.sql** - Schéma initial de la base de données
2. **20251029100000_add_birthdate_to_profiles.sql** - Ajout du champ birthdate aux profils
3. **20251029100001_update_visitor_address.sql** - Mise à jour de l'adresse du profil VISITOR

### Migrations de sécurité RLS (30 octobre 2025)

Ces migrations corrigent les politiques RLS pour respecter le principe : **chaque utilisateur ne peut accéder QU'À ses propres données**.

4. **20251030000000_add_unique_constraint_rides.sql** 
   - Ajoute une contrainte d'unicité sur `(user_id, destination_id)` dans `rides`
   - Empêche les doublons : un utilisateur = un seul ride par destination

5. **20251030000001_add_visitor_rides_policy.sql** ⚠️ **IMPORTANT**
   - Crée la fonction `public.get_current_user_id()` utilisée par toutes les politiques RLS
   - Remplace les politiques RLS de la table `rides`
   - Permet aux sessions anonymes (VISITOR) d'accéder à leurs rides

6. **20251030000002_fix_ratings_rls_policy.sql**
   - Corrige les politiques RLS de la table `ratings`
   - Supprime la politique trop permissive "Everyone can read ratings"
   - Chaque utilisateur ne voit que ses propres ratings

7. **20251030000003_fix_profiles_rls_policy.sql**
   - Corrige les politiques RLS de la table `profiles`
   - Chaque utilisateur ne peut accéder qu'à son propre profil
   - VISITOR accède uniquement au profil VISITOR

8. **20251030000004_fix_handle_new_user_search_path.sql** ⚠️ **SÉCURITÉ**
   - Corrige le `search_path` de toutes les fonctions `SECURITY DEFINER`
   - Ajoute `SET search_path = ''` pour éviter les attaques par injection de schéma
   - Fonctions corrigées : `get_user_role`, `handle_new_user`, `is_user_admin`, `get_current_user_id`
   - Résout le warning Supabase Linter

## Fonction centrale : `get_current_user_id()`

Cette fonction est le pilier de la sécurité RLS. Elle retourne :
- L'UUID Supabase pour les utilisateurs authentifiés (`auth.uid()`)
- L'UUID du profil VISITOR (`00000000-0000-0000-0000-000000000000`) pour les sessions anonymes

```sql
CREATE OR REPLACE FUNCTION public.get_current_user_id()
RETURNS uuid
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''  -- ⚠️ Important pour la sécurité
AS $$
BEGIN
  IF auth.uid() IS NOT NULL THEN
    RETURN auth.uid();
  END IF;
  RETURN '00000000-0000-0000-0000-000000000000'::uuid;
END;
$$;
```

### 🔒 Sécurité `search_path`

Toutes les fonctions `SECURITY DEFINER` doivent avoir `SET search_path = ''` pour éviter les attaques par injection de schéma. Sans cela, un attaquant pourrait créer un schéma malveillant et intercepter les appels de fonction.

**Fonctions sécurisées :**
- `get_current_user_id()` ✅
- `get_user_role()` ✅
- `handle_new_user()` ✅
- `is_user_admin()` ✅

## Principe de sécurité

**Isolation totale des données utilisateur :**
- Un utilisateur VISITOR ne peut accéder qu'aux données du profil VISITOR
- Un utilisateur authentifié ne peut accéder qu'à SES propres données
- Aucun utilisateur ne peut lire les données d'un autre utilisateur

**Tables concernées :**
- `profiles` : Chaque utilisateur ne voit que son profil
- `rides` : Chaque utilisateur ne voit que ses rides
- `ratings` : Chaque utilisateur ne voit que ses ratings

**Tables publiques (lecture seule pour tous) :**
- `destinations` : Liste de toutes les destinations
- `opening_hours` : Horaires d'ouverture des destinations
- `roles` : Rôles disponibles dans l'application

## Appliquer les migrations

```bash
# Réinitialiser la base de données (applique toutes les migrations + seed)
supabase db reset

# Appliquer uniquement les nouvelles migrations
supabase db push
```

## Vérifier les migrations appliquées

```sql
SELECT * FROM supabase_migrations.schema_migrations
ORDER BY version;
```

## Rollback (en cas de problème)

Pour annuler une migration :

```bash
# Restaurer à un point spécifique
supabase db reset --version 20251029100001
```

⚠️ **Attention** : Le rollback supprime toutes les données ! Utilisez uniquement en développement.

## Documentation

Pour plus de détails sur la sécurité RLS :
- [Guide de sécurité RLS](../docs/database/rls_security_guide.md)

