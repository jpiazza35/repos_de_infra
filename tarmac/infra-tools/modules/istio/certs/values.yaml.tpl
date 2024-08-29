certs:
  name: ${name}
  env: ${env}
  project: ${project}
  aws_region: ${aws_region}
  iac: "deployed-via-terraform"
  email: ${email}
  dns_zone: ${cert_manager_dns_zone}
  dns_zone_id: ${cert_manager_dns_zone_id}
  istio_gw_name: ${istio_gw_name}
  istio_namespace: ${istio_namespace}
  istio_dns_record: ${istio_dns_record}
  istio_cert_secret_name: ${istio_cert_secret_name}
