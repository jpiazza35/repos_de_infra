from typing import Optional, Union

import cn.datagovernance.v1.data_governance_framework_pb2 as dg  # import must remain to support custom field options
import grpc
from buf.reflect.v1beta1.file_descriptor_set_pb2 import (
    GetFileDescriptorSetRequest,
    GetFileDescriptorSetResponse,
)
from buf.reflect.v1beta1.file_descriptor_set_pb2_grpc import (
    FileDescriptorSetServiceStub,
)
from google.protobuf.descriptor_pb2 import DescriptorProto, FileDescriptorSet


class SchemaRegistryError(Exception):
    pass


class SchemaRegistryService:
    EXTENSIONS = [
        dg.display_name,
        dg.is_required,
        dg.is_key_field,
        dg.precision,
        dg.scale,
    ]

    def __init__(self, token: str):
        self.token = token
        # Create access token credentials
        credentials = grpc.access_token_call_credentials(token)
        # Load SSL credentials for secure channel
        ssl_creds = grpc.ssl_channel_credentials()
        # Compose the credentials
        composite_creds = grpc.composite_channel_credentials(ssl_creds, credentials)
        # Establish the channel with the composite credentials
        self.channel = grpc.secure_channel("buf.build:443", composite_creds)

    def get_message_descriptor_proto(
        self,
        module: str,
        symbol: str,
        message_name: Optional[str] = None,
        version: Optional[str] = None,
    ) -> Union[FileDescriptorSet, DescriptorProto]:
        """
        Get the descriptor proto for a given module and symbol. If schema_id is provided, return the descriptor proto,
        otherwise return the file descriptor set.
        """
        stub = FileDescriptorSetServiceStub(self.channel)
        request = GetFileDescriptorSetRequest(
            module=module,
            symbols=[symbol],
            version=version,
        )
        response: GetFileDescriptorSetResponse = stub.GetFileDescriptorSet(request)

        if not message_name:
            return response.file_descriptor_set

        for file in response.file_descriptor_set.file:
            for message in file.message_type:
                if message.name == message_name:
                    return message

        raise SchemaRegistryError(f"Could not find message {message_name} in response")
