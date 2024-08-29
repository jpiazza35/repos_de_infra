resource "databricks_cluster" "survey_team_alteryx_compute" {
  cluster_name            = "survey-team-alteryx-cluster"
  spark_version           = "13.3.x-scala2.12"
  autotermination_minutes = 0
  instance_pool_id        = databricks_instance_pool.survey_team_alteryx_compute_worker_pool.id
  driver_instance_pool_id = databricks_instance_pool.survey_team_alteryx_compute_driver_pool.id
  data_security_mode      = "SINGLE_USER"
  single_user_name        = var.alteryx_databricks_service_account_email
  autoscale {
    min_workers = 1
    max_workers = 50
  }
}

resource "databricks_instance_pool" "survey_team_alteryx_compute_driver_pool" {
  instance_pool_name = "Survey Team Alteryx Compute Driver Pool"
  min_idle_instances = 1
  max_capacity       = 100
  node_type_id       = "m5dn.large"
  aws_attributes {
    availability           = "ON_DEMAND"
    zone_id                = module.availability_zone_ids.zone_names[0]
    spot_bid_price_percent = "100"
  }
  idle_instance_autotermination_minutes = 60
  disk_spec {
    disk_type {
      ebs_volume_type = "GENERAL_PURPOSE_SSD"
    }
    disk_size  = 80
    disk_count = 1
  }
}

resource "databricks_instance_pool" "survey_team_alteryx_compute_worker_pool" {
  instance_pool_name = "Survey Team Alteryx Compute Worker Pool"
  min_idle_instances = 0
  max_capacity       = 100
  node_type_id       = "m5dn.large"
  aws_attributes {
    availability           = "SPOT"
    zone_id                = module.availability_zone_ids.zone_names[0]
    spot_bid_price_percent = "100"
  }
  idle_instance_autotermination_minutes = 60
  disk_spec {
    disk_type {
      ebs_volume_type = "GENERAL_PURPOSE_SSD"
    }
    disk_size  = 80
    disk_count = 1
  }
}

module "availability_zone_ids" {
  source = "../modules/availability_zone_selector"
}

resource "databricks_permissions" "survey_alteryx_cluster_usage" {
  cluster_id = databricks_cluster.survey_team_alteryx_compute.id

  dynamic "access_control" {
    for_each = var.survey_developer_group_name == "" ? [] : [var.survey_developer_group_name]
    content {
      group_name       = var.survey_developer_group_name
      permission_level = "CAN_RESTART"
    }
  }

  access_control {
    group_name       = "${module.workspace_vars.role_prefix}_engineer"
    permission_level = "CAN_MANAGE"
  }
}
