# Configuration templates

The two config files (agent.yaml and docker-compose.yaml) in this folder need to MANUALLY be base64 encoded and added to HC vault. Make sure to remove all new lines in the encoding. Save to HC Vault as a single line string.

The [User Data Script](../user_data.sh) loads these files from HC Vault decodes them and stores them in the agent configuration folder.

## IMPORTANT ##

Making changes to this template, encoding it and uploading it to HC Vault WILL affect all running agents of BigEye on their next initialization.
