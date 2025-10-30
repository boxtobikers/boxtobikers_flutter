-- =============================================
-- Migration: Améliorations de sécurité et support complet du profil VISITOR
-- Date: 2025-10-30
-- Description:
--   1. Ajoute une contrainte d'unicité sur rides (user_id, destination_id)
--   2. Crée une fonction get_current_user_id() pour supporter VISITOR
--   3. Corrige toutes les politiques RLS (rides, ratings, profiles)
--   4. Sécurise les fonctions SECURITY DEFINER avec search_path = ''
-- =============================================

-- =============================================
-- PARTIE 1: Contrainte d'unicité sur rides
-- =============================================

-- Supprimer les doublons existants (garder le plus récent)
DELETE FROM public.rides a
USING public.rides b
WHERE a.id < b.id
  AND a.user_id = b.user_id
  AND a.destination_id = b.destination_id;

-- Ajouter la contrainte d'unicité
ALTER TABLE public.rides
ADD CONSTRAINT rides_user_id_destination_id_unique UNIQUE (user_id, destination_id);

COMMENT ON CONSTRAINT rides_user_id_destination_id_unique ON public.rides IS
'Empêche un utilisateur d''avoir plusieurs rides pour la même destination. Un utilisateur ne peut avoir qu''un seul ride par destination.';

-- =============================================
-- PARTIE 2: Fonction get_current_user_id() pour VISITOR
-- =============================================

-- Créer une fonction pour obtenir le user_id courant
-- Pour les utilisateurs authentifiés : auth.uid()
-- Pour les sessions anonymes : '00000000-0000-0000-0000-000000000000'::uuid (VISITOR)
CREATE OR REPLACE FUNCTION public.get_current_user_id()
RETURNS uuid
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  -- Si l'utilisateur est authentifié, retourner son UUID
  IF auth.uid() IS NOT NULL THEN
    RETURN auth.uid();
  END IF;

  -- Sinon, retourner l'UUID du profil VISITOR
  RETURN '00000000-0000-0000-0000-000000000000'::uuid;
END;
$$;

COMMENT ON FUNCTION public.get_current_user_id() IS
'Retourne le user_id courant : auth.uid() pour les utilisateurs authentifiés, UUID VISITOR pour les sessions anonymes. Utilise SECURITY DEFINER avec search_path vide pour la sécurité.';

-- =============================================
-- PARTIE 3: Politiques RLS pour rides
-- =============================================

-- Supprimer l'ancienne politique restrictive
DROP POLICY IF EXISTS "Users can manage their own rides" ON public.rides;

-- Créer les nouvelles politiques pour rides
CREATE POLICY "Users can read their own rides"
ON public.rides
FOR SELECT
USING (user_id = public.get_current_user_id());

CREATE POLICY "Users can insert their own rides"
ON public.rides
FOR INSERT
WITH CHECK (user_id = public.get_current_user_id());

CREATE POLICY "Users can update their own rides"
ON public.rides
FOR UPDATE
USING (user_id = public.get_current_user_id())
WITH CHECK (user_id = public.get_current_user_id());

CREATE POLICY "Users can delete their own rides"
ON public.rides
FOR DELETE
USING (user_id = public.get_current_user_id());

-- Commentaires pour rides
COMMENT ON POLICY "Users can read their own rides" ON public.rides IS
'Permet à chaque utilisateur (VISITOR ou authentifié) de lire UNIQUEMENT ses propres rides.';

COMMENT ON POLICY "Users can insert their own rides" ON public.rides IS
'Permet à chaque utilisateur de créer des rides pour lui-même uniquement.';

COMMENT ON POLICY "Users can update their own rides" ON public.rides IS
'Permet à chaque utilisateur de mettre à jour UNIQUEMENT ses propres rides.';

COMMENT ON POLICY "Users can delete their own rides" ON public.rides IS
'Permet à chaque utilisateur de supprimer UNIQUEMENT ses propres rides.';

-- =============================================
-- PARTIE 4: Politiques RLS pour ratings
-- =============================================

-- Supprimer les anciennes politiques trop permissives
DROP POLICY IF EXISTS "Everyone can read ratings" ON public.ratings;
DROP POLICY IF EXISTS "Users can manage their own ratings" ON public.ratings;

-- Créer les nouvelles politiques pour ratings
CREATE POLICY "Users can read their own ratings"
ON public.ratings
FOR SELECT
USING (user_id = public.get_current_user_id());

CREATE POLICY "Users can insert their own ratings"
ON public.ratings
FOR INSERT
WITH CHECK (user_id = public.get_current_user_id());

CREATE POLICY "Users can update their own ratings"
ON public.ratings
FOR UPDATE
USING (user_id = public.get_current_user_id())
WITH CHECK (user_id = public.get_current_user_id());

CREATE POLICY "Users can delete their own ratings"
ON public.ratings
FOR DELETE
USING (user_id = public.get_current_user_id());

-- Commentaires pour ratings
COMMENT ON POLICY "Users can read their own ratings" ON public.ratings IS
'Permet à chaque utilisateur (VISITOR ou authentifié) de lire UNIQUEMENT ses propres ratings.';

COMMENT ON POLICY "Users can insert their own ratings" ON public.ratings IS
'Permet à chaque utilisateur de créer des ratings pour lui-même uniquement.';

COMMENT ON POLICY "Users can update their own ratings" ON public.ratings IS
'Permet à chaque utilisateur de mettre à jour UNIQUEMENT ses propres ratings.';

COMMENT ON POLICY "Users can delete their own ratings" ON public.ratings IS
'Permet à chaque utilisateur de supprimer UNIQUEMENT ses propres ratings.';

-- =============================================
-- PARTIE 5: Politiques RLS pour profiles
-- =============================================

-- Supprimer les anciennes politiques
DROP POLICY IF EXISTS "Anyone can read visitor profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can view and update their own profile" ON public.profiles;

-- Créer les nouvelles politiques pour profiles
CREATE POLICY "Users can read their own profile"
ON public.profiles
FOR SELECT
USING (id = public.get_current_user_id());

CREATE POLICY "Users can update their own profile"
ON public.profiles
FOR UPDATE
USING (id = public.get_current_user_id())
WITH CHECK (id = public.get_current_user_id());

-- Note: On ne permet pas INSERT ni DELETE sur profiles car ces opérations
-- sont gérées par des triggers lors de la création/suppression d'utilisateurs Supabase

-- Commentaires pour profiles
COMMENT ON POLICY "Users can read their own profile" ON public.profiles IS
'Permet à chaque utilisateur (VISITOR ou authentifié) de lire UNIQUEMENT son propre profil.';

COMMENT ON POLICY "Users can update their own profile" ON public.profiles IS
'Permet à chaque utilisateur de mettre à jour UNIQUEMENT son propre profil.';

-- =============================================
-- PARTIE 6: Sécurisation des fonctions SECURITY DEFINER
-- =============================================

-- Corriger get_user_role
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS text
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  user_role TEXT;
BEGIN
  -- Si pas authentifié, retourner VISITOR
  IF auth.uid() IS NULL THEN
    RETURN 'VISITOR';
  END IF;

  -- Récupérer le rôle de l'utilisateur
  SELECT r.name INTO user_role
  FROM public.profiles p
  JOIN public.roles r ON r.id = p.role_id
  WHERE p.id = auth.uid()
  LIMIT 1;

  RETURN COALESCE(user_role, 'VISITOR');
END;
$$;

COMMENT ON FUNCTION public.get_user_role() IS
'Retourne le rôle de l''utilisateur courant (ADMIN, CLIENT, VISITOR). Utilise SECURITY DEFINER avec search_path vide pour éviter la récursion RLS et les attaques par injection de schéma.';

-- Corriger handle_new_user
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.profiles (id, role_id, first_name, last_name, email)
  VALUES (
    NEW.id,
    (SELECT id FROM public.roles WHERE name = 'VISITOR' LIMIT 1),
    '',
    '',
    NEW.email
  );
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.handle_new_user() IS
'Trigger function qui crée automatiquement un profil VISITOR lors de la création d''un utilisateur Supabase. Utilise SECURITY DEFINER avec search_path vide pour la sécurité.';

-- Corriger is_user_admin
CREATE OR REPLACE FUNCTION public.is_user_admin()
RETURNS boolean
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  RETURN public.get_user_role() = 'ADMIN';
END;
$$;

COMMENT ON FUNCTION public.is_user_admin() IS
'Vérifie si l''utilisateur courant est un administrateur. Utilise SECURITY DEFINER avec search_path vide pour éviter la récursion RLS et les attaques par injection de schéma.';

