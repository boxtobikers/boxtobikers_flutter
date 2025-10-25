# Migration depuis un schéma Supabase existant

Si vous avez déjà une base de données Supabase en production, voici comment synchroniser vos migrations locales.

## Situation

Vous avez :
- ✅ Une base de données Supabase en production
- ✅ Des tables, functions, policies déjà créées via l'interface
- ❌ Pas de migrations versionnées

## Solution : Générer les migrations depuis la production

### Étape 0 : Se connecter à Supabase (une seule fois)

```bash
make db-login
```

Votre navigateur va s'ouvrir pour vous authentifier. Suivez les instructions.

### Étape 1 : Lier votre projet

```bash
make db-link ref=VOTRE_PROJECT_REF
```

Trouvez votre `PROJECT_REF` dans l'URL de votre projet Supabase :
```
https://app.supabase.com/project/abcdefghijklmnop
                                    ^^^^^^^^^^^^^^^^
                                    C'est votre ref
```

### Étape 2 : Créer une migration depuis la production

```bash
# Supprimer la migration initiale (si vous en avez une)
rm supabase/migrations/20241025000000_init_schema.sql

# Générer une nouvelle migration depuis la prod
cd supabase
supabase db pull
```

Cela va créer un fichier dans `supabase/migrations/` avec tout votre schéma actuel.

### Étape 3 : Vérifier la migration générée

```bash
cat supabase/migrations/XXXXXX_remote_commit.sql
```

Ce fichier contient :
- Toutes vos tables
- Tous vos indexes
- Toutes vos functions
- Toutes vos policies RLS
- Toutes vos views

### Étape 4 : Tester localement

```bash
make db-reset
```

Cela va :
1. Arrêter Supabase local
2. Supprimer les données
3. Réappliquer toutes les migrations
4. Redémarrer

### Étape 5 : Vérifier dans Studio

```bash
open http://localhost:54323
```

Vérifiez que tout est identique à votre production.

### Étape 6 : Renommer la migration (optionnel)

Pour plus de clarté, vous pouvez renommer :

```bash
cd supabase/migrations
mv XXXXXX_remote_commit.sql YYYYMMDD000000_initial_schema_from_production.sql
```

### Étape 7 : Commiter

```bash
git add supabase/migrations/
git commit -m "feat: import existing schema from production"
git push
```

## Workflow futur

Maintenant que votre schéma est versionné, utilisez le workflow normal :

### Méthode 1 : Créer via Studio local puis générer la migration

```bash
# 1. Démarrer localement
make db-start

# 2. Faire vos modifications dans Studio local
open http://localhost:54323

# 3. Générer la migration depuis les différences
make db-diff-migration name=description_du_changement

# 4. Vérifier la migration
cat supabase/migrations/XXXXXX_description_du_changement.sql

# 5. Pousser vers la prod
make db-push

# 6. Commiter
git add supabase/migrations/
git commit -m "feat: description du changement"
git push
```

### Méthode 2 : Écrire la migration manuellement

```bash
# 1. Créer une migration vide
make db-migration name=add_new_feature

# 2. Éditer le fichier
nano supabase/migrations/XXXXXX_add_new_feature.sql

# 3. Tester localement
make db-reset

# 4. Pousser vers la prod
make db-push

# 5. Commiter
git add supabase/migrations/
git commit -m "feat: add new feature"
git push
```

## Synchronisation régulière

Si quelqu'un fait des changements directement en production (à éviter !), vous pouvez les récupérer :

```bash
# Voir les différences
make db-diff

# Générer une migration depuis les différences
cd supabase
supabase db diff -f sync_from_production

# Vérifier
cat migrations/XXXXXX_sync_from_production.sql

# Appliquer localement
make db-reset

# Commiter
git add migrations/
git commit -m "sync: import changes from production"
git push
```

## Bonnes pratiques

### ✅ À faire

- Toujours faire les changements localement d'abord
- Tester avec `make db-reset`
- Vérifier dans Studio local
- Puis pousser vers la prod avec `make db-push`
- Toujours commiter les migrations dans Git

### ❌ À éviter

- Ne pas faire de changements directement en production
- Ne pas modifier une migration déjà déployée
- Ne pas supprimer des migrations déjà appliquées

## Cas particuliers

### J'ai fait une erreur en production

```bash
# 1. Créer une migration de rollback
make db-migration name=rollback_previous_change

# 2. Écrire le SQL inverse
# Exemple : DROP TABLE au lieu de CREATE TABLE

# 3. Tester localement
make db-reset

# 4. Appliquer en prod
make db-push

# 5. Commiter
git add supabase/migrations/
git commit -m "fix: rollback previous change"
git push
```

### Je veux un backup avant de migrer

```bash
# Créer un dump de la prod
make db-dump

# Ou via la CLI
cd supabase
supabase db dump -f backup_before_migration_$(date +%Y%m%d).sql --db-url "postgresql://..."
```

### Je veux tester une migration sur un environnement de staging

```bash
# 1. Créer un projet Supabase de staging
# 2. Le lier
cd supabase
supabase link --project-ref STAGING_PROJECT_REF

# 3. Pousser les migrations
supabase db push

# 4. Tester votre app en staging
make staging

# 5. Si OK, pousser vers la prod
supabase link --project-ref PROD_PROJECT_REF
supabase db push
```

## Ressources

- [Documentation Supabase CLI](https://supabase.com/docs/guides/cli)
- [Guide des migrations](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [Guide de ce projet](SETUP_GUIDE.md)

