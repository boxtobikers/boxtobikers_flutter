SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

COMMENT ON SCHEMA "public" IS 'standard public schema';CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";CREATE OR REPLACE FUNCTION "public"."get_user_role"() RETURNS "text"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
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
$$;ALTER FUNCTION "public"."get_user_role"() OWNER TO "postgres";

COMMENT ON FUNCTION "public"."get_user_role"() IS 'Retourne le rôle de l''utilisateur courant (ADMIN, CLIENT, VISITOR). Utilise SECURITY DEFINER pour éviter la récursion RLS.';CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
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
$$;ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";CREATE OR REPLACE FUNCTION "public"."is_user_admin"() RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
BEGIN
  RETURN public.get_user_role() = 'ADMIN';
END;
$$;
ALTER FUNCTION "public"."is_user_admin"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."is_user_admin"() IS 'Vérifie si l''utilisateur courant est un administrateur. Utilise SECURITY DEFINER pour éviter la récursion RLS.';


SET default_tablespace = '';

SET default_table_access_method = "heap";
CREATE TABLE IF NOT EXISTS "public"."destinations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "type" "text" NOT NULL,
    "description" "text",
    "address" "text",
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "status" "text" DEFAULT 'OPEN'::"text" NOT NULL,
    "locker_count" integer DEFAULT 0,
    "image_url" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "destinations_locker_count_check" CHECK (("locker_count" >= 0)),
    CONSTRAINT "destinations_status_check" CHECK (("status" = ANY (ARRAY['OPEN'::"text", 'CLOSED'::"text", 'PAUSED'::"text"]))),
    CONSTRAINT "destinations_type_check" CHECK (("type" = ANY (ARRAY['BUSINESS'::"text", 'PRIVATE'::"text"])))
);
ALTER TABLE "public"."destinations" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."destinations_ratings_avg" AS
SELECT
    NULL::"uuid" AS "destination_id",
    NULL::"text" AS "name",
    NULL::numeric AS "avg_rating",
    NULL::bigint AS "total_ratings";
ALTER VIEW "public"."destinations_ratings_avg" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."opening_hours" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "destination_id" "uuid" NOT NULL,
    "weekday" "text" NOT NULL,
    "open_time" time without time zone NOT NULL,
    "close_time" time without time zone NOT NULL,
    "is_closed" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "opening_hours_weekday_check" CHECK (("weekday" = ANY (ARRAY['MONDAY'::"text", 'TUESDAY'::"text", 'WEDNESDAY'::"text", 'THURSDAY'::"text", 'FRIDAY'::"text", 'SATURDAY'::"text", 'SUNDAY'::"text"])))
);
ALTER TABLE "public"."opening_hours" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "role_id" "uuid",
    "first_name" "text" NOT NULL,
    "last_name" "text" NOT NULL,
    "email" "text",
    "mobile" "text",
    "address" "text",
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."profiles" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ratings" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "destination_id" "uuid" NOT NULL,
    "rating" integer NOT NULL,
    "comment" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "ratings_rating_check" CHECK ((("rating" >= 1) AND ("rating" <= 5)))
);
ALTER TABLE "public"."ratings" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."rides" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "destination_id" "uuid" NOT NULL,
    "status" "text" DEFAULT 'PENDING'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "rides_status_check" CHECK (("status" = ANY (ARRAY['PENDING'::"text", 'CONFIRMED'::"text", 'CANCELLED'::"text", 'COMPLETED'::"text"])))
);
ALTER TABLE "public"."rides" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "roles_name_check" CHECK (("name" = ANY (ARRAY['ADMIN'::"text", 'VISITOR'::"text", 'CLIENT'::"text"])))
);
ALTER TABLE "public"."roles" OWNER TO "postgres";
ALTER TABLE ONLY "public"."destinations"
    ADD CONSTRAINT "destinations_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."opening_hours"
    ADD CONSTRAINT "opening_hours_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."ratings"
    ADD CONSTRAINT "ratings_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."ratings"
    ADD CONSTRAINT "ratings_user_id_destination_id_key" UNIQUE ("user_id", "destination_id");

ALTER TABLE ONLY "public"."rides"
    ADD CONSTRAINT "rides_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_name_key" UNIQUE ("name");

ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");
CREATE OR REPLACE VIEW "public"."destinations_ratings_avg" AS
 SELECT "d"."id" AS "destination_id",
    "d"."name",
    "round"("avg"("r"."rating"), 2) AS "avg_rating",
    "count"("r"."id") AS "total_ratings"
   FROM ("public"."destinations" "d"
     LEFT JOIN "public"."ratings" "r" ON (("r"."destination_id" = "d"."id")))
  GROUP BY "d"."id";

ALTER TABLE ONLY "public"."opening_hours"
    ADD CONSTRAINT "opening_hours_destination_id_fkey" FOREIGN KEY ("destination_id") REFERENCES "public"."destinations"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id");

ALTER TABLE ONLY "public"."ratings"
    ADD CONSTRAINT "ratings_destination_id_fkey" FOREIGN KEY ("destination_id") REFERENCES "public"."destinations"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."ratings"
    ADD CONSTRAINT "ratings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."rides"
    ADD CONSTRAINT "rides_destination_id_fkey" FOREIGN KEY ("destination_id") REFERENCES "public"."destinations"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."rides"
    ADD CONSTRAINT "rides_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;

CREATE POLICY "Anyone can read visitor profile" ON "public"."profiles" FOR SELECT USING ((("id" = '00000000-0000-0000-0000-000000000000'::"uuid") OR ("auth"."uid"() = "id")));

CREATE POLICY "Everyone can read destinations" ON "public"."destinations" FOR SELECT USING (true);

CREATE POLICY "Everyone can read opening hours" ON "public"."opening_hours" FOR SELECT USING (true);

CREATE POLICY "Everyone can read ratings" ON "public"."ratings" FOR SELECT USING (true);

CREATE POLICY "Users can manage their own ratings" ON "public"."ratings" USING ((("auth"."uid"() = "user_id") AND ("auth"."uid"() IS NOT NULL)));

CREATE POLICY "Users can manage their own rides" ON "public"."rides" USING ((("auth"."uid"() = "user_id") AND ("auth"."uid"() IS NOT NULL)));

CREATE POLICY "Users can view and update their own profile" ON "public"."profiles" USING ((("auth"."uid"() = "id") AND ("auth"."uid"() IS NOT NULL)));

ALTER TABLE "public"."destinations" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "destinations_delete_admin" ON "public"."destinations" FOR DELETE USING ("public"."is_user_admin"());

CREATE POLICY "destinations_insert_admin" ON "public"."destinations" FOR INSERT WITH CHECK ("public"."is_user_admin"());

CREATE POLICY "destinations_update_admin" ON "public"."destinations" FOR UPDATE USING ("public"."is_user_admin"()) WITH CHECK ("public"."is_user_admin"());

ALTER TABLE "public"."opening_hours" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "opening_hours_delete_admin" ON "public"."opening_hours" FOR DELETE USING ("public"."is_user_admin"());

CREATE POLICY "opening_hours_insert_admin" ON "public"."opening_hours" FOR INSERT WITH CHECK ("public"."is_user_admin"());

CREATE POLICY "opening_hours_update_admin" ON "public"."opening_hours" FOR UPDATE USING ("public"."is_user_admin"()) WITH CHECK ("public"."is_user_admin"());

ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ratings" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."rides" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."roles" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "roles_delete_admin" ON "public"."roles" FOR DELETE USING ("public"."is_user_admin"());

CREATE POLICY "roles_insert_admin" ON "public"."roles" FOR INSERT WITH CHECK ("public"."is_user_admin"());

CREATE POLICY "roles_select_public" ON "public"."roles" FOR SELECT USING (true);

CREATE POLICY "roles_update_admin" ON "public"."roles" FOR UPDATE USING ("public"."is_user_admin"()) WITH CHECK ("public"."is_user_admin"());

ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

























































































































































GRANT ALL ON FUNCTION "public"."get_user_role"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_role"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_role"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_user_admin"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_user_admin"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_user_admin"() TO "service_role";


















GRANT ALL ON TABLE "public"."destinations" TO "anon";
GRANT ALL ON TABLE "public"."destinations" TO "authenticated";
GRANT ALL ON TABLE "public"."destinations" TO "service_role";



GRANT ALL ON TABLE "public"."destinations_ratings_avg" TO "anon";
GRANT ALL ON TABLE "public"."destinations_ratings_avg" TO "authenticated";
GRANT ALL ON TABLE "public"."destinations_ratings_avg" TO "service_role";



GRANT ALL ON TABLE "public"."opening_hours" TO "anon";
GRANT ALL ON TABLE "public"."opening_hours" TO "authenticated";
GRANT ALL ON TABLE "public"."opening_hours" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."ratings" TO "anon";
GRANT ALL ON TABLE "public"."ratings" TO "authenticated";
GRANT ALL ON TABLE "public"."ratings" TO "service_role";



GRANT ALL ON TABLE "public"."rides" TO "anon";
GRANT ALL ON TABLE "public"."rides" TO "authenticated";
GRANT ALL ON TABLE "public"."rides" TO "service_role";



GRANT ALL ON TABLE "public"."roles" TO "anon";
GRANT ALL ON TABLE "public"."roles" TO "authenticated";
GRANT ALL ON TABLE "public"."roles" TO "service_role";







ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";




ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";




ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































drop extension if exists "pg_net";


