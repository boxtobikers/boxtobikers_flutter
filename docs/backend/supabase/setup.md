# 🔧 Configuration Supabase

Guide de configuration de Supabase pour BoxToBikers.

---

## 🎯 Prérequis

1. Un compte Supabase (gratuit sur https://supabase.com)
2. Un projet créé dans Supabase
3. Variables d'environnement configurées

---

## 📋 Étapes de Configuration

### 1. Créer un Projet Supabase

1. Allez sur https://supabase.com/dashboard
2. Cliquez sur "New Project"
3. Remplissez les informations :
   - **Name:** BoxToBikers
   - **Database Password:** (générez-en un fort)
   - **Region:** Choisissez la plus proche
4. Cliquez sur "Create Project"

### 2. Récupérer les Clés

1. Dans le dashboard, allez dans **Settings → API**
2. Copiez :
   - **Project URL** (ex: https://xxxxx.supabase.co)
   - **anon public** key (commence par eyJhbGc...)

### 3. Configurer l'Application

Éditez `config/dev.json` :

```json
{
  "SUPABASE_URL": "https://votre-projet.supabase.co",
  "SUPABASE_ANON_KEY": "votre_cle_anon",
  "ENV": "development"
}
```

**[Guide complet des variables d'env →](../../environment/configuration.md)**

### 4. Créer les Tables

Dans l'éditeur SQL Supabase, créez vos tables :

```sql
-- Table users
CREATE TABLE users (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  role TEXT DEFAULT 'user',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Activer RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Politiques RLS
CREATE POLICY "Users can view own profile"
ON users FOR SELECT
USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
ON users FOR UPDATE
USING (auth.uid() = id);
```

### 5. Tester la Connexion

```bash
flutter pub get
make dev
```

Vous devriez voir :
```
✅ Supabase initialisé : https://votre-projet.supabase.co
```

---

## 🔒 Sécurité

### Row Level Security (RLS)

**Activez toujours RLS** sur vos tables :

```sql
ALTER TABLE nom_table ENABLE ROW LEVEL SECURITY;
```

### Politiques d'Accès

Exemples de politiques courantes :

```sql
-- Lecture : tout le monde
CREATE POLICY "Public read"
ON table_name FOR SELECT
TO public
USING (true);

-- Écriture : utilisateurs authentifiés uniquement
CREATE POLICY "Authenticated write"
ON table_name FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Modification : propriétaire uniquement
CREATE POLICY "Owner update"
ON table_name FOR UPDATE
USING (auth.uid() = user_id);
```

### Authentication

Configurez l'authentification dans **Authentication → Settings** :
- Email confirmation (optionnel)
- Password requirements
- OAuth providers (optionnel)

---

## 📚 Ressources

- **[Guide Supabase](README.md)** - Utilisation
- **[Exemples](examples/)** - Code d'exemple
- **[Dashboard](https://supabase.com/dashboard)** - Console

---

📖 **[Retour à la documentation →](../../README.md)**

