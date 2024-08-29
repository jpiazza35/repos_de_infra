from dataclasses import dataclass
from datetime import datetime
from typing import List

import betterproto

@dataclass(eq=False, repr=False)
class FakeSubClass(betterproto.Message):
    name: str = betterproto.string_field(2)
    keys: List[int] = betterproto.int32_field(1)

@dataclass(eq=False, repr=False)
class FakeNameKeySet(betterproto.Message):
    name: str = betterproto.string_field(1)
    key: str = betterproto.message_field(2)
    
@dataclass(eq=False, repr=False)
class FakeDataclass(betterproto.Message):
    standard_job_description: str = betterproto.string_field(1)
    standard_deviation: float = betterproto.float_field(31)
    current_offset: int = betterproto.int32_field(32)
    current_serverdatetime: datetime = betterproto.message_field(34)
    survey_publisher_name_keysets: List[FakeSubClass] = betterproto.message_field(1)
    percentiles: List[float] = betterproto.float_field(35)
    percentiles_keysets: List["FakeNameKeySet"] = betterproto.message_field(3),
    percentiles_keyset: FakeNameKeySet = betterproto.message_field(4)


@dataclass(eq=False, repr=False)
class FakeProtoSchema(betterproto.Message):
    field_name: str = betterproto.message_field(1)
    field_keyset: "FakeNameKeySet" = betterproto.message_field(2)
    field_keyset_list: List[
        "FakeNameKeySet"
    ] = betterproto.message_field(3)
    field_float: float = betterproto.message_field(4)

