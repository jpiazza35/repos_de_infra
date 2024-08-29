variable "ecs_metrics" {
  description = "Variable used to specify the metrics that make up the alarms for ECS Service"
  type = map(object({
    alarm_name          = string
    alarm_description   = string
    cluster_name        = string
    service_name        = string
    namespace           = string
    statistic           = string
    period              = string
    evaluation_periods  = string
    datapoints_to_alarm = string
    threshold           = string
    comparison_operator = string
    missing_data        = string
  }))
}

variable "sns_topic_notifications" {
  description = "Sns topic ARN list used for forwarding alarms notifications"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  type = string
}
variable "dashboard_body" {
  type = string
}