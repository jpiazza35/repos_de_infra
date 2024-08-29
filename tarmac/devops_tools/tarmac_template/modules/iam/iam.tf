resource "aws_iam_user" "automation_user" {
  name = var.automation_user_name
  path = var.automation_user_path
}

resource "aws_iam_user_policy" "automation_user_distribution" {
  name   = "CreateInvalidationCloudFrontDevDistribution"
  user   = aws_iam_user.automation_user.name
  policy = data.aws_iam_policy_document.distribution_invalidation.json
}

resource "aws_iam_user_policy_attachment" "instances_remote_access_policy" {
  user       = aws_iam_user.automation_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess" #add Session Manager access
}

resource "aws_iam_user_policy_attachment" "artifactcode_access_policy" {
  user       = aws_iam_user.automation_user.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeArtifactAdminAccess" #add artifactcode access
}

resource "aws_iam_user_policy_attachment" "fargate_access_policy" {
  user       = aws_iam_user.automation_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess" #update fargate task
}

resource "aws_iam_user_policy" "automation_user_s3" {
  name   = "PutOnlyFrontendBucket"
  user   = aws_iam_user.automation_user.name
  policy = data.aws_iam_policy_document.bucket_putonly.json
}

resource "aws_iam_role" "instance_secret_manager" {
  name               = var.instance_secret_manager_name
  assume_role_policy = data.aws_iam_policy_document.instance_secret_manager_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "instance_secret_manager_policy" {
  role       = aws_iam_role.instance_secret_manager.name
  policy_arn = data.aws_iam_policy.instance_secret_manager_policy.arn
}

resource "aws_iam_instance_profile" "instance_secret_manager_profile" {
  name = var.instance_secret_manager_name
  role = aws_iam_role.instance_secret_manager.name
}

resource "aws_iam_role_policy_attachment" "instances_remote_access_attach" {
  role       = aws_iam_role.instance_secret_manager.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_user_policy" "datalake_access_s3" {
  name   = "AccessDatalakeS3Policy"
  user   = aws_iam_user.automation_user.name
  policy = data.aws_iam_policy_document.bucket_datalake.json
}

resource "aws_iam_user_policy" "access_s3_scripts" {
  name   = "AccessS3ScriptsPolicy"
  user   = aws_iam_user.automation_user.name
  policy = data.aws_iam_policy_document.bucket_scripts.json
}

/*
resource "aws_iam_role" "load_balancer_bucket_log" {
  name               = var.load_balancer_bucket_log_policy_name
  assume_role_policy = data.aws_iam_policy_document.load_balancer_bucket_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "load_balancer_bucket_log_policy" {
  role       = aws_iam_role.load_balancer_bucket_log.name
  policy_arn = data.aws_iam_policy.load_balancer_bucket_log_policy.arn
}

resource "aws_iam_policy" "load_balancer_bucket_log_policy_access" {
  name       = "${var.load_balancer_bucket_log_policy_name}Access"
  policy = data.aws_iam_policy_document.load_balancer_bucket_putonly.json
}

resource "aws_iam_role_policy_attachment" "load_balancer_bucket_log_policy_access" {
  role       = aws_iam_role.load_balancer_bucket_log.name
  policy_arn = aws_iam_policy.load_balancer_bucket_log_policy_access.arn
}
*/

resource "aws_iam_policy" "repository" {
  name        = "fargate-task-policy-image-user"
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
               "ecr:UploadLayerPart"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}
resource "aws_iam_user_policy" "automation_user_registry" {
  name   = "AllowRegistryManagment"
  user   = aws_iam_user.automation_user.name
  policy = aws_iam_policy.repository.policy
}
