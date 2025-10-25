# 🎉 Configuration Supabase terminée !

Votre projet BoxToBikers est maintenant configuré pour versionner et déployer automatiquement votre base de données Supabase.

## ✅ Ce qui a été mis en place

### 1. Structure des fichiers créés

```
supabase/
├── migrations/
│   └── 20241025000000_init_schema.sql    ✅ Schéma initial avec tables, RLS, triggers
├── seed.sql                               ✅ Données de test
├── config.toml                            ✅ Configuration Supabase CLI
└── README.md                              ✅ Documentation Supabase

.github/workflows/
└── deploy_supabase.yml                    ✅ Déploiement automatique

docs/backend/supabase/
├── SETUP_GUIDE.md                         ✅ Guide complet d'utilisation
└── GITHUB_ACTIONS_SETUP.md                ✅ Configuration GitHub Actions

Makefile                                   ✅ Nouvelles commandes db-*
check_supabase_setup.sh                    ✅ Script de vérification
```

### 2. Nouvelles commandes disponibles

| Commande | Description |
|----------|-------------|
| `make check-supabase` | ⭐ Vérifier que tout est installé |
| `make db-start` | Démarrer Supabase en local |
| `make db-stop` | Arrêter Supabase |
| `make db-reset` | Réinitialiser la DB locale |
| `make db-status` | Voir le status |
| `make db-migration name=XXX` | Créer une migration |
| `make db-diff-migration name=XXX` | Générer migration depuis diff |
| `make db-push` | Déployer vers production |
| `make db-link ref=XXX` | Lier au projet distant |
| `make db-types` | Générer types Dart |
| `make db-dump` | Créer un backup |

## 🚀 Prochaines étapes

### Étape 1 : Vérifier l'installation (2 min)

```bash
make check-supabase
```

Ce script va vérifier :
- ✅ Supabase CLI est installé
- ✅ Docker est installé et démarré
- ✅ Les fichiers sont présents
- ✅ La structure est correcte

**Si des erreurs apparaissent**, suivez les instructions affichées.

### Étape 2 : Démarrer Supabase en local (5 min première fois)

```bash
# Assurez-vous que Docker Desktop est démarré !
make db-start
```

La première fois, cela va :
1. Télécharger les images Docker (~500 MB)
2. Démarrer les services (Postgres, PostgREST, etc.)
3. Appliquer votre migration initiale
4. Exécuter le seed.sql

Vous obtiendrez :
```
API URL: http://localhost:54321
Studio URL: http://localhost:54323
DB URL: postgresql://postgres:postgres@localhost:54322/postgres
```

### Étape 3 : Explorer Supabase Studio (5 min)

Ouvrez http://localhost:54323

Vous verrez :
- ✅ Vos tables : `roles`, `profiles`, `destinations`, `rides`, `ratings`, `opening_hours`
- ✅ Les données de seed (3 destinations exemple)
- ✅ Les RLS policies configurées
- ✅ L'éditeur SQL

**Testez une requête :**
```sql
SELECT * FROM public.destinations;
```

### Étape 4 : Configurer le déploiement automatique (10 min)

Pour activer le déploiement automatique sur chaque push :

1. Suivez le guide : `docs/backend/supabase/GITHUB_ACTIONS_SETUP.md`
2. Configurez les 3 secrets GitHub
3. Pushez une modification pour tester

**C'est optionnel** - Vous pouvez déployer manuellement avec `make db-push`.

## 📚 Documentation

| Document | Contenu |
|----------|---------|
| **[SETUP_GUIDE.md](docs/backend/supabase/SETUP_GUIDE.md)** | Guide complet d'utilisation (démarrage, workflow, commandes) |
| **[GITHUB_ACTIONS_SETUP.md](docs/backend/supabase/GITHUB_ACTIONS_SETUP.md)** | Configuration du déploiement automatique |
| **[supabase/README.md](supabase/README.md)** | Documentation des migrations |

## 🎯 Workflow recommandé

### Ajouter une nouvelle fonctionnalité (ex: table bookings)

```bash
# 1. Créer une migration
make db-migration name=add_bookings_table

# 2. Éditer le fichier dans supabase/migrations/XXXXXX_add_bookings_table.sql
# Ajouter votre SQL (CREATE TABLE, RLS, etc.)

# 3. Tester localement
make db-reset

# 4. Vérifier dans Studio
open http://localhost:54323

# 5. Si OK, commiter
git add supabase/migrations/
git commit -m "feat: add bookings table"
git push

# 6. Le déploiement est automatique (si configuré) !
```

### Modifier le schéma existant

```bash
# 1. Faire les changements dans Studio (http://localhost:54323)
# Exemple : ajouter une colonne "phone" à destinations

# 2. Générer automatiquement la migration
make db-diff-migration name=add_phone_to_destinations

# 3. Vérifier la migration générée
cat supabase/migrations/XXXXXX_add_phone_to_destinations.sql

# 4. Tester
make db-reset

# 5. Commiter et pusher
git add supabase/migrations/
git commit -m "feat: add phone to destinations"
git push
```

## 🔍 Vérification rapide

Testez que tout fonctionne :

```bash
# 1. Vérifier l'installation
make check-supabase

# 2. Démarrer Supabase
make db-start

# 3. Ouvrir Studio
open http://localhost:54323

# 4. Vérifier les tables
# Vous devriez voir 6 tables + auth.users

# 5. Arrêter quand vous avez fini
make db-stop
```

## ❓ FAQ Rapide

**Q : Docker n'est pas installé ?**
→ Téléchargez [Docker Desktop](https://www.docker.com/products/docker-desktop/)

**Q : Supabase CLI n'est pas installé ?**
```bash
brew install supabase/tap/supabase
```

**Q : Port déjà utilisé ?**
```bash
make db-stop
make db-start
```

**Q : Je veux réinitialiser complètement ?**
```bash
make db-stop
make db-start
make db-reset
```

**Q : Comment voir les logs ?**
```bash
make db-status
```

**Q : Je veux un backup du schéma actuel ?**
```bash
make db-dump
```

## 🎊 Vous êtes prêt !

Votre système de versioning de base de données est opérationnel.

**Pour commencer :**
```bash
make check-supabase
```

**Besoin d'aide ?**
- Consultez [SETUP_GUIDE.md](docs/backend/supabase/SETUP_GUIDE.md)
- Vérifiez [supabase/README.md](supabase/README.md)
- Lancez `make help`

---

**Note** : Toutes vos migrations sont maintenant versionnées dans Git et peuvent être déployées automatiquement. Vous avez un historique complet de l'évolution de votre schéma ! 🎉

