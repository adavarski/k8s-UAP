### Example AKS cluster using Terraform

This repository showcases using Terraform to provision a new AKS cluster with nodes within.

#### Prerequisites:
Azure subscription: If you don't have an Azure subscription, create a free account before you begin.

#### Tasks:

- Install and configure az, terraform and kubectl (ensure that az, terraform and kubectl are installed first).

```
$ ./build-environment.sh
```

- Authenticate to Azure

Initialise the Azure CLI if you haven't already:
```
az login
```
- Create an Azure service principal using the Azure CLI (Azure Active Directory service principals for automation authentication)

```
# Get subscriptionId
az account list --query "[].{name:name, subscriptionId:id}"
# Use above subscriptionId for Azure service principal creation, and save command output
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription_id>"
```

- Authenticate to Azure using a service principal (optional)
```
az login --service-principal -u <service_principal_name> -p "<service_principal_password>" --tenant "<service_principal_tenant>"
```
- Set the current Azure subscription - for use if you have multiple subscriptions (optional)
```
az account list --query "[].{name:name, subscriptionId:id}"
az account set --subscription="<subscription_id>"
az account show
```
Generate public/private ssh key pair (needed to ssh login @ k8s pool VMs)
```
$ ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/home/davar/.ssh/id_rsa): /home/davar/.ssh/azure-aks
...
```
Setup variables (fill out variables.tf with the variables you'd like)

Required variables are location, and name, the Azure location/region, name you'd like your cluster, and client_id, client_secret, subscription_id, tenant_id (Note: you get/save {client_id, client_secret, subscription_id, tenant_id} during service principal creation)

Note: Your free account has a four-core limit (4 vCore) that will be violated if we go with big AKS cluster, so if we want 2 nodes pool use: D1_v2, for 1 node pool: Standard_D2_v2 is OK.

Check available location and k8s versions for needed location (@variables.tf):
```
$ az account list-locations -o table
$ az aks get-versions --location eastus
```

- Provisioning
```
$ terraform init
$ terraform apply
```
Example output:
```
$ terraform apply

...
azurerm_resource_group.k8s: Creating...
azurerm_resource_group.k8s: Creation complete after 2s [id=/subscriptions/53a13c25-74e3-4753-8e1f-6d5d436e7109/resourceGroups/k8s-resources]
azurerm_kubernetes_cluster.k8s: Creating...
azurerm_kubernetes_cluster.k8s: Still creating... [10s elapsed]
...
azurerm_kubernetes_cluster.k8s: Still creating... [4m20s elapsed]
azurerm_kubernetes_cluster.k8s: Creation complete after 4m21s [id=/subscriptions/53a13c25-74e3-4753-8e1f-6d5d436e7109/resourcegroups/k8s-resources/providers/Microsoft.ContainerService/managedClusters/kubernetes-aks1]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:
...

```


- Configure kubectl
```
cp ~/.kube/config ~/.kube/config.BACKUP
az aks get-credentials --resource-group k8s-resources --name kubernetes-aks1
cat ~/.kube/config
```
- Test it works
```
# Check k8s cluster

$ kubectl version
Client Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.6", GitCommit:"fbf646b339dc52336b55d8ec85c181981b86331a", GitTreeState:"clean", BuildDate:"2020-12-18T12:09:30Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.6", GitCommit:"fbf646b339dc52336b55d8ec85c181981b86331a", GitTreeState:"clean", BuildDate:"2020-12-18T16:06:08Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}


$ kubectl cluster-info
Kubernetes master is running at https://kubecluster-478665c0.hcp.eastus.azmk8s.io:443
CoreDNS is running at https://kubecluster-478665c0.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://kubecluster-478665c0.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

$ kubectl get node -o wide
NAME                              STATUS   ROLES   AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
aks-default-19536001-vmss000000   Ready    agent   19m   v1.19.6   10.240.0.4    <none>        Ubuntu 18.04.5 LTS   5.4.0-1035-azure   containerd://1.4.3+azure

$ kubectl get all --all-namespaces
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   pod/coredns-autoscaler-5b6cbd75d7-dgkdn   1/1     Running   0          22m
kube-system   pod/coredns-b94d8b788-bn82s               1/1     Running   0          22m
kube-system   pod/coredns-b94d8b788-js6t5               1/1     Running   0          22m
kube-system   pod/kube-proxy-92gmq                      1/1     Running   0          22m
kube-system   pod/metrics-server-77c8679d7d-pz524       1/1     Running   0          22m
kube-system   pod/tunnelfront-f99dd9b64-szffj           1/1     Running   0          22m

NAMESPACE     NAME                     TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)         AGE
default       service/kubernetes       ClusterIP   10.0.0.1      <none>        443/TCP         23m
kube-system   service/kube-dns         ClusterIP   10.0.0.10     <none>        53/UDP,53/TCP   22m
kube-system   service/metrics-server   ClusterIP   10.0.56.229   <none>        443/TCP         22m

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                 AGE
kube-system   daemonset.apps/kube-proxy   1         1         1       1            1           beta.kubernetes.io/os=linux   22m

NAMESPACE     NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/coredns              2/2     2            2           22m
kube-system   deployment.apps/coredns-autoscaler   1/1     1            1           22m
kube-system   deployment.apps/metrics-server       1/1     1            1           22m
kube-system   deployment.apps/tunnelfront          1/1     1            1           22m

NAMESPACE     NAME                                            DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/coredns-autoscaler-5b6cbd75d7   1         1         1       22m
kube-system   replicaset.apps/coredns-b94d8b788               2         2         2       22m
kube-system   replicaset.apps/metrics-server-77c8679d7d       1         1         1       22m
kube-system   replicaset.apps/tunnelfront-f99dd9b64           1         1         1       22m

# LoadBalancer

$ kubectl run nginx --image=nginx --port=80
$ kubectl apply -f k8s-manifests/public-svc.yaml
$ kubectl get svc
NAME         TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)        AGE
kubernetes   ClusterIP      10.0.0.1      <none>         443/TCP        47m
public-svc   LoadBalancer   10.0.230.39   40.88.251.43   80:32159/TCP   6s

# Login to k8s pool VM

$ kubectl get node -o wide
NAME                              STATUS   ROLES   AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
aks-default-19536001-vmss000000   Ready    agent   19m   v1.19.6   10.240.0.4    <none>        Ubuntu 18.04.5 LTS   5.4.0-1035-azure   containerd://1.4.3+azure

$ kubectl run -it --rm aks-ssh --image=debian
$ kubectl cp ~/.ssh/azure-aks $(kubectl get pod -l run=aks-ssh -o jsonpath='{.items[0].metadata.name}'):/id_rsa
$ kubectl exec -it aks-ssh -- bash
root@aks-ssh:/# chmod 0600 /id_rsa 
root@aks-ssh:/# apt-get update && apt-get install openssh-client -y
root@aks-ssh:/# ssh -i /id_rsa ubuntu@10.240.0.4
The authenticity of host '10.240.0.4 (10.240.0.4)' can't be established.
ECDSA key fingerprint is SHA256:55fhUaux4iUyWKIbaju1PD+n4Ew0iddZBpX9W7jhHIc.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.240.0.4' (ECDSA) to the list of known hosts.

Authorized uses only. All activity may be monitored and reported.
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-1035-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 * Introducing self-healing high availability clusters in MicroK8s.
   Simple, hardened, Kubernetes for production, from RaspberryPi to DC.

     https://microk8s.io/high-availability

1 package can be updated.
0 of these updates are security updates.

To see these additional updates run: apt list --upgradable
The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@aks-default-19536001-vmss000000:~$ sudo su -
root@aks-default-19536001-vmss000000:~# crictl ps -a
CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID
732a3c2d19474       e7d08cddf791f       6 minutes ago       Running             aks-ssh             0                   b427dbe15927c
2310b36922c8a       7ddd7d32eeb3f       29 minutes ago      Running             tunnel-front        0                   1cc54951a4223
b0a8fc761712d       2a8d4a7ec8035       29 minutes ago      Running             coredns             0                   dedf8a11a8019
6b3850bb9487e       9dd718864ce61       29 minutes ago      Running             metrics-server      0                   f01ddce8a8149
1f68af4c40d03       2a8d4a7ec8035       29 minutes ago      Running             coredns             0                   76eb6667b5749
0fb5330af489e       dafdf6a290890       29 minutes ago      Running             autoscaler          0                   ace8d5092485d
b9a250ac022ce       f86c769f3c5c4       29 minutes ago      Running             kube-proxy          0                   81b9720743d38

```
- Tearing down

```
$ terraform destroy
# Delete Azure Active Directory service principals for automation authentication
$ az ad sp show --id 00000000-0000-0000-0000-000000000000
$ az ad sp delete --id 00000000-0000-0000-0000-000000000000
```

Example output:
```
$ terraform destroy

...
azurerm_kubernetes_cluster.k8s: Destroying... [id=/subscriptions/53a13c25-74e3-4753-8e1f-6d5d436e7109/resourcegroups/k8s-resources/providers/Microsoft.ContainerService/managedClusters/kubernetes-aks1]
azurerm_kubernetes_cluster.k8s: Still destroying... [id=/subscriptions/53a13c25-74e3-4753-8e1f-...ervice/managedClusters/kubernetes-aks1, 10s elapsed]
...
azurerm_kubernetes_cluster.k8s: Still destroying... [id=/subscriptions/53a13c25-74e3-4753-8e1f-...ervice/managedClusters/kubernetes-aks1, 5m0s elapsed]
azurerm_kubernetes_cluster.k8s: Destruction complete after 5m6s
azurerm_resource_group.k8s: Destroying... [id=/subscriptions/53a13c25-74e3-4753-8e1f-6d5d436e7109/resourceGroups/k8s-resources]
azurerm_resource_group.k8s: Still destroying... [id=/subscriptions/53a13c25-74e3-4753-8e1f-6d5d436e7109/resourceGroups/k8s-resources, 10s elapsed]
azurerm_resource_group.k8s: Still destroying... [id=/subscriptions/53a13c25-74e3-4753-8e1f-6d5d436e7109/resourceGroups/k8s-resources, 20s elapsed]
azurerm_resource_group.k8s: Still destroying... [id=/subscriptions/53a13c25-74e3-4753-8e1f-6d5d436e7109/resourceGroups/k8s-resources, 30s elapsed]
azurerm_resource_group.k8s: Still destroying... [id=/subscriptions/53a13c25-74e3-4753-8e1f-6d5d436e7109/resourceGroups/k8s-resources, 40s elapsed]
azurerm_resource_group.k8s: Destruction complete after 49s
```

What now?
AKS documentation for more information on AKS itself.
Terraform AKS documentation for more details on customising the cluster.

