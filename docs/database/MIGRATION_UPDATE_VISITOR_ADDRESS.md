d  # ✅ Migration : Mise à jour de l'adresse du profil VISITOR

## 🎯 Objectif

Mettre à jour l'adresse du profil VISITOR avec la nouvelle adresse : **"1 place de La LUNE 24000 LA LUNE"**

## 📦 Fichiers Créés/Modifiés

### 1. **Nouvelle Migration** ✅
**Fichier :** `supabase/migrations/20251029100001_update_visitor_address.sql`

```sql
-- Mettre à jour l'adresse du profil VISITOR
UPDATE public.profiles
SET address = '1 place de La LUNE 24000 LA LUNE'
WHERE id = '00000000-0000-0000-0000-000000000000'::uuid
  AND (address IS NULL OR address = '' OR address = '1 Rue de La Lune 24000 La LUNE');
```

**Ce que fait cette migration :**
- ✅ Met à jour l'adresse si elle est NULL
- ✅ Met à jour l'adresse si elle est vide ('')
- ✅ Met à jour l'adresse si c'est l'ancienne valeur ('1 Rue de La Lune 24000 La LUNE')
- ✅ Ne touche pas aux autres profils (uniquement le VISITOR)

### 2. **Seed Modifié** ✅
**Fichier :** `supabase/seed.sql`

**Modification :**
```sql
-- Avant
address = '1 Rue de La Lune 24000 La LUNE',

-- Après
address = '1 place de La LUNE 24000 LA LUNE',

-- Dans le ON CONFLICT (ajouté)
on conflict (id) do update set
  role_id = (select id from public.roles where name = 'VISITOR' limit 1),
  first_name = 'Visiteur',
  last_name = 'Anonyme',
  address = '1 place de La LUNE 24000 LA LUNE',  -- ← AJOUTÉ
  birthdate = '1970-01-01'::date;
```

## 🚀 Comment Appliquer

### Option 1 : Base Locale (Docker)

```bash
# Réinitialiser la base locale (applique toutes les migrations + seed)
make db-reset
```

**Résultat :**
- ✅ Nouvelle migration appliquée
- ✅ Profil VISITOR avec la nouvelle adresse

### Option 2 : Base Distante (Supabase.io)

#### Via CLI
```bash
# Pousser la nouvelle migration
make db-push
```

#### Via Supabase Studio (Plus Rapide)
1. Aller sur https://app.supabase.com
2. SQL Editor
3. Copier-coller ce SQL :
   ```sql
   UPDATE public.profiles
   SET address = '1 place de La LUNE 24000 LA LUNE'
   WHERE id = '00000000-0000-0000-0000-000000000000'::uuid
     AND (address IS NULL OR address = '' OR address = '1 Rue de La Lune 24000 La LUNE');
   ```
4. Cliquer sur **Run**
5. ✅ Done !

## ✅ Vérification

### Via SQL
```sql
SELECT first_name, last_name, address
FROM public.profiles
WHERE id = '00000000-0000-0000-0000-000000000000'::uuid;
```

**Résultat attendu :**
```
first_name: Visiteur
last_name: Anonyme
address: 1 place de La LUNE 24000 LA LUNE  ← ✅
```

### Via l'Application Flutter

1. Lancer l'app sans être connecté (mode VISITOR)
   ```bash
   make local  # ou make dev
   ```

2. Aller dans la page **Profil**

3. Vérifier le champ **Adresse** :
   - **Avant :** "1 Rue de La Lune 24000 La LUNE"
   - **Après :** "1 place de La LUNE 24000 LA LUNE" ✅

## 📊 Changements

| Avant | Après |
|-------|-------|
| 1 **Rue** de La Lune 24000 **La** LUNE | 1 **place** de La LUNE 24000 **LA** LUNE |

**Différences :**
- ✅ "Rue" → "place"
- ✅ "La" → "LA" (tout en majuscules)

## 🎯 Impact

### Base Locale (Docker)
- ✅ Appliquée automatiquement lors du prochain `make db-reset`
- ✅ Seed mis à jour, donc toujours la bonne adresse lors des réinitialisations

### Base Distante (Supabase.io)
- ⚠️ À appliquer manuellement via `make db-push` ou Studio

### Application Flutter
- ✅ Aucun changement de code nécessaire
- ✅ L'adresse sera automatiquement récupérée depuis la BDD
- ✅ Affichage immédiat dans le formulaire de profil

## 📝 Ordre des Migrations

```
20251029072113_remote_schema.sql                    (Schéma initial)
20251029100000_add_birthdate_to_profiles.sql        (Ajout birthdate)
20251029100001_update_visitor_address.sql           (Nouvelle adresse) ← NOUVEAU
```

## 🎉 Résultat Final

Une fois appliquée, le profil VISITOR aura :

```
Profil VISITOR :
├─ Prénom : Visiteur
├─ Nom : Anonyme
├─ Email : visitor@boxtobikers.local
├─ Téléphone : (vide)
├─ Adresse : 1 place de La LUNE 24000 LA LUNE ✨
└─ Date de naissance : 01/01/1970
```

---

**✅ Migration créée et prête à être appliquée !**

**Prochaines étapes :**
1. Base locale : `make db-reset`
2. Base distante : `make db-push` ou via Studio
3. Tester l'app : Vérifier que la nouvelle adresse s'affiche

