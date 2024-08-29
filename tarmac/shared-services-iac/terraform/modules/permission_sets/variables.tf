variable "permission_sets" {
  type = list(object({
    name        = string
    description = string
  }))
  description = "The list of permission sets in the AWS Management account"
}

variable "session_duration" {
  type    = string
  default = "PT4H"
}

variable "permissions" {

}
  