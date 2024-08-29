variable "s3_bucket_distribution" {
  description = "distribution s3 bucket"
}

variable "s3_bucket" {
  description = "s3 bucket"
}
variable "s3_bucket_log" {
  description = "s3 bucket log"
}

variable "automation_user_name" {
  description = "Name of user"
  type        = string
  default     = "dev-automation"
}

variable "automation_user_path" {
  description = "User path"
  type        = string
  default     = "/"
}