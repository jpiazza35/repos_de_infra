# Databricks notebook source
args = dbutils.notebook.entry_point.getCurrentBindings()

# COMMAND ----------

import psycopg2

table_path = args["DELTA_TABLE"]
query_path = args["SQL_PATH"]

with open(query_path) as fd:
    query = fd.read()

# COMMAND ----------

df = spark.sql(query)

# COMMAND ----------

display(df)

# COMMAND ----------

from collections import Counter
counts = Counter(df.columns)
repeated_columns = [(item, count) for item, count in counts.items() if count > 1]

assert not repeated_columns, f"There are repeated columns: {repeated_columns}"

# COMMAND ----------

# Remove Table if exists
spark.sql(f"DROP TABLE IF EXISTS {table_path}")

# COMMAND ----------

df.write.format("delta") \
        .mode("overwrite") \
         .saveAsTable(table_path)

# COMMAND ----------

df.count()
