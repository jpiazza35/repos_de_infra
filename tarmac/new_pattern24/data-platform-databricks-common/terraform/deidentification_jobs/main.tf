module "workspace_vars" {
  source    = "git::https://github.com/clinician-nexus/data-platform-iac//terraform/modules/workspace_variable_transformer"
  workspace = terraform.workspace
}

module "deidentification_batch_jobs" {
  for_each = {
    for index, deid_job in var.deidentification_jobs :
    deid_job.job_name => deid_job
  }
  source                 = "../modules/batch_deidentification_job"
  job_name               = each.value.job_name
  deidentification_tasks = each.value.job_tasks
  role_prefix            = module.workspace_vars.role_prefix
  cron_schedule_enable   = each.value.cron_schedule_enable
  wheel_path             = var.wheel_path
  instance_profile_arn   = var.instance_profile_arn
  default_role_prefix    = module.workspace_vars.role_prefix
}
