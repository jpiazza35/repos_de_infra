#!/usr/bin/zsh
pip install --pre --force-reinstall "betterproto[compiler]" grpcio-tools

mkdir -p ./simple_integration_service/generated

python3 -m grpc_tools.protoc --python_betterproto_out="./simple_integration_service/generated/" \
-I "./protobuf" \
"$(find protobuf -name "*.proto")"
