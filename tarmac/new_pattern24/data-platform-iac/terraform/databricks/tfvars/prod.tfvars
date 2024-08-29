workspace_id = "8014465683629600"

# there are some deep cloned tables. ft1, mdm
linked_catalog_names = ["domain_oriented", "d_source_oriented", "d_usecase_oriented"]

catalogs = {
  source_oriented = {
    extra_catalog_grants = [
      {
        principal  = "db_prod_ws_readonly"
        privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT"]
      },
      {
        principal  = "dwb_sp"
        privileges = ["SELECT", "USE_CATALOG", "MODIFY", "REFRESH", "USE_SCHEMA"]
      },
    ]
    schemas = [
      "benchmark",
      "cdc",
      "repl_ces_public",
      "cms",
      "workforce_analytics",
      "insights360",
      "pna",
      "survey",
      "qtn_survey",
      "rfi_surveys",
      "repl_hubspot",
      "repl_benchmark_dbo"
    ],
    schema_grants = {
      repl_hubspot = [
        {
          principal  = "governance_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      benchmark = [
        {
          principal  = "data_scientists_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "phy_wkfce_data_science_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      repl_benchmark_dbo = [
        {
          principal  = "governance_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      workforce_analytics = [
        {
          principal  = "data_scientists_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      insights360 = [
        {
          principal  = "data_scientists_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      repl_hubspot = [
        {
          principal  = "finance_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "marketing_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      repl_ces_public = [
        {
          principal  = "governance_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
          }, {
          principal  = "finance_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "marketing_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "survey_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "phy_wkfce_data_science_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "dwb_sp"
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
        },
        {
          principal  = "data_scientists_group"
          privileges = ["SELECT", "USE_SCHEMA"]
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
      rfi_surveys = [
        {
          principal  = "rfi_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY", "CREATE_TABLE"]
        },
        # there is a dashboard that rfi users need to access
        {
          principal  = "rfi_app_user_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "physician_rfi_submissions_readonly_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
    }
  },
  domain_oriented = {
    extra_catalog_grants = [
      {
        principal  = "db_prod_ws_readonly"
        privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT"]
      },
      {
        principal  = "dwb_sp"
        privileges = ["SELECT", "USE_CATALOG", "MODIFY", "REFRESH", "USE_SCHEMA"]
      },
    ]
    schemas = [
      "external_survey",
      "job",
      "survey", # this is a temp schema while we migrate existing schema to this one
      "stg_survey",
      "pub_survey",
      "sbx_survey_team",
      "pub_mdm",
      "stg_mdm",
      "stg_survey",
      "pub_survey",
      "rfi_survey",
      "pub_pna_edw",
      "stg_pna_edw",
    ]
    schema_grants = {
      pub_survey = [
        {
          principal  = "dwb_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
        },
        {
          principal  = "survey_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        }
      ],
      stg_survey = [
        {
          principal  = "survey_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "dwb_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
        }
      ],
      stg_mdm = [
        {
          principal  = "governance_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "mpt_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      pub_mdm = [
        {
          principal  = "governance_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "mpt_sp"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "mpt_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
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
        {
          principal  = "survey_sandbox_readonly_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        }
      ],
      rfi_survey = [
        {
          principal  = "physician_practice_managers_group"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY", "CREATE_TABLE"]
        },
        {
          principal  = "physician_rfi_submissions_readonly_group"
          privileges = ["SELECT", "USE_SCHEMA"]
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
    }
  },
  usecase_oriented = {
    extra_catalog_grants = [
      {
        principal  = "db_prod_ws_readonly"
        privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT"]
      },
    ]
    schemas = [
      "core_business",
      "rfi_users",
      "stg_survey_cuts",
      "pub_survey_cuts",
      "pub_target_market",
      "pub_auditbooks",
      "sbx_consulting_physician_workforce",
      "consulting_physician_workforce",
      "sbx_consulting_emerging_markets",
      "consulting_emerging_markets",
    ]
    schema_grants = {
      pub_target_market = [
        {
          principal  = "finance_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "marketing_analysts_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      stg_survey_cuts = [
        {
          principal  = "mpt_developers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "survey_analysts_group",
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
        {
          principal  = "phy_wkfce_data_science_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
        {
          principal  = "survey_analysts_group",
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      rfi_users = [
        {
          principal  = "rfi_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY", "CREATE_TABLE"]
        },
        {
          principal  = "physician_practice_managers_group"
          privileges = ["SELECT", "USE_SCHEMA"]
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
      ],
      sbx_consulting_physician_workforce = [
        {
          principal  = "phy_wkfce_data_science_group_name"
          privileges = ["ALL_PRIVILEGES"]
        },
      ],
      consulting_physician_workforce = [
        {
          principal  = "phy_wkfce_data_science_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
      sbx_consulting_emerging_markets = [
        {
          principal  = "cbu_emerging_markets_data_science_group_name"
          privileges = ["ALL_PRIVILEGES"]
        },
      ],
      consulting_emerging_markets = [
        {
          principal  = "cbu_emerging_markets_data_science_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
    },
  },
  data_science = {
    schemas = ["jtcs", "test", "workforce_analytics_prod"]
    catalog_grants = [
      {
        principal  = "data_scientists_group"
        privileges = ["EXECUTE", "REFRESH", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "USE_SCHEMA"]
      }
    ]
    # same set of catalog grants for all schemas for data_scientists group because
    # catalog grants predate schema creation
    schema_grants = {
      jtcs = [
        {
          principal  = "data_scientists_group"
          privileges = ["EXECUTE", "REFRESH", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "USE_SCHEMA"]
        }
      ],
      test = [
        {
          principal  = "data_scientists_group"
          privileges = ["EXECUTE", "REFRESH", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "USE_SCHEMA"]
        }
      ],
      workforce_analytics_prod = [
        {
          principal  = "data_scientists_group"
          privileges = ["EXECUTE", "REFRESH", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "USE_SCHEMA"]
        }
      ]
    }
  },
}

delta_share_catalogs = {
  definitive_healthcare = {
    provider_name  = "definitive-healthcare"
    share_name     = "sullivan_cotter_117195"
    catalog_prefix = "external_"
    isolation_mode = "OPEN"
    catalog_grants = [
      {
        principal  = "reltio_sp"
        privileges = ["SELECT", "USE_SCHEMA"]
      },
      {
        principal  = "dataworld_sp"
        privileges = ["SELECT", "USE_SCHEMA"]
      },
      {
        principal  = "data_scientists_group"
        privileges = ["SELECT", "USE_SCHEMA"]
      },
      {
        principal  = "sdlc_ds_group"
        privileges = ["SELECT", "USE_SCHEMA"]
      },
      {
        principal  = "preview_ds_group"
        privileges = ["SELECT", "USE_SCHEMA"]
      }
    ]
  }
}

# Databricks Account Level Groups (managed externally by IT)
# WARNING: Production Group Memberships are sensitive and should be limited to internal associates on a need-basis only
rfi_app_user_group_name                       = "db_prod_physician_rfi_application_user"
mpt_developer_group_name                      = "db_prod_mpt_developers"
data_scientist_group_name                     = "db_prod_ws_scientist"
survey_analyst_group_name                     = "db_prod_ws_survey_analyst"
auditbooks_user_group_name                    = "db_prod_ws_auditbooks"
physician_practice_managers_group_name        = "db_prod_ws_physician_practice_managers"
phy_wkfce_data_science_group_name             = "db_prod_ws_physician_workforce_data_science"
governance_group_name                         = "db_prod_ws_governance"
finance_analysts_group_name                   = "db_prod_finance_analysts"
marketing_analysts_group_name                 = "db_prod_marketing_analysts"
survey_sandbox_readonly_group_name            = "db_prod_ws_survey_sandbox_readonly"
survey_developer_group_name                   = "db_prod_ws_survey_developers"
physician_rfi_submissions_readonly_group_name = "db_prod_ws_physician_rfi_submissions_readonly"
cbu_emerging_markets_data_science_group_name  = "db_prod_ws_cbu_emerging_markets_data_science"

# Databricks groups that are used in other workspaces
sdlc_ds_group_name    = "db_sdlc_scientist"
preview_ds_group_name = "db_preview_scientist"

# Additional Service Principals
fivetran_service_account_id = "fivetran_sa@cliniciannexus.com"

# non-default groups that should be granted token usage privileges
enable_token_use_group_names = [
  "db_prod_ws_survey_developers",
  "db_prod_ws_cbu_emerging_markets_data_science"
]

bigeye_cluster_size      = "2X-Small"
data_platform_account_id = "417425771013"
ces_bucket               = "sca-ces-prod"
data_quality_bucket_url  = "data-quality.cliniciannexus.com"

alteryx_databricks_service_account_email = "db_alx_prod_sa@cliniciannexus.com"
file_api_role_arn                        = "arn:aws:iam::417425771013:role/prod_databricks_instance_role"
fivetran_cluster_size                    = "Small"

eks_oidc_arn      = "arn:aws:iam::071766652168:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/3B996ACB055D2F42589CC5560D96347F"
eks_oidc_provider = "oidc.eks.us-east-1.amazonaws.com/id/3B996ACB055D2F42589CC5560D96347F"

pna_sql_endpoint_size                 = "2X-Small"
pna_sql_endpoint_spot_instance_policy = "RELIABILITY_OPTIMIZED"
pna_bucket                            = "sc-edw-prod-lake01-447179157197-us-east-1"