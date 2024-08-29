#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

waitforurl() {
  # timeout -s TERM 45 bash -c \
  while [[ "$(curl -k -s -o /dev/null -L -w ''%%{http_code}'' $1)" != "200" ]]; do sleep 2; done
}

# Detect package management system.
APT_GET=$(which apt-get 2>/dev/null)

sudo apt-get update
sudo apt update 

user_ubuntu() {
  # UBUNTU user setup
  if ! getent group $2 >/dev/null
  then
    sudo addgroup --system $2 >/dev/null
  fi

  if ! getent passwd $1 >/dev/null
  then
    sudo adduser \
      --system \
      --disabled-login \
      --ingroup $2 \
      --home $3 \
      --no-create-home \
      --gecos "$4" \
      --shell /bin/false \
      $1  >/dev/null
  fi
}

echo "Setting up user vault for Debian/Ubuntu"
user_ubuntu "vault" "vault" "/etc/vault" "Hashicorp vault user"

apt-get install jq unzip -y

curl -s https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/${arch_version}/latest/amazon-cloudwatch-agent.deb --output /tmp/amazon-cloudwatch-agent.deb
dpkg -i -E /tmp/amazon-cloudwatch-agent.deb


echo "installing AWS CLI"

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`

REGION=`curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`

# ASG_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$(INSTANCE_ID)" "Name=key,Values=aws:autoscaling:groupName")
ASG_NAME=`aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID"  --region $REGION | jq '.Tags[] | select(.["Key"] | contains("aws:autoscaling:groupName")) | .Value'`
ASG_NAME=`echo $ASG_NAME | tr -d '"'`
PRIVATE_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

echo "Amazon Cloudwatch Agent"

cat << EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "agent": {
    "metrics_collection_interval": 300,
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
  },
  "logs": {
        "force_flush_interval": 15,
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/vault_audit.log",
                        "log_group_name": "${environment}-${app_name}",
                        "log_stream_name": "vaultaudit-{instance_id}",
                        "timezone": "Local"
                    },
                    {
                        "file_path": "/var/log/secure",
                        "log_group_name": "${environment}-${app_name}",
                        "log_stream_name": "secure-{instance_id}",
                        "timezone": "Local"
                    },
                    {
                        "file_path": "/var/log/messages",
                        "log_group_name": "${environment}-${app_name}",
                        "log_stream_name": "messages-{instance_id}",
                        "timezone": "Local"
                    }
                ]
            }
        }
    },
  "metrics": {
    "metrics_collected": {
      "disk": {
        "metrics_collection_interval": 600,
        "resources": [
          "/"
        ],
        "measurement": [
          {"name": "disk_free", "rename": "DISK_FREE", "unit": "Gigabytes"}
        ]
      },
      "mem": {
        "metrics_collection_interval": 600,
        "measurement": [
          {"name": "mem_free", "rename": "MEM_FREE", "unit": "Megabytes"},
          {"name": "mem_total", "rename": "MEM_TOTAL", "unit": "Megabytes"},
          {"name": "mem_used", "rename": "MEM_USED", "unit": "Megabytes"}
        ]
      }
    },
    "append_dimensions": {
          "AutoScalingGroupName": "$ASG_NAME",
          "InstanceId": "{instance_id}"
    },
    "aggregation_dimensions" : [
            ["AutoScalingGroupName"],
            ["InstanceId"],
            []
        ]
  }
}
EOF
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
systemctl enable amazon-cloudwatch-agent.service

curl --silent --output /tmp/vault.zip ${vault_url}
unzip -o /tmp/vault.zip -d /sbin/
chmod 0755 /sbin/vault
mkdir -pm 0755 /etc/vault
chown vault:vault /etc/vault


cat << EOF > /lib/systemd/system/vault.service
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault/vault.hcl
StartLimitIntervalSec=60
StartLimitBurst=3
[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/sbin/vault server -config=/etc/vault/vault.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitInterval=60
StartLimitIntervalSec=60
StartLimitBurst=3
LimitNOFILE=65536
LimitMEMLOCK=infinity
[Install]
WantedBy=multi-user.target
EOF


openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout /etc/vault/vault_ssl.key -out /etc/vault/vault_ssl.crt -subj "/CN=vault.local"

cat << EOF > /etc/vault/vault.hcl
storage "dynamodb" {
  region     = "${aws_region}"
  table      = "${environment}-${app_name}"
  ha_enabled = "true"
}

listener "tcp" {
  address = "[::]:8200"
  cluster_address = "[::]:8201"
  tls_disable   = false
  tls_cert_file = "/etc/vault/vault_ssl.crt"
  tls_key_file = "/etc/vault/vault_ssl.key"
}

seal "awskms" {
  region     = "${aws_region}"
  kms_key_id = "${kms_key}"
}

telemetry {
  disable_hostname = true
  prometheus_retention_time = "12h"
}

ui = true
api_addr = "https://${cluster_dns_name}:8200"
cluster_addr = "https://$PRIVATE_IP:8201"
# cluster_addr = "https://127.0.0.1:8201"
cluster_name = "clinician-nexus-vault"
log_level = "ERROR"
disable_mlock = true

EOF

chown -R vault:vault /etc/vault
chmod -R 0644 /etc/vault/*
touch /var/log/vault_audit.log
chown vault:vault /var/log/vault_audit.log

cat << EOF > /etc/profile.d/vault.sh
export VAULT_ADDR=https://$PRIVATE_IP:8200
export VAULT_SKIP_VERIFY=true
EOF

systemctl daemon-reload
systemctl enable vault
systemctl start vault

export VAULT_ADDR=https://$PRIVATE_IP:8200
export VAULT_SKIP_VERIFY=true

echo "waiting vault boot"
waitforurl https://$PRIVATE_IP:8200/v1/sys/seal-status
echo "vault is available"

# Stop vault
systemctl stop vault

#Delete all items in Dynamodb
export DYNAMO_TABLE="${environment}-${app_name}"

export KEY_SCHEMA="$(aws dynamodb describe-table \
    --table-name $DYNAMO_TABLE | \
    jq -r '.Table.KeySchema[].AttributeName' | \
    tr '\n' ' ')"

aws dynamodb scan \
  --table-name $DYNAMO_TABLE \
  --attributes-to-get $KEY_SCHEMA | \
  jq -r ".Items[] | tojson" | \
  tr '\n' '\0' | xargs -0 -I keyItem \
  aws dynamodb delete-item \
    --table-name $DYNAMO_TABLE \
    --key=keyItem

# Restart vault
systemctl start vault

sleep 3s
## Initialize Vault

INIT=$(vault operator init -recovery-shares=1 -recovery-threshold=1 -format=json || true)

ROOT_TOKEN="$(echo $INIT | jq .root_token -r)"
RECOVERY_KEY="$(echo $INIT | jq .recovery_keys_b64[0] -r)" > /dev/null 2>&1

echo "Saving root token on ssm:///${app_name}/root/token"
if [ $ROOT_TOKEN != '' ]
then
  aws ssm put-parameter --name '/${app_name}/root/token' --value "$ROOT_TOKEN" --type SecureString --region ${aws_region} --overwrite > /dev/null 2>&1
else
  echo "Vault already Initialized, root token is empty"
fi

## Rename Instances based on role
leader=$(vault status -format json | jq -r .is_self)

if [ "$( echo $leader)" == "true" ]
then 
  echo "This is the Leader/Active Node"
  echo "renaming the instance"

  aws ec2 create-tags --resources $INSTANCE_ID --tag Key=Name,Value="${environment}-${app_name}-leader"

else
  echo "This is the standby node"
  echo "renaming the instance"

  aws ec2 create-tags --resources $INSTANCE_ID --tag Key=Name,Value="${environment}-${app_name}-standby"

  echo "Vault Installation and Configuration Completed Successfully!"

  exit 0

fi

STATUS=$(vault status -format=json)
if [ "$(echo $STATUS | jq .initialized)" == "false" ]
then
  STATUS2=$(vault status -format=json )
  if [ "$(echo $STATUS2 | jq .sealed)" == "false" ]
  then
    echo "vault setup completed"

    export VAULT_TOKEN=$ROOT_TOKEN
    echo "Setting Audit file"
    vault audit enable file file_path=/var/log/vault_audit.log

    cat << EOF > /tmp/admin.hcl
path "*"
{
capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF
    echo "Creating Admin Policy"
    vault policy write admin /tmp/admin.hcl
    echo "Enabling userpass"
    vault auth enable userpass
    echo "setting admin user"
    PASS=$(openssl rand -base64 18)
    echo "setting vault root username and passwd"
    vault write auth/userpass/users/root password="$PASS" policies=admin,default

    echo "Saving root token on ssm:///${app_name}/root/token"
    aws ssm put-parameter --name '/${app_name}/root/token' --value "$ROOT_TOKEN" --type SecureString --region ${aws_region} --overwrite > /dev/null 2>&1
    echo "Saving root password on ssm:///${app_name}/root/pass"
    aws ssm put-parameter --name '/${app_name}/root/pass'  --value "$PASS"  --type SecureString --region ${aws_region} --overwrite > /dev/null 2>&1
  else
    echo "Error on vault setup"
    echo $STATUS2
  fi

else
  echo "vault is initialized and configured"
fi

## login to Vault
export VAULT_TOKEN=$ROOT_TOKEN

## Define policy for the kv
vault policy write kv-read -<<EOF
path "cubbyhole/*" {
capabilities = ["read", "list"]
}
EOF

## Set up Azure OIDC
vault auth enable oidc

export VAULT_LOGIN_ROLE=readers

export AD_VAULT_APP_ID=$(aws secretsmanager get-secret-value --secret-id vault-azure-oidc | jq --raw-output '.SecretString' | jq -r .APP_ID)

export AD_CLIENT_SECRET=$(aws secretsmanager get-secret-value --secret-id vault-azure-oidc | jq --raw-output '.SecretString' | jq -r .CLIENT_SECRET)

export AD_TENANT_ID=$(aws secretsmanager get-secret-value --secret-id vault-azure-oidc | jq --raw-output '.SecretString' | jq -r .TENANT_ID)

vault write -tls-skip-verify auth/oidc/config \
    oidc_client_id="$AD_VAULT_APP_ID" \
    oidc_client_secret="$AD_CLIENT_SECRET" \
    default_role="$VAULT_LOGIN_ROLE" \
    oidc_discovery_url="https://login.microsoftonline.com/$AD_TENANT_ID/v2.0"

vault write -tls-skip-verify auth/oidc/role/$VAULT_LOGIN_ROLE \
  user_claim="email" \
  allowed_redirect_uris="http://localhost:8250/oidc/callback" \
  allowed_redirect_uris="https://${cluster_dns_name}:8200/ui/vault/auth/oidc/oidc/callback"  \
  policies="kv-read,default" \
  oidc_scopes="https://graph.microsoft.com/.default"

## Enable the mount point for oidc as an option in the UI
vault auth tune -listing-visibility=unauth -description="Azure" oidc/

## Enable Audit Logs
vault audit enable file file_path=/var/log/vault_audit.log

## Enable Usage Metrics
vault policy write usage-metrics - << EOF
# To retrieve the usage metrics
path "sys/internal/counters/activity" {
  capabilities = ["read"]
}

# To read and update the usage metrics configuration
path "sys/internal/counters/config" {
  capabilities = ["read", "update"]
}
EOF

vault write sys/internal/counters/config enabled=enable retention_months=6

## Allow Prometheus Metrics
vault policy write prometheus-metrics - << EOF
path "/sys/metrics" {
  capabilities = ["read"]
}
EOF

echo "Vault Installation and Configuration Completed Successfully!"

