# Guide de dépannage rapide - Supabase

## Erreur : "Access token not provided"

**Message complet** :
```
2025/10/25 13:05:44 Access token not provided. Supply an access token by running supabase login or setting the SUPABASE_ACCESS_TOKEN environment variable.
make: *** [db-link] Error 1
```

**Cause** : Vous n'êtes pas authentifié auprès de Supabase.

**Solution** :
```bash
# 1. Se connecter à Supabase (votre navigateur va s'ouvrir)
make db-login

# 2. Ensuite, lier votre projet
make db-link ref=VOTRE_PROJECT_REF
```

**Alternative** : Utiliser une variable d'environnement
```bash
# Récupérez votre access token sur https://app.supabase.com/account/tokens
export SUPABASE_ACCESS_TOKEN=votre_token_ici

# Puis
make db-link ref=VOTRE_PROJECT_REF
```

---

## Erreur : Port déjà utilisé

**Message** :
```
Error: port 54321 already in use
```

**Solution** :
```bash
make db-stop
make db-start
```

**Si ça ne fonctionne pas** :
```bash
# Arrêter complètement
make db-stop

# Vérifier qu'il n'y a plus de containers
docker ps

# Redémarrer
make db-start
```

---

## Erreur : Docker daemon not running

**Message** :
```
Cannot connect to the Docker daemon
```

**Solution** :
1. Ouvrez Docker Desktop
2. Attendez qu'il soit complètement démarré (l'icône devient verte)
3. Relancez `make db-start`

---

## Erreur : Migration failed

**Message** :
```
Error applying migration XXXXX_nom.sql
```

**Solutions** :

1. **Vérifier la syntaxe SQL** :
   ```bash
   cat supabase/migrations/XXXXX_nom.sql
   ```

2. **Voir les logs détaillés** :
   ```bash
   make db-status
   docker logs supabase_db_flutter
   ```

3. **Tester dans Studio** :
   ```bash
   make db-start
   # Ouvrir http://localhost:54323
   # Copier/coller votre SQL dans l'éditeur
   ```

4. **Réinitialiser et retester** :
   ```bash
   make db-reset
   ```

---

## Erreur : Project ref not found

**Message** :
```
Error: project ref not found
```

**Cause** : Le project ref est incorrect ou le projet n'existe pas.

**Solution** :
1. Allez sur https://app.supabase.com
2. Sélectionnez votre projet
3. L'URL ressemble à `https://app.supabase.com/project/XXXXX`
4. Copiez le `XXXXX`
5. Relancez : `make db-link ref=XXXXX`

---

## Erreur : Supabase CLI not found

**Message** :
```
supabase: command not found
```

**Solution** :
```bash
# Installation sur macOS
brew install supabase/tap/supabase

# Vérifier l'installation
make check-supabase
```

---

## Erreur : Permission denied sur le script

**Message** :
```
Permission denied: ./check_supabase_setup.sh
```

**Solution** :
```bash
chmod +x check_supabase_setup.sh
chmod +x install_supabase.sh
make check-supabase
```

---

## Connexion perdue au projet distant

**Symptôme** : `make db-push` ou `make db-diff` ne fonctionnent plus.

**Solution** :
```bash
# Re-login
make db-login

# Re-link
make db-link ref=VOTRE_PROJECT_REF

# Retester
make db-push
```

---

## Base de données locale corrompue

**Symptôme** : Erreurs bizarres, comportement incohérent.

**Solution** :
```bash
# Arrêter complètement
make db-stop

# Supprimer les volumes Docker (⚠️ perte des données locales)
docker volume ls | grep supabase
docker volume rm supabase_db_data_flutter

# Redémarrer proprement
make db-start
```

---

## Migration déjà appliquée

**Message** :
```
Error: migration already applied
```

**Cause** : Vous essayez d'appliquer une migration qui existe déjà.

**Solution** :
1. **Ne jamais modifier une migration déjà appliquée**
2. Créez une nouvelle migration pour les changements :
   ```bash
   make db-migration name=fix_previous_migration
   ```

---

## Différences entre local et distant

**Symptôme** : `make db-diff` montre des différences inattendues.

**Cause** : Quelqu'un a modifié la prod directement.

**Solution** :
```bash
# 1. Voir les différences
make db-diff

# 2. Récupérer les changements de prod
cd supabase
supabase db pull

# 3. Vérifier la migration générée
cat migrations/XXXXXX_remote_commit.sql

# 4. Appliquer localement
make db-reset

# 5. Commiter
git add migrations/
git commit -m "sync: import changes from production"
git push
```

---

## Studio local ne s'ouvre pas

**Symptôme** : http://localhost:54323 ne répond pas.

**Solutions** :

1. **Vérifier que Supabase tourne** :
   ```bash
   make db-status
   ```

2. **Vérifier les ports** :
   ```bash
   docker ps | grep supabase
   ```

3. **Redémarrer** :
   ```bash
   make db-stop
   make db-start
   ```

4. **Vérifier les logs** :
   ```bash
   docker logs supabase_studio_flutter
   ```

---

## Générer types Dart échoue

**Message** :
```
Error generating types
```

**Solution** :
```bash
# S'assurer que Supabase local tourne
make db-start

# Vérifier qu'il y a des tables
open http://localhost:54323

# Regénérer les types
make db-types
```

---

## Commandes utiles pour débugger

```bash
# Voir tous les containers Supabase
docker ps | grep supabase

# Voir les logs d'un service
docker logs supabase_db_flutter
docker logs supabase_api_flutter
docker logs supabase_studio_flutter

# Voir le status complet
make db-status

# Vérifier la configuration
cat supabase/config.toml

# Lister les migrations
ls -la supabase/migrations/

# Vérifier l'installation
make check-supabase
```

---

## Toujours pas résolu ?

1. **Vérifier la documentation** :
   - [SETUP_GUIDE.md](SETUP_GUIDE.md)
   - [supabase/README.md](../../supabase/README.md)

2. **Réinitialiser complètement** :
   ```bash
   make db-stop
   # Attendre 10 secondes
   make db-start
   make db-reset
   ```

3. **Vérifier votre environnement** :
   ```bash
   make check-supabase
   ```

4. **Consulter les ressources externes** :
   - [Documentation Supabase CLI](https://supabase.com/docs/guides/cli)
   - [GitHub Issues](https://github.com/supabase/cli/issues)
   - [Discord Supabase](https://discord.supabase.com/)

