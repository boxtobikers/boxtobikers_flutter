# Documentation Supabase - BoxToBikers

Cette section contient toute la documentation relative à la base de données Supabase.

## 📚 Guides disponibles

| Guide                                                              | Description                                           | Temps  |
|--------------------------------------------------------------------|-------------------------------------------------------|--------|
| **[NAVIGATION.md](NAVIGATION.md)**                                 | 🗺️ **Nouveau !** Guide de navigation rapide          | 2 min  |
| **[STARTER.md](STARTER.md)**                                       | ⚡ Démarrage rapide en 5 minutes                       | 5 min  |
| **[SETUP_GUIDE.md](SETUP_GUIDE.md)**                               | 📖 Guide complet : installation, migrations, workflow | 15 min |
| **[GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md)**             | 🚀 Configuration du déploiement automatique CI/CD     | 10 min |
| **[MIGRATION_FROM_EXISTING.md](MIGRATION_FROM_EXISTING.md)**       | 🔄 Migrer depuis un schéma existant                   | 10 min |
| **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)**                       | ⭐ Guide de dépannage rapide                           | 5 min  |

> **💡 Nouveau sur Supabase ?** Commencez par [NAVIGATION.md](NAVIGATION.md) pour trouver rapidement
> ce dont vous avez besoin !

## 🚀 Démarrage rapide

### Installation (une seule fois)

```bash
# 1. Installer Supabase CLI
bash install_supabase.sh

# 2. Vérifier l'installation
make check-supabase

# 3. Démarrer Supabase
make db-start
```

### Utilisation quotidienne

```bash
# Démarrer
make db-start

# Faire vos modifications dans Studio
open http://localhost:54323

# Générer la migration
make db-diff-migration name=description

# Arrêter
make db-stop
```

## 📖 Structure de la documentation

```
docs/backend/supabase/
├── README.md                      ← Vous êtes ici
├── SETUP_GUIDE.md                 ← Guide principal d'utilisation
├── GITHUB_ACTIONS_SETUP.md        ← Configuration CI/CD
├── MIGRATION_FROM_EXISTING.md     ← Migration depuis existant
├── TROUBLESHOOTING.md             ← Guide de dépannage
└── examples/
    └── boxtobikers_schema.sql     ← Schéma original (référence)
```

## 🗄️ Structure de la base de données

### Tables principales

| Table           | Description                                 | Relations                       |
|-----------------|---------------------------------------------|---------------------------------|
| `roles`         | Rôles utilisateurs (ADMIN, VISITOR, CLIENT) | → profiles                      |
| `profiles`      | Profils utilisateurs étendus                | auth.users ←                    |
| `destinations`  | Points de dépôt/récupération                | → opening_hours, rides, ratings |
| `opening_hours` | Horaires d'ouverture                        | destinations ←                  |
| `rides`         | Trajets/réservations                        | profiles ←, destinations ←      |
| `ratings`       | Évaluations des destinations                | profiles ←, destinations ←      |

### Schéma relationnel

```
auth.users (Supabase Auth)
    ↓
profiles (user_id)
    ├─→ rides (user_id)
    └─→ ratings (user_id)

roles
    ↓
profiles (role_id)

destinations
    ├─→ opening_hours (destination_id)
    ├─→ rides (destination_id)
    └─→ ratings (destination_id)
```

### Sécurité (RLS)

Toutes les tables ont Row Level Security activé avec des policies :

- Les utilisateurs voient uniquement leurs données
- Les admins ont accès complet
- Les données publiques (destinations, horaires) sont lisibles par tous

## 🔧 Commandes utiles {#commandes-utiles}

### Base de données

```bash
make db-start                    # Démarrer Supabase local
make db-stop                     # Arrêter Supabase
make db-reset                    # Réinitialiser (réapplique migrations + seed)
make db-status                   # Voir le status
```

### Migrations

```bash
make db-migration name=XXX       # Créer migration vide
make db-diff-migration name=XXX  # Générer depuis différences
make db-push                     # Déployer vers production
make db-diff                     # Voir différences local vs distant
```

### Utilitaires

```bash
make db-login                # Se connecter à Supabase
make db-link ref=XXX         # Lier au projet distant
make db-types                # Générer types Dart
make db-dump                 # Créer backup
make check-supabase          # Vérifier installation
```

## 🔄 Workflow de développement

### Ajouter une nouvelle table

```bash
# 1. Créer migration
make db-migration name=add_bookings

# 2. Éditer supabase/migrations/XXXXXX_add_bookings.sql
# Voir : supabase/migrations/EXAMPLE_migration_template.sql

# 3. Tester
make db-reset

# 4. Vérifier
open http://localhost:54323

# 5. Commiter
git add supabase/migrations/
git commit -m "feat: add bookings table"
git push
```

### Modifier une table existante

```bash
# 1. Faire les modifs dans Studio local
open http://localhost:54323

# 2. Générer automatiquement la migration
make db-diff-migration name=add_phone_column

# 3. Vérifier la migration
cat supabase/migrations/XXXXXX_add_phone_column.sql

# 4. Tester
make db-reset

# 5. Commiter
git add supabase/migrations/
git commit -m "feat: add phone to destinations"
git push
```

## 📦 Fichiers et dossiers

```
supabase/
├── migrations/                          # Migrations versionnées
│   ├── 20241025000000_init_schema.sql  # Migration initiale
│   └── EXAMPLE_migration_template.sql  # Template d'exemple
├── seed.sql                            # Données de test
├── config.toml                         # Configuration CLI
├── README.md                           # Doc migrations
└── .gitignore                          # Fichiers ignorés

.github/workflows/
└── deploy_supabase.yml                 # CI/CD automatique

scripts/
├── check_supabase_setup.sh             # Vérification
```

## 🎯 Cas d'usage courants

### Tester localement avant de déployer

```bash
make db-start
make db-reset
# Tester votre app
make db-stop
```

### Synchroniser depuis la production

```bash
# 1. Se connecter à Supabase (une seule fois)
make db-login

# 2. Lier le projet
make db-link ref=VOTRE_PROJECT_REF

# 3. Récupérer le schéma distant
cd supabase && supabase db pull
make db-reset
```

### Rollback d'une migration

Créez une nouvelle migration inverse :

```bash
make db-migration name=rollback_previous_feature
# Écrivez le SQL inverse dans le fichier créé
make db-reset
make db-push
```

### Backup avant grosse modification

```bash
make db-dump
# Crée : supabase/schema_backup_YYYYMMDD_HHMMSS.sql
```

## 🔒 Sécurité et bonnes pratiques

### ✅ À faire

- Toujours tester localement avec `make db-reset`
- Utiliser `IF NOT EXISTS` dans les CREATE
- Utiliser `DROP ... IF EXISTS` avant CREATE POLICY
- Activer RLS sur toutes les tables
- Ajouter des index pour les performances
- Commiter les migrations dans Git
- Versionner petit à petit

### ❌ À éviter

- Modifier une migration déjà déployée
- Supprimer une migration appliquée
- Faire des changements directement en prod
- Oublier d'activer RLS
- Hardcoder des IDs dans les migrations
- Commiter des secrets dans Git

## 📊 Monitoring et debugging

### Voir les logs Supabase

```bash
make db-status
docker logs supabase_db_flutter
```

### Tester les RLS policies

Connectez-vous dans Studio avec différents utilisateurs :

1. Créez des utilisateurs test dans Auth
2. Testez les requêtes avec chaque utilisateur
3. Vérifiez que les policies fonctionnent

### Analyser les performances

```sql
-- Dans Studio SQL Editor
EXPLAIN ANALYZE SELECT * FROM bookings WHERE user_id = 'xxx';
```

## 🆘 Dépannage

**⚠️ Problème d'authentification ?
** → [TROUBLESHOOTING.md](TROUBLESHOOTING.md#erreur--access-token-not-provided)

| Problème                  | Solution                                     |
|---------------------------|----------------------------------------------|
| Access token not provided | `make db-login` puis `make db-link ref=XXX`  |
| Port déjà utilisé         | `make db-stop` puis `make db-start`          |
| Migration échoue          | Vérifier les logs, corriger, `make db-reset` |
| Docker non démarré        | Lancer Docker Desktop                        |
| Connexion perdue          | `make db-login` puis `make db-link ref=XXX`  |
| Schema désynchronisé      | `supabase db pull`                           |

**[📖 Guide complet de dépannage →](TROUBLESHOOTING.md)**

## 📦 Versions et mises à jour {#versions-et-updates}

### Version actuelle : Supabase Flutter 2.10.3

**Date :** Octobre 2025  
**Status :** ✅ En production

**Changements :**

- 🐛 Corrections de bugs mineurs
- 🔒 Améliorations de sécurité
- ⚡ Optimisations de performance
- 📚 Mises à jour des dépendances

**Compatibilité :**

- ✅ 100% compatible avec le code existant
- ✅ Aucune breaking change
- ✅ Migration automatique

**Installation :**

```bash
flutter pub get
make dev
```

**Ressources :**

- [Changelog officiel](https://pub.dev/packages/supabase_flutter/changelog)
- [Documentation du package](https://pub.dev/packages/supabase_flutter)

## 📚 Ressources externes

- [Documentation Supabase](https://supabase.com/docs)
- [Supabase CLI](https://supabase.com/docs/guides/cli)
- [Migrations](https://supabase.com/docs/guides/cli/local-development)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)

## 🤝 Contribution

Pour contribuer au schéma de base de données :

1. Créez une branche
2. Créez votre migration
3. Testez localement
4. Créez une Pull Request
5. Les migrations seront déployées après merge

---

**Besoin d'aide ?** Consultez les guides ci-dessus ou lancez `make help`

