variable "repositories" {
  type = list(string)
}

variable "environments" {
  type = map(object({
    name           = string
    account_number = string
  }))
  default = {
    sdlc = {
      name           = "sdlc"
      account_number = "230176594509"
    },
    prod = {
      name           = "prod"
      account_number = "467744931205"
    }
  }
}
