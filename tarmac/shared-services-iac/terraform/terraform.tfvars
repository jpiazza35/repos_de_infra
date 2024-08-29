### Common ###
app    = ""
env    = "SS"
tags   = {}
region = "us-east-1"

### Github OIDC ###
enabled = true
github_repositories = [
  "clinician-nexus/shared-services-iac",
  "clinician-nexus/app-mpt-ui",
  "clinician-nexus/app-mpt-project-service",
  "clinician-nexus/app-organization-service",
  "clinician-nexus/app-survey-service",
  "clinician-nexus/app-user-service",
  "clinician-nexus/app-incumbent-service",
  "clinician-nexus/infra-cluster-resources",
  "clinician-nexus/app-incumbent-db",
  "clinician-nexus/app-incumbent-staging-db",
  "clinician-nexus/app-mpt-postgres-db",
  "clinician-nexus/aws-networking",
  "clinician-nexus/bi-platform-devops-iac",
  "clinician-nexus/data-platform-devops-iac",
  "clinician-nexus/app-ps-ui",
  "clinician-nexus/app-ps-comp-summary",
  "clinician-nexus/app-mpt-data"
]
eks_provider_urls = [
  "oidc.eks.us-east-1.amazonaws.com/id/B26E67CA3751C7A93EF38DAA3D8D2E18" ## D_EKS
]
max_session_duration          = 3600
attach_admin_policy           = true
attach_read_only_policy       = false
create_oidc_provider          = true
force_detach_policies         = false
iam_role_name                 = ""
iam_role_path                 = "/"
iam_role_permissions_boundary = ""
iam_role_policy_arns          = []
iam_role_inline_policies      = {}

### Backend/Prereqs ###
dynamodb_name = "cn-shared-services-tf-dynamodb-table"
bucket_name   = "cn-shared-services-tf-backend-bucket"
/* create_prereqs = true */
### ecs ###
capacity_provider_strategy = [
  {
    capacity_provider = "FARGATE_SPOT",
    weight            = 100
  }
]
task_container_image   = ""
task_definition_cpu    = 2048 #2vcpu
task_definition_memory = 4096 #4gb

task_container_port             = 80
task_container_cpu              = 128
task_container_assign_public_ip = false
target_groups = [
  {
    target_group_name = "ss-alb-tg"
    container_port    = 80
    matcher           = "200,302"
  },
]
health_check = {
  port                = "80"
  path                = "/"
  enabled             = true
  interval            = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
  protocol            = "HTTP" #"TCP" #
  matcher             = "200,302"
}
enable_deployment_circuit_breaker          = true
enable_deployment_circuit_breaker_rollback = true
load_balanced                              = true


### phpIPAM
cidr_ranges = [
  "10.202.0.0",
  "10.203.0.0",
  "10.204.0.0",
  "10.205.0.0",
  "10.206.0.0",
  "10.207.0.0",
  "10.208.0.0",
  "10.209.0.0"
]

azure_cidr_ranges = [
  "10.210.0.0",
  "10.211.0.0",
  "10.212.0.0",
  "10.213.0.0",
  "10.214.0.0",
  "10.215.0.0",
  "10.216.0.0",
  "10.217.0.0",
  "10.218.0.0",
  "10.219.0.0"
]

full_vpcs = {
  "D_DATABRICKS" = {
    vpc_cidr = "10.202.0.0"
    mask     = "23"
  },
  "SS_TOOLS" = {
    vpc_cidr = "10.202.2.0"
    mask     = "23"
  },
  "SS_NETWORK" = {
    vpc_cidr = "10.202.4.0"
    mask     = "23"
  },
  "D_DATA_PLATFORM" = {
    vpc_cidr = "10.202.6.0"
    mask     = "23"
  },
  "D_MPT" = {
    vpc_cidr = "10.202.8.0"
    mask     = "23"
  },

}

## Vault Management
paths = [
  "dev",
  "devops",
  "qa",
  "prod",
  "data_platform"
]

k8s_serviceaccount             = "vault-auth"
k8s_cert_issuer_serviceaccount = "vault-cert-issuer"
vault_addr                     = "https://vault.cliniciannexus.com:8200"
cluster_name                   = ""


## Sonatype Artifactory

sonatype_task_container_image   = "sonatype/nexus3:latest"
sonatype_task_definition_cpu    = 4096 #4vcpu
sonatype_task_definition_memory = 8192 #8gb

sonatype_task_container_port             = 8081
sonatype_task_container_cpu              = 4096
sonatype_task_container_memory           = 8192
sonatype_task_container_assign_public_ip = false

sonatype_target_groups = [
  {
    target_group_name = "sonatype-alb-tg"
    container_port    = 8081
    matcher           = "200,302"
  },
]

sonatype_health_check = {
  port                = "8081"
  path                = "/"
  enabled             = true
  interval            = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
  protocol            = "HTTP" #"TCP" #
  matcher             = "200,302"
}

## Incident Bot

incident_bot_task_container_image            = "163032254965.dkr.ecr.us-east-1.amazonaws.com/incident-bot-ecr-repo:v1.4.18"
incident_bot_task_definition_cpu             = 2048
incident_bot_task_definition_memory          = 4096
incident_bot_task_container_port             = 3000
incident_bot_task_container_cpu              = 512
incident_bot_task_container_memory           = 1024
incident_bot_task_container_assign_public_ip = false

incident_bot_target_groups = [
  {
    target_group_name = "ss-alb-incident-bot-tg"
    container_port    = 3000
    matcher           = "200,302"
  },
]

incident_bot_health_check = {
  port                = "3000"
  path                = "/"
  enabled             = true
  interval            = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
  protocol            = "HTTP" #"TCP" #
  matcher             = "200,302"
}

backend_accounts_ids = [
  "964608896914", # D_DevOps
  "946884638317", # D_EKS
  "071766652168", # P_EKS
  "063890802877", # Q_EKS
  "130145099123", # D_data_platform
  "417425771013"  # P_data_platform
]

backend_dynamodb_table_arn = "arn:aws:dynamodb:us-east-1:163032254965:table/cn-terraform-state"