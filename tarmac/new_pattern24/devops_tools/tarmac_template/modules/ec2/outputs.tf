
output "ec2_instance" {
  description = "instance"
  value       = aws_instance.instance2
}

output "instance_network_interface_id" {
  description = "Network interface id"
  value       = aws_network_interface.instance_interface2.id
}

