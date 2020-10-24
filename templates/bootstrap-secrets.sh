#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

BASENAME=$(basename "$${0}")
function log {
  local MESSAGE=$${1}
  echo "$${BASENAME}: $${MESSAGE}"
  logger --id "$${BASENAME}: $${MESSAGE}"
}

log 'Started ...'

export CFG_API_URL=$(aws ssm get-parameter --name ${api_url} | jq -r '.Parameter.Value')
log "API URL: $${CFG_API_URL}"

export CFG_API_KEY=$(aws ssm get-parameter --with-decryption --name ${api_key} | jq -r '.Parameter.Value')
log "API KEY: $${CFG_API_KEY}"

export CFG_SECRET=$(aws secretsmanager get-secret-value --secret-id ${database_secret} --version-stage AWSCURRENT | jq -r '.SecretString')
log "SECRET: $${CFG_SECRET}"

log 'Finished ...'
