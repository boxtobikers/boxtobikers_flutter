-- boxtobikers_schema.sql
-- Supabase-compatible SQL schema for the Boxtobikers project
-- Includes roles, profiles, destinations, rides, ratings, RLS policies, triggers, and views
-- Does NOT recreate auth.users (managed by Supabase Auth)

-- =============================================
-- =============== TABLES =======================
-- =============================================

create table if not exists public.roles (
  id uuid primary key default gen_random_uuid(),
  name text unique not null check (name in ('ADMIN', 'VISITOR', 'CLIENT')),
  created_at timestamptz default now()
);

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role_id uuid references public.roles(id),
  first_name text not null,
  last_name text not null,
  email text,
  mobile text,
  address text,
  created_at timestamptz default now()
);

create table if not exists public.destinations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type text not null check (type in ('BUSINESS', 'PRIVATE')),
  description text,
  address text,
  latitude double precision not null,
  longitude double precision not null,
  status text not null check (status in ('OPEN', 'CLOSED', 'PAUSED')) default 'OPEN',
  locker_count integer default 0 check (locker_count >= 0),
  image_url text,
  created_at timestamptz default now()
);

create table if not exists public.opening_hours (
  id uuid primary key default gen_random_uuid(),
  destination_id uuid not null references public.destinations(id) on delete cascade,
  weekday text not null check (weekday in ('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY')),
  open_time time not null,
  close_time time not null,
  is_closed boolean default false,
  created_at timestamptz default now()
);

create table if not exists public.rides (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  destination_id uuid not null references public.destinations(id) on delete cascade,
  pickup_address text not null,
  destination_address text,
  status text default 'PENDING' check (status in ('PENDING','CONFIRMED','CANCELLED','COMPLETED')),
  created_at timestamptz default now()
);

create table if not exists public.ratings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  destination_id uuid not null references public.destinations(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  comment text,
  created_at timestamptz default now(),
  unique (user_id, destination_id)
);

-- =============================================
-- =============== FUNCTIONS ===================
-- =============================================

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, role_id, first_name, last_name, email)
  values (
    new.id,
    (select id from public.roles where name = 'VISITOR' limit 1),
    '',
    '',
    new.email
  );
  return new;
end;
$$ language plpgsql security definer;

-- =============================================
-- =============== TRIGGERS ====================
-- =============================================

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- =============================================
-- =============== RLS POLICIES ================
-- =============================================

alter table public.roles enable row level security;
alter table public.profiles enable row level security;
alter table public.destinations enable row level security;
alter table public.opening_hours enable row level security;
alter table public.rides enable row level security;
alter table public.ratings enable row level security;

-- Roles table
drop policy if exists "Admins can manage roles" on public.roles;
create policy "Admins can manage roles"
on public.roles for all
using (exists (
  select 1 from public.profiles p
  join public.roles r on r.id = p.role_id
  where p.id = auth.uid() and r.name = 'ADMIN'
));

-- Profiles table
drop policy if exists "Users can view and update their own profile" on public.profiles;
create policy "Users can view and update their own profile"
on public.profiles for all
using (auth.uid() = id);

-- Destinations table
drop policy if exists "Everyone can read destinations" on public.destinations;
create policy "Everyone can read destinations"
on public.destinations for select using (true);

drop policy if exists "Admins can manage destinations" on public.destinations;
create policy "Admins can manage destinations"
on public.destinations for all
using (exists (
  select 1 from public.profiles p
  join public.roles r on r.id = p.role_id
  where p.id = auth.uid() and r.name = 'ADMIN'
));

-- Opening hours table
drop policy if exists "Everyone can read opening hours" on public.opening_hours;
create policy "Everyone can read opening hours"
on public.opening_hours for select using (true);

drop policy if exists "Admins can manage opening hours" on public.opening_hours;
create policy "Admins can manage opening hours"
on public.opening_hours for all
using (exists (
  select 1 from public.profiles p
  join public.roles r on r.id = p.role_id
  where p.id = auth.uid() and r.name = 'ADMIN'
));

-- Rides table
drop policy if exists "Users can manage their own rides" on public.rides;
create policy "Users can manage their own rides"
on public.rides for all
using (auth.uid() = user_id);

-- Ratings table
drop policy if exists "Everyone can read ratings" on public.ratings;
create policy "Everyone can read ratings"
on public.ratings for select using (true);

drop policy if exists "Users can manage their own ratings" on public.ratings;
create policy "Users can manage their own ratings"
on public.ratings for all
using (auth.uid() = user_id);

-- =============================================
-- =============== VIEWS =======================
-- =============================================

create or replace view public.destinations_ratings_avg as
select
  d.id as destination_id,
  d.name,
  round(avg(r.rating), 2) as avg_rating,
  count(r.id) as total_ratings
from public.destinations d
left join public.ratings r on r.destination_id = d.id
group by d.id;

-- =============================================
-- =============== INITIAL DATA ================
-- =============================================

insert into public.roles (name) values ('ADMIN'), ('VISITOR'), ('CLIENT')
on conflict (name) do nothing;

