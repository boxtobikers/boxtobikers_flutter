# Changelog - Schéma de base de données Supabase

Toutes les modifications notables du schéma de base de données seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère à [Semantic Versioning](https://semver.org/lang/fr/).

## [Non publié]

### À venir
- Table `bookings` pour gérer les réservations
- Table `notifications` pour les notifications push
- Table `payments` pour l'historique des paiements

## [1.0.0] - 2024-10-25

### Ajouté - Migration initiale

**Migration** : `20241025000000_init_schema.sql`

#### Tables créées
- `roles` - Rôles utilisateurs (ADMIN, VISITOR, CLIENT)
- `profiles` - Profils utilisateurs étendus depuis auth.users
- `destinations` - Points de dépôt/récupération de motos
- `opening_hours` - Horaires d'ouverture des destinations
- `rides` - Trajets/réservations des utilisateurs
- `ratings` - Évaluations des destinations par les utilisateurs

#### Fonctionnalités
- Row Level Security (RLS) activé sur toutes les tables
- Policies pour sécuriser l'accès aux données
- Trigger automatique pour créer un profil lors de l'inscription
- Vue `destinations_ratings_avg` pour les moyennes des évaluations
- Index pour optimiser les performances
- Données initiales : 3 rôles (ADMIN, VISITOR, CLIENT)

#### Seed data
- 3 destinations exemple (Paris, Bordeaux, Nice)
- Horaires d'ouverture pour chaque destination

### Sécurité
- RLS activé sur toutes les tables
- Les utilisateurs ne peuvent voir que leurs propres données
- Les admins ont accès complet
- Les destinations et horaires sont publics en lecture

---

## Format des entrées

Chaque changement devrait être documenté avec :

### [Version] - YYYY-MM-DD

**Migration** : `YYYYMMDDHHMMSS_nom_de_la_migration.sql`

#### Ajouté
- Nouvelles tables, colonnes, index, etc.

#### Modifié
- Changements sur des structures existantes

#### Déprécié
- Fonctionnalités qui seront supprimées

#### Supprimé
- Fonctionnalités supprimées

#### Corrigé
- Corrections de bugs

#### Sécurité
- Changements liés à la sécurité

---

## Exemple d'entrée future

```markdown
## [1.1.0] - 2024-11-01

### Ajouté

**Migration** : `20241101120000_add_bookings_table.sql`

- Table `bookings` pour gérer les réservations de casiers
  - `id` : UUID primary key
  - `user_id` : Référence vers profiles
  - `destination_id` : Référence vers destinations
  - `locker_number` : Numéro du casier
  - `start_time` : Date/heure de début
  - `end_time` : Date/heure de fin
  - `status` : PENDING, CONFIRMED, CANCELLED, COMPLETED
  - `total_price` : Prix total
- Index sur user_id, destination_id, status
- RLS policies pour bookings
- Vue `active_bookings` pour les réservations en cours

### Modifié

**Migration** : `20241101130000_add_phone_to_destinations.sql`

- Ajout colonne `phone` à la table destinations
- Ajout colonne `email` à la table destinations

### Corrigé

**Migration** : `20241101140000_fix_ratings_constraint.sql`

- Correction de la contrainte unique sur ratings (user_id, destination_id)
```

---

## Notes

- Les versions suivent le [Semantic Versioning](https://semver.org/lang/fr/)
  - MAJOR : Changements incompatibles avec l'API
  - MINOR : Ajout de fonctionnalités rétrocompatibles
  - PATCH : Corrections de bugs rétrocompatibles

- Chaque entrée doit référencer la migration SQL correspondante

- Gardez ce fichier à jour à chaque nouvelle migration

- Ce fichier est complémentaire aux migrations SQL (elles contiennent le "comment", ce fichier le "pourquoi")

