ai oublié de le# Dépannage GitHub Actions - Checklist Rapide

## ✅ Checklist avant de relancer

### 1. Vérifier les secrets GitHub (2 min)

Allez sur : `https://github.com/VOTRE_USERNAME/VOTRE_REPO/settings/secrets/actions`

Vérifiez que vous avez **3 secrets** configurés :

| Secret | Comment le vérifier |
|--------|---------------------|
| `SUPABASE_PROJECT_ID` | Doit être visible dans la liste (valeur masquée) |
| `SUPABASE_ACCESS_TOKEN` | Doit être visible dans la liste (valeur masquée) |
| `SUPABASE_DB_PASSWORD` | Doit être visible dans la liste (valeur masquée) |

⚠️ Si un secret manque ou est mal configuré, **supprimez-le et recréez-le**.

### 2. Obtenir les bonnes valeurs

#### SUPABASE_PROJECT_ID
```
1. Allez sur https://app.supabase.com
2. Sélectionnez votre projet
3. L'URL ressemble à : https://app.supabase.com/project/abcdefghijklmnop
4. Copiez uniquement : abcdefghijklmnop
```

#### SUPABASE_ACCESS_TOKEN
```
1. Allez sur https://app.supabase.com/account/tokens
2. Cliquez sur "Generate new token"
3. Nom : "GitHub Actions Production"
4. Copiez le token (commence par sbp_)
5. ⚠️ Vous ne pourrez plus le voir après !
```

#### SUPABASE_DB_PASSWORD
```
1. Allez sur https://app.supabase.com/project/VOTRE_PROJECT_ID/settings/database
2. Scrollez jusqu'à "Database Password"
3. Si vous l'avez perdu : cliquez sur "Reset Database Password"
4. Copiez le nouveau mot de passe
5. ⚠️ Mettez à jour votre .env local aussi !
```

### 3. Vérifier les migrations localement (3 min)

```bash
# 1. Démarrer Supabase local
make db-start

# 2. Réinitialiser avec toutes les migrations
make db-reset

# 3. Si ça échoue, il y a un problème dans vos migrations
# Corrigez-les avant de pusher !
```

### 4. Relancer le workflow

#### Option A : Relancer le dernier workflow
```
1. Allez dans l'onglet "Actions"
2. Cliquez sur le workflow échoué
3. Cliquez sur "Re-run failed jobs"
```

#### Option B : Forcer un nouveau déploiement
```bash
git commit --allow-empty -m "chore: retry github actions deployment"
git push
```

---

## 🔍 Diagnostic des erreurs courantes

### Erreur 1 : "Failed to link to project"

**Message d'erreur :**
```
Error: Failed to link to Supabase project
```

**Cause :** `SUPABASE_PROJECT_ID` incorrect

**Solution :**
1. Vérifiez votre Project ID sur https://app.supabase.com
2. Supprimez et recréez le secret `SUPABASE_PROJECT_ID`
3. Relancez le workflow

---

### Erreur 2 : "Invalid access token"

**Message d'erreur :**
```
Error: Invalid access token
Error: Authentication failed
```

**Cause :** `SUPABASE_ACCESS_TOKEN` expiré ou incorrect

**Solution :**
1. Générez un nouveau token : https://app.supabase.com/account/tokens
2. Supprimez l'ancien secret `SUPABASE_ACCESS_TOKEN`
3. Créez un nouveau secret avec le nouveau token
4. Relancez le workflow

---

### Erreur 3 : "Database connection failed"

**Message d'erreur :**
```
Error: Failed to connect to database
Error: password authentication failed
```

**Cause :** `SUPABASE_DB_PASSWORD` incorrect

**Solution :**
1. Allez sur Settings > Database dans Supabase
2. Réinitialisez le mot de passe
3. Mettez à jour le secret `SUPABASE_DB_PASSWORD`
4. Mettez à jour votre `.env` local aussi !
5. Relancez le workflow

---

### Erreur 4 : "Migration already applied"

**Message d'erreur :**
```
Error: Migration 20251030000000_xxx.sql has already been applied
```

**Cause :** Vous essayez d'appliquer une migration déjà en prod

**Solution :**
```bash
# Si vous avez modifié une migration déjà appliquée, créez-en une nouvelle :
make db-migration name=fix_previous_migration

# Copiez vos modifications dans la nouvelle migration
# Poussez la nouvelle migration
```

---

### Erreur 5 : "Duplicate migration timestamp"

**Message d'erreur :**
```
Error: Multiple migrations with timestamp 20251030000000
```

**Cause :** Vous avez 2 fichiers avec le même timestamp

**Solution :**
```bash
# Listez vos migrations
ls -la supabase/migrations/

# Si vous voyez des doublons, supprimez le fichier en trop
rm supabase/migrations/20251030000000_duplicate.sql

# Ou renommez-le avec un nouveau timestamp
mv supabase/migrations/20251030000000_old.sql \
   supabase/migrations/20251030000001_corrected.sql
```

---

### Erreur 6 : "Permission denied"

**Message d'erreur :**
```
Error: You don't have permission to push migrations
```

**Cause :** Token sans droits suffisants

**Solution :**
1. Supprimez votre token actuel : https://app.supabase.com/account/tokens
2. Générez un nouveau token avec **tous les droits**
3. Mettez à jour `SUPABASE_ACCESS_TOKEN`
4. Relancez le workflow

---

## 📊 Comment lire les logs GitHub Actions

### Étape par étape :

1. **Checkout code** ✅
   - Si ça échoue : problème avec votre repository GitHub

2. **Setup Supabase CLI** ✅
   - Si ça échoue : problème avec l'action GitHub (rare)

3. **Verify Supabase CLI installation** ✅
   - Si ça échoue : problème d'installation Supabase CLI

4. **Link to Supabase project** ❌ (Échec fréquent)
   - Si ça échoue : vérifiez `SUPABASE_PROJECT_ID` et `SUPABASE_DB_PASSWORD`

5. **Check migration status** ℹ️
   - Liste les migrations déjà appliquées
   - Utile pour débugger

6. **Run migrations** ❌ (Échec fréquent)
   - Si ça échoue : problème dans une migration SQL
   - Testez localement avec `make db-reset`

---

## 🚀 Test rapide de votre configuration

Ajoutez temporairement cette étape dans votre workflow pour débugger :

```yaml
- name: Debug configuration
  run: |
    echo "=== Configuration Check ==="
    echo "Project ID length: ${#SUPABASE_PROJECT_ID}"
    echo "Token length: ${#SUPABASE_ACCESS_TOKEN}"
    echo "Password length: ${#SUPABASE_DB_PASSWORD}"
    echo "Supabase CLI version:"
    supabase --version
    echo "==========================="
```

**Valeurs attendues :**
- Project ID length: ~20 caractères
- Token length: ~40+ caractères (commence par `sbp_`)
- Password length: 20+ caractères

⚠️ **IMPORTANT :** Ne loggez JAMAIS les valeurs réelles ! Supprimez cette étape après le debug.

---

## 📞 Besoin d'aide ?

1. **Vérifiez les logs** : L'erreur exacte est dans les logs GitHub Actions
2. **Testez en local** : `make db-reset` doit fonctionner avant de pusher
3. **Relisez cette checklist** : 90% des problèmes sont des secrets mal configurés
4. **Documentation Supabase** : https://supabase.com/docs/guides/cli

---

## ✅ Workflow validé

Une fois que tout fonctionne, vous devriez voir :

```
✅ Checkout code
✅ Setup Supabase CLI  
✅ Verify Supabase CLI installation
✅ Link to Supabase project
✅ Check migration status
✅ Run migrations
✅ Notification on success

🎉 Migrations deployed successfully to Supabase!
```

Bravo ! Vos migrations sont maintenant déployées automatiquement. 🚀

