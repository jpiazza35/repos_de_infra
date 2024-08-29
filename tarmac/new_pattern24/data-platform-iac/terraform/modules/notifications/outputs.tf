locals {
  # unfortunately, there is no terraform resource or data source around notification IDs. workflow is create manually
  # in slack & databricks UI, and add the IDs here
  # each workspace notification channel is linked to the same webhook
  dp_slack_notification_id = {
    sdlc    = "b67bdfc8-3a93-4b1a-8ac4-bcc0886fe668"
    preview = "e2d5d93c-e02f-46dd-afd0-4de70b942b0b"
    prod    = "4a67a1f2-6485-4efa-958d-f4d4fbec6b45"
  }
}

output "data_platform_slack_notification_id" {
  description = "The ID of the Slack notification channel for the Data Platform"
  value       = local.dp_slack_notification_id[var.workspace]
}

output "data_platform_email" {
  value = "Data-platform@cliniciannexus.com"
}
