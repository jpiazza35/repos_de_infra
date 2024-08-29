from pyspark.sql import functions as F
from common_transformations import transform_spark_dataframe

# TODO: Add logging
# TODO: Add type hints
# TODO: Add docstrings
# TODO: Add exception handling
# TODO: Add schema validation
# TODO: Add data validation
# TODO: Add data quality checks
# TODO: Add data profiling
# TODO: Add configuration object 

def extract() -> Dict[str, DataFrame]:
    """Extract data from source"""
    dfs = dict()

    dfs["my_csv_data"] = spark.read.csv("s3://<bucket-name>/data.csv", header=True, inferSchema=True)
    dfs["source_oriented.ces.addresses"] = spark.read.table("source_oriented.ces.addresses")

    validate_data(dfs)

    return dfs

def transform(source_dfs: Dict[str, DataFrame]) -> Dict[str, DataFrame]:
    """Transform source datasets"""
    dfs = dict()

    validate_data(source_dfs)

    dfs["new_csv_data"] = transform_spark_dataframe(source_dfs["my_csv_data"])
    dfs["new_table_data"] = transform_spark_dataframe(source_dfs["source_oriented.ces.addresses"])

    validate_data(dfs)

    return dfs

def load(dfs: Dict[str, DataFrame]) -> None:
    """Load data into destination"""
    
    validate_data(dfs)

    dfs["new_csv_data"].write.mode("overwrite").parquet("s3://<bucket-name>/output.parquet")
    dfs["new_table_data"].write.mode("overwrite").parquet("s3://<bucket-name>/output.parquet")

def run():
    """Run ETL job"""
    df = extract()
    df = transform(df)
    load(df)