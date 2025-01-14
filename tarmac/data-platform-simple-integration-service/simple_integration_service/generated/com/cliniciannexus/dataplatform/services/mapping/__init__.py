# Generated by the protocol buffer compiler.  DO NOT EDIT!
# sources: mapping-service-messages.proto
# plugin: python-betterproto
from dataclasses import dataclass
from datetime import datetime
from typing import List

import betterproto


@dataclass(eq=False, repr=False)
class ElementMetadata(betterproto.Message):
    element_order: int = betterproto.int32_field(1)
    element_name: str = betterproto.string_field(2)
    element_type: str = betterproto.string_field(3)
    element_description: str = betterproto.string_field(4)


@dataclass(eq=False, repr=False)
class DomainRegisteredAsset(betterproto.Message):
    fq_data_asset_id: str = betterproto.string_field(1)
    version_id: datetime = betterproto.message_field(2)
    asset_elements: List["ElementMetadata"] = betterproto.message_field(3)


@dataclass(eq=False, repr=False)
class ElementMapping(betterproto.Message):
    source_element_metadata: "ElementMetadata" = betterproto.message_field(1)
    target_element_metadata: "ElementMetadata" = betterproto.message_field(2)


@dataclass(eq=False, repr=False)
class ObjectMapping(betterproto.Message):
    source_object_name_pattern: str = betterproto.string_field(1)
    element_mappings: List["ElementMapping"] = betterproto.message_field(2)


@dataclass(eq=False, repr=False)
class DataMapping(betterproto.Message):
    registered_data_asset_id: str = betterproto.string_field(1)
    """Contemplates multipe source files/tables mapped to one target."""

    version_id: datetime = betterproto.message_field(2)
    object_mappings: List["ObjectMapping"] = betterproto.message_field(3)
