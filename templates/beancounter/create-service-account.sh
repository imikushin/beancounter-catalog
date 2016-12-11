#!/bin/bash
set -ex

RANCHER_URL=${RANCHER_URL:?'RANCHER_URL required, e.g.: http://172.16.232.168:8080'} # IMPORTANT: no slash ('/') after host:port

SERVICE_KEY=${SERVICE_KEY:?'SERVICE_KEY required, e.g.: service'}
SERVICE_PASS=${SERVICE_PASS:?'SERVICE_PASS required, e.g.: servicepass'}

AUTH="${USER_KEY}:${USER_PASS}"
if [ "${AUTH}" = ":" ]; then AUTH=""
else AUTH="-u ${AUTH}"
fi

# See if it exists
ID=$(curl -f ${AUTH} -X GET -H 'Accept: application/json' -H 'Content-Type: application/json' "${RANCHER_URL}/v1/accounts?uuid=${SERVICE_KEY}" | jq -r '.data[0].id')

[ "${ID}" = "" ] && exit 1

if [ "${ID}" = "null" ]; then
    # Create the account
    ID=$(curl -f ${AUTH} -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{"kind":"service", "name":"'"${SERVICE_KEY}"'", "uuid":"'"${SERVICE_KEY}"'"}' "${RANCHER_URL}/v1/accounts" | jq -r '.id')
    [ "${ID}" = "" ] && exit 1

    # Create api keys for the account
    curl -f ${AUTH} -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{"accountId":"'"${ID}"'", "name":"'"${SERVICE_KEY}"'", "publicValue":"'"${SERVICE_KEY}"'", "secretValue":"'"${SERVICE_PASS}"'"}' "${RANCHER_URL}/v1/apikeys"
fi
