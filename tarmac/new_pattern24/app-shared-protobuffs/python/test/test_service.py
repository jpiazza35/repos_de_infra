import os
from unittest.mock import patch

import pytest
from cn_proto_utils.service import SchemaRegistryService
from google.protobuf.descriptor_pb2 import DescriptorProto, FileDescriptorSet
from pyspark.sql.types import (
    DecimalType,
    IntegerType,
    StringType,
    StructField,
    StructType,
)


@pytest.fixture
def schema_registry_service():
    host = "clinician-nexus.buf.dev:443"
    token = os.getenv("SCHEMA_REGISTRY_TOKEN")
    return SchemaRegistryService(host=host, token=token)


@pytest.mark.parametrize(
    "module, symbol, message_name",
    [
        (
            "clinician-nexus.buf.dev/cn-shared/app-shared-protobuffs",
            "cn.dataexchange.files.v1.FileRegistration",
            "FileRegistration",
        ),
    ],
)
def test_schema_registry_with_schema_exists(
    schema_registry_service, module, symbol, message_name
):
    response = schema_registry_service.get_message_descriptor_proto(
        module=module, symbol=symbol, message_name=message_name
    )
    assert isinstance(response, DescriptorProto)
    assert response.name == message_name


def test_schema_registry_without_schema_id(schema_registry_service):
    response = schema_registry_service.get_message_descriptor_proto(
        module="clinician-nexus.buf.dev/cn-shared/app-shared-protobuffs",
        symbol="cn.dataexchange.files.v1.FileRegistration",
    )

    assert isinstance(response, FileDescriptorSet)


def test_get_field_extensions(schema_registry_service):
    response = schema_registry_service.get_message_descriptor_proto(
        module="clinician-nexus.buf.dev/cn-shared/app-shared-protobuffs",
        symbol="cn.survey.app.v1.AppIncumbentSourceOriented",
        message_name="AppIncumbentSourceOriented",
    )

    assert isinstance(response, DescriptorProto)
    assert len(response.field[16].options.Extensions) > 0


def test_schema_registry_junk_symbol(schema_registry_service):
    with pytest.raises(Exception):
        schema_registry_service.get_message_descriptor_proto(
            module="clinician-nexus.buf.dev/cn-shared/app-shared-protobuffs",
            symbol="cn.dataexchange.files.v1.SurveySubmissionRequiredTagsJunk",
        )


@patch(
    "src.cn_proto_utils.service.get_precision_and_scale_from_metadata",
    return_value=(0, 0),
)
def test_build_survey_struct(mock_func, schema_registry_service):
    module = "clinician-nexus.buf.dev/cn-shared/data-exchange-framework"
    symbol = "cn.dataexchange.testing.v1"
    schema = "ExampleSheetA"
    expected = StructType(
        [
            StructField("Human Readable ID", IntegerType(), True),
            StructField("Human Readable String", StringType(), True),
            StructField("Human Readable Float", DecimalType(0, 0), True),
        ]
    )

    fields = schema_registry_service.get_message_descriptor_proto(
        module=module, symbol=symbol, message_name=schema
    )

    schema = schema_registry_service.generate_struct_type_from_buf(fields.field)

    for f1, f2 in zip(schema, expected):
        assert f1.name == f2.name
        assert f1.dataType == f2.dataType
        assert f1.nullable == f2.nullable
