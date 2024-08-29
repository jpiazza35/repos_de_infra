resource "aws_cognito_user_pool" "pool" {
  name = "${var.tags["Environment"]}-${var.tags["Project"]}-${var.properties.name}-userpool"

  account_recovery_setting {
    dynamic "recovery_mechanism" {
      for_each = var.properties.recovery_mechanisms
      content {
        name     = recovery_mechanism.value.name
        priority = recovery_mechanism.value.priority
      }
    }
  }

  password_policy {
    minimum_length                   = var.properties.password_policy.minimum_length
    require_lowercase                = var.properties.password_policy.require_lowercase
    require_numbers                  = var.properties.password_policy.require_numbers
    require_uppercase                = var.properties.password_policy.require_uppercase
    require_symbols                  = var.properties.password_policy.require_symbols
    temporary_password_validity_days = var.properties.password_policy.temporary_password_validity_days
  }

  tags = var.tags

}

resource "aws_cognito_user_pool_domain" "tool_domain" {
  domain       = var.properties.domain
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_identity_provider" "google_provider" {
  user_pool_id  = aws_cognito_user_pool.pool.id
  provider_name = var.properties.provider_name
  provider_type = var.properties.provider_type

  provider_details = {
    attributes_url                = data.aws_ssm_parameter.attributes_url.value
    authorize_scopes              = data.aws_ssm_parameter.authorize_scopes.value
    attributes_url_add_attributes = data.aws_ssm_parameter.attributes_url_add_attributes.value
    authorize_url                 = data.aws_ssm_parameter.authorize_url.value
    client_id                     = data.aws_ssm_parameter.client_id.value
    client_secret                 = data.aws_ssm_parameter.client_secret.value
    oidc_issuer                   = data.aws_ssm_parameter.oidc_issuer.value
    token_request_method          = data.aws_ssm_parameter.token_request_method.value
    token_url                     = data.aws_ssm_parameter.token_url.value
  }

  attribute_mapping = {
    email          = var.properties.attribute_mapping.email
    username       = var.properties.attribute_mapping.username
    email_verified = var.properties.attribute_mapping.email_verified
    name           = var.properties.attribute_mapping.name
  }

}