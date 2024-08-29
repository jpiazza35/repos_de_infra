locals {
  prefix = format("%s-%s", var.env, var.app)

  private_link = {
    relay_service     = "com.amazonaws.vpce.us-east-1.vpce-svc-00018a8c3ff62ffdf"
    workspace_service = "com.amazonaws.vpce.us-east-1.vpce-svc-09143d1e626de2f04"
  }

  ad_group_assignments = flatten([
    for p in var.groups : [
      for g in p : {
        g = g
      }
    ]
  ])

}

