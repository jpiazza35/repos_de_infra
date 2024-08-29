from argparse import ArgumentParser
from typing import Optional

from cn_databricks.deidentification import DeidentificationRequestParameters, DeidentificationType, deidentify
from cn_databricks.utils import get_spark

def deidentify_table(
    deidentification_type: str,
    column_name_list: str,
    source_table_name: str,
    target_table_name: Optional[str] = None,
    salt: Optional[str] = None,
):
    spark = get_spark()
    fq_name_arr =  source_table_name.split(".", 2) if target_table_name is None else target_table_name.split(".", 2)
    actual_target_table_name = f"{fq_name_arr[0]}.deid_{fq_name_arr[1]}.{fq_name_arr[2]}"
    source_df = spark.read.table(source_table_name)
    params = DeidentificationRequestParameters(
        column_name_list=column_name_list.split(","),
        deidentification_type=DeidentificationType[deidentification_type]
    )
    return deidentify(source_df, params, salt), actual_target_table_name


def main():
    argparse = ArgumentParser()
    required_kwargs = [
        "deidentification_type",
        "column_name_list",
        "source_table_name",
    ]
    optional_kwargs = [
        "target_table_name",
        "salt",
    ]
    for kwarg in required_kwargs:
        argparse.add_argument(f"--{kwarg}", required=True)
    for kwarg in optional_kwargs:
        argparse.add_argument(f"--{kwarg}", required=False)
    args = argparse.parse_args()
    target_df, target_table_name = deidentify_table(**vars(args))
    spark = get_spark()
    spark.sql(f"DROP TABLE IF EXISTS {target_table_name}")
    target_df.write.saveAsTable(target_table_name)

if __name__ == "__main__":
    main()
