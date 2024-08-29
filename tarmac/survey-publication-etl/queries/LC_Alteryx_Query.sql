with survey_info as (
	 select
/*surveys*/
	 s.name
	,s.id
	,s.year
	,s.start_date
	,s.expiration_date
	,s.publication_date
/*survey_instances*/
	,si.id as survey_instance_id
	,si.owner_id
	,si.organization_id
	,si.working_copy
	,si.original_id
	,si.status_description
	,si.completed
	,si.notes as survey_instance_notes
	,si.productivity_submission_status
	,si.records_eligible_for_sync
	,si.organization_survey_general_information_id
	,si.cpt_upload_count
/*organizations*/
	,o.id as o_id
	,o.name as organization_name
	,o.parent_id as parent_org_id
	,o.teaching_program_type_id
	,o.sponsorship_type_id
	,o.is_member_council_teaching_hospitals
	,o.has_teaching_program
	,o.is_major_academic_medical_center
	,o.net_revenue
	,o.source_id
	,o.number_of_beds
	,o.clinic_id
	,o.specialized_hospital_type
	,o.pediatric_hospital_structure
	,o.is_trauma_center
	,o.trauma_center_level
	,o.organization_ownership
	,o.teaching_program
	,o.inactive
	,o.lft
	,o.rgt
	,o.depth
	,o.path
	,o.system_org_id as top_parent_id
	,o.hierarchy_level
	,o.dynamics_id
	,o.definitive_id
	,o.ownership_designation
	,o.org_classification_level1_id as oc_id_1
	,o.org_classification_level2_id as oc_id_2
	,o.org_classification_level3_id as oc_id_3
	,o.academic_medical_center as amc
	,o.childrens_hospital as childrens
	,o.flagship_hospital as flagship
	,o.hubspot_id
/*addresses*/
	,a.addressable_id
	,a.street1
	,a.city
	,a.state
	,a.zip_code
	from source_oriented.ces.surveys s
	join source_oriented.ces.survey_instances si on si.survey_id = s.id
	join source_oriented.ces.organizations o on o.id = si.organization_id
	join source_oriented.ces.addresses a on a.addressable_id = o.id
	where si.survey_id = 84 -- current survey year
		and si.working_copy = 'true' -- only pull working copy
		and a.addressable_type = 'ScCommon::ScCrm::Organizations::Organization' -- limit organizations
)
/*individual template*/
,individual as (
	 select
	 si.id as survey_instance_id_individual
	--,si.survey_id
	--,si.original_id
	--,si.working_copy
	--,si.organization_id
/*calculations*/
	,case when ica.total_fte > 1 then ica.quality_payment else ica.quality_payment/ica.total_fte end as adjusted_quality_payment
	,case when ica.total_fte > 1 then ica.quality_payment/ica.adjusted_TCC else ((ica.quality_payment/ica.total_fte)/ica.adjusted_TCC) end as adjusted_quality_based_as_a_percentage_TCC
	,case when ica.clinical_fte > 1 then ica.quality_payment else ica.quality_payment/nullif(ica.clinical_fte, 0) end as cFTE_adjusted_quality_payment
	,case when ica.clinical_fte > 1 then ica.quality_payment/ica.cFTE_adjusted_cTCC else ((ica.quality_payment/nullif(ica.clinical_fte, 0))/ica.cFTE_adjusted_cTCC) end as cFTE_adjusted_quality_based_as_a_percentage_TCC
	,case when ica.total_fte > 1 then ica.fringe_benefits else ica.fringe_benefits/ica.total_fte end as adjusted_total_cost_of_benefits
	,case when ica.total_fte > 1 then ica.fringe_benefits/ica.adjusted_TCC else ((ica.fringe_benefits/ica.total_fte)/ica.adjusted_TCC) end as adjusted_total_cost_of_benefits_as_a_percentage_TCC
	,case when ica.total_fte > 1 then ica.work_rvus else ica.work_rvus/ica.total_fte end as FTE_adjusted_wRVUs_individual
	,case when ica.total_fte > 1 then ica.collected_charges else ica.collected_charges/ica.total_fte end as FTE_adjusted_collections
	,case when ica.total_fte > 1 then ica.adjusted_TCC/ica.work_rvus else (ica.adjusted_TCC/(ica.work_rvus/ica.total_fte)) end as adjusted_TCC_per_FTE_work_wRVU
	,case when ica.total_fte > 1 then ica.adjusted_TCC/ica.collected_charges else (ica.adjusted_TCC/(ica.collected_charges/ica.total_fte)) end as adjusted_TCC_to_FTE_collections
	from source_oriented.ces.survey_instances si
	join source_oriented.ces.surveys_large_clinic_individual_compensations ic on ic.survey_instance_id = si.id
	join source_oriented.ces.surveys_large_clinic_individual_compensation_answers ica on ica.surveys_large_clinic_individual_compensation_id = ic.id
	where si.survey_id = 84
	and si.working_copy = 'true'
	limit 1000 -- limit for testing
)
/* app template */
,apc as (
	 select
	 si.id as survey_instance_id_apc
	--,si.survey_id
	--,si.original_id
	--,si.working_copy
	--,si.organization_id
/*calculations*/
	,calculated_base_salary as calculated_base_salary -- may not be required
	,(coalesce(on_call_pay, 0) + coalesce(moonlighting_pay, 0) + coalesce(extra_shift_pay, 0) + coalesce(shift_differential_compensation, 0)) as premium_pay
	,(coalesce(calculated_base_salary, 0) + coalesce(adj_productivity_incentive_pay, 0) + coalesce(adj_value_quality_pay, 0) + coalesce(adj_telehealth_pay, 0) + coalesce(retention_bonus, 0) + coalesce(adj_leadership_incentive_pay, 0) + coalesce(adj_other_clinical_cash_comp, 0) + coalesce(adj_other_non_clinical_cash_comp, 0)) as tcc_excluding_premium
	,(coalesce(calculated_base_salary, 0) + coalesce(adj_productivity_incentive_pay, 0) + coalesce(adj_value_quality_pay, 0) + coalesce(adj_telehealth_pay, 0) + coalesce(retention_bonus, 0) + coalesce(adj_leadership_incentive_pay, 0) + coalesce(adj_other_clinical_cash_comp, 0) + coalesce(adj_other_non_clinical_cash_comp, 0)) + (coalesce(on_call_pay, 0) + coalesce(moonlighting_pay, 0) + coalesce(extra_shift_pay, 0) + coalesce(shift_differential_compensation, 0)) as tcc_including_premium
	,(net_collections/fte) as adjusted_collections
	,(work_rvus/fte) as FTE_adjusted_wRVUs_apc
	,(coalesce(calculated_base_salary, 0) + coalesce(adj_productivity_incentive_pay, 0) + coalesce(adj_value_quality_pay, 0) + coalesce(adj_telehealth_pay, 0) + coalesce(retention_bonus, 0) + coalesce(adj_leadership_incentive_pay, 0) + coalesce(adj_other_clinical_cash_comp, 0) + coalesce(adj_other_non_clinical_cash_comp, 0)) + (coalesce(on_call_pay, 0) + coalesce(moonlighting_pay, 0) + coalesce(extra_shift_pay, 0) + coalesce(shift_differential_compensation, 0))/(work_rvus/fte) as FTE_adjusted_TCC_per_FTE_work_wRVU
	,(total_encounters/fte) as FTE_adjusted_total_encounters
	,(coalesce(calculated_base_salary, 0) + coalesce(adj_productivity_incentive_pay, 0) + coalesce(adj_value_quality_pay, 0) + coalesce(adj_telehealth_pay, 0) + coalesce(retention_bonus, 0) + coalesce(adj_leadership_incentive_pay, 0) + coalesce(adj_other_clinical_cash_comp, 0) + coalesce(adj_other_non_clinical_cash_comp, 0)) + (coalesce(on_call_pay, 0) + coalesce(moonlighting_pay, 0) + coalesce(extra_shift_pay, 0) + coalesce(shift_differential_compensation, 0)) / (net_collections/fte) as FTE_adjusted_TCC_to_FTE_collections
	,(coalesce(calculated_base_salary, 0) + coalesce(adj_productivity_incentive_pay, 0) + coalesce(adj_value_quality_pay, 0) + coalesce(adj_telehealth_pay, 0) + coalesce(retention_bonus, 0) + coalesce(adj_leadership_incentive_pay, 0) + coalesce(adj_other_clinical_cash_comp, 0) + coalesce(adj_other_non_clinical_cash_comp, 0))/(work_rvus/fte) as FTE_adjusted_TCCep_per_FTE_work_wRVU
	,(coalesce(calculated_base_salary, 0) + coalesce(adj_productivity_incentive_pay, 0) + coalesce(adj_value_quality_pay, 0) + coalesce(adj_telehealth_pay, 0) + coalesce(retention_bonus, 0) + coalesce(adj_leadership_incentive_pay, 0) + coalesce(adj_other_clinical_cash_comp, 0) + coalesce(adj_other_non_clinical_cash_comp, 0))/(net_collections/fte) as FTE_adjusted_TCCep_to_FTE_collections
	from source_oriented.ces.survey_instances si
	join source_oriented.ces.surveys_large_clinic_apc_compensations ac on ac.survey_instance_id = si.id
	join source_oriented.ces.surveys_large_clinic_apc_compensation_answers aca on aca.apc_compensation_id = ac.id
	where si.survey_id = 84
	and si.working_copy = 'true'
	limit 1000 -- limit for testing
)
/*new hire template*/
,new_hire as (
	 select
	 si.id as survey_instance_id_new_hire
	--,si.survey_id
	--,si.original_id
	--,si.working_copy
	--,si.organization_id
/*calculations*/
	,case when nca.clinical_fte = 0 then 0 else (nca.starting_salary/nca.clinical_fte) end as annualized_starting_salary
	,case when nca.forgivable_loan_total_amount > 0 and nca.forgivable_loan_num_years = 0 then 1 else nca.forgivable_loan_num_years end as forgivable_loan_num_years -- we should update the way this field comes in to reflect the appropriate calculation
	,case when nca.signing_bonus_amount > 0 and nca.signing_bonus_years = 0 then 1 else nca.signing_bonus_years end as signing_bonus_years -- we should update the way this field comes in to reflect the appropriate calculation
	,case when nca.forgivable_loan_total_amount = 0 then 0 when nca.forgivable_loan_total_amount > 0 and coalesce(nca.forgivable_loan_num_years, 0) = 0 then nca.forgivable_loan_total_amount else (nca.forgivable_loan_total_amount/nca.forgivable_loan_num_years) end as annualized_forgivable_loans
	,case when nca.signing_bonus_amount = 0 then 0 when nca.signing_bonus_amount > 0 and coalesce(nca.signing_bonus_years, 0) = 0 then nca.signing_bonus_amount else (nca.signing_bonus_amount/nca.signing_bonus_years) end as annualized_sign_on_bonuses
	,case when nca.clinical_fte = 0 then 0 else (nca.starting_salary/nca.clinical_fte) + 
		coalesce(nca.forgivable_loan_total_amount, 0) + 
		coalesce(nca.signing_bonus_amount, 0) end as annualized_total_compensation_package
	,case when nca.clinical_fte = 0 then 0 else (nca.starting_salary/nca.clinical_fte) end + 
		case when nca.signing_bonus_amount = 0 then 0 when nca.signing_bonus_amount > 0 and coalesce(nca.signing_bonus_years, 0) = 0 then nca.signing_bonus_amount else (nca.signing_bonus_amount/nca.signing_bonus_years) end +
		case when nca.forgivable_loan_total_amount = 0 then 0 when nca.forgivable_loan_total_amount > 0 and coalesce(nca.forgivable_loan_num_years, 0) = 0 then nca.forgivable_loan_total_amount else (nca.forgivable_loan_total_amount/nca.forgivable_loan_num_years) end as annualized_total_first_year_compensation
	from source_oriented.ces.survey_instances si
	join source_oriented.ces.surveys_large_clinic_new_hire_compensations nc on si.id = nc.survey_instance_id 
	join source_oriented.ces.surveys_large_clinic_new_hire_compensation_answers nca on nc.id = nca.surveys_large_clinic_new_hire_compensation_id 
	where si.survey_id = 84
	and si.working_copy = 'true'
	limit 1000 -- limit for testing
)
/*final table*/
select 
* 
from survey_info si
left join individual i on i.survey_instance_id_individual = si.survey_instance_id
left join apc a on a.survey_instance_id_apc = si.survey_instance_id
left join new_hire n on n.survey_instance_id_new_hire = si.survey_instance_id