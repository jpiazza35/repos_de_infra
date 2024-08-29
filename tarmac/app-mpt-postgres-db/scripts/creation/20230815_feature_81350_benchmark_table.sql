CREATE TABLE IF NOT EXISTS public.benchmark_data_type_setup
(
    benchmark_data_type_key integer,
    benchmark_data_type_name character(100),
    benchmark_data_type_long_alias character(100),
    benchmark_data_type_short_alias character(50),
    benchmark_data_type_order_override integer,
    benchmark_data_type_format character(50), 
    benchmark_data_type_format_decimal integer,
    PRIMARY KEY (benchmark_data_type_key)
);

INSERT INTO public.benchmark_data_type_setup (benchmark_data_type_order_override, benchmark_data_type_key, benchmark_data_type_name, benchmark_data_type_long_alias, benchmark_data_type_short_alias, benchmark_data_type_format, benchmark_data_type_format_decimal)
VALUES (1, 29, 'Base Pay Hourly Rate', 'Hourly Base Pay', 'Base', '$', 2),
       (2, 1, 'Annualized Base Salary', 'Annual Base Pay', 'Base', '$', 0),
       (3, 45, 'Pay Range Minimum', 'Hourly Pay Range Minimum', 'Min', '$', 2),
       (4, 123, 'Hourly Pay Range Midpoint', 'Hourly Pay Range Midpoint', 'Mid', '$', 2),
       (5, 44, 'Pay Range Maximum', 'Hourly Pay Range Maximum', 'Max', '$', 2),
       (6, 188, 'Annual Pay Range Minimum', 'Annual Pay Range Minimum', 'Min', '$', 0),
       (7, 190, 'Annual Pay Range Midpoint', 'Annual Pay Range Midpoint', 'Mid', '$', 0),
       (8, 189, 'Annual Pay Range Maximum', 'Annual Pay Range Maximum', 'Max', '$', 0),
       (9, 27, 'Actual Annual Incentive', 'Annual Incentive Pay ($)', 'Incentive ($)', '$', 0),
       (10, 191, 'Annual Incentive Pay (%)', 'Annual Incentive Pay (%)', 'Incentive (%)', '%', 2),
       (11, 94, 'Target Annual Incentive', 'Annual Incentive Pay Target ($)', 'Target IP ($)', '$', 0),
       (12, 42, 'Target Incentive Percentage', 'Annual Incentive Pay Target (%)', 'Target IP (%)', '%', 2),
       (13, 117, 'Annual Incentive Threshold Opportunity', 'Annual Incentive Pay Threshold ($)', 'Threshold IP ($)', '$', 0),
       (14, 192, 'Annual Incentive Pay Threshold (%)', 'Annual Incentive Pay Threshold (%)', 'Threshold IP (%)', '%', 2),
       (15, 71, 'Annual Incentive Maximum Opportunity', 'Annual Incentive Pay Maximum ($)', 'Maximum IP ($)', '$', 0),
       (16, 193, 'Annual Incentive Pay Maximum (%)', 'Annual Incentive Pay Maximum (%)', 'Maximum IP (%)', '%', 2),
       (17, 65, 'TCC - Hourly', 'Hourly Total Cash Compensation', 'TCC', '$', 2),
       (18, 2, 'TCC', 'Annual Total Cash Compensation', 'TCC', '$', 0) ON CONFLICT DO NOTHING;