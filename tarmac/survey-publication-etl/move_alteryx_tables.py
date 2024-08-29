# Databricks notebook source
args = dbutils.notebook.entry_point.getCurrentBindings()
source_tables = args["SOURCE_TABLES"]
dest_tables = args["DEST_TABLES"]

# COMMAND ----------

# Check if variables are list or string
source_tables = [s.strip() for s in source_tables.split(",")]
dest_tables = [d.strip() for d in dest_tables.split(",")]

assert len(source_tables) == len(dest_tables), "The amount of Source tables doesn't match with the amount of Dest Tables"

# COMMAND ----------

# (Over)write tables from hive_metastore to Unity Catalog

for source, dest in zip(source_tables, dest_tables):
    df = spark.table(f"hive_metastore.alteryx.{source}")
    df.write.option("mode","overwrite").saveAsTable(dest)

