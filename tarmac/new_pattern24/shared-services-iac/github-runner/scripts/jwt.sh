#!/usr/bin/env bash
set -e

thisdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -o pipefail

# Change these variables:
app_id=376578
app_private_key="github_app_key.pem"

## Download pem file
certificate_secrets_file="private_key.pem"

aws secretsmanager get-secret-value \
    --region us-east-1 \
    --secret-id github-runner \
    --query "SecretString" \
    --output text \
    | jq -r .private_key > "$certificate_secrets_file"

cat "$certificate_secrets_file" | tr -d '"' | base64 --decode > "$app_private_key"

app_private_key="$(< $thisdir/github_app_key.pem)"

# Shared content to use as template
header='{
    "alg": "RS256",
    "typ": "JWT"
}'

payload_template='{}'

build_payload() {
        jq -c \
                --arg iat_str "$(date +%s)" \
                --arg app_id "${app_id}" \
        '
        ($iat_str | tonumber) as $iat
        | .iat = $iat
        | .exp = ($iat + 300)
        | .iss = ($app_id | tonumber)
        ' <<< "${payload_template}" | tr -d '\n'
}

b64enc() { openssl enc -base64 -A | tr '+/' '-_' | tr -d '='; }

json() { jq -c . | LC_CTYPE=C tr -d '\n'; }

rs256_sign() { openssl dgst -binary -sha256 -sign <(printf '%s\n' "$1"); }

sign() {
    local algo payload sig
    algo=${1:-RS256}; algo=${algo^^}
    payload=$(build_payload) || return
    signed_content="$(json <<<"$header" | b64enc).$(json <<<"$payload" | b64enc)"
    sig=$(printf %s "$signed_content" | rs256_sign "$app_private_key" | b64enc)
    printf '%s.%s\n' "${signed_content}" "${sig}"
}

sign
