import dataclasses
import pytest
from typing import List, get_args
from unittest import TestCase

from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, DecimalType, ArrayType, \
    TimestampType

from simple_integration_service.pyspark_proto_helper_functs import get_spark_schema_for_proto, add_to_class_dependency, validate_schema
from tests.fixtures import FakeDataclass, FakeNameKeySet, FakeProtoSchema

add_to_class_dependency(FakeNameKeySet)
class TestProtoHelper(TestCase):

    def test_scratch(self):
        print(dataclasses.is_dataclass(get_args(List[FakeNameKeySet])[0]))

    def test_get_schema_for_proto_with_array(self):
        expected = StructType([
            StructField('standard_job_description', StringType(), True),
            StructField('standard_deviation', DecimalType(10, 0), True),
            StructField('current_offset', IntegerType(), True),
            StructField('current_serverdatetime', TimestampType(), True),
            StructField('survey_publisher_name_keysets', ArrayType(StructType(
                [StructField('name', StringType(), True),
                StructField('keys', ArrayType(IntegerType(), True), True)]), True)),
            StructField('percentiles', ArrayType(DecimalType(10, 0), True), True),
            StructField('percentiles_keysets', ArrayType(StructType([
                StructField('name', StringType()),
                StructField('key', StringType())
            ]))),
            StructField('percentiles_keyset', StructType([
                StructField('name', StringType()),
                StructField('key', StringType())
            ]))
        ])

        r = get_spark_schema_for_proto(FakeDataclass)
        print(r)
        self.assertEqual(expected.json(), r.json())


    def test_validate_schema(self):
        test_schema = StructType([
            StructField('field_name', StringType()),
            StructField('field_keyset', StructType([
                StructField('name', StringType()),
                StructField('key', StringType()),
            ])),
            StructField('field_keyset_list', ArrayType(StructType([
                StructField('name', StringType()),
                StructField('key', StringType()),
            ])), True),
            StructField('field_float', DecimalType())
        ])

        print(test_schema.json())

        self.assertTrue(validate_schema(test_schema, FakeProtoSchema))

