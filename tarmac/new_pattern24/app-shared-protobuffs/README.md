# app-shared-protobuffs

This repository is linked to the [Buf Schema Registry][1]. This is behind SSO, so request access through IT.
[1]: https://clinician-nexus.buf.dev/cn-shared/app-shared-protobuffs

# Tooling

Familiarize yourself with the [Buf CLI][2] and [schema registry][3].

[2]: https://buf.build/docs/ecosystem/cli-overview
[3]: https://buf.build/docs/bsr/introduction

## Mac

        brew install bufbuild/buf/buf

## Ubuntu

### Install

```shell
sudo apt update
sudo apt install nodejs npm
npm install @bufbuild/buf
```

### Add to ~/.zshrc

        buf="npx buf"

Generate code. Base python is currently implemented. Note that since we rely on external libraries,
we should follow those imports when generating.

        cd proto/
        buf generate --include-imports --include-wkt

Lint. Catch import mistakes, naming that defies convention, etc.

        buf lint

Format and auto fix files

        buf format -w

Check for breaking changes

        buf breaking

Compile protos into distributable binary format.

        buf build

Open a branch in the schema registry

        buf push --branch <BRANCH_NAME>

Check your branch for breaking changes against the main branch

        buf breaking --against 'https://github.com/foo/bar.git'

## Contributing

- Follow the [module layout][4] recommended by the schema registry, or else
  `buf lint` will break.

[4]: https://buf.build/docs/bsr/module/configure#module-layout

## Tooling

### `pre-commit`

`pre-commit` provides configuration and execution of git hooks for custom
linting. See [pre-commit docs](https://pre-commit.com/).

#### Brew

```shell
brew install pre-commit
pre-commit install
```

#### Pip

```shell
pip install pre-commit
pre-commit install
```

## Using generated code & cn_protos utilities
`cn_protos` is a python library that contains some utility functions between protobuf and pyspark. In prior versions, this
also contained all the generated Python protobuf Message classes. We have since moved to BSR pro, which also adds support
for the Python generated SDKs. Therefore, we're removing generated classes from `cn_protos`. You can use each library like the following:

```shell
pip install cn_protos

# 

# grpc service stubs
pip install cn-shared-app-shared-protobuffs-grpc-python --extra-index-url https://clinician-nexus.buf.dev/gen/python
```

Reference the following for generated sdk documentation: https://clinician-nexus.buf.dev/cn-shared/app-shared-protobuffs/sdks/main

**Note**: All clusters and jobs in Databricks already have `extra-index-url` with authentication for `clinician-nexus.buf.dev` already
set up; you simply need to specify the package name and version


## Other Languages
You should use generated SDKs when possible. Ruby is not supported, so the github pipeline will call `buf generate` and push
the `.gem` to sonatype.



## Data Contracts

### Field level metadata

Some of our schemas are sourced from Excel files with names that are not
compliant with the Protobuf standard for field naming. For example, a CSV
may have a header `Organization ID (Required)`. Understanding that field
names [should be in lower snake case][5], we'll represent this as
`organization_id` within the protobuf.

We can track that mapping by extending google/protobuf/descriptor/FieldOptions.

We must maintain that:

1. Something in the schema must alert the driver that there are field to
   display name mappings.
2. Changes in a display name should be considered a schema change for the
   purpose of schema evolution.
3. Within a data contract, we should be able to perform serialization and
   deserialization operations between proto format and an arbitrary file format.

[5]: https://docs.confluent.io/platform/current/schema-registry/fundamentals/data-contracts.html#tags

[`data_governance_framework.proto`]()

```protobuf
syntax = "proto3";
import "google/protobuf/descriptor.proto";

extend google.protobuf.FieldOptions {
  string display_name = 1000;
  bool is_required = 1001;
}
```

`survey_app.proto`

```protobuf
syntax = "proto3";
package cn.PhysicianIncumbent.v1;
int32 organization_id = 1 [
    (cn.datagovernance.v1.display_name) = "Organization ID (Required)",
    (cn.datagovernance.v1.is_required) = true,
    (cn.datagovernance.v1.is_key_field) = true
  ]
```

**Note**: In the python client, we have noticed that when calling the
schema registry API, field extensions are not present _unless_ the generated
extended `FieldOptions` has been imported. If using `SchemaRegistryService`,
this should automatically be taken care of because it imports the following:

```python
# import must remain to support custom field options
import cn.datagovernance.v1.data_governance_framework_pb2 as dg
```

This also means that for any new field extension to be processed, you must
update the python client to include the latest changes.

