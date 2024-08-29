catalogs = {
  source_oriented = {
    schemas = [
      "benchmark",
      "cdc",
      "ces",
      "cms",
      "workforce_analytics",
      "insights360",
      "pna",
      "survey",
      "rfi_surveys"
    ],
    schema_grants = {
      rfi_surveys = [
        {
          principal  = "rfi_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
        }
      ],
      ces = [
        {
          principal  = "db_prod_ws_survey_analyst"
          privileges = ["SELECT", "USE_SCHEMA"]
        }
      ],
    }
  },
  domain_oriented = {
    schemas = ["ces", "external_survey", "job", "survey", "pub_mdm", "stg_mdm"]
    schema_grants = {
      stg_mdm = [
        {
          principal  = "mpt_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      pub_mdm = [
        {
          principal  = "mpt_sp"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "mpt_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "db_prod_ws_survey_analyst"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
    }
  },
  usecase_oriented = {
    schemas = ["core_business", "survey_cuts", "rfi_users", "stg_survey_cuts", "pub_survey_cuts"]
    schema_grants = {
      # survey cuts is deprecated in favor of stg & pub
      survey_cuts = [
        {
          principal  = "mpt_sp"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "mpt_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      stg_survey_cuts = [
        {
          principal  = "mpt_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      pub_survey_cuts = [
        {
          principal  = "mpt_sp"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "mpt_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      rfi_users = [
        {
          principal  = "rfi_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
        }
      ]
    },

  },
  landing = {
    schemas                      = ["ces", "finance"]
    schemas_get_isolated_buckets = true
  }
}
rfi_app_user_group_name  = "db_prod_physician_rfi_application_user"
mpt_developer_group_name = "db_prod_mpt_developers"
workspace_id             = "8014465683629600"

# there are some deep cloned tables. ft1, mdm
linked_catalog_names = ["domain_oriented"]
bigeye_cluster_size  = "Large"
