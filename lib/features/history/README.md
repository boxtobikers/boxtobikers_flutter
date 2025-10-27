# Module History - Destinations

## Description
Le module History affiche une liste des destinations disponibles pour le service BoxToBikers. Les données sont récupérées depuis Supabase.

## Structure

### Modèles (`data/models/`)
- **destination_model.dart** : Modèle représentant une destination avec tous ses attributs (nom, type, adresse, coordonnées GPS, statut, nombre de casiers, etc.)

### Services (`data/services/`)
- **destination_service.dart** : Service pour interagir avec la table `destinations` de Supabase
  - `getDestinations(limit, offset)` : Récupère une liste de destinations (pagination)
  - `getDestinationById(id)` : Récupère une destination par son ID
  - `getDestinationsByStatus(status, limit)` : Filtre les destinations par statut
  - `getDestinationsCount()` : Compte le nombre total de destinations

### UI (`ui/pages/`)
- **history.pages.dart** : Page affichant la liste des destinations sous forme de cards avec :
  - Icône selon le type (Business/Particulier)
  - Couleur selon le statut (Ouvert/Fermé/En pause)
  - Nom, adresse, statut, nombre de casiers
  - Gestion des états de chargement et d'erreur

## Structure de la table Supabase

```sql
create table public.destinations (
  id uuid primary key,
  name text not null,
  type text not null check (type in ('BUSINESS', 'PRIVATE')),
  description text,
  address text,
  latitude double precision not null,
  longitude double precision not null,
  status text not null check (status in ('OPEN', 'CLOSED', 'PAUSED')),
  locker_count integer default 0,
  image_url text,
  created_at timestamptz default now()
);
```

## Migration des données

Un fichier de migration `20241025100000_seed_destinations.sql` contient 10 destinations de test réparties en France (Paris, Bordeaux, Nice, Lyon, Marseille, Toulouse, Strasbourg, Nantes).

## Bonnes pratiques

✅ Utilisation du singleton `SupabaseService` pour accéder à Supabase
✅ Gestion des erreurs avec try/catch et messages de debug
✅ Séparation modèle/service/UI
✅ Support de la pagination (limite de 10 par défaut)
✅ États de chargement et d'erreur gérés dans l'UI

## TODO

- [ ] Ajouter un système de pagination complet avec "Charger plus"
- [ ] Implémenter la page de détails d'une destination
- [ ] Ajouter des filtres (par type, par statut, par localisation)
- [ ] Intégrer une carte pour visualiser les destinations
- [ ] Ajouter le support des images de destinations

