-- For the property modified_username a random GUID was generated

--*** project_list ***

INSERT INTO project_list ("org_key", "project_name", "survey_source_group_key", "project_status_key", "project_status_modified_utc_datetime", "project_created_utc_datetime", "emulated_by", "modified_username", "modified_utc_datetime")
VALUES (90, 'Project Valid File', 6, 1, '2023-04-21 13:41:58.07159', '2023-04-19 15:48:36.865256', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-21 13:41:58.07159');

INSERT INTO project_list ("org_key", "project_name", "survey_source_group_key", "project_status_key", "project_status_modified_utc_datetime", "project_created_utc_datetime", "emulated_by", "modified_username", "modified_utc_datetime")
VALUES (90, 'Project Valid With Warning File', 6, 1, '2023-04-21 13:41:58.07159', '2023-04-19 15:48:36.865256', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-21 13:41:58.07159');

INSERT INTO project_list ("org_key", "project_name", "survey_source_group_key", "project_status_key", "project_status_modified_utc_datetime", "project_created_utc_datetime", "emulated_by", "modified_username", "modified_utc_datetime")
VALUES (90, 'Project Valid File 2', 6, 1, '2023-04-21 13:41:58.07159', '2023-04-19 15:48:36.865256', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-21 13:41:58.07159');


--*** project_version ***

INSERT INTO public.project_version (project_id, project_version_label, project_version_datetime, project_version_status_key, project_version_status_notes, file_log_key, aggregation_methodology_key, emulated_by, modified_username, modified_utc_datetime) 
VALUES (1, '1', '2023-04-19 15:48:36.871104', 1, NULL, 1, 2, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-21 13:41:58.075446');

INSERT INTO public.project_version (project_id, project_version_label, project_version_datetime, project_version_status_key, project_version_status_notes, file_log_key, aggregation_methodology_key, emulated_by, modified_username, modified_utc_datetime) 
VALUES (2, '1', '2023-04-19 15:48:36.871104', 1, NULL, 1, 2, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-21 13:41:58.075446');

INSERT INTO public.project_version (project_id, project_version_label, project_version_datetime, project_version_status_key, project_version_status_notes, file_log_key, aggregation_methodology_key, emulated_by, modified_username, modified_utc_datetime, main_settings_json) 
VALUES (3, '1', '2023-04-19 15:48:36.871104', 1, NULL, 1, 1, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-21 13:41:58.075446', '{"Sections":{"ClientPayDetail":true,"ClientPosDetail":true,"JobMatchDetail":true,"MarketSegmentName":true,"OrgName":true,"ReportDate":true},"Columns":{"surveyCode":true,"surveyPublisherName":true,"surveyName":true,"surveyYear":true,"surveySpecialtyCode":true,"surveySpecialtyName":true,"adjustment":true,"adjustmentNotes":true,"industryName":true,"organizationTypeName":true,"cutGroupName":true,"cutSubGroupName":true,"cutKey":true,"providerCount":true},"AgeToDate":"2023-07-06T03:00:00Z","Benchmarks":[{"Id":84,"Title":"Target Annual Incentive","AgingFactor":0.0,"Percentiles":[25,50,75,90]},{"Id":79,"Title":"Annualized Pay Range Minimum","AgingFactor":0.0,"Percentiles":[50]},{"Id":44,"Title":"Pay Range Maximum","AgingFactor":0.0,"Percentiles":[50]},{"Id":29,"Title":"Base Pay Hourly Rate","AgingFactor":0.0,"Percentiles":[25,50,75,90]}]}');


--*** project_benchmark_data_type ***

INSERT INTO public.project_benchmark_data_type (project_version_id, benchmark_data_type_key, aging_factor_override, override_comment, emulated_by, modified_username, modified_utc_datetime) 
VALUES (1, 84, NULL, '', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-20 09:28:21.923575'),
       (1, 79, NULL, '', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-26 10:48:33.069035'),
       (1, 44, NULL, '', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-26 10:48:33.069035'),
       (1, 29, NULL, '', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-26 10:48:33.069035');
       
INSERT INTO public.project_benchmark_data_type (project_version_id, benchmark_data_type_key, aging_factor_override, override_comment, emulated_by, modified_username, modified_utc_datetime) 
VALUES (2, 84, NULL, '', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-20 09:28:21.923575'),
       (2, 79, NULL, '', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-26 10:48:33.069035');

INSERT INTO public.project_benchmark_data_type (project_version_id, benchmark_data_type_key, aging_factor_override, override_comment, emulated_by, modified_username, modified_utc_datetime) 
VALUES (3, 84, NULL, '', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-20 09:28:21.923575'),
       (3, 79, NULL, '', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-26 10:48:33.069035'),
       (3, 44, NULL, '', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-26 10:48:33.069035'),
       (3, 29, NULL, '', NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-26 10:48:33.069035');
       

       
--*** market_pricing_sheet ***

INSERT INTO public.market_pricing_sheet (project_version_id, aggregation_method_key, ces_org_id, job_code, job_title, job_group, position_code, market_segment_id, status_key, status_change_date, job_match_note, job_decription_selection, is_job_description_overwritten, market_pricing_job_description, market_pricing_sheet_name, market_pricing_sheet_note, emulated_by, modified_username, modified_utc_datetime, market_pricing_job_code, market_pricing_job_title, publisher_key)
VALUES (1, 2, 90, '2.52', 'Software Developer 2', 'Group1', '3.001', 1, 7, '2023-04-21 17:32:06.905696', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-21 17:13:37.886609', NULL, NULL, NULL),
       (1, 3, 10423, 'JC002', 'Software Developer 2', 'Group3', '4.5', NULL, 7, '2023-04-21 17:32:06.905696', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:56:47.009282', NULL, NULL, NULL),
       (1, 2, 90, '2.51', 'Software Developer 1', 'Group4', '', 1, 7, '2023-04-21 17:32:06.905696', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-21 17:32:06.905696', '2.61', 'Software Developer 1 - standard', NULL),
       (1, 3, 10423, 'JC002', 'Software Developer 2', 'Group2', '3.002', 1, 8, '2023-04-21 17:32:06.905696', 'Reviewed by Analyst', NULL, NULL, NULL, NULL, NULL, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:54:40.518924', '3.002', NULL, NULL),
       (1, 3, 10423, 'JC001', 'Software Developer 1', 'Group1', '3.001', NULL, 8, '2023-04-21 17:32:06.905696', 'Reviewed by Analyst', NULL, NULL, NULL, NULL, NULL, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:56:46.395062', '3.001', NULL, NULL),
       (3, 1, 90, '2.52', 'Software Developer 2', 'Group1', '3.001', 1, 7, '2023-04-21 17:32:06.905696', 'Reviewed by Analyst', NULL, NULL, 'Information Tecnhology', NULL, NULL, NULL,'e876479e-3131-4f69-aa27-59205195709e', '2023-04-21 17:13:37.886609', NULL, 'Software Developer 1 - standard', NULL),
       (3, 1, 10423, 'JC002', 'Software Developer 2', 'Group3', '4.5', NULL, 7, '2023-04-21 17:32:06.905696', NULL, NULL, NULL, NULL, NULL, NULL, NULL,'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:56:47.009282', NULL, NULL, NULL),
       (3, 2, 90, '2.51', 'Software Developer 1', 'Group4', '', 1, 7, '2023-04-21 17:32:06.905696', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-21 17:32:06.905696', '2.61', 'Software Developer 1 - standard', NULL),
       (3, 1, 10423, 'JC002', 'Software Developer 2', 'Group2', '3.002', 1, 8, '2023-04-21 17:32:06.905696', 'Reviewed by Analyst', NULL, NULL, NULL, NULL, NULL, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:54:40.518924', '3.002', NULL, NULL),
       (3, 1, 10423, 'JC001', 'Software Developer 1', 'Group1', '3.001', NULL, 8, '2023-04-21 17:32:06.905696', 'Reviewed by Analyst', NULL, NULL, NULL, NULL, NULL, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:56:46.395062', '3.001', NULL, NULL),
       (3, 1, 90, '2.52', 'Software Developer 2', 'Group1', '3.001', 1, 8, '2023-04-21 17:32:06.905696', 'Reviewed by Analyst', NULL, NULL, 'Information Tecnhology', NULL, NULL, NULL, 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:56:46.395062', '3030', 'Software Developer 1 - standard', 1),
	   (3, 1, 90, '3', NULL, 'Group2', '3.001', 2, 8, NULL, '', NULL, NULL , 'desc', NULL, NULL, NULL, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 17:25:23.902879', '1110', 'Family Medicine', NULL);

--*** market_pricing_sheet_job_match ***

INSERT INTO public.market_pricing_sheet_job_match(
    market_pricing_sheet_id, standard_job_code, standard_job_title, blend_percent, modified_username, modified_utc_datetime)
    VALUES (6, '3030', 'Certified Registered Nurse Anesthetist', 100, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-06-08 13:21:13.337739'),
(12, '1110', 'Family Medicine', 100.00, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 17:25:23.919338');

--*** market_segment_list ***

INSERT INTO public.market_segment_list(
    project_version_id, market_segment_name, market_segment_status_key, eri_adjustment_factor, eri_cut_name, eri_city, emulated_by, modified_username, modified_utc_datetime)
    VALUES (3, 'market segment test', 4, NULL, NULL, NULL, 'e876479e-3131-4f69-aa27-59205195709e', 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:56:46.395062'),
(3,'add',4,0.03,'ERI TEST',NULL,'e4f76c83-c292-4f8b-8b61-fedf4f3b6673','e4f76c83-c292-4f8b-8b61-fedf4f3b6673','2023-07-06 15:59:50.763298');

--*** market_segment_cut ***

INSERT INTO public.market_segment_cut(
    market_segment_id, is_blend_flag, industry_sector_key, organization_type_key, cut_group_key, cut_sub_group_key, market_pricing_cut_name, display_on_report_flag, report_order, emulated_by, modified_username, modified_utc_datetime)
    VALUES (1, false, NULL, 52, 3, NULL, 'cut test', true, 1, 'e876479e-3131-4f69-aa27-59205195709e', 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:56:46.395062'),
(2, false, NULL, 61, 1, NULL, NULL, true, 1, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 11, NULL, NULL, true, 2, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 17, NULL, NULL, true, 3, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 3, NULL, 'one', true, 4, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 15, 10, 'two', true, 5, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 14, 8, 'three', true, 6, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 10, NULL, NULL, true, 7, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 16, NULL, NULL, true, 8, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 13, 5, NULL, true, 9, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 9, 6, NULL, true, 10, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 14, 7, NULL, true, 11, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 2, NULL, NULL, true, 12, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, 1, 61, 3, NULL, NULL, true, 13, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 4, 1, NULL, true, 14, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 6, NULL, NULL, true, 15, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 5, NULL, NULL, true, 16, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 9, 5, NULL, true, 17, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 15, 9, NULL, true, 18, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 13, 6, NULL, true, 19, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 4, 3, NULL, true, 20, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 4, 2, NULL, true, 21, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 68, 18, NULL, NULL, true, 22, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 2, NULL, NULL, true, 23, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 4, 4, NULL, true, 24, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, NULL, 61, 2, NULL, NULL, true, 25, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, false, 11, 76, 3, NULL, NULL, true, 26, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.913848'),
(2, true, NULL, NULL, NULL, NULL, 'BLEND TEST', true, 27, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 16:00:12.619802');

--*** market_segment_cut_detail ***

INSERT INTO public.market_segment_cut_detail(
    market_segment_cut_key, publisher_key, survey_key, industry_sector_key, organization_type_key, cut_group_key, cut_sub_group_key, cut_key, is_selected, emulated_by, modified_username, modified_utc_datetime)
    VALUES (1, 1, 42, NULL, 52, 3, NULL, 128, true, 'e876479e-3131-4f69-aa27-59205195709e', 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:56:46.395062'),
(2, 2, 53, NULL, 61, 1, NULL, 223, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 2, 53, NULL, 61, 1, NULL, 221, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 56, NULL, 61, 1, NULL, 221, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 56, NULL, 61, 1, NULL, 224, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 56, NULL, 61, 1, NULL, 222, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 54, NULL, 61, 1, NULL, 221, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 56, NULL, 61, 1, NULL, 223, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 51, NULL, 61, 1, NULL, 293, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 51, NULL, 61, 1, NULL, 295, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 54, NULL, 61, 1, NULL, 224, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 51, NULL, 61, 1, NULL, 294, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 54, NULL, 61, 1, NULL, 223, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 51, NULL, 61, 1, NULL, 224, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 54, NULL, 61, 1, NULL, 222, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 51, NULL, 61, 1, NULL, 225, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 51, NULL, 61, 1, NULL, 296, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 2, 53, NULL, 61, 1, NULL, 222, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 2, 53, NULL, 61, 1, NULL, 224, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 67, NULL, 68, 1, NULL, 421, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 66, NULL, 68, 1, NULL, 417, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 66, NULL, 68, 1, NULL, 422, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 67, NULL, 68, 1, NULL, 418, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 67, NULL, 68, 1, NULL, 417, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 68, NULL, 68, 1, NULL, 418, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 67, NULL, 68, 1, NULL, 420, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 68, NULL, 68, 1, NULL, 417, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 66, NULL, 68, 1, NULL, 421, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 52, NULL, 61, 1, NULL, 293, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 52, NULL, 61, 1, NULL, 294, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 66, NULL, 68, 1, NULL, 420, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 66, NULL, 68, 1, NULL, 415, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 52, NULL, 61, 1, NULL, 295, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 68, NULL, 68, 1, NULL, 420, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 67, NULL, 68, 1, NULL, 422, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 52, NULL, 61, 1, NULL, 296, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 68, NULL, 68, 1, NULL, 421, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 68, NULL, 68, 1, NULL, 422, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 52, NULL, 61, 1, NULL, 224, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 52, NULL, 61, 1, NULL, 225, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 66, NULL, 68, 1, NULL, 418, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 64, NULL, 68, 1, NULL, 418, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 64, NULL, 68, 1, NULL, 422, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 64, NULL, 68, 1, NULL, 420, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 64, NULL, 68, 1, NULL, 421, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 64, NULL, 68, 1, NULL, 417, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(2, 1, 64, NULL, 68, 1, NULL, 415, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.920037'),
(3, 1, 56, NULL, 61, 11, NULL, 253, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 51, NULL, 61, 11, NULL, 254, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 51, NULL, 61, 11, NULL, 297, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 51, NULL, 61, 11, NULL, 256, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 51, NULL, 61, 11, NULL, 299, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 51, NULL, 61, 11, NULL, 252, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 51, NULL, 61, 11, NULL, 298, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 56, NULL, 61, 11, NULL, 299, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 56, NULL, 61, 11, NULL, 256, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 56, NULL, 61, 11, NULL, 265, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 56, NULL, 61, 11, NULL, 297, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 51, NULL, 61, 11, NULL, 266, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 51, NULL, 61, 11, NULL, 265, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 56, NULL, 61, 11, NULL, 266, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 56, NULL, 61, 11, NULL, 254, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 56, NULL, 61, 11, NULL, 298, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 51, NULL, 61, 11, NULL, 253, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 56, NULL, 61, 11, NULL, 252, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 66, NULL, 68, 11, NULL, 425, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 66, NULL, 68, 11, NULL, 427, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 66, NULL, 68, 11, NULL, 428, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 66, NULL, 68, 11, NULL, 426, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 66, NULL, 68, 11, NULL, 423, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 66, NULL, 68, 11, NULL, 424, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 66, NULL, 68, 11, NULL, 430, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 66, NULL, 68, 11, NULL, 431, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(3, 1, 66, NULL, 68, 11, NULL, 429, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.936475'),
(4, 1, 55, NULL, 61, 17, NULL, 382, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 360, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 399, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 363, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 355, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 361, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 373, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 394, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 368, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 357, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 393, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 374, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 369, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 384, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 375, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 356, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 389, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 377, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 365, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 376, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 366, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 380, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 367, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 390, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 379, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 353, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 364, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 370, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 378, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 372, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 391, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 397, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 395, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 362, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 398, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 381, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 383, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 386, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 359, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 387, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 392, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 358, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 55, NULL, 61, 17, NULL, 388, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 462, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 491, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 468, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 505, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 512, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 469, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 493, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 489, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 473, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 476, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 495, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 483, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 490, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 466, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 467, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 474, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 486, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 487, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 472, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 465, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 492, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 498, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 508, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 484, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 500, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 480, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 463, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 504, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 478, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 479, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 506, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 507, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 510, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 464, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 475, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 482, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 471, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 497, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 509, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 494, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 477, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 485, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 470, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 499, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 481, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 502, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 503, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 496, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 501, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(4, 1, 67, NULL, 68, 17, NULL, 511, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.943704'),
(5, 1, 54, NULL, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 55, NULL, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 51, NULL, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 45, NULL, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 47, NULL, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 2, 53, NULL, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 56, NULL, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 52, NULL, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 67, NULL, 68, 3, NULL, 409, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 58, NULL, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 66, NULL, 68, 3, NULL, 409, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 60, NULL, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 68, NULL, 68, 3, NULL, 409, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 85, NULL, 75, 3, NULL, 533, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(5, 1, 64, NULL, 68, 3, NULL, 409, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.979348'),
(6, 1, 55, NULL, 61, 15, 10, 287, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.984306'),
(6, 1, 55, NULL, 61, 15, 10, 288, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.984306'),
(6, 1, 55, NULL, 61, 15, 10, 289, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.984306'),
(6, 1, 67, NULL, 68, 15, 10, 457, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.984306'),
(6, 1, 67, NULL, 68, 15, 10, 456, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.984306'),
(6, 1, 67, NULL, 68, 15, 10, 455, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.984306'),
(7, 1, 55, NULL, 61, 14, 8, 284, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.986697'),
(7, 1, 55, NULL, 61, 14, 8, 285, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.986697'),
(7, 1, 67, NULL, 68, 14, 8, 461, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.986697'),
(7, 1, 67, NULL, 68, 14, 8, 460, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.986697'),
(8, 1, 51, NULL, 61, 10, NULL, 251, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 56, NULL, 61, 10, NULL, 300, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 51, NULL, 61, 10, NULL, 300, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 56, NULL, 61, 10, NULL, 250, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 56, NULL, 61, 10, NULL, 251, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 51, NULL, 61, 10, NULL, 249, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 51, NULL, 61, 10, NULL, 250, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 56, NULL, 61, 10, NULL, 249, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 66, NULL, 68, 10, NULL, 433, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 66, NULL, 68, 10, NULL, 435, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 66, NULL, 68, 10, NULL, 434, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(8, 1, 66, NULL, 68, 10, NULL, 432, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.988592'),
(9, 2, 53, NULL, 61, 16, NULL, 400, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.994002'),
(9, 2, 53, NULL, 61, 16, NULL, 401, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.994002'),
(10, 1, 45, NULL, 61, 13, 5, 281, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.994785'),
(10, 1, 45, NULL, 61, 13, 5, 270, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.994785'),
(10, 1, 45, NULL, 61, 13, 5, 268, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.994785'),
(10, 1, 45, NULL, 61, 13, 5, 269, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.994785'),
(11, 1, 55, NULL, 61, 9, 6, 290, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.996226'),
(11, 1, 55, NULL, 61, 9, 6, 291, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.996226'),
(11, 1, 58, NULL, 61, 9, 6, 279, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.996226'),
(11, 1, 67, NULL, 68, 9, 6, 515, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.996226'),
(11, 1, 67, NULL, 68, 9, 6, 514, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.996226'),
(11, 1, 58, NULL, 61, 9, 6, 280, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.996226'),
(11, 1, 58, NULL, 61, 9, 6, 241, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.996226'),
(12, 1, 55, NULL, 61, 14, 7, 283, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.998402'),
(12, 1, 67, NULL, 68, 14, 7, 459, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.998402'),
(13, 1, 56, NULL, 61, 2, NULL, 226, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.999351'),
(13, 1, 51, NULL, 61, 2, NULL, 227, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.999351'),
(13, 1, 56, NULL, 61, 2, NULL, 227, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.999351'),
(13, 1, 51, NULL, 61, 2, NULL, 226, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.999351'),
(13, 1, 66, NULL, 68, 2, NULL, 413, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.999351'),
(13, 1, 66, NULL, 68, 2, NULL, 412, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:38.999351'),
(14, 1, 44, 1, 61, 3, NULL, 128, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.001694'),
(15, 1, 54, NULL, 61, 4, 1, 231, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.002271'),
(15, 1, 54, NULL, 61, 4, 1, 228, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.002271'),
(15, 1, 60, NULL, 61, 4, 1, 261, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.002271'),
(15, 1, 60, NULL, 61, 4, 1, 262, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.002271'),
(16, 1, 54, NULL, 61, 6, NULL, 235, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.003694'),
(16, 1, 54, NULL, 61, 6, NULL, 234, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.003694'),
(17, 1, 54, NULL, 61, 5, NULL, 232, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.004511'),
(17, 1, 54, NULL, 61, 5, NULL, 233, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.004511'),
(17, 1, 52, NULL, 61, 5, NULL, 233, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.004511'),
(17, 1, 52, NULL, 61, 5, NULL, 232, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.004511'),
(17, 1, 64, NULL, 68, 5, NULL, 411, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.004511'),
(17, 1, 64, NULL, 68, 5, NULL, 410, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.004511'),
(18, 1, 55, NULL, 61, 9, 5, 292, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.006429'),
(18, 1, 55, NULL, 61, 9, 5, 243, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.006429'),
(18, 1, 67, NULL, 68, 9, 5, 513, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.006429'),
(18, 1, 67, NULL, 68, 9, 5, 516, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.006429'),
(19, 1, 55, NULL, 61, 15, 9, 286, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.007864'),
(19, 1, 67, NULL, 68, 15, 9, 454, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.007864'),
(20, 1, 45, NULL, 61, 13, 6, 281, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.008689'),
(21, 1, 54, NULL, 61, 4, 3, 264, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.009263'),
(22, 1, 54, NULL, 61, 4, 2, 229, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.009818'),
(23, 1, 66, NULL, 68, 18, NULL, 517, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.010379'),
(24, 1, 52, NULL, 61, 2, NULL, 226, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.011033'),
(24, 1, 64, NULL, 68, 2, NULL, 412, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.011033'),
(25, 1, 60, NULL, 61, 4, '4', 263, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.01188'),
(26, 1, 52, NULL, 61, 2, NULL, 227, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.012475'),
(26, 1, 64, NULL, 68, 2, NULL, 413, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.012475'),
(27, 1, 88, 11, 76, 3, NULL, 536, true, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 15:59:39.01484');

--*** market_segment_blend ***

INSERT INTO public.market_segment_blend(
   parent_market_segment_cut_key, child_market_segment_cut_key, blend_weight, emulated_by, modified_username, modified_utc_datetime)
 VALUES(28, 10, 0.70, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673','2023-07-06 16:00:12.623729'),
    (28, 20, 0.30, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 16:00:12.623729');

--*** market_segment_combined_averages ***

INSERT INTO public.market_segment_combined_averages(
    market_segment_id, combined_averages_name, combined_averages_order, emulated_by, modified_username, modified_utc_datetime)
    VALUES(2, 'ott', 1, NULL, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 16:00:21.516113');

--** market_segment_combined_averages_cut ***

INSERT INTO public.market_segment_combined_averages_cut(
    combined_averages_key, market_pricing_cut_name, emulated_by, modified_username, modified_utc_datetime)
    VALUES (1, 'one', NULL, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 17:24:57.594019'),
(1, 'three', NULL, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 17:24:57.599871'),
(1, 'two', NULL, 'e4f76c83-c292-4f8b-8b61-fedf4f3b6673', '2023-07-06 17:24:57.600611');

--*** market_pricing_sheet_survey ***

INSERT INTO public.market_pricing_sheet_survey(
	market_pricing_sheet_id, market_segment_cut_detail_key, cut_external_key, raw_data_key, exclude_in_calc, adjustment_value, emulated_by, modified_username, modified_utc_datetime)
	VALUES (6, 1, null, 104741617, true, NULL, 'e876479e-3131-4f69-aa27-59205195709e', 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:56:46.395062');

--*** market_pricing_sheet_adjustment_note ***

	INSERT INTO public.market_pricing_sheet_adjustment_note(
	market_pricing_sheet_survey_key, adjustment_note_key, emulated_by, modified_username, modified_utc_datetime)
	VALUES (1, 1, 'e876479e-3131-4f69-aa27-59205195709e', 'e876479e-3131-4f69-aa27-59205195709e', '2023-04-24 21:56:46.395062');
	
