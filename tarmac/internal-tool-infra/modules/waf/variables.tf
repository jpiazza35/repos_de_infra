variable "cloudfront_distribution_arn" {
  type        = string
  description = "The ARN of the cloudfront"
}
variable "lb_arn" {
  type        = string
  description = "The ARN of the alb"
}
variable "tags" {
  type = map(any)
}
variable "properties" {
  type = any
}