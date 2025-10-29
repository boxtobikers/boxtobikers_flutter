-- Migration: Mise à jour de l'adresse du profil VISITOR
-- Date: 2025-10-29
-- Description: Ajoute ou met à jour l'adresse du profil VISITOR avec une adresse par défaut

-- Mettre à jour l'adresse du profil VISITOR
UPDATE public.profiles
SET address = '1 place de La LUNE 24000 LA LUNE'
WHERE id = '00000000-0000-0000-0000-000000000000'::uuid
  AND (address IS NULL OR address = '' OR address = '1 Rue de La Lune 24000 La LUNE');

