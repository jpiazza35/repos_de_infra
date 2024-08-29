variable "instance_ami" {
  description = "instance ami"
  type        = string
  default     = "ami-0c02fb55956c7d316" #AWSLinux2
}

variable "instance_type" {
  description = "Type of instance"
  type        = string
  default     = "t2.micro"
}
variable "instance_subnet" {
  description = "Instance subnet"
  type        = list(string)
}

variable "instance_tags" {
  description = "Instance Tags"
  type        = map(string)
  default     = { "Name" : "EC2 Instance" }
}

variable "tags" {
  type = map(any)
}

variable "instance_volume_size" {
  description = "Size of EBS volume in GiBs"
  type        = number
  default     = 1
}

variable "instance_volume_az" {
  description = "AZ for EBS volume"
  type        = string
  default     = "us-east-1a"
}

variable "instance_security_group" {
  description = "Security group from VPC"
  type        = list(string)
  default     = [""]
}

variable "instance_user_data" {
  description = "User data"
  type        = string
  default     = ""

}

variable "instance_secret_manager_profile" {
  description = "Instance profile to access secret manager service"
}