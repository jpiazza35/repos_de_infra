data "aws_ssm_parameter" "attributes_url" {
  name = "/${var.tags["Environment"]}/internaltool/attributes_url"
}
data "aws_ssm_parameter" "authorize_scopes" {
  name = "/${var.tags["Environment"]}/internaltool/authorize_scopes"
}
data "aws_ssm_parameter" "attributes_url_add_attributes" {
  name = "/${var.tags["Environment"]}/internaltool/attributes_url_add_attributes"
}
data "aws_ssm_parameter" "authorize_url" {
  name = "/${var.tags["Environment"]}/internaltool/authorize_url"
}
data "aws_ssm_parameter" "client_id" {
  name = "/${var.tags["Environment"]}/internaltool/client_id"
}
data "aws_ssm_parameter" "client_secret" {
  name = "/${var.tags["Environment"]}/internaltool/client_secret"
}
data "aws_ssm_parameter" "oidc_issuer" {
  name = "/${var.tags["Environment"]}/internaltool/oidc_issuer"
}
data "aws_ssm_parameter" "token_request_method" {
  name = "/${var.tags["Environment"]}/internaltool/token_request_method"
}
data "aws_ssm_parameter" "token_url" {
  name = "/${var.tags["Environment"]}/internaltool/token_url"
}
