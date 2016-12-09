#!/bin/bash
set -ex

RANCHER_URL=${RANCHER_URL:?'RANCHER_URL required, e.g.: http://172.16.232.168:8080'} # IMPORTANT: no slash ('/') after host:port
ACCOUNT=${ACCOUNT:?'ACCOUNT required, e.g.: service'}
PASS=${PASS:?'PASS required, e.g.: servicepass'}

# See if it exists
ID=$(curl  -X GET -H 'Accept: application/json' -H 'Content-Type: application/json' "${RANCHER_URL}/v1/accounts?uuid=${ACCOUNT}" | jq -r '.data[0].id')

if [ ${ID} == "null" ]; then
    # Create the account
    ID=$(curl  -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{"kind":"service", "name":"${ACCOUNT}", "uuid":"${ACCOUNT}"}' "${RANCHER_URL}/v1/accounts" | jq -r '.id')

    # Create api keys for the account
    curl  -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' -d "{\"accountId\":\"$ID\", \"name\":\"${ACCOUNT}\", \"publicValue\":\"${ACCOUNT}\", \"secretValue\":\"${PASS}\"}" "${RANCHER_URL}/v1/apikeys"
fi
