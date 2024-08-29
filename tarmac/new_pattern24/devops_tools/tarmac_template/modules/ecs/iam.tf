resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role" "ecs_task_role" {
  name = "FargateTaskRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "polly_access_policy" {
  name        = "AmazonPollyFullAccess"
  description = "Grants full access to Amazon Polly service and resources"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "polly:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ecs_repository_policy" {
  name        = "fargate-task-policy-image-pull"
  description = "Policy that allows access to ECR"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
               "ecr:BatchCheckLayerAvailability",
               "ecr:CompleteLayerUpload",
               "ecr:InitiateLayerUpload",
               "ecr:PutImage",
               "ecr:GetAuthorizationToken",
               "ecr:UploadLayerPart",
               "logs:PutLogEvents",
               "logs:GetLogEvents",
               "logs:FilterLogEvents",
               "logs:DescribeLogStreams",
               "logs:DescribeLogGroups",
               "logs:CreateLogStream",
               "logs:CreateLogGroup"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}

resource "aws_iam_role" "new-relic-role" {
  name        = "NewRelicECSTaskExecutionRole"
  description = "ECS task execution role for New Relic infrastructure"

  assume_role_policy = <<EOF
{
 "Version": "2008-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "new_relic_policy" {
  name        = "NewRelicSSMLicenseKeyReadAccess"
  description = "Provides read access to the New Relic secretsmanager license key parameter"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
               "secretsmanager:GetRandomPassword",
               "secretsmanager:GetResourcePolicy",
               "secretsmanager:GetSecretValue",
               "secretsmanager:DescribeSecret",
               "secretsmanager:ListSecretVersionIds"
           ],
           "Resource": "arn:aws:secretsmanager:us-east-1:699214391223:secret:new-relic-secrets-xZvNNR"
       }
   ]
}
EOF
}
## ECS access - task role & execution-task role
resource "aws_iam_role_policy_attachment" "polly-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.polly_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "newrelic-task-role-policy-attachment" {
  role       = aws_iam_role.new-relic-role.name
  policy_arn = aws_iam_policy.new_relic_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_repository_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-log-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_repository_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

## RDS access permissions
resource "aws_iam_role_policy_attachment" "ecs-task-execution-policy-RDS" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}

## Secret Manager access permissions
resource "aws_iam_role_policy_attachment" "ecs-task-execution-policy-SM" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
