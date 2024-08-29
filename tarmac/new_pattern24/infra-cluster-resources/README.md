# infra-cluster-resources
This will hold the code to deploy cluster resources.

This is the current folder structure:

```

📦eks_cluster
 ┣ 📂envvars
 ┃ ┃ ┣ 📜env.tfvars
 ┣ 📜 cluster terraform files

```

The `eks_cluster` folder contains a specific solution that is environment agnostic. It includes the main Terraform file (`main.tf`) that consumes the Terraform modules found in the `modules` folder.


## EKS Module

The `eks` module creates an EKS cluster with the following resources:

- Amazon EKS cluster
- Amazon EC2 instances for worker nodes
- Amazon IAM roles for the cluster and nodes
- Amazon Security Groups

The `1_eks` module has the following variables:

- `aws_region`: AWS region where the EKS cluster will be deployed.
- `cluster_version`: Version of Kubernetes to use.
- `instance_types`: Amazon EC2 instance type for worker nodes.
- `min_size`: Minimum number of worker nodes.
- `max_size`: Maximum number of worker nodes.
- `des_size`: Desired number of worker nodes.
- `ebs_csi_addon_version`: Version of the EBS driver.
- `iam_roles`: Map of IAM Roles mapped as system:masters inside k8s.
- `key_name`: SSH key used to deploy the nodes.
- `is_eks_api_public`: Boolean value for making k8s API public available.
- `is_eks_api_private`: Boolean value for making k8s API private available.
- `ami_type`: Type of AMI to use for the nodes.

## Usage

To deploy the EKS cluster, use the corresponding GHA.

### Notes

- The `terraform.tfstate` file will be generated in the SS_Tools account. This file contains the state of the Terraform resources and should be stored securely.
- To destroy the resources, run `terraform destroy -var-file=envvars/ENV.tfvars.example`.
- Terraform version 1.4.5 is required to use this code.


### To create an External Secret using the Cluster Secret Store
```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: vault-secret-cluster ## Name of the external secret managing the cluster secret
  namespace: mpt-apps ## Namespace to create the secret
spec:
  refreshInterval: "15s" # How often this secret is synchronized
  secretStoreRef:
    name: vault-backend # Name of the ClusterSecretStore
    kind: ClusterSecretStore
  target: # Our target Kubernetes Secret to be created in the cluster's namespace
    name: vault-secret-rancher-123 # If not present, then the secretKey field under data will be used
    creationPolicy: Owner # This will create the secret if it doesn't exist
  data:
    - secretKey: vault-secret-rancher ## Will be used if target is not set
      remoteRef:
        key: dev/rancher # This is the remote key in vault
        property: rancherpass # The property inside of the secret in vault
```
