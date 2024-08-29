INSERT INTO public.status_list(status_key, status_name, status_description, status_type, display_status)
    VALUES (1, 'Draft', 'Draft', 'Project', true),
           (2, 'Final', 'Final', 'Project', true),
           (3, 'Deleted', 'Deleted', 'Project', false),
           (4, 'Draft', 'Draft', 'Market Segment', true),
           (5, 'Final', 'Final', 'Market Segment', true),
           (6, 'Deleted', 'Deleted', 'Market Segment', false),
           (7, 'Not Started', 'Not Started', 'Market Pricing', true),
           (8, 'Analyst Reviewed', 'Analyst Reviewed', 'Market Pricing', true),
           (9, 'Peer Reviewed', 'Peer Reviewed', 'Market Pricing', true),
           (10, 'Complete', 'Complete', 'Market Pricing', true) ON CONFLICT DO NOTHING;


INSERT INTO public.adjustment_note_list(adjustment_note_name, emulated_by, modified_username, modified_utc_datetime)
    VALUES ('Level', NULL, 'system', CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
           ('Scope', NULL, 'system', CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
           ('Complexity', NULL, 'system', CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
           ('Other', NULL, 'system', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') ON CONFLICT DO NOTHING;