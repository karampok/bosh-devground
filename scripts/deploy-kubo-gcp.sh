#!/bin/bash
set -euo pipefail

state_dir="${ENV_DIR}/$DIRECTOR-${ENV_TYPE}"
kubo_deployment=~/workspace/kubo-deployment

deployment_dir="$state_dir/deployments/kubo"
mkdir -p "$deployment_dir"

STEMCELL_VERSION=$(bosh int $kubo_deployment/manifests/cfcr.yml --path /stemcells/alias=trusty/version)
bosh ss --json|grep "$STEMCELL_VERSION" || bosh upload-stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent?v="$STEMCELL_VERSION"
unset CPI_EXTRA_ARGS
bosh -n update-cloud-config --vars-env=CPI ${CPI_EXTRA_ARGS:-}  cloud-configs/$ENV_TYPE/cloud-config.yml
bosh update-runtime-config -n ops/empty-runtime.yml

bosh -n -d cfcr deploy --no-redact \
  -o ops/kubo-local-release.yml \
  "$@" \
 "$kubo_deployment"/manifests/cfcr.yml

# export KUBECONFIG="$deployment_dir/kuboconfig"
# credhub login -u ${CREDHUB_USER} -p ${CREDHUB_PASS} -s ${CREDHUB_SERVER}
# bosh int <(credhub get -n "/$DIRECTOR/cfcr/tls-kubernetes" ) --path=/value/ca > "$deployment_dir/kubernetes.crt"
# KUBERNETES_PWD=$(bosh int <(credhub get -n "/$DIRECTOR/cfcr/kubo-admin-password" --output-json) --path=/value)
# kubectl config set-cluster kubo --server https://master.kubo:8443 --embed-certs=true --certificate-authority="$deployment_dir/kubernetes.crt"
# kubectl config set-credentials "kubo-admin" --token=${KUBERNETES_PWD}
# kubectl config set-context kubo --cluster=kubo --user=kubo-admin
# kubectl config use-context kubo
# echo export KUBECONFIG="$deployment_dir/kuboconfig"

# cat <<EOF >${deployment_dir}/.envrc
# export BOSH_DEPLOYMENT=cfcr" > $deployment_dir/.envrc
# export KUBECONFIG="$deployment_dir/kuboconfig"
# EOF
