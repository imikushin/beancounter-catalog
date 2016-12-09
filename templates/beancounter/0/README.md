## Installation

Make sure you have a service account with sufficient privileges. To do that, run [this Bash script](https://github.com/imikushin/beancounter-catalog/blob/master/templates/beancounter/create-service-account.sh)
to create a service account `service` with pass `servicepass`, e.g.:

```bash
RANCHER_URL=http://172.16.232.168:8080 ACCOUNT=service PASS=servicepass ./create-service-account.sh
```

To run that script, you need `curl` and `jq` installed.
