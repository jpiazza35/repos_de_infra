locals {
  password = random_password.master_password[var.trigger_rotation].result
}
