resource "databricks_job" "job" {
  name = "${local.source_id}-batch-ingestion"
  tags = var.tags

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
      }
    }
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


}


module "permissions" {
  source      = "../../modules/permissions/job"
  job_id      = databricks_job.job.id
  role_prefix = var.role_prefix
}
