catalogs = {
  source_oriented = {
    schemas = [
      "benchmark",
      "benchmark_prod",
      "cdc",
      "cms",
      "workforce_analytics",
      "insights360",
      "pna",
      "survey",
      "qtn_survey",
      "rfi_surveys",
      "repl_ces_public"
    ]
    catalog_grants = [
      {
        principal  = "dwb_sp"
        privileges = ["SELECT", "USE_CATALOG", "MODIFY", "REFRESH", "USE_SCHEMA"]
      },
      {
        principal  = "engineers_group"
        privileges = ["SELECT", "USE_CATALOG", "MODIFY", "REFRESH", "USE_SCHEMA", "CREATE_TABLE", "CREATE_MODEL", "USE_SCHEMA", "CREATE_FUNCTION", "EXECUTE"]
      }
    ]
    schema_grants = {
      rfi_surveys = [
        {
          principal  = "rfi_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY", "CREATE_TABLE"]
        },
        {
          principal  = "rfi_developer_group"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY", "CREATE_TABLE"]
        },
      ]
      benchmark_prod = [
        {
          principal  = "phy_wkfce_data_science_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      repl_ces_public = [
        {
          principal  = "survey_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "reltio_sp"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      survey = [
        {
          principal  = "survey_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "dwb_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
        }
      ],
      qtn_survey = [
        {
          principal  = "survey_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "dwb_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
        }
      ],
    }
  },
  domain_oriented = {
    schemas = [
      "ces",
      "external_survey",
      "job",
      "survey",
      "stg_mdm",
      "pub_mdm",
      "sbx_survey_team",
      "stg_survey",
      "pub_survey",
      "pub_pna_edw",
      "stg_pna_edw",
      "rfi_survey",
    ]
    catalog_grants = [
      {
        principal  = "dwb_sp"
        privileges = ["SELECT", "USE_CATALOG", "MODIFY", "REFRESH", "USE_SCHEMA"]
      },
      {
        principal  = "engineers_group"
        privileges = ["SELECT", "USE_CATALOG", "MODIFY", "REFRESH", "USE_SCHEMA", "CREATE_TABLE", "CREATE_MODEL", "USE_SCHEMA", "CREATE_FUNCTION", "EXECUTE"]
      }
    ]
    schema_grants = {
      stg_survey = [
        {
          principal  = "dwb_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
        },
        {
          principal  = "survey_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        }
      ],
      pub_survey = [
        {
          principal  = "dwb_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
        }
      ],
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
          principal  = "reltio_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY", "WRITE_VOLUME"]
        }
      ],
      pub_survey = [
        {
          principal  = "survey_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      sbx_survey_team = [
        {
          principal  = "survey_analysts_group"
          privileges = ["ALL_PRIVILEGES"]
        },
      ],
      pub_pna_edw = [
        {
          principal  = "pna_sp"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      stg_pna_edw = [
        {
          principal  = "pna_sp"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      rfi_survey = [
        {
          principal  = "rfi_developer_group"
          privileges = ["ALL_PRIVILEGES"]
        },
        {
          principal  = "survey_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "phy_wkfce_data_science_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ]
    }

  },
  usecase_oriented = {
    schemas = [
      "core_business",
      "rfi_users",
      "stg_survey_cuts",
      "pub_survey_cuts",
      "pub_auditbooks"
    ]
    schema_grants = {
      stg_survey_cuts = [
        {
          principal  = "mpt_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "benchmarks_sp"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "benchmark_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "survey_analysts_group",
          privileges = ["SELECT", "USE_SCHEMA"]
        }
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
        {
          principal  = "phy_wkfce_data_science_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "survey_analysts_group",
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "benchmarks_sp"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "benchmark_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        }
      ],
      rfi_users = [
        {
          principal  = "rfi_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY", "CREATE_TABLE"]
        },
        {
          principal  = "rfi_developer_group"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY", "CREATE_TABLE"]
        },
      ],
      pub_auditbooks = [
        {
          principal  = "auditbooks_user_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "survey_analysts_group",
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ]
    }
    catalog_grants = [
      {
        principal  = "engineers_group"
        privileges = ["SELECT", "USE_CATALOG", "MODIFY", "REFRESH", "USE_SCHEMA", "CREATE_TABLE", "CREATE_MODEL", "USE_SCHEMA", "CREATE_FUNCTION", "EXECUTE"]
      }
    ]
  },
  data_science = {
    schemas = ["jtcs", "test", "workforce_analytics_prod"]
    catalog_grants = [
      {
        principal  = "data_scientists_group"
        privileges = ["ALL_PRIVILEGES"]
      }
    ]
    # all privileges for all schemas to data_scientists_group. These schemas predated catalog_level grants
    # and so need explicit, schema level grants
    schema_grants = {
      jtcs = [
        {
          principal  = "data_scientists_group"
          privileges = ["ALL_PRIVILEGES"]
        }
      ],
      test = [
        {
          principal  = "data_scientists_group"
          privileges = ["ALL_PRIVILEGES"]
        }
      ],
      workforce_analytics_prod = [
        {
          principal  = "data_scientists_group"
          privileges = ["ALL_PRIVILEGES"]
        }
      ]
    }
  }
}

data_scientist_group_name                = "db_sdlc_scientist"
rfi_app_user_group_name                  = ""
mpt_developer_group_name                 = "db_sdlc_mpt_developers"
auditbooks_user_group_name               = "db_sdlc_ws_auditbooks"
phy_wkfce_data_science_group_name        = "db_sdlc_ws_physician_workforce_data_science"
workspace_id                             = "3835368488578306"
linked_catalog_names                     = ["domain_oriented"]
data_platform_account_id                 = "130145099123"
ces_bucket                               = "sca-ces-sandbox"
data_quality_bucket_url                  = "data-quality.sdlc.cliniciannexus.com"
survey_analyst_group_name                = "db_sdlc_ws_survey_analyst"
alteryx_databricks_service_account_email = "db_alx_sdlc_sa@cliniciannexus.com"
fivetran_service_account_id              = "fivetran_sa@cliniciannexus.com"
rfi_developer_group_name                 = "db_sdlc_rfi_developers"
file_api_role_arn                        = "arn:aws:iam::130145099123:role/sdlc_databricks_instance_role"
benchmark_developers_group_name          = "db_sdlc_benchmark_developers"

eks_oidc_arn      = "arn:aws:iam::946884638317:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/529145E6E0FAEA987CE65574123F2560"
eks_oidc_provider = "oidc.eks.us-east-1.amazonaws.com/id/529145E6E0FAEA987CE65574123F2560"

pna_bucket = "sc-edw-test-lake01-239450381840-us-east-1"
