-- Migration: Garantir un seul profil VISITOR avec UUID fixe
-- Date: 2025-10-28
-- Objectif: Nettoyer les doublons et garantir qu'il n'existe qu'un seul profil "Visiteur Anonyme"

-- =============================================
-- ÉTAPE 1: Supprimer TOUS les profils Visiteur sauf celui avec l'UUID fixe
-- =============================================

DELETE FROM public.profiles
WHERE first_name = 'Visiteur'
  AND last_name = 'Anonyme'
  AND id != '00000000-0000-0000-0000-000000000000'::uuid;

-- =============================================
-- ÉTAPE 2: S'assurer que le rôle VISITOR existe
-- =============================================

INSERT INTO public.roles (name)
VALUES ('VISITOR')
ON CONFLICT (name) DO NOTHING;

-- =============================================
-- ÉTAPE 3: Créer ou mettre à jour le profil VISITOR unique
-- =============================================

INSERT INTO public.profiles (
  id,
  role_id,
  first_name,
  last_name,
  email,
  mobile,
  address,
  created_at
) VALUES (
  '00000000-0000-0000-0000-000000000000'::uuid,
  (SELECT id FROM public.roles WHERE name = 'VISITOR' LIMIT 1),
  'Visiteur',
  'Anonyme',
  'visitor@boxtobikers.local',
  '',
  '',
  now()
)
ON CONFLICT (id) DO UPDATE SET
  role_id = (SELECT id FROM public.roles WHERE name = 'VISITOR' LIMIT 1),
  first_name = 'Visiteur',
  last_name = 'Anonyme',
  email = 'visitor@boxtobikers.local',
  mobile = '',
  address = '';

-- =============================================
-- VÉRIFICATION: Il ne doit y avoir qu'un seul profil Visiteur Anonyme
-- =============================================

DO $$
DECLARE
  visitor_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO visitor_count
  FROM public.profiles
  WHERE first_name = 'Visiteur' AND last_name = 'Anonyme';

  IF visitor_count != 1 THEN
    RAISE EXCEPTION 'ERREUR: % profils "Visiteur Anonyme" trouvés, il ne devrait y en avoir qu''un seul', visitor_count;
  END IF;

  RAISE NOTICE 'OK: Un seul profil "Visiteur Anonyme" existe (UUID: 00000000-0000-0000-0000-000000000000)';
END $$;

