locals {
  s3_cf_list = [
    for key, val in module.s3 : {
      key            = key
      s3_bucket_id   = val.s3_bucket_id
      cloudfront_arn = element(module.cloudfront[key].distribution_arn, 0)
    }
  ]

  flat_s3_cf_list = flatten(local.s3_cf_list)
  s3_cf_map       = { for idx, val in local.flat_s3_cf_list : val.key => val }
}