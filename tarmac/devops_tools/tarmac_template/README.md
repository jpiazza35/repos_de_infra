## default-infrastructure

### requirements

Valid certificate generated on AWS Certificate for the Cloudfront distribution.

Name: distribution_acm_certificate
Value: AWS certificate's arn

Create a secret on Secret Manager to add the private key to pull code from repository

Name: github-dev-puller
Value: Private Key

### ECS service