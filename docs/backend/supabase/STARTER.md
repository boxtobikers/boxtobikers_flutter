# 🔧 Configuration Supabase - Démarrage rapide

Guide de démarrage rapide pour configurer Supabase sur BoxToBikers.

> **💡 Pour le guide complet**, consultez **[SETUP_GUIDE.md](SETUP_GUIDE.md)**

---

## ⚡ Configuration en 5 minutes

### 1. Créer un compte et un projet Supabase

1. Allez sur https://supabase.com/dashboard
2. Créez un nouveau projet "BoxToBikers"
3. Notez le mot de passe de la base de données

### 2. Récupérer vos clés

Dans **Settings → API**, copiez :
- Project URL
- anon public key

### 3. Configurer l'application

Éditez `config/dev.json` :

```json
{
  "SUPABASE_URL": "https://votre-projet.supabase.co",
  "SUPABASE_ANON_KEY": "votre_cle_anon",
  "ENV": "development"
}
```

### 4. Installer Supabase CLI

```bash
# macOS
brew install supabase/tap/supabase

# Vérifier
make check-supabase
```

### 5. Démarrer en local

```bash
# Installer Docker Desktop d'abord
# Puis :
make db-start

# Accéder à Studio
open http://localhost:54323
```

### 6. Tester l'application

```bash
flutter pub get
make dev
```

✅ Si vous voyez "Supabase initialisé", c'est bon !

---

## 📖 Aller plus loin

| Guide | Quand l'utiliser |
|-------|------------------|
| **[SETUP_GUIDE.md](SETUP_GUIDE.md)** | Guide complet : migrations, workflow, déploiement |
| **[GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md)** | Configurer le déploiement automatique |
| **[MIGRATION_FROM_EXISTING.md](MIGRATION_FROM_EXISTING.md)** | Vous avez déjà une base en production |
| **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** | Résoudre les problèmes courants |

---

## 🔒 Sécurité - Les bases

### Toujours activer RLS

```sql
ALTER TABLE votre_table ENABLE ROW LEVEL SECURITY;
```

### Exemple de policy simple

```sql
-- Les utilisateurs voient uniquement leurs données
CREATE POLICY "Users read own data"
ON votre_table FOR SELECT
USING (auth.uid() = user_id);
```

**[En savoir plus sur la sécurité →](SETUP_GUIDE.md#securite-et-bonnes-pratiques)**

---

## 🚀 Commandes essentielles

```bash
# Base de données locale
make db-start          # Démarrer Supabase
make db-stop           # Arrêter
make db-reset          # Réinitialiser (migrations + seed)

# Migrations
make db-migration name=XXX           # Créer migration vide
make db-diff-migration name=XXX      # Générer depuis changements

# Application
make dev               # Lancer en développement
```

**[Voir toutes les commandes →](SETUP_GUIDE.md#commandes-disponibles)**

---

📖 **[Documentation complète →](README.md)** • **[Guide complet →](SETUP_GUIDE.md)**

