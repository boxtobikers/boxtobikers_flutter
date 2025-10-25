# Supabase Migrations

Ce dossier contient les migrations de base de données pour le projet Boxtobikers.

## Structure

- `migrations/` : Contient toutes les migrations SQL versionnées
- `seed.sql` : Données de seed pour le développement local
- `config.toml` : Configuration du CLI Supabase

## Utilisation

### Prérequis

Installer Supabase CLI :
```bash
brew install supabase/tap/supabase
```

### Commandes principales

#### 1. Démarrer Supabase en local
```bash
supabase start
```

Cette commande va :
- Démarrer un container Docker avec Postgres
- Appliquer toutes les migrations
- Exécuter le fichier seed.sql
- Vous donner les URLs d'accès (API, DB, Studio)

#### 2. Arrêter Supabase
```bash
supabase stop
```

#### 3. Créer une nouvelle migration
```bash
supabase migration new nom_de_la_migration
```

#### 4. Appliquer les migrations sur votre projet distant
```bash
# D'abord, lier votre projet
supabase link --project-ref VOTRE_PROJECT_REF

# Ensuite, pousser les migrations
supabase db push
```

#### 5. Générer les types TypeScript/Dart depuis le schéma
```bash
supabase gen types typescript --local > lib/core/models/database.types.ts
```

#### 6. Réinitialiser la base de données locale
```bash
supabase db reset
```

#### 7. Créer un dump du schéma actuel
```bash
supabase db dump -f supabase/schema_backup.sql
```

#### 8. Voir les différences entre local et distant
```bash
supabase db diff
```

## Workflow recommandé

### Développement local

1. Démarrer Supabase localement :
   ```bash
   supabase start
   ```

2. Faire vos modifications dans Supabase Studio (http://localhost:54323)

3. Générer une migration depuis les changements :
   ```bash
   supabase db diff -f nom_de_la_migration
   ```

4. Vérifier la migration générée dans `supabase/migrations/`

### Déploiement en production

1. Lier votre projet distant :
   ```bash
   supabase link --project-ref VOTRE_PROJECT_REF
   ```

2. Pousser les migrations :
   ```bash
   supabase db push
   ```

### Avec CI/CD (GitHub Actions)

Voir le fichier `.github/workflows/deploy_supabase.yml` pour le déploiement automatique.

## Variables d'environnement

Après `supabase start`, vous obtiendrez :
- `API URL` : http://localhost:54321
- `GraphQL URL` : http://localhost:54321/graphql/v1
- `DB URL` : postgresql://postgres:postgres@localhost:54322/postgres
- `Studio URL` : http://localhost:54323
- `Inbucket URL` : http://localhost:54324
- `anon key` : Clé publique pour les requêtes anonymes
- `service_role key` : Clé pour les opérations admin

## Sauvegarde et versioning

Toutes les migrations sont versionnées dans Git. Chaque migration a un timestamp unique dans son nom de fichier (format: `YYYYMMDDHHMMSS_description.sql`).

**Important** : Ne modifiez jamais une migration déjà appliquée en production. Créez toujours une nouvelle migration pour les changements.

## Troubleshooting

### Erreur de port déjà utilisé
```bash
supabase stop
supabase start
```

### Réinitialiser complètement
```bash
supabase stop --no-backup
supabase start
```

### Voir les logs
```bash
supabase status
```

