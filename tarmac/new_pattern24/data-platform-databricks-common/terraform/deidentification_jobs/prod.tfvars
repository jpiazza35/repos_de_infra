instance_profile_arn = "arn:aws:iam::467744931205:instance-profile/prod-artifact-storage-instance-profile"
wheel_path           = "s3://prod-artifacts-467744931205/wheels/dist/cn_databricks-0.1.49-py3-none-any.whl"

deidentification_jobs = [
  {
    "job_name" = "2023-survey-submission-migration"
    "job_tasks" = [
      {
        "task_name"             = "2023_physician_incumbent",
        "source_table_name"     = "p_source_oriented.survey.physician_incumbent",
        "deidentification_type" = "HASH",
        "column_name_list"      = ["npi_number"]
      },
      {
        "task_name"             = "2023_physician_new_hire",
        "source_table_name"     = "p_source_oriented.survey.physician_new_hire",
        "deidentification_type" = "HASH",
        "column_name_list"      = ["npi_number"]
      },
      {
        "task_name"             = "2023_app_incumbent",
        "source_table_name"     = "p_source_oriented.survey.app_incumbent",
        "deidentification_type" = "HASH",
        "column_name_list"      = ["npi_number"]
      },
      {
        "task_name"             = "2023_app_new_hire",
        "source_table_name"     = "p_source_oriented.survey.app_new_hire",
        "deidentification_type" = "HASH",
        "column_name_list"      = ["npi_number"]
      },
    ],
    cron_schedule_enable = false
  }
]