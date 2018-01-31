#!/bin/bash
set -euo pipefail

bosh upload-stemcell https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent

#TODO. do not execute the command if stemcell exists
bosh -n update-cloud-config cloud-configs/virtualbox/cloud-config.yml

bosh -n -d cfcr deploy --no-redact \
  -o ops/kubo-local-release.yml \
  "$@" \
  ~/workspace/kubo-deployment/manifests/cfcr.yml

deployment_dir="${ENV_DIR}/bosh-lite/deployments/cfcr" &&  mkdir -p "$deployment_dir"
export KUBECONFIG="$deployment_dir/kuboconfig"
credhub login
bosh int <(credhub get -n /lite/cfcr/tls-kubernetes ) --path=/value/ca > "$deployment_dir/kubernetes.crt"
KUBERNETES_PWD=$(bosh int <(credhub get -n /lite/cfcr/kubo-admin-password --output-json) --path=/value)
kubectl config set-cluster kubo --server https://kubernetes:8443 --embed-certs=true --certificate-authority="$deployment_dir/kubernetes.crt"
kubectl config set-credentials "kubo-admin" --token=${KUBERNETES_PWD}
kubectl config set-context kubo --cluster=kubo --user=kubo-admin
kubectl config use-context kubo
echo export KUBECONFIG="$deployment_dir/kuboconfig"
