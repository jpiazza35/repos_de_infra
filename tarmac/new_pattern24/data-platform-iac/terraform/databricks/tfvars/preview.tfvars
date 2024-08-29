workspace_id = "2512791465891598"
# link to sdlc is for cloning 2023 survey submission data to the preview environment
linked_catalog_names = ["d_source_oriented", "d_domain_oriented"]
catalogs = {
  source_oriented = {
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
    extra_catalog_grants = [
      {
        principal  = "db_preview_readonly"
        privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT"]
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
      rfi_surveys = [
        {
          principal  = "rfi_sp"
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
        },
        # there is a dashboard that rfi users need to access
        {
          principal  = "rfi_app_user_group_name"
          privileges = ["SELECT", "USE_SCHEMA"]
        },
      ],
    }
  },
  domain_oriented = {
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
    extra_catalog_grants = [
      {
        principal  = "db_preview_readonly"
        privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT"]
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
      "pub_pna_edw",
      "stg_pna_edw",
      "rfi_survey",
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
    extra_catalog_grants = [
      {
        principal  = "db_preview_readonly"
        privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT"]
      },
      {
        principal  = "engineers_group"
        privileges = ["SELECT", "USE_CATALOG", "MODIFY", "REFRESH", "USE_SCHEMA", "CREATE_TABLE", "CREATE_MODEL", "USE_SCHEMA", "CREATE_FUNCTION", "EXECUTE"]
      }
    ]
    schemas = [
      "core_business",
      "survey_cuts", # deprecated.  will remove once all systems have migrated to stg & pub
      "rfi_users",
      "stg_survey_cuts",
      "pub_survey_cuts",
      "pub_target_market",
    "pub_auditbooks"]
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
          privileges = ["SELECT", "USE_SCHEMA", "MODIFY"]
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
      ]
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
  }

}

# Databricks Account Level Groups (managed externally by IT)
rfi_app_user_group_name                = "db_preview_physician_rfi_application_user"
mpt_developer_group_name               = "db_preview_mpt_developers"
data_scientist_group_name              = "db_preview_scientist"
survey_analyst_group_name              = "db_preview_ws_survey_analyst"
auditbooks_user_group_name             = "db_preview_ws_auditbooks"
physician_practice_managers_group_name = "db_preview_physician_practice_managers"
phy_wkfce_data_science_group_name      = "db_preview_physician_workforce_data_science"
governance_group_name                  = "db_preview_governance"
finance_analysts_group_name            = "db_preview_finance_analysts"
marketing_analysts_group_name          = "db_preview_marketing_analysts"
survey_sandbox_readonly_group_name     = "db_preview_survey_sandbox_readonly"
rfi_developer_group_name               = "db_preview_rfi_developers"

# Additional Service Principals
fivetran_service_account_id = "fivetran_sa@cliniciannexus.com"

# non-default groups that should be granted token usage privileges
enable_token_use_group_names = [
  #  "db_preview_survey_developers"
]

bigeye_cluster_size      = "2X-Small"
data_platform_account_id = "975050241955"
ces_bucket               = "sca-ces-staging"
data_quality_bucket_url  = "data-quality.preview.cliniciannexus.com"

alteryx_databricks_service_account_email = "db_alx_preview_sa@cliniciannexus.com"
file_api_role_arn                        = "arn:aws:iam::975050241955:role/preview_databricks_instance_role"

eks_oidc_arn      = "arn:aws:iam::071766652168:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/3B996ACB055D2F42589CC5560D96347F"
eks_oidc_provider = "oidc.eks.us-east-1.amazonaws.com/id/3B996ACB055D2F42589CC5560D96347F"

pna_bucket = "sc-edw-stg-lake01-239450381840-us-east-1"