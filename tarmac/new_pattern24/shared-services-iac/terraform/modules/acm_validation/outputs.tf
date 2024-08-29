output "fqdns" {
  value = [
    for record in aws_route53_record.certs : record.fqdn
  ]
}
