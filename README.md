# Step 0 - Configure environment 

```
cat .envrc
  > export DIRECTOR=k10s  #director name
  > export ENV_TYPE=virtualbox
  > export ENV_DIR=$PWD/environments
  > export PATH=$PATH:bin
```

# Step 1 - Create Credentials in the CPI
pre-cpi

# Step 2 - Terraform the infrastructure
tform-me

# Step 3 - Deploy bosh director
bosh-me

# Step 4 - Deploy Software
Deploy cf or cfcr

## Deploy CFCR Virtualbox

```
#sudo route add -net 10.244.0.0/16 192.168.50.6

# cat /etc/hosts|grep master
# 10.244.0.128 master.kubo

> diff --git a/jobs/flanneld/templates/bin/flanneld_ctl.erb b/jobs/flanneld/templates/bin/flanneld_ctl.erb
> -  modprobe br_netfilter
> +  modprobe br_netfilter || true
```

```
 ./scripts/deploy-kubo-lite.sh
```
