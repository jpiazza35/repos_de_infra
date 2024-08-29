resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.properties.environment}-${var.properties.product}-${var.properties.name}-ecs-execution-role"

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
  name = "${var.properties.environment}-${var.properties.product}-${var.properties.name}-ecs-task-role"

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

resource "aws_iam_role_policy_attachment" "s3_attach_collector" {
  policy_arn = aws_iam_policy.s3_assume_role_policy.arn
  role       = aws_iam_role.ecs_task_role.name
}

resource "aws_iam_policy" "s3_assume_role_policy" {
  name        = "${var.properties.environment}-${var.properties.product}-${var.properties.name}-s3-assume-role"
  description = "Policy that assumes iam role from S3 bucket"
  policy      = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
        {
           "Effect": "Allow",
           "Action": "sts:AssumeRole",
           "Resource": "arn:aws:iam::${var.aws_s3_collector_iam_role}"
        }
   ]
}
EOF
}

resource "aws_iam_policy" "s3_allow" {
  name        = "${var.properties.environment}-${var.properties.product}-${var.properties.name}-s3-access"
  description = "Policy that allows access to s3 bucket"
  policy      = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
        {
           "Effect": "Allow",
           "Action": [
               "s3:ListAllMyBuckets"
           ],
           "Resource":
            [
                "*"
            ]
        },
        {
           "Effect": "Allow",
           "Action": [
               "s3:Get*",
               "s3:List*",
               "s3:PutObjectAcl"
           ],
           "Resource":
            [
                "arn:aws:s3:::${var.aws_s3_collector_bucket}",
                "arn:aws:s3:::${var.aws_s3_collector_bucket}/*"
            ]
       }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  policy_arn = aws_iam_policy.s3_allow.arn
  role       = aws_iam_role.ecs_task_role.name
}

resource "aws_iam_role_policy_attachment" "s3_attach_exec_role" {
  policy_arn = aws_iam_policy.s3_allow.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_iam_policy" "ecs_repository_policy" {
  name        = "${var.properties.environment}-${var.properties.product}-${var.properties.name}-ecs-ecr-cw-policy"
  description = "Policy that allows access to ECR and CW"

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
           "Resource": "${aws_ecr_repository.ecr.arn}*"
       }
   ]
}
EOF
}

## ECS access - task role & execution-task role
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

## Secret Manager access permissions
resource "aws_iam_role_policy_attachment" "ecs-task-execution-policy-SM" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
