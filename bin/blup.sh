#!/bin/bash
set -euo pipefail

state_dir="${ENV_DIR}/bosh-lite"
mkdir -p "${state_dir}"
bosh_deployment=~/workspace/bosh-deployment

export BOSH_LOG_LEVEL=debug
export BOSH_LOG_PATH="$state_dir"/bosh-debug.log
export CPI_external_ip=192.168.50.6
export CPI_internal_ip=192.168.50.6
export CPI_internal_gw=192.168.50.1
export CPI_internal_cidr=192.168.50.0/24
export CPI_dns_recursor_ip=192.168.50.6
export CPI_outbound_network_name=NatNetwork

bosh create-env \
  -v director_name=lite \
  --vars-store $state_dir/bosh-vars.yml \
  --state $state_dir/bosh/bosh-state.json \
  -o "$bosh_deployment/virtualbox/cpi.yml" \
  -o "$bosh_deployment/jumpbox-user.yml" \
  -o "$bosh_deployment/uaa.yml" \
  -o "$bosh_deployment/credhub.yml" \
  -o "$bosh_deployment/local-dns.yml" \
  -o "${bosh_deployment}/bosh-lite.yml" \
  -o "${bosh_deployment}/virtualbox/outbound-network.yml" \
  -o "${bosh_deployment}/bosh-lite-runc.yml" \
  --vars-env=CPI \
  "$bosh_deployment/bosh.yml"


rm -f  ${state_dir}/id_rsa_jumpbox || true
bosh int ${state_dir}/bosh-vars.yml --path /jumpbox_ssh/private_key > ${state_dir}/id_rsa_jumpbox
chmod 400 ${state_dir}/id_rsa_jumpbox

cat <<EOF >${state_dir}/bosh-envs
export BOSH_CLIENT=admin
BOSH_CLIENT_SECRET=\$(bosh int ${state_dir}/bosh-vars.yml --path /admin_password)
export BOSH_CLIENT_SECRET
export BOSH_CA_CERT=\$(bosh int ${state_dir}/bosh-vars.yml --path /director_ssl/ca)
export BOSH_ENVIRONMENT=${CPI_external_ip}
export BOSH_GW_USER=jumpbox
export BOSH_GW_HOST="${CPI_external_ip}"
export BOSH_GW_PRIVATE_KEY=${state_dir}/id_rsa_jumpbox
export CREDHUB_SERVER="https://${CPI_external_ip}:8844"
export CREDHUB_USER="credhub-cli"
export CREDHUB_PASS=\$(bosh int ${state_dir}/bosh-vars.yml --path /credhub_cli_password)
export CREDHUB_CA_CERT=\$(bosh int ${state_dir}/bosh-vars.yml --path /uaa_ssl/ca;bosh int ${state_dir}/bosh-vars.yml --path /credhub_tls/ca)
#credhub login -u \$CREDHUB_USER -p \$CREDHUB_PASS
EOF

echo "source ${state_dir}/bosh-envs"
echo "ssh jumpbox@${CPI_external_ip} -i ${state_dir}/id_rsa_jumpbox"
echo "sudo route add -net 10.244.0.0/16 192.168.50.6"
