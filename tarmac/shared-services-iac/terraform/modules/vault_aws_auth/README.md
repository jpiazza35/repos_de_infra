### Vault AWS Auth

There is a requirement to authenticate with vault from AWS, the new feature in this directory will create an aws auth for vault that will allow EC2 instances and other resources in our AWS accounts authenticate with vault.

To log in to vault using aws auth, run the following command: 
```bash
export VAULT_ADDR=https://vault.cliniciannexus.com:8200

vault login -method=aws -path=<aws_account_id> header_value=vault.cliniciannexus.com  role=<aws_account_id>-vault-aws-auth-role
```
