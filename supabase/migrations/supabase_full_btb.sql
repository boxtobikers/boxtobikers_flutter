--
-- PostgreSQL database dump
--

\restrict EO7R1nP8kkGSPrClWZbL4XlnlLfBUPQevRgfZtxIxCMJ8HjJA3Go5hyj51vghEi-- Dumped from database version 17.6
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
SET row_security = off;--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--
CREATE SCHEMA auth;
--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--
CREATE SCHEMA extensions;
--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--
CREATE SCHEMA graphql;
--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--
CREATE SCHEMA graphql_public;
--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--
CREATE SCHEMA pgbouncer;
--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--
CREATE SCHEMA realtime;
--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--
CREATE SCHEMA storage;
--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: -
--
CREATE SCHEMA supabase_migrations;
--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--
CREATE SCHEMA vault;
--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;
--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--
COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';
--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;
--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--
COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';
--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;
--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;
--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--
COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';
--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;
--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--
COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);
--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--
CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);
--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--
CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);
--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--
CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);
--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--
CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);
--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--
CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);
--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--
CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);
--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--
CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);
--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--
CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);
--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--
CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);
--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--
CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);
--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--
CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);
--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--
CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);
--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--
CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);
--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--
CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS'
);
--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--
CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;
--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';
--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--
CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;
--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--
CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;
--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';
--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--
CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;
--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';
--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--
CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;
--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--
COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';
--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--
CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;
--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--
COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';
--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--
CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;
--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--
COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';
--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--
CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;
--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--
CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;
--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--
CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;
--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--
COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';
--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--
CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;
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
--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;
--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;
--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;
--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;
--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;
--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;
--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;
--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;
--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;
--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;
--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;
--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--
CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;
--
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;
--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;
--
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;
--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;
--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;
--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;
--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;
--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;
--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;
--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;
--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;
--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;
--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;
--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;
--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;
--
-- Name: lock_top_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket text;
    v_top text;
BEGIN
    FOR v_bucket, v_top IN
        SELECT DISTINCT t.bucket_id,
            split_part(t.name, '/', 1) AS top
        FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        WHERE t.name <> ''
        ORDER BY 1, 2
        LOOP
            PERFORM pg_advisory_xact_lock(hashtextextended(v_bucket || '/' || v_top, 0));
        END LOOP;
END;
$$;
--
-- Name: objects_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.objects_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;
--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;
--
-- Name: objects_update_cleanup(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.objects_update_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    -- NEW - OLD (destinations to create prefixes for)
    v_add_bucket_ids text[];
    v_add_names      text[];

    -- OLD - NEW (sources to prune)
    v_src_bucket_ids text[];
    v_src_names      text[];
BEGIN
    IF TG_OP <> 'UPDATE' THEN
        RETURN NULL;
    END IF;

    -- 1) Compute NEW−OLD (added paths) and OLD−NEW (moved-away paths)
    WITH added AS (
        SELECT n.bucket_id, n.name
        FROM new_rows n
        WHERE n.name <> '' AND position('/' in n.name) > 0
        EXCEPT
        SELECT o.bucket_id, o.name FROM old_rows o WHERE o.name <> ''
    ),
    moved AS (
         SELECT o.bucket_id, o.name
         FROM old_rows o
         WHERE o.name <> ''
         EXCEPT
         SELECT n.bucket_id, n.name FROM new_rows n WHERE n.name <> ''
    )
    SELECT
        -- arrays for ADDED (dest) in stable order
        COALESCE( (SELECT array_agg(a.bucket_id ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        COALESCE( (SELECT array_agg(a.name      ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        -- arrays for MOVED (src) in stable order
        COALESCE( (SELECT array_agg(m.bucket_id ORDER BY m.bucket_id, m.name) FROM moved m), '{}' ),
        COALESCE( (SELECT array_agg(m.name      ORDER BY m.bucket_id, m.name) FROM moved m), '{}' )
    INTO v_add_bucket_ids, v_add_names, v_src_bucket_ids, v_src_names;

    -- Nothing to do?
    IF (array_length(v_add_bucket_ids, 1) IS NULL) AND (array_length(v_src_bucket_ids, 1) IS NULL) THEN
        RETURN NULL;
    END IF;

    -- 2) Take per-(bucket, top) locks: ALL prefixes in consistent global order to prevent deadlocks
    DECLARE
        v_all_bucket_ids text[];
        v_all_names text[];
    BEGIN
        -- Combine source and destination arrays for consistent lock ordering
        v_all_bucket_ids := COALESCE(v_src_bucket_ids, '{}') || COALESCE(v_add_bucket_ids, '{}');
        v_all_names := COALESCE(v_src_names, '{}') || COALESCE(v_add_names, '{}');

        -- Single lock call ensures consistent global ordering across all transactions
        IF array_length(v_all_bucket_ids, 1) IS NOT NULL THEN
            PERFORM storage.lock_top_prefixes(v_all_bucket_ids, v_all_names);
        END IF;
    END;

    -- 3) Create destination prefixes (NEW−OLD) BEFORE pruning sources
    IF array_length(v_add_bucket_ids, 1) IS NOT NULL THEN
        WITH candidates AS (
            SELECT DISTINCT t.bucket_id, unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(v_add_bucket_ids, v_add_names) AS t(bucket_id, name)
            WHERE name <> ''
        )
        INSERT INTO storage.prefixes (bucket_id, name)
        SELECT c.bucket_id, c.name
        FROM candidates c
        ON CONFLICT DO NOTHING;
    END IF;

    -- 4) Prune source prefixes bottom-up for OLD−NEW
    IF array_length(v_src_bucket_ids, 1) IS NOT NULL THEN
        -- re-entrancy guard so DELETE on prefixes won't recurse
        IF current_setting('storage.gc.prefixes', true) <> '1' THEN
            PERFORM set_config('storage.gc.prefixes', '1', true);
        END IF;

        PERFORM storage.delete_leaf_prefixes(v_src_bucket_ids, v_src_names);
    END IF;

    RETURN NULL;
END;
$$;
--
-- Name: objects_update_level_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.objects_update_level_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Set the new level
        NEW."level" := "storage"."get_level"(NEW."name");
    END IF;
    RETURN NEW;
END;
$$;
--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;
--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;
--
-- Name: prefixes_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.prefixes_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;
--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;
--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;
--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;
--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;
--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    sort_col text;
    sort_ord text;
    cursor_op text;
    cursor_expr text;
    sort_expr text;
BEGIN
    -- Validate sort_order
    sort_ord := lower(sort_order);
    IF sort_ord NOT IN ('asc', 'desc') THEN
        sort_ord := 'asc';
    END IF;

    -- Determine cursor comparison operator
    IF sort_ord = 'asc' THEN
        cursor_op := '>';
    ELSE
        cursor_op := '<';
    END IF;
    
    sort_col := lower(sort_column);
    -- Validate sort column  
    IF sort_col IN ('updated_at', 'created_at') THEN
        cursor_expr := format(
            '($5 = '''' OR ROW(date_trunc(''milliseconds'', %I), name COLLATE "C") %s ROW(COALESCE(NULLIF($6, '''')::timestamptz, ''epoch''::timestamptz), $5))',
            sort_col, cursor_op
        );
        sort_expr := format(
            'COALESCE(date_trunc(''milliseconds'', %I), ''epoch''::timestamptz) %s, name COLLATE "C" %s',
            sort_col, sort_ord, sort_ord
        );
    ELSE
        cursor_expr := format('($5 = '''' OR name COLLATE "C" %s $5)', cursor_op);
        sort_expr := format('name COLLATE "C" %s', sort_ord);
    END IF;

    RETURN QUERY EXECUTE format(
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    NULL::uuid AS id,
                    updated_at,
                    created_at,
                    NULL::timestamptz AS last_accessed_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
            UNION ALL
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    id,
                    updated_at,
                    created_at,
                    last_accessed_at,
                    metadata
                FROM storage.objects
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
        ) obj
        ORDER BY %s
        LIMIT $3
        $sql$,
        cursor_expr,    -- prefixes WHERE
        sort_expr,      -- prefixes ORDER BY
        cursor_expr,    -- objects WHERE
        sort_expr,      -- objects ORDER BY
        sort_expr       -- final ORDER BY
    )
    USING prefix, bucket_name, limits, levels, start_after, sort_column_after;
END;
$_$;
--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--
CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);
--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';
--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);
--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';
--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);
--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';
--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';
--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);
--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';
--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);
--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';
--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);
--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';
--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);
--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';
--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);
--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048))
);
--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);
--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);
--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);
--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';
--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--
CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--
ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;
--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);
--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';
--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);
--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';
--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);
--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';
--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid
);
--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';
--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';
--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);
--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';
--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);
--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';
--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';
--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--
CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);
--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';
--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';
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
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--
CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);
--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--
CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);
--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--
CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);
--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--
ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--
CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);
--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--
COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';
--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--
CREATE TABLE storage.buckets_analytics (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--
CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--
CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    level integer
);
--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--
COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';
--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: -
--
CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--
CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);
--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--
CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: -
--
CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);
--
-- Name: seed_files; Type: TABLE; Schema: supabase_migrations; Owner: -
--
CREATE TABLE supabase_migrations.seed_files (
    path text NOT NULL,
    hash text NOT NULL
);
--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);
--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.
--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.
--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.
--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.
--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.
--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.
--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.
--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at) FROM stdin;
\.
--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type) FROM stdin;
\.
--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.
--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.
--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.
--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.
--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.
--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
\.
--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id) FROM stdin;
\.
--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.
--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.
--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\N	11111111-1111-1111-1111-111111111111	\N	\N	testclient@boxtobikers.com	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N			\N		0	\N		\N	f	\N	f
\.
--
-- Data for Name: destinations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.destinations (id, name, type, description, address, latitude, longitude, status, locker_count, image_url, created_at) FROM stdin;
f1840ea5-f322-423f-8daf-46550238b1dc	Green Coffee	BUSINESS	Coffee shop downtown	12 Rue de Rivoli, Paris	48.8566	2.3522	OPEN	5	\N	2025-10-25 13:10:54.905277+00
7a445e92-44b2-4331-82c2-a390e359853e	Bike Garage	BUSINESS	Bike repair & parts	5 Rue Oberkampf, Paris	48.865	2.37	OPEN	3	\N	2025-10-25 13:10:54.905277+00
942df1b1-c0c3-4db7-b08f-d705f8d21fd4	Alice Home	PRIVATE	Friendly host offering lockers	77 Rue St-Honoré, Paris	48.862	2.341	OPEN	2	\N	2025-10-25 13:10:54.905277+00
243bd25b-b41b-41c1-aeaa-d2884659c7de	Tour Eiffel	BUSINESS	Café souvenir près de la Tour Eiffel	Champ de Mars, 5 Avenue Anatole France, 75007 Paris	48.8584	2.2945	OPEN	8	\N	2025-10-25 17:18:29.831059+00
2cdfe6ae-55e4-4170-a451-3ce362fb925f	Louvre Museum	BUSINESS	Boutique d’art et librairie du musée du Louvre	Rue de Rivoli, 75001 Paris	48.8606	2.3376	OPEN	6	\N	2025-10-25 17:18:29.831059+00
3e617778-9c74-459c-a2e5-94707d6f8c63	Stade de France	PRIVATE	Espace VIP du Stade de France	93216 Saint-Denis, France	48.9244	2.3601	OPEN	10	\N	2025-10-25 17:18:29.831059+00
a49ca7a6-8f46-40c0-b1e4-0182496635ee	Mont Saint-Michel	BUSINESS	Hôtel-restaurant au Mont Saint-Michel	50170 Le Mont-Saint-Michel, France	48.6361	-1.5115	OPEN	4	\N	2025-10-25 17:18:29.831059+00
d0682846-a82c-49b3-8913-0afab9c1fefe	Dune du Pilat	BUSINESS	Point de location de vélos et buvette	33115 Pyla-sur-Mer, France	44.5896	-1.213	OPEN	3	\N	2025-10-25 17:18:29.831059+00
540c49ad-1de1-460a-bd79-47646cfa2f03	Château de Versailles	PRIVATE	Résidence privée à proximité du château	Place d’Armes, 78000 Versailles	48.8049	2.1204	CLOSED	2	\N	2025-10-25 17:18:29.831059+00
5ef71cc6-5be9-4455-9773-00b69f5524cf	Promenade des Anglais	BUSINESS	Bar lounge en bord de mer	Promenade des Anglais, Nice	43.6954	7.265	OPEN	6	\N	2025-10-25 17:18:29.831059+00
48d145a0-17fa-4fdb-87f6-47c53a4c2a21	Basilique Notre-Dame de la Garde	BUSINESS	Boutique de souvenirs	Rue Fort du Sanctuaire, 13281 Marseille	43.2841	5.3718	OPEN	4	\N	2025-10-25 17:18:29.831059+00
8f466aac-b475-426d-81fd-d81b1d1e1fd6	Place du Capitole	BUSINESS	Café historique au cœur de Toulouse	Place du Capitole, 31000 Toulouse	43.6043	1.4437	OPEN	5	\N	2025-10-25 17:18:29.831059+00
b67f6fb9-cd2d-4508-bfec-45315f23b9b4	Cathédrale Notre-Dame de Strasbourg	PRIVATE	Appartement touristique face à la cathédrale	Place de la Cathédrale, 67000 Strasbourg	48.5816	7.7507	OPEN	2	\N	2025-10-25 17:18:29.831059+00
9fefea3b-d21c-4c52-8331-bd76dc7b1a0d	Mont Blanc	PRIVATE	Chalet de montagne proche du Mont Blanc	74400 Chamonix-Mont-Blanc	45.8326	6.8652	CLOSED	1	\N	2025-10-25 17:18:29.831059+00
3261f9f4-b4bb-4120-9e8c-25c9e58dd18d	Pont du Gard	BUSINESS	Aire de repos et boutique artisanale	400 Route du Pont du Gard, 30210 Vers-Pont-du-Gard	43.9475	4.535	OPEN	3	\N	2025-10-25 17:18:29.831059+00
c31e7c6d-a6d3-4ad6-b43e-1c6687dba5dc	Saint-Tropez Port	BUSINESS	Boutique nautique sur le port	Quai Suffren, 83990 Saint-Tropez	43.2675	6.6403	OPEN	5	\N	2025-10-25 17:18:29.831059+00
ac6639b9-1ca2-4903-9b35-0f29337d8c0c	Colmar Centre	BUSINESS	Café typique dans la Petite Venise de Colmar	Rue des Tanneurs, 68000 Colmar	48.079	7.3585	OPEN	4	\N	2025-10-25 17:18:29.831059+00
bb9f9d6f-90bb-4c33-97c6-a004fec5126f	Gorges du Verdon	PRIVATE	Gîte rural avec vue sur les Gorges du Verdon	04120 Castellane, France	43.7372	6.3633	OPEN	2	\N	2025-10-25 17:18:29.831059+00
e69e3558-2c90-4d37-8300-09e7d6c35142	Lac d’Annecy	BUSINESS	Location de paddle et café au bord du lac	74000 Annecy, France	45.8992	6.1286	OPEN	4	\N	2025-10-25 17:18:29.831059+00
d518bb07-d7df-408e-82a8-31f1b5f8e008	Parc National des Écrins	PRIVATE	Refuge de montagne dans les Alpes	05200 Les Orres, France	44.8739	6.4076	OPEN	1	\N	2025-10-25 17:18:29.831059+00
1bf2197f-f124-4bfc-847c-ba354a14cd0d	Île de Ré	BUSINESS	Hôtel de charme en bord de mer	Le Bois-Plage-en-Ré, 17580, France	46.1806	-1.3954	OPEN	3	\N	2025-10-25 17:18:29.831059+00
87e1a532-f777-4f49-aad9-b585e8b26e6d	Puy de Dôme	PRIVATE	Maison d’hôtes avec vue sur le volcan	63130 Royat, France	45.772	2.9644	OPEN	2	\N	2025-10-25 17:18:29.831059+00
2c80818d-d7f7-4789-99a6-d6e925b77eed	Lac Léman	BUSINESS	Restaurant panoramique au bord du lac Léman	74500 Évian-les-Bains, France	46.4011	6.5899	OPEN	5	\N	2025-10-25 17:18:29.831059+00
16c18bb2-8a7b-4758-a908-54d9a7e22e95	Camargue	PRIVATE	Ferme équestre en pleine Camargue	13460 Saintes-Maries-de-la-Mer, France	43.4516	4.4298	OPEN	3	\N	2025-10-25 17:18:29.831059+00
3c00e7df-bf46-488c-82ff-a7f4dbf6e9df	Parc du Marquenterre	BUSINESS	Observatoire ornithologique et café bio	80120 Saint-Quentin-en-Tourmont, France	50.2371	1.6164	OPEN	2	\N	2025-10-25 17:18:29.831059+00
cee6fde0-3652-4e28-9ab6-52e67e7e74ed	Vignoble de Saint-Émilion	PRIVATE	Château viticole familial	33330 Saint-Émilion, France	44.8939	-0.1555	OPEN	4	\N	2025-10-25 17:18:29.831059+00
de804f76-beee-4a1f-8bdb-4532b566807e	Forêt de Brocéliande	PRIVATE	Maison forestière inspirée des légendes arthuriennes	35380 Paimpont, France	48.0172	-2.1723	CLOSED	1	\N	2025-10-25 17:18:29.831059+00
\.
--
-- Data for Name: opening_hours; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.opening_hours (id, destination_id, weekday, open_time, close_time, is_closed, created_at) FROM stdin;
4f8fd9dc-c28c-4a5e-83c7-250afd452baf	f1840ea5-f322-423f-8daf-46550238b1dc	MONDAY	08:00:00	18:00:00	f	2025-10-25 13:10:54.905277+00
1b3404c8-63e8-4471-9f22-17aa614d1253	7a445e92-44b2-4331-82c2-a390e359853e	MONDAY	08:00:00	18:00:00	f	2025-10-25 13:10:54.905277+00
b7ff67e8-3f3e-4677-8be7-9096441d0d4a	f1840ea5-f322-423f-8daf-46550238b1dc	TUESDAY	08:00:00	18:00:00	f	2025-10-25 13:10:54.905277+00
726784eb-672b-4bab-a11f-b097afee3d44	7a445e92-44b2-4331-82c2-a390e359853e	TUESDAY	08:00:00	18:00:00	f	2025-10-25 13:10:54.905277+00
\.
--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profiles (id, role_id, first_name, last_name, email, mobile, address, created_at) FROM stdin;
11111111-1111-1111-1111-111111111111	2b7b612b-ff15-49ba-869d-56d443430822	John	Doe	testclient@boxtobikers.com	060102030405	\N	2025-10-25 13:10:54.905277+00
\.
--
-- Data for Name: ratings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ratings (id, user_id, destination_id, rating, comment, created_at) FROM stdin;
bcfeb66e-69ff-4a61-8f2d-1358c0e1c235	11111111-1111-1111-1111-111111111111	f1840ea5-f322-423f-8daf-46550238b1dc	2	Nice location!	2025-10-25 13:10:54.905277+00
b196c686-0691-4105-b0a9-a4369f4d84db	11111111-1111-1111-1111-111111111111	7a445e92-44b2-4331-82c2-a390e359853e	3	Nice location!	2025-10-25 13:10:54.905277+00
fedf22ed-040b-4694-929b-d1a727fba578	11111111-1111-1111-1111-111111111111	942df1b1-c0c3-4db7-b08f-d705f8d21fd4	5	Nice location!	2025-10-25 13:10:54.905277+00
\.
--
-- Data for Name: rides; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rides (id, user_id, destination_id, status, created_at) FROM stdin;
9b9fbaae-6bde-4251-9ae7-5838c716a63f	11111111-1111-1111-1111-111111111111	f1840ea5-f322-423f-8daf-46550238b1dc	CONFIRMED	2025-10-25 13:10:54.905277+00
\.
--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.roles (id, name, created_at) FROM stdin;
fe0838e4-809d-4dd1-a978-7abd98375f56	ADMIN	2025-10-25 11:52:13.683932+00
2b7b612b-ff15-49ba-869d-56d443430822	VISITOR	2025-10-25 11:52:13.683932+00
4c5b416b-be4a-41d4-965b-f555d718ee26	CLIENT	2025-10-25 11:52:13.683932+00
\.
--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-10-24 13:25:42
20211116045059	2025-10-24 13:25:45
20211116050929	2025-10-24 13:25:47
20211116051442	2025-10-24 13:25:48
20211116212300	2025-10-24 13:25:51
20211116213355	2025-10-24 13:25:52
20211116213934	2025-10-24 13:25:54
20211116214523	2025-10-24 13:25:57
20211122062447	2025-10-24 13:25:59
20211124070109	2025-10-24 13:26:00
20211202204204	2025-10-24 13:26:02
20211202204605	2025-10-24 13:26:04
20211210212804	2025-10-24 13:26:10
20211228014915	2025-10-24 13:26:12
20220107221237	2025-10-24 13:26:14
20220228202821	2025-10-24 13:26:15
20220312004840	2025-10-24 13:26:17
20220603231003	2025-10-24 13:26:20
20220603232444	2025-10-24 13:26:22
20220615214548	2025-10-24 13:26:24
20220712093339	2025-10-24 13:26:26
20220908172859	2025-10-24 13:26:28
20220916233421	2025-10-24 13:26:30
20230119133233	2025-10-24 13:26:32
20230128025114	2025-10-24 13:26:34
20230128025212	2025-10-24 13:26:36
20230227211149	2025-10-24 13:26:38
20230228184745	2025-10-24 13:26:40
20230308225145	2025-10-24 13:26:41
20230328144023	2025-10-24 13:26:43
20231018144023	2025-10-24 13:26:45
20231204144023	2025-10-24 13:26:48
20231204144024	2025-10-24 13:26:50
20231204144025	2025-10-24 13:26:52
20240108234812	2025-10-24 13:26:54
20240109165339	2025-10-24 13:26:56
20240227174441	2025-10-24 13:26:59
20240311171622	2025-10-24 13:27:01
20240321100241	2025-10-24 13:27:05
20240401105812	2025-10-24 13:27:10
20240418121054	2025-10-24 13:27:13
20240523004032	2025-10-24 13:27:19
20240618124746	2025-10-24 13:27:21
20240801235015	2025-10-24 13:27:23
20240805133720	2025-10-24 13:27:25
20240827160934	2025-10-24 13:27:27
20240919163303	2025-10-24 13:27:29
20240919163305	2025-10-24 13:27:31
20241019105805	2025-10-24 13:27:33
20241030150047	2025-10-24 13:27:40
20241108114728	2025-10-24 13:27:42
20241121104152	2025-10-24 13:27:44
20241130184212	2025-10-24 13:27:46
20241220035512	2025-10-24 13:27:48
20241220123912	2025-10-24 13:27:50
20241224161212	2025-10-24 13:27:52
20250107150512	2025-10-24 13:27:54
20250110162412	2025-10-24 13:27:55
20250123174212	2025-10-24 13:27:57
20250128220012	2025-10-24 13:27:59
20250506224012	2025-10-24 13:28:00
20250523164012	2025-10-24 13:28:02
20250714121412	2025-10-24 13:28:04
20250905041441	2025-10-24 13:28:06
\.
--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.
--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.
--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (id, type, format, created_at, updated_at) FROM stdin;
\.
--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-10-24 13:25:46.984627
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-10-24 13:25:46.992819
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-10-24 13:25:47.001813
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-10-24 13:25:47.023234
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-10-24 13:25:47.088567
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-10-24 13:25:47.095726
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-10-24 13:25:47.104097
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-10-24 13:25:47.112065
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-10-24 13:25:47.119476
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-10-24 13:25:47.126943
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-10-24 13:25:47.135379
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-10-24 13:25:47.142991
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-10-24 13:25:47.151402
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-10-24 13:25:47.158425
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-10-24 13:25:47.166573
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-10-24 13:25:47.199195
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-10-24 13:25:47.206482
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-10-24 13:25:47.21406
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-10-24 13:25:47.223163
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-10-24 13:25:47.232317
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-10-24 13:25:47.239897
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-10-24 13:25:47.249571
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-10-24 13:25:47.269274
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-10-24 13:25:47.286492
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-10-24 13:25:47.294344
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-10-24 13:25:47.302365
26	objects-prefixes	ef3f7871121cdc47a65308e6702519e853422ae2	2025-10-24 13:25:47.310418
27	search-v2	33b8f2a7ae53105f028e13e9fcda9dc4f356b4a2	2025-10-24 13:25:47.327337
28	object-bucket-name-sorting	ba85ec41b62c6a30a3f136788227ee47f311c436	2025-10-24 13:25:47.507403
29	create-prefixes	a7b1a22c0dc3ab630e3055bfec7ce7d2045c5b7b	2025-10-24 13:25:47.514694
30	update-object-levels	6c6f6cc9430d570f26284a24cf7b210599032db7	2025-10-24 13:25:47.523711
31	objects-level-index	33f1fef7ec7fea08bb892222f4f0f5d79bab5eb8	2025-10-24 13:25:47.532059
32	backward-compatible-index-on-objects	2d51eeb437a96868b36fcdfb1ddefdf13bef1647	2025-10-24 13:25:47.541321
33	backward-compatible-index-on-prefixes	fe473390e1b8c407434c0e470655945b110507bf	2025-10-24 13:25:47.655996
34	optimize-search-function-v1	82b0e469a00e8ebce495e29bfa70a0797f7ebd2c	2025-10-24 13:25:47.658592
35	add-insert-trigger-prefixes	63bb9fd05deb3dc5e9fa66c83e82b152f0caf589	2025-10-24 13:25:47.667241
36	optimise-existing-functions	81cf92eb0c36612865a18016a38496c530443899	2025-10-24 13:25:47.674228
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-10-24 13:25:47.684892
38	iceberg-catalog-flag-on-buckets	19a8bd89d5dfa69af7f222a46c726b7c41e462c5	2025-10-24 13:25:47.692334
39	add-search-v2-sort-support	39cf7d1e6bf515f4b02e41237aba845a7b492853	2025-10-24 13:25:47.704961
40	fix-prefix-race-conditions-optimized	fd02297e1c67df25a9fc110bf8c8a9af7fb06d1f	2025-10-24 13:25:47.71305
41	add-object-level-update-trigger	44c22478bf01744b2129efc480cd2edc9a7d60e9	2025-10-24 13:25:47.726017
42	rollback-prefix-triggers	f2ab4f526ab7f979541082992593938c05ee4b47	2025-10-24 13:25:47.734363
43	fix-object-level	ab837ad8f1c7d00cc0b7310e989a23388ff29fc6	2025-10-24 13:25:47.742691
\.
--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, level) FROM stdin;
\.
--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.prefixes (bucket_id, name, created_at, updated_at) FROM stdin;
\.
--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.
--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.
--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
20241025000000	{"-- boxtobikers_schema.sql\n-- Supabase-compatible SQL schema for the Boxtobikers project\n-- Includes roles, profiles, destinations, rides, ratings, RLS policies, triggers, and views\n-- Does NOT recreate auth.users (managed by Supabase Auth)\n\n-- =============================================\n-- =============== TABLES =======================\n-- =============================================\n\ncreate table if not exists public.roles (\n  id uuid primary key default gen_random_uuid(),\n  name text unique not null check (name in ('ADMIN', 'VISITOR', 'CLIENT')),\n  created_at timestamptz default now()\n)","create table if not exists public.profiles (\n  id uuid primary key references auth.users(id) on delete cascade,\n  role_id uuid references public.roles(id),\n  first_name text not null,\n  last_name text not null,\n  email text,\n  mobile text,\n  address text,\n  created_at timestamptz default now()\n)","create table if not exists public.destinations (\n  id uuid primary key default gen_random_uuid(),\n  name text not null,\n  type text not null check (type in ('BUSINESS', 'PRIVATE')),\n  description text,\n  address text,\n  latitude double precision not null,\n  longitude double precision not null,\n  status text not null check (status in ('OPEN', 'CLOSED', 'PAUSED')) default 'OPEN',\n  locker_count integer default 0 check (locker_count >= 0),\n  image_url text,\n  created_at timestamptz default now()\n)","create table if not exists public.opening_hours (\n  id uuid primary key default gen_random_uuid(),\n  destination_id uuid not null references public.destinations(id) on delete cascade,\n  weekday text not null check (weekday in ('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY')),\n  open_time time not null,\n  close_time time not null,\n  is_closed boolean default false,\n  created_at timestamptz default now()\n)","create table if not exists public.rides (\n  id uuid primary key default gen_random_uuid(),\n  user_id uuid not null references public.profiles(id) on delete cascade,\n  destination_id uuid not null references public.destinations(id) on delete cascade,\n  pickup_address text not null,\n  destination_address text,\n  status text default 'PENDING' check (status in ('PENDING','CONFIRMED','CANCELLED','COMPLETED')),\n  created_at timestamptz default now()\n)","create table if not exists public.ratings (\n  id uuid primary key default gen_random_uuid(),\n  user_id uuid not null references public.profiles(id) on delete cascade,\n  destination_id uuid not null references public.destinations(id) on delete cascade,\n  rating integer not null check (rating between 1 and 5),\n  comment text,\n  created_at timestamptz default now(),\n  unique (user_id, destination_id)\n)","-- =============================================\n-- =============== FUNCTIONS ===================\n-- =============================================\n\ncreate or replace function public.handle_new_user()\nreturns trigger as $$\nbegin\n  insert into public.profiles (id, role_id, first_name, last_name, email)\n  values (\n    new.id,\n    (select id from public.roles where name = 'VISITOR' limit 1),\n    '',\n    '',\n    new.email\n  );\n  return new;\nend;\n$$ language plpgsql security definer","-- =============================================\n-- =============== TRIGGERS ====================\n-- =============================================\n\ndrop trigger if exists on_auth_user_created on auth.users","create trigger on_auth_user_created\nafter insert on auth.users\nfor each row execute procedure public.handle_new_user()","-- =============================================\n-- =============== RLS POLICIES ================\n-- =============================================\n\nalter table public.roles enable row level security","alter table public.profiles enable row level security","alter table public.destinations enable row level security","alter table public.opening_hours enable row level security","alter table public.rides enable row level security","alter table public.ratings enable row level security","-- Roles table\ndrop policy if exists \\"Admins can manage roles\\" on public.roles","create policy \\"Admins can manage roles\\"\non public.roles for all\nusing (exists (\n  select 1 from public.profiles p\n  join public.roles r on r.id = p.role_id\n  where p.id = auth.uid() and r.name = 'ADMIN'\n))","-- Profiles table\ndrop policy if exists \\"Users can view and update their own profile\\" on public.profiles","create policy \\"Users can view and update their own profile\\"\non public.profiles for all\nusing (auth.uid() = id)","-- Destinations table\ndrop policy if exists \\"Everyone can read destinations\\" on public.destinations","create policy \\"Everyone can read destinations\\"\non public.destinations for select using (true)","drop policy if exists \\"Admins can manage destinations\\" on public.destinations","create policy \\"Admins can manage destinations\\"\non public.destinations for all\nusing (exists (\n  select 1 from public.profiles p\n  join public.roles r on r.id = p.role_id\n  where p.id = auth.uid() and r.name = 'ADMIN'\n))","-- Opening hours table\ndrop policy if exists \\"Everyone can read opening hours\\" on public.opening_hours","create policy \\"Everyone can read opening hours\\"\non public.opening_hours for select using (true)","drop policy if exists \\"Admins can manage opening hours\\" on public.opening_hours","create policy \\"Admins can manage opening hours\\"\non public.opening_hours for all\nusing (exists (\n  select 1 from public.profiles p\n  join public.roles r on r.id = p.role_id\n  where p.id = auth.uid() and r.name = 'ADMIN'\n))","-- Rides table\ndrop policy if exists \\"Users can manage their own rides\\" on public.rides","create policy \\"Users can manage their own rides\\"\non public.rides for all\nusing (auth.uid() = user_id)","-- Ratings table\ndrop policy if exists \\"Everyone can read ratings\\" on public.ratings","create policy \\"Everyone can read ratings\\"\non public.ratings for select using (true)","drop policy if exists \\"Users can manage their own ratings\\" on public.ratings","create policy \\"Users can manage their own ratings\\"\non public.ratings for all\nusing (auth.uid() = user_id)","-- =============================================\n-- =============== VIEWS =======================\n-- =============================================\n\ncreate or replace view public.destinations_ratings_avg as\nselect\n  d.id as destination_id,\n  d.name,\n  round(avg(r.rating), 2) as avg_rating,\n  count(r.id) as total_ratings\nfrom public.destinations d\nleft join public.ratings r on r.destination_id = d.id\ngroup by d.id","-- =============================================\n-- =============== INITIAL DATA ================\n-- =============================================\n\ninsert into public.roles (name) values ('ADMIN'), ('VISITOR'), ('CLIENT')\non conflict (name) do nothing"}	init_schema
\.
--
-- Data for Name: seed_files; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.seed_files (path, hash) FROM stdin;
\.
--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.
--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);
--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);
--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);
--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);
--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);
--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);
--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);
--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);
--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);
--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);
--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);
--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);
--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);
--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);
--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);
--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);
--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);
--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);
--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);
--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);
--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);
--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);
--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);
--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);
--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);
--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);
--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);
--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);
--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
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
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--
ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);
--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--
ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);
--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--
ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);
--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);
--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);
--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);
--
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);
--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);
--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);
--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--
ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
--
-- Name: seed_files seed_files_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--
ALTER TABLE ONLY supabase_migrations.seed_files
    ADD CONSTRAINT seed_files_pkey PRIMARY KEY (path);
--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);
--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);
--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);
--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);
--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);
--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);
--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);
--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';
--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);
--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);
--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);
--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);
--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);
--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);
--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);
--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);
--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);
--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);
--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);
--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);
--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);
--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);
--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);
--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);
--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);
--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);
--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);
--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);
--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);
--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);
--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);
--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);
--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);
--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);
--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);
--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);
--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));
--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);
--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));
--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);
--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);
--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);
--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--
CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);
--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--
COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';
--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));
--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);
--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--
CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);
--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--
CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);
--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--
CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));
--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: -
--
CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);
--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--
CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);
--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--
CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);
--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--
CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);
--
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: -
--
CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);
--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--
CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");
--
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: -
--
CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);
--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: -
--
CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);
--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--
CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);
--
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: -
--
CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");
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
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: -
--
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--
CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();
--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--
CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();
--
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: -
--
CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();
--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--
CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();
--
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--
CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();
--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--
CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();
--
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--
CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();
--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--
CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();
--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;
--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;
--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;
--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;
--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;
--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;
--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;
--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;
--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;
--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--
ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;
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
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);
--
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);
--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);
--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);
--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--
ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;
--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--
ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;--
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
CREATE POLICY "Users can manage their own ratings" ON public.ratings USING ((auth.uid() = user_id));
--
-- Name: rides Users can manage their own rides; Type: POLICY; Schema: public; Owner: -
--
CREATE POLICY "Users can manage their own rides" ON public.rides USING ((auth.uid() = user_id));
--
-- Name: profiles Users can view and update their own profile; Type: POLICY; Schema: public; Owner: -
--
CREATE POLICY "Users can view and update their own profile" ON public.profiles USING ((auth.uid() = id));
--
-- Name: destinations; Type: ROW SECURITY; Schema: public; Owner: -
--
ALTER TABLE public.destinations ENABLE ROW LEVEL SECURITY;--
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
ALTER TABLE public.opening_hours ENABLE ROW LEVEL SECURITY;--
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
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;--
-- Name: ratings; Type: ROW SECURITY; Schema: public; Owner: -
--
ALTER TABLE public.ratings ENABLE ROW LEVEL SECURITY;--
-- Name: rides; Type: ROW SECURITY; Schema: public; Owner: -
--
ALTER TABLE public.rides ENABLE ROW LEVEL SECURITY;--
-- Name: roles; Type: ROW SECURITY; Schema: public; Owner: -
--
ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;--
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
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--
ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--
ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--
ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--
ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;--
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: -
--
ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--
ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--
ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--
CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');
--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--
CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();
--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--
CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();
--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--
CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();
--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--
CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();
--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--
CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();
--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--
CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();
--
-- PostgreSQL database dump complete
--

\unrestrict EO7R1nP8kkGSPrClWZbL4XlnlLfBUPQevRgfZtxIxCMJ8HjJA3Go5hyj51vghEi

