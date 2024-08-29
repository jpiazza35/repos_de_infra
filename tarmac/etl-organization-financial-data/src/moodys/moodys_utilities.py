# Databricks notebook source
import re

from pyspark.sql.functions import concat, monotonically_increasing_id

# COMMAND ----------


def clean_name(column_name):
    """
    Reformats given name to correct format (all lowercase, no special characters, no spaces, no repeating underscores, leading and trailing characters must be letters)
    EX: Hello%World?-> hello_percent_world

    :returns: cleaned string
    """
    column_name = column_name.lower()
    replacement_dict = {
        "($000)": "",
        "($'000": "",
        "%": " percent ",
        "&": " and ",
        " ": "_",
        "-": "_",
        "/": "_",
        "(x)": "",
        "___": "_",
        "__": "_",
    }
    for key, value in replacement_dict.items():
        column_name = column_name.replace(key, value)

    column_name = re.sub("[^A-Za-z0-9_]+", "", column_name)
    column_name = column_name.strip("_")

    return column_name


# COMMAND ----------


def add_combo_column(df, first_combo_col, sec_combo_col):
    """
    Returns df with a new column 'combo' couples (first_combo_col, sec_combo_col)

    :param df: the target Dataframe
    :param first_combo_col: the first column to be used in 'combo'
    :param sec_combo_col: the second column to be used in 'combo'
    :returns: copy of df with the two additional columns
    """
    make_combo = df.select(concat(first_combo_col, sec_combo_col).alias("combo"))
    make_combo = make_combo.withColumn("mon_id", monotonically_increasing_id())

    df = df.withColumn("mon_id", monotonically_increasing_id())

    df = df.join(make_combo, df.mon_id == make_combo.mon_id, how="inner")
    df = df.drop("mon_id")
    return df
