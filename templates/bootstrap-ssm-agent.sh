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

systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
systemctl status amazon-ssm-agent

log 'Finished ...'
