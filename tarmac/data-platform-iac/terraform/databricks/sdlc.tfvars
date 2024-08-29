catalogs = {
  source_oriented = {
    schemas = [
      "benchmark",
      "benchmark_prod",
      "cdc",
      "ces",
      "cms",
      "workforce_analytics",
      "insights360",
      "pna",
      "survey",
      "rfi_surveys"
    ]
    schema_grants = {
      rfi_surveys = [{
        principal  = "rfi_sp"
        privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
      }]
    }
  },
  domain_oriented = {
    schemas = ["ces", "external_survey", "job", "survey", "stg_mdm", "pub_mdm"]
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
      rfi_users = [{
        principal  = "rfi_sp"
        privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
      }]
    }
  },
  landing = {
    schemas                      = ["survey"]
    schemas_get_isolated_buckets = true
  }
  data_science = {
    schemas = ["jtcs", "test"]
  }
}
rfi_app_user_group_name  = ""
mpt_developer_group_name = "db_sdlc_mpt_developers"
workspace_id             = "3835368488578306"
linked_catalog_names     = ["domain_oriented"]
