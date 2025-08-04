--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 17.5

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: animal_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.animal_types (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    species character varying(255) NOT NULL,
    breed character varying(255),
    typical_weight_kg numeric(8,2),
    gestation_days integer,
    life_expectancy_years integer,
    description text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: animal_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.animal_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: animal_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.animal_types_id_seq OWNED BY public.animal_types.id;


--
-- Name: animals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.animals (
    id bigint NOT NULL,
    name character varying(255),
    tag_number character varying(255) NOT NULL,
    birth_date date,
    gender character varying(255) NOT NULL,
    weight_kg numeric(8,2),
    health_status character varying(255) DEFAULT 'healthy'::character varying,
    notes text,
    farm_id bigint NOT NULL,
    animal_type_id bigint NOT NULL,
    mother_id bigint,
    father_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: animals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.animals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: animals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.animals_id_seq OWNED BY public.animals.id;


--
-- Name: farms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.farms (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    location character varying(255),
    acreage numeric(10,2),
    established_date date,
    owner_name character varying(255),
    phone character varying(255),
    email character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: farms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.farms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: farms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.farms_id_seq OWNED BY public.farms.id;


--
-- Name: feed_inventory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feed_inventory (
    id bigint NOT NULL,
    farm_id bigint NOT NULL,
    feed_type_id bigint NOT NULL,
    quantity_kg numeric(10,2) NOT NULL,
    purchase_date date,
    expiry_date date,
    cost_per_kg numeric(8,2),
    supplier_batch_number character varying(255),
    storage_location character varying(255),
    notes text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: feed_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feed_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feed_inventory_id_seq OWNED BY public.feed_inventory.id;


--
-- Name: feed_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feed_types (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    brand character varying(255),
    feed_category character varying(255) NOT NULL,
    protein_percentage numeric(5,2),
    fat_percentage numeric(5,2),
    fiber_percentage numeric(5,2),
    calories_per_kg integer,
    cost_per_kg numeric(8,2),
    supplier character varying(255),
    description text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: feed_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feed_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feed_types_id_seq OWNED BY public.feed_types.id;


--
-- Name: feeding_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feeding_schedules (
    id bigint NOT NULL,
    animal_id bigint NOT NULL,
    feed_type_id bigint NOT NULL,
    quantity_kg numeric(8,2) NOT NULL,
    feeding_time time(0) without time zone NOT NULL,
    frequency_per_day integer DEFAULT 1,
    start_date date NOT NULL,
    end_date date,
    notes text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: feeding_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feeding_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feeding_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feeding_schedules_id_seq OWNED BY public.feeding_schedules.id;


--
-- Name: health_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.health_records (
    id bigint NOT NULL,
    animal_id bigint NOT NULL,
    record_date date NOT NULL,
    record_type character varying(255) NOT NULL,
    description text NOT NULL,
    veterinarian character varying(255),
    treatment character varying(255),
    medication character varying(255),
    dosage character varying(255),
    cost numeric(8,2),
    follow_up_date date,
    notes text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: health_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.health_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: health_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.health_records_id_seq OWNED BY public.health_records.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: animal_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animal_types ALTER COLUMN id SET DEFAULT nextval('public.animal_types_id_seq'::regclass);


--
-- Name: animals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animals ALTER COLUMN id SET DEFAULT nextval('public.animals_id_seq'::regclass);


--
-- Name: farms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farms ALTER COLUMN id SET DEFAULT nextval('public.farms_id_seq'::regclass);


--
-- Name: feed_inventory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_inventory ALTER COLUMN id SET DEFAULT nextval('public.feed_inventory_id_seq'::regclass);


--
-- Name: feed_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_types ALTER COLUMN id SET DEFAULT nextval('public.feed_types_id_seq'::regclass);


--
-- Name: feeding_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeding_schedules ALTER COLUMN id SET DEFAULT nextval('public.feeding_schedules_id_seq'::regclass);


--
-- Name: health_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_records ALTER COLUMN id SET DEFAULT nextval('public.health_records_id_seq'::regclass);


--
-- Name: animal_types animal_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animal_types
    ADD CONSTRAINT animal_types_pkey PRIMARY KEY (id);


--
-- Name: animals animals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT animals_pkey PRIMARY KEY (id);


--
-- Name: farms farms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farms
    ADD CONSTRAINT farms_pkey PRIMARY KEY (id);


--
-- Name: feed_inventory feed_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_inventory
    ADD CONSTRAINT feed_inventory_pkey PRIMARY KEY (id);


--
-- Name: feed_types feed_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_types
    ADD CONSTRAINT feed_types_pkey PRIMARY KEY (id);


--
-- Name: feeding_schedules feeding_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeding_schedules
    ADD CONSTRAINT feeding_schedules_pkey PRIMARY KEY (id);


--
-- Name: health_records health_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_records
    ADD CONSTRAINT health_records_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: animal_types_species_breed_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX animal_types_species_breed_index ON public.animal_types USING btree (species, breed);


--
-- Name: animals_animal_type_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX animals_animal_type_id_index ON public.animals USING btree (animal_type_id);


--
-- Name: animals_birth_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX animals_birth_date_index ON public.animals USING btree (birth_date);


--
-- Name: animals_farm_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX animals_farm_id_index ON public.animals USING btree (farm_id);


--
-- Name: animals_farm_id_tag_number_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX animals_farm_id_tag_number_index ON public.animals USING btree (farm_id, tag_number);


--
-- Name: animals_health_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX animals_health_status_index ON public.animals USING btree (health_status);


--
-- Name: farms_location_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX farms_location_index ON public.farms USING btree (location);


--
-- Name: farms_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX farms_name_index ON public.farms USING btree (name);


--
-- Name: feed_inventory_expiry_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feed_inventory_expiry_date_index ON public.feed_inventory USING btree (expiry_date);


--
-- Name: feed_inventory_farm_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feed_inventory_farm_id_index ON public.feed_inventory USING btree (farm_id);


--
-- Name: feed_inventory_feed_type_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feed_inventory_feed_type_id_index ON public.feed_inventory USING btree (feed_type_id);


--
-- Name: feed_inventory_purchase_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feed_inventory_purchase_date_index ON public.feed_inventory USING btree (purchase_date);


--
-- Name: feed_types_feed_category_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feed_types_feed_category_index ON public.feed_types USING btree (feed_category);


--
-- Name: feed_types_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feed_types_name_index ON public.feed_types USING btree (name);


--
-- Name: feed_types_supplier_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feed_types_supplier_index ON public.feed_types USING btree (supplier);


--
-- Name: feeding_schedules_animal_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feeding_schedules_animal_id_index ON public.feeding_schedules USING btree (animal_id);


--
-- Name: feeding_schedules_feed_type_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feeding_schedules_feed_type_id_index ON public.feeding_schedules USING btree (feed_type_id);


--
-- Name: feeding_schedules_feeding_time_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feeding_schedules_feeding_time_index ON public.feeding_schedules USING btree (feeding_time);


--
-- Name: feeding_schedules_start_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX feeding_schedules_start_date_index ON public.feeding_schedules USING btree (start_date);


--
-- Name: health_records_animal_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX health_records_animal_id_index ON public.health_records USING btree (animal_id);


--
-- Name: health_records_follow_up_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX health_records_follow_up_date_index ON public.health_records USING btree (follow_up_date);


--
-- Name: health_records_record_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX health_records_record_date_index ON public.health_records USING btree (record_date);


--
-- Name: health_records_record_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX health_records_record_type_index ON public.health_records USING btree (record_type);


--
-- Name: animals animals_animal_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT animals_animal_type_id_fkey FOREIGN KEY (animal_type_id) REFERENCES public.animal_types(id) ON DELETE RESTRICT;


--
-- Name: animals animals_farm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT animals_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.farms(id) ON DELETE CASCADE;


--
-- Name: animals animals_father_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT animals_father_id_fkey FOREIGN KEY (father_id) REFERENCES public.animals(id) ON DELETE SET NULL;


--
-- Name: animals animals_mother_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT animals_mother_id_fkey FOREIGN KEY (mother_id) REFERENCES public.animals(id) ON DELETE SET NULL;


--
-- Name: feed_inventory feed_inventory_farm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_inventory
    ADD CONSTRAINT feed_inventory_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.farms(id) ON DELETE CASCADE;


--
-- Name: feed_inventory feed_inventory_feed_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_inventory
    ADD CONSTRAINT feed_inventory_feed_type_id_fkey FOREIGN KEY (feed_type_id) REFERENCES public.feed_types(id) ON DELETE RESTRICT;


--
-- Name: feeding_schedules feeding_schedules_animal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeding_schedules
    ADD CONSTRAINT feeding_schedules_animal_id_fkey FOREIGN KEY (animal_id) REFERENCES public.animals(id) ON DELETE CASCADE;


--
-- Name: feeding_schedules feeding_schedules_feed_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeding_schedules
    ADD CONSTRAINT feeding_schedules_feed_type_id_fkey FOREIGN KEY (feed_type_id) REFERENCES public.feed_types(id) ON DELETE RESTRICT;


--
-- Name: health_records health_records_animal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_records
    ADD CONSTRAINT health_records_animal_id_fkey FOREIGN KEY (animal_id) REFERENCES public.animals(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20240101000001);
INSERT INTO public."schema_migrations" (version) VALUES (20240101000002);
INSERT INTO public."schema_migrations" (version) VALUES (20240101000003);
INSERT INTO public."schema_migrations" (version) VALUES (20240101000004);
INSERT INTO public."schema_migrations" (version) VALUES (20240101000005);
INSERT INTO public."schema_migrations" (version) VALUES (20240101000006);
INSERT INTO public."schema_migrations" (version) VALUES (20240101000007);
