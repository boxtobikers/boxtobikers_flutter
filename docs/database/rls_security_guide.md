# Sécurité RLS (Row Level Security) - BoxToBikers

## Principe fondamental

**Chaque utilisateur (anonyme VISITOR ou authentifié) ne peut accéder QU'À SES PROPRES données.**

Ce principe s'applique à toutes les tables contenant une colonne `user_id` :
- `profiles` : Un utilisateur ne peut lire/modifier que son propre profil
- `rides` : Un utilisateur ne peut accéder qu'à ses propres rides
- `ratings` : Un utilisateur ne peut gérer que ses propres évaluations

## La fonction `get_current_user_id()`

Pour gérer à la fois les utilisateurs authentifiés ET les sessions anonymes (VISITOR), nous utilisons une fonction centralisée :

```sql
CREATE OR REPLACE FUNCTION public.get_current_user_id()
RETURNS uuid
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
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
```

### Comment ça fonctionne ?

**Pour un utilisateur authentifié :**
- `auth.uid()` retourne son UUID Supabase
- La fonction retourne cet UUID
- L'utilisateur accède à ses données (celles où `user_id = son UUID`)

**Pour une session anonyme (VISITOR) :**
- `auth.uid()` retourne `NULL` (pas de session Supabase)
- La fonction retourne `'00000000-0000-0000-0000-000000000000'`
- L'utilisateur accède aux données du profil VISITOR


