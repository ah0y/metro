--
-- PostgreSQL database dump
--

-- Dumped from database version 10.6
-- Dumped by pg_dump version 10.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authors (
    id bigint NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    location character varying(255),
    bio text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.authors_id_seq OWNED BY public.authors.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.books (
    isbn bigint NOT NULL,
    title character varying(255),
    year integer,
    summary text,
    pages integer,
    image character varying(255),
    author_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cards (
    id bigint NOT NULL,
    pin character varying(255),
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cards_id_seq OWNED BY public.cards.id;


--
-- Name: checkouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.checkouts (
    id bigint NOT NULL,
    renewals_remaining integer,
    checkout_date timestamp(0) without time zone,
    checkin_date timestamp(0) without time zone,
    due_date timestamp(0) without time zone,
    card_id bigint,
    copy_id bigint,
    isbn_id bigint,
    library_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: checkouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.checkouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: checkouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.checkouts_id_seq OWNED BY public.checkouts.id;


--
-- Name: copies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.copies (
    id bigint NOT NULL,
    "checked_out?" boolean DEFAULT false NOT NULL,
    library_id bigint,
    isbn_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: copies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.copies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: copies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.copies_id_seq OWNED BY public.copies.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    description text,
    images character varying(255),
    datetime timestamp(0) without time zone,
    room_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: libraries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.libraries (
    id bigint NOT NULL,
    address character varying(255),
    image character varying(255),
    hours character varying(255),
    branch character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: libraries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.libraries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: libraries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.libraries_id_seq OWNED BY public.libraries.id;


--
-- Name: reservations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reservations (
    id bigint NOT NULL,
    expiration_date timestamp(0) without time zone,
    transit_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reservations_id_seq OWNED BY public.reservations.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    id bigint NOT NULL,
    capacity integer,
    library_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: transit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transit (
    id bigint NOT NULL,
    estimated_arrival timestamp(0) without time zone,
    actual_arrival timestamp(0) without time zone,
    checkout_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: transit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transit_id_seq OWNED BY public.transit.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255),
    email character varying(255),
    password_hash character varying(255),
    reset_password_token character varying(255),
    reset_password_sent_at timestamp(0) without time zone,
    failed_attempts integer DEFAULT 0,
    locked_at timestamp(0) without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp(0) without time zone,
    last_sign_in_at timestamp(0) without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    unlock_token character varying(255),
    fines double precision,
    "is_librarian?" boolean DEFAULT false,
    num_books_out integer,
    library_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: waitlist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.waitlist (
    id bigint NOT NULL,
    "position" integer,
    copy_id bigint,
    checkout_id bigint,
    isbn_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: waitlist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.waitlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: waitlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.waitlist_id_seq OWNED BY public.waitlist.id;


--
-- Name: authors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authors ALTER COLUMN id SET DEFAULT nextval('public.authors_id_seq'::regclass);


--
-- Name: cards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cards ALTER COLUMN id SET DEFAULT nextval('public.cards_id_seq'::regclass);


--
-- Name: checkouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checkouts ALTER COLUMN id SET DEFAULT nextval('public.checkouts_id_seq'::regclass);


--
-- Name: copies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.copies ALTER COLUMN id SET DEFAULT nextval('public.copies_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: libraries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.libraries ALTER COLUMN id SET DEFAULT nextval('public.libraries_id_seq'::regclass);


--
-- Name: reservations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations ALTER COLUMN id SET DEFAULT nextval('public.reservations_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: transit id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transit ALTER COLUMN id SET DEFAULT nextval('public.transit_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: waitlist id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist ALTER COLUMN id SET DEFAULT nextval('public.waitlist_id_seq'::regclass);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (isbn);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: checkouts checkouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_pkey PRIMARY KEY (id);


--
-- Name: copies copies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.copies
    ADD CONSTRAINT copies_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: libraries libraries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.libraries
    ADD CONSTRAINT libraries_pkey PRIMARY KEY (id);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: transit transit_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transit
    ADD CONSTRAINT transit_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: waitlist waitlist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist
    ADD CONSTRAINT waitlist_pkey PRIMARY KEY (id);


--
-- Name: books_author_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX books_author_id_index ON public.books USING btree (author_id);


--
-- Name: cards_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cards_user_id_index ON public.cards USING btree (user_id);


--
-- Name: checkouts_card_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX checkouts_card_id_index ON public.checkouts USING btree (card_id);


--
-- Name: checkouts_copy_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX checkouts_copy_id_index ON public.checkouts USING btree (copy_id);


--
-- Name: checkouts_isbn_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX checkouts_isbn_id_index ON public.checkouts USING btree (isbn_id);


--
-- Name: checkouts_library_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX checkouts_library_id_index ON public.checkouts USING btree (library_id);


--
-- Name: copies_isbn_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX copies_isbn_id_index ON public.copies USING btree (isbn_id);


--
-- Name: copies_library_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX copies_library_id_index ON public.copies USING btree (library_id);


--
-- Name: events_room_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX events_room_id_index ON public.events USING btree (room_id);


--
-- Name: reservations_transit_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reservations_transit_id_index ON public.reservations USING btree (transit_id);


--
-- Name: rooms_library_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rooms_library_id_index ON public.rooms USING btree (library_id);


--
-- Name: transit_checkout_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX transit_checkout_id_index ON public.transit USING btree (checkout_id);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- Name: users_library_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_library_id_index ON public.users USING btree (library_id);


--
-- Name: waitlist_checkout_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX waitlist_checkout_id_index ON public.waitlist USING btree (checkout_id);


--
-- Name: waitlist_copy_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX waitlist_copy_id_index ON public.waitlist USING btree (copy_id);


--
-- Name: waitlist_isbn_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX waitlist_isbn_id_index ON public.waitlist USING btree (isbn_id);


--
-- Name: books books_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.authors(id);


--
-- Name: cards cards_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: checkouts checkouts_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.cards(id);


--
-- Name: checkouts checkouts_copy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_copy_id_fkey FOREIGN KEY (copy_id) REFERENCES public.copies(id);


--
-- Name: checkouts checkouts_isbn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_isbn_id_fkey FOREIGN KEY (isbn_id) REFERENCES public.books(isbn);


--
-- Name: checkouts checkouts_library_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_library_id_fkey FOREIGN KEY (library_id) REFERENCES public.libraries(id);


--
-- Name: copies copies_isbn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.copies
    ADD CONSTRAINT copies_isbn_id_fkey FOREIGN KEY (isbn_id) REFERENCES public.books(isbn);


--
-- Name: copies copies_library_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.copies
    ADD CONSTRAINT copies_library_id_fkey FOREIGN KEY (library_id) REFERENCES public.libraries(id);


--
-- Name: events events_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: reservations reservations_transit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_transit_id_fkey FOREIGN KEY (transit_id) REFERENCES public.transit(id);


--
-- Name: rooms rooms_library_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_library_id_fkey FOREIGN KEY (library_id) REFERENCES public.libraries(id);


--
-- Name: transit transit_checkout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transit
    ADD CONSTRAINT transit_checkout_id_fkey FOREIGN KEY (checkout_id) REFERENCES public.checkouts(id);


--
-- Name: users users_library_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_library_id_fkey FOREIGN KEY (library_id) REFERENCES public.libraries(id);


--
-- Name: waitlist waitlist_checkout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist
    ADD CONSTRAINT waitlist_checkout_id_fkey FOREIGN KEY (checkout_id) REFERENCES public.checkouts(id);


--
-- Name: waitlist waitlist_copy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist
    ADD CONSTRAINT waitlist_copy_id_fkey FOREIGN KEY (copy_id) REFERENCES public.copies(id);


--
-- Name: waitlist waitlist_isbn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist
    ADD CONSTRAINT waitlist_isbn_id_fkey FOREIGN KEY (isbn_id) REFERENCES public.books(isbn);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20190316183930), (20190316183934), (20190316183940), (20190316183944), (20190316183949), (20190316183952), (20190316183955), (20190316183956), (20190316183959), (20190316184004), (20190316184007), (20190316184010);

