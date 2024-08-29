module "file_notification_instance_profile" {
  source          = "../modules/instance_profile"
  env             = module.workspace_vars.env
  iam_policy_json = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DatabricksAutoLoaderSetup",
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketNotification",
        "s3:PutBucketNotification",
        "sns:ListSubscriptionsByTopic",
        "sns:GetTopicAttributes",
        "sns:SetTopicAttributes",
        "sns:CreateTopic",
        "sns:TagResource",
        "sns:Publish",
        "sns:Subscribe",
        "sqs:CreateQueue",
        "sqs:DeleteMessage",
        "sqs:ReceiveMessage",
        "sqs:SendMessage",
        "sqs:GetQueueUrl",
        "sqs:GetQueueAttributes",
        "sqs:SetQueueAttributes",
        "sqs:TagQueue",
        "sqs:ChangeMessageVisibility"
      ],
      "Resource": [
        "arn:aws:s3:::*",
        "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:databricks-auto-ingest-*",
        "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:databricks-auto-ingest-*"
      ]
    },
    {
      "Sid": "DatabricksAutoLoaderList",
      "Effect": "Allow",
      "Action": [
        "sqs:ListQueues",
        "sqs:ListQueueTags",
        "sns:ListTopics"
      ],
      "Resource": "*"
    },
    {
      "Sid": "DatabricksAutoLoaderTeardown",
      "Effect": "Allow",
      "Action": [
        "sns:Unsubscribe",
        "sns:DeleteTopic",
        "sqs:DeleteQueue"
      ],
      "Resource": [
        "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:databricks-auto-ingest-*",
        "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:databricks-auto-ingest-*"
      ]
    }
  ]
}
JSON
  name            = "file_notification_instance_profile"
}

resource "databricks_group_role" "file_notification_instance_profile" {
  group_id = data.databricks_group.data_engineers.id
  role     = module.instance_profile.instance_profile_name
}
