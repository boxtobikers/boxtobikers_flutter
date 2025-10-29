-- =============================================
-- =============== SEED DATA ===================
-- =============================================
-- Fichier de données initiales pour le projet BoxToBikers
-- Ce fichier est exécuté après les migrations lors d'un db reset

-- =============================================
-- 1. Rôles
-- =============================================
INSERT INTO public.roles (id, name, created_at)
VALUES
  ('2b7b612b-ff15-49ba-869d-56d443430822', 'VISITOR', '2025-10-25 11:52:13.683932+00'),
  ('4c5b416b-be4a-41d4-965b-f555d718ee26', 'CLIENT', '2025-10-25 11:52:13.683932+00'),
  ('fe0838e4-809d-4dd1-a978-7abd98375f56', 'ADMIN', '2025-10-25 11:52:13.683932+00')
ON conflict (name) do nothing;

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
  '1 Rue de La Lune 24000 La LUNE',
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
) VALUES
  ('16c18bb2-8a7b-4758-a908-54d9a7e22e95', 'Camargue', 'PRIVATE', 'Ferme équestre en pleine Camargue', '13460 Saintes-Maries-de-la-Mer, France', '43.4516', '4.4298', 'OPEN', '3', null, '2025-10-25 17:18:29.831059+00'),
  ('1bf2197f-f124-4bfc-847c-ba354a14cd0d', 'Île de Ré', 'BUSINESS', 'Hôtel de charme en bord de mer', 'Le Bois-Plage-en-Ré, 17580, France', '46.1806', '-1.3954', 'OPEN', '3', null, '2025-10-25 17:18:29.831059+00'),
  ('243bd25b-b41b-41c1-aeaa-d2884659c7de', 'Tour Eiffel', 'BUSINESS', 'Café souvenir près de la Tour Eiffel', 'Champ de Mars, 5 Avenue Anatole France, 75007 Paris', '48.8584', '2.2945', 'OPEN', '8', null, '2025-10-25 17:18:29.831059+00'),
  ('2c80818d-d7f7-4789-99a6-d6e925b77eed', 'Lac Léman', 'BUSINESS', 'Restaurant panoramique au bord du lac Léman', '74500 Évian-les-Bains, France', '46.4011', '6.5899', 'OPEN', '5', null, '2025-10-25 17:18:29.831059+00'),
  ('2cdfe6ae-55e4-4170-a451-3ce362fb925f', 'Louvre Museum', 'BUSINESS', 'Boutique d’art et librairie du musée du Louvre', 'Rue de Rivoli, 75001 Paris', '48.8606', '2.3376', 'OPEN', '6', null, '2025-10-25 17:18:29.831059+00'),
  ('3261f9f4-b4bb-4120-9e8c-25c9e58dd18d', 'Pont du Gard', 'BUSINESS', 'Aire de repos et boutique artisanale', '400 Route du Pont du Gard, 30210 Vers-Pont-du-Gard', '43.9475', '4.535', 'OPEN', '3', null, '2025-10-25 17:18:29.831059+00'),
  ('3c00e7df-bf46-488c-82ff-a7f4dbf6e9df', 'Parc du Marquenterre', 'BUSINESS', 'Observatoire ornithologique et café bio', '80120 Saint-Quentin-en-Tourmont, France', '50.2371', '1.6164', 'OPEN', '2', null, '2025-10-25 17:18:29.831059+00'),
  ('3e617778-9c74-459c-a2e5-94707d6f8c63', 'Stade de France', 'PRIVATE', 'Espace VIP du Stade de France', '93216 Saint-Denis, France', '48.9244', '2.3601', 'OPEN', '10', null, '2025-10-25 17:18:29.831059+00'),
  ('48d145a0-17fa-4fdb-87f6-47c53a4c2a21', 'Basilique Notre-Dame de la Garde', 'BUSINESS', 'Boutique de souvenirs', 'Rue Fort du Sanctuaire, 13281 Marseille', '43.2841', '5.3718', 'OPEN', '4', null, '2025-10-25 17:18:29.831059+00'),
  ('540c49ad-1de1-460a-bd79-47646cfa2f03', 'Château de Versailles', 'PRIVATE', 'Résidence privée à proximité du château', 'Place d’Armes, 78000 Versailles', '48.8049', '2.1204', 'CLOSED', '2', null, '2025-10-25 17:18:29.831059+00'),
  ('5ef71cc6-5be9-4455-9773-00b69f5524cf', 'Promenade des Anglais', 'BUSINESS', 'Bar lounge en bord de mer', 'Promenade des Anglais, Nice', '43.6954', '7.265', 'OPEN', '6', null, '2025-10-25 17:18:29.831059+00'),
  ('7a445e92-44b2-4331-82c2-a390e359853e', 'Bike Garage', 'BUSINESS', 'Bike repair & parts', '5 Rue Oberkampf, Paris', '48.865', '2.37', 'OPEN', '3', null, '2025-10-25 13:10:54.905277+00'),
  ('87e1a532-f777-4f49-aad9-b585e8b26e6d', 'Puy de Dôme', 'PRIVATE', 'Maison d’hôtes avec vue sur le volcan', '63130 Royat, France', '45.772', '2.9644', 'OPEN', '2', null, '2025-10-25 17:18:29.831059+00'),
  ('8f466aac-b475-426d-81fd-d81b1d1e1fd6', 'Place du Capitole', 'BUSINESS', 'Café historique au cœur de Toulouse', 'Place du Capitole, 31000 Toulouse', '43.6043', '1.4437', 'OPEN', '5', null, '2025-10-25 17:18:29.831059+00'),
  ('942df1b1-c0c3-4db7-b08f-d705f8d21fd4', 'Alice Home', 'PRIVATE', 'Friendly host offering lockers', '77 Rue St-Honoré, Paris', '48.862', '2.341', 'OPEN', '2', null, '2025-10-25 13:10:54.905277+00'),
  ('9fefea3b-d21c-4c52-8331-bd76dc7b1a0d', 'Mont Blanc', 'PRIVATE', 'Chalet de montagne proche du Mont Blanc', '74400 Chamonix-Mont-Blanc', '45.8326', '6.8652', 'CLOSED', '1', null, '2025-10-25 17:18:29.831059+00'),
  ('a49ca7a6-8f46-40c0-b1e4-0182496635ee', 'Mont Saint-Michel', 'BUSINESS', 'Hôtel-restaurant au Mont Saint-Michel', '50170 Le Mont-Saint-Michel, France', '48.6361', '-1.5115', 'OPEN', '4', null, '2025-10-25 17:18:29.831059+00'),
  ('ac6639b9-1ca2-4903-9b35-0f29337d8c0c', 'Colmar Centre', 'BUSINESS', 'Café typique dans la Petite Venise de Colmar', 'Rue des Tanneurs, 68000 Colmar', '48.079', '7.3585', 'OPEN', '4', null, '2025-10-25 17:18:29.831059+00'),
  ('b67f6fb9-cd2d-4508-bfec-45315f23b9b4', 'Cathédrale Notre-Dame de Strasbourg', 'PRIVATE', 'Appartement touristique face à la cathédrale', 'Place de la Cathédrale, 67000 Strasbourg', '48.5816', '7.7507', 'OPEN', '2', null, '2025-10-25 17:18:29.831059+00'),
  ('bb9f9d6f-90bb-4c33-97c6-a004fec5126f', 'Gorges du Verdon', 'PRIVATE', 'Gîte rural avec vue sur les Gorges du Verdon', '04120 Castellane, France', '43.7372', '6.3633', 'OPEN', '2', null, '2025-10-25 17:18:29.831059+00'),
  ('c31e7c6d-a6d3-4ad6-b43e-1c6687dba5dc', 'Saint-Tropez Port', 'BUSINESS', 'Boutique nautique sur le port', 'Quai Suffren, 83990 Saint-Tropez', '43.2675', '6.6403', 'OPEN', '5', null, '2025-10-25 17:18:29.831059+00'),
  ('cee6fde0-3652-4e28-9ab6-52e67e7e74ed', 'Vignoble de Saint-Émilion', 'PRIVATE', 'Château viticole familial', '33330 Saint-Émilion, France', '44.8939', '-0.1555', 'OPEN', '4', null, '2025-10-25 17:18:29.831059+00'),
  ('d0682846-a82c-49b3-8913-0afab9c1fefe', 'Dune du Pilat', 'BUSINESS', 'Point de location de vélos et buvette', '33115 Pyla-sur-Mer, France', '44.5896', '-1.213', 'OPEN', '3', null, '2025-10-25 17:18:29.831059+00'),
  ('d518bb07-d7df-408e-82a8-31f1b5f8e008', 'Parc National des Écrins', 'PRIVATE', 'Refuge de montagne dans les Alpes', '05200 Les Orres, France', '44.8739', '6.4076', 'OPEN', '1', null, '2025-10-25 17:18:29.831059+00'),
  ('de804f76-beee-4a1f-8bdb-4532b566807e', 'Forêt de Brocéliande', 'PRIVATE', 'Maison forestière inspirée des légendes arthuriennes', '35380 Paimpont, France', '48.0172', '-2.1723', 'CLOSED', '1', null, '2025-10-25 17:18:29.831059+00'),
  ('e69e3558-2c90-4d37-8300-09e7d6c35142', 'Lac d’Annecy', 'BUSINESS', 'Location de paddle et café au bord du lac', '74000 Annecy, France', '45.8992', '6.1286', 'OPEN', '4', null, '2025-10-25 17:18:29.831059+00'),
  ('f1840ea5-f322-423f-8daf-46550238b1dc', 'Green Coffee', 'BUSINESS', 'Coffee shop downtown', '12 Rue de Rivoli, Paris', '48.8566', '2.3522', 'OPEN', '5', null, '2025-10-25 13:10:54.905277+00')
ON conflict (id) do nothing;

-- =============================================
-- 5. Horaires d'ouverture de test (optionnel)
-- =============================================
INSERT INTO public.opening_hours (id, destination_id, weekday, open_time, close_time, is_closed, created_at)
VALUES
('1b3404c8-63e8-4471-9f22-17aa614d1253', '7a445e92-44b2-4331-82c2-a390e359853e', 'MONDAY', '08:00:00', '18:00:00', 'false', '2025-10-25 13:10:54.905277+00'),
('4f8fd9dc-c28c-4a5e-83c7-250afd452baf', 'f1840ea5-f322-423f-8daf-46550238b1dc', 'MONDAY', '08:00:00', '18:00:00', 'false', '2025-10-25 13:10:54.905277+00'),
('726784eb-672b-4bab-a11f-b097afee3d44', '7a445e92-44b2-4331-82c2-a390e359853e', 'TUESDAY', '08:00:00', '18:00:00', 'false', '2025-10-25 13:10:54.905277+00'),
('b7ff67e8-3f3e-4677-8be7-9096441d0d4a', 'f1840ea5-f322-423f-8daf-46550238b1dc', 'TUESDAY', '08:00:00', '18:00:00', 'false', '2025-10-25 13:10:54.905277+00')
ON conflict(id) do nothing;

