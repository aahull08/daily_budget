--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.22
-- Dumped by pg_dump version 9.6.22

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

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: date; Type: TABLE; Schema: public; Owner: ec2-user
--

CREATE TABLE public.date (
    id integer NOT NULL,
    day date NOT NULL,
    daily_budget numeric NOT NULL
);


ALTER TABLE public.date OWNER TO "ec2-user";

--
-- Name: date_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE public.date_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.date_id_seq OWNER TO "ec2-user";

--
-- Name: date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE public.date_id_seq OWNED BY public.date.id;


--
-- Name: expenses; Type: TABLE; Schema: public; Owner: ec2-user
--

CREATE TABLE public.expenses (
    id integer NOT NULL,
    cost numeric NOT NULL,
    date_id integer NOT NULL
);


ALTER TABLE public.expenses OWNER TO "ec2-user";

--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE public.expenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.expenses_id_seq OWNER TO "ec2-user";

--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE public.expenses_id_seq OWNED BY public.expenses.id;


--
-- Name: date id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.date ALTER COLUMN id SET DEFAULT nextval('public.date_id_seq'::regclass);


--
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.expenses ALTER COLUMN id SET DEFAULT nextval('public.expenses_id_seq'::regclass);


--
-- Name: date date_day_key; Type: CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.date
    ADD CONSTRAINT date_day_key UNIQUE (day);


--
-- Name: date date_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.date
    ADD CONSTRAINT date_pkey PRIMARY KEY (id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- Name: expenses expenses_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_date_id_fkey FOREIGN KEY (date_id) REFERENCES public.date(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

