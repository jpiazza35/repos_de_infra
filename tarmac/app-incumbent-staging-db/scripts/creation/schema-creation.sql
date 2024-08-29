BEGIN;


CREATE TABLE IF NOT EXISTS public.file_log_detail
(
    file_log_detail_key integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    file_log_key integer,
    message_text text COLLATE pg_catalog."default",
    created_utc_datetime timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT file_log_detail_pkey PRIMARY KEY (file_log_detail_key)
);

CREATE TABLE IF NOT EXISTS public.raw_data
(
    raw_data_key integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    file_log_key integer,
    file_line_number integer,
    ces_org_id character varying(255) COLLATE pg_catalog."default",
    ces_org_name character varying(255) COLLATE pg_catalog."default",
    job_code character varying(255) COLLATE pg_catalog."default",
    job_title character varying(255) COLLATE pg_catalog."default",
    incumbent_id character varying(255) COLLATE pg_catalog."default",
    incumbent_name character varying(255) COLLATE pg_catalog."default",
    fte_value character varying(255) COLLATE pg_catalog."default",
    client_job_group character varying(255) COLLATE pg_catalog."default",
    location_description character varying(255) COLLATE pg_catalog."default",
    job_family character varying(255) COLLATE pg_catalog."default",
    pay_grade character varying(255) COLLATE pg_catalog."default",
    pay_type character varying(255) COLLATE pg_catalog."default",
    position_code character varying(255) COLLATE pg_catalog."default",
    position_code_description character varying(255) COLLATE pg_catalog."default",
    job_level character varying(255) COLLATE pg_catalog."default",
    job_priority character varying(255) COLLATE pg_catalog."default",
    department_id character varying(255) COLLATE pg_catalog."default",
    department_name character varying(255) COLLATE pg_catalog."default",
    supervisor_id character varying(255) COLLATE pg_catalog."default",
    supervisor_name character varying(255) COLLATE pg_catalog."default",
    exemption_status character varying(255) COLLATE pg_catalog."default",
    union_affiliate character varying(255) COLLATE pg_catalog."default",
    work_status character varying(255) COLLATE pg_catalog."default",
    gender character varying(255) COLLATE pg_catalog."default",
    ethnicity character varying(255) COLLATE pg_catalog."default",
    date_of_original_licensure character varying(255) COLLATE pg_catalog."default",
    original_hire_date character varying(255) COLLATE pg_catalog."default",
    job_date character varying(255) COLLATE pg_catalog."default",
    credited_yoe character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_1 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_2 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_3 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_4 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_5 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_6 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_7 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_8 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_9 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_10 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_11 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_12 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_13 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_14 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_15 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_16 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_17 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_18 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_19 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_20 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_21 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_22 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_23 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_24 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_25 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_26 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_27 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_28 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_29 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_30 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_31 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_32 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_33 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_34 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_35 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_36 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_37 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_38 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_39 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_40 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_41 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_42 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_43 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_44 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_45 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_46 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_47 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_48 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_49 character varying(255) COLLATE pg_catalog."default",
    benchmark_data_type_50 character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT raw_data_pkey PRIMARY KEY (raw_data_key)
);

CREATE TABLE IF NOT EXISTS public.raw_data_validation
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    raw_data_key integer NOT NULL,
    file_log_key character varying(255) COLLATE pg_catalog."default",
    "column" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    value character varying(255) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT raw_data_validation_pkey PRIMARY KEY (id),
    CONSTRAINT raw_data_validation_raw_data_key_fkey FOREIGN KEY (raw_data_key)
        REFERENCES public.raw_data (raw_data_key) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS public.mapping
(
    category character varying(50) COLLATE pg_catalog."default" NOT NULL,
    internal_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    external_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT mapping_pkey PRIMARY KEY (category, internal_name)
);

END;