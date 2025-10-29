-- Migration: Ajout de la colonne birthdate à la table profiles
-- Date: 2025-10-29
-- Description: Ajoute une colonne pour stocker la date de naissance des utilisateurs

-- Ajouter la colonne birthdate (nullable car les profils existants n'ont pas cette info)
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS birthdate DATE;

-- Ajouter un commentaire pour documenter la colonne
COMMENT ON COLUMN public.profiles.birthdate IS 'Date de naissance de l''utilisateur (format: YYYY-MM-DD)';

-- Mettre à jour le profil VISITOR avec une date de naissance par défaut
UPDATE public.profiles
SET birthdate = '1970-01-01'
WHERE id = '00000000-0000-0000-0000-000000000000'::uuid
  AND birthdate IS NULL;

