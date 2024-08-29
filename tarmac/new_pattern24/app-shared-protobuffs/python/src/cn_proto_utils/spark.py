from dataclasses import dataclass
from typing import List, Tuple, Type, Optional

from cn.datagovernance.v1 import data_governance_framework_pb2
from cn_proto_utils.schema_registry import SchemaRegistryService
from google.protobuf.descriptor import FieldDescriptor
from google.protobuf.descriptor_pb2 import FieldDescriptorProto
from google.protobuf.json_format import MessageToDict
from google.protobuf.message import Message
from pyspark.sql import SparkSession
from pyspark.sql.types import (
    ArrayType,
    BooleanType,
    ByteType,
    DateType,
    DecimalType,
    IntegerType,
    LongType,
    StringType,
    StructField,
    StructType,
    TimestampType,
)

proto_type: dict = {
    getattr(FieldDescriptor, attr): attr
    for attr in dir(FieldDescriptor)
    if attr.startswith("TYPE")
}


class FieldDescriptorWrapper:
    """
    Utility class to wrap a FieldDescriptor, found in generated proto classes, and provide
    convenience methods for accessing the field's metadata.
    """

    proto_2_spark_type_mapping: dict = {
        FieldDescriptor.TYPE_DOUBLE: DecimalType(38, 6),
        FieldDescriptor.TYPE_FLOAT: DecimalType(38, 6),
        FieldDescriptor.TYPE_INT64: LongType(),
        FieldDescriptor.TYPE_UINT64: LongType(),
        FieldDescriptor.TYPE_INT32: IntegerType(),
        FieldDescriptor.TYPE_FIXED64: LongType(),
        FieldDescriptor.TYPE_FIXED32: IntegerType(),
        FieldDescriptor.TYPE_BOOL: BooleanType(),
        FieldDescriptor.TYPE_STRING: StringType(),
        FieldDescriptor.TYPE_GROUP: StructType(),
        FieldDescriptor.TYPE_MESSAGE: StructType(),
        FieldDescriptor.TYPE_BYTES: ByteType(),
        FieldDescriptor.TYPE_UINT32: IntegerType(),
        FieldDescriptor.TYPE_ENUM: StringType(),
        FieldDescriptor.TYPE_SFIXED32: IntegerType(),
        FieldDescriptor.TYPE_SFIXED64: LongType(),
        FieldDescriptor.TYPE_SINT32: IntegerType(),
        FieldDescriptor.TYPE_SINT64: LongType(),
    }

    def __init__(self, field: FieldDescriptor):
        self.field = field

    def is_required(self) -> bool:
        return self.field.GetOptions().Extensions[
            data_governance_framework_pb2.is_required
        ]

    def is_struct(self) -> bool:
        return self.field.type in [
            FieldDescriptor.TYPE_MESSAGE,
            FieldDescriptor.TYPE_GROUP,
        ]

    def is_array(self) -> bool:
        return self.field.label == FieldDescriptor.LABEL_REPEATED

    def get_proto_type(self) -> str:
        if self.is_struct():
            return self.field.message_type.name
        return proto_type[self.field.type]

    def get_metadata(self) -> dict:
        field_options = self.field.GetOptions()
        # List all the options and their values
        return {
            option_descriptor.name: value
            for option_descriptor, value in field_options.ListFields()
        }

    def get_python_type(self) -> type:
        if self.field.message_type:
            return self.field.message_type._concrete_class
        else:
            raise NotImplementedError


class FieldDescriptorProtoWrapper:
    """
    Utility class to wrap a FieldDescriptorProto, found from the FileDescriptorSet of the BSR api, and provide
    convenience methods for accessing the field's metadata.
    """

    proto_2_spark_type_mapping: dict = {
        FieldDescriptorProto.TYPE_DOUBLE: DecimalType(38, 6),
        FieldDescriptorProto.TYPE_FLOAT: DecimalType(38, 6),
        FieldDescriptorProto.TYPE_INT64: LongType(),
        FieldDescriptorProto.TYPE_UINT64: LongType(),
        FieldDescriptorProto.TYPE_INT32: IntegerType(),
        FieldDescriptorProto.TYPE_FIXED64: LongType(),
        FieldDescriptorProto.TYPE_FIXED32: IntegerType(),
        FieldDescriptorProto.TYPE_BOOL: BooleanType(),
        FieldDescriptorProto.TYPE_STRING: StringType(),
        FieldDescriptorProto.TYPE_GROUP: StructType(),
        FieldDescriptorProto.TYPE_MESSAGE: StructType(),
        FieldDescriptorProto.TYPE_BYTES: ByteType(),
        FieldDescriptorProto.TYPE_UINT32: IntegerType(),
        FieldDescriptorProto.TYPE_ENUM: StringType(),
        FieldDescriptorProto.TYPE_SFIXED32: IntegerType(),
        FieldDescriptorProto.TYPE_SFIXED64: LongType(),
        FieldDescriptorProto.TYPE_SINT32: IntegerType(),
        FieldDescriptorProto.TYPE_SINT64: LongType(),
    }

    def __init__(self, field: FieldDescriptorProto):
        self.field = field

    def get_field_extension(self, extension: FieldDescriptor):
        return self.field.options.Extensions[extension]

    def get_display_name(self) -> str:
        return self.field.name

    def get_metadata(self) -> dict:
        # List all the options and their values
        return MessageToDict(self.field.options)

    def is_required(self) -> bool:
        return self.get_field_extension(data_governance_framework_pb2.is_required)

    def is_struct(self) -> bool:
        return self.field.type in [
            FieldDescriptorProto.TYPE_MESSAGE,
            FieldDescriptorProto.TYPE_GROUP,
        ]

    def is_array(self) -> bool:
        return self.field.label == FieldDescriptorProto.LABEL_REPEATED

    def is_decimal(self) -> bool:
        return (
            self.field.type == FieldDescriptorProto.TYPE_DOUBLE
            or self.field.type == FieldDescriptorProto.TYPE_FLOAT
        )

    def get_precision_and_scale_from_metadata(self) -> Tuple[int, int]:
        precision = self.get_field_extension(data_governance_framework_pb2.precision)
        scale = self.get_field_extension(data_governance_framework_pb2.scale)
        return precision, scale

    def generate_spark_field_from_buf(
        self, schema_registry: SchemaRegistryService, module: str
    ):
        data_type = None
        if self.field.type not in self.proto_2_spark_type_mapping:
            raise Exception(f"Unsupported field type: {self.field.type}")

        if (
            self.field.type == FieldDescriptorProto.TYPE_MESSAGE
            and self.field.type_name.strip(".") == "google.protobuf.Timestamp"
        ):
            data_type = TimestampType()

        elif (
            self.field.type == FieldDescriptorProto.TYPE_MESSAGE
            and self.field.type_name.strip(".") == "google.type.Date"
        ):
            data_type = DateType()

        elif self.is_decimal():
            precision, scale = self.get_precision_and_scale_from_metadata()
            data_type = DecimalType(precision, scale)

        elif self.is_struct():
            symbol = self.field.type_name.strip(".")
            schema = symbol.split(".")[-1]
            fields = schema_registry.get_message_descriptor_proto(
                module=module, symbol=symbol, message_name=schema
            )
            data_type = StructType(
                [
                    self.generate_spark_field_from_buf(schema_registry, module)
                    for field in fields
                ]
            )
        struct_field = StructField(
            name=self.get_display_name(),
            dataType=data_type,
            metadata=self.get_metadata(),
        )
        struct_field.nullable = not self.is_required()
        return struct_field

    def generate_struct_type_from_buf(
            self,
            schema_registry_service: SchemaRegistryService,
            fields: List[FieldDescriptorProto],
            ignore_fields: Optional[List[str]] = None,
    ) -> StructType:
        """Return a Pyspark StructType from fields FieldDescriptorProto
        Args:
            schema_registry_service : SchemaRegistryService
            fields : List of FieldDescriptorProto
            ignore_fields: List of columns names to ignore and not convert into pyspark data type
        """
        ignore_fields = ignore_fields or []
        return StructType(
            [
                self.generate_spark_field_from_buf(schema_registry_service, field)
                for field in fields
                if field.name not in ignore_fields
            ]
        )

def generate_struct_type(proto_class: Type[Message]) -> StructType:
    m = proto_class()
    descriptor = m.DESCRIPTOR

    return StructType([generate_spark_field(field) for field in descriptor.fields])


def generate_spark_field(field: FieldDescriptor) -> StructField:
    if field.type not in FieldDescriptorWrapper.proto_2_spark_type_mapping:
        raise Exception(f"Unsupported field type: {field.type}")
    wrapper = FieldDescriptorWrapper(field)
    if (
        field.message_type
        and field.message_type.full_name == "google.protobuf.Timestamp"
    ):
        data_type = TimestampType()
    elif field.message_type and field.message_type.full_name == "google.type.Date":
        data_type = DateType()
    elif wrapper.is_struct():
        data_type = generate_struct_type(field.message_type._concrete_class)
    else:
        data_type = FieldDescriptorWrapper.proto_2_spark_type_mapping[field.type]

    if wrapper.is_array():
        data_type = ArrayType(data_type)

    return StructField(
        name=field.name,
        dataType=data_type,
        nullable=not wrapper.is_required(),
        metadata=wrapper.get_metadata(),
    )


@dataclass
class FieldMetadata:
    field_order: int
    field_name: str
    proto_type: str
    python_field_type: Type
    display_name: str
    is_required: bool
    is_struct: bool
    is_array: bool


def get_field_metadata(
    proto_class: Type[Message],
) -> List[FieldMetadata]:
    """
    This function will return a list of FieldMetadata objects for a given protobuf class.
    :param proto_class: A class generated from a protobuf
    :return: a list of FieldMetadata objects
    """
    m = proto_class()
    descriptor = m.DESCRIPTOR

    def _get_field_metadata(field: FieldDescriptor) -> FieldMetadata:
        display_name = field.GetOptions().Extensions[
            data_governance_framework_pb2.display_name
        ]
        wrapper = FieldDescriptorWrapper(field)
        return FieldMetadata(
            field_order=field.number,
            field_name=field.name,
            proto_type=wrapper.get_proto_type(),
            python_field_type=wrapper.get_python_type(),
            display_name=display_name,
            is_required=wrapper.is_required(),
            is_struct=wrapper.is_struct(),
            is_array=wrapper.is_array(),
        )

    return [_get_field_metadata(field) for field in descriptor.fields]


def create_delta_table_for_proto(
    proto_class: Type[Message], fq_table_name: str, spark_session: SparkSession
):
    """
    Create a Delta table with the schema of the proto class
    :param proto_class: a protobuf class
    :param fq_table_name: the fully qualified table name
    :return:
    """

    schema = generate_struct_type(proto_class)
    empty_df = spark_session.createDataFrame([], schema=schema)
    # Write the empty DataFrame as a Delta table
    empty_df.write.format("delta").save(fq_table_name)
