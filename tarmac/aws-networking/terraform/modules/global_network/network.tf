resource "aws_networkmanager_global_network" "network" {
  description = "Global Network supporting the organization."
  tags = merge(
    var.tags,
    {
      Name           = var.name
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}
