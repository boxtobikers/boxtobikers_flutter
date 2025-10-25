-- Exemple de migration : Ajouter une table bookings
-- Nom du fichier : YYYYMMDDHHMMSS_add_bookings_table.sql
--
-- Ce fichier montre les bonnes pratiques pour écrire une migration Supabase

-- =============================================
-- 1. CREATE TABLE avec IF NOT EXISTS
-- =============================================

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  destination_id uuid not null references public.destinations(id) on delete cascade,
  locker_number text,
  start_time timestamptz not null,
  end_time timestamptz not null,
  status text not null default 'PENDING' check (status in ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')),
  total_price decimal(10,2),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- =============================================
-- 2. CREATE INDEX pour les performances
-- =============================================

create index if not exists idx_bookings_user_id on public.bookings(user_id);
create index if not exists idx_bookings_destination_id on public.bookings(destination_id);
create index if not exists idx_bookings_status on public.bookings(status);
create index if not exists idx_bookings_dates on public.bookings(start_time, end_time);

-- =============================================
-- 3. ACTIVER RLS (Row Level Security)
-- =============================================

alter table public.bookings enable row level security;

-- =============================================
-- 4. CREATE POLICIES avec DROP IF EXISTS
-- =============================================

-- Policy : Les utilisateurs peuvent voir leurs propres réservations
drop policy if exists "Users can view their own bookings" on public.bookings;
create policy "Users can view their own bookings"
  on public.bookings for select
  using (auth.uid() = user_id);

-- Policy : Les utilisateurs peuvent créer leurs propres réservations
drop policy if exists "Users can create their own bookings" on public.bookings;
create policy "Users can create their own bookings"
  on public.bookings for insert
  with check (auth.uid() = user_id);

-- Policy : Les utilisateurs peuvent modifier leurs réservations non terminées
drop policy if exists "Users can update their own pending bookings" on public.bookings;
create policy "Users can update their own pending bookings"
  on public.bookings for update
  using (auth.uid() = user_id and status in ('PENDING', 'CONFIRMED'));

-- Policy : Les admins peuvent tout voir
drop policy if exists "Admins can view all bookings" on public.bookings;
create policy "Admins can view all bookings"
  on public.bookings for select
  using (
    exists (
      select 1 from public.profiles p
      join public.roles r on r.id = p.role_id
      where p.id = auth.uid() and r.name = 'ADMIN'
    )
  );

-- =============================================
-- 5. CREATE FUNCTION pour la logique métier
-- =============================================

-- Fonction pour mettre à jour updated_at automatiquement
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- =============================================
-- 6. CREATE TRIGGER
-- =============================================

drop trigger if exists set_updated_at on public.bookings;
create trigger set_updated_at
  before update on public.bookings
  for each row
  execute function public.handle_updated_at();

-- =============================================
-- 7. CREATE VIEW (optionnel)
-- =============================================

create or replace view public.bookings_with_details as
select
  b.id,
  b.user_id,
  p.first_name || ' ' || p.last_name as user_name,
  b.destination_id,
  d.name as destination_name,
  d.address as destination_address,
  b.locker_number,
  b.start_time,
  b.end_time,
  b.status,
  b.total_price,
  b.created_at,
  b.updated_at
from public.bookings b
join public.profiles p on p.id = b.user_id
join public.destinations d on d.id = b.destination_id;

-- =============================================
-- 8. GRANT PERMISSIONS (si nécessaire)
-- =============================================

-- Par défaut, RLS gère les permissions
-- Mais vous pouvez ajouter des GRANT si besoin

-- =============================================
-- 9. COMMENTAIRES (bonne pratique)
-- =============================================

comment on table public.bookings is 'Table des réservations de casiers';
comment on column public.bookings.locker_number is 'Numéro du casier attribué';
comment on column public.bookings.status is 'Statut : PENDING, CONFIRMED, CANCELLED, COMPLETED';

-- =============================================
-- NOTES IMPORTANTES :
-- =============================================
--
-- ✅ Toujours utiliser IF NOT EXISTS / IF EXISTS
-- ✅ Toujours utiliser DROP POLICY IF EXISTS avant CREATE POLICY
-- ✅ Penser aux index pour les performances
-- ✅ Activer RLS pour la sécurité
-- ✅ Tester localement avec `make db-reset`
-- ✅ Ne jamais modifier une migration déjà déployée
--
-- ❌ Ne pas utiliser DROP TABLE (destructif)
-- ❌ Ne pas utiliser TRUNCATE dans une migration
-- ❌ Ne pas hardcoder des IDs
--
-- Pour rollback, créer une nouvelle migration qui défait les changements

