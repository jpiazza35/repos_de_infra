#!/bin/sh
set -ex

# This script generates the environment variables for the incident bot
export VAULT_ADDR="${VAULT_ADDR}"
export VAULT_TOKEN="${VAULT_TOKEN}"

## Get secrets from vault
vault kv get -field=env devops/incident-bot > .env
