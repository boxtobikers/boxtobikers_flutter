-- Fix final: Solution simple et efficace pour la récursion RLS
-- Date: 2025-10-26
--
-- Cette migration résout le problème de récursion infinie en créant
-- des fonctions helper et des politiques simplifiées

-- =============================================
-- ÉTAPE 1: Créer les fonctions helper
-- =============================================

-- Fonction pour obtenir le rôle de l'utilisateur courant
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS TEXT AS $$
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
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- Fonction pour vérifier si l'utilisateur est admin
CREATE OR REPLACE FUNCTION public.is_user_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN public.get_user_role() = 'ADMIN';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- =============================================
-- ÉTAPE 2: Supprimer les anciennes politiques
-- =============================================

-- Supprimer toutes les politiques existantes qui causent la récursion
DROP POLICY IF EXISTS "Admins can manage roles" ON public.roles;
DROP POLICY IF EXISTS "Everyone can read roles" ON public.roles;
DROP POLICY IF EXISTS "Admins can modify roles" ON public.roles;
DROP POLICY IF EXISTS "Admins can insert roles" ON public.roles;
DROP POLICY IF EXISTS "Admins can update roles" ON public.roles;
DROP POLICY IF EXISTS "Admins can delete roles" ON public.roles;

DROP POLICY IF EXISTS "Admins can manage destinations" ON public.destinations;
DROP POLICY IF EXISTS "Admins can modify destinations" ON public.destinations;
DROP POLICY IF EXISTS "Admins can insert destinations" ON public.destinations;
DROP POLICY IF EXISTS "Admins can update destinations" ON public.destinations;
DROP POLICY IF EXISTS "Admins can delete destinations" ON public.destinations;

DROP POLICY IF EXISTS "Admins can manage opening hours" ON public.opening_hours;
DROP POLICY IF EXISTS "Admins can modify opening hours" ON public.opening_hours;
DROP POLICY IF EXISTS "Admins can insert opening hours" ON public.opening_hours;
DROP POLICY IF EXISTS "Admins can update opening hours" ON public.opening_hours;
DROP POLICY IF EXISTS "Admins can delete opening hours" ON public.opening_hours;

-- =============================================
-- ÉTAPE 3: Créer les nouvelles politiques
-- =============================================

-- TABLE ROLES
-- Tout le monde peut lire les rôles
CREATE POLICY "roles_select_public"
ON public.roles FOR SELECT
USING (true);

-- Seuls les admins peuvent modifier les rôles
CREATE POLICY "roles_insert_admin"
ON public.roles FOR INSERT
WITH CHECK (public.is_user_admin());

CREATE POLICY "roles_update_admin"
ON public.roles FOR UPDATE
USING (public.is_user_admin())
WITH CHECK (public.is_user_admin());

CREATE POLICY "roles_delete_admin"
ON public.roles FOR DELETE
USING (public.is_user_admin());

-- TABLE DESTINATIONS
-- Lecture publique déjà définie dans la migration initiale
-- On ajoute juste les permissions pour les admins

CREATE POLICY "destinations_insert_admin"
ON public.destinations FOR INSERT
WITH CHECK (public.is_user_admin());

CREATE POLICY "destinations_update_admin"
ON public.destinations FOR UPDATE
USING (public.is_user_admin())
WITH CHECK (public.is_user_admin());

CREATE POLICY "destinations_delete_admin"
ON public.destinations FOR DELETE
USING (public.is_user_admin());

-- TABLE OPENING_HOURS
-- Lecture publique déjà définie dans la migration initiale
-- On ajoute juste les permissions pour les admins

CREATE POLICY "opening_hours_insert_admin"
ON public.opening_hours FOR INSERT
WITH CHECK (public.is_user_admin());

CREATE POLICY "opening_hours_update_admin"
ON public.opening_hours FOR UPDATE
USING (public.is_user_admin())
WITH CHECK (public.is_user_admin());

CREATE POLICY "opening_hours_delete_admin"
ON public.opening_hours FOR DELETE
USING (public.is_user_admin());

-- =============================================
-- ÉTAPE 4: Ajouter des commentaires
-- =============================================

COMMENT ON FUNCTION public.get_user_role() IS
'Retourne le rôle de l''utilisateur courant (ADMIN, CLIENT, VISITOR). Utilise SECURITY DEFINER pour éviter la récursion RLS.';

COMMENT ON FUNCTION public.is_user_admin() IS
'Vérifie si l''utilisateur courant est un administrateur. Utilise SECURITY DEFINER pour éviter la récursion RLS.';

-- =============================================
-- Notes
-- =============================================
-- Les fonctions SECURITY DEFINER s'exécutent avec les privilèges du créateur
-- et non de l'appelant, ce qui permet d'éviter la récursion dans les politiques RLS.
--
-- Les fonctions STABLE indiquent à PostgreSQL que le résultat ne change pas
-- pendant une transaction, permettant une optimisation des performances.

