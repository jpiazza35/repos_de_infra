# Databricks notebook source
from enum import Enum
from typing import List, Optional

from pyspark.sql import DataFrame
from pyspark.sql.functions import concat, lit, sha2


class DeidentificationType(Enum):
    HASH = 1
    REMOVE = 2


class DeidentificationRequestParameters:
    def __init__(
        self, column_name_list: List[str], deidentification_type: DeidentificationType
    ):
        self.column_name_list = column_name_list
        self.deidentification_type = deidentification_type


def deidentify( 
    df: DataFrame, params: DeidentificationRequestParameters, salt: Optional[str] = None
) -> DataFrame:
    """
    Accepts a DataFrame and processes identifiable columns included in the parameters
        according to the DeidentificationType included in the parameters. Returns a new
        DataFrame. Compatible with both batch and streaming Spark jobs.
    :param df: the dataframe to deidentify.
    :param params: DeidentificationRequestParameters containing Columns to deidentify
        and the type of deidentification requested.
    :param salt: String with salt value for hash
    :return: new DataFrame with the identifiable columns processed according to
        the requested deidentification type.
    """
    column_name_list = params.column_name_list
    deidentification_type = params.deidentification_type
    salt = "" if salt is None else salt

    if deidentification_type == DeidentificationType.HASH:
        # Perform hashing logic on identifiable columns
        for column in column_name_list:
            df = df.withColumn(column, sha2(concat(lit(salt), df[column]), 256))

    elif deidentification_type == DeidentificationType.REMOVE:
        # Remove identifiable columns from the DataFrame
        df = df.drop(*column_name_list)

    return df
