# data-platform-iac
Infrastructure as code for the data platform, supporting resources in our AWS accounts

|         | Data Platform   | Databricks    |
|---------|-----------------|---------------|
| dev     | D_DATA_PLATFORM | SS_DATABRICKS |
| preview | S_DATA_PLATFORM | S_DATABRICKS  |
| prod    | P_DATA_PLATFORM | P_DATABRICKS  |


## Module Directory
1. [Databricks workspace configuration](./terraform/databricks/README.md)



## Submodule Directory

| **module_name**                                                                                | **description**                                                                                                                                                            | **safe to use outside of data-platform-iac** |
|------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|
| [availability_zone_selector](./terraform/modules/availability_zone_selector/README.md)         | Returns available AZs in the databricks AWS account for use when setting `zone_id` on a cluster. This is typically not needed unless `auto` zone selection is not working. | yes                                          |
| [catalog](./terraform/modules/catalog/README.md)                                               | Provisions a `databricks_catalog`, schemas within in, and manges security & data access inside of it.                                                                      | no                                           |
| [external_location](./terraform/modules/external_location/README.md)                           | Provisions a `databricks_external_location`. See README for details.                                                                                                       | yes                                          |
| [instance_profile](./terraform/modules/instance_profile/README.md)                             | Attaches an AWS IAM role to a databricks instance. #todo: set defualt permission for engineers                                                                             | yes                                          |
| [permissions](./terraform/modules/permissions)                                                 | Default permissions for various resources in Unity Catalog. Each permission set can be customized.                                                                         | yes                                          |
| [service_principal_token](./terraform/modules/service_principal_token/README.md)               | Provisions a token for a given service principal and stores it in a standardized vault location.                                                                           | yes**                                        |
| [storage_bucket](./terraform/modules/storage_bucket/README.md)                                 | S3 bucket with KMS encryption, used in all databricks account buckets.                                                                                                     | yes                                          |
| [token_policy](./terraform/modules/token_policy/README.md)                                     | Workspace configuration for what users are allowed to call the Databricks API via tokens.                                                                                  | no                                           |
| [workspace_variable_transformer](./terraform/modules/workspace_variable_transformer/README.md) | Utility to transform common variables between workspaces                                                                                                                   | yes                                          |


# Contributing
## Local Terraform Plans

Configure the following:


`~/.databrickscfg`
```text
[tf_sdlc]
host=https://cn-sdlc-databricks.cloud.databricks.com/
token=<YOUR_PERSONAL_TOKEN>
```

`~/.aws/config`
```text
[profile ss_databricks]
sso_account_id = 230176594509
sso_role_name = <YOUR_ROLE>
region = us-east-1
sso_region = us-east-1
sso_start_url = https://sullivancotter.awsapps.com/start#/
```


Running a terraform plan
```shell
vault login -method oidc role=data-platform
aws sso login
cd terraform/databricks
terraform workspace select sdlc
terraform plan -var-file=tfvars/sdlc.tfvars
```

## Applying Changes
Plans are automatically generated for all workspaces when a pull request is opened. Applying changes is restricted to automation
when a pull request is merged to main. `sdlc` changes are automatically applied on merge, while `preview` and `prod` require
additional deployment reviews.

## Docs
Most `README.md` in this project are governed by [terraform-docs](https://terraform-docs.io/user-guide/introduction/),
so ensure all variables have descriptions.
Extra notes about a module that are captured in `.header.md` will automatically be written to that modules `README.md`.

Dwight tried setting up a [GitHub Action](https://github.com/terraform-docs/gh-actions) to automatically update tf-docs,
but ran into issues. Until that is fixed, updating the entire module is as simple as

```shell
cd terraform/databricks
terraform-docs .
```

## Pre-commit hooks
https://github.com/antonbabenko/pre-commit-terraform#how-to-install

```shell
brew install pre-commit terraform-docs tflint tfsec checkov terrascan infracost tfupdate minamijoyo/hcledit/hcledit jq
pre-commit install
```
