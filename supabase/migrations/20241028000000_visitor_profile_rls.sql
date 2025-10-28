-- Migration pour adapter les RLS policies au nouveau système VISITOR
-- Permet au profil VISITOR pré-créé d'accéder aux données publiques
-- sans nécessiter d'authentification Supabase

-- =============================================
-- =============== RLS POLICIES ================
-- =============================================

-- Note importante:
-- Avec le nouveau système, les utilisateurs non connectés utilisent le profil VISITOR
-- pré-créé (UUID: 00000000-0000-0000-0000-000000000000) SANS utilisateur Supabase.
-- Les policies doivent donc permettre l'accès aux données publiques même quand auth.uid() est null.

-- Profiles table - Permettre la lecture du profil VISITOR sans authentification
drop policy if exists "Anyone can read visitor profile" on public.profiles;
create policy "Anyone can read visitor profile"
on public.profiles for select
using (
  id = '00000000-0000-0000-0000-000000000000'::uuid -- Profil VISITOR public
  or auth.uid() = id -- Ou son propre profil si authentifié
);

-- Conserver la policy existante pour les utilisateurs authentifiés
drop policy if exists "Users can view and update their own profile" on public.profiles;
create policy "Users can view and update their own profile"
on public.profiles for all
using (auth.uid() = id and auth.uid() is not null);

-- Destinations - Déjà accessible à tous (inchangé)
-- drop policy if exists "Everyone can read destinations" on public.destinations;
-- create policy "Everyone can read destinations"
-- on public.destinations for select using (true);

-- Opening hours - Déjà accessible à tous (inchangé)
-- drop policy if exists "Everyone can read opening hours" on public.opening_hours;
-- create policy "Everyone can read opening hours"
-- on public.opening_hours for select using (true);

-- Ratings - Déjà accessible en lecture à tous (inchangé)
-- drop policy if exists "Everyone can read ratings" on public.ratings;
-- create policy "Everyone can read ratings"
-- on public.ratings for select using (true);

-- Rides - Les utilisateurs VISITOR ne peuvent pas créer de rides
-- Ils doivent d'abord se connecter ou s'inscrire
drop policy if exists "Users can manage their own rides" on public.rides;
create policy "Users can manage their own rides"
on public.rides for all
using (auth.uid() = user_id and auth.uid() is not null);

-- Ratings - Les utilisateurs VISITOR ne peuvent pas créer de ratings
-- Ils doivent d'abord se connecter ou s'inscrire
drop policy if exists "Users can manage their own ratings" on public.ratings;
create policy "Users can manage their own ratings"
on public.ratings for all
using (auth.uid() = user_id and auth.uid() is not null);

-- =============================================
-- =============== COMMENTAIRES ================
-- =============================================

-- Résumé des permissions:
--
-- VISITOR (non connecté, profil pré-créé):
-- ✅ Peut lire: destinations, opening_hours, ratings (données publiques)
-- ✅ Peut lire: son propre profil VISITOR
-- ❌ Ne peut pas: créer rides, créer ratings (nécessite authentification)
-- ❌ Ne peut pas: modifier son profil VISITOR
--
-- CLIENT/ADMIN (authentifié):
-- ✅ Peut lire: destinations, opening_hours, ratings, son profil
-- ✅ Peut créer/modifier: ses propres rides, ses propres ratings
-- ✅ Peut modifier: son propre profil
--
-- ADMIN uniquement:
-- ✅ Peut gérer: destinations, opening_hours, roles (via policies existantes)

