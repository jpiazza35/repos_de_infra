resource "aws_config_remediation_configuration" "s3_public_read_write_prohibit" {
  config_rule_name = aws_config_config_rule.s3_public_write_prohibit.name
  resource_type    = "AWS::S3::Bucket"
  target_type      = "SSM_DOCUMENT"
  target_id        = "AWS-DisableS3BucketPublicReadWrite"
  target_version   = "1"

  parameter {
    name         = "AutomationAssumeRole"
    static_value = aws_iam_role.ssm_remediation_iam_role.arn
  }

  parameter {
    name           = "S3BucketName"
    resource_value = "RESOURCE_ID"
  }

  automatic                  = true
  maximum_automatic_attempts = 10
  retry_attempt_seconds      = 600

  execution_controls {
    ssm_controls {
      concurrent_execution_rate_percentage = 25
      error_percentage                     = 20
    }
  }
}

resource "aws_config_remediation_configuration" "s3_encryption_enabled" {
  config_rule_name = aws_config_config_rule.s3_encryption_enabled.name
  resource_type    = "AWS::S3::Bucket"
  target_type      = "SSM_DOCUMENT"
  target_id        = aws_ssm_document.s3_encryption_remediation.name
  target_version   = "1"

  parameter {
    name         = "AutomationAssumeRole"
    static_value = aws_iam_role.ssm_remediation_iam_role.arn
  }

  parameter {
    name           = "BucketName"
    resource_value = "RESOURCE_ID"
  }

  parameter {
    name         = "SSEAlgorithm"
    static_value = "aws:kms"
  }

  parameter {
    name         = "KMSKeyId"
    static_value = var.s3_kms_key_alias
  }

  automatic                  = true
  maximum_automatic_attempts = 10
  retry_attempt_seconds      = 600

  execution_controls {
    ssm_controls {
      concurrent_execution_rate_percentage = 25
      error_percentage                     = 20
    }
  }
}

resource "aws_config_remediation_configuration" "s3_SSLonly_enabled" {
  config_rule_name = aws_config_config_rule.s3_SSLonly_enabled.name
  resource_type    = "AWS::S3::Bucket"
  target_type      = "SSM_DOCUMENT"
  target_id        = "AWSConfigRemediation-RestrictBucketSSLRequestsOnly"
  target_version   = "1"

  parameter {
    name         = "AutomationAssumeRole"
    static_value = aws_iam_role.ssm_remediation_iam_role.arn
  }

  parameter {
    name           = "BucketName"
    resource_value = "RESOURCE_ID"
  }

  automatic                  = true
  maximum_automatic_attempts = 10
  retry_attempt_seconds      = 600

  execution_controls {
    ssm_controls {
      concurrent_execution_rate_percentage = 25
      error_percentage                     = 20
    }
  }
}

resource "aws_config_remediation_configuration" "s3_bucket_policy_grantee_check" {
  config_rule_name = aws_config_config_rule.s3_bucket_policy_grantee_check.name
  resource_type    = "AWS::S3::Bucket"
  target_type      = "SSM_DOCUMENT"
  target_id        = "AWSConfigRemediation-RemovePrincipalStarFromS3BucketPolicy"
  target_version   = "1"

  parameter {
    name         = "AutomationAssumeRole"
    static_value = aws_iam_role.ssm_remediation_iam_role.arn
  }

  parameter {
    name           = "BucketName"
    resource_value = "RESOURCE_ID"
  }

  automatic                  = true
  maximum_automatic_attempts = 10
  retry_attempt_seconds      = 600

  execution_controls {
    ssm_controls {
      concurrent_execution_rate_percentage = 25
      error_percentage                     = 20
    }
  }
}

resource "aws_config_remediation_configuration" "iam_password_policy" {
  config_rule_name = aws_config_config_rule.iam_password_policy.name
  target_type      = "SSM_DOCUMENT"
  target_id        = "AWSConfigRemediation-SetIAMPasswordPolicy"
  target_version   = "1"

  parameter {
    name         = "AutomationAssumeRole"
    static_value = aws_iam_role.ssm_remediation_iam_role.arn
  }

  parameter {
    name         = "RequireUppercaseCharacters"
    static_value = var.iam_password_policy_require_uppercase
  }

  parameter {
    name         = "RequireLowercaseCharacters"
    static_value = var.iam_password_policy_require_lowercase
  }

  parameter {
    name         = "RequireNumbers"
    static_value = var.iam_password_policy_require_numbers
  }

  parameter {
    name         = "RequireSymbols"
    static_value = var.iam_password_policy_require_symbols
  }

  parameter {
    name         = "AllowUsersToChangePassword"
    static_value = var.iam_password_policy_allow_users_to_change_password
  }

  parameter {
    name         = "MinimumPasswordLength"
    static_value = var.iam_password_policy_min_password_length
  }

  parameter {
    name         = "PasswordReusePrevention"
    static_value = var.iam_password_policy_password_reuse_prevention
  }

  parameter {
    name         = "MaxPasswordAge"
    static_value = var.iam_password_policy_max_password_age
  }

  automatic                  = true
  maximum_automatic_attempts = 10
  retry_attempt_seconds      = 600

  execution_controls {
    ssm_controls {
      concurrent_execution_rate_percentage = 25
      error_percentage                     = 20
    }
  }
}
