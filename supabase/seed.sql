-- Seed data for Boxtobikers
-- This file contains sample data for testing and development

-- Sample destinations (you can add your own)
insert into public.destinations (name, type, description, address, latitude, longitude, status, locker_count, image_url)
values
  ('Gare de Lyon', 'BUSINESS', 'Point de dépôt à la gare de Lyon', '20 Boulevard Diderot, 75012 Paris', 48.8443, 2.3736, 'OPEN', 50, null),
  ('Bordeaux Centre', 'BUSINESS', 'Point de dépôt au centre de Bordeaux', '1 Place de la Bourse, 33000 Bordeaux', 44.8378, -0.5792, 'OPEN', 30, null),
  ('Nice Promenade', 'BUSINESS', 'Point de dépôt sur la promenade des Anglais', '15 Promenade des Anglais, 06000 Nice', 43.6951, 7.2658, 'OPEN', 25, null)
on conflict do nothing;

-- Sample opening hours for destinations
insert into public.opening_hours (destination_id, weekday, open_time, close_time, is_closed)
select
  d.id,
  unnest(array['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY']) as weekday,
  '08:00'::time as open_time,
  '20:00'::time as close_time,
  false as is_closed
from public.destinations d
where d.name in ('Gare de Lyon', 'Bordeaux Centre', 'Nice Promenade')
on conflict do nothing;

insert into public.opening_hours (destination_id, weekday, open_time, close_time, is_closed)
select
  d.id,
  unnest(array['SATURDAY', 'SUNDAY']) as weekday,
  '10:00'::time as open_time,
  '18:00'::time as close_time,
  false as is_closed
from public.destinations d
where d.name in ('Gare de Lyon', 'Bordeaux Centre', 'Nice Promenade')
on conflict do nothing;

