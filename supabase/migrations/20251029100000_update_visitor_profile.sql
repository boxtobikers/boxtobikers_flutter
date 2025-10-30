-- =============================================
-- Migration: Mise à jour du profil VISITOR
-- Date: 2025-10-29
-- Description:
--   1. Ajoute la colonne birthdate à la table profiles
--   2. Met à jour le profil VISITOR avec une date de naissance et une adresse par défaut
-- =============================================

-- =============================================
-- PARTIE 1: Ajout de la colonne birthdate
-- =============================================

-- Ajouter la colonne birthdate (nullable car les profils existants n'ont pas cette info)
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS birthdate DATE;

-- Ajouter un commentaire pour documenter la colonne
COMMENT ON COLUMN public.profiles.birthdate IS 'Date de naissance de l''utilisateur (format: YYYY-MM-DD)';

-- =============================================
-- PARTIE 2: Mise à jour du profil VISITOR
-- =============================================

-- Mettre à jour le profil VISITOR avec les valeurs par défaut
UPDATE public.profiles
SET
  birthdate = '1970-01-01',
  address = '1 place de La LUNE 24000 LA LUNE'
WHERE id = '00000000-0000-0000-0000-000000000000'::uuid
  AND (
    birthdate IS NULL
    OR address IS NULL
    OR address = ''
    OR address = '1 Rue de La Lune 24000 La LUNE'
  );

