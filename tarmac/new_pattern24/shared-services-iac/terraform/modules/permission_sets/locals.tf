locals {
  name = {
    for p in var.permissions : p.name => p
  }

  managed_policies = flatten([
    for p in var.permissions : flatten([
      for mp in p.managed_policies : {
        name = p.name
        mp   = mp
      }
    ])
    if p.managed_policies != []
  ])
}
