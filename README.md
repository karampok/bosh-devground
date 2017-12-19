# Howto

```
cat .envrc #Step 0. Configure environment
  > export DIRECTOR=k10s
  > export ENV_TYPE=virtualbox
  > export ENV_DIR=$PWD/environments
  > export PATH=$PATH:bin

#Step 1. Create Credentials in the CPI
pre-cpi

#Step 2 - Terraform the infrastructure
tform-me

# Step 3 - Deploy bosh director
bosh-me

#Deploy cf or cfcr
 ./scripts/deploy-kubo-lite.sh
```

## Prereqs for deploying CFCR Virtualbox

For Virtualbox (bosh-lite) step 1 and step 2 are more or less dummy steps.

```
#sudo route add -net 10.244.0.0/16 192.168.50.6

# cat /etc/hosts|grep master
# 10.244.0.128 master.kubo

> diff --git a/jobs/flanneld/templates/bin/flanneld_ctl.erb b/jobs/flanneld/templates/bin/flanneld_ctl.erb
> -  modprobe br_netfilter
> +  modprobe br_netfilter || true
```
