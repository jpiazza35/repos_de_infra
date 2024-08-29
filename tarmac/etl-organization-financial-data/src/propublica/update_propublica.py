# Databricks notebook source
# MAGIC %md
# MAGIC Step 4: upload & update propublica data 

# COMMAND ----------

import re
import sys
from quinn import validate_schema, DataFrameMissingStructFieldError

# COMMAND ----------

# MAGIC %run ./moodys_utilities

# COMMAND ----------

# Convert NAs to null values
import pyspark.sql.functions as F
df = spark.read.csv("dbfs:/FileStore/mfra_data/Financial_Database.csv", header=True)


# for (column, ctype) in df.dtypes:
#     df = df.withColumn(column, F.col(column).replace("NA", None))

df = df.replace("NA", None)
# display(df)


try:
    test_propublica = spark.read.csv("dbfs:/FileStore/propublica_tmp_df", header=True)
    validate_schema(df, test_propublica.schema)
except DataFrameMissingStructFieldError:
    print("the schema of the raw propublica file is wrong; exiting workflow")
    sys.exit(1)
except:
    print("an exception occurred trying to read the temp propublica file")

df.write.csv("dbfs:/FileStore/propublica_tmp_df", mode="overwrite", header=True)
df2 = spark.read.csv("dbfs:/FileStore/propublica_tmp_df", header=True, inferSchema=True)


# COMMAND ----------

for column in df.columns:
    df2 = df2.withColumnRenamed(column, clean_name(column))

# COMMAND ----------

df2 = add_combo_column(df2, df2.id, df2.year)

# COMMAND ----------

df2 = df2.where(df2.id != 'NA')

# COMMAND ----------

try:
    test_propublica2 = spark.read.table('source_oriented.default.propublica_financials')
    validate_schema(df2, test_propublica2.schema)
except DataFrameMissingStructFieldError:
    print("the inferred schema of the propublica file is wrong; exiting workflow")
    sys.exit(1)
except:
    print("an exception occurred trying to read the inferred propublica file")

# COMMAND ----------

# df2.write.mode("overwrite").saveAsTable('source_oriented.default.propublica_financials')

# COMMAND ----------

df2.select('combo').distinct().count()

# COMMAND ----------

df2.count()

# COMMAND ----------

df2.createOrReplaceTempView('recent_propublica')

# COMMAND ----------

# MAGIC %sql
# MAGIC MERGE INTO source_oriented.default.propublica_financials
# MAGIC USING recent_propublica
# MAGIC ON propublica_financials.combo = recent_propublica.combo
# MAGIC WHEN MATCHED THEN
# MAGIC   UPDATE SET
# MAGIC     id = recent_propublica.id,
# MAGIC     quarter = recent_propublica.quarter,
# MAGIC     year = recent_propublica.year,
# MAGIC     cash_and_cash_equivalents = recent_propublica.cash_and_cash_equivalents,
# MAGIC     short_term_investments = recent_propublica.short_term_investments,
# MAGIC     current_portion_of_assets_limited_as_to_use = recent_propublica.current_portion_of_assets_limited_as_to_use,
# MAGIC     accounts_receivable = recent_propublica.accounts_receivable,
# MAGIC     current_assets = recent_propublica.current_assets,
# MAGIC     total_assets = recent_propublica.total_assets,
# MAGIC     current_portion_of_long_term_debt = recent_propublica.current_portion_of_long_term_debt,
# MAGIC     long_term_debt_less_current_portion = recent_propublica.long_term_debt_less_current_portion,
# MAGIC     current_liabilities = recent_propublica.current_liabilities,
# MAGIC     unrestricted_net_assets = recent_propublica.unrestricted_net_assets,
# MAGIC     total_net_assets = recent_propublica.total_net_assets,
# MAGIC     net_patient_service_revenue = recent_propublica.net_patient_service_revenue,
# MAGIC     health_plan_revenue = recent_propublica.health_plan_revenue,
# MAGIC     total_operating_revenue = recent_propublica.total_operating_revenue,
# MAGIC     salaries_and_wages = recent_propublica.salaries_and_wages,
# MAGIC     employee_benefits = recent_propublica.employee_benefits,
# MAGIC     supplies_expense = recent_propublica.supplies_expense,
# MAGIC     purchased_services = recent_propublica.purchased_services,
# MAGIC     depreciation_and_amortization = recent_propublica.depreciation_and_amortization,
# MAGIC     interest = recent_propublica.interest,
# MAGIC     total_operating_expenses = recent_propublica.total_operating_expenses,
# MAGIC     cash_provided_by_operating_activities = recent_propublica.cash_provided_by_operating_activities, 
# MAGIC     csba = recent_propublica.csba,
# MAGIC     governmental_payors = recent_propublica.governmental_payors,
# MAGIC     non_governmental_payors = recent_propublica.non_governmental_payors,
# MAGIC     py_accounts_receivable = recent_propublica.py_accounts_receivable
# MAGIC WHEN NOT MATCHED
# MAGIC   THEN INSERT *;

# COMMAND ----------


