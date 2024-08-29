## Commented out for the use of cluter_name from the infra-clsuter-resources repo.

# locals {

#   cluster_name = [
#     for c in [
#       for eks in data.aws_eks_clusters.cluster.names : eks
#     ] : c
#   ]

# }
