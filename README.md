## Prerequirement

Deployment release repositories to exist in `~/workspace`

```
$ ls -d  ~/workspace/{bosh,cf,kubo}-deployment ~/workspace/kubo-release/
  > /Users/User/workspace/bosh-deployment
  > /Users/User/workspace/cf-deployment
  > /Users/User/workspace/kubo-deployment
  > /Users/User/workspace/kubo-release
$ echo $?
> 0
```

# TUTORIAL

```
cat .envrc # Step 0 - Configure environment
  > export DIRECTOR=k10s
  > export ENV_TYPE=virtualbox
  > export ENV_DIR=$PWD/environments
  > export PATH=$PATH:bin

# Step 1 - Create Credentials in the CPI
pre-cpi

# Step 2 - Terraform the infrastructure
tform-me

# Step 3 - Deploy bosh director
bosh-me

# Step 4 - Deploy cf or cfcr
 ./scripts/deploy-kubo-lite.sh
```

## Specific requirements for deploying CFCR in Virtualbox

For Virtualbox (bosh-lite) step 1 and step 2 are more or less dummy steps.

```
#sudo route add -net 10.244.0.0/16 192.168.50.6

# cat /etc/hosts|grep master
# 10.244.0.128 master.kubo

```
In kubo deployment, we need a small change.

Note: it [deploys local cfcr](https://github.com/karampok/bosh-devground/blob/dc65f40ad0316d59f967fd725c29da375c0625d0/scripts/deploy-kubo-lite.sh#L16)

```
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
Either by `cd`-ing to the bosh directory
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

Or by simply sourcing the `.envrc` file of the folder 

```
source ${ENV_DIR}/k10s-virtualbox/bosh/.envrc
```

## Access to a deployment

In order to access to a CFCR deployment, either `cd` to the deployment folder

```
$ cd environments/k10s-virtualbox/deployments/kubo/
  > direnv: error .envrc is blocked. Run `direnv allow` to approve its content.
$ direnv allow
  > direnv: loading .envrc
  > direnv: export +KUBECONFIG
$ kubectl get nodes
  > NAME           STATUS    ROLES     AGE       VERSION
  > 10.244.0.129   Ready     <none>    1h        v1.8.4
  > 10.244.0.130   Ready     <none>    1h        v1.8.4
  > 10.244.0.131   Ready     <none>    1h        v1.8.4
```

Or source/export the kubeconfig 
```
export KUBECONFIG=${ENV_DIR}/k10s-virtualbox/deployments/kubo/kuboconfig
```


# Clean up 
Every bin has a clean up counterpart

```
source ${ENV_DIR}/k10s-virtualbox/bosh/.envrc
bosh -n delete-deployment -d cfcr

source ${ENV_DIR}/k10s-virtualbox/bosh/input.args
bosh-me delete-env

tform-me destroy #removes the resources created with terraform

pre-cpi remove #remove credentials needed only for the setup
```
