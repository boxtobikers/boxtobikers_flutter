-- boxtobikers_test_data.sql
-- Test data for Boxtobikers schema
-- Run this after importing boxtobikers_schema.sql

-- =============================================
-- =============== INSERT TEST DATA =============
-- =============================================

-- 1️⃣ Create a dummy user in auth.users (for local dev)
-- ⚠️ In Supabase, this would normally be created via signUp()
insert into auth.users (id, email)
values ('11111111-1111-1111-1111-111111111111', 'testclient@boxtobikers.com')
on conflict (id) do nothing;

-- 2️⃣ Assign role CLIENT to that user in profiles
insert into public.profiles (id, role_id, first_name, last_name, email, mobile, address)
values (
  '11111111-1111-1111-1111-111111111111',
  (select id from public.roles where name = 'CLIENT' limit 1),
  'John',
  'Doe',
  'testclient@boxtobikers.com',
  '+33600000000',
  '123 Avenue République, Paris'
)
on conflict (id) do nothing;

-- 3️⃣ Add some destinations
insert into public.destinations (name, type, description, address, latitude, longitude, status, locker_count)
values
('Green Coffee', 'BUSINESS', 'Coffee shop downtown', '12 Rue de Rivoli, Paris', 48.8566, 2.3522, 'OPEN', 5),
('Bike Garage', 'BUSINESS', 'Bike repair & parts', '5 Rue Oberkampf, Paris', 48.865, 2.37, 'OPEN', 3),
('Alice Home', 'PRIVATE', 'Friendly host offering lockers', '77 Rue St-Honoré, Paris', 48.862, 2.341, 'OPEN', 2);

-- 4️⃣ Add opening hours for businesses
insert into public.opening_hours (destination_id, weekday, open_time, close_time, is_closed)
select id, 'MONDAY', '08:00', '18:00', false from public.destinations where type = 'BUSINESS';

insert into public.opening_hours (destination_id, weekday, open_time, close_time, is_closed)
select id, 'TUESDAY', '08:00', '18:00', false from public.destinations where type = 'BUSINESS';

-- 5️⃣ Add a ride for the test user
insert into public.rides (user_id, destination_id, pickup_address, destination_address, status)
values (
  '11111111-1111-1111-1111-111111111111',
  (select id from public.destinations where name = 'Green Coffee' limit 1),
  '22 Boulevard Voltaire, Paris',
  '12 Rue de Rivoli, Paris',
  'CONFIRMED'
);

-- 6️⃣ Add ratings for destinations
insert into public.ratings (user_id, destination_id, rating, comment)
select
  '11111111-1111-1111-1111-111111111111',
  id,
  floor(random() * 5 + 1),
  'Nice location!'
from public.destinations;

-- =============================================
-- =============== VALIDATION QUERIES ===========
-- =============================================

-- Check roles
select * from public.roles;

-- Check profiles
select p.*, r.name as role_name
from public.profiles p
join public.roles r on r.id = p.role_id;

-- Check destinations
select * from public.destinations;

-- Check rides
select r.id, d.name as destination_name, r.status
from public.rides r
join public.destinations d on d.id = r.destination_id;

-- Check ratings + view
select * from public.ratings;
select * from public.destinations_ratings_avg;

-- Done
