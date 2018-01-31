## Prerequirement

Deployment release repositories to exist in `~/workspace`

```
$ ls -d  ~/workspace/{bosh,cf,kubo}-deployment ~/workspace/kubo-release/
  > /Users/User/workspace/bosh-deployment
  > /Users/User/workspace/kubo-deployment
  > /Users/User/workspace/kubo-release
$ echo $?
  > 0
```


## Tutorial

Simply execute the following commands

```bash
 ./bin/blup.sh 
 source ./environments/bosh-lite/bosh-envs
 ./scripts/deploy-kubo-lite.sh 
 ```

and make sure that your workstation has the following
```
# sudo route add -net 10.244.0.0/16 192.168.50.6
# sudo echo "10.244.0.128 kubernetes" >> /etc/hosts
```

### Access to the CFCR deployment

Export the kubeconfig

```
export KUBECONFIG=$PWD/environments/bosh-lite/deployments/cfcr/kuboconfig

$ kubectl get nodes
  > NAME           STATUS    ROLES     AGE       VERSION
  > 10.244.0.129   Ready     <none>    1h        v1.8.4
  > 10.244.0.130   Ready     <none>    1h        v1.8.4
  > 10.244.0.131   Ready     <none>    1h        v1.8.4
```

## Clean up

```
rm -rf $PWD/environments/bosh-lite
#clean up the VMs from the VirtualBox
```
