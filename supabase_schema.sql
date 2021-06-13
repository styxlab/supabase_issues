--
-- PostgreSQL database dump
--

-- Dumped from database version 12.6 (Ubuntu 12.6-1.pgdg18.04+1)
-- Dumped by pg_dump version 12.7

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

ALTER TABLE ONLY public."Token" DROP CONSTRAINT "Token_userId_fkey";
ALTER TABLE ONLY public."Token" DROP CONSTRAINT "Token_projectId_fkey";
ALTER TABLE ONLY public."Session" DROP CONSTRAINT "Session_userId_fkey";
ALTER TABLE ONLY public."Project" DROP CONSTRAINT "Project_userId_fkey";
ALTER TABLE ONLY public."Post" DROP CONSTRAINT "Post_userId_fkey";
ALTER TABLE ONLY public."Post" DROP CONSTRAINT "Post_projectId_fkey";
ALTER TABLE ONLY public."Plan" DROP CONSTRAINT "Plan_userId_fkey";
ALTER TABLE ONLY public."Activity" DROP CONSTRAINT "Activity_userId_fkey";
ALTER TABLE ONLY public."Account" DROP CONSTRAINT "Account_userId_fkey";
DROP INDEX public."VerificationRequest.token_unique";
DROP INDEX public."VerificationRequest.identifier_token_unique";
DROP INDEX public."User.email_unique";
DROP INDEX public."Session.sessionToken_unique";
DROP INDEX public."Session.accessToken_unique";
DROP INDEX public."Project.name_suffix_unique";
DROP INDEX public."Post.slug_projectId_unique";
DROP INDEX public."Plan.userId_unique";
DROP INDEX public."Plan.stripeSubscriptionId_unique";
DROP INDEX public."Plan.stripeCustomerId_unique";
DROP INDEX public."Account.providerId_providerAccountId_unique";
ALTER TABLE ONLY public._prisma_migrations DROP CONSTRAINT _prisma_migrations_pkey;
ALTER TABLE ONLY public."VerificationRequest" DROP CONSTRAINT "VerificationRequest_pkey";
ALTER TABLE ONLY public."User" DROP CONSTRAINT "User_pkey";
ALTER TABLE ONLY public."Token" DROP CONSTRAINT "Token_pkey";
ALTER TABLE ONLY public."Session" DROP CONSTRAINT "Session_pkey";
ALTER TABLE ONLY public."Project" DROP CONSTRAINT "Project_pkey";
ALTER TABLE ONLY public."Post" DROP CONSTRAINT "Post_pkey";
ALTER TABLE ONLY public."Plan" DROP CONSTRAINT "Plan_pkey";
ALTER TABLE ONLY public."Editor" DROP CONSTRAINT "Editor_pkey";
ALTER TABLE ONLY public."Activity" DROP CONSTRAINT "Activity_pkey";
ALTER TABLE ONLY public."Account" DROP CONSTRAINT "Account_pkey";
ALTER TABLE public."Editor" ALTER COLUMN id DROP DEFAULT;
DROP TABLE public._prisma_migrations;
DROP TABLE public."VerificationRequest";
DROP TABLE public."User";
DROP TABLE public."Token";
DROP TABLE public."Session";
DROP TABLE public."Project";
DROP TABLE public."Post";
DROP TABLE public."Plan";
DROP SEQUENCE public."Editor_id_seq";
DROP TABLE public."Editor";
DROP TABLE public."Activity";
DROP TABLE public."Account";
DROP TYPE public."Role";
DROP TYPE public."Intro";
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: Intro; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."Intro" AS ENUM (
    'NONE',
    'USER',
    'PROJECT'
);


ALTER TYPE public."Intro" OWNER TO postgres;

--
-- Name: Role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."Role" AS ENUM (
    'USER',
    'ADMIN'
);


ALTER TYPE public."Role" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Account" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "providerType" text NOT NULL,
    "providerId" text NOT NULL,
    "providerAccountId" text NOT NULL,
    "refreshToken" text,
    "accessToken" text,
    "accessTokenExpires" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Account" OWNER TO postgres;

--
-- Name: Activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Activity" (
    id text NOT NULL,
    "userId" text NOT NULL,
    projects integer DEFAULT 1 NOT NULL,
    tokens integer DEFAULT 0 NOT NULL,
    posts integer DEFAULT 0 NOT NULL,
    published integer DEFAULT 0 NOT NULL,
    domains integer DEFAULT 0 NOT NULL,
    images integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Activity" OWNER TO postgres;

--
-- Name: Editor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Editor" (
    id integer NOT NULL,
    title text,
    content text,
    published boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Editor" OWNER TO postgres;

--
-- Name: Editor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Editor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Editor_id_seq" OWNER TO postgres;

--
-- Name: Editor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Editor_id_seq" OWNED BY public."Editor".id;


--
-- Name: Plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Plan" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "stripeCustomerId" text,
    "stripeSubscriptionId" text,
    "stripePriceId" text,
    "stripePeriodEnd" timestamp(3) without time zone
);


ALTER TABLE public."Plan" OWNER TO postgres;

--
-- Name: Post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Post" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "projectId" text NOT NULL,
    title text,
    editordoc jsonb,
    slug text,
    html text,
    excerpt text,
    tags text,
    authors text,
    "docCount" integer DEFAULT 0 NOT NULL,
    published boolean DEFAULT false NOT NULL,
    "publishedAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    new boolean DEFAULT true,
    intro public."Intro" DEFAULT 'NONE'::public."Intro" NOT NULL
);


ALTER TABLE public."Post" OWNER TO postgres;

--
-- Name: Project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Project" (
    id text NOT NULL,
    "userId" text NOT NULL,
    name text NOT NULL,
    suffix integer DEFAULT 0,
    title text DEFAULT 'Pure Theme'::text,
    description text DEFAULT 'Own your own words. Inspire your audience.'::text,
    lang text DEFAULT 'en'::text,
    domain text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "visitedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Project" OWNER TO postgres;

--
-- Name: Session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Session" (
    id text NOT NULL,
    "userId" text NOT NULL,
    expires timestamp(3) without time zone NOT NULL,
    "sessionToken" text NOT NULL,
    "accessToken" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Session" OWNER TO postgres;

--
-- Name: Token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Token" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "projectId" text NOT NULL,
    name text,
    bearer text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Token" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id text NOT NULL,
    name text,
    email text,
    "emailVerified" timestamp(3) without time zone,
    image text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    role public."Role" DEFAULT 'USER'::public."Role" NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: VerificationRequest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."VerificationRequest" (
    id text NOT NULL,
    identifier text NOT NULL,
    token text NOT NULL,
    expires timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."VerificationRequest" OWNER TO postgres;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: Editor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Editor" ALTER COLUMN id SET DEFAULT nextval('public."Editor_id_seq"'::regclass);


--
-- Name: Account Account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_pkey" PRIMARY KEY (id);


--
-- Name: Activity Activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Activity"
    ADD CONSTRAINT "Activity_pkey" PRIMARY KEY (id);


--
-- Name: Editor Editor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Editor"
    ADD CONSTRAINT "Editor_pkey" PRIMARY KEY (id);


--
-- Name: Plan Plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Plan"
    ADD CONSTRAINT "Plan_pkey" PRIMARY KEY (id);


--
-- Name: Post Post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_pkey" PRIMARY KEY (id, "userId");


--
-- Name: Project Project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_pkey" PRIMARY KEY (id);


--
-- Name: Session Session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Session"
    ADD CONSTRAINT "Session_pkey" PRIMARY KEY (id);


--
-- Name: Token Token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Token"
    ADD CONSTRAINT "Token_pkey" PRIMARY KEY (id, "userId");


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: VerificationRequest VerificationRequest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VerificationRequest"
    ADD CONSTRAINT "VerificationRequest_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Account.providerId_providerAccountId_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Account.providerId_providerAccountId_unique" ON public."Account" USING btree ("providerId", "providerAccountId");


--
-- Name: Plan.stripeCustomerId_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Plan.stripeCustomerId_unique" ON public."Plan" USING btree ("stripeCustomerId");


--
-- Name: Plan.stripeSubscriptionId_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Plan.stripeSubscriptionId_unique" ON public."Plan" USING btree ("stripeSubscriptionId");


--
-- Name: Plan.userId_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Plan.userId_unique" ON public."Plan" USING btree ("userId");


--
-- Name: Post.slug_projectId_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Post.slug_projectId_unique" ON public."Post" USING btree (slug, "projectId");


--
-- Name: Project.name_suffix_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Project.name_suffix_unique" ON public."Project" USING btree (name, suffix);


--
-- Name: Session.accessToken_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Session.accessToken_unique" ON public."Session" USING btree ("accessToken");


--
-- Name: Session.sessionToken_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Session.sessionToken_unique" ON public."Session" USING btree ("sessionToken");


--
-- Name: User.email_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User.email_unique" ON public."User" USING btree (email);


--
-- Name: VerificationRequest.identifier_token_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "VerificationRequest.identifier_token_unique" ON public."VerificationRequest" USING btree (identifier, token);


--
-- Name: VerificationRequest.token_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "VerificationRequest.token_unique" ON public."VerificationRequest" USING btree (token);


--
-- Name: Account Account_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Activity Activity_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Activity"
    ADD CONSTRAINT "Activity_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Plan Plan_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Plan"
    ADD CONSTRAINT "Plan_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Post Post_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Post Post_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Project Project_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Session Session_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Session"
    ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Token Token_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Token"
    ADD CONSTRAINT "Token_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Token Token_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Token"
    ADD CONSTRAINT "Token_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

