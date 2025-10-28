-- =============================================
-- =============== SEED DATA ===================
-- =============================================
-- Fichier de données initiales pour le projet BoxToBikers
-- Ce fichier est exécuté après les migrations lors d'un db reset

-- =============================================
-- 1. Rôles (déjà créés dans la migration initiale, mais on s'assure)
-- =============================================
insert into public.roles (name)
values ('ADMIN'), ('VISITOR'), ('CLIENT')
on conflict (name) do nothing;

-- =============================================
-- 2. Utilisateur VISITOR pré-créé dans auth.users
-- =============================================
-- Note importante :
-- On crée un utilisateur Supabase avec un UUID fixe pour le VISITOR.
-- Cet utilisateur sera partagé par TOUS les utilisateurs non connectés.
-- L'UUID fixe permet de toujours référencer le même utilisateur VISITOR.

-- Insérer l'utilisateur VISITOR dans auth.users (schéma interne Supabase)
-- IMPORTANT: Cette insertion est sensible et nécessite les bons champs
insert into auth.users (
  id,
  instance_id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  invited_at,
  confirmation_token,
  confirmation_sent_at,
  recovery_token,
  recovery_sent_at,
  email_change_token_new,
  email_change,
  email_change_sent_at,
  last_sign_in_at,
  raw_app_meta_data,
  raw_user_meta_data,
  is_super_admin,
  created_at,
  updated_at,
  phone,
  phone_confirmed_at,
  phone_change,
  phone_change_token,
  phone_change_sent_at,
  email_change_token_current,
  email_change_confirm_status,
  banned_until,
  reauthentication_token,
  reauthentication_sent_at,
  is_sso_user,
  deleted_at
) values (
  '00000000-0000-0000-0000-000000000000'::uuid,  -- UUID fixe pour VISITOR
  '00000000-0000-0000-0000-000000000000'::uuid,  -- instance_id
  'authenticated',                                 -- aud
  'authenticated',                                 -- role
  'visitor@boxtobikers.local',                    -- email (non utilisé)
  '$2a$10$VISITOR_ACCOUNT_NO_PASSWORD_HASH',     -- encrypted_password (hash fictif)
  now(),                                          -- email_confirmed_at
  null,                                           -- invited_at
  '',                                             -- confirmation_token
  null,                                           -- confirmation_sent_at
  '',                                             -- recovery_token
  null,                                           -- recovery_sent_at
  '',                                             -- email_change_token_new
  '',                                             -- email_change
  null,                                           -- email_change_sent_at
  null,                                           -- last_sign_in_at
  '{"provider":"system","providers":["system"]}', -- raw_app_meta_data
  '{"first_name":"Visiteur","last_name":"Anonyme"}', -- raw_user_meta_data
  false,                                          -- is_super_admin
  now(),                                          -- created_at
  now(),                                          -- updated_at
  null,                                           -- phone
  null,                                           -- phone_confirmed_at
  '',                                             -- phone_change
  '',                                             -- phone_change_token
  null,                                           -- phone_change_sent_at
  '',                                             -- email_change_token_current
  0,                                              -- email_change_confirm_status
  null,                                           -- banned_until
  '',                                             -- reauthentication_token
  null,                                           -- reauthentication_sent_at
  false,                                          -- is_sso_user
  null                                            -- deleted_at
)
on conflict (id) do nothing;

-- =============================================
-- 3. Profil VISITOR dans public.profiles
-- =============================================
-- Maintenant qu'on a l'utilisateur auth.users, on peut créer le profil

insert into public.profiles (
  id,
  role_id,
  first_name,
  last_name,
  email,
  mobile,
  address,
  created_at
) values (
  '00000000-0000-0000-0000-000000000000'::uuid,  -- UUID fixe pour VISITOR (même que auth.users)
  (select id from public.roles where name = 'VISITOR' limit 1),
  'Visiteur',
  'Anonyme',
  'visitor@boxtobikers.local',
  '',
  '',
  now()
)
on conflict (id) do update set
  role_id = (select id from public.roles where name = 'VISITOR' limit 1),
  first_name = 'Visiteur',
  last_name = 'Anonyme';

-- =============================================
-- 3. Exemple d'utilisateur admin pour les tests
-- =============================================
-- Note : Pour créer un vrai admin, vous devez :
-- 1. Créer l'utilisateur via Supabase Auth (Studio ou API)
-- 2. Mettre à jour son profil pour lui donner le rôle ADMIN
--
-- Exemple de commande pour mettre à jour un utilisateur existant en ADMIN :
-- update public.profiles
-- set role_id = (select id from public.roles where name = 'ADMIN')
-- where email = 'admin@boxtobikers.com';

-- =============================================
-- 4. Destinations de test (optionnel)
-- =============================================
-- Décommenter pour ajouter des destinations de test

-- insert into public.destinations (
--   name,
--   type,
--   description,
--   address,
--   latitude,
--   longitude,
--   status,
--   locker_count
-- ) values
-- (
--   'Test Destination - Paris Centre',
--   'BUSINESS',
--   'Point de dépôt test au centre de Paris',
--   '123 Rue de Rivoli, 75001 Paris',
--   48.8606,
--   2.3376,
--   'OPEN',
--   10
-- ),
-- (
--   'Test Destination - Bordeaux',
--   'PRIVATE',
--   'Point privé de test à Bordeaux',
--   '45 Quai des Chartrons, 33000 Bordeaux',
--   44.8478,
--   -0.5792,
--   'OPEN',
--   5
-- )
-- on conflict (id) do nothing;

-- =============================================
-- 5. Horaires d'ouverture de test (optionnel)
-- =============================================
-- Décommenter pour ajouter des horaires aux destinations de test

-- insert into public.opening_hours (
--   destination_id,
--   weekday,
--   open_time,
--   close_time,
--   is_closed
-- )
-- select
--   d.id,
--   day,
--   '09:00'::time,
--   '18:00'::time,
--   false
-- from
--   public.destinations d,
--   unnest(array['MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY']) as day
-- where d.name like 'Test Destination%'
-- on conflict do nothing;

