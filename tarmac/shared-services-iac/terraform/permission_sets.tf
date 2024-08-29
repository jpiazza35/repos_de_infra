module "permission_sets" {
  source = "./modules/permission_sets"
  providers = {
    aws = aws.management
  }

  permission_sets = [
    {
      name        = "ppmt_api_dev"
      description = "Dev role for PPMT API accounts."
    },
    {
      name        = "PowerUserAccess"
      description = "Clinician Nexus Poweruser with IAM permissions"
    },
    {
      name        = "CNDataScientist"
      description = "Data Scientist Permissions for Clinician Nexus"
    },
    {
      name        = "Route53"
      description = "Route53 Access to HostedZone"
    },
    {
      name        = "AWSReadOnlyAccess"
      description = "This policy grants permissions to view resources and basic metadata across all AWS services"
    },
    {
      name        = "AWSServiceCatalogAdminFullAccess"
      description = "Provides full access to AWS Service Catalog admin capabilities"
    },
    {
      name        = "AWSAdministratorAccess"
      description = "Provides full access to AWS services and resources"
    },
    {
      name        = "AWS-Global-ABAC-Dynamic-Access"
      description = "AD Group based access controls - All non-security accounts."
    },
    {
      name        = "CNDeveloper"
      description = "Developer Permissions for Clinician Nexus"
    },
    {
      name        = "databricks_dev"
      description = "Dev role for Databricks accounts."
    },
    {
      name        = "datahub_wh_dev"
      description = "Dev role in Datahub Warehouse accounts."
    },
    {
      name        = "datahub_lake_contributor"
      description = "Contributor role in Datahub lake accounts."
    },
    {
      name        = "AWSOrganizationsFullAccess"
      description = "Provides full access to AWS Organizations"
    },
    {
      name        = "Account_Administrator"
      description = "Provides broad administrative permissions in an account except a few restricted network and organization related functions."
    },
    {
      name        = "aws_infra_prod_ciai_poc"
      description = "Grants access to objects related to the ciai datalake PoC."
    },
    {
      name        = "Billing"
      description = "Access to billing and budget related functions including payment methods."
    },
    {
      name        = "AWSServiceCatalogEndUserAccess"
      description = "Provides access to the AWS Service Catalog end user console"
    },
    {
      name        = "builddeploy_dev"
      description = "Dev role for BuildDeploy accounts."
    },
    {
      name        = "Tarmac_ITOps_Admin"
      description = "Tarmac IT Ops Administrative User (limited access)"
    },
    {
      name        = "AWSPowerUserAccess"
      description = "Provides full access to AWS services and resources, but does not allow management of Users and groups"
    },
    {
      name        = "datahub_lake_dev"
      description = "Dev role in Datahub Lake acounts."
    }
  ]

  permissions = [
    {
      name = "ppmt_api_dev"
      managed_policies = [
        "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator",
        "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
        "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess",
        "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess",
        "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
        "arn:aws:iam::aws:policy/CloudFrontFullAccess",
        "arn:aws:iam::aws:policy/CloudWatchFullAccess",
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
      ],
      inline_policies = [
        data.aws_iam_policy_document.ppmt_api_dev.json
      ]
    },

    {
      name = "PowerUserAccess"
      managed_policies = [
        "arn:aws:iam::aws:policy/IAMFullAccess",
        "arn:aws:iam::aws:policy/PowerUserAccess",
      ],
      inline_policies = [
      ]
    },

    {
      name = "CNDataScientist"
      managed_policies = [

      ],
      inline_policies = [
        data.aws_iam_policy_document.CNDataScientist.json
      ]

    },
    {
      name = "Route53"
      managed_policies = [
      ],
      inline_policies = [
        data.aws_iam_policy_document.Route53.json
      ]
    },

    {
      name = "AWSReadOnlyAccess"
      managed_policies = [
        "arn:aws:iam::aws:policy/ReadOnlyAccess",
        "arn:aws:iam::aws:policy/viewOnlyAccess",
      ],
      inline_policies = [
      ]
    },

    {
      name = "AWSServiceCatalogAdminFullAccess"
      managed_policies = [
        "arn:aws:iam::aws:policy/AWSServiceCatalogAdminFullAccess",
      ],
      inline_policies = [
      ]
    },
    {
      name = "AWSAdministratorAccess"
      managed_policies = [
        "arn:aws:iam::aws:policy/AWSAdministratorAccess",
      ],
      inline_policies = [
      ]
    },
    {
      name = "AWS-Global-ABAC-Dynamic-Access"
      managed_policies = [

      ],
      inline_policies = [
        data.aws_iam_policy_document.AWS-Global-ABAC-Dynamic-Access.json
      ]
    },
    {
      name = "CNDeveloper"
      managed_policies = [

      ],
      inline_policies = [
        data.aws_iam_policy_document.CNDeveloper.json
      ]
    },
    {
      name = "databricks_dev"
      managed_policies = [
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
      ],
      inline_policies = [
        data.aws_iam_policy_document.databricks_dev.json
      ]
    },

    {
      name = "datahub_wh_dev"
      managed_policies = [
        "arn:aws:iam::aws:policy/AmazonRedshiftAllCommandsFullAccess",
        "arn:aws:iam::aws:policy/AmazonRedshiftDataFullAccess",
        "arn:aws:iam::aws:policy/AmazonRedshiftQueryEditor",
        "arn:aws:iam::aws:policy/AmazonRedshiftQueryEditorV2FullAccess",
        "arn:aws:iam::aws:policy/AmazonRedshiftReadOnlyAccess",
        "arn:aws:iam::aws:policy/AWSQuickSightDescribeRedshift",
        "arn:aws:iam::aws:policy/ReadOnlyAccess",
      ],
      inline_policies = [
        data.aws_iam_policy_document.datahub_wh_dev.json
      ]
    },

    {
      name = "datahub_lake_contributor"
      managed_policies = [
        "arn:aws:iam::aws:policy/ViewOnlyAccess"

      ],
      inline_policies = [
        data.aws_iam_policy_document.datahub_lake_contributor.json
      ]
    },

    {
      name = "AWSOrganizationsFullAccess"
      managed_policies = [
        "arn:aws:iam::aws:policy/AWSOrganizationsFullAccess"

      ],
      inline_policies = [

      ]
    },

    {
      name = "Account_Administrator"
      managed_policies = [
        "arn:aws:iam::aws:policy/AdministratorAccess",
      ],
      inline_policies = [

      ]
    },
    {
      name = "aws_infra_prod_ciai_poc"
      managed_policies = [

      ],
      inline_policies = [
        data.aws_iam_policy_document.aws_infra_prod_ciai_poc.json
      ]
    },

    {
      name = "Billing"
      managed_policies = [
        "arn:aws:iam::aws:policy/job-function/Billing"
      ],
      inline_policies = [

      ]
    },

    {
      name = "AWSServiceCatalogEndUserAccess"
      managed_policies = [
        "arn:aws:iam::aws:policy/AWSServiceCatalogEndUserFullAccess"
      ],
      inline_policies = [
        data.aws_iam_policy_document.AWSServiceCatalogEndUserAccess.json
      ]
    },

    {
      name = "builddeploy_dev"
      managed_policies = [
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
        "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
        "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess",
        "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess",
        "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess",
        "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess",
        "arn:aws:iam::aws:policy/CloudWatchFullAccess",
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
      ],
      inline_policies = [
        data.aws_iam_policy_document.builddeploy_dev.json
      ]
    },

    {
      name = "Tarmac_ITOps_Admin"
      managed_policies = [
        "arn:aws:iam::aws:policy/AWSServiceCatalogEndUserFullAccess",
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
      ],
      inline_policies = [

      ]
    },
    {
      name = "AWSPowerUserAccess"
      managed_policies = [
        "arn:aws:iam::aws:policy/PowerUserAccess",
      ],
      inline_policies = [

      ]
    },
    {
      name = "datahub_lake_dev"
      managed_policies = [
        "arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
        "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
        "arn:aws:iam::aws:policy/AWSGlueDataBrewFullAccessPolicy",
        "arn:aws:iam::aws:policy/AWSGlueSchemaRegistryFullAccess",
        "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
        "arn:aws:iam::aws:policy/ReadOnlyAccess",
        "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
      ],
      inline_policies = [
        data.aws_iam_policy_document.datahub_lake_dev.json
      ]
    },
  ]
}
