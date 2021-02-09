# Terraform + k8s on Oracle Cloud Infrastructure (OKE : Container Engine For Kubernetes) 

This repository contains ready-to-use Kubernetes Cluster on Oracle Container Engine for Kubernetes (OKE).

It uses the latest available Kubernetes version available in the Oracle Cloud Infrastructure region and creates a kubeconfig file at completion.

1.Install oci-cli and terraform
```
$ bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
$/Users/davar/bin/oci setup keys

...
If you haven't already uploaded your public key through the console,
follow the instructions on the page linked below in the section 'How toupload the public key':

    <https://docs.cloud.oracle.com/Content/API/Concepts/apisigningkey.htm#How2>

$ cat /Users/davar/.oci/config
[DEFAULT]
user=
fingerprint=
key_file=~/.oci/oci_api_key.pem
tenancy=
region=
$ /Users/davar/bin/oci setup repair-file-permissions --file /Users/davar/.oci/config
$ /Users/davar/bin/oci iam region list --output table
$ /Users/davar/bin/oci iam availability-domain list --output table --profile DEFAULT
$ /Users/davar/bin/oci compute image list -c ocid1.tenancy.oc1XXXXXXXXXX --output table --query "data [*].{ImageName:\"display-name\", OCID:id}"|grep CentOS
$ curl https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_darwin_amd64.zip --output terraform_0.12.18_darwin_amd64.zip
$ unzip terraform_0.12.18_darwin_amd64.zip
$ cp ./terraform /usr/local/bin
```
2.Create env-vars file
```
$ cat env-vars
export TF_VAR_tenancy_ocid=
export TF_VAR_user_ocid=
export TF_VAR_compartment_ocid=

export TF_VAR_fingerprint=$(cat ~/.oci/oci_api_key_fingerprint)
export TF_VAR_private_key_path=~/.oci/oci_api_key.pem

export TF_VAR_ssh_public_key=$(cat ~/.ssh/id_rsa.pub)
export TF_VAR_ssh_private_key=$(cat ~/.ssh/id_rsa)

export TF_VAR_region=
```
3.Create OCI (OKE) k8s infrastructure
```
$ source env-vars
$ terraform init
$ terraform plan
$ terraform apply
```
4.Accessing Kubernetes Cluster using kubectl and creating an Application on Kubernetes Cluster.

```
$ cat ~/.bash_profile|grep OCI
export OCI=/Users/davar/bin
export PATH=$OCI:$PATH

$ source ~/.bash_profile

$ brew install kubernetes-cli
$ brew link --overwrite kubernetes-cli
$ mv /Users/davar/.kube/config /Users/davar/.kube/config.minikube

$ mkdir -p $HOME/.kube

$ oci ce cluster create-kubeconfig --cluster-id ocid1.cluster.oc1.phx.aaaaaaaaae3dcodcheytsndfgm4dqyzvmqydinzxmu4teztbgcywgmldmq2t --file $HOME/.kube/config --region us-phoenix-1 --token-version 2.0.0

$ export KUBECONFIG=$HOME/.kube/config


$ kubectl get node
NAME       STATUS   ROLES   AGE   VERSION
10.0.2.2   Ready    node    66m   v1.14.8
10.0.3.2   Ready    node    66m   v1.14.8

$ kubectl cluster-info
Kubernetes master is running at https://cywgmldmq2t.us-phoenix-1.clusters.oci.oraclecloud.com:6443
CoreDNS is running at https://cywgmldmq2t.us-phoenix-1.clusters.oci.oraclecloud.com:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.


$ kubectl run nginx --image=nginx --port=80 --replicas=3
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/nginx created


$ kubectl get deployments
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   3/3     3            3           30s
$ kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
nginx-755464dd6c-9cmr8   1/1     Running   0          43s   10.244.0.5   10.0.2.2   <none>           <none>
nginx-755464dd6c-w52nr   1/1     Running   0          43s   10.244.1.3   10.0.3.2   <none>           <none>
nginx-755464dd6c-z466g   1/1     Running   0          43s   10.244.0.4   10.0.2.2   <none>           <none>

$ kubectl expose deployment nginx --port=80 --type=LoadBalancer
service/nginx exposed
```


5.Clean OCI infrastructure
```
$ terraform destroy
```
Details:

- [Terraform Kubernetes on Oracle Cloud](#Terraform-Kubernetes-on-Oracle-Cloud)
  - [Requirements](#Requirements)
  - [Features](#Features)
  - [Notes](#Notes)
  - [Defaults](#Defaults)
  - [Terraform Inputs](#Terraform-Inputs)
  - [Outputs](#Outputs)


## Requirements

You need an [Oracle Cloud](https://cloud.oracle.com/en_US/tryit) account.


## Features

* Always uses latest Kubernetes version available at Oracle Cloud
* **kubeconfig** file generation
* Creates separate node pool for worker nodes
* Allows SSH access from workstation IPv4 address only


## Notes

* `export KUBECONFIG=./kubeconfig_oci` in repo root dir to use the generated kubeconfig file
* The `enable_oracle` variable is used in the [hajowieland/terraform-kubernetes-multi-cloud](https://github.com/hajowieland/terraform-kubernetes-multi-cloud) module
* It can take a few minutes after Terraform finishes until the Kubernetes nodes are available!


## Defaults

See tables at the end for a comprehensive list of inputs and outputs.


* Default region: **eu-frankfurt-1** _(Frankfurt, Germany)_
* Default worker node type: **VM.Standard2.1** _(1x vCPU, 15.0GB memory)_
* Default worker node pool size: **2** (per subnet, by default we only use one subnet)



## Terraform Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enable_oracle | Enable / Disable Oracle Cloud k8s  | bool | true | yes |
| random_cluster_suffix | Random 6 byte hex suffix for cluster name | string |  | true |
| oci_region | Oracle Cloud region | string | eu-frankfurt-1 | true |
| oci_user_ocid | Oracle Cloud User OCID | string |   | yes |
| oci_tenancy_ocid | Oracle Cloud Tenancy OCID | string |  | yes |
| oci_private_key_path | Path to your OCI private key | string | ~/.oci/oci_api_key.pem | yes |
| oci_public_key_path | Path to your OCI public key | string | ~/.oci/oci_api_key_public.pem | yes |
| oci_fingerprint | OCI public key fingerprint | string |   | yes |
| lbs | Count of 8-bit numbers of LoadBalancer base_cidr_block | number | 10 | yes |
| oci_cidr_block | OCI VCN CIDR block | string | 10.0.0.0/16 | yes |
| oci_subnets | Count of 8-bit numbers of subnets base_cidr_block | number | 2 | yes |
| oci_policy_statements | OCI Policy Statements in policy language | list(string) | "Allow service OKE to manage all-resources in tenancy" | yes |
| oci_cluster_name | Oracle Cloud OKE Kubernetes cluster name | string | k8soci | yes |
| oci_node_pool_name | Oracle Cloud OKE Kubernetes node pool name | string | k8s-nodepool-oci | yes |
| oci_cluster_add_ons_kubernetes_dashboard | Enable the Kubernetes Dashboard | bool | false | yes |
| oci_cluster_add_ons_tiller | Enable Tiller for helm | bool | false | yes |
| oke_node_pool_size | OKE Kubernetes worker node pool quantity per subnet | number | 2 | yes |
| oci_node_pool_node_shape | OCI Kubernetse node pool Shape | string | VM.Standard2.1 | yes |
| oci_subnet_prohibit_public_ip_on_vnic | OCI VCN subnet prohibits assigning public IPs or not | bool | true | yes |
| oci_node_pool_ssh_public_key | SSH public key to add to each node in the node pool | string | ~/.ssh/id_rsa.pub | yes |
| oci_node_pool_node_image_name | OCI Kubernetes node pool image name | string | Oracle-Linux-7.6 | yes | 



## Outputs

| Name | Description |
|------|-------------|
| kubernetes_version | Latest available Kubernetes version on Oracle Cloud |
| kubeconfig_path_oci | generated kubeconfig file name |
