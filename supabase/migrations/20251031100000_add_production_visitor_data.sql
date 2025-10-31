-- =============================================
-- Migration: Ajouter les données de production pour le profil VISITOR
-- Date: 2025-10-31
-- Description: Ajoute une destination de test, ses horaires et un ride pour le profil VISITOR
--              Cette migration est conçue pour la PRODUCTION uniquement.
--              Elle vide et remplit les tables destinations, opening_hours et rides
--              pour garantir que le profil VISITOR a des données de démonstration.
-- =============================================

-- =============================================
-- PARTIE 1: Créer ou vérifier le profil VISITOR
-- =============================================

-- Créer le profil VISITOR s'il n'existe pas
INSERT INTO public.profiles (
  id,
  role_id,
  first_name,
  last_name,
  email,
  address,
  birthdate,
  created_at
) VALUES (
  '00000000-0000-0000-0000-000000000000'::uuid,
  (SELECT id FROM public.roles WHERE name = 'VISITOR' LIMIT 1),
  'Visitor',
  'Demo',
  'visitor@boxtobikers.com',
  '1 Place de La Lune, Mare Tranquillitatis, The Moon',
  '1969-07-21',
  now()
)
ON CONFLICT (id) DO UPDATE SET
  address = EXCLUDED.address,
  birthdate = EXCLUDED.birthdate;

-- =============================================
-- PARTIE 2: Supprimer les données VISITOR existantes
-- =============================================

-- Supprimer les rides du profil VISITOR
DELETE FROM public.rides WHERE user_id = '00000000-0000-0000-0000-000000000000'::uuid;

-- Supprimer les horaires de la destination VISITOR
DELETE FROM public.opening_hours WHERE destination_id = 'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid;

-- Supprimer la destination VISITOR
DELETE FROM public.destinations WHERE id = 'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid;

-- =============================================
-- PARTIE 3: Ajouter une destination de test
-- =============================================

INSERT INTO public.destinations (
  id,
  name,
  type,
  description,
  address,
  latitude,
  longitude,
  status,
  locker_count,
  image_url,
  created_at
) VALUES (
  'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid,
  'Lunar Bike Station',
  'BUSINESS',
  'Station de vélos lunaires - Premier garage à vélos sur la Lune ! Équipement anti-gravité inclus',
  '1 Place de La Lune, Mare Tranquillitatis, The Moon',
  0.6875,
  23.4333,
  'OPEN',
  42,
  null,
  now()
)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  type = EXCLUDED.type,
  description = EXCLUDED.description,
  address = EXCLUDED.address,
  latitude = EXCLUDED.latitude,
  longitude = EXCLUDED.longitude,
  status = EXCLUDED.status,
  locker_count = EXCLUDED.locker_count;

-- =============================================
-- PARTIE 4: Ajouter les horaires d'ouverture (toute la semaine)
-- =============================================

INSERT INTO public.opening_hours (
  destination_id,
  weekday,
  open_time,
  close_time,
  is_closed,
  created_at
) VALUES
  -- Lundi
  ('ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid, 'MONDAY', '00:00:00', '23:59:59', false, now()),
  -- Mardi
  ('ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid, 'TUESDAY', '00:00:00', '23:59:59', false, now()),
  -- Mercredi
  ('ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid, 'WEDNESDAY', '00:00:00', '23:59:59', false, now()),
  -- Jeudi
  ('ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid, 'THURSDAY', '00:00:00', '23:59:59', false, now()),
  -- Vendredi
  ('ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid, 'FRIDAY', '00:00:00', '23:59:59', false, now()),
  -- Samedi
  ('ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid, 'SATURDAY', '00:00:00', '23:59:59', false, now()),
  -- Dimanche
  ('ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid, 'SUNDAY', '00:00:00', '23:59:59', false, now());

-- =============================================
-- PARTIE 5: Ajouter un ride pour le profil VISITOR
-- =============================================

INSERT INTO public.rides (
  user_id,
  destination_id,
  status,
  created_at
) VALUES (
  '00000000-0000-0000-0000-000000000000'::uuid,
  'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid,
  'COMPLETED',
  now()
)
ON CONFLICT (user_id, destination_id) DO UPDATE SET
  status = EXCLUDED.status,
  created_at = now();

-- =============================================
-- COMMENTAIRE FINAL
-- =============================================

-- Cette migration garantit que le profil VISITOR a toujours:
-- 1 destination de démonstration fun : Lunar Bike Station sur la Lune !
-- 7 horaires d''ouverture 24h/24 (la Lune ne dort jamais)
-- 1 ride complété pour tester l''application
--
-- ISOLATION COMPLÈTE: UUID = ffffffff-ffff-ffff-ffff-ffffffffffff
--    Cette destination est UNIQUEMENT pour le profil VISITOR
--    Coordonnées : Mare Tranquillitatis (là où Apollo 11 s''est posé)
--    42 casiers disponibles (référence à la réponse universelle)
--
-- IDEMPOTENTE: Cette migration peut être exécutée plusieurs fois sans problème
--    Elle supprime uniquement les données du profil VISITOR avant de les réinsérer
--    Les autres données (autres utilisateurs, autres destinations) ne sont pas affectées
--
-- COMPATIBLE: Fonctionne en local ET en production

