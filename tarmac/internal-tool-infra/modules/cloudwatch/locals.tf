locals {
  ecs_alarm_config = flatten([
    for metric_key, config_values in var.ecs_metrics : [{
      alarm_metric_name = metric_key

      alarm_name                     = config_values.alarm_name
      alarm_description              = config_values.alarm_description
      alarm_cluster_name             = config_values.cluster_name
      alarm_service_name             = config_values.service_name
      alarm_namespace                = config_values.namespace
      alarm_metric_statistic         = config_values.statistic
      alarm_metric_period            = config_values.period
      alarm_metric_evaluation_period = config_values.evaluation_periods
      alarm_datapoints_to_alarm      = config_values.datapoints_to_alarm
      alarm_threshold                = config_values.threshold
      alarm_comparison_operator      = config_values.comparison_operator
      alarm_missing_data             = config_values.missing_data
    }]
  ])
}
