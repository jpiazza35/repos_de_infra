#!/bin/bash
cd /tmp

########################################################
############ STEP 1 - INSTALL PREREQUISITES ############
########################################################

# Install the Amazon SSM Agent
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# Update package list
sudo yum update -y

# Install docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install Vault
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install vault -y

#############################################################################
############ STEP 2 - READ CONFIGURATIONS AND SECRETS FROM VAULT ############
#############################################################################

export VAULT_ADDR=https://vault.cliniciannexus.com:8200

# Login to Vault
vault login -method=aws -path=${tf_var_account_id} header_value=vault.cliniciannexus.com role=${tf_var_account_id}-vault-aws-auth-role

# Read secrets from Vault
export docker_password=$(vault read -field='docker_password' ${bigeye_mtls_secret_name}  )
export company_uuid=$(vault read -field='company_uuid' ${bigeye_mtls_secret_name} )

# Set BigEye configuration values.
export BIGEYE_AGENT_IMAGE=docker.io/bigeyedata/agent:latest
export BIGEYE_AGENT_CONFIG_PATH=config
export BIGEYE_COMPANY_PREFIX=app # this is different for single-tenant saas
export BIGEYE_DOCKER_PASSWORD=$docker_password
export BIGEYE_COMPANY_UUID=$company_uuid

# mkdir for bigeye-agent
cd ~
echo 'Decoding secrets and creating directories'
echo $(pwd)
echo $BIGEYE_AGENT_CONFIG_PATH

mkdir -v $BIGEYE_AGENT_CONFIG_PATH
# # Save BigEye agent.yaml from vault secret to local file
echo 'Retrieving agent.yaml'
vault read -field='agent_yaml_b64' ${bigeye_mtls_secret_name} | base64 --decode  > $BIGEYE_AGENT_CONFIG_PATH/agent.yaml

# # Save BigEye docker compose file from vault secret to local file
echo 'Retrieving docker-compose.yaml'
vault read -field='docker_compose_yaml_b64' ${bigeye_mtls_secret_name} | base64 --decode > docker-compose.yaml

# # Save BigEye certs from vault secrets to local files
echo 'Retrieving company.pem'
vault read -field='company_pem_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/$BIGEYE_COMPANY_UUID.pem
echo 'Retrieving bigeye.pem'
vault read -field='bigeye_pem_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/bigeye.pem
echo 'Retrieving bigeye_workflows_ca.pem'
vault read -field='bigeye_workflows_ca_pem_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/bigeye_workflows_ca.pem
echo 'Retrieving mtls.conf'
vault read -field='mtls_conf_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/mtls.conf
echo 'Retrieving mtls.key'
vault read -field='mtls_key_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/mtls.key
echo 'Retrieving mtls.pem'
vault read -field='mtls_pem_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/mtls.pem
echo 'Retrieving mtls_ca.conf'
vault read -field='mtls_ca_conf_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/mtls_ca.conf
echo 'Retrieving mtls_ca.key'
vault read -field='mtls_ca_key_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/mtls_ca.key
echo 'Retrieving mtls_ca.pem'
vault read -field='mtls_ca_pem_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/mtls_ca.pem
echo 'Retrieving private.key'
vault read -field='private_key_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/private.key
echo 'Retrieving private.pem'
vault read -field='private_pem_b64' ${bigeye_mtls_secret_name} | base64 --decode > $BIGEYE_AGENT_CONFIG_PATH/private.pem


echo 'Agent.yaml parameters'
echo ${agent_identifier}

# Reading type from Vault Secret
export bigeye_source_type=$(vault read -field='type' ${bigeye_agent_config_secret_name})

echo ${bigeye_source_type}
export bigeye_source_identifier=${agent_identifier}-host
export bigeye_source_host=$(vault read -field='host' ${bigeye_agent_config_secret_name})
export bigeye_source_port=$(vault read -field='port' ${bigeye_agent_config_secret_name})
export bigeye_source_username=$(vault read -field='username' ${bigeye_agent_config_secret_name})
export bigeye_source_password=$(vault read -field='password' ${bigeye_agent_config_secret_name})

# Reading databases from Vault Secret and looping over them
read -a databaseNames <<< $(vault read -field='databases' ${bigeye_agent_config_secret_name})

# Initialize an empty list for bigeye_databases
bigeye_databases=()

for dbname in "${databaseNames[@]}"; do
  export bigeye_source_databaseName_$dbname=$(vault read -field='databaseName' ${bigeye_agent_config_secret_name})
  
  # Add database to bigeye_databases list
  bigeye_databases+=("$dbname")
done

# Export bigeye_databases as a space-separated string
export bigeye_databases=$(printf "%s " "${bigeye_databases[@]}")
echo 'Done decoding secrets and creating directories'

####################################################
############ STEP 3 - PULL BIGEYE IMAGE ############
####################################################

# Login to Docker repository
sudo docker login -u bigeyedata -p $BIGEYE_DOCKER_PASSWORD
# # Pull agent image to local Docker host
sudo docker pull $BIGEYE_AGENT_IMAGE

    # Pull docker-compose file from bigeye-public-web S3 bucket
    # wget https://bigeye-public-web.s3.amazonaws.com/bigeye-agent-docker-compose.yaml --output-document=docker-compose.yaml
    ############ Official docker-compose.yaml file only allows passing USERNAME and PASSWORD as env vars, which makes not possible to automate.

###################################################
############ STEP 4 - RUN BIGEYE AGENT ############
###################################################

# Run docker-compose file
# UNCOMMENT THE FOLLOWING IF DEBUGGING
# docker-compose config
docker-compose up -d
