import dataclasses
import inspect
import re, json, sys
from dataclasses import fields
from datetime import datetime
from typing import get_args

from pyspark.sql.types import IntegerType, StringType, StructType, StructField, ArrayType, DecimalType, \
    TimestampType

type_map = {
    int: IntegerType(),
    str: StringType(),
    float: DecimalType(),
    datetime: TimestampType(),
}

class_dependencies = {}

def _parse_forward_ref(classname) -> dataclasses.dataclass:
    classnameMatch = re.match(r"ForwardRef\(\'([a-zA-Z0-9\_]+)", str(classname))
    return get_dependency_class(classnameMatch[1])

def _process_subclass(c) -> StructType:
    struct_type = StructType()

    for field in fields(c):
        struct_type.fields.append(_process_field(field))

    return struct_type

def _process_field(field) -> StructField:
    field_args = get_args(field.type)

    if 'List[' in str(field.type):
        if 'ForwardRef' in str(field_args[0]):
            return StructField(field.name,
                                ArrayType(_process_subclass(_parse_forward_ref(str(field_args[0])))),
                                field.default is not None)

        elif dataclasses.is_dataclass(field_args[0]):
            return StructField(field.name,
                               ArrayType(_process_subclass(field_args[0])),
                               field.default is not None)
        else:
            return StructField(
                field.name,
                ArrayType(type_map[field_args[0]]),
                field.default is not None)
    elif dataclasses.is_dataclass(field_args):
        return StructField(field.name,
                           _process_subclass(field.type),
                           field.default is not None)

    else:
        return StructField(
            field.name,
            type_map[field.type] if field.type in type_map else _process_subclass(get_dependency_class(field.type)),
            field.default is not None)


def get_spark_schema_for_proto(c) -> StructType:
    return _process_subclass(c)


class SchemaMismatchException(Exception):
    def __init__(self, actual_schema, expected_schema) -> None:
        self.actual_schema = actual_schema
        self.expected_schema = expected_schema
        
        super().__init__(f"""Expected Schema: {expected_schema}
            Actual Schema: {actual_schema}""")
    pass


def validate_schema(df_schema, proto_class: dataclasses.dataclass) -> bool:
    """
    Will validate a DataFrame schema against the schema of a dataclass generated from protobuf
    :param df: dataframe to validate
    :param proto_class: protobuf generated dataclass to validate against
    :exception will throw SchemaMismatchException if schema is not a match.
    """
    expected_schema = get_spark_schema_for_proto(proto_class).json()
    actual_schema = df_schema.json()

    # Decimal precision is not configurable by protobuf
    actual_schema = re.sub(r'decimal\([0-9]+\,[0-9]\)', 'decimal(10,0)', actual_schema)

    expected_schema = normalizeMetadata(expected_schema)
    actual_schema = normalizeMetadata(actual_schema)

    if actual_schema != expected_schema:
        raise SchemaMismatchException(expected_schema=expected_schema, actual_schema=actual_schema)
            
    return True

def add_to_class_dependency(classobj: dataclasses.dataclass) -> None:
    class_dependencies[classobj.__name__] = classobj

def get_dependency_class(classname: str):
    try:
        if inspect.isclass(classname):
            return classname
        if classname in class_dependencies:
            return class_dependencies[classname]
        else:
            return getattr(sys.modules[__name__], classname)
    except Exception as e:
        raise e

    

def normalizeMetadata(schema):
    newSchema = json.loads(schema) if type(schema) is str else schema.copy()

    for field in newSchema:
        try:
            del newSchema[field]['metadata']
        except:
            pass
        
        if type(newSchema[field]) is dict:
            newSchema[field] = normalizeMetadata(newSchema[field])

        if type(newSchema[field]) is list:
            for item in newSchema[field]:
                try:
                    del item['metadata']
                except:
                    pass
                
                if type(item) is dict:
                    item = normalizeMetadata(item)

    return json.dumps(newSchema)