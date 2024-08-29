resource "aws_kms_key" "codeartifact_kms_key" {
  description = "default domain key for codeartifact service"
}

resource "aws_codeartifact_domain" "codeartifact_domain" {
  domain         = "default"
  encryption_key = aws_kms_key.codeartifact_kms_key.arn
}

resource "aws_codeartifact_repository" "default_repository" {
  repository = "default-repo"
  domain     = aws_codeartifact_domain.codeartifact_domain.domain
}
