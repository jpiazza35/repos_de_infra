#Kraft - Kraft controller
data "kubectl_file_documents" "confluent_kraft_broker_controller" {
  content = templatefile("${path.module}/manifests/kraft/kraftbroker_controller.yaml", {
  })
}

#Kraft - confluent-platform
data "kubectl_file_documents" "confluent_kraft_producer_app_data" {
  content = templatefile("${path.module}/manifests/kraft/confluent-platform.yaml", {
  })
}

#confluent-platform
data "kubectl_file_documents" "confluent_confluent_platform" {
  content = templatefile("${path.module}/manifests/confluent-platform.yaml", {
  })
}

#Kraft - producer-app-data
data "kubectl_file_documents" "confluent_producer_app_data" {
  content = templatefile("${path.module}/manifests/producer-app-data.yaml", {
  })
}



