resource "databricks_job" "job" {
  name = "batch-deid-${var.job_name}"

  job_cluster {
    job_cluster_key = "batch-deidentify-compute"

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

  dynamic "task" {
    for_each = var.deidentification_tasks
    content {
      task_key        = task.value.task_name
      job_cluster_key = "batch-deidentify-compute"

      python_wheel_task {
        entry_point = "deidentification"
        named_parameters = {
          "source_table_name"     = task.value.source_table_name
          "column_name_list"      = join(",", task.value.column_name_list)
          "deidentification_type" = task.value.deidentification_type
          "target_table_name"     = task.value.target_table_name
        }
        package_name = "cn_databricks"
      }

      library {
        whl = var.wheel_path
      }
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