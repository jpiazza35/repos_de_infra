locals {
  sso_users = {
    john_doe = {
      user_name    = "john.doe@tarmac.io"
      display_name = "John Doe"
      given_name   = "John"
      family_name  = "Doe"
      sso_groups = [
        "DevAdminGroup",
        "ProdReadOnlyGroup",
      ]
      emails = [
        {
          value   = "john.doe@tarmac.io"
          primary = true
          type    = "work"
        }
      ]
    },
  }
}