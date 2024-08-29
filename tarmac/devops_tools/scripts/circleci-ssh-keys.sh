#!/bin/bash
# This script will rotate all SSH keys in CircleCI projects that the user running it follows (Follow All is recommended). 
# Use a machine user to log in to CircleCI and create a Persona API token.

circle_token="" # Machine user CircleCI API token. Log in with this user to CircleCI and visit https://app.circleci.com/settings/user/tokens
org="" # Organization name in VSC provider
vsc_provider="" # Can be gh or bitbucket

org_repos=$(curl https://circleci.com/api/v1.1/projects -H "Circle-Token: ${circle_token}" | jq -r '.[] | select(.username == "'${org}'") | .reponame' >> repos-${org}) 
echo $org_repos
input="./repos-${org}"

while read -r repo; do 
  # GET deploy-key from project
  echo "Repo:" $repo
  fingerprints=$(curl -fsS -H "Circle-Token: ${circle_token}" "https://circleci.com/api/v2/project/${vsc_provider}/${org}/${repo}/checkout-key" | jq -r 'select(.items[]) | .items[].fingerprint')
  echo $fingerprints
  # Delete deploy-key from project
  echo ${fingerprints} | while read fingerprint; do curl -fsS -X DELETE -H "Circle-Token: ${circle_token}" "https://circleci.com/api/v2/project/${vsc_provider}/${org}/${repo}/checkout-key/${fingerprint}"; done
  
  # Create new deploy-key to project
  curl -fsS -X POST -H "Circle-Token: ${circle_token}" -H "content-type: application/json"  -d '{"type":"deploy-key"}' "https://circleci.com/api/v2/project/${vsc_provider}/${org}/${repo}/checkout-key"
done < "$input"