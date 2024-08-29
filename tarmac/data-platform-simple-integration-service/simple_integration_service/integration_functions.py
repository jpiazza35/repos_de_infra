from typing import Dict, List, Any

from pyspark.sql import DataFrame, Column
from pyspark.sql.functions import lit
from pyspark.sql.types import Row

from simple_integration_service.generated.com.cliniciannexus.dataplatform.services.mapping import DataMapping


def build_fq_source_column_name(source_object_name_pattern: str, column_name: str) -> str:
    return f"{source_object_name_pattern}.{column_name}"


def build_spark_mapping(data_mapping: DataMapping) -> Dict[str, Column]:
    return {
        em.target_element_metadata.element_name:
            lit(build_fq_source_column_name(om.source_object_name_pattern, em.source_element_metadata.element_name))
        for om in data_mapping.object_mappings
        for em in om.element_mappings
    }


def process_mapping(data_mapping: DataMapping,
                    data: DataFrame) -> DataFrame:
    """

    :param data_mapping: Mapping used to process the data.
    :param data: DataFrame containing all required source files joined together with columns named as:
    source_object_name_pattern.column_name
    :return: A correctly mapped Dataframe.
    """

    data.withColumns(build_spark_mapping(data_mapping=data_mapping))

    return data


def pivot_by_col_name_pattern(col_name_pattern: str, r: Row, remove_pattern: bool = False) -> Dict[str, Any]:
    """
    Will pivot row data to a dict by a specific name pattern
    :param col_name_pattern: string pattern.  Example: 'Percentile'
    :param r: row to transform
    :param remove_pattern: whether to remove the pattern from the resulting dictionary key.
    :return: a dict containing all the pivoted rows.
    """
    d = r.asDict()
    if remove_pattern:
        return {k.replace(col_name_pattern, ''): d[k] for k in d.keys() if col_name_pattern in k}
    else:
        return {k: d[k] for k in d.keys() if col_name_pattern in k}
