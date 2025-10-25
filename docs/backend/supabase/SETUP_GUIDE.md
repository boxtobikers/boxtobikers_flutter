# Guide de mise en place Supabase pour Boxtobikers

Ce guide complet explique comment configurer et utiliser Supabase pour BoxToBikers, incluant le système de versioning et le déploiement automatique de la base de données.

## 📋 Vue d'ensemble

Votre projet est configuré pour :
- ✅ Versionner votre schéma de base de données dans Git
- ✅ Tester localement avec Supabase CLI
- ✅ Déployer automatiquement via GitHub Actions
- ✅ Avoir un historique complet des changements
- ✅ Row Level Security (RLS) pour la sécurité des données
- ✅ Authentication intégrée

## 🎯 Prérequis

1. Un compte Supabase (gratuit sur https://supabase.com)
2. Un projet créé dans Supabase
3. Docker Desktop installé et démarré
4. Supabase CLI installé

## 🚀 Configuration initiale

### 1. Créer un projet Supabase (si ce n'est pas déjà fait)

1. Allez sur https://supabase.com/dashboard
2. Cliquez sur "New Project"
3. Remplissez les informations :
   - **Name:** BoxToBikers
   - **Database Password:** (générez-en un fort et conservez-le)
   - **Region:** Choisissez la plus proche de vos utilisateurs
4. Cliquez sur "Create Project" et attendez quelques minutes

### 2. Récupérer les clés d'API

1. Dans le dashboard Supabase, allez dans **Settings → API**
2. Copiez :
   - **Project URL** (ex: https://xxxxx.supabase.co)
   - **anon public** key (commence par eyJhbGc...)
   - **Project Reference ID** (dans l'URL ou Settings → General)

### 3. Configurer les variables d'environnement

Éditez `config/dev.json` :

```json
{
  "SUPABASE_URL": "https://votre-projet.supabase.co",
  "SUPABASE_ANON_KEY": "votre_cle_anon",
  "ENV": "development"
}
```

**[Guide complet des variables d'env →](../../environment/configuration.md)**

### 4. Installation des outils de développement

### 1. Installer Supabase CLI

Sur macOS :
```bash
brew install supabase/tap/supabase
```

Sur Windows (PowerShell) :
```powershell
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase
```

Sur Linux :
```bash
brew install supabase/tap/supabase
```

### 2. Installer Docker Desktop

Supabase CLI nécessite Docker pour fonctionner localement.
- Téléchargez et installez [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Démarrez Docker Desktop

### 3. Démarrer Supabase en local

```bash
make db-start
```

Cette commande va :
- Télécharger les images Docker nécessaires (première fois seulement)
- Démarrer PostgreSQL, PostgREST, GoTrue, etc.
- Appliquer la migration initiale (`20241025000000_init_schema.sql`)
- Exécuter le fichier seed.sql

Vous obtiendrez des URLs comme :
```
API URL: http://localhost:54321
DB URL: postgresql://postgres:postgres@localhost:54322/postgres
Studio URL: http://localhost:54323
```

### 4. Accéder à Supabase Studio

Ouvrez http://localhost:54323 dans votre navigateur.

Vous pourrez :
- Voir toutes vos tables
- Exécuter des requêtes SQL
- Gérer les utilisateurs
- Configurer l'authentification
- Tester les Row Level Security (RLS)

## 📁 Structure des fichiers

```
supabase/
├── migrations/                          # Migrations versionnées
│   └── 20241025000000_init_schema.sql  # Migration initiale
├── seed.sql                            # Données de test
├── config.toml                         # Configuration Supabase
├── README.md                           # Documentation
└── .gitignore                          # Fichiers à ignorer

.github/
└── workflows/
    └── deploy_supabase.yml             # Workflow de déploiement auto

docs/backend/supabase/
├── GITHUB_ACTIONS_SETUP.md             # Config GitHub Actions
└── examples/
    └── boxtobikers_schema.sql          # Schéma original (référence)
```

## 🔄 Workflow de développement

### Scénario 1 : Créer une nouvelle table

```bash
# 1. Créer une nouvelle migration
make db-migration name=add_bookings_table

# 2. Éditer le fichier créé dans supabase/migrations/
# Exemple : 20241025123456_add_bookings_table.sql
```

```sql
create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id),
  destination_id uuid not null references public.destinations(id),
  start_time timestamptz not null,
  end_time timestamptz not null,
  status text default 'PENDING',
  created_at timestamptz default now()
);

alter table public.bookings enable row level security;

create policy "Users can view their own bookings"
  on public.bookings for select
  using (auth.uid() = user_id);
```

```bash
# 3. Tester localement
make db-reset

# 4. Vérifier dans Studio (http://localhost:54323)

# 5. Commiter et pusher
git add supabase/migrations/
git commit -m "feat: add bookings table"
git push
```

### Scénario 2 : Modifier une table existante

```bash
# 1. Faire les modifications dans Supabase Studio
# Par exemple : ajouter une colonne à la table destinations

# 2. Générer automatiquement la migration
make db-diff-migration name=add_phone_to_destinations

# 3. Vérifier le fichier généré
cat supabase/migrations/XXXXXX_add_phone_to_destinations.sql

# 4. Tester
make db-reset

# 5. Commiter si OK
git add supabase/migrations/
git commit -m "feat: add phone column to destinations"
git push
```

### Scénario 3 : Modifier des données (seed)

```bash
# 1. Éditer supabase/seed.sql
# Ajoutez vos données de test

# 2. Réinitialiser pour tester
make db-reset

# 3. Vérifier dans Studio

# 4. Commiter
git add supabase/seed.sql
git commit -m "chore: update seed data"
git push
```

## 🌐 Déploiement en production

### Configuration initiale (une seule fois)

1. Suivez le guide [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md)
2. Configurez les secrets GitHub :
   - `SUPABASE_PROJECT_ID`
   - `SUPABASE_ACCESS_TOKEN`
   - `SUPABASE_DB_PASSWORD`

### Déploiement

Une fois configuré, c'est automatique ! 🎉

Chaque fois que vous pushez une modification dans `supabase/migrations/` sur `main` :
1. GitHub Actions se déclenche
2. Se connecte à votre projet Supabase
3. Applique les nouvelles migrations
4. Vous notifie du résultat

Vous pouvez aussi déclencher manuellement :
```bash
# D'abord se connecter (une seule fois)
make db-login

# Ensuite lier le projet
make db-link ref=VOTRE_PROJECT_REF

# Puis pousser les migrations
make db-push
```

## 📊 Commandes disponibles {#commandes-disponibles}

### Base de données

| Commande | Description |
|----------|-------------|
| `make db-start` | Démarrer Supabase en local |
| `make db-stop` | Arrêter Supabase |
| `make db-reset` | Réinitialiser la DB (réapplique migrations + seed) |
| `make db-status` | Voir le status de Supabase |
| `make db-migration name=XXX` | Créer une migration vide |
| `make db-diff-migration name=XXX` | Générer migration depuis les changements |
| `make db-push` | Pousser les migrations vers le serveur |
| `make db-diff` | Voir les différences local vs distant |
| `make db-login` | Se connecter à Supabase (requis avant db-link) |
| `make db-link ref=XXX` | Lier au projet Supabase distant |
| `make db-types` | Générer les types Dart depuis le schéma |
| `make db-dump` | Créer un backup du schéma |

### Application Flutter

| Commande | Description |
|----------|-------------|
| `make dev` | Lancer l'app en mode dev |
| `make staging` | Lancer l'app en mode staging |
| `make prod` | Lancer l'app en mode production |

Voir `make help` pour toutes les commandes.

## 🧪 Tests et validation

### Tester une migration localement

```bash
# Réinitialiser complètement
make db-reset

# Vérifier dans Studio
open http://localhost:54323

# Tester les requêtes
# Allez dans SQL Editor et testez vos queries
```

### Vérifier avant de pusher en production

```bash
# Voir les différences avec la prod
make db-diff

# Si vous êtes sûr
git push
```

## 🔒 Sécurité et bonnes pratiques {#securite-et-bonnes-pratiques}

### Row Level Security (RLS)

**Activez toujours RLS** sur vos tables pour protéger les données :

```sql
ALTER TABLE nom_table ENABLE ROW LEVEL SECURITY;
```

### Exemples de politiques RLS courantes

```sql
-- Lecture publique pour tous
CREATE POLICY "Public read access"
ON table_name FOR SELECT
TO public
USING (true);

-- Écriture pour utilisateurs authentifiés uniquement
CREATE POLICY "Authenticated users can insert"
ON table_name FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Modification par le propriétaire uniquement
CREATE POLICY "Users can update own data"
ON table_name FOR UPDATE
USING (auth.uid() = user_id);

-- Lecture de ses propres données
CREATE POLICY "Users can view own profile"
ON users FOR SELECT
USING (auth.uid() = id);
```

### Configuration de l'authentification

Dans votre dashboard Supabase, allez dans **Authentication → Settings** pour configurer :
- **Email confirmation** : Validation des emails (recommandé pour la production)
- **Password requirements** : Complexité minimale des mots de passe
- **OAuth providers** : Google, GitHub, etc. (optionnel)
- **Email templates** : Personnalisation des emails envoyés

## ✅ À faire

- Toujours tester localement avec `make db-reset` avant de pusher
- Utiliser `IF NOT EXISTS` pour les créations de tables/policies
- Utiliser `DROP POLICY IF EXISTS` avant `CREATE POLICY`
- Ajouter des commentaires dans vos migrations SQL
- Versionner petit à petit (une fonctionnalité = une migration)
- Utiliser des noms de migration descriptifs
- Activer RLS sur toutes les tables contenant des données utilisateurs
- Faire des backups réguliers avec `make db-dump`

## ❌ À éviter

- Ne jamais modifier une migration déjà déployée en production
- Ne jamais supprimer une migration déjà appliquée
- Ne jamais commiter de secrets (mots de passe, clés) dans Git
- Ne pas faire de migrations destructives (DROP TABLE) sans backup
- Ne pas désactiver RLS sans raison valable
- Ne pas utiliser la clé `service_role` côté client

## 🛠️ Dépannage

### Problèmes courants

Pour une liste complète des problèmes et solutions, consultez **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)**.

**Problèmes fréquents :**

### Docker n'est pas démarré
```
Error: Cannot connect to the Docker daemon
```
→ Démarrez Docker Desktop et attendez qu'il soit prêt

### Port déjà utilisé
```
Error: port 54321 already in use
```
→ Arrêtez Supabase : `make db-stop` puis relancez `make db-start`

### Migration échoue
```
Error: migration failed
```
→ Vérifiez les logs : `make db-status`  
→ Vérifiez la syntaxe SQL dans votre fichier de migration  
→ Testez avec `make db-reset` pour réinitialiser

### Erreur "Access token not provided"
```
Error: Access token not provided
```
→ Connectez-vous d'abord : `make db-login`  
→ Puis liez le projet : `make db-link ref=VOTRE_PROJECT_REF`

**→ [Guide de dépannage complet](TROUBLESHOOTING.md)**

## 📚 Ressources complémentaires

- **[README.md](README.md)** - Index de la documentation Supabase
- **[GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md)** - Configuration du déploiement automatique
- **[MIGRATION_FROM_EXISTING.md](MIGRATION_FROM_EXISTING.md)** - Migrer depuis une base existante
- **[Documentation officielle Supabase](https://supabase.com/docs)** - Docs complètes
- **[Changelog supabase_flutter](https://pub.dev/packages/supabase_flutter/changelog)** - Versions du package

---

📖 **[Retour à la documentation principale →](../../README.md)**

### Connexion perdue avec le projet distant
```bash
make db-login
make db-link ref=VOTRE_PROJECT_REF
```

## 📚 Ressources

- [Documentation Supabase](https://supabase.com/docs)
- [Supabase CLI](https://supabase.com/docs/guides/cli)
- [Migrations](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Flutter avec Supabase](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)

## 🆘 Support

- Documentation du projet : `docs/backend/supabase/`
- Issues GitHub : [Créer une issue](https://github.com/VOTRE_REPO/issues)
- Discord Supabase : https://discord.supabase.com/

---

**Note** : Ce système est maintenant en place et prêt à être utilisé ! 
Commencez par `make db-start` pour démarrer votre environnement de développement local.

