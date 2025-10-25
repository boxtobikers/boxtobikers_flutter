# Configuration GitHub Actions pour Supabase

Ce guide vous explique comment configurer le déploiement automatique des migrations Supabase via GitHub Actions.

## Prérequis

1. Un compte GitHub avec un repository pour votre projet
2. Un projet Supabase (gratuit ou payant)
3. Accès aux paramètres du repository GitHub

## Étapes de configuration

### 1. Récupérer les informations Supabase

Connectez-vous à votre [Dashboard Supabase](https://app.supabase.com) et récupérez :

#### a) Project Reference ID
- Allez sur votre projet
- L'URL ressemble à : `https://app.supabase.com/project/VOTRE_PROJECT_REF`
- Copiez la partie `VOTRE_PROJECT_REF` (ex: `abcdefghijklmnop`)

#### b) Database Password
- Allez dans `Settings` > `Database`
- Notez le mot de passe de votre base de données
- ⚠️ Si vous l'avez perdu, vous devrez le réinitialiser

#### c) Access Token
- Allez sur https://app.supabase.com/account/tokens
- Cliquez sur `Generate new token`
- Donnez-lui un nom (ex: "GitHub Actions")
- Copiez le token généré (vous ne pourrez plus le voir après)

### 2. Configurer les secrets GitHub

1. Allez sur votre repository GitHub
2. Cliquez sur `Settings` > `Secrets and variables` > `Actions`
3. Cliquez sur `New repository secret`
4. Ajoutez les trois secrets suivants :

| Nom du secret | Valeur | Description |
|--------------|--------|-------------|
| `SUPABASE_PROJECT_ID` | Votre project ref | L'ID de votre projet Supabase |
| `SUPABASE_ACCESS_TOKEN` | Votre access token | Token d'accès API |
| `SUPABASE_DB_PASSWORD` | Votre DB password | Mot de passe de la base de données |

### 3. Vérifier le workflow

Le workflow est déjà configuré dans `.github/workflows/deploy_supabase.yml`.

Il se déclenche automatiquement quand :
- Vous pushez sur `main` ou `master`
- Les fichiers dans `supabase/migrations/` sont modifiés
- Vous le lancez manuellement (via l'onglet Actions)

### 4. Tester le déploiement

#### Test manuel

1. Allez dans l'onglet `Actions` de votre repository
2. Sélectionnez le workflow `Deploy Supabase Migrations`
3. Cliquez sur `Run workflow`
4. Vérifiez que tout se passe bien ✅

#### Test automatique

1. Créez une nouvelle migration :
   ```bash
   make db-migration name=test_deploy
   ```

2. Éditez le fichier créé dans `supabase/migrations/`

3. Commitez et pushez :
   ```bash
   git add supabase/migrations/
   git commit -m "feat: add test migration"
   git push
   ```

4. Le workflow devrait se lancer automatiquement dans l'onglet Actions

## Workflow de développement recommandé

### En local

```bash
# 1. Démarrer Supabase en local
make db-start

# 2. Faire vos modifications dans Supabase Studio
# Ouvrez http://localhost:54323

# 3. Générer une migration depuis vos changements
make db-diff-migration name=description_du_changement

# 4. Vérifier la migration générée
cat supabase/migrations/XXXXXX_description_du_changement.sql

# 5. Tester la migration localement
make db-reset

# 6. Si tout est OK, commiter et pusher
git add supabase/migrations/
git commit -m "feat: description du changement"
git push
```

### Déploiement

Le déploiement est automatique ! Une fois que vous pushez sur `main`, GitHub Actions :
1. ✅ Récupère le code
2. ✅ Installe Supabase CLI
3. ✅ Se connecte à votre projet
4. ✅ Applique les migrations
5. ✅ Vous notifie du succès ou de l'échec

## Commandes utiles

```bash
# Voir toutes les commandes disponibles
make help

# Base de données
make db-start          # Démarrer Supabase local
make db-stop           # Arrêter Supabase local
make db-reset          # Réinitialiser la DB locale
make db-status         # Voir le status
make db-migration name=XXX  # Créer une migration
make db-diff-migration name=XXX  # Générer migration depuis diff
make db-push           # Pousser vers le serveur
make db-link ref=XXX   # Lier au projet distant
make db-types          # Générer les types Dart
make db-dump           # Créer un backup
```

## Dépannage

### Erreur : "Project ref not found"
- Vérifiez que `SUPABASE_PROJECT_ID` est correct
- Le format doit être comme `abcdefghijklmnop` (sans espaces)

### Erreur : "Authentication failed"
- Vérifiez que `SUPABASE_ACCESS_TOKEN` est valide
- Générez un nouveau token si nécessaire

### Erreur : "Database password incorrect"
- Vérifiez `SUPABASE_DB_PASSWORD`
- Vous pouvez le réinitialiser dans Settings > Database

### Les migrations ne se lancent pas automatiquement
- Vérifiez que le fichier workflow est dans `.github/workflows/`
- Vérifiez que vous pushez sur `main` ou `master`
- Vérifiez que les modifications touchent `supabase/migrations/**`

### Migration échoue en production
- Testez d'abord localement avec `make db-reset`
- Vérifiez les logs dans l'onglet Actions
- Les migrations sont idempotentes (utilisez `IF NOT EXISTS`, etc.)

## Sécurité

⚠️ **Important** :
- Ne commitez JAMAIS vos secrets dans Git
- Utilisez toujours les GitHub Secrets
- Ne partagez pas vos tokens d'accès
- Régénérez les tokens si compromis

## Ressources

- [Documentation Supabase CLI](https://supabase.com/docs/guides/cli)
- [Documentation GitHub Actions](https://docs.github.com/en/actions)
- [Documentation migrations Supabase](https://supabase.com/docs/guides/cli/local-development#database-migrations)

