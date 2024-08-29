variable "deidentification_jobs" {
  type = list(
    object({
      job_name = string
      job_tasks = list(
        object(
          {
            task_name             = string
            source_table_name     = string
            column_name_list      = list(string)
            deidentification_type = optional(string)
            target_table_name     = optional(string)
            salt                  = optional(string)
          }
        )
      )
      cron_schedule_enable = optional(bool)
    })
  )
}

variable "wheel_path" {
  type = string
}

variable "instance_profile_arn" {
  type = string
}
