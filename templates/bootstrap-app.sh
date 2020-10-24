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

cd /usr/local/src/
ls -la
cd django-dashboard-black

docker-compose -f docker-compose-cloud.yml pull
docker-compose -f docker-compose-cloud.yml build --parallel
docker-compose -f docker-compose-cloud.yml up --detach --no-color --force-recreate

log 'Finished ...'
