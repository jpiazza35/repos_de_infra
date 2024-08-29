#!/bin/bash
set -e

ORGANIZATION="clinician-nexus"
ACCESS_TOKEN=$(bash jwt.sh)
INSTALLATION_ID=40761900
RUNNER_NAME="ss-runner"
RUNNER_NAME_SUFFIX=$(echo $RANDOM | base64| awk '{print tolower($0)}' | head -c 6; echo;)

INSTALLATION_TOKEN=$(curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/app/installations/${INSTALLATION_ID}/access_tokens \
  | jq -r .token
)

REG_TOKEN=$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token ${INSTALLATION_TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token \
  | jq -r .token
)

cd /actions-runner

./config.sh --unattended --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN} --labels sharedservices --name ${RUNNER_NAME}-${RUNNER_NAME_SUFFIX} --replace

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
