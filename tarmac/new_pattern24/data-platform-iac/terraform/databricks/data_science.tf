resource "databricks_cluster" "data_science_cluster_chee" {
  count              = module.workspace_vars.env == "sdlc" ? 1 : 0
  cluster_name       = "Chee Lee's Data Science Cluster"
  single_user_name   = "cheelee@cliniciannexus.com"
  data_security_mode = "SINGLE_USER"
  spark_version      = "13.3.x-scala2.12"
  node_type_id       = "i4i.xlarge"
  num_workers        = 1
  autoscale {
    min_workers = 1
    max_workers = 10
  }
  spark_conf = {
    "spark.databricks.delta.preview.enabled" = "true"
  }
  lifecycle {
    ignore_changes = [
      cluster_name,
      spark_version,
      node_type_id,
      num_workers,
      autoscale,
      autotermination_minutes,
      enable_elastic_disk,
      enable_local_disk_encryption,
      spark_conf,
    ]
  }
}

module "cluster_usage_ds_chee" {
  count      = module.workspace_vars.env == "sdlc" ? 1 : 0
  source     = "../modules/permissions/cluster"
  cluster_id = databricks_cluster.data_science_cluster_chee[0].id
  workspace  = module.workspace_vars.env
  depends_on = [databricks_cluster.data_science_cluster_chee]
  additional_user_permissions = [{
    permission_level = "CAN_MANAGE"
    user_name        = "cheelee@cliniciannexus.com"
  }]
}

resource "databricks_cluster" "data_science_cluster_shahrukh" {
  count              = module.workspace_vars.env == "sdlc" ? 1 : 0
  cluster_name       = "Shahrukh Khan's Data Science Cluster"
  single_user_name   = "shahrukhkhan@cliniciannexus.com"
  data_security_mode = "SINGLE_USER"
  spark_version      = "13.3.x-scala2.12"
  node_type_id       = "i4i.xlarge"
  num_workers        = 1
  autoscale {
    min_workers = 1
    max_workers = 10
  }
  spark_conf = {
    "spark.databricks.delta.preview.enabled" = "true"
  }

  lifecycle {
    ignore_changes = [
      cluster_name,
      spark_version,
      node_type_id,
      num_workers,
      autoscale,
      autotermination_minutes,
      enable_elastic_disk,
      enable_local_disk_encryption,
      spark_conf,
    ]
  }

}

module "cluster_usage_ds_shahrukh" {
  count      = module.workspace_vars.env == "sdlc" ? 1 : 0
  source     = "../modules/permissions/cluster"
  cluster_id = databricks_cluster.data_science_cluster_shahrukh[0].id
  workspace  = module.workspace_vars.env
  depends_on = [databricks_cluster.data_science_cluster_shahrukh]

  additional_user_permissions = [{
    permission_level = "CAN_MANAGE"
    user_name        = "shahrukhkhan@cliniciannexus.com"
  }]

}
