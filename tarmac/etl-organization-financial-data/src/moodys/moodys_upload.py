# Databricks notebook source
# MAGIC %md
# MAGIC Step 1: takes raw data and fixes the names and downloads to separate sheets

# COMMAND ----------

import pandas as pd
import re
from pyspark.sql.functions import concat
from pyspark.sql.functions import monotonically_increasing_id
from quinn import validate_presence_of_columns, validate_schema, DataFrameMissingStructFieldError, DataFrameMissingColumnError
import sys

path = '/dbfs/FileStore/mfra_data/Moodys_Raw_03_2023.xlsx'

# COMMAND ----------

# MAGIC %run ./moodys_utilities

# COMMAND ----------

def try_add_combo(df):
    try:
        validate_presence_of_columns(df, ["name", "years"])
    except DataFrameMissingColumnError:
        print("The name or years column is missing")
    else:
        combo_df = add_combo_column(df, df.name, df.years)
    return combo_df

# COMMAND ----------

def prepare_raw (df):
    for column in df.columns:
        df = df.withColumnRenamed(column, clean_name(column))
    # Renames existing 'unnamed_0' column to 'name'
    df = df.withColumnRenamed('unnamed_0', 'name')
    return df

# COMMAND ----------

dfs = []
# Read each excel sheet, replace NULL values in 'Unnamed: 0' with value from previous row, append to dfs
for x in range(3):
    data = pd.read_excel(io = path, sheet_name = x, skiprows = 8, engine='openpyxl')
    data['Unnamed: 0']  = data['Unnamed: 0'].ffill()
    df = spark.createDataFrame(data)
    dfs.append(df)

# Clean column names for each df and add 'combo' column
dfs2 = []
for df in dfs:
    df = prepare_raw(df)
    df = try_add_combo(df)
    dfs2.append(df)


# COMMAND ----------

financial_data = spark.read.table("source_oriented.default.moodys_financial")
OD_data = spark.read.table("source_oriented.default.moodys_OD")
ratio_data = spark.read.table("source_oriented.default.moodys_ratio")


# COMMAND ----------

try:
    validate_schema(dfs2[0], financial_data.schema)
    validate_schema(dfs2[1], OD_data.schema)
    validate_schema(dfs2[2], ratio_data.schema)
except DataFrameMissingStructFieldError:
    print("At least one of the schemas of the raw files is wrong")
    sys.exit(1)

# COMMAND ----------

dfs2[0].createOrReplaceTempView('recent_financial')
dfs2[1].createOrReplaceTempView('recent_OD')
dfs2[2].createOrReplaceTempView('recent_ratio')

# COMMAND ----------

# MAGIC %sql
# MAGIC MERGE INTO source_oriented.default.moodys_financial
# MAGIC USING recent_financial
# MAGIC ON moodys_financial.combo = recent_financial.combo
# MAGIC WHEN MATCHED THEN
# MAGIC   UPDATE SET
# MAGIC     name = recent_financial.name,
# MAGIC     years = recent_financial.years,
# MAGIC     current_senior_most_rating = recent_financial.current_senior_most_rating,
# MAGIC     revenue_backed_rating_description = recent_financial.revenue_backed_rating_description,
# MAGIC     state = recent_financial.state,
# MAGIC     moodys_org_id = recent_financial.moodys_org_id,
# MAGIC     type_of_organization = recent_financial.type_of_organization,
# MAGIC     accrued_interest_payable = recent_financial.accrued_interest_payable,
# MAGIC     due_to_3rd_party_payors = recent_financial.due_to_3rd_party_payors,
# MAGIC     current_portion_of_lt_debt = recent_financial.current_portion_of_lt_debt,
# MAGIC     short_term_debt = recent_financial.short_term_debt,
# MAGIC     other_current_liabilities = recent_financial.other_current_liabilities,
# MAGIC     total_current_liabilities = recent_financial.total_current_liabilities,
# MAGIC     short_term_operating_debt_operating_lines_etc = recent_financial.short_term_operating_debt_operating_lines_etc,
# MAGIC     salaries_and_benefits = recent_financial.salaries_and_benefits,
# MAGIC     supplies = recent_financial.supplies,
# MAGIC     bad_debt = recent_financial.bad_debt,
# MAGIC     interest_expense = recent_financial.interest_expense,
# MAGIC     depreciation_and_amortization = recent_financial.depreciation_and_amortization,
# MAGIC     research_expenses = recent_financial.research_expenses,
# MAGIC     recurring_transfer_to_affiliated_entity = recent_financial.recurring_transfer_to_affiliated_entity,
# MAGIC     other_expenditures = recent_financial.other_expenditures,
# MAGIC     total_expenses = recent_financial.total_expenses,
# MAGIC     operating_and_maintenance_expense = recent_financial.operating_and_maintenance_expense,
# MAGIC     operating_income = recent_financial.operating_income,
# MAGIC     board_designated_and_other_long_term_investments = recent_financial.board_designated_and_other_long_term_investments,
# MAGIC     bond_trustee_held_construction_funds_unspent_proceeds = recent_financial.bond_trustee_held_construction_funds_unspent_proceeds,
# MAGIC     bond_trustee_held_dsrf_or_debt_service_funds = recent_financial.bond_trustee_held_dsrf_or_debt_service_funds,
# MAGIC     property_plant_and_equipment_net = recent_financial.property_plant_and_equipment_net,
# MAGIC     accumulated_depreciation = recent_financial.accumulated_depreciation,
# MAGIC     self_insurance_funds = recent_financial.self_insurance_funds,
# MAGIC     pledges_receivable = recent_financial.pledges_receivable,
# MAGIC     pension_asset = recent_financial.pension_asset,
# MAGIC     due_from_3rd_party_payers_non_current = recent_financial.due_from_3rd_party_payers_non_current,
# MAGIC     other_non_current_assets = recent_financial.other_non_current_assets,
# MAGIC     total_assets = recent_financial.total_assets,
# MAGIC     unrestricted_net_assets = recent_financial.unrestricted_net_assets,
# MAGIC     temporarily_restricted_net_assets = recent_financial.temporarily_restricted_net_assets,
# MAGIC     permanently_restricted_net_assets = recent_financial.permanently_restricted_net_assets,
# MAGIC     total_net_assets = recent_financial.total_net_assets,
# MAGIC     contributions = recent_financial.contributions,
# MAGIC     other_revenues_and_expenses = recent_financial.other_revenues_and_expenses,
# MAGIC     smoothed_investment_income = recent_financial.smoothed_investment_income,
# MAGIC     excess_of_revenues_over_expenses = recent_financial.excess_of_revenues_over_expenses,
# MAGIC     principal_payments_on_debt = recent_financial.principal_payments_on_debt,
# MAGIC     total_debt_service = recent_financial.total_debt_service,
# MAGIC     purchases_of_property_plant_and_equipment = recent_financial.purchases_of_property_plant_and_equipment,
# MAGIC     cash_and_investments = recent_financial.cash_and_investments,
# MAGIC     net_patient_accounts_receivable = recent_financial.net_patient_accounts_receivable,
# MAGIC     due_from_3rd_party_payors = recent_financial.due_from_3rd_party_payors,
# MAGIC     current_portion_of_trusteed_fund_for_debt_service = recent_financial.current_portion_of_trusteed_fund_for_debt_service,
# MAGIC     current_portion_of_construction_funds = recent_financial.current_portion_of_construction_funds,
# MAGIC     current_portion_of_self_insurance_funds = recent_financial.current_portion_of_self_insurance_funds,
# MAGIC     other_current_assets = recent_financial.other_current_assets,
# MAGIC     total_current_assets = recent_financial.total_current_assets,
# MAGIC     lt_debt = recent_financial.lt_debt,
# MAGIC     accrued_pension_liability = recent_financial.accrued_pension_liability,
# MAGIC     due_to_3rd_party_payers_non_current = recent_financial.due_to_3rd_party_payers_non_current,
# MAGIC     self_insurance_liabilities = recent_financial.self_insurance_liabilities,
# MAGIC     other_liabilities = recent_financial.other_liabilities,
# MAGIC     total_liabilities = recent_financial.total_liabilities,
# MAGIC     total_liabilities_and_net_assets = recent_financial.total_liabilities_and_net_assets,
# MAGIC     gains_losses_on_non_recurring_items = recent_financial.gains_losses_on_non_recurring_items,
# MAGIC     realized_gain_loss_on_investments = recent_financial.realized_gain_loss_on_investments,
# MAGIC     unrealized_gain_loss_on_investments = recent_financial.unrealized_gain_loss_on_investments,
# MAGIC     restricted_contributions = recent_financial.restricted_contributions,
# MAGIC     other_restricted_revenues_expenses = recent_financial.other_restricted_revenues_expenses,
# MAGIC     total_net_patient_service_revenues = recent_financial.total_net_patient_service_revenues,
# MAGIC     grants_and_contracts = recent_financial.grants_and_contracts,
# MAGIC     state_and_local_appropriations = recent_financial.state_and_local_appropriations,
# MAGIC     premium_revenue = recent_financial.premium_revenue,
# MAGIC     tax_revenue = recent_financial.tax_revenue,
# MAGIC     contributions_included_in_operating_revenue = recent_financial.contributions_included_in_operating_revenue,
# MAGIC     net_assets_released_from_restrictions_and_used_for_operations = recent_financial.net_assets_released_from_restrictions_and_used_for_operations,
# MAGIC     other_operating_revenue = recent_financial.other_operating_revenue,
# MAGIC     total_operating_revenues = recent_financial.total_operating_revenues,
# MAGIC     increase_decrease_in_unrestricted_net_assets = recent_financial.increase_decrease_in_unrestricted_net_assets,
# MAGIC     increase_decrease_in_restricted_net_assets = recent_financial.increase_decrease_in_restricted_net_assets,
# MAGIC     increase_decrease_in_net_assets = recent_financial.increase_decrease_in_net_assets
# MAGIC WHEN NOT MATCHED
# MAGIC   THEN INSERT *;

# COMMAND ----------

# MAGIC %sql
# MAGIC MERGE INTO source_oriented.default.moodys_OD
# MAGIC USING recent_OD
# MAGIC ON moodys_OD.combo = recent_OD.combo
# MAGIC WHEN MATCHED THEN
# MAGIC   UPDATE SET
# MAGIC     name = recent_OD.name,
# MAGIC     years = recent_OD.years,
# MAGIC     current_senior_most_rating = recent_OD.current_senior_most_rating,
# MAGIC     revenue_backed_rating_description = recent_OD.revenue_backed_rating_description,
# MAGIC     state = recent_OD.state,
# MAGIC     moodys_org_id = recent_OD.moodys_org_id,
# MAGIC     type_of_organization = recent_OD.type_of_organization,
# MAGIC     medicare_percent_of_gross_revenue = recent_OD.medicare_percent_of_gross_revenue,
# MAGIC     medicare_managed_care_percent_of_gross_revenue = recent_OD.medicare_managed_care_percent_of_gross_revenue,
# MAGIC     total_medicare_percent = recent_OD.total_medicare_percent,
# MAGIC     medicaid_percent_of_gross_revenue = recent_OD.medicaid_percent_of_gross_revenue,
# MAGIC     medicaid_managed_care_percent_of_gross_revenue = recent_OD.medicaid_managed_care_percent_of_gross_revenue,
# MAGIC     total_medicaid_percent = recent_OD.total_medicaid_percent,
# MAGIC     total_commercial_percent = recent_OD.total_commercial_percent,
# MAGIC     self_pay_percent_of_gross_revenue = recent_OD.self_pay_percent_of_gross_revenue,
# MAGIC     other_percent_of_gross_revenue = recent_OD.other_percent_of_gross_revenue,
# MAGIC     medicare_number_of_covered_lives = recent_OD.medicare_number_of_covered_lives,
# MAGIC     medicaid_number_of_covered_lives = recent_OD.medicaid_number_of_covered_lives,
# MAGIC     commercial_number_of_covered_lives = recent_OD.commercial_number_of_covered_lives,
# MAGIC     inpatient_revenue_percent_of_net_patient_revenue = recent_OD.inpatient_revenue_percent_of_net_patient_revenue,
# MAGIC     outpatient_revenue_percent_of_net_patient_revenue = recent_OD.outpatient_revenue_percent_of_net_patient_revenue,
# MAGIC     total_100_percent = recent_OD.total_100_percent,
# MAGIC     licensed_beds = recent_OD.licensed_beds,
# MAGIC     maintained_beds = recent_OD.maintained_beds,
# MAGIC     unique_patients = recent_OD.unique_patients,
# MAGIC     admissions = recent_OD.admissions,
# MAGIC     patient_days = recent_OD.patient_days,
# MAGIC     emergency_room_visits = recent_OD.emergency_room_visits,
# MAGIC     outpatient_visits = recent_OD.outpatient_visits,
# MAGIC     outpatient_surgeries = recent_OD.outpatient_surgeries,
# MAGIC     total_surgeries = recent_OD.total_surgeries,
# MAGIC     observation_stays = recent_OD.observation_stays,
# MAGIC     newborn_admissions = recent_OD.newborn_admissions,
# MAGIC     medicare_case_mix_index = recent_OD.medicare_case_mix_index,
# MAGIC     total_case_mix_index = recent_OD.total_case_mix_index,
# MAGIC     admissions_plus_observation_stays = recent_OD.admissions_plus_observation_stays,
# MAGIC     percent_change_in_admissions_and_observation_stays = recent_OD.percent_change_in_admissions_and_observation_stays,
# MAGIC     percent_change_in_outpatient_surgeries = recent_OD.percent_change_in_outpatient_surgeries,
# MAGIC     maintained_bed_occupancy = recent_OD.maintained_bed_occupancy,
# MAGIC     licensed_bed_occupancy = recent_OD.licensed_bed_occupancy,
# MAGIC     average_length_of_stay = recent_OD.average_length_of_stay
# MAGIC WHEN NOT MATCHED
# MAGIC   THEN INSERT *;

# COMMAND ----------

# MAGIC %sql
# MAGIC MERGE INTO source_oriented.default.moodys_ratio
# MAGIC USING recent_ratio
# MAGIC ON moodys_ratio.combo = recent_ratio.combo
# MAGIC WHEN MATCHED THEN
# MAGIC   UPDATE SET   
# MAGIC     name = recent_ratio.name,
# MAGIC     years = recent_ratio.years,
# MAGIC     current_senior_most_rating = recent_ratio.current_senior_most_rating,
# MAGIC     revenue_backed_rating_description = recent_ratio.revenue_backed_rating_description,
# MAGIC     state = recent_ratio.state,
# MAGIC     moodys_org_id = recent_ratio.moodys_org_id,
# MAGIC     type_of_organization = recent_ratio.type_of_organization,
# MAGIC     operating_cash_flow = recent_ratio.operating_cash_flow,
# MAGIC     net_revenues_available_for_debt_service = recent_ratio.net_revenues_available_for_debt_service,
# MAGIC     additions_to_pp_and_e = recent_ratio.additions_to_pp_and_e,
# MAGIC     operating_revenue = recent_ratio.operating_revenue,
# MAGIC     unrestricted_cash_and_investments = recent_ratio.unrestricted_cash_and_investments,
# MAGIC     total_adjusted_debt = recent_ratio.total_adjusted_debt,
# MAGIC     total_debt = recent_ratio.total_debt,
# MAGIC     net_debt = recent_ratio.net_debt,
# MAGIC     debt_service_reserve_and_debt_service_fund = recent_ratio.debt_service_reserve_and_debt_service_fund,
# MAGIC     maximum_annual_debt_service = recent_ratio.maximum_annual_debt_service,
# MAGIC     variable_rate_debt_percent_of_total_debt = recent_ratio.variable_rate_debt_percent_of_total_debt,
# MAGIC     fixed_rate_debt_percent_of_total_debt = recent_ratio.fixed_rate_debt_percent_of_total_debt,
# MAGIC     on_demand_debt_percent = recent_ratio.on_demand_debt_percent,
# MAGIC     cash_to_demand_debt_percent = recent_ratio.cash_to_demand_debt_percent,
# MAGIC     operating_margin_percent = recent_ratio.operating_margin_percent,
# MAGIC     operating_cash_flow_margin_percent = recent_ratio.operating_cash_flow_margin_percent,
# MAGIC     cash_on_hand_days = recent_ratio.cash_on_hand_days,
# MAGIC     cash_and_investments_to_total_debt_percent = recent_ratio.cash_and_investments_to_total_debt_percent,
# MAGIC     total_debt_to_cash_flow = recent_ratio.total_debt_to_cash_flow,
# MAGIC     mads_coverage_moodys_adjusted = recent_ratio.mads_coverage_moodys_adjusted,
# MAGIC     unrestricted_cash_and_investments_to_total_adjusted_debt_percent = recent_ratio.unrestricted_cash_and_investments_to_total_adjusted_debt_percent,
# MAGIC     bad_debt_as_a_percent_of_net_patient_revenue_percent = recent_ratio.bad_debt_as_a_percent_of_net_patient_revenue_percent,
# MAGIC     capital_spending_ratio = recent_ratio.capital_spending_ratio,
# MAGIC     age_of_plant = recent_ratio.age_of_plant,
# MAGIC     accounts_receivable_days = recent_ratio.accounts_receivable_days,
# MAGIC     average_payment_period = recent_ratio.average_payment_period,
# MAGIC     total_debt_to_operating_revenue_percent = recent_ratio.total_debt_to_operating_revenue_percent,
# MAGIC     total_debt_to_capitalization_percent = recent_ratio.total_debt_to_capitalization_percent,
# MAGIC     debt_service_coverage = recent_ratio.debt_service_coverage,
# MAGIC     mads_coverage_with_reported_investment_income = recent_ratio.mads_coverage_with_reported_investment_income,
# MAGIC     mads_as_a_percent_of_operating_expenses_percent = recent_ratio.mads_as_a_percent_of_operating_expenses_percent,
# MAGIC     smoothed_investment_income_to_nrads_percent = recent_ratio.smoothed_investment_income_to_nrads_percent,
# MAGIC     three_year_operating_revenue_cagr_percent = recent_ratio.three_year_operating_revenue_cagr_percent,
# MAGIC     excess_margin_percent = recent_ratio.excess_margin_percent,
# MAGIC     cushion_ratio = recent_ratio.cushion_ratio,
# MAGIC     current_ratio = recent_ratio.current_ratio,
# MAGIC     return_on_assets_percent = recent_ratio.return_on_assets_percent,
# MAGIC     return_on_equity_percent = recent_ratio.return_on_equity_percent,
# MAGIC     monthly_liquidity = recent_ratio.monthly_liquidity,
# MAGIC     monthly_days_cash_on_hand = recent_ratio.monthly_days_cash_on_hand,
# MAGIC     monthly_liquidity_to_demand_debt_percent = recent_ratio.monthly_liquidity_to_demand_debt_percent,
# MAGIC     annual_liquidity = recent_ratio.annual_liquidity,
# MAGIC     annual_days_cash_on_hand = recent_ratio.annual_days_cash_on_hand,
# MAGIC     annual_liquidity_to_demand_debt_percent = recent_ratio.annual_liquidity_to_demand_debt_percent,
# MAGIC     type_of_benefit_plan = recent_ratio.type_of_benefit_plan,
# MAGIC     adjusted_pension_liability = recent_ratio.adjusted_pension_liability,
# MAGIC     adjusted_net_pension_liability = recent_ratio.adjusted_net_pension_liability,
# MAGIC     three_year_average_adjusted_net_pension_liability = recent_ratio.three_year_average_adjusted_net_pension_liability,
# MAGIC     projected_benefit_obligation = recent_ratio.projected_benefit_obligation,
# MAGIC     fv_of_plan_assets = recent_ratio.fv_of_plan_assets,
# MAGIC     employer_contribution = recent_ratio.employer_contribution,
# MAGIC     discount_rate_as_reported_percent = recent_ratio.discount_rate_as_reported_percent,
# MAGIC     adjusted_discount_rate_percent = recent_ratio.adjusted_discount_rate_percent,
# MAGIC     funded_ratio_percent_per_gaap = recent_ratio.funded_ratio_percent_per_gaap,
# MAGIC     adjusted_funded_ratio_percent = recent_ratio.adjusted_funded_ratio_percent,
# MAGIC     overfunded_underfunded_as_reported = recent_ratio.overfunded_underfunded_as_reported,
# MAGIC     pension_costs = recent_ratio.pension_costs,
# MAGIC     net_pension_costs = recent_ratio.net_pension_costs,
# MAGIC     service_cost_component_as_reported = recent_ratio.service_cost_component_as_reported,
# MAGIC     on_behalf_payments = recent_ratio.on_behalf_payments
# MAGIC WHEN NOT MATCHED
# MAGIC   THEN INSERT *;
