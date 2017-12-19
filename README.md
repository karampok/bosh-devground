# Prerequirement

Deployment release repositories to exist in `~/workspace`

```
$ ls -d  ~/workspace/{bosh,cf,kubo}-deployment ~/workspace/kubo-release/
> /Users/taakako1/workspace/bosh-deployment /Users/taakako1/workspace/cf-deployment   /Users/taakako1/workspace/kubo-deployment /Users/taakako1/workspace/kubo-release/
$ echo $?
> 0
```

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

# kubo deployment ([deploys local cfcr](https://github.com/karampok/bosh-devground/blob/dc65f40ad0316d59f967fd725c29da375c0625d0/scripts/deploy-kubo-lite.sh#L16)
> diff --git a/jobs/flanneld/templates/bin/flanneld_ctl.erb b/jobs/flanneld/templates/bin/flanneld_ctl.erb
> -  modprobe br_netfilter
> +  modprobe br_netfilter || true
```


# Environment Directory

All the important information in order to access the setup (terraform,
bosh-director, cf or cfcr deployments) are stored in the environment directory
(`ENV_DIR`).  That content of that folder should be encrypted or saved in private
repository.

```
environments/
└── k10s-virtualbox
    ├── bosh
    │   ├── debug.log
    │   ├── env
    │   ├── id_rsa_jumpbox
    │   ├── input.args
    │   ├── state.json
    │   └── vars.yml
    ├── deployments
    │   └── kubo
    │       ├── kubernetes.crt
    │       └── kuboconfig
    └── terraform
        ├── terraform.tfstate
        ├── terraform.tfstate.backup
        └── tform.vars
```

## Access to the bosh director
```
$ direnv allow
$ cd environments/k10s-virtualbox/bosh/
	> direnv: loading .envrc
	> direnv: export +BOSH_CA_CERT ...  +BOSH_ENVIRONMENT .. +CREDHUB_USER
$ bosh ss
	> Using environment '192.168.50.6' as client 'admin'
	> Name                                         Version   OS             CPI  CID
	> bosh-warden-boshlite-ubuntu-trusty-go_agent  3468.13*  ubuntu-trusty  -    f821b9ec-c7b3-44ce-63cf-85156a4f7d57
	> (*) Currently deployed
	> 1 stemcells
	> Succeeded
$ cd -
$ bosh ss
	> Expected non-empty Director URL
	> Exit code 1
```
