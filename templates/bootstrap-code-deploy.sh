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

# service codedeploy-agent start
service codedeploy-agent status

log 'Finished ...'
