locals {
  tags = {
    Team       = "Data Platform"
    Region     = "us-east-1"
    Project    = "data-platform-iac"
    Individual = "dwightwhitlock@cliniciannexus.com"
    Terraform  = true
  }
  default_spot_instance_policy = module.workspace_vars.env == "prod" ? "RELIABILITY_OPTIMIZED" : "COST_OPTIMIZED"
}


# force user to use terraform workspace, then have it configure the environment
module "workspace_vars" {
  source    = "../modules/workspace_variable_transformer"
  workspace = terraform.workspace
}

module "default_storage_credential" {
  source  = "../modules/storage_credential"
  env     = module.workspace_vars.env
  name    = "default"
  comment = "Provides access to buckets in the the workspace AWS account."

  # flag must be false for first init on workspace, then true
  # todo: improve flow on this
  enable_self_trust = true
}

# need to add the following group permissions

locals {
  # should a principal (service principal, user or group) require catalog or schema level permissions, they should be added here
  # this maps between the tfvars and the actual principal id
  additional_group_lookups = {
    benchmark_developers_group                   = var.benchmark_developers_group_name
    mpt_developers_group                         = var.mpt_developer_group_name
    engineers_group                              = data.databricks_group.data_engineers.display_name
    data_scientists_group                        = var.data_scientist_group_name
    survey_analysts_group                        = var.survey_analyst_group_name
    auditbooks_user_group                        = var.auditbooks_user_group_name
    physician_practice_managers_group            = var.physician_practice_managers_group_name
    phy_wkfce_data_science_group_name            = var.phy_wkfce_data_science_group_name
    governance_group_name                        = var.governance_group_name
    finance_analysts_group                       = var.finance_analysts_group_name
    marketing_analysts_group                     = var.marketing_analysts_group_name
    rfi_app_user_group_name                      = var.rfi_app_user_group_name
    survey_sandbox_readonly_group                = var.survey_sandbox_readonly_group_name
    physician_rfi_submissions_readonly_group     = var.physician_rfi_submissions_readonly_group_name
    rfi_developer_group                          = var.rfi_developer_group_name,
    cbu_emerging_markets_data_science_group_name = var.cbu_emerging_markets_data_science_group_name
    sdlc_ds_group                                = var.sdlc_ds_group_name
    preview_ds_group                             = var.preview_ds_group_name
  }

  deploy_dataworld = module.workspace_vars.env == "prod" ? true : false

  principal_lookup = merge({
    mpt_sp        = databricks_service_principal.mpt.application_id
    bigeye_sp     = databricks_service_principal.bigeye.application_id
    rfi_sp        = databricks_service_principal.rfi.application_id
    dataworld_sp  = local.deploy_dataworld ? databricks_service_principal.dataworld[0].application_id : null
    dwb_sp        = databricks_service_principal.survey-data-workbench-sp.application_id
    benchmarks_sp = databricks_service_principal.benchmarks_sp.application_id
    reltio_sp     = databricks_service_principal.reltio.application_id
    fivetran      = var.fivetran_service_account_id
    pna_sp        = databricks_service_principal.pna.application_id
  }, local.additional_group_lookups)

  global_catalog_grants = concat(
    [
      {
        # I recognize that we can directly access databricks_service_principal.bigeye.application_id,
        # but because the catalog module needs to do a lookup for groups, I'm treating SP and groups the same
        # Same applies for ddw sp
        principal  = "bigeye_sp"
        privileges = ["USE_CATALOG", "SELECT", "USE_SCHEMA"]
      }
    ],
    local.deploy_dataworld ? [
      {
        principal  = "dataworld_sp"
        privileges = ["USE_CATALOG", "SELECT", "USE_SCHEMA"]
      }
    ] : [],
    var.fivetran_service_account_id != "" ? [
      {
        principal  = "fivetran"
        privileges = ["USE_CATALOG", "SELECT", "USE_SCHEMA", "READ_VOLUME", "EXECUTE", "CREATE_SCHEMA"]
      }
    ] : []
  )
}

module "catalogs" {
  depends_on                   = [module.default_storage_credential]
  for_each                     = var.catalogs
  source                       = "../modules/catalog"
  catalog_name                 = each.key
  env                          = module.workspace_vars.env
  env_prefix                   = module.workspace_vars.env_prefix
  account_id                   = data.aws_caller_identity.current.account_id
  metastore_id                 = var.unity_catalog_metastore_id
  role_prefix                  = module.workspace_vars.role_prefix
  schemas                      = each.value.schemas
  schemas_get_isolated_buckets = each.value.schemas_get_isolated_buckets
  owner_service_principal_id   = data.databricks_current_user.terraform_sp.user_name

  # this isn't the cleanest, but it forces only one schema grant document to be created
  schema_grants    = each.value.schema_grants
  principal_lookup = local.principal_lookup


  storage_credential_iam_role = module.default_storage_credential.iam_role_name
  storage_credential_name     = module.default_storage_credential.storage_credential_name
  catalog_grants = concat(
    each.value.catalog_grants,
    local.global_catalog_grants,
  )
}

module "delta_share_catalogs" {
  for_each       = var.delta_share_catalogs
  source         = "../modules/delta_share_catalog"
  catalog_name   = each.key
  catalog_prefix = each.value.catalog_prefix
  metastore_id   = var.unity_catalog_metastore_id
  role_prefix    = module.workspace_vars.role_prefix
  share_name     = each.value.share_name
  provider_name  = each.value.provider_name
  comment        = each.value.comment
  isolation_mode = each.value.isolation_mode

  principal_lookup = local.principal_lookup

  catalog_grants = concat(
    each.value.catalog_grants,
    local.global_catalog_grants,
  )

}

# see import.tf. this was originally a catalog resource
# todo: add bucket policy to allow GetObject and PutObject from data platform accounts
locals {
  databricks_account_id = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions = ["s3:GetObject", "s3:PutObject"]
    effect  = "Allow"
    resources = [
      "arn:aws:s3:::external-location-${module.workspace_vars.env_prefix}-landing-${local.databricks_account_id}/*",
      "arn:aws:s3:::external-location-${module.workspace_vars.env_prefix}-landing-${local.databricks_account_id}",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.data_platform_account_id}:root"]
    }
  }
}

resource "aws_s3_bucket_policy" "landing_bucket_policy" {
  bucket = module.landing_external_location.bucket_name
  policy = data.aws_iam_policy_document.bucket_policy.json
}

module "landing_external_location" {
  source                      = "../modules/external_location"
  account_id                  = data.aws_caller_identity.current.id
  name                        = "${module.workspace_vars.env_prefix}-landing"
  role_prefix                 = module.workspace_vars.role_prefix
  storage_credential_iam_role = module.default_storage_credential.iam_role_name
  storage_credential_name     = module.default_storage_credential.storage_credential_name
}

# override default kms policy for landing bucket to allow data platform account write access for file-api
resource "aws_kms_key_policy" "kms_access" {
  key_id = module.landing_external_location.kms_key_id
  policy = jsonencode({
    Statement = [
      {
        Sid      = "Default KMS key policy"
        Action   = "kms:*"
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
      {
        Sid    = "Enable external write access"
        Action = "kms:GenerateDataKey"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.data_platform_account_id}:root"
        }

        Resource = "*"
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_s3_bucket_policy" "data_platform_write_to_landing" {
  bucket = module.landing_external_location.bucket_name
  policy = <<JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.data_platform_account_id}:root"
            },
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": [
                "${module.landing_external_location.bucket_arn}/*",
                "${module.landing_external_location.bucket_arn}"
            ]
        }
    ]
}
JSON
}


resource "databricks_catalog_workspace_binding" "bindings" {
  # these are external to the workspace
  for_each     = var.linked_catalog_names
  catalog_name = each.value
  workspace_id = var.workspace_id
}

module "global_pip_init" {
  source         = "../modules/pip_init_script"
  nexus_base_url = "sonatype.cliniciannexus.com"
  nexus_url      = "sonatype.cliniciannexus.com/repository/cn_pypi/simple"
  nexus_password = var.nexus_password
  nexus_user     = var.nexus_user

  bsr_password = var.bsr_password
  bsr_user     = var.bsr_user
}





data "vault_generic_secret" "vault_auth" {
  path = "data_platform/vault_service_token"
}

resource "databricks_secret_scope" "secret_scope" {
  name = "data-platform-secrets"
}

resource "databricks_secret_acl" "vault_read_engineer" {
  permission = "READ"
  principal  = data.databricks_group.data_engineers.display_name
  scope      = databricks_secret_scope.secret_scope.name
}

resource "databricks_secret_acl" "vault_manage" {
  permission = "MANAGE"
  principal  = data.databricks_current_user.terraform_sp.user_name
  scope      = databricks_secret_scope.secret_scope.name
}

resource "databricks_secret" "vault_url" {
  key          = "vault-url"
  scope        = databricks_secret_scope.secret_scope.name
  string_value = data.vault_generic_secret.vault_auth.data["url"]
}

resource "databricks_secret" "vault_token" {
  key          = "vault-token"
  scope        = databricks_secret_scope.secret_scope.name
  string_value = data.vault_generic_secret.vault_auth.data["token"]
}
