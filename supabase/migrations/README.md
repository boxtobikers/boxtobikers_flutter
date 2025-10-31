# Migrations Supabase - BoxToBikers

## Ordre des migrations

Les migrations sont appliquées dans l'ordre chronologique basé sur leur timestamp.

### Migrations principales

1. **20251029072113_remote_schema.sql** - Schéma initial de la base de données
2. **20251029100000_add_birthdate_to_profiles.sql** - Ajout du champ birthdate aux profils
3. **20251029100001_update_visitor_address.sql** - Mise à jour de l'adresse du profil VISITOR

### Migrations de sécurité RLS (30 octobre 2025)

⚠️ **MIGRATION MUTUALISÉE** : Toutes les migrations du 30 octobre ont été fusionnées en une seule pour simplifier le déploiement.

4. **20251030000000_security_and_visitor_improvements.sql** ⚠️ **IMPORTANTE**
   
   Cette migration mutualisée contient 6 parties :
   
   **Partie 1 : Contrainte d'unicité sur rides**
   - Ajoute une contrainte d'unicité sur `(user_id, destination_id)` dans `rides`
   - Empêche les doublons : un utilisateur = un seul ride par destination
   
   **Partie 2 : Fonction `get_current_user_id()`**
   - Crée la fonction utilisée par toutes les politiques RLS
   - Retourne `auth.uid()` pour les utilisateurs authentifiés
   - Retourne l'UUID VISITOR pour les sessions anonymes
   
   **Partie 3 : Politiques RLS pour rides**
   - Remplace toutes les politiques de la table `rides`
   - Permet à chaque utilisateur (VISITOR inclus) d'accéder uniquement à ses rides
   
   **Partie 4 : Politiques RLS pour ratings**
   - Remplace toutes les politiques de la table `ratings`
   - Supprime la politique trop permissive "Everyone can read ratings"
   - Chaque utilisateur ne voit que ses propres ratings
   
   **Partie 5 : Politiques RLS pour profiles**
   - Remplace toutes les politiques de la table `profiles`
   - Chaque utilisateur ne peut accéder qu'à son propre profil
   
   **Partie 6 : Sécurisation des fonctions SECURITY DEFINER**
   - Ajoute `SET search_path = ''` à toutes les fonctions `SECURITY DEFINER`
   - Fonctions corrigées : `get_user_role`, `handle_new_user`, `is_user_admin`, `get_current_user_id`
   - Résout le warning Supabase Linter et protège contre les attaques par injection de schéma

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

## ⚠️ Migrations vs Seed : Données de test

**Règle importante :** Les données de test (destinations, rides, ratings de test) doivent être dans `seed.sql`, PAS dans les migrations.

### Pourquoi ?

1. **Ordre d'exécution** : Les migrations s'exécutent AVANT le seed
   - Si vous créez une migration qui insère des rides, mais que les destinations sont dans le seed, la migration échouera (foreign key violation)

2. **Les migrations sont pour la production** : 
   - Les migrations sont appliquées automatiquement en production via GitHub Actions
   - Le seed.sql n'est exécuté QUE en développement local (via `make db-reset`)

3. **Données de test ≠ Schéma** :
   - Migrations → Structure de la base (tables, colonnes, contraintes, fonctions, politiques RLS)
   - Seed → Données de test pour le développement local

### Exemple : Rides VISITOR

❌ **Mauvais** : Créer une migration `20251031000000_add_visitor_test_rides.sql`
```sql
-- ❌ Échouera car les destinations n'existent pas encore
INSERT INTO public.rides (user_id, destination_id, status) VALUES ...
```

✅ **Bon** : Ajouter les rides dans `supabase/seed.sql`
```sql
-- ✅ Fonctionne car les destinations sont aussi dans seed.sql
INSERT INTO public.rides (user_id, destination_id, status) VALUES ...
ON CONFLICT (user_id, destination_id) DO UPDATE SET ...
```

### Et en production ?

Si vous avez besoin de données initiales en production (par exemple, un profil VISITOR), vous avez deux options :

1. **Option A (Recommandée)** : Créer une migration complète avec TOUT (destinations + rides)
   ```sql
   -- 1. Insérer les destinations
   INSERT INTO public.destinations (...) VALUES (...);
   
   -- 2. Insérer les rides (maintenant les destinations existent)
   INSERT INTO public.rides (...) VALUES (...);
   ```

2. **Option B** : Exécuter manuellement le seed en production (via Supabase Dashboard → SQL Editor)

## Appliquer les migrations

### En local
```bash
# Réinitialiser la base de données (applique toutes les migrations + seed)
supabase db reset
# ou via Makefile
make db-reset

# Appliquer uniquement les nouvelles migrations
supabase db push
# ou via Makefile
make db-push
```

### En production (GitHub Actions)

Les migrations sont déployées automatiquement via GitHub Actions quand vous pushez sur `main`.

**🚨 Si le déploiement échoue :**
1. Consultez : `GITHUB_ACTIONS_QUICK_FIX.md` à la racine du projet
2. Guide complet : `docs/backend/supabase/TROUBLESHOOTING_GITHUB_ACTIONS.md`
3. Testez localement AVANT de pusher : `make db-validate`

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

