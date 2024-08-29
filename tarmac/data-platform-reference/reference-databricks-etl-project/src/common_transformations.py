from pyspark.sql import functions as F

def transform_spark_dataframe(df):
    """Transform original dataset"""
    df = df.withColumn("new_column", F.lit("new_value"))
    return df