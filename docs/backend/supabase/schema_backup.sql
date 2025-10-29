--
-- PostgreSQL database dump
--

\restrict jOll6OxMNPnnxCCKQMm76BCpsLVQ8T9RDwMOc4cBG3lJ27bNtuiBMu3EVkp4bIy

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: get_user_role(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_role() RETURNS text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
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


--
-- Name: FUNCTION get_user_role(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_user_role() IS 'Retourne le rôle de l''utilisateur courant (ADMIN, CLIENT, VISITOR). Utilise SECURITY DEFINER pour éviter la récursion RLS.';


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
  insert into public.profiles (id, role_id, first_name, last_name, email)
  values (
    new.id,
    (select id from public.roles where name = 'VISITOR' limit 1),
    '',
    '',
    new.email
  );
  return new;
end;
$$;


--
-- Name: is_user_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_user_admin() RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
BEGIN
  RETURN public.get_user_role() = 'ADMIN';
END;
$$;


--
-- Name: FUNCTION is_user_admin(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.is_user_admin() IS 'Vérifie si l''utilisateur courant est un administrateur. Utilise SECURITY DEFINER pour éviter la récursion RLS.';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: destinations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.destinations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    description text,
    address text,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    status text DEFAULT 'OPEN'::text NOT NULL,
    locker_count integer DEFAULT 0,
    image_url text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT destinations_locker_count_check CHECK ((locker_count >= 0)),
    CONSTRAINT destinations_status_check CHECK ((status = ANY (ARRAY['OPEN'::text, 'CLOSED'::text, 'PAUSED'::text]))),
    CONSTRAINT destinations_type_check CHECK ((type = ANY (ARRAY['BUSINESS'::text, 'PRIVATE'::text])))
);


--
-- Name: destinations_ratings_avg; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.destinations_ratings_avg AS
SELECT
    NULL::uuid AS destination_id,
    NULL::text AS name,
    NULL::numeric AS avg_rating,
    NULL::bigint AS total_ratings;


--
-- Name: opening_hours; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.opening_hours (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    destination_id uuid NOT NULL,
    weekday text NOT NULL,
    open_time time without time zone NOT NULL,
    close_time time without time zone NOT NULL,
    is_closed boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT opening_hours_weekday_check CHECK ((weekday = ANY (ARRAY['MONDAY'::text, 'TUESDAY'::text, 'WEDNESDAY'::text, 'THURSDAY'::text, 'FRIDAY'::text, 'SATURDAY'::text, 'SUNDAY'::text])))
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    role_id uuid,
    first_name text NOT NULL,
    last_name text NOT NULL,
    email text,
    mobile text,
    address text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ratings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    destination_id uuid NOT NULL,
    rating integer NOT NULL,
    comment text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT ratings_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- Name: rides; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rides (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    destination_id uuid NOT NULL,
    status text DEFAULT 'PENDING'::text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT rides_status_check CHECK ((status = ANY (ARRAY['PENDING'::text, 'CONFIRMED'::text, 'CANCELLED'::text, 'COMPLETED'::text])))
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT roles_name_check CHECK ((name = ANY (ARRAY['ADMIN'::text, 'VISITOR'::text, 'CLIENT'::text])))
);


--
-- Name: destinations destinations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_pkey PRIMARY KEY (id);


--
-- Name: opening_hours opening_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: ratings ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: ratings ratings_user_id_destination_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_user_id_destination_id_key UNIQUE (user_id, destination_id);


--
-- Name: rides rides_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rides
    ADD CONSTRAINT rides_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: destinations_ratings_avg _RETURN; Type: RULE; Schema: public; Owner: -
--

CREATE OR REPLACE VIEW public.destinations_ratings_avg AS
 SELECT d.id AS destination_id,
    d.name,
    round(avg(r.rating), 2) AS avg_rating,
    count(r.id) AS total_ratings
   FROM (public.destinations d
     LEFT JOIN public.ratings r ON ((r.destination_id = d.id)))
  GROUP BY d.id;


--
-- Name: opening_hours opening_hours_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: ratings ratings_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(id) ON DELETE CASCADE;


--
-- Name: ratings ratings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: rides rides_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rides
    ADD CONSTRAINT rides_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(id) ON DELETE CASCADE;


--
-- Name: rides rides_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rides
    ADD CONSTRAINT rides_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: profiles Anyone can read visitor profile; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anyone can read visitor profile" ON public.profiles FOR SELECT USING (((id = '00000000-0000-0000-0000-000000000000'::uuid) OR (auth.uid() = id)));


--
-- Name: destinations Everyone can read destinations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Everyone can read destinations" ON public.destinations FOR SELECT USING (true);


--
-- Name: opening_hours Everyone can read opening hours; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Everyone can read opening hours" ON public.opening_hours FOR SELECT USING (true);


--
-- Name: ratings Everyone can read ratings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Everyone can read ratings" ON public.ratings FOR SELECT USING (true);


--
-- Name: ratings Users can manage their own ratings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage their own ratings" ON public.ratings USING (((auth.uid() = user_id) AND (auth.uid() IS NOT NULL)));


--
-- Name: rides Users can manage their own rides; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage their own rides" ON public.rides USING (((auth.uid() = user_id) AND (auth.uid() IS NOT NULL)));


--
-- Name: profiles Users can view and update their own profile; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view and update their own profile" ON public.profiles USING (((auth.uid() = id) AND (auth.uid() IS NOT NULL)));


--
-- Name: destinations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.destinations ENABLE ROW LEVEL SECURITY;

--
-- Name: destinations destinations_delete_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY destinations_delete_admin ON public.destinations FOR DELETE USING (public.is_user_admin());


--
-- Name: destinations destinations_insert_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY destinations_insert_admin ON public.destinations FOR INSERT WITH CHECK (public.is_user_admin());


--
-- Name: destinations destinations_update_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY destinations_update_admin ON public.destinations FOR UPDATE USING (public.is_user_admin()) WITH CHECK (public.is_user_admin());


--
-- Name: opening_hours; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.opening_hours ENABLE ROW LEVEL SECURITY;

--
-- Name: opening_hours opening_hours_delete_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY opening_hours_delete_admin ON public.opening_hours FOR DELETE USING (public.is_user_admin());


--
-- Name: opening_hours opening_hours_insert_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY opening_hours_insert_admin ON public.opening_hours FOR INSERT WITH CHECK (public.is_user_admin());


--
-- Name: opening_hours opening_hours_update_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY opening_hours_update_admin ON public.opening_hours FOR UPDATE USING (public.is_user_admin()) WITH CHECK (public.is_user_admin());


--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: ratings; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ratings ENABLE ROW LEVEL SECURITY;

--
-- Name: rides; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.rides ENABLE ROW LEVEL SECURITY;

--
-- Name: roles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;

--
-- Name: roles roles_delete_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY roles_delete_admin ON public.roles FOR DELETE USING (public.is_user_admin());


--
-- Name: roles roles_insert_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY roles_insert_admin ON public.roles FOR INSERT WITH CHECK (public.is_user_admin());


--
-- Name: roles roles_select_public; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY roles_select_public ON public.roles FOR SELECT USING (true);


--
-- Name: roles roles_update_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY roles_update_admin ON public.roles FOR UPDATE USING (public.is_user_admin()) WITH CHECK (public.is_user_admin());


--
-- PostgreSQL database dump complete
--

\unrestrict jOll6OxMNPnnxCCKQMm76BCpsLVQ8T9RDwMOc4cBG3lJ27bNtuiBMu3EVkp4bIy

