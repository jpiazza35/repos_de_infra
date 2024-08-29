alter table raw_data_validation
alter column file_log_key type int USING file_log_key::integer,
alter column file_log_key set not null;