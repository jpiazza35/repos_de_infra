# AWS Config :mega:

This is a terraform repository module for AWS Config within [Conformance CIS Pack](https://github.com/awslabs/aws-config-rules/blob/master/aws-config-conformance-packs/Operational-Best-Practices-for-CIS.yaml)
All the resources needed to work properly without extra configuration are there detailed in the `.tf` files 

There is a [walkthrough](https://aws.amazon.com/blogs/mt/how-to-deploy-aws-config-conformance-packs-using-terraform/) made by AWS on how to create from scratch the same module in case something is not clear

# How it works :white_check_mark:

Need to add or reference this module in your `main.tf` file as shown below

Need to create the variable `s3_bucket_config_name` under your `variables.tf` file

```bash
module "config" {
  source         = "../../modules/config" # Directory where your module is related to the main.tf
  s3_bucket_conf = var.s3_bucket_config_name #Variable value for the bucket, need to be defined under variables.tf
  tags = var.tags #Optional tags definition if you have it
}
```

`tags` variable is not mandatory, can be removed from the module if you don't use it

If you will use a different [Conformance Pack Template](https://docs.aws.amazon.com/config/latest/developerguide/conformancepack-sample-templates.html) you can add it to the `conformance_pack` folder and reference it inside `conformance-pack.tf` file

## Attention :exclamation: :exclamation: :warning: :warning: :warning:

If for some reason the `terraform apply` fails the first time, probably is because the conformance pack started without having the `.yaml` file inside the S3.

Run a `terraform apply` again and it will work smoothly

## Date created: :date:

This module was created on September 2022


__Author: Victor Alcorta__
