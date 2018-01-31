#!/bin/bash
set -euo pipefail

kubo_deployment=~/workspace/kubo-deployment

state_dir="${ENV_DIR}/bosh-lite"
deployment_dir="$state_dir/deployments/cfcr" &&  mkdir -p "$deployment_dir"

STEMCELL_VERSION=$(bosh int $kubo_deployment/manifests/cfcr.yml --path /stemcells/alias=trusty/version)
bosh ss --json|grep "$STEMCELL_VERSION" || bosh upload-stemcell https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent?v="$STEMCELL_VERSION"

bosh -n update-cloud-config cloud-configs/virtualbox/cloud-config.yml

bosh -n -d cfcr deploy --no-redact \
  -o ops/kubo-local-release.yml \
  "$@" \
  "$kubo_deployment"/manifests/cfcr.yml

export KUBECONFIG="$deployment_dir/kuboconfig"
credhub login
bosh int <(credhub get -n /lite/cfcr/tls-kubernetes ) --path=/value/ca > "$deployment_dir/kubernetes.crt"
KUBERNETES_PWD=$(bosh int <(credhub get -n /lite/cfcr/kubo-admin-password --output-json) --path=/value)
kubectl config set-cluster kubo --server https://kubernetes:8443 --embed-certs=true --certificate-authority="$deployment_dir/kubernetes.crt"
kubectl config set-credentials "kubo-admin" --token=${KUBERNETES_PWD}
kubectl config set-context kubo --cluster=kubo --user=kubo-admin
kubectl config use-context kubo
echo export KUBECONFIG="$deployment_dir/kuboconfig"

cat <<EOF >${deployment_dir}/.envrc
export BOSH_DEPLOYMENT=cfcr
export KUBECONFIG="$deployment_dir/kuboconfig"
EOF
