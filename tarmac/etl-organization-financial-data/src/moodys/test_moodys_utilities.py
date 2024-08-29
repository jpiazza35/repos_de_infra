# Databricks notebook source
# MAGIC %run ./moodys_utilities

# COMMAND ----------

from pyspark.sql import SparkSession

from moodys import moodys_utilities


# COMMAND ----------
def test_clean_names():
    test_names = {
        "Hello World": "hello_world",
        "($000)Financial-help (x)": "financial_help",
        "##$$@@?//good NAme": "good_name",
        "five% & two": "five_percent_and_two",
        "hello-": "hello",
        "hi___4": "hi_4",
        "money($'000)": "money",
        "($'000)": "",
        " /yup ": "yup",
        "!@#$^**~()_++{}:'.,.<>\\|[]?/;": "",
        "    column_name": "column_name",
    }

    for test_name, exp_name in test_names.items():
        assert moodys_utilities.clean_name(test_name) == exp_name

    assert not (moodys_utilities.clean_name("%&___%") == "percent_and_percent")
    assert not (moodys_utilities.clean_name("clean_____name") == "clean_name")


# COMMAND ----------


def test_add_combo_column():
    spark = SparkSession.builder.appName("integrity-tests").getOrCreate()

    data = [{"name": "Scottsdale HealthCare", "years": 2025}]
    df = spark.createDataFrame(data)
    df = moodys_utilities.add_combo_column(df, df.name, df.years)
    assert df.columns[2] == "combo"

    listColumns = df.columns
    assert not ("mon_id" in listColumns)

    # also check if years is a number and name is a string? but should be to even get to this point? yes for cleanign but not necessarily for upload
