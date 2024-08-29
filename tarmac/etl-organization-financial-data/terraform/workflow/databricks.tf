resource "databricks_repo" "repository" {
  url  = "https://${var.github_username}:${var.github_enterprise_token}@github.com/clinician-nexus/etl-organization-financial-data.git"
  path = "/Repos/Data Platform/etl-organization-financial-data"
}

resource "databricks_job" "data_pipeline" {
  name = "etl-organization-financial-data"

  task {
    task_key = "ingest-moodys-mfra-data"

    new_cluster {
      spark_version      = var.spark_version
      node_type_id       = var.workflow_node_type
      num_workers        = 2
      data_security_mode = "SINGLE_USER"
    }

    library {
      pypi {
        package = "quinn"
      }
    }

    library {
      pypi {
        package = "openpyxl"
      }
    }

    library {
      pypi {
        package = "pandas"
      }
    }

    library {
      pypi {
        package = "xlrd>=1.0.0"
      }
    }

    notebook_task {
      notebook_path = "/Repos/Data Platform/etl-organization-financial-data/src/moodys/moodys_upload"
    }

  }

  task {
    task_key = "clean-moodys-mfra-data"

    new_cluster {
      spark_version      = var.spark_version
      node_type_id       = var.workflow_node_type
      num_workers        = 1
      data_security_mode = "SINGLE_USER"
    }
    notebook_task {
      notebook_path = "/Repos/Data Platform/etl-organization-financial-data/src/moodys/moodys_cleaning"
    }

    depends_on {
      task_key = "ingest-moodys-mfra-data"
    }

  }

  task {
    task_key = "clean-propublica-financials-data"

    new_cluster {
      spark_version      = var.spark_version
      node_type_id       = var.workflow_node_type
      num_workers        = 1
      data_security_mode = "SINGLE_USER"
    }

    library {
      pypi {
        package = "quinn"
      }
    }

    notebook_task {
      notebook_path = "/Repos/Data Platform/etl-organization-financial-data/src/propublica/update_propublica"
    }
  }

  task {
    task_key = "combine-organization-financials-data"

    new_cluster {
      spark_version      = var.spark_version
      node_type_id       = var.workflow_node_type
      num_workers        = 1
      data_security_mode = "SINGLE_USER"
    }

    notebook_task {
      notebook_path = "/Repos/Data Platform/etl-organization-financial-data/src/combine_all"
    }

    depends_on {
      task_key = "clean-moodys-mfra-data"
    }

    depends_on {
      task_key = "clean-propublica-financials-data"
    }
  }

  max_concurrent_runs = 1
  max_retries         = 0
  email_notifications {
    on_start   = []
    on_success = []
    on_failure = ["data-platform@cliniciannexus.com"]
  }
  timeout_seconds = 3600
  schedule {
    quartz_cron_expression = "0 0 0 * * ?"
    timezone_id            = "America/Chicago"
  }
}

resource "databricks_permissions" "job_permissions" {
  job_id = databricks_job.data_pipeline.id
  access_control {
    group_name       = "db_nonprod_ws01_admin"
    permission_level = "CAN_MANAGE"
  }

  access_control {
    group_name       = "db_nonprod_ws01_engineer"
    permission_level = "CAN_MANAGE"
  }

  access_control {
    group_name       = "db_nonprod_ws01_scientist"
    permission_level = "CAN_MANAGE_RUN"
  }

  access_control {
    group_name       = "db_nonprod_ws01_user"
    permission_level = "CAN_MANAGE_RUN"
  }

}
