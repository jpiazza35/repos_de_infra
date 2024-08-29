BEGIN;
    UPDATE public.mapping   SET external_name = 'Hourly Pay Range Midpoint'             WHERE category = 'benchmark' AND internal_name = 'Pay_Range_Midpoint';
    UPDATE public.mapping   SET external_name = 'Annual Pay Range Minimum'              WHERE category = 'benchmark' AND internal_name = 'Annualized_Pay_Range_Minimum';
    UPDATE public.mapping   SET external_name = 'Annual Pay Range Midpoint'             WHERE category = 'benchmark' AND internal_name = 'Annualized_Pay_Range_Midpoint';
    UPDATE public.mapping   SET external_name = 'Annual Pay Range Maximum'              WHERE category = 'benchmark' AND internal_name = 'Annualized_Pay_Range_Maximum';
    UPDATE public.mapping   SET external_name = 'Annual Incentive Pay Threshold (%)'    WHERE category = 'benchmark' AND internal_name = 'Threshold_Incentive_Percent';
COMMIT;