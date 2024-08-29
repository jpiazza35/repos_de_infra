# Databricks notebook source
# MAGIC %md
# MAGIC Step 2: combines all sheets of raw data

# COMMAND ----------

import pyspark.sql.functions as F
import pyspark.pandas as pd
from pyspark.sql.functions import concat
from pyspark.sql.functions import monotonically_increasing_id

# COMMAND ----------

# MAGIC %run ./moodys_utilities

# COMMAND ----------

financial_data = spark.read.table("source_oriented.default.moodys_financial")
OD_data = spark.read.table("source_oriented.default.moodys_OD")
ratio_data = spark.read.table("source_oriented.default.moodys_ratio")

# COMMAND ----------

#fix financial
financial_data = financial_data.drop('exclude_from_medians')


# COMMAND ----------

#fix OD
OD_data = OD_data.drop(*('name', 'years', 'current_senior_most_rating', 'revenue_backed_rating_description', 'state', 'moodys_org_id', 'type_of_organization', 'exclude_from_medians'))

# COMMAND ----------

#fix ratio
ratio_data = ratio_data.drop(*('name', 'years', 'current_senior_most_rating', 'revenue_backed_rating_description', 'state', 'moodys_org_id', 'type_of_organization', 'exclude_from_medians', 'total_debt_service'))

# COMMAND ----------

#combine all datasets together into master_df
from pyspark.sql.functions import monotonically_increasing_id
fin_test = financial_data.withColumn("id",monotonically_increasing_id() )
od_test = OD_data.withColumn( "id", monotonically_increasing_id() )
ratio_test = ratio_data.withColumn( "id", monotonically_increasing_id() )
master_df = fin_test.join(od_test,fin_test.id == od_test.id, how='inner') \
    .join(ratio_test,fin_test.id == ratio_test.id, how='inner')
master_df = master_df.drop('id')
master_df = master_df.drop('combo')

# COMMAND ----------

#drop empty rows at bottom
master_df = master_df.na.drop(subset=["years"])
display(master_df)

# COMMAND ----------

#name changes for companies
master_df = master_df.replace('Charlotte-Mecklenburg Hospital Authority, NC', 'Atrium Health, NC', 'name')
master_df = master_df.replace('IHC Health Services, Inc., UT','Intermountain Health, UT','name')
master_df = master_df.replace('Catholic Healthcare West, CA','Dignity Health, CA','name')
master_df = master_df.replace('Greenville Health System, SC','Prisma Health, SC','name')
master_df = master_df.replace('New York University Hospitals Center, NY','NYU Langone Health, NY','name')
master_df = master_df.replace('Highland Hospital (Rochester), NY','University of Rochester, NY','name')
master_df = master_df.replace('Irving Hospital Authority, TX','Baylor Scott & White Medical Center - Irving, TX','name')

change1 = master_df.filter(F.col("name").like("%Mercy Health, OH%")).filter(F.col("years") >= 2019)
for i in change1.collect():
    master_df= master_df.replace(i["name"],"Bon Secours Mercy Health, OH", "name")
change2= master_df.filter(F.col("name").like("%Advocate Health Care Network, IL%")).filter(F.col("years") >= 2018)
for i in change2.collect():
    master_df= master_df.replace(i["name"],"Advocate Aurora Health, IL", "name")
change3 = master_df.filter(F.col("name").like("%Scottsdale Healthcare Corporation, AZ%")).filter(F.col("years") >= 2014)
for i in change3.collect():
    master_df= master_df.replace(i["name"],"HonorHealth, AZ", "name")
change4 = master_df.filter(F.col("name").like("%Catholic Health Initiatives, CO%")).filter(F.col("years") >= 2019)
for i in change4.collect():
    master_df= master_df.replace(i["name"],"CommonSpirit Health, IL", "name")

# COMMAND ----------

#add column 'combo' to combine on
master_df = add_combo_column(master_df, master_df.name, master_df.years)

# COMMAND ----------

master_df = master_df.where(master_df.name != 'NA')
# master_df.write.mode("overwrite").saveAsTable('source_oriented.default.moodys_mfra')

# COMMAND ----------

master_df.createOrReplaceTempView('recent_mfra')

# COMMAND ----------

# MAGIC %sql
# MAGIC MERGE INTO source_oriented.default.moodys_mfra
# MAGIC USING recent_mfra
# MAGIC ON moodys_mfra.combo = recent_mfra.combo
# MAGIC WHEN MATCHED THEN
# MAGIC   UPDATE SET
# MAGIC     name = recent_mfra.name,
# MAGIC     years = recent_mfra.years,
# MAGIC     current_senior_most_rating = recent_mfra.current_senior_most_rating,
# MAGIC     revenue_backed_rating_description = recent_mfra.revenue_backed_rating_description,
# MAGIC     state = recent_mfra.state,
# MAGIC     moodys_org_id = recent_mfra.moodys_org_id,
# MAGIC     type_of_organization = recent_mfra.type_of_organization,
# MAGIC     accrued_interest_payable = recent_mfra.accrued_interest_payable,
# MAGIC     due_to_3rd_party_payors = recent_mfra.due_to_3rd_party_payors,
# MAGIC     current_portion_of_lt_debt = recent_mfra.current_portion_of_lt_debt,
# MAGIC     short_term_debt = recent_mfra.short_term_debt,
# MAGIC     other_current_liabilities = recent_mfra.other_current_liabilities,
# MAGIC     total_current_liabilities = recent_mfra.total_current_liabilities,
# MAGIC     short_term_operating_debt_operating_lines_etc = recent_mfra.short_term_operating_debt_operating_lines_etc,
# MAGIC     salaries_and_benefits = recent_mfra.salaries_and_benefits,
# MAGIC     supplies = recent_mfra.supplies,
# MAGIC     bad_debt = recent_mfra.bad_debt,
# MAGIC     interest_expense = recent_mfra.interest_expense,
# MAGIC     depreciation_and_amortization = recent_mfra.depreciation_and_amortization,
# MAGIC     research_expenses = recent_mfra.research_expenses,
# MAGIC     recurring_transfer_to_affiliated_entity = recent_mfra.recurring_transfer_to_affiliated_entity,
# MAGIC     other_expenditures = recent_mfra.other_expenditures,
# MAGIC     total_expenses = recent_mfra.total_expenses,
# MAGIC     operating_and_maintenance_expense = recent_mfra.operating_and_maintenance_expense,
# MAGIC     operating_income = recent_mfra.operating_income,
# MAGIC     board_designated_and_other_long_term_investments = recent_mfra.board_designated_and_other_long_term_investments,
# MAGIC     bond_trustee_held_construction_funds_unspent_proceeds = recent_mfra.bond_trustee_held_construction_funds_unspent_proceeds,
# MAGIC     bond_trustee_held_dsrf_or_debt_service_funds = recent_mfra.bond_trustee_held_dsrf_or_debt_service_funds,
# MAGIC     property_plant_and_equipment_net = recent_mfra.property_plant_and_equipment_net,
# MAGIC     accumulated_depreciation = recent_mfra.accumulated_depreciation,
# MAGIC     self_insurance_funds = recent_mfra.self_insurance_funds,
# MAGIC     pledges_receivable = recent_mfra.pledges_receivable,
# MAGIC     pension_asset = recent_mfra.pension_asset,
# MAGIC     due_from_3rd_party_payers_non_current = recent_mfra.due_from_3rd_party_payers_non_current,
# MAGIC     other_non_current_assets = recent_mfra.other_non_current_assets,
# MAGIC     total_assets = recent_mfra.total_assets,
# MAGIC     unrestricted_net_assets = recent_mfra.unrestricted_net_assets,
# MAGIC     temporarily_restricted_net_assets = recent_mfra.temporarily_restricted_net_assets,
# MAGIC     permanently_restricted_net_assets = recent_mfra.permanently_restricted_net_assets,
# MAGIC     total_net_assets = recent_mfra.total_net_assets,
# MAGIC     contributions = recent_mfra.contributions,
# MAGIC     other_revenues_and_expenses = recent_mfra.other_revenues_and_expenses,
# MAGIC     smoothed_investment_income = recent_mfra.smoothed_investment_income,
# MAGIC     excess_of_revenues_over_expenses = recent_mfra.excess_of_revenues_over_expenses,
# MAGIC     principal_payments_on_debt = recent_mfra.principal_payments_on_debt,
# MAGIC     total_debt_service = recent_mfra.total_debt_service,
# MAGIC     purchases_of_property_plant_and_equipment = recent_mfra.purchases_of_property_plant_and_equipment,
# MAGIC     cash_and_investments = recent_mfra.cash_and_investments,
# MAGIC     net_patient_accounts_receivable = recent_mfra.net_patient_accounts_receivable,
# MAGIC     due_from_3rd_party_payors = recent_mfra.due_from_3rd_party_payors,
# MAGIC     current_portion_of_trusteed_fund_for_debt_service = recent_mfra.current_portion_of_trusteed_fund_for_debt_service,
# MAGIC     current_portion_of_construction_funds = recent_mfra.current_portion_of_construction_funds,
# MAGIC     current_portion_of_self_insurance_funds = recent_mfra.current_portion_of_self_insurance_funds,
# MAGIC     other_current_assets = recent_mfra.other_current_assets,
# MAGIC     total_current_assets = recent_mfra.total_current_assets,
# MAGIC     lt_debt = recent_mfra.lt_debt,
# MAGIC     accrued_pension_liability = recent_mfra.accrued_pension_liability,
# MAGIC     due_to_3rd_party_payers_non_current = recent_mfra.due_to_3rd_party_payers_non_current,
# MAGIC     self_insurance_liabilities = recent_mfra.self_insurance_liabilities,
# MAGIC     other_liabilities = recent_mfra.other_liabilities,
# MAGIC     total_liabilities = recent_mfra.total_liabilities,
# MAGIC     total_liabilities_and_net_assets = recent_mfra.total_liabilities_and_net_assets,
# MAGIC     gains_losses_on_non_recurring_items = recent_mfra.gains_losses_on_non_recurring_items,
# MAGIC     realized_gain_loss_on_investments = recent_mfra.realized_gain_loss_on_investments,
# MAGIC     unrealized_gain_loss_on_investments = recent_mfra.unrealized_gain_loss_on_investments,
# MAGIC     restricted_contributions = recent_mfra.restricted_contributions,
# MAGIC     other_restricted_revenues_expenses = recent_mfra.other_restricted_revenues_expenses,
# MAGIC     total_net_patient_service_revenues = recent_mfra.total_net_patient_service_revenues,
# MAGIC     grants_and_contracts = recent_mfra.grants_and_contracts,
# MAGIC     state_and_local_appropriations = recent_mfra.state_and_local_appropriations,
# MAGIC     premium_revenue = recent_mfra.premium_revenue,
# MAGIC     tax_revenue = recent_mfra.tax_revenue,
# MAGIC     contributions_included_in_operating_revenue = recent_mfra.contributions_included_in_operating_revenue,
# MAGIC     net_assets_released_from_restrictions_and_used_for_operations = recent_mfra.net_assets_released_from_restrictions_and_used_for_operations,
# MAGIC     other_operating_revenue = recent_mfra.other_operating_revenue,
# MAGIC     total_operating_revenues = recent_mfra.total_operating_revenues,
# MAGIC     increase_decrease_in_unrestricted_net_assets = recent_mfra.increase_decrease_in_unrestricted_net_assets,
# MAGIC     increase_decrease_in_restricted_net_assets = recent_mfra.increase_decrease_in_restricted_net_assets,
# MAGIC     increase_decrease_in_net_assets = recent_mfra.increase_decrease_in_net_assets,
# MAGIC     medicare_percent_of_gross_revenue = recent_mfra.medicare_percent_of_gross_revenue,
# MAGIC     medicare_managed_care_percent_of_gross_revenue = recent_mfra.medicare_managed_care_percent_of_gross_revenue,
# MAGIC     total_medicare_percent = recent_mfra.total_medicare_percent,
# MAGIC     medicaid_percent_of_gross_revenue = recent_mfra.medicaid_percent_of_gross_revenue,
# MAGIC     medicaid_managed_care_percent_of_gross_revenue = recent_mfra.medicaid_managed_care_percent_of_gross_revenue,
# MAGIC     total_medicaid_percent = recent_mfra.total_medicaid_percent,
# MAGIC     total_commercial_percent = recent_mfra.total_commercial_percent,
# MAGIC     self_pay_percent_of_gross_revenue = recent_mfra.self_pay_percent_of_gross_revenue,
# MAGIC     other_percent_of_gross_revenue = recent_mfra.other_percent_of_gross_revenue,
# MAGIC     medicare_number_of_covered_lives = recent_mfra.medicare_number_of_covered_lives,
# MAGIC     medicaid_number_of_covered_lives = recent_mfra.medicaid_number_of_covered_lives,
# MAGIC     commercial_number_of_covered_lives = recent_mfra.commercial_number_of_covered_lives,
# MAGIC     inpatient_revenue_percent_of_net_patient_revenue = recent_mfra.inpatient_revenue_percent_of_net_patient_revenue,
# MAGIC     outpatient_revenue_percent_of_net_patient_revenue = recent_mfra.outpatient_revenue_percent_of_net_patient_revenue,
# MAGIC     total_100_percent = recent_mfra.total_100_percent,
# MAGIC     licensed_beds = recent_mfra.licensed_beds,
# MAGIC     maintained_beds = recent_mfra.maintained_beds,
# MAGIC     unique_patients = recent_mfra.unique_patients,
# MAGIC     admissions = recent_mfra.admissions,
# MAGIC     patient_days = recent_mfra.patient_days,
# MAGIC     emergency_room_visits = recent_mfra.emergency_room_visits,
# MAGIC     outpatient_visits = recent_mfra.outpatient_visits,
# MAGIC     outpatient_surgeries = recent_mfra.outpatient_surgeries,
# MAGIC     total_surgeries = recent_mfra.total_surgeries,
# MAGIC     observation_stays = recent_mfra.observation_stays,
# MAGIC     newborn_admissions = recent_mfra.newborn_admissions,
# MAGIC     medicare_case_mix_index = recent_mfra.medicare_case_mix_index,
# MAGIC     total_case_mix_index = recent_mfra.total_case_mix_index,
# MAGIC     admissions_plus_observation_stays = recent_mfra.admissions_plus_observation_stays,
# MAGIC     percent_change_in_admissions_and_observation_stays = recent_mfra.percent_change_in_admissions_and_observation_stays,
# MAGIC     percent_change_in_outpatient_surgeries = recent_mfra.percent_change_in_outpatient_surgeries,
# MAGIC     maintained_bed_occupancy = recent_mfra.maintained_bed_occupancy,
# MAGIC     licensed_bed_occupancy = recent_mfra.licensed_bed_occupancy,
# MAGIC     average_length_of_stay = recent_mfra.average_length_of_stay,
# MAGIC     operating_cash_flow = recent_mfra.operating_cash_flow,
# MAGIC     net_revenues_available_for_debt_service = recent_mfra.net_revenues_available_for_debt_service,
# MAGIC     additions_to_pp_and_e = recent_mfra.additions_to_pp_and_e,
# MAGIC     operating_revenue = recent_mfra.operating_revenue,
# MAGIC     unrestricted_cash_and_investments = recent_mfra.unrestricted_cash_and_investments,
# MAGIC     total_adjusted_debt = recent_mfra.total_adjusted_debt,
# MAGIC     total_debt = recent_mfra.total_debt,
# MAGIC     net_debt = recent_mfra.net_debt,
# MAGIC     debt_service_reserve_and_debt_service_fund = recent_mfra.debt_service_reserve_and_debt_service_fund,
# MAGIC     maximum_annual_debt_service = recent_mfra.maximum_annual_debt_service,
# MAGIC     variable_rate_debt_percent_of_total_debt = recent_mfra.variable_rate_debt_percent_of_total_debt,
# MAGIC     fixed_rate_debt_percent_of_total_debt = recent_mfra.fixed_rate_debt_percent_of_total_debt,
# MAGIC     on_demand_debt_percent = recent_mfra.on_demand_debt_percent,
# MAGIC     cash_to_demand_debt_percent = recent_mfra.cash_to_demand_debt_percent,
# MAGIC     operating_margin_percent = recent_mfra.operating_margin_percent,
# MAGIC     operating_cash_flow_margin_percent = recent_mfra.operating_cash_flow_margin_percent,
# MAGIC     cash_on_hand_days = recent_mfra.cash_on_hand_days,
# MAGIC     cash_and_investments_to_total_debt_percent = recent_mfra.cash_and_investments_to_total_debt_percent,
# MAGIC     total_debt_to_cash_flow = recent_mfra.total_debt_to_cash_flow,
# MAGIC     mads_coverage_moodys_adjusted = recent_mfra.mads_coverage_moodys_adjusted,
# MAGIC     unrestricted_cash_and_investments_to_total_adjusted_debt_percent = recent_mfra.unrestricted_cash_and_investments_to_total_adjusted_debt_percent,
# MAGIC     bad_debt_as_a_percent_of_net_patient_revenue_percent = recent_mfra.bad_debt_as_a_percent_of_net_patient_revenue_percent,
# MAGIC     capital_spending_ratio = recent_mfra.capital_spending_ratio,
# MAGIC     age_of_plant = recent_mfra.age_of_plant,
# MAGIC     accounts_receivable_days = recent_mfra.accounts_receivable_days,
# MAGIC     average_payment_period = recent_mfra.average_payment_period,
# MAGIC     total_debt_to_operating_revenue_percent = recent_mfra.total_debt_to_operating_revenue_percent,
# MAGIC     total_debt_to_capitalization_percent = recent_mfra.total_debt_to_capitalization_percent,
# MAGIC     debt_service_coverage = recent_mfra.debt_service_coverage,
# MAGIC     mads_coverage_with_reported_investment_income = recent_mfra.mads_coverage_with_reported_investment_income,
# MAGIC     mads_as_a_percent_of_operating_expenses_percent = recent_mfra.mads_as_a_percent_of_operating_expenses_percent,
# MAGIC     smoothed_investment_income_to_nrads_percent = recent_mfra.smoothed_investment_income_to_nrads_percent,
# MAGIC     three_year_operating_revenue_cagr_percent = recent_mfra.three_year_operating_revenue_cagr_percent,
# MAGIC     excess_margin_percent = recent_mfra.excess_margin_percent,
# MAGIC     cushion_ratio = recent_mfra.cushion_ratio,
# MAGIC     current_ratio = recent_mfra.current_ratio,
# MAGIC     return_on_assets_percent = recent_mfra.return_on_assets_percent,
# MAGIC     return_on_equity_percent = recent_mfra.return_on_equity_percent,
# MAGIC     monthly_liquidity = recent_mfra.monthly_liquidity,
# MAGIC     monthly_days_cash_on_hand = recent_mfra.monthly_days_cash_on_hand,
# MAGIC     monthly_liquidity_to_demand_debt_percent = recent_mfra.monthly_liquidity_to_demand_debt_percent,
# MAGIC     annual_liquidity = recent_mfra.annual_liquidity,
# MAGIC     annual_days_cash_on_hand = recent_mfra.annual_days_cash_on_hand,
# MAGIC     annual_liquidity_to_demand_debt_percent = recent_mfra.annual_liquidity_to_demand_debt_percent,
# MAGIC     type_of_benefit_plan = recent_mfra.type_of_benefit_plan,
# MAGIC     adjusted_pension_liability = recent_mfra.adjusted_pension_liability,
# MAGIC     adjusted_net_pension_liability = recent_mfra.adjusted_net_pension_liability,
# MAGIC     three_year_average_adjusted_net_pension_liability = recent_mfra.three_year_average_adjusted_net_pension_liability,
# MAGIC     projected_benefit_obligation = recent_mfra.projected_benefit_obligation,
# MAGIC     fv_of_plan_assets = recent_mfra.fv_of_plan_assets,
# MAGIC     employer_contribution = recent_mfra.employer_contribution,
# MAGIC     discount_rate_as_reported_percent = recent_mfra.discount_rate_as_reported_percent,
# MAGIC     adjusted_discount_rate_percent = recent_mfra.adjusted_discount_rate_percent,
# MAGIC     funded_ratio_percent_per_gaap = recent_mfra.funded_ratio_percent_per_gaap,
# MAGIC     adjusted_funded_ratio_percent = recent_mfra.adjusted_funded_ratio_percent,
# MAGIC     overfunded_underfunded_as_reported = recent_mfra.overfunded_underfunded_as_reported,
# MAGIC     pension_costs = recent_mfra.pension_costs,
# MAGIC     net_pension_costs = recent_mfra.net_pension_costs,
# MAGIC     service_cost_component_as_reported = recent_mfra.service_cost_component_as_reported,
# MAGIC     on_behalf_payments = recent_mfra.on_behalf_payments
# MAGIC WHEN NOT MATCHED
# MAGIC   THEN INSERT *;
