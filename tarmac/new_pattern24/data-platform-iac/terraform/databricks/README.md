<!-- BEGIN_TF_DOCS -->
# Databricks Workspace Configuration

## **Design Constraints for Databricks Configuration Management**

Our approach to managing Databricks configuration is subject to several design constraints, primarily divided between account-level configuration and workspace-level management.

### Account-Level Configuration
Account-level configurations, such as workspace provisioning, network settings, and user/group management, are handled by DevOps. This is managed separately in our [DevOps repository](https://github.com/clinician-nexus/data-platform-devops-iac/tree/main/terraform/databricks). Key points include:
- Groups are provisioned in Active Directory by the IT team.
- These groups are then synchronized to Databricks through this module.
- IT is responsible for the ongoing management of group memberships in Active Directory.

### Workspace-Level Management
The `data-platform` team is responsible for managing all aspects **inside** a Databricks workspace. Our responsibilities extend to deploying a variety of workspace-specific resources. Key aspects include:

- **Storage Configurations**: Setting up and managing storage options within the workspace, ensuring they align with data handling and processing requirements.

- **Data Catalogs and Schemas**: Creating and maintaining data catalogs and schemas that organize and structure the data effectively for easy access and analysis.

- **Service Principals**: Deploying service principals, which are automated users, to enable programmatic access and operations within the Databricks environment.

- **Workspace-Specific Databricks Resources**: Managing any other Databricks resources that are specific to a workspace. This could include clusters, jobs, notebooks, and more, depending on the workspace's needs.

- **Security and Access Control**: Importantly, all these resources must be secured according to the group memberships and roles defined in the account-level configuration. We ensure that the appropriate permissions and access controls are in place, reflecting the group structures provisioned in Active Directory by IT and synchronized to Databricks.

Our role is to ensure that everything within the workspace is optimally configured, secure, and aligned with both the broader organizational policies and the specific needs of our workspace users.

### Infrastructure-as-Code (IaC) Approach
We employ Infrastructure-as-Code (IaC) to manage Unity Catalog, aiming for consistency and auditability across workspaces. Key aspects include:
- Avoidance of "click-ops"; all configurations are codified.
- Terraform serves as the primary tool for transforming Unity Catalog (and other Databricks configurations) into IaC.

### Critical Terraform Resources
In our Terraform setup, two resources are particularly pivotal:

1. [`databricks_permissions`](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions#data-access-with-unity-catalog)
2. [`databricks_grants`](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grant)

The configuration of `databricks_permissions` is crucial because it **overwrites** any existing permissions of the same type unless imported. Changes made outside Terraform are also reset unless they are reflected in the configuration. This is a key reason why catalogs and schemas must be managed exclusively in this repository:

- **Catalogs and Schemas Management**: Since `databricks_permissions` can overwrite existing settings, catalogs and schemas need to be managed centrally to maintain consistency and control. This ensures that permissions are set and modified in a controlled manner, preventing conflicts or accidental overwrites.

- **Tables Management**: While catalogs and schemas are managed within this repository, tables are considered application-specific and are therefore outside its scope. Each application repository is responsible for the lifecycle and permissions of its tables. However, these tables operate within the inherited permission sets from the catalogs and schemas. This delineation ensures that application teams have the flexibility to manage their tables while adhering to the broader security and access framework established at the catalog and schema levels.

Our approach guarantees a structured and secure management of Databricks resources, aligning with our broader goals of consistency, auditability, and controlled access in the workspace.

## Process for Requesting Access to a Catalog or Schema

1. **Identify the Required Access**:
   - The user or team should first clearly identify the specific catalog or schema they need access to and the type of access required (e.g., read, write, admin).

2. **Submit an Access Request**:
   - The request should be made through a predefined channel, such as a ticketing system or an internal request form, including details such as the user's identity, the specific catalog or schema, and the type of access needed.

3. **Approval from Data-Platform Team**:
   - The `data-platform` team reviews the request for its validity and alignment with organizational policies. This may involve verifying the requester's role and the necessity of the access.

4. **Group Membership Verification**:
   - If the access request is approved, the team will check if the requester is part of an appropriate Active Directory group already synchronized to Databricks. If not, the requester may need to contact IT to be added to the relevant group.

5. **Update Terraform Configuration**:
   - The `data-platform` team updates the Terraform configuration to reflect the new access permissions. This step involves modifying the `databricks_permissions` and/or `databricks_grants` resources to include the new access rules.

6. **Apply Terraform Changes**:
   - The updated Terraform configuration is applied to update the permissions in the Databricks workspace.

7. **Notify the Requester**:
   - After successfully applying the Terraform changes, the requester is notified that they now have access to the specified catalog or schema.

8. **Monitoring and Compliance**:
   - Regular audits and compliance checks will be conducted to ensure that access permissions are in line with the organizational security policies.

This process ensures controlled, auditable access to catalogs and schemas, aligning with security and management policies and leveraging Infrastructure-as-Code for systematic application and tracking.

**\_Note\_** This process is not automated yet - reach out to #data-platform to begin a request, but the above is the general flow.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 1.27.0 |
| <a name="requirement_fivetran"></a> [fivetran](#requirement\_fivetran) | ~> 1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.37.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.27.0 |
| <a name="provider_fivetran"></a> [fivetran](#provider\_fivetran) | 1.1.13 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.25.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_artifact_bucket"></a> [artifact\_bucket](#module\_artifact\_bucket) | ../modules/storage_bucket | n/a |
| <a name="module_availability_zone_ids"></a> [availability\_zone\_ids](#module\_availability\_zone\_ids) | ../modules/availability_zone_selector | n/a |
| <a name="module_bigeye_sql_endpoint"></a> [bigeye\_sql\_endpoint](#module\_bigeye\_sql\_endpoint) | ../modules/sql_warehouse | n/a |
| <a name="module_bigeye_sql_endpoint_permission"></a> [bigeye\_sql\_endpoint\_permission](#module\_bigeye\_sql\_endpoint\_permission) | ../modules/permissions/sql_warehouse | n/a |
| <a name="module_catalogs"></a> [catalogs](#module\_catalogs) | ../modules/catalog | n/a |
| <a name="module_ces_external_location"></a> [ces\_external\_location](#module\_ces\_external\_location) | ../modules/external_location | n/a |
| <a name="module_cluster_usage_ds_chee"></a> [cluster\_usage\_ds\_chee](#module\_cluster\_usage\_ds\_chee) | ../modules/permissions/cluster | n/a |
| <a name="module_cluster_usage_ds_shahrukh"></a> [cluster\_usage\_ds\_shahrukh](#module\_cluster\_usage\_ds\_shahrukh) | ../modules/permissions/cluster | n/a |
| <a name="module_ddw_cluster_permissions"></a> [ddw\_cluster\_permissions](#module\_ddw\_cluster\_permissions) | ../modules/permissions/cluster | n/a |
| <a name="module_default_storage_credential"></a> [default\_storage\_credential](#module\_default\_storage\_credential) | ../modules/storage_credential | n/a |
| <a name="module_delta_share_catalogs"></a> [delta\_share\_catalogs](#module\_delta\_share\_catalogs) | ../modules/delta_share_catalog | n/a |
| <a name="module_dq_instance_profile"></a> [dq\_instance\_profile](#module\_dq\_instance\_profile) | ../modules/instance_profile | n/a |
| <a name="module_dwb_endpoint_permissions"></a> [dwb\_endpoint\_permissions](#module\_dwb\_endpoint\_permissions) | ../modules/permissions/sql_warehouse | n/a |
| <a name="module_dwb_sql_endpoint"></a> [dwb\_sql\_endpoint](#module\_dwb\_sql\_endpoint) | ../modules/sql_warehouse | n/a |
| <a name="module_file_notification_instance_profile"></a> [file\_notification\_instance\_profile](#module\_file\_notification\_instance\_profile) | ../modules/instance_profile | n/a |
| <a name="module_fivetran_sql_endpoint"></a> [fivetran\_sql\_endpoint](#module\_fivetran\_sql\_endpoint) | ../modules/sql_warehouse | n/a |
| <a name="module_fivetran_warehouse_permissions"></a> [fivetran\_warehouse\_permissions](#module\_fivetran\_warehouse\_permissions) | ../modules/permissions/sql_warehouse | n/a |
| <a name="module_global_pip_init"></a> [global\_pip\_init](#module\_global\_pip\_init) | ../modules/pip_init_script | n/a |
| <a name="module_instance_profile"></a> [instance\_profile](#module\_instance\_profile) | ../modules/instance_profile | n/a |
| <a name="module_landing_external_location"></a> [landing\_external\_location](#module\_landing\_external\_location) | ../modules/external_location | n/a |
| <a name="module_mpt_sql_endpoint"></a> [mpt\_sql\_endpoint](#module\_mpt\_sql\_endpoint) | ../modules/sql_warehouse | n/a |
| <a name="module_mpt_warehouse_permission"></a> [mpt\_warehouse\_permission](#module\_mpt\_warehouse\_permission) | ../modules/permissions/sql_warehouse | n/a |
| <a name="module_reltio_sql_endpoint"></a> [reltio\_sql\_endpoint](#module\_reltio\_sql\_endpoint) | ../modules/sql_warehouse | n/a |
| <a name="module_reltio_warehouse_permissions"></a> [reltio\_warehouse\_permissions](#module\_reltio\_warehouse\_permissions) | ../modules/permissions/sql_warehouse | n/a |
| <a name="module_survey_template_extracts_bucket"></a> [survey\_template\_extracts\_bucket](#module\_survey\_template\_extracts\_bucket) | ../modules/storage_bucket | n/a |
| <a name="module_survey_template_instance_profile"></a> [survey\_template\_instance\_profile](#module\_survey\_template\_instance\_profile) | ../modules/instance_profile | n/a |
| <a name="module_token_permissions"></a> [token\_permissions](#module\_token\_permissions) | ../modules/token_policy | n/a |
| <a name="module_tokens"></a> [tokens](#module\_tokens) | ../modules/service_principal_token | n/a |
| <a name="module_workspace_vars"></a> [workspace\_vars](#module\_workspace\_vars) | ../modules/workspace_variable_transformer | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_key_policy.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_kms_key_policy.kms_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_s3_bucket_policy.allow_access_from_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.data_platform_write_to_landing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.landing_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [databricks_access_control_rule_set.rfi_rule](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/access_control_rule_set) | resource |
| [databricks_catalog_workspace_binding.bindings](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/catalog_workspace_binding) | resource |
| [databricks_cluster.data_science_cluster_chee](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/cluster) | resource |
| [databricks_cluster.data_science_cluster_shahrukh](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/cluster) | resource |
| [databricks_cluster.dataworld](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/cluster) | resource |
| [databricks_cluster.survey_team_alteryx_compute](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/cluster) | resource |
| [databricks_group_role.data_engineer_dq_editor](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/group_role) | resource |
| [databricks_group_role.dq_editor_sdlc](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/group_role) | resource |
| [databricks_group_role.file_notification_instance_profile](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/group_role) | resource |
| [databricks_group_role.users](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/group_role) | resource |
| [databricks_instance_pool.survey_team_alteryx_compute_driver_pool](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/instance_pool) | resource |
| [databricks_instance_pool.survey_team_alteryx_compute_worker_pool](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/instance_pool) | resource |
| [databricks_permissions.survey_alteryx_cluster_usage](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/permissions) | resource |
| [databricks_secret.vault_token](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/secret) | resource |
| [databricks_secret.vault_url](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/secret) | resource |
| [databricks_secret_acl.vault_manage](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/secret_acl) | resource |
| [databricks_secret_acl.vault_read_engineer](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/secret_acl) | resource |
| [databricks_secret_scope.secret_scope](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/secret_scope) | resource |
| [databricks_service_principal.auditbook_etl_trigger](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [databricks_service_principal.auditbook_replicate_trigger](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [databricks_service_principal.bigeye](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [databricks_service_principal.benchmarks_sp](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [databricks_service_principal.data_quality](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [databricks_service_principal.dataworld](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [databricks_service_principal.file_ingestion_sp](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [databricks_service_principal.mpt](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [databricks_service_principal.reltio](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [databricks_service_principal.rfi](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [databricks_service_principal.survey-data-workbench-sp](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/service_principal) | resource |
| [fivetran_connector.repl_benchmark](https://registry.terraform.io/providers/fivetran/fivetran/latest/docs/resources/connector) | resource |
| [fivetran_connector.repl_ces](https://registry.terraform.io/providers/fivetran/fivetran/latest/docs/resources/connector) | resource |
| [fivetran_connector_schedule.repl_benchmark_connector_schedule](https://registry.terraform.io/providers/fivetran/fivetran/latest/docs/resources/connector_schedule) | resource |
| [fivetran_connector_schedule.repl_ces_connector_schedule](https://registry.terraform.io/providers/fivetran/fivetran/latest/docs/resources/connector_schedule) | resource |
| [fivetran_destination.databricks_source_oriented_catalog](https://registry.terraform.io/providers/fivetran/fivetran/latest/docs/resources/destination) | resource |
| [fivetran_group.databricks_source_oriented_catalog](https://registry.terraform.io/providers/fivetran/fivetran/latest/docs/resources/group) | resource |
| [vault_generic_secret.bigeye-creds](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [vault_generic_secret.dwb_secret](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_access_from_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dq_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.publisher_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.cross_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [databricks_current_user.terraform_sp](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/data-sources/current_user) | data source |
| [databricks_group.data_engineers](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/data-sources/group) | data source |
| [databricks_group.users](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/data-sources/group) | data source |
| [databricks_node_type.node](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/data-sources/node_type) | data source |
| [databricks_node_type.smallest](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/data-sources/node_type) | data source |
| [databricks_spark_version.latest](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/data-sources/spark_version) | data source |
| [databricks_spark_version.spark_scala](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/data-sources/spark_version) | data source |
| [vault_generic_secret.benchmark_credentials](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.ces_credentials](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.fivetran_service_account](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.vault_auth](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alteryx_databricks_service_account_email"></a> [alteryx\_databricks\_service\_account\_email](#input\_alteryx\_databricks\_service\_account\_email) | The Databricks account email address used for alteryx connections from the survey team | `any` | n/a | yes |
| <a name="input_auditbooks_user_group_name"></a> [auditbooks\_user\_group\_name](#input\_auditbooks\_user\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_bigeye_cluster_size"></a> [bigeye\_cluster\_size](#input\_bigeye\_cluster\_size) | n/a | `string` | `"2X-Small"` | no |
| <a name="input_bsr_password"></a> [bsr\_password](#input\_bsr\_password) | n/a | `any` | n/a | yes |
| <a name="input_bsr_user"></a> [bsr\_user](#input\_bsr\_user) | n/a | `any` | n/a | yes |
| <a name="input_catalogs"></a> [catalogs](#input\_catalogs) | n/a | <pre>map(<br>    object({<br>      catalog_grants = optional(<br>        list(<br>          object(<br>            {<br>              principal  = string<br>              privileges = list(string)<br>            }<br>          )<br>        ), []<br>      )<br>      schemas_get_isolated_buckets = optional(bool, false)<br>      schemas                      = list(string)<br>      schema_grants = optional(<br>        map(<br>          list(<br>            object(<br>              {<br>                principal  = string<br>                privileges = list(string)<br>              }<br>            )<br>          ),<br>        ), {}<br>      )<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_cbu_emerging_markets_data_science_group_name"></a> [cbu\_emerging\_markets\_data\_science\_group\_name](#input\_cbu\_emerging\_markets\_data\_science\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_ces_bucket"></a> [ces\_bucket](#input\_ces\_bucket) | Bucket for CES to be mounted as a read only external location | `any` | n/a | yes |
| <a name="input_data_platform_account_id"></a> [data\_platform\_account\_id](#input\_data\_platform\_account\_id) | Account ID for D\_DATA\_PLATFORM or P\_DATA\_PLATFORM | `any` | n/a | yes |
| <a name="input_data_quality_bucket_url"></a> [data\_quality\_bucket\_url](#input\_data\_quality\_bucket\_url) | n/a | `any` | n/a | yes |
| <a name="input_data_scientist_group_name"></a> [data\_scientist\_group\_name](#input\_data\_scientist\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | n/a | `string` | `"ad35a21f-129b-4626-884f-7ee496730a60"` | no |
| <a name="input_delta_share_catalogs"></a> [delta\_share\_catalogs](#input\_delta\_share\_catalogs) | n/a | <pre>map(<br>    object({<br>      provider_name  = string<br>      share_name     = string<br>      catalog_prefix = optional(string, "")<br>      catalog_grants = optional(<br>        list(<br>          object(<br>            {<br>              principal  = string<br>              privileges = list(string)<br>            }<br>          )<br>        ), []<br>      )<br>      schemas_get_isolated_buckets = optional(bool, false)<br>      schemas                      = list(string)<br>      schema_grants = optional(<br>        map(<br>          list(<br>            object(<br>              {<br>                principal  = string<br>                privileges = list(string)<br>              }<br>            )<br>          ),<br>        ), {}<br>      )<br>      isolation_mode = optional(string, "ISOLATED")<br>      comment        = optional(string, "Managed by Terraform")<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_eks_aws_account_ids"></a> [eks\_aws\_account\_ids](#input\_eks\_aws\_account\_ids) | n/a | `map` | <pre>{<br>  "dev": {<br>    "account_id": "946884638317",<br>    "name": "D_EKS"<br>  },<br>  "prod": {<br>    "account_id": "071766652168",<br>    "name": "P_EKS"<br>  },<br>  "qa": {<br>    "account_id": "063890802877",<br>    "name": "Q_EKS"<br>  }<br>}</pre> | no |
| <a name="input_eks_oidc_arn"></a> [eks\_oidc\_arn](#input\_eks\_oidc\_arn) | n/a | `any` | n/a | yes |
| <a name="input_eks_oidc_provider"></a> [eks\_oidc\_provider](#input\_eks\_oidc\_provider) | n/a | `any` | n/a | yes |
| <a name="input_enable_token_use_group_names"></a> [enable\_token\_use\_group\_names](#input\_enable\_token\_use\_group\_names) | List of groups that should be allowed to use tokens. This is in addition to the default groups. | `list(string)` | `[]` | no |
| <a name="input_file_api_role_arn"></a> [file\_api\_role\_arn](#input\_file\_api\_role\_arn) | n/a | `any` | n/a | yes |
| <a name="input_finance_analysts_group_name"></a> [finance\_analysts\_group\_name](#input\_finance\_analysts\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_fivetran_cluster_size"></a> [fivetran\_cluster\_size](#input\_fivetran\_cluster\_size) | n/a | `string` | `"2X-Small"` | no |
| <a name="input_fivetran_service_account_id"></a> [fivetran\_service\_account\_id](#input\_fivetran\_service\_account\_id) | n/a | `string` | `""` | no |
| <a name="input_governance_group_name"></a> [governance\_group\_name](#input\_governance\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_linked_catalog_names"></a> [linked\_catalog\_names](#input\_linked\_catalog\_names) | Catalogs external to the workspace that should be linked to this workspace. Useful for CLONE operations when promoting tables directly between workspaces. | `set(string)` | `[]` | no |
| <a name="input_marketing_analysts_group_name"></a> [marketing\_analysts\_group\_name](#input\_marketing\_analysts\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_mpt_developer_group_name"></a> [mpt\_developer\_group\_name](#input\_mpt\_developer\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_mpt_endpoint"></a> [mpt\_endpoint](#input\_mpt\_endpoint) | n/a | <pre>object({<br>    cluster_size     = optional(string, "2X-Small")<br>    min_num_clusters = optional(number, 1)<br>    max_num_clusters = optional(number, 2)<br>  })</pre> | n/a | yes |
| <a name="input_nexus_password"></a> [nexus\_password](#input\_nexus\_password) | Nexus password for global databricks authentication against nexus pip | `any` | n/a | yes |
| <a name="input_nexus_user"></a> [nexus\_user](#input\_nexus\_user) | Nexus user for global databricks authentication against nexus pip | `any` | n/a | yes |
| <a name="input_phy_wkfce_data_science_group_name"></a> [phy\_wkfce\_data\_science\_group\_name](#input\_phy\_wkfce\_data\_science\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_physician_practice_managers_group_name"></a> [physician\_practice\_managers\_group\_name](#input\_physician\_practice\_managers\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_physician_rfi_submissions_readonly_group_name"></a> [physician\_rfi\_submissions\_readonly\_group\_name](#input\_physician\_rfi\_submissions\_readonly\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_rfi_app_user_group_name"></a> [rfi\_app\_user\_group\_name](#input\_rfi\_app\_user\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_rfi_developer_group_name"></a> [rfi\_developer\_group\_name](#input\_rfi\_developer\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_survey_analyst_group_name"></a> [survey\_analyst\_group\_name](#input\_survey\_analyst\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_survey_developer_group_name"></a> [survey\_developer\_group\_name](#input\_survey\_developer\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_survey_sandbox_readonly_group_name"></a> [survey\_sandbox\_readonly\_group\_name](#input\_survey\_sandbox\_readonly\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_unity_catalog_metastore_id"></a> [unity\_catalog\_metastore\_id](#input\_unity\_catalog\_metastore\_id) | n/a | `any` | n/a | yes |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact_instance_profile"></a> [artifact\_instance\_profile](#output\_artifact\_instance\_profile) | n/a |
| <a name="output_artifact_s3_bucket"></a> [artifact\_s3\_bucket](#output\_artifact\_s3\_bucket) | n/a |
| <a name="output_bigeye_vault_secret_path"></a> [bigeye\_vault\_secret\_path](#output\_bigeye\_vault\_secret\_path) | n/a |
| <a name="output_data_workbench"></a> [data\_workbench](#output\_data\_workbench) | n/a |
| <a name="output_databricks_secrets"></a> [databricks\_secrets](#output\_databricks\_secrets) | n/a |
| <a name="output_mpt_sp_id"></a> [mpt\_sp\_id](#output\_mpt\_sp\_id) | n/a |
| <a name="output_reltio_vault_secret_path"></a> [reltio\_vault\_secret\_path](#output\_reltio\_vault\_secret\_path) | n/a |
| <a name="output_rfi_service_principal_application_id"></a> [rfi\_service\_principal\_application\_id](#output\_rfi\_service\_principal\_application\_id) | n/a |
<!-- END_TF_DOCS -->
