resource "databricks_job" "job" {
  name = "${local.source_id}-batch-ingestion"

  job_cluster {
    job_cluster_key = "batch-ingest-compute"

    new_cluster {
      spark_version       = local.spark_version
      node_type_id        = local.node_type_id
      num_workers         = var.job_cluster.num_workers
      enable_elastic_disk = var.job_cluster.enable_elastic_disk

      autoscale {
        min_workers = var.job_cluster.min_workers
        max_workers = var.job_cluster.max_workers
      }

      aws_attributes {
        instance_profile_arn = var.instance_profile_arn
        first_on_demand      = var.job_cluster.min_workers + 1
        availability         = "ON_DEMAND"
      }
    }
  }

  schedule {
    quartz_cron_expression = var.cron_schedule
    timezone_id            = "US/Central"
    pause_status           = var.cron_schedule_enable ? "UNPAUSED" : "PAUSED"
  }

  task {
    task_key        = "single_ingestion_task"
    job_cluster_key = "batch-ingest-compute"

    python_wheel_task {
      entry_point      = var.entry_point
      named_parameters = var.named_parameters
      package_name     = var.package_name
    }

    library {
      whl = var.wheel_path
    }
  }

  tags = {
    Owner      = "data-platform"
    Repository = "data-platform-databricks-common"
  }

}

resource "databricks_permissions" "job_usage" {
  job_id = databricks_job.job.id

  access_control {
    group_name       = "${var.default_role_prefix}_admin"
    permission_level = "CAN_MANAGE"
  }

  access_control {
    group_name       = "${var.default_role_prefix}_engineer"
    permission_level = "CAN_MANAGE"
  }

  access_control {
    group_name       = "${var.default_role_prefix}_scientist"
    permission_level = "CAN_MANAGE_RUN"
  }

}