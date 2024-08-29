instance_profile_arn = "arn:aws:iam::230176594509:instance-profile/sdlc-artifact-storage-instance-profile"
wheel_path           = "s3://sdlc-artifacts-230176594509/wheels/dist/cn_databricks-0.1.49-py3-none-any.whl"

deidentification_jobs = [
  {
    "job_name" : "job"
    "job_tasks" : [
      {
        "task_name"             = "example_task_name",
        "source_table_name"     = "d_source_oriented.my_database.my_table",
        "deidentification_type" = "HASH",
        "column_name_list"      = ["column1", "column2"]
      },
    ],
    cron_schedule_enable = false
  },
  {
    "job_name" : "so-mercer-tables-test"
    "job_tasks" : [
      {
        "task_name"             = "so-survey-mercer_corporate_services_human_resources",
        "source_table_name"     = "d_source_oriented.survey.mercer_corporate_services_human_resources",
        "deidentification_type" = "HASH",
        "column_name_list"      = ["mjl_code"]
      },
      {
        "task_name"             = "so-survey-mercer_executive",
        "source_table_name"     = "d_source_oriented.survey.mercer_executive",
        "deidentification_type" = "REMOVE",
        "column_name_list"      = ["mjl_code"]
      },
    ],
    cron_schedule_enable = false
  },
]