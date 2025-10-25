# boxtobikers — Database Schema (Full)
Project: **boxtobikers**
Stack: Supabase (PostgreSQL) + Google Maps integration
Tables use **plural** names. This document includes the full SQL DDL for tables,
row-level security (RLS) policies, triggers and helpful queries.

---

## Overview

Entities:
- `roles` — ADMIN / VISITOR / CLIENT
- `profiles` — user profile linked to `auth.users`
- `destinations` — commerce or private, with Google Maps support (place_id)
- `horaires_ouvertures` — opening hours (primarily for commerces)
- `ratings` — user ratings (1..5 stars)
- `destinations_ratings_avg` — materialized view for averages
- `ridings` — reservations (rides)
- plus triggers/functions for defaults and refreshing materialized view

---

## 1. Roles

```sql
create table public.roles (
  id uuid primary key default gen_random_uuid(),
  name text unique not null check (name in ('ADMIN', 'VISITOR', 'CLIENT'))
);

insert into public.roles (name) values ('ADMIN'), ('VISITOR'), ('CLIENT');
```

---

## 2. Profiles (linked to auth.users)

```sql
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role_id uuid references public.roles(id),
  nom text not null,
  prenom text not null,
  email text unique,
  mobile text,
  adresse_postale text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
```

Default profile creation on auth.user insert:

```sql
create function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, role_id, nom, prenom, email)
  values (
    new.id,
    (select id from public.roles where name = 'VISITOR'),
    '', '', new.email
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();
```

Notes:
- `auth.users` is Supabase's internal auth table. We keep user profile data in `public.profiles` to avoid duplicating auth concerns.

---

## 3. Destinations

```sql
create table public.destinations (
  id uuid primary key default gen_random_uuid(),
  nom text not null,
  type text not null check (type in ('COMMERCE', 'PARTICULIER')),
  description text,
  adresse text,
  latitude double precision not null,
  longitude double precision not null,
  place_id text unique,
  google_rating double precision,
  statut text not null check (statut in ('OUVERT', 'FERME', 'EN_PAUSE')) default 'OUVERT',
  nombre_casiers integer default 0 check (nombre_casiers >= 0),
  image_url text,
  created_at timestamptz default now()
);
```

- `place_id` holds Google Places ID for synchronization & enriched info.
- `google_rating` can store the rating fetched from Google (optional).
- Consider adding a `position geography(Point,4326)` column and PostGIS for proximity searches if needed.

Optional: add geography position and trigger to update it:

```sql
alter table public.destinations add column position geography(Point, 4326);

create function public.update_position()
returns trigger as $$
begin
  new.position = ST_SetSRID(ST_MakePoint(new.longitude, new.latitude), 4326);
  return new;
end;
$$ language plpgsql;

create trigger set_position_before_insert
before insert or update on public.destinations
for each row execute function public.update_position();
```

---

## 4. Horaires (opening hours)

```sql
create table public.horaires_ouvertures (
  id uuid primary key default gen_random_uuid(),
  destination_id uuid not null references public.destinations(id) on delete cascade,
  jour_semaine text not null check (jour_semaine in (
    'LUNDI','MARDI','MERCREDI','JEUDI','VENDREDI','SAMEDI','DIMANCHE'
  )),
  heure_ouverture time not null,
  heure_fermeture time not null,
  is_ferme boolean default false,
  created_at timestamptz default now()
);
```

---

## 5. Ratings (user ratings for destinations)

```sql
create table public.ratings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  destination_id uuid not null references public.destinations(id) on delete cascade,
  note integer not null check (note between 1 and 5),
  commentaire text,
  created_at timestamptz default now(),
  unique (user_id, destination_id)
);
```

- `unique (user_id, destination_id)` prevents multiple ratings by the same user for the same destination.
- Use `upsert` in app to allow users to update their rating (insert ... on conflict (user_id,destination_id) do update ...).

---

## 6. Materialized view: destinations_ratings_avg

```sql
create materialized view public.destinations_ratings_avg as
select
  d.id as destination_id,
  avg(r.note)::numeric(2,1) as note_moyenne,
  count(r.id) as nb_notes
from public.destinations d
left join public.ratings r on d.id = r.destination_id
group by d.id;
```

Trigger/function to refresh the materialized view (concurrently if supported):

```sql
create or replace function public.refresh_destinations_ratings_avg()
returns trigger as $$
begin
  -- Refresh the mat view to keep averages up-to-date. Consider scheduling for heavy load.
  refresh materialized view concurrently public.destinations_ratings_avg;
  return null;
end;
$$ language plpgsql;

create trigger refresh_ratings_avg_trigger
after insert or update or delete on public.ratings
for each statement execute function public.refresh_destinations_ratings_avg();
```

Notes:
- `refresh materialized view concurrently` requires a unique index on the mat view and appropriate permissions.
- For high write volume, consider computing aggregates incrementally or using a counter table.

---

## 7. Ridings (reservations)

```sql
create table public.ridings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  destination_id uuid references public.destinations(id) on delete restrict,
  point_depart text not null,
  statut text not null check (statut in ('PENDING', 'CONFIRMED', 'CANCELLED')) default 'PENDING',
  date_reservation timestamptz default now(),
  date_riding timestamptz,
  created_at timestamptz default now()
);
```

---

## 8. Row Level Security (RLS) Policies

-- PROFILES
```sql
alter table public.profiles enable row level security;

create policy "Users can view their own profile"
on public.profiles for select
using (auth.uid() = id);

create policy "Admins can manage all profiles"
on public.profiles for all
using (exists (
  select 1 from public.profiles p
  join public.roles r on r.id = p.role_id
  where p.id = auth.uid() and r.name = 'ADMIN'
));
```

-- DESTINATIONS
```sql
alter table public.destinations enable row level security;

create policy "Everyone can read destinations"
on public.destinations for select
using (true);

create policy "Admins can manage destinations"
on public.destinations for all
using (exists (
  select 1 from public.profiles p
  join public.roles r on r.id = p.role_id
  where p.id = auth.uid() and r.name = 'ADMIN'
));
```

-- HORAIRES
```sql
alter table public.horaires_ouvertures enable row level security;

create policy "Everyone can read opening hours"
on public.horaires_ouvertures for select
using (true);

create policy "Admins can manage opening hours"
on public.horaires_ouvertures for all
using (exists (
  select 1 from public.profiles p
  join public.roles r on r.id = p.role_id
  where p.id = auth.uid() and r.name = 'ADMIN'
));
```

-- RATINGS
```sql
alter table public.ratings enable row level security;

create policy "Everyone can read ratings"
on public.ratings for select using (true);

create policy "Users can insert their own rating"
on public.ratings for insert
with check (
  user_id = auth.uid() and
  exists (
    select 1 from public.profiles p
    join public.roles r on r.id = p.role_id
    where p.id = auth.uid() and r.name in ('CLIENT', 'VISITOR')
  )
);

-- Optional: allow users to update/delete their own rating
create policy "Users can modify their rating"
on public.ratings for update, delete
using (user_id = auth.uid());
```

-- RIDINGS
```sql
alter table public.ridings enable row level security;

create policy "Users can view their own ridings"
on public.ridings for select
using (auth.uid() = user_id);

create policy "Users can insert their own riding"
on public.ridings for insert
with check (
  user_id = auth.uid() and
  exists (
    select 1 from public.profiles p
    join public.roles r on r.id = p.role_id
    where p.id = auth.uid() and r.name in ('VISITOR', 'CLIENT')
  )
);

create policy "Admins can manage all ridings"
on public.ridings for all
using (exists (
  select 1 from public.profiles p
  join public.roles r on r.id = p.role_id
  where p.id = auth.uid() and r.name = 'ADMIN'
));
```

---

## 9. Useful Queries

-- Get open destinations with available lockers:
```sql
select * from public.destinations
where statut = 'OUVERT' and nombre_casiers > 0;
```

-- Top 5 destinations by average rating:
```sql
select d.*, a.note_moyenne, a.nb_notes
from public.destinations d
join public.destinations_ratings_avg a on a.destination_id = d.id
order by a.note_moyenne desc
limit 5;
```

-- Get opening hours for a destination:
```sql
select * from public.horaires_ouvertures
where destination_id = '<id>';
```

-- Insert or update a rating (upsert):
```sql
insert into public.ratings (user_id, destination_id, note, commentaire)
values ('<user_id>', '<destination_id>', 5, 'Great service!')
on conflict (user_id, destination_id) do update set
  note = excluded.note,
  commentaire = excluded.commentaire,
  created_at = now();
```

---

## 10. Google Maps Integration Notes

- Keep `place_id` populated when syncing with the Google Places API.
- Use `geometry.location.lat/lng` to fill `latitude` and `longitude`.
- `opening_hours.periods` maps to `horaires_ouvertures`. If Google supplies complex periods, normalize them to the schema or store raw JSON in an additional column like `google_opening_hours jsonb`.
- Consider fetching `photos[]` and storing the best photo URL in `image_url`, or storing photo references in a separate `destination_photos` table.
- Rate-limits and API quotas: cache results and avoid excessive calls from clients; prefer server-side sync or edge functions.

---

## Files created
- `boxtobikers_database_schema.md` (this file)
- `boxtobikers_schema.dbml`
- `boxtobikers_erd.png`

