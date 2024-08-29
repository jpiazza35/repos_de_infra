BEGIN;

-- Project tables

CREATE TABLE IF NOT EXISTS public.project_list
(
    project_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    org_key integer NOT NULL,
    project_name varchar(100) COLLATE pg_catalog."default" NOT NULL,
    survey_source_group_key integer,
    project_status_key integer,
    project_status_modified_utc_datetime timestamp without time zone NOT NULL,
    project_created_utc_datetime timestamp without time zone NOT NULL,
    emulated_by varchar(100) COLLATE pg_catalog."default",
    modified_username varchar(100) COLLATE pg_catalog."default",
    modified_utc_datetime timestamp without time zone,
    CONSTRAINT project_list_pkey PRIMARY KEY (project_id)
);

CREATE TABLE IF NOT EXISTS public.project_version
(
    project_version_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    project_id integer NOT NULL,
    project_version_label varchar(100) COLLATE pg_catalog."default",
    project_version_datetime timestamp without time zone NOT NULL,
    project_version_status_key integer,
    project_version_status_notes varchar(1000),
    file_log_key integer,
    aggregation_methodology_key integer,
    emulated_by varchar(100) COLLATE pg_catalog."default",
    modified_username varchar(100) COLLATE pg_catalog."default" NOT NULL,
    modified_utc_datetime timestamp without time zone NOT NULL,
    main_settings_json json,
    CONSTRAINT project_version_pkey PRIMARY KEY (project_version_id)
);

CREATE TABLE IF NOT EXISTS public.status_list
(
    status_key integer NOT NULL,
    status_name varchar(100) COLLATE pg_catalog."default",
    status_description varchar(200) COLLATE pg_catalog."default",
    status_type character varying(20) COLLATE pg_catalog."default",
    display_status boolean,
    CONSTRAINT status_list_pkey PRIMARY KEY (status_key)
);

CREATE TABLE IF NOT EXISTS public.project_benchmark_data_type
(
    project_benchmark_data_type_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    project_version_id integer NOT NULL,
    benchmark_data_type_key integer NOT NULL,
    aging_factor_override numeric(18, 2),
    override_comment varchar(1000) COLLATE pg_catalog."default",
    emulated_by varchar(100) COLLATE pg_catalog."default",
    modified_username varchar(100) COLLATE pg_catalog."default" NOT NULL,
    modified_utc_datetime timestamp without time zone NOT NULL,
    CONSTRAINT project_benchmark_data_type_pkey PRIMARY KEY (project_benchmark_data_type_id)
);

ALTER TABLE IF EXISTS public.project_list
    ADD FOREIGN KEY (project_status_key)
    REFERENCES public.status_list (status_key) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.project_version
    ADD FOREIGN KEY (project_id)
    REFERENCES public.project_list (project_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.project_version
    ADD FOREIGN KEY (project_version_status_key)
    REFERENCES public.status_list (status_key) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.project_benchmark_data_type
    ADD FOREIGN KEY (project_version_id)
    REFERENCES public.project_version (project_version_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;

-- Market Segment tables

CREATE TABLE IF NOT EXISTS public.market_segment_list
(
    market_segment_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    project_version_id integer NOT NULL,
    market_segment_name varchar(100) COLLATE pg_catalog."default" NOT NULL,
    market_segment_status_key integer,
    eri_adjustment_factor numeric(5, 2),
    eri_cut_name varchar(100) COLLATE pg_catalog."default",
    eri_city varchar(100) COLLATE pg_catalog."default",
    emulated_by varchar(100) COLLATE pg_catalog."default",
    modified_username varchar(100) COLLATE pg_catalog."default" NOT NULL,
    modified_utc_datetime timestamp without time zone NOT NULL,
    CONSTRAINT market_segment_list_pkey PRIMARY KEY (market_segment_id)
);

CREATE TABLE IF NOT EXISTS public.market_segment_blend
(
    market_segment_blend_key integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    parent_market_segment_cut_key integer,
    child_market_segment_cut_key integer,
    blend_weight numeric(5, 2),
    emulated_by varchar(100) COLLATE pg_catalog."default",
    modified_username varchar(100) COLLATE pg_catalog."default" NOT NULL,
    modified_utc_datetime timestamp without time zone NOT NULL,
    CONSTRAINT market_segment_blend_pkey PRIMARY KEY (market_segment_blend_key)
);

CREATE TABLE IF NOT EXISTS public.market_segment_cut
(
    market_segment_cut_key integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    market_segment_id integer NOT NULL,
    is_blend_flag boolean,
    industry_sector_key integer,
    organization_type_key integer,
    cut_group_key integer,
    cut_sub_group_key integer,
    market_pricing_cut_name varchar(100) COLLATE pg_catalog."default",
    display_on_report_flag boolean,
    report_order integer,
    emulated_by varchar(100) COLLATE pg_catalog."default",
    modified_username varchar(100) COLLATE pg_catalog."default" NOT NULL,
    modified_utc_datetime timestamp without time zone NOT NULL,
    CONSTRAINT market_segment_cut_pkey PRIMARY KEY (market_segment_cut_key),
    CONSTRAINT unique_market_pricing_cut UNIQUE (market_segment_id, industry_sector_key, organization_type_key, cut_group_key, cut_sub_group_key)
);

CREATE TABLE IF NOT EXISTS public.market_segment_cut_detail
(
    market_segment_cut_detail_key integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    market_segment_cut_key integer,
    publisher_key integer,
    survey_key integer,
    industry_sector_key integer,
    organization_type_key integer,
    cut_group_key integer,
    cut_sub_group_key integer,
    cut_key integer,
    is_selected boolean,
    emulated_by varchar(100) COLLATE pg_catalog."default",
    modified_username varchar(100) COLLATE pg_catalog."default" NOT NULL,
    modified_utc_datetime timestamp without time zone NOT NULL,
    CONSTRAINT market_segment_cut_detail_pkey PRIMARY KEY (market_segment_cut_detail_key)
);

ALTER TABLE IF EXISTS public.market_segment_blend
    ADD FOREIGN KEY (parent_market_segment_cut_key)
    REFERENCES public.market_segment_cut (market_segment_cut_key) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.market_segment_blend
    ADD FOREIGN KEY (child_market_segment_cut_key)
    REFERENCES public.market_segment_cut (market_segment_cut_key) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.market_segment_cut
    ADD FOREIGN KEY (market_segment_id)
    REFERENCES public.market_segment_list (market_segment_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.market_segment_cut_detail
    ADD FOREIGN KEY (market_segment_cut_key)
    REFERENCES public.market_segment_cut (market_segment_cut_key) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;

-- Combined average tables

CREATE TABLE IF NOT EXISTS market_segment_combined_averages
(
    combined_averages_key		INT GENERATED ALWAYS AS IDENTITY	PRIMARY KEY,
    market_segment_id			INT	REFERENCES market_segment_list(market_segment_id),
    combined_averages_name		VARCHAR(100) NOT NULL,
    combined_averages_order		INT NOT NULL,
    emulated_by					VARCHAR(100),
    modified_username			VARCHAR(100),
    modified_utc_datetime		TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT unq_combined_average_name UNIQUE (market_segment_id, combined_averages_name)
);

CREATE TABLE IF NOT EXISTS market_segment_combined_averages_cut
(
    combined_averages_cut_key	INT	GENERATED ALWAYS AS IDENTITY	PRIMARY KEY,
    combined_averages_key		INT	REFERENCES market_segment_combined_averages(combined_averages_key),
    market_pricing_cut_name		VARCHAR(100) NOT NULL,
    emulated_by					VARCHAR(100),
    modified_username			VARCHAR(100),
    modified_utc_datetime		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT unq_combined_average_name_and_cut UNIQUE (combined_averages_key, market_pricing_cut_name)
);

CREATE INDEX IF NOT EXISTS IDX_market_pricing_cut_name ON market_segment_combined_averages_cut(market_pricing_cut_name);

-- Market Pricing Sheet tables

CREATE TABLE IF NOT EXISTS public.market_pricing_sheet
(
    market_pricing_sheet_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    project_version_id integer,
    aggregation_method_key smallint,
    ces_org_id integer,
    job_code varchar(255),
    job_title varchar(255),
    market_pricing_job_code varchar(255),
    market_pricing_job_title varchar(255),
    job_group varchar(255),
    position_code varchar(255),
    market_segment_id integer,
    status_key integer,
    status_change_date timestamp without time zone,
    job_match_note varchar(1000),
    job_decription_selection varchar(100),
    is_job_description_overwritten boolean,
    market_pricing_job_description varchar(8000),
    market_pricing_sheet_name varchar(100),
    market_pricing_sheet_note varchar(1000),
    publisher_name varchar(255),
    publisher_key integer,
    emulated_by varchar(100),
    modified_username varchar(100),
    modified_utc_datetime timestamp without time zone,
    PRIMARY KEY (market_pricing_sheet_id)
);

CREATE TABLE IF NOT EXISTS public.market_pricing_sheet_job_match
(
    job_match_key integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    market_pricing_sheet_id integer,
    standard_job_code varchar(100),
    standard_job_title varchar(100),
    standard_job_description varchar(8000),
    blend_percent numeric(5, 2),
    blend_note varchar(1000),
    emulated_by varchar(100),
    modified_username varchar(100),
    modified_utc_datetime timestamp without time zone,
    PRIMARY KEY (job_match_key)
);

CREATE TABLE IF NOT EXISTS public.market_pricing_sheet_survey
(
    market_pricing_sheet_survey_key integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    market_pricing_sheet_id integer,
    market_segment_cut_detail_key integer,
    cut_external_key integer,
    raw_data_key bigint,
    exclude_in_calc boolean,
    adjustment_value numeric(5, 2),
    emulated_by varchar(100),
    modified_username varchar(100),
    modified_utc_datetime timestamp without time zone,
    PRIMARY KEY (market_pricing_sheet_survey_key)
);

CREATE TABLE IF NOT EXISTS public.market_pricing_sheet_adjustment_note
(
    market_pricing_sheet_adjustment_note_key integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    market_pricing_sheet_survey_key integer,
    adjustment_note_key integer,
    emulated_by varchar(100),
    modified_username varchar(100),
    modified_utc_datetime timestamp without time zone,
    PRIMARY KEY (market_pricing_sheet_adjustment_note_key)
);

CREATE TABLE IF NOT EXISTS public.adjustment_note_list
(
    adjustment_note_key integer NOT NULL  GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    adjustment_note_name varchar(100) NOT NULL,
    emulated_by varchar(100),
    modified_username varchar(100),
    modified_utc_datetime timestamp without time zone,
    CONSTRAINT adjustment_note_pkey PRIMARY KEY (adjustment_note_key),
    CONSTRAINT unq_adjustment_note_name UNIQUE (adjustment_note_name)
);

CREATE TABLE IF NOT EXISTS public.market_pricing_sheet_cut_external
(
    cut_external_key integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    project_version_id integer,
    market_pricing_sheet_id integer,
    standard_job_code varchar(100),
    standard_job_title varchar(100),
    external_publisher_name varchar(100),
    external_survey_name varchar(100),
    external_survey_year integer,
    external_survey_job_code varchar(100),
    external_survey_job_title varchar(100),
    external_industry_sector_name varchar(100),
    external_organization_type_name varchar(100),
    external_cut_group_name varchar(100),
    external_cut_sub_group_name varchar(100),
    external_market_pricing_cut_name varchar(100),
    external_survey_cut_name varchar(100),
    external_survey_effective_date timestamp without time zone,
    incumbent_count integer,
    emulated_by varchar(100) COLLATE pg_catalog."default",
    modified_username varchar(100) COLLATE pg_catalog."default" NOT NULL,
    modified_utc_datetime timestamp without time zone NOT NULL,
    CONSTRAINT cut_external_pkey PRIMARY KEY (cut_external_key)
);

CREATE TABLE IF NOT EXISTS public.market_pricing_sheet_cut_external_data
(
    cut_external_data_key integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    cut_external_key integer,
    benchmark_data_type_key integer,
    benchmark_data_type_value numeric(18, 6),
    percentile_number smallint,
    emulated_by varchar(100),
    modified_username varchar(100),
    modified_utc_datetime timestamp without time zone,
    PRIMARY KEY (cut_external_data_key)
);

CREATE TABLE IF NOT EXISTS public.market_pricing_sheet_file
(
    project_version_id integer NOT NULL,
    market_pricing_sheet_id integer,
    file_s3_url varchar(1024),
    file_s3_name varchar(300),
    emulated_by character varying(100) COLLATE pg_catalog."default",
    modified_username character varying(100) COLLATE pg_catalog."default" NOT NULL,
    modified_utc_datetime timestamp without time zone NOT NULL,
    CONSTRAINT market_pricing_sheet_file_pkey PRIMARY KEY (project_version_id, market_pricing_sheet_id)
);

-- TODO: Decision made based on the bug 81607. After MVP the solution will be in the following user story:
-- User Story 81659 - BE - Soft Delete for deleting records from original file that have been job matched/had a market pricing sheet that are not in the replacement file.

-- ALTER TABLE IF EXISTS public.market_pricing_sheet_job_match
--     ADD FOREIGN KEY (market_pricing_sheet_id)
--     REFERENCES public.market_pricing_sheet (market_pricing_sheet_id) MATCH SIMPLE
--     ON UPDATE NO ACTION
--     ON DELETE NO ACTION
--     NOT VALID;

-- ALTER TABLE IF EXISTS public.market_pricing_sheet_survey
--     ADD FOREIGN KEY (market_pricing_sheet_id)
--     REFERENCES public.market_pricing_sheet (market_pricing_sheet_id) MATCH SIMPLE
--     ON UPDATE NO ACTION
--     ON DELETE NO ACTION
--     NOT VALID;

ALTER TABLE IF EXISTS public.market_pricing_sheet_survey
    ADD FOREIGN KEY (market_segment_cut_detail_key)
    REFERENCES public.market_segment_cut_detail (market_segment_cut_detail_key) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.market_pricing_sheet_survey
    ADD FOREIGN KEY (cut_external_key)
    REFERENCES public.market_pricing_sheet_cut_external (cut_external_key) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.market_pricing_sheet_adjustment_note
    ADD FOREIGN KEY (adjustment_note_key)
    REFERENCES public.adjustment_note_list (adjustment_note_key) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.market_pricing_sheet_adjustment_note
    ADD FOREIGN KEY (market_pricing_sheet_survey_key)
    REFERENCES public.market_pricing_sheet_survey (market_pricing_sheet_survey_key) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.market_pricing_sheet_cut_external_data
    ADD FOREIGN KEY (cut_external_key)
    REFERENCES public.market_pricing_sheet_cut_external (cut_external_key) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;