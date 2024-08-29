# Databricks notebook source
# MAGIC %md
# MAGIC Step 5: combine all data together (pdfs and moodys)

# COMMAND ----------

library(data.table)
library(plyr)
library(dplyr)
library(SparkR)
# library(fst)

sc_df_tmp = tableToDF("source_oriented.default.propublica_financials")
moodys_df_tmp = tableToDF("source_oriented.default.moodys_mfra")
moodys_map_tmp = tableToDF("source_oriented.default.moodys_propublica_org_financial_mapping")


# COMMAND ----------


moodys_df <- collect(moodys_df_tmp)
moodys_map <- collect(moodys_map_tmp)
sc_df <- collect(sc_df_tmp)

# COMMAND ----------

#Make all Moodys data have quarter = NA
moodys_df$quarter <- NA

# COMMAND ----------

new_df <- cbind(sc_id = moodys_map$CES[match(moodys_df$name, moodys_map$Moody_Name)], moodys_df)

# COMMAND ----------

#get rid of all rows with null total operatiing revenues
new_df <- new_df[!is.na(new_df$total_operating_revenues),]

# COMMAND ----------

#make df with only rows that have a quarter specified
quarter_df <- sc_df[!is.na(sc_df$quarter),]

# COMMAND ----------

#get rid of all entires with non-null quarters
sc_df <- sc_df[is.na(sc_df$quarter),]

# COMMAND ----------

#make new column that you can match on
new_df$combo <- paste0(new_df$sc_id, "_", new_df$years)
sc_df$combo <- paste0(sc_df$id, "_", sc_df$year)

# COMMAND ----------

#sc_df2 contains all rows that weren't in new_df
sc_df2 <- sc_df[!(sc_df$combo %in% new_df$combo),]

# COMMAND ----------

#delete combo column
sc_df2 <- subset(sc_df2, select = -c(combo))

# COMMAND ----------

#combine
sc_df2 <- rbind(quarter_df, sc_df2)

# COMMAND ----------

#get rid of rows again that have null tor
sc_df2 <- sc_df2[!is.na(sc_df2$total_operating_revenue),]

# COMMAND ----------

#make name column in sc_df2 equal to the SC_Finance_Name column where Id is wequal to Ces
sc_df2$name <- moodys_map$SC_Finance_Name[match(sc_df2$id, moodys_map$CES)]
#!!! Indices
sc_df2 <- sc_df2[, c(1,30,2:26)]
sc_df2 <- sc_df2[!is.na(sc_df2$name),]

# COMMAND ----------

#set column names of sc)df2
colnames(sc_df2) <- c("sc_id", "name", "quarter", "years", "cash_and_cash_equivalents", "short_term_investments", "current_portion_of_trusteed_fund_for_debt_service", "net_patient_accounts_receivable", "total_current_assets", "total_assets", "current_portion_of_lt_debt", "lt_debt", "total_current_liabilities", "unrestricted_net_assets", "total_net_assets", "total_net_patient_service_revenues", "premium_revenue", "total_operating_revenues", "salaries", "benefits", "supplies", "purchased_services", "depreciation_and_amortization", "interest_expense", "total_expenses", "operating_cash_flow", "csba")

# COMMAND ----------

# new column salaries and benefits, cash and investments, and total debt
sc_df2$'salaries_and_benefits' <- rowSums(sc_df2[, c("salaries", "benefits")], na.rm = TRUE)
sc_df2$'cash_and_investments' <- rowSums(sc_df2[, c("cash_and_cash_equivalents", "short_term_investments", "current_portion_of_trusteed_fund_for_debt_service")], na.rm = TRUE)
sc_df2$total_debt <- rowSums(sc_df2[, c("current_portion_of_lt_debt", "lt_debt")], na.rm = TRUE)
sc_df2$moodys <- "F"

# COMMAND ----------

#delete salaries column abd benefits column
sc_df2 <- subset(sc_df2, select = -c(salaries, benefits))

sc_df2$name <- ifelse(sc_df2$sc_id %in% moodys_map$CES & moodys_map$Moody_Name[match(sc_df2$sc_id, moodys_map$CES)] != "", moodys_map$Moody_Name[match(sc_df2$sc_id, moodys_map$CES)], moodys_map$SC_Finance_Name[match(sc_df2$sc_id, moodys_map$CES)])

new_df2 <- rbind.fill(new_df, sc_df2)

# COMMAND ----------

class(new_df2$py_accounts_receivable)

# COMMAND ----------

#more new columns -- or just giving columns new values
new_df2$cash_and_cash_equivalents <- sc_df$cash_and_cash_equivalents[match(interaction(new_df2$sc_id, new_df2$years), interaction(sc_df$id, sc_df$year))]
new_df2$short_term_investments <- sc_df$short_term_investments[match(interaction(new_df2$sc_id, new_df2$years), interaction(sc_df$id, sc_df$year))]
new_df2$purchased_services <- sc_df$purchased_services[match(interaction(new_df2$sc_id, new_df2$years), interaction(sc_df$id, sc_df$year))]
new_df2$csba <- sc_df$csba[match(interaction(new_df2$sc_id, new_df2$years), interaction(sc_df$id, sc_df$year))]
new_df3 <- new_df2[!is.na(new_df2$total_operating_revenues),]

# COMMAND ----------

new_df3$py_accounts_receivable <- NA

# COMMAND ----------


for(i in 1:nrow(new_df3)){
  year <- new_df3[i, "years"]
  if(!(year %like% "Most")){
    year <- as.numeric(year) - 1
    id <- new_df3[i, "sc_id"]
    number <- new_df3$net_patient_accounts_receivable[match(interaction(year, id), interaction(new_df3$years, new_df3$sc_id))]
    new_df3[i, 'py_accounts_receivable'] <- number
  }
}

# COMMAND ----------

new_df3$labor_cost_savings_ratio_percent <- round(new_df3$salaries_and_benefits / new_df3$total_operating_revenues * 100, 2)
new_df3$labor_cost_savings_ratio_percent <- ifelse(sign(new_df3$labor_cost_savings_ratio) == -1 | sign(new_df3$labor_cost_savings_ratio == 0), NA, new_df3$labor_cost_savings_ratio_percent)

# COMMAND ----------

new_df3$total_debt_to_capitalization_percent <- ifelse(is.na(new_df3$total_debt_to_capitalization_percent), round(rowSums(new_df3[, c("current_portion_of_lt_debt", "lt_debt")], na.rm = TRUE) / rowSums(new_df3[, c("current_portion_of_lt_debt", "lt_debt", "unrestricted_net_assets")], na.rm = TRUE) * 100, 2), new_df3$total_debt_to_capitalization_percent)
new_df3$total_debt_to_capitalization_percent <- ifelse(sign(new_df3$total_debt_to_capitalization_percent) == -1 | sign(new_df3$total_debt_to_capitalization_percent == 0), NA, new_df3$total_debt_to_capitalization_percent)

# COMMAND ----------

new_df3$operating_margin_percent <- ifelse(is.na(new_df3$operating_margin_percent), round((new_df3$total_operating_revenue - new_df3$total_expenses) / new_df3$total_operating_revenue * 100, 2), new_df3$operating_margin_percent)
new_df3$average_collection_period <- ifelse(is.na(new_df3$quarter), round(((new_df3$net_patient_accounts_receivable + new_df3$py_accounts_receivable) / 2) / new_df3$total_operating_revenue * 365, 2),
                                              ifelse(new_df3$quarter == "Q1", round(((new_df3$net_patient_accounts_receivable + new_df3$py_accounts_receivable) / 2) / new_df3$total_operating_revenue * 365 * .25, 2),
                                                     ifelse(new_df3$quarter == "Q2", round(((new_df3$net_patient_accounts_receivable + new_df3$py_accounts_receivable) / 2) / new_df3$total_operating_revenue * 365 * .5, 2), round(((new_df3$net_patient_accounts_receivable + new_df3$py_accounts_receivable) / 2) / new_df3$total_operating_revenue * 365 * .75, 2))))

# COMMAND ----------

for(i in 1:nrow(new_df3)){
  year <- new_df3[i, "years"]
  id <- new_df3[i, "sc_id"]
  if(year %in% c(2019, 2020, 2021)){
    year <- as.numeric(year) - 3
    number <- new_df3$total_operating_revenues[match(interaction(year, id), interaction(new_df3$years, new_df3$sc_id))]
    new_df3[i, "blah"] <- number
  }
}

# COMMAND ----------

exponent <- function(a, pow) (abs(a)^pow)*sign(a)
new_df3$three_year_operating_revenue_cagr_percent <- ifelse(is.na(new_df3$three_year_operating_revenue_cagr_percent) & new_df3$years %in% c(2019, 2020, 2021), round((exponent(new_df3$total_operating_revenues / new_df3$blah, 1/3) - 1) * 100, 2), new_df3$three_year_operating_revenue_cagr_percent)
new_df3$ebida_margin_percent <- round((rowSums(new_df3[, c("total_operating_revenues", "depreciation_and_amortization", "interest_expense")], na.rm = TRUE) - new_df3$total_expenses) / new_df3$total_operating_revenues * 100, 2)
new_df3$cash_ratio <- round(new_df3$cash_and_investments / new_df3$total_current_liabilities, 2)
new_df3$current_ratio <- ifelse(is.na(new_df3$current_ratio), round(new_df3$total_current_assets / new_df3$total_current_liabilities, 2), new_df3$current_ratio)
new_df3$operating_income <- ifelse(is.na(new_df3$operating_income), new_df3$total_operating_revenues - new_df3$total_expenses, new_df3$operating_income)

# COMMAND ----------

new_df3 <- subset(new_df3, select = -c(blah, combo))

# COMMAND ----------

#reorders data
new_df3 <- new_df3[, c(1:3, 174, 4:173, 175:185)]
new_df3 <- new_df3[with(new_df3, order(name, -years)),]

# COMMAND ----------

# No Quarterly
new_df3 <- new_df3[is.na(new_df3$quarter),]

# COMMAND ----------

new_df3$combo <- paste0(new_df3$sc_id, "_", new_df3$years)

# COMMAND ----------

new_df3 <- new_df3[!is.na(new_df3$sc_id),]

# COMMAND ----------

df <- as.DataFrame(new_df3)
createOrReplaceTempView(df, 'end_df')

# COMMAND ----------

# MAGIC %python
# MAGIC df = spark.sql("SELECT * FROM end_df")
# MAGIC df.write.mode("overwrite").saveAsTable('domain_oriented.default.organization_financials')

# COMMAND ----------

# MAGIC %python
# MAGIC df.select("combo").distinct().count()
# MAGIC df.groupBy("combo").count().display()
# MAGIC #NA_2020 and NA_2021 have duplicates - need to deal with this. for now, I just deleted all rows with id = NA

# COMMAND ----------

# MAGIC %python
# MAGIC df.count()

# COMMAND ----------

# MAGIC %sql
# MAGIC MERGE INTO domain_oriented.default.organization_financials
# MAGIC USING end_df
# MAGIC ON organization_financials.combo = end_df.combo
# MAGIC WHEN MATCHED THEN
# MAGIC   UPDATE SET
# MAGIC     sc_id = end_df.sc_id,
# MAGIC     name = end_df.name,
# MAGIC     years = end_df.years,
# MAGIC     on_behalf_payments = end_df.on_behalf_payments,
# MAGIC     current_senior_most_rating = end_df.current_senior_most_rating,
# MAGIC     revenue_backed_rating_description = end_df.revenue_backed_rating_description,
# MAGIC     state = end_df.state,
# MAGIC     moodys_org_id = end_df.moodys_org_id,
# MAGIC     type_of_organization = end_df.type_of_organization,
# MAGIC     accrued_interest_payable = end_df.accrued_interest_payable,
# MAGIC     due_to_3rd_party_payors = end_df.due_to_3rd_party_payors,
# MAGIC     current_portion_of_lt_debt= end_df.current_portion_of_lt_debt,
# MAGIC     short_term_debt = end_df.short_term_debt,
# MAGIC     other_current_liabilities = end_df.other_current_liabilities,
# MAGIC     total_current_liabilities = end_df.total_current_liabilities,
# MAGIC     short_term_operating_debt_operating_lines_etc = end_df.short_term_operating_debt_operating_lines_etc,
# MAGIC     salaries_and_benefits = end_df.salaries_and_benefits,
# MAGIC     supplies = end_df.supplies,
# MAGIC     bad_debt = end_df.bad_debt,
# MAGIC     interest_expense = end_df.interest_expense,
# MAGIC     depreciation_and_amortization = end_df.depreciation_and_amortization,
# MAGIC     research_expenses = end_df.research_expenses,
# MAGIC     recurring_transfer_to_affiliated_entity= end_df.recurring_transfer_to_affiliated_entity,
# MAGIC     other_expenditures = end_df.other_expenditures,
# MAGIC     total_expenses = end_df.total_expenses,
# MAGIC     operating_and_maintenance_expense = end_df.operating_and_maintenance_expense,
# MAGIC     operating_income= end_df.operating_income,
# MAGIC     board_designated_and_other_long_term_investments = end_df.board_designated_and_other_long_term_investments,
# MAGIC     bond_trustee_held_construction_funds_unspent_proceeds = end_df.bond_trustee_held_construction_funds_unspent_proceeds,
# MAGIC     bond_trustee_held_dsrf_or_debt_service_funds = end_df.bond_trustee_held_dsrf_or_debt_service_funds,
# MAGIC     property_plant_and_equipment_net = end_df.property_plant_and_equipment_net,
# MAGIC     accumulated_depreciation = end_df.accumulated_depreciation,
# MAGIC     self_insurance_funds = end_df.self_insurance_funds,
# MAGIC     pledges_receivable = end_df.pledges_receivable,
# MAGIC     pension_asset = end_df.pension_asset,
# MAGIC     due_from_3rd_party_payers_non_current = end_df.due_from_3rd_party_payers_non_current,
# MAGIC     other_non_current_assets = end_df.other_non_current_assets,
# MAGIC     total_assets = end_df.total_assets,
# MAGIC     unrestricted_net_assets = end_df.unrestricted_net_assets,
# MAGIC     temporarily_restricted_net_assets = end_df.temporarily_restricted_net_assets,
# MAGIC     permanently_restricted_net_assets = end_df.permanently_restricted_net_assets,
# MAGIC     total_net_assets = end_df.total_net_assets,
# MAGIC     contributions = end_df.contributions,
# MAGIC     other_revenues_and_expenses = end_df.other_revenues_and_expenses,
# MAGIC     smoothed_investment_income = end_df.smoothed_investment_income,
# MAGIC     excess_of_revenues_over_expenses = end_df.excess_of_revenues_over_expenses,
# MAGIC     principal_payments_on_debt = end_df.principal_payments_on_debt,
# MAGIC     total_debt_service = end_df.total_debt_service,
# MAGIC     purchases_of_property_plant_and_equipment = end_df.purchases_of_property_plant_and_equipment,
# MAGIC     cash_and_investments = end_df.cash_and_investments,
# MAGIC     net_patient_accounts_receivable = end_df.net_patient_accounts_receivable,
# MAGIC     due_from_3rd_party_payors = end_df.due_from_3rd_party_payors,
# MAGIC     current_portion_of_trusteed_fund_for_debt_service = end_df.current_portion_of_trusteed_fund_for_debt_service,
# MAGIC     current_portion_of_construction_funds = end_df.current_portion_of_construction_funds,
# MAGIC     current_portion_of_self_insurance_funds = end_df.current_portion_of_self_insurance_funds,
# MAGIC     other_current_assets = end_df.other_current_assets,
# MAGIC     total_current_assets = end_df.total_current_assets,
# MAGIC     lt_debt = end_df.lt_debt,
# MAGIC     accrued_pension_liability = end_df.accrued_pension_liability,
# MAGIC     due_to_3rd_party_payers_non_current= end_df.due_to_3rd_party_payers_non_current,
# MAGIC     self_insurance_liabilities = end_df.self_insurance_liabilities,
# MAGIC     other_liabilities = end_df.other_liabilities,
# MAGIC     total_liabilities = end_df.total_liabilities,
# MAGIC     total_liabilities_and_net_assets = end_df.total_liabilities_and_net_assets,
# MAGIC     gains_losses_on_non_recurring_items = end_df.gains_losses_on_non_recurring_items,
# MAGIC     realized_gain_loss_on_investments = end_df.realized_gain_loss_on_investments,
# MAGIC     unrealized_gain_loss_on_investments = end_df.unrealized_gain_loss_on_investments,
# MAGIC     restricted_contributions = end_df.restricted_contributions,
# MAGIC     other_restricted_revenues_expenses = end_df.other_restricted_revenues_expenses,
# MAGIC     total_net_patient_service_revenues = end_df.total_net_patient_service_revenues,
# MAGIC     grants_and_contracts = end_df.grants_and_contracts,
# MAGIC     state_and_local_appropriations = end_df.state_and_local_appropriations,
# MAGIC     premium_revenue = end_df.premium_revenue,
# MAGIC     tax_revenue = end_df.tax_revenue,
# MAGIC     contributions_included_in_operating_revenue = end_df.contributions_included_in_operating_revenue,
# MAGIC     net_assets_released_from_restrictions_and_used_for_operations = end_df.net_assets_released_from_restrictions_and_used_for_operations,
# MAGIC     other_operating_revenue = end_df.other_operating_revenue,
# MAGIC     total_operating_revenues = end_df.total_operating_revenues,
# MAGIC     increase_decrease_in_unrestricted_net_assets = end_df.increase_decrease_in_unrestricted_net_assets,
# MAGIC     increase_decrease_in_restricted_net_assets = end_df.increase_decrease_in_restricted_net_assets,
# MAGIC     increase_decrease_in_net_assets = end_df.increase_decrease_in_net_assets,
# MAGIC     medicare_percent_of_gross_revenue = end_df.medicare_percent_of_gross_revenue,
# MAGIC     medicare_managed_care_percent_of_gross_revenue = end_df.medicare_managed_care_percent_of_gross_revenue,
# MAGIC     total_medicare_percent = end_df.total_medicare_percent,
# MAGIC     medicaid_percent_of_gross_revenue = end_df.medicaid_percent_of_gross_revenue,
# MAGIC     medicaid_managed_care_percent_of_gross_revenue = end_df.medicaid_managed_care_percent_of_gross_revenue,
# MAGIC     total_medicaid_percent = end_df.total_medicaid_percent,
# MAGIC     total_commercial_percent = end_df.total_commercial_percent,
# MAGIC     self_pay_percent_of_gross_revenue = end_df.self_pay_percent_of_gross_revenue,
# MAGIC     other_percent_of_gross_revenue = end_df.other_percent_of_gross_revenue,
# MAGIC     medicare_number_of_covered_lives = end_df.medicare_number_of_covered_lives,
# MAGIC     medicaid_number_of_covered_lives = end_df.medicaid_number_of_covered_lives,
# MAGIC     commercial_number_of_covered_lives = end_df.commercial_number_of_covered_lives,
# MAGIC     inpatient_revenue_percent_of_net_patient_revenue = end_df.inpatient_revenue_percent_of_net_patient_revenue,
# MAGIC     outpatient_revenue_percent_of_net_patient_revenue = end_df.outpatient_revenue_percent_of_net_patient_revenue,
# MAGIC     total_100_percent = end_df.total_100_percent,
# MAGIC     licensed_beds = end_df.licensed_beds,
# MAGIC     maintained_beds = end_df.maintained_beds,
# MAGIC     unique_patients = end_df.unique_patients,
# MAGIC     admissions = end_df.admissions,
# MAGIC     patient_days = end_df.patient_days,
# MAGIC     emergency_room_visits = end_df.emergency_room_visits,
# MAGIC     outpatient_visits = end_df.outpatient_visits,
# MAGIC     outpatient_surgeries = end_df.outpatient_surgeries,
# MAGIC     total_surgeries = end_df.total_surgeries,
# MAGIC     observation_stays = end_df.observation_stays,
# MAGIC     newborn_admissions = end_df.newborn_admissions,
# MAGIC     medicare_case_mix_index = end_df.medicare_case_mix_index,
# MAGIC     total_case_mix_index = end_df.total_case_mix_index,
# MAGIC     admissions_plus_observation_stays = end_df.admissions_plus_observation_stays,
# MAGIC     percent_change_in_admissions_and_observation_stays = end_df.percent_change_in_admissions_and_observation_stays,
# MAGIC     percent_change_in_outpatient_surgeries = end_df.percent_change_in_outpatient_surgeries,
# MAGIC     maintained_bed_occupancy = end_df.maintained_bed_occupancy,
# MAGIC     licensed_bed_occupancy = end_df.licensed_bed_occupancy,
# MAGIC     average_length_of_stay= end_df.average_length_of_stay,
# MAGIC     operating_cash_flow = end_df.operating_cash_flow,
# MAGIC     net_revenues_available_for_debt_service = end_df.net_revenues_available_for_debt_service,
# MAGIC     additions_to_pp_and_e = end_df.additions_to_pp_and_e,
# MAGIC     operating_revenue = end_df.operating_revenue,
# MAGIC     unrestricted_cash_and_investments = end_df.unrestricted_cash_and_investments,
# MAGIC     total_adjusted_debt = end_df.total_adjusted_debt,
# MAGIC     total_debt = end_df.total_debt,
# MAGIC     net_debt = end_df.net_debt,
# MAGIC     debt_service_reserve_and_debt_service_fund = end_df.debt_service_reserve_and_debt_service_fund,
# MAGIC     maximum_annual_debt_service = end_df.maximum_annual_debt_service,
# MAGIC     variable_rate_debt_percent_of_total_debt = end_df.variable_rate_debt_percent_of_total_debt,
# MAGIC     fixed_rate_debt_percent_of_total_debt = end_df.fixed_rate_debt_percent_of_total_debt,
# MAGIC     on_demand_debt_percent = end_df.on_demand_debt_percent,
# MAGIC     cash_to_demand_debt_percent = end_df.cash_to_demand_debt_percent,
# MAGIC     operating_margin_percent = end_df.operating_margin_percent,
# MAGIC     operating_cash_flow_margin_percent = end_df.operating_cash_flow_margin_percent,
# MAGIC     cash_on_hand_days = end_df.cash_on_hand_days,
# MAGIC     cash_and_investments_to_total_debt_percent = end_df.cash_and_investments_to_total_debt_percent,
# MAGIC     total_debt_to_cash_flow = end_df.total_debt_to_cash_flow,
# MAGIC     mads_coverage_moodys_adjusted = end_df.mads_coverage_moodys_adjusted,
# MAGIC     unrestricted_cash_and_investments_to_total_adjusted_debt_percent= end_df.unrestricted_cash_and_investments_to_total_adjusted_debt_percent,
# MAGIC     bad_debt_as_a_percent_of_net_patient_revenue_percent= end_df.bad_debt_as_a_percent_of_net_patient_revenue_percent,
# MAGIC     capital_spending_ratio = end_df.capital_spending_ratio,
# MAGIC     age_of_plant = end_df.age_of_plant,
# MAGIC     accounts_receivable_days = end_df.accounts_receivable_days,
# MAGIC     average_payment_period = end_df.average_payment_period,
# MAGIC     total_debt_to_operating_revenue_percent = end_df.total_debt_to_operating_revenue_percent,
# MAGIC     total_debt_to_capitalization_percent = end_df.total_debt_to_capitalization_percent,
# MAGIC     debt_service_coverage = end_df.debt_service_coverage,
# MAGIC     mads_coverage_with_reported_investment_income = end_df.mads_coverage_with_reported_investment_income,
# MAGIC     mads_as_a_percent_of_operating_expenses_percent = end_df.mads_as_a_percent_of_operating_expenses_percent,
# MAGIC     smoothed_investment_income_to_nrads_percent = end_df.smoothed_investment_income_to_nrads_percent,
# MAGIC     three_year_operating_revenue_cagr_percent = end_df.three_year_operating_revenue_cagr_percent,
# MAGIC     excess_margin_percent = end_df.excess_margin_percent,
# MAGIC     cushion_ratio = end_df.cushion_ratio,
# MAGIC     current_ratio = end_df.current_ratio,
# MAGIC     return_on_assets_percent = end_df.return_on_assets_percent,
# MAGIC     return_on_equity_percent = end_df.return_on_equity_percent,
# MAGIC     monthly_liquidity = end_df.monthly_liquidity,
# MAGIC     monthly_days_cash_on_hand = end_df.monthly_days_cash_on_hand,
# MAGIC     monthly_liquidity_to_demand_debt_percent = end_df.monthly_liquidity_to_demand_debt_percent,
# MAGIC     annual_liquidity = end_df.annual_liquidity,
# MAGIC     annual_days_cash_on_hand = end_df.annual_days_cash_on_hand,
# MAGIC     annual_liquidity_to_demand_debt_percent = end_df.annual_liquidity_to_demand_debt_percent,
# MAGIC     type_of_benefit_plan = end_df.type_of_benefit_plan,
# MAGIC     adjusted_pension_liability = end_df.adjusted_pension_liability,
# MAGIC     adjusted_net_pension_liability = end_df.adjusted_net_pension_liability,
# MAGIC     three_year_average_adjusted_net_pension_liability = end_df.three_year_average_adjusted_net_pension_liability,
# MAGIC     projected_benefit_obligation = end_df.projected_benefit_obligation,
# MAGIC     fv_of_plan_assets = end_df.fv_of_plan_assets,
# MAGIC     employer_contribution = end_df.employer_contribution,
# MAGIC     discount_rate_as_reported_percent = end_df.discount_rate_as_reported_percent,
# MAGIC     adjusted_discount_rate_percent = end_df.adjusted_discount_rate_percent,
# MAGIC     funded_ratio_percent_per_gaap = end_df.funded_ratio_percent_per_gaap,
# MAGIC     adjusted_funded_ratio_percent = end_df.adjusted_funded_ratio_percent,
# MAGIC     overfunded_underfunded_as_reported = end_df.overfunded_underfunded_as_reported,
# MAGIC     pension_costs = end_df.pension_costs,
# MAGIC     net_pension_costs = end_df.net_pension_costs,
# MAGIC     service_cost_component_as_reported = end_df.service_cost_component_as_reported,
# MAGIC     quarter = end_df.quarter,
# MAGIC     cash_and_cash_equivalents = end_df.cash_and_cash_equivalents,
# MAGIC     short_term_investments = end_df.short_term_investments,
# MAGIC     purchased_services = end_df.purchased_services,
# MAGIC     csba = end_df.csba,
# MAGIC     moodys = end_df.moodys,
# MAGIC     py_accounts_receivable = end_df.py_accounts_receivable,
# MAGIC     labor_cost_savings_ratio_percent = end_df.labor_cost_savings_ratio_percent,
# MAGIC     average_collection_period = end_df.average_collection_period,
# MAGIC     ebida_margin_percent = end_df.ebida_margin_percent,
# MAGIC     cash_ratio = end_df.cash_ratio
# MAGIC WHEN NOT MATCHED
# MAGIC   THEN INSERT *;

# COMMAND ----------


