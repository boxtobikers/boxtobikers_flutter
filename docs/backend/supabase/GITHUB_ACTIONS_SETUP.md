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

### ❌ Job "deploy" failed

**Causes possibles et solutions :**

#### 1. Erreur : "Project ref not found"
- ✅ Vérifiez que `SUPABASE_PROJECT_ID` est correct dans GitHub Secrets
- ✅ Le format doit être comme `abcdefghijklmnop` (sans espaces, sans tirets)
- ✅ Trouvez-le dans l'URL : `https://app.supabase.com/project/VOTRE_ID`

#### 2. Erreur : "Authentication failed" ou "Invalid access token"
- ✅ Vérifiez que `SUPABASE_ACCESS_TOKEN` est valide
- ✅ Le token doit commencer par `sbp_`
- ✅ Générez un nouveau token sur https://app.supabase.com/account/tokens
- ✅ Mettez à jour le secret GitHub immédiatement après

#### 3. Erreur : "Database password incorrect" ou "Connection refused"
- ✅ Vérifiez `SUPABASE_DB_PASSWORD` dans GitHub Secrets
- ✅ Le mot de passe est celui défini lors de la création du projet
- ✅ Vous pouvez le réinitialiser dans Settings > Database > Database Password
- ⚠️ Après réinitialisation, mettez à jour le secret GitHub

#### 4. Erreur : "supabase link" échoue
- ✅ Le workflow a été corrigé pour passer `--password $SUPABASE_DB_PASSWORD`
- ✅ Vérifiez que les 3 secrets sont bien définis
- ✅ Relancez le workflow après correction

#### 5. Les migrations ne se lancent pas automatiquement
- ✅ Vérifiez que le fichier workflow est dans `.github/workflows/deploy_supabase.yml`
- ✅ Vérifiez que vous pushez sur `main` ou `master`
- ✅ Vérifiez que les modifications touchent `supabase/migrations/**`
- ✅ Le workflow peut être lancé manuellement via l'onglet Actions

#### 6. Migration échoue en production mais fonctionne en local
- ✅ Testez d'abord localement avec `make db-reset`
- ✅ Vérifiez les logs complets dans l'onglet Actions
- ✅ Les migrations doivent être idempotentes : utilisez `IF NOT EXISTS`, `DROP IF EXISTS`, etc.
- ✅ Vérifiez qu'il n'y a pas de conflit de noms de migration (pas de doublons)
- ✅ Assurez-vous que les migrations sont dans l'ordre chronologique

#### 7. Comment voir les logs détaillés ?
1. Allez dans l'onglet `Actions` de votre repository
2. Cliquez sur le workflow qui a échoué
3. Cliquez sur le job `deploy`
4. Dépliez chaque étape pour voir les détails
5. Cherchez les messages d'erreur en rouge

#### 8. Vérifier que les secrets sont bien configurés
```bash
# Dans l'onglet Actions, ajoutez une étape temporaire de debug :
- name: Debug secrets (TEMPORARY - REMOVE AFTER)
  run: |
    echo "Project ID length: ${#SUPABASE_PROJECT_ID}"
    echo "Token length: ${#SUPABASE_ACCESS_TOKEN}"
    echo "Password length: ${#SUPABASE_DB_PASSWORD}"
```
⚠️ **Ne loggez JAMAIS les valeurs réelles des secrets !**

### 🔄 Workflow de correction

Si votre job échoue :

1. **Vérifiez les logs** : Identifiez l'étape qui échoue
2. **Corrigez le problème** : Secrets, migration, etc.
3. **Relancez** : 
   - Via l'onglet Actions > Re-run failed jobs
   - Ou poussez un nouveau commit avec `git commit --allow-empty -m "chore: trigger workflow"`
4. **Testez en local** : Toujours tester avec `make db-reset` avant de pusher

## Sécurité

⚠️ **Important** :
- Ne commitez JAMAIS vos secrets dans Git
- Utilisez toujours les GitHub Secrets
- Ne partagez pas vos tokens d'accès
- Régénérez les tokens si compromis

## 🆘 Dépannage approfondi

Pour un guide de dépannage complet avec toutes les erreurs courantes et leurs solutions, consultez :

👉 **[TROUBLESHOOTING_GITHUB_ACTIONS.md](./TROUBLESHOOTING_GITHUB_ACTIONS.md)**

Ce guide contient :
- ✅ Checklist rapide avant de relancer
- 🔍 Diagnostic des 8 erreurs les plus fréquentes
- 📊 Comment lire les logs GitHub Actions
- 🚀 Script de validation automatique : `make db-validate`

## Ressources

- [Documentation Supabase CLI](https://supabase.com/docs/guides/cli)
- [Documentation GitHub Actions](https://docs.github.com/en/actions)
- [Documentation migrations Supabase](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [Guide de dépannage complet](./TROUBLESHOOTING_GITHUB_ACTIONS.md)

