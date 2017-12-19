#!/bin/bash
set -euo pipefail


state_dir="${ENV_DIR}/$DIRECTOR-${ENV_TYPE}"
cf_deployment=~/workspace/cf-deployment
director_ip=192.168.50.6

deployment_dir="$state_dir/deployments/kubo"
mkdir -p "$deployment_dir"


STEMCELL_VERSION=$(bosh int ~/workspace/cf-deployment/cf-deployment.yml --path /stemcells/alias=default/version)
bosh ss --json|grep "$STEMCELL_VERSION" || bosh upload-stemcell https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent?v="$STEMCELL_VERSION"
bosh -n update-cloud-config "$cf_deployment"/iaas-support/bosh-lite/cloud-config.yml
bosh update-runtime-config -n ops/empty-runtime.yml
bosh -n -d cf deploy --no-redact \
  --vars-store "$deployment_dir/cf-vars.yml" \
  -o "$cf_deployment"/operations/bosh-lite.yml \
  -o "$cf_deployment"/operations/use-compiled-releases.yml \
  -o "$cf_deployment"/operations/scale-to-one-az.yml \
  -v system_domain="bosh-lite.com" \
  "$@" \
  "$cf_deployment"/cf-deployment.yml

echo "export BOSH_DEPLOYMENT=cf" > $deployment_dir/.envrc
  #-o "$cf_deployment"/operations/experimental/use-bosh-dns.yml \
