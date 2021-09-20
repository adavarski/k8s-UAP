# Example EKS cluster using Terraform

This repository showcases using Terraform to provision a new VPC and Elastic Kubernetes Service (EKS) cluster with nodes within.

By default, this will create a highly available cluster using public and private subnets, a best practise for production environments.

## Install awscli

Install/configure awscli:
```
apt install -y python3-pip
pip3 install awscli
aws configure (or export AWS_ACCESS_KEY_ID= ; export AWS_SECRET_ACCESS_KEY=; export AWS_DEFAULT_REGION=ap-southeast-2)
```

Exmaple:
```
$ cat ~/.aws/config
[default]
region = ap-southeast-2

$ cat ~/.aws/credentials 
[default]
aws_access_key_id = XXXXX
aws_secret_access_key = XXXXX

```

## Setup variables

In `main.tf` set your AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY
```
  access_key = ""
  secret_key = ""
```
In `terraform.tfvars` set the variables you'd like.

`name` and `region` must be defined, everything else is optional.

(Optional): ssh access to worker nodes 
```
$ aws ec2 --profile default create-key-pair --key-name demo-aks --query 'KeyMaterial' --output text > demo-aks.pem
$ git diff
diff --git a/EKS/main.tf b/EKS/main.tf
index 0b1d9c1..dfcc90e 100755
--- a/EKS/main.tf
+++ b/EKS/main.tf
@@ -129,6 +129,9 @@ resource "aws_eks_node_group" "nodegroup" {
     min_size     = lookup(var.node_pools[count.index], "min_size", 1)
     max_size     = lookup(var.node_pools[count.index], "max_size", 2)
   }
+  remote_access {
+    ec2_ssh_key = var.worker-node-ssh-key
+  }
   disk_size      = lookup(var.node_pools[count.index], "disk_size", 20)
   instance_types = [lookup(var.node_pools[count.index], "instance_type", "t3.small")]
   # Allow external changes to autoscaling desired size without interference from Terraform
diff --git a/EKS/terraform.tfvars b/EKS/terraform.tfvars
index e101270..4880e69 100644
--- a/EKS/terraform.tfvars
+++ b/EKS/terraform.tfvars
@@ -10,3 +10,4 @@ node_pools = [
     max_size      = 2
   }
 ]
+worker-node-ssh-key = "demo-aks"
diff --git a/EKS/variables.tf b/EKS/variables.tf
index 1ec82eb..2d24385 100755
--- a/EKS/variables.tf
+++ b/EKS/variables.tf
@@ -61,3 +61,7 @@ List of node pools to use for the cluster.
 See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
 EOF
 }
+
+variable "worker-node-ssh-key" {
+  description = "EC2 Keyname to connect to node group"
+}
```

## Provisioning

```shell
terraform init
terraform plan
terraform apply
```

Example:
```
$ terraform apply
...
  Enter a value: yes

aws_eip.nat[0]: Creating...
aws_vpc.vpc: Creating...
aws_iam_role.node: Creating...
aws_eip.nat[1]: Creating...
aws_iam_role.cluster: Creating...
aws_iam_role.cluster: Creation complete after 2s [id=mycluster-cluster]
aws_iam_role.node: Creation complete after 2s [id=mycluster-node]
aws_iam_role_policy_attachment.AmazonEKSServicePolicy: Creating...
aws_iam_role_policy_attachment.AmazonEKSClusterPolicy: Creating...
aws_iam_role_policy_attachment.AmazonSSMManagedInstanceCore: Creating...
aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly: Creating...
aws_iam_role_policy.EKSClusterAutoscaler: Creating...
aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy: Creating...
aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy: Creating...
aws_eip.nat[1]: Creation complete after 3s [id=eipalloc-01f1150f85c3c4410]
aws_eip.nat[0]: Creation complete after 3s [id=eipalloc-0ad5493a3cc2cea37]
aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly: Creation complete after 1s [id=mycluster-node-20210802150034509000000004]
aws_iam_role_policy_attachment.AmazonEKSServicePolicy: Creation complete after 1s [id=mycluster-cluster-20210802150034505800000002]
aws_iam_role_policy_attachment.AmazonSSMManagedInstanceCore: Creation complete after 1s [id=mycluster-node-20210802150034543300000006]
aws_iam_role_policy_attachment.AmazonEKSClusterPolicy: Creation complete after 1s [id=mycluster-cluster-20210802150034502200000001]
aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy: Creation complete after 1s [id=mycluster-node-20210802150034507800000003]
aws_iam_role_policy.EKSClusterAutoscaler: Creation complete after 1s [id=mycluster-node:EKSClusterAutoscaler]
aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy: Creation complete after 1s [id=mycluster-node-20210802150034541500000005]
aws_vpc.vpc: Still creating... [10s elapsed]
aws_vpc.vpc: Still creating... [20s elapsed]
aws_vpc.vpc: Still creating... [30s elapsed]
aws_vpc.vpc: Creation complete after 32s [id=vpc-04c9ab8f8bb7c22e3]
aws_subnet.public[1]: Creating...
aws_internet_gateway.igw: Creating...
aws_subnet.private[1]: Creating...
aws_subnet.public[0]: Creating...
aws_subnet.private[0]: Creating...
aws_subnet.private[0]: Creation complete after 7s [id=subnet-069e9af7fd8014abe]
aws_subnet.private[1]: Creation complete after 7s [id=subnet-0126fb9d4cc8ad28b]
aws_internet_gateway.igw: Still creating... [10s elapsed]
aws_subnet.public[1]: Still creating... [10s elapsed]
aws_subnet.public[0]: Still creating... [10s elapsed]
aws_internet_gateway.igw: Creation complete after 11s [id=igw-0e7ac330db4105c75]
aws_route_table.public: Creating...
aws_subnet.public[1]: Still creating... [20s elapsed]
aws_subnet.public[0]: Still creating... [20s elapsed]
aws_route_table.public: Still creating... [10s elapsed]
aws_subnet.public[1]: Creation complete after 21s [id=subnet-07b4f82f5cdc33751]
aws_subnet.public[0]: Creation complete after 21s [id=subnet-01ee0eae18f927cc3]
aws_nat_gateway.nat[0]: Creating...
aws_nat_gateway.nat[1]: Creating...
aws_eks_cluster.cluster: Creating...
aws_route_table.public: Creation complete after 12s [id=rtb-04827e4f49d16a564]
aws_route_table_association.public[0]: Creating...
aws_route_table_association.public[1]: Creating...
aws_route_table_association.public[1]: Creation complete after 5s [id=rtbassoc-0ba32e3e2d8bb18b9]
aws_route_table_association.public[0]: Creation complete after 5s [id=rtbassoc-046f9b5891288e4f4]
aws_nat_gateway.nat[0]: Still creating... [10s elapsed]
aws_nat_gateway.nat[1]: Still creating... [10s elapsed]
aws_eks_cluster.cluster: Still creating... [10s elapsed]
aws_nat_gateway.nat[0]: Still creating... [20s elapsed]
aws_nat_gateway.nat[1]: Still creating... [20s elapsed]
aws_eks_cluster.cluster: Still creating... [20s elapsed]
aws_nat_gateway.nat[0]: Still creating... [30s elapsed]
aws_nat_gateway.nat[1]: Still creating... [30s elapsed]
aws_eks_cluster.cluster: Still creating... [30s elapsed]
aws_nat_gateway.nat[0]: Still creating... [40s elapsed]
aws_nat_gateway.nat[1]: Still creating... [40s elapsed]
aws_eks_cluster.cluster: Still creating... [40s elapsed]
aws_nat_gateway.nat[0]: Still creating... [50s elapsed]
aws_nat_gateway.nat[1]: Still creating... [50s elapsed]
aws_eks_cluster.cluster: Still creating... [50s elapsed]
aws_nat_gateway.nat[0]: Still creating... [1m0s elapsed]
aws_nat_gateway.nat[1]: Still creating... [1m0s elapsed]
aws_eks_cluster.cluster: Still creating... [1m0s elapsed]
aws_nat_gateway.nat[0]: Still creating... [1m10s elapsed]
aws_nat_gateway.nat[1]: Still creating... [1m10s elapsed]
aws_eks_cluster.cluster: Still creating... [1m10s elapsed]
aws_nat_gateway.nat[0]: Still creating... [1m20s elapsed]
aws_nat_gateway.nat[1]: Still creating... [1m20s elapsed]
aws_eks_cluster.cluster: Still creating... [1m20s elapsed]
aws_nat_gateway.nat[0]: Still creating... [1m30s elapsed]
aws_nat_gateway.nat[1]: Still creating... [1m30s elapsed]
aws_eks_cluster.cluster: Still creating... [1m30s elapsed]
aws_nat_gateway.nat[0]: Still creating... [1m40s elapsed]
aws_nat_gateway.nat[1]: Still creating... [1m40s elapsed]
aws_eks_cluster.cluster: Still creating... [1m40s elapsed]
aws_nat_gateway.nat[1]: Creation complete after 1m50s [id=nat-0b4f7bc12cbeee77b]
aws_nat_gateway.nat[0]: Still creating... [1m50s elapsed]
aws_eks_cluster.cluster: Still creating... [1m50s elapsed]
aws_nat_gateway.nat[0]: Still creating... [2m0s elapsed]
aws_eks_cluster.cluster: Still creating... [2m0s elapsed]
aws_nat_gateway.nat[0]: Creation complete after 2m1s [id=nat-04d768e678a115e74]
aws_route_table.private[1]: Creating...
aws_route_table.private[0]: Creating...
aws_eks_cluster.cluster: Still creating... [2m10s elapsed]
aws_route_table.private[0]: Still creating... [10s elapsed]
aws_route_table.private[1]: Still creating... [10s elapsed]
aws_route_table.private[1]: Creation complete after 12s [id=rtb-02e83a764101b153f]
aws_route_table.private[0]: Creation complete after 14s [id=rtb-0c9b1a29a54cd57b8]
aws_route_table_association.private[1]: Creating...
aws_route_table_association.private[0]: Creating...
aws_route_table_association.private[1]: Creation complete after 5s [id=rtbassoc-05ec5c6203b948a44]
aws_route_table_association.private[0]: Creation complete after 5s [id=rtbassoc-0dd62b87e90670453]
aws_eks_cluster.cluster: Still creating... [2m20s elapsed]
aws_eks_cluster.cluster: Still creating... [2m30s elapsed]
aws_eks_cluster.cluster: Still creating... [2m40s elapsed]
aws_eks_cluster.cluster: Still creating... [2m50s elapsed]
aws_eks_cluster.cluster: Still creating... [3m0s elapsed]
aws_eks_cluster.cluster: Still creating... [3m10s elapsed]
aws_eks_cluster.cluster: Still creating... [3m20s elapsed]
aws_eks_cluster.cluster: Still creating... [3m30s elapsed]
aws_eks_cluster.cluster: Still creating... [3m40s elapsed]
aws_eks_cluster.cluster: Still creating... [3m50s elapsed]
aws_eks_cluster.cluster: Still creating... [4m0s elapsed]
aws_eks_cluster.cluster: Still creating... [4m10s elapsed]
aws_eks_cluster.cluster: Still creating... [4m20s elapsed]
aws_eks_cluster.cluster: Still creating... [4m30s elapsed]
aws_eks_cluster.cluster: Still creating... [4m40s elapsed]
aws_eks_cluster.cluster: Still creating... [4m50s elapsed]
aws_eks_cluster.cluster: Still creating... [5m0s elapsed]
aws_eks_cluster.cluster: Still creating... [5m10s elapsed]
aws_eks_cluster.cluster: Still creating... [5m20s elapsed]
aws_eks_cluster.cluster: Still creating... [5m30s elapsed]
aws_eks_cluster.cluster: Still creating... [5m40s elapsed]
aws_eks_cluster.cluster: Still creating... [5m50s elapsed]
aws_eks_cluster.cluster: Still creating... [6m0s elapsed]
aws_eks_cluster.cluster: Still creating... [6m10s elapsed]
aws_eks_cluster.cluster: Still creating... [6m20s elapsed]
aws_eks_cluster.cluster: Still creating... [6m30s elapsed]
aws_eks_cluster.cluster: Still creating... [6m40s elapsed]
aws_eks_cluster.cluster: Still creating... [6m50s elapsed]
aws_eks_cluster.cluster: Still creating... [7m0s elapsed]
aws_eks_cluster.cluster: Still creating... [7m10s elapsed]
aws_eks_cluster.cluster: Still creating... [7m20s elapsed]
aws_eks_cluster.cluster: Still creating... [7m30s elapsed]
aws_eks_cluster.cluster: Still creating... [7m40s elapsed]
aws_eks_cluster.cluster: Still creating... [7m50s elapsed]
aws_eks_cluster.cluster: Still creating... [8m0s elapsed]
aws_eks_cluster.cluster: Still creating... [8m10s elapsed]
aws_eks_cluster.cluster: Still creating... [8m20s elapsed]
aws_eks_cluster.cluster: Still creating... [8m30s elapsed]
aws_eks_cluster.cluster: Still creating... [8m40s elapsed]
aws_eks_cluster.cluster: Still creating... [8m50s elapsed]
aws_eks_cluster.cluster: Still creating... [9m0s elapsed]
aws_eks_cluster.cluster: Still creating... [9m10s elapsed]
aws_eks_cluster.cluster: Still creating... [9m20s elapsed]
aws_eks_cluster.cluster: Still creating... [9m30s elapsed]
aws_eks_cluster.cluster: Still creating... [9m40s elapsed]
aws_eks_cluster.cluster: Still creating... [9m50s elapsed]
aws_eks_cluster.cluster: Still creating... [10m0s elapsed]
aws_eks_cluster.cluster: Still creating... [10m10s elapsed]
aws_eks_cluster.cluster: Still creating... [10m20s elapsed]
aws_eks_cluster.cluster: Still creating... [10m30s elapsed]
aws_eks_cluster.cluster: Still creating... [10m40s elapsed]
aws_eks_cluster.cluster: Still creating... [10m50s elapsed]
aws_eks_cluster.cluster: Creation complete after 10m52s [id=mycluster]
aws_eks_node_group.nodegroup[0]: Creating...
aws_eks_node_group.nodegroup[0]: Still creating... [10s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [20s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [30s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [40s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [50s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [1m0s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [1m10s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [1m20s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [1m30s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [1m40s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [1m50s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [2m0s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [2m10s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [2m20s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [2m30s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [2m40s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [2m50s elapsed]
aws_eks_node_group.nodegroup[0]: Still creating... [3m0s elapsed]
aws_eks_node_group.nodegroup[0]: Creation complete after 3m8s [id=mycluster:001-group]

Apply complete! Resources: 28 added, 0 changed, 0 destroyed.

Outputs:

endpoint = "https://2ACF0ACF62CACB72DBAEB14220D8E3C9.gr7.ap-southeast-2.eks.amazonaws.com"
```
Note: Free Tier error (resource limits)

```
Error: error waiting for EKS Node Group (mycluster:001-group) to create: unexpected state 'CREATE_FAILED', wanted target 'ACTIVE'. last error: 2 errors occurred:
	* eks-b2bd9abe-937a-853f-84dc-1532d07149f1: AsgInstanceLaunchFailures: You've reached your quota for maximum Fleet Requests for this account. Launching EC2 instance failed.
	* DUMMY_553e8105-1d53-431e-a988-d913c5df2416, DUMMY_654d701c-4e09-4f17-a7b4-436723e094d8, DUMMY_6aad6331-8956-499c-b271-eadaec5ff1c7, DUMMY_7c3e02a3-3153-45ae-aebb-39a1a2633603, DUMMY_91dd16eb-d017-4e71-80dc-943085cf696e, DUMMY_f3a2343a-4774-4356-bc97-e8ccb3313c9c: NodeCreationFailure: Instances failed to join the kubernetes cluster
```


## Configure kubectl

Ref: See [this guide on setting up authentication](https://docs.aws.amazon.com/eks/latest/userguide/managing-auth.html).

Pre: Install aws-iam-authenticator
```
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
sudo cp ./aws-iam-authenticator /usr/local/bin
aws-iam-authenticator help
```

Example:
```
$ aws sts get-caller-identity
{
    "UserId": "218645542363",
    "Account": "218645542363",
    "Arn": "arn:aws:iam::218645542363:root"
}

$ export KUBECONFIG=./config.conf
$ aws eks --region ap-southeast-2 update-kubeconfig --name mycluster
$ cat config 
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1EZ3dNakUxTURnd01Wb1hEVE14TURjek1URTFNRGd3TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTW0zCnMvUmJOd3J3dXU0L0tCOXJWRnBKRlVkV3RpOTFjZUxjQm5VQkRFajZhSk9IZFloTm1RanNWeFllYjFWTTFxUGsKNGZPZi9kWEhGeVFQc0hTems0NFdhSVc1bTlwNG1BbDlYVXFVL2FreVpCY0E5WW5jQy9jVDhYRDJ1TEQ2cERFaQozWTd5ZkxoL3JqTG1wbUlEK3NYU3FyZDFCekE5TTZHVlVGc01yNkZ1WXN3Mm1iVFlKTHpsV1dSbDhSNCs4cVdjCkRuaTZSUEFMNXRXKzRxdmhhWFVQWDFQeno5ZVlxRFU5NTZMODNvWHFpdE5UMVNuYkNWekNyYWlUMHJsQmoyeGkKdmZkd3o5aVZFbTVNV0FGd1gzUkR6djhLYzFNMnF2WTMvaXFMV0RmTVlPaU9lK3BPZGNRVWd5YnNEOEZCYzhqSwpmU0crckFxZjRXV3JsTDMwV1E4Q0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZJOHhnQTJwUkg3RlRyVkJNeHJ0ZDZtSDk1djJNQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFDYjFtN1dzeHFrdko5bmREUVJJT2tUMWZzZ2NiOGVIcEtsbFYyNUJ4N1g1Z0NMR3N3UgpxbC9FTjhUbDJ1NXZXdVpiSkh2M0xSVmtiemRqSTFvdHJJZFY5UW5FdVlSN0ZSOEJhSFF5M3VwU2pTVUFOODdBCmMzOTRadXZRQ3pkWXZiVUpWMG5wT3VrdVlXTnNSaHRFVEFaVjhoZU5HbjYxNjFqNlQ2TlRXWktIVVhOYkVPUk8KOVM4UmY1Q1JkRFV4bFFTODFnZlBzd3VMUS9WSnBzM0oxcVpUTjlleWF5eXNHSzFxQmF0aTBlWUk0SmFWS2xFRgo5MXgvUERiWE5XcVFKcWhmK0lrNjdTWk8rdzhqam5Vb0FGeGhNSmhqWCtDOXBFaU0yZ3ZuVzBpeWd1TVJYKzF6CktPWWRZSlY1RlYwWmFadE4xSkVvd2ptNW1IM3pqN3N1M1N0ZgotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://2ACF0ACF62CACB72DBAEB14220D8E3C9.gr7.ap-southeast-2.eks.amazonaws.com
  name: arn:aws:eks:ap-southeast-2:218645542363:cluster/mycluster
contexts:
- context:
    cluster: arn:aws:eks:ap-southeast-2:218645542363:cluster/mycluster
    user: arn:aws:eks:ap-southeast-2:218645542363:cluster/mycluster
  name: arn:aws:eks:ap-southeast-2:218645542363:cluster/mycluster
current-context: arn:aws:eks:ap-southeast-2:218645542363:cluster/mycluster
kind: Config
preferences: {}
users:
- name: arn:aws:eks:ap-southeast-2:218645542363:cluster/mycluster
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - --region
      - ap-southeast-2
      - eks
      - get-token
      - --cluster-name
      - mycluster
      command: aws

```

## Test it works

```shell
kubectl cluster-info
kubectl get nodes -o wide
kubectl get all --all-namespaces
```
Example:

```
$ kubectl cluster-info
Kubernetes master is running at https://2ACF0ACF62CACB72DBAEB14220D8E3C9.gr7.ap-southeast-2.eks.amazonaws.com
CoreDNS is running at https://2ACF0ACF62CACB72DBAEB14220D8E3C9.gr7.ap-southeast-2.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

$ kubectl get node -o wide
NAME                                             STATUS   ROLES    AGE   VERSION              INTERNAL-IP   EXTERNAL-IP   OS-IMAGE         KERNEL-VERSION                CONTAINER-RUNTIME
ip-10-0-32-204.ap-southeast-2.compute.internal   Ready    <none>   57m   v1.20.4-eks-6b7464   10.0.32.204   <none>        Amazon Linux 2   5.4.129-63.229.amzn2.x86_64   docker://19.3.13

$ kubectl get all --all-namespaces
NAMESPACE     NAME                           READY   STATUS    RESTARTS   AGE
kube-system   pod/aws-node-wgbkz             1/1     Running   0          55m
kube-system   pod/coredns-6bfbc5f9f8-595h8   1/1     Running   0          59m
kube-system   pod/coredns-6bfbc5f9f8-fj2dw   1/1     Running   0          59m
kube-system   pod/kube-proxy-mrkxl           1/1     Running   0          55m

NAMESPACE     NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)         AGE
default       service/kubernetes   ClusterIP   172.20.0.1    <none>        443/TCP         59m
kube-system   service/kube-dns     ClusterIP   172.20.0.10   <none>        53/UDP,53/TCP   59m

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
kube-system   daemonset.apps/aws-node     1         1         1       1            1           <none>          59m
kube-system   daemonset.apps/kube-proxy   1         1         1       1            1           <none>          59m

NAMESPACE     NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/coredns   2/2     2            2           59m

NAMESPACE     NAME                                 DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/coredns-6bfbc5f9f8   2         2         2       59m
```
## Set up NGINX with sample traffic on Amazon EKS and Kubernetes

Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights-Prometheus-Sample-Workloads-nginx.html

```
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
"ingress-nginx" has been added to your repositories
$ kubectl create namespace nginx-ingress-sample
namespace/nginx-ingress-sample created
$ helm install my-nginx ingress-nginx/ingress-nginx \
> --namespace nginx-ingress-sample \
> --set controller.metrics.enabled=true \
> --set-string controller.metrics.service.annotations."prometheus\.io/port"="10254" \
> --set-string controller.metrics.service.annotations."prometheus\.io/scrape"="true"

NAME: my-nginx
LAST DEPLOYED: Mon Aug  2 19:40:23 2021
NAMESPACE: nginx-ingress-sample
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The ingress-nginx controller has been installed.
It may take a few minutes for the LoadBalancer IP to be available.
You can watch the status by running 'kubectl --namespace nginx-ingress-sample get services -o wide -w my-nginx-ingress-nginx-controller'

An example Ingress that makes use of the controller:

  apiVersion: networking.k8s.io/v1beta1
  kind: Ingress
  metadata:
    annotations:
      kubernetes.io/ingress.class: nginx
    name: example
    namespace: foo
  spec:
    rules:
      - host: www.example.com
        http:
          paths:
            - backend:
                serviceName: exampleService
                servicePort: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
        - hosts:
            - www.example.com
          secretName: example-tls

If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls
$ kubectl get service -n nginx-ingress-sample
NAME                                          TYPE           CLUSTER-IP       EXTERNAL-IP                                                                    PORT(S)                      AGE
my-nginx-ingress-nginx-controller             LoadBalancer   172.20.63.173    a4448c89057b1427692283001c049ace-1867031002.ap-southeast-2.elb.amazonaws.com   80:31358/TCP,443:30772/TCP   77s
my-nginx-ingress-nginx-controller-admission   ClusterIP      172.20.102.134   <none>                                                                         443/TCP                      77s
my-nginx-ingress-nginx-controller-metrics     ClusterIP      172.20.63.175    <none>                                                                         10254/TCP                    77s

$ EXTERNAL_IP=a4448c89057b1427692283001c049ace-1867031002.ap-southeast-2.elb.amazonaws.com
$ SAMPLE_TRAFFIC_NAMESPACE=nginx-sample-traffic
$ curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-deployment-manifest-templates/deployment-mode/service/cwagent-prometheus/sample_traffic/nginx-traffic/nginx-traffic-sample.yaml | 
> sed "s/{{external_ip}}/$EXTERNAL_IP/g" | 
> sed "s/{{namespace}}/$SAMPLE_TRAFFIC_NAMESPACE/g" | 
> kubectl apply -f -
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2088  100  2088    0     0   6713      0 --:--:-- --:--:-- --:--:--  6692
namespace/nginx-sample-traffic created
pod/banana-app created
service/banana-service created
pod/apple-app created
service/apple-service created
Warning: extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
ingress.extensions/ingress-nginx-demo created
pod/traffic-generator created

$ kubectl get pod -n $SAMPLE_TRAFFIC_NAMESPACE
NAME                READY   STATUS    RESTARTS   AGE
apple-app           1/1     Running   0          29s
banana-app          1/1     Running   0          32s
traffic-generator   1/1     Running   0          26s


$ kubectl get ing --all-namespaces
NAMESPACE              NAME                 CLASS    HOSTS                                                                          ADDRESS                                                                        PORTS   AGE
nginx-sample-traffic   ingress-nginx-demo   <none>   a4448c89057b1427692283001c049ace-1867031002.ap-southeast-2.elb.amazonaws.com   a4448c89057b1427692283001c049ace-1867031002.ap-southeast-2.elb.amazonaws.com   80      2m34s

$ kubectl get ing -n $SAMPLE_TRAFFIC_NAMESPACE
NAME                 CLASS    HOSTS                                                                          ADDRESS                                                                        PORTS   AGE
ingress-nginx-demo   <none>   a4448c89057b1427692283001c049ace-1867031002.ap-southeast-2.elb.amazonaws.com   a4448c89057b1427692283001c049ace-1867031002.ap-southeast-2.elb.amazonaws.com   80      88s

### Clean 
$ kubectl delete namespace $SAMPLE_TRAFFIC_NAMESPACE
namespace "nginx-sample-traffic" deleted
$ helm list --all-namespaces
NAME    	NAMESPACE           	REVISION	UPDATED                                 	STATUS  	CHART               	APP VERSION
my-nginx	nginx-ingress-sample	1       	2021-08-02 19:40:23.481396231 +0300 EEST	deployed	ingress-nginx-3.34.0	0.47.0     
$ helm uninstall my-nginx --namespace nginx-ingress-sample
release "my-nginx" uninstalled
$ kubectl delete namespace nginx-ingress-sample 
namespace "nginx-ingress-sample" deleted

---------
```
## Monitoring & Logs Aggregation
```
1.Monitoring k8s 
1.1.Prometheus+Graphana operator:

git clone https://github.com/prometheus-operator/kube-prometheus
cd kube-prometheus
# Create the namespace and CRDs, and then wait for them to be availble before creating the remaining resources
kubectl create -f manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl create -f manifests/
$ kubectl --namespace monitoring port-forward svc/prometheus-k8s 9090
$ kubectl --namespace monitoring port-forward svc/alertmanager-main 9093
$ kubectl --namespace monitoring port-forward svc/grafana 3000

Open http://localhost:3000 on a local workstation, and log in to Grafana with the default administrator credentials, username: admin, password: admin. Explore the prebuilt dashboards for monitoring many aspects of the Kubernetes cluster, including Nodes, Namespaces, and Pods.


To teardown the monitoring stack: kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup


1.2.Prometheus+Grafana via Helm Charts (Working:tested)

Deploy the Metrics Server with the following command:

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# add prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# add grafana Helm repo
helm repo add grafana https://grafana.github.io/helm-charts
kubectl create namespace prometheus

helm install prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2" \
    --set server.persistentVolume.storageClass="gp2"

kubectl port-forward -n prometheus deploy/prometheus-server 8080:9090

sum(rate(container_cpu_usage_seconds_total{container_name!="POD",namespace!=""}[5m])) by (namespace)
sum(kube_pod_container_resource_requests_cpu_cores) by (namespace)
sum(kube_pod_container_resource_limits_cpu_cores) by (namespace)

mkdir ${HOME}/environment/grafana

cat << EoF > ./grafana.yaml
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus-server.prometheus.svc.cluster.local
      access: proxy
      isDefault: true
EoF
kubectl create namespace grafana

helm install grafana grafana/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true \
    --set adminPassword='Kr0k0dil' \
    --values ${HOME}/environment/grafana/grafana.yaml \
    --set service.type=ClusterIP

     export POD_NAME=$(kubectl get pods --namespace grafana -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
     kubectl --namespace grafana port-forward $POD_NAME 3000

https://grafana.com/grafana/dashboards/3119 Downloads: 28838
https://grafana.com/grafana/dashboards/6417 Downloads: 195449

$ kubectl get all -n prometheus
NAME                                                 READY   STATUS    RESTARTS   AGE
pod/prometheus-alertmanager-7ff9ffd975-kvcvd         2/2     Running   0          60s
pod/prometheus-kube-state-metrics-696cf79768-v64xj   1/1     Running   0          60s
pod/prometheus-node-exporter-hp49q                   1/1     Running   0          60s
pod/prometheus-node-exporter-x6ngw                   1/1     Running   0          60s
pod/prometheus-pushgateway-b5d568dcc-5fzsf           1/1     Running   0          60s
pod/prometheus-server-766649cb7-6ghs4                2/2     Running   0          60s

NAME                                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/prometheus-alertmanager         ClusterIP   172.20.103.147   <none>        80/TCP     61s
service/prometheus-kube-state-metrics   ClusterIP   172.20.153.16    <none>        8080/TCP   61s
service/prometheus-node-exporter        ClusterIP   None             <none>        9100/TCP   61s
service/prometheus-pushgateway          ClusterIP   172.20.147.100   <none>        9091/TCP   61s
service/prometheus-server               ClusterIP   172.20.101.43    <none>        80/TCP     61s

NAME                                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/prometheus-node-exporter   2         2         2       2            2           <none>          61s

NAME                                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prometheus-alertmanager         1/1     1            1           61s
deployment.apps/prometheus-kube-state-metrics   1/1     1            1           61s
deployment.apps/prometheus-pushgateway          1/1     1            1           61s
deployment.apps/prometheus-server               1/1     1            1           61s

NAME                                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/prometheus-alertmanager-7ff9ffd975         1         1         1       61s
replicaset.apps/prometheus-kube-state-metrics-696cf79768   1         1         1       61s
replicaset.apps/prometheus-pushgateway-b5d568dcc           1         1         1       61s
replicaset.apps/prometheus-server-766649cb7                1         1         1       61s


$ kubectl get all -n grafana
NAME                          READY   STATUS    RESTARTS   AGE
pod/grafana-d5bb59bdf-zlzrs   1/1     Running   0          16m

NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/grafana   ClusterIP   172.20.61.45   <none>        80/TCP    17m

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/grafana   1/1     1            1           16m

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/grafana-d5bb59bdf   1         1         1       16m

1.3.Datadog 
1.4.newrelic
1.5.dynatrace

2.Logs Aggregation (EFK)

///helm delete aws-for-fluent-bit -n logging

kubectl create namespace logging
helm repo add elastic https://helm.elastic.co
helm install elasticsearch elastic/elasticsearch --namespace logging
helm install kibana elastic/kibana --namespace logging

configure fluentbit
$ kubectl edit configmap aws-for-fluent-bit -n logging
configmap/aws-for-fluent-bit edited


    [OUTPUT]
        Name            es
        Match           *
        Host            elasticsearch-master
        Port            9200
        Logstash_Format On
        Replace_Dots    On
        Retry_Limit     False


Note: redeploy fluentbit pods for new configmap to take place (example: kubectl delete pod/aws-for-fluent-bit-zp8p8 -n logging)

Access ElasticSearch and Kibana UI

$ kubectl -n logging port-forward svc/elasticsearch-master 9200
$ curl localhost:9200/_cat/indices
green open .kibana-event-log-7.14.0-000001 qRYe_YnJQpuvFryoEuEWOg 1 1    1    0  11.2kb   5.6kb
green open .geoip_databases                JSwCTt6-RjKchvK310UJzg 1 1   42    0    82mb    41mb
green open .kibana_7.14.0_001              kjiAZ9wYTX-t-TJ6zgEUOQ 1 1   30   11   4.3mb   2.1mb
green open .apm-custom-link                uG3YYtQsRTyaNQBDvKNRLQ 1 1    0    0    416b    208b
green open .apm-agent-configuration        0HNlSAEQTfiYtGoyL5EI3Q 1 1    0    0    416b    208b
green open logstash-2021.09.11             9priaCimTiuCzsZ6SKNzdg 1 1  209    0 238.7kb 117.5kb
green open logstash-2021.09.12             Wl6FERhiRKGZHNC0yIBlVw 1 1 1518    0   678kb 351.6kb
green open .kibana_task_manager_7.14.0_001 W3BgW75kRlikrVoLEwD9BQ 1 1   14 3831     1mb 521.2kb
green open logstash-2021.09.13             8LYGMNWKQfKuDtJ9bmthmA 1 1 8452    0   6.3mb   3.1mb

$ kubectl -n logging port-forward deployment/kibana-kibana 5601
Browser: http://localhost:5601

$ kubectl get all -n logging
NAME                                READY   STATUS    RESTARTS   AGE
pod/elasticsearch-master-0          1/1     Running   0          6m13s
pod/elasticsearch-master-1          1/1     Running   0          6m13s
pod/elasticsearch-master-2          0/1     Pending   0          6m13s
pod/kibana-kibana-b4dfc69c7-dbd8g   1/1     Running   0          5m59s

NAME                                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
service/elasticsearch-master            ClusterIP   172.20.22.177   <none>        9200/TCP,9300/TCP   6m13s
service/elasticsearch-master-headless   ClusterIP   None            <none>        9200/TCP,9300/TCP   6m13s
service/kibana-kibana                   ClusterIP   172.20.9.140    <none>        5601/TCP            5m59s

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kibana-kibana   1/1     1            1           5m59s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/kibana-kibana-b4dfc69c7   1         1         1       5m59s

NAME                                    READY   AGE
statefulset.apps/elasticsearch-master   2/3     6m13s



```



## Tearing down

```shell
terraform destroy
```

Example:
```
$ terraform destroy

...

  Enter a value: yes

aws_route_table_association.private[0]: Destroying... [id=rtbassoc-0dd62b87e90670453]
aws_route_table_association.private[1]: Destroying... [id=rtbassoc-05ec5c6203b948a44]
aws_route_table_association.public[0]: Destroying... [id=rtbassoc-046f9b5891288e4f4]
aws_route_table_association.public[1]: Destroying... [id=rtbassoc-0ba32e3e2d8bb18b9]
aws_eks_node_group.nodegroup[0]: Destroying... [id=mycluster:001-group]
aws_route_table_association.public[1]: Destruction complete after 4s
aws_route_table_association.public[0]: Destruction complete after 4s
aws_route_table_association.private[0]: Destruction complete after 4s
aws_route_table_association.private[1]: Destruction complete after 4s
aws_route_table.public: Destroying... [id=rtb-04827e4f49d16a564]
aws_route_table.private[1]: Destroying... [id=rtb-02e83a764101b153f]
aws_route_table.private[0]: Destroying... [id=rtb-0c9b1a29a54cd57b8]
aws_route_table.public: Destruction complete after 5s
aws_internet_gateway.igw: Destroying... [id=igw-0e7ac330db4105c75]
aws_route_table.private[1]: Destruction complete after 5s
aws_route_table.private[0]: Destruction complete after 5s
aws_nat_gateway.nat[1]: Destroying... [id=nat-0b4f7bc12cbeee77b]
aws_nat_gateway.nat[0]: Destroying... [id=nat-04d768e678a115e74]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 10s elapsed]
aws_internet_gateway.igw: Still destroying... [id=igw-0e7ac330db4105c75, 10s elapsed]
aws_nat_gateway.nat[0]: Still destroying... [id=nat-04d768e678a115e74, 10s elapsed]
aws_nat_gateway.nat[1]: Still destroying... [id=nat-0b4f7bc12cbeee77b, 10s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 20s elapsed]
aws_internet_gateway.igw: Still destroying... [id=igw-0e7ac330db4105c75, 20s elapsed]
aws_nat_gateway.nat[0]: Still destroying... [id=nat-04d768e678a115e74, 20s elapsed]
aws_nat_gateway.nat[1]: Still destroying... [id=nat-0b4f7bc12cbeee77b, 20s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 30s elapsed]
aws_internet_gateway.igw: Still destroying... [id=igw-0e7ac330db4105c75, 30s elapsed]
aws_nat_gateway.nat[1]: Still destroying... [id=nat-0b4f7bc12cbeee77b, 30s elapsed]
aws_nat_gateway.nat[0]: Still destroying... [id=nat-04d768e678a115e74, 30s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 40s elapsed]
aws_internet_gateway.igw: Still destroying... [id=igw-0e7ac330db4105c75, 40s elapsed]
aws_nat_gateway.nat[0]: Still destroying... [id=nat-04d768e678a115e74, 40s elapsed]
aws_nat_gateway.nat[1]: Still destroying... [id=nat-0b4f7bc12cbeee77b, 40s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 50s elapsed]
aws_nat_gateway.nat[0]: Destruction complete after 49s
aws_internet_gateway.igw: Still destroying... [id=igw-0e7ac330db4105c75, 50s elapsed]
aws_nat_gateway.nat[1]: Still destroying... [id=nat-0b4f7bc12cbeee77b, 50s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 1m0s elapsed]
aws_internet_gateway.igw: Still destroying... [id=igw-0e7ac330db4105c75, 1m0s elapsed]
aws_nat_gateway.nat[1]: Destruction complete after 1m0s
aws_eip.nat[0]: Destroying... [id=eipalloc-0ad5493a3cc2cea37]
aws_eip.nat[1]: Destroying... [id=eipalloc-01f1150f85c3c4410]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 1m10s elapsed]
aws_eip.nat[1]: Destruction complete after 4s
aws_eip.nat[0]: Destruction complete after 4s
aws_internet_gateway.igw: Still destroying... [id=igw-0e7ac330db4105c75, 1m10s elapsed]
aws_internet_gateway.igw: Destruction complete after 1m10s
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 1m20s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 1m30s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 1m40s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 1m50s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 2m0s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 2m10s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 2m20s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 2m30s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 2m40s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 2m50s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 3m0s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 3m10s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 3m20s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 3m30s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 3m40s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 3m50s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 4m0s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 4m10s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 4m20s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 4m30s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 4m40s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 4m50s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 5m0s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 5m10s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 5m20s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 5m30s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 5m40s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 5m50s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 6m0s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 6m10s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 6m20s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 6m30s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 6m40s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 6m50s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 7m0s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 7m10s elapsed]
aws_eks_node_group.nodegroup[0]: Still destroying... [id=mycluster:001-group, 7m20s elapsed]
aws_eks_node_group.nodegroup[0]: Destruction complete after 7m25s
aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy: Destroying... [id=mycluster-node-20210802150034507800000003]
aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly: Destroying... [id=mycluster-node-20210802150034509000000004]
aws_iam_role_policy.EKSClusterAutoscaler: Destroying... [id=mycluster-node:EKSClusterAutoscaler]
aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy: Destroying... [id=mycluster-node-20210802150034541500000005]
aws_iam_role_policy_attachment.AmazonSSMManagedInstanceCore: Destroying... [id=mycluster-node-20210802150034543300000006]
aws_eks_cluster.cluster: Destroying... [id=mycluster]
aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy: Destruction complete after 1s
aws_iam_role_policy.EKSClusterAutoscaler: Destruction complete after 1s
aws_iam_role_policy_attachment.AmazonSSMManagedInstanceCore: Destruction complete after 1s
aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly: Destruction complete after 1s
aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy: Destruction complete after 1s
aws_iam_role.node: Destroying... [id=mycluster-node]
aws_iam_role.node: Destruction complete after 2s
aws_eks_cluster.cluster: Still destroying... [id=mycluster, 10s elapsed]
aws_eks_cluster.cluster: Still destroying... [id=mycluster, 20s elapsed]
aws_eks_cluster.cluster: Still destroying... [id=mycluster, 30s elapsed]
aws_eks_cluster.cluster: Still destroying... [id=mycluster, 40s elapsed]
aws_eks_cluster.cluster: Still destroying... [id=mycluster, 50s elapsed]
aws_eks_cluster.cluster: Destruction complete after 1m0s
aws_iam_role_policy_attachment.AmazonEKSServicePolicy: Destroying... [id=mycluster-cluster-20210802150034505800000002]
aws_iam_role_policy_attachment.AmazonEKSClusterPolicy: Destroying... [id=mycluster-cluster-20210802150034502200000001]
aws_subnet.private[0]: Destroying... [id=subnet-069e9af7fd8014abe]
aws_subnet.public[1]: Destroying... [id=subnet-07b4f82f5cdc33751]
aws_subnet.private[1]: Destroying... [id=subnet-0126fb9d4cc8ad28b]
aws_subnet.public[0]: Destroying... [id=subnet-01ee0eae18f927cc3]
aws_iam_role_policy_attachment.AmazonEKSClusterPolicy: Destruction complete after 0s
aws_iam_role_policy_attachment.AmazonEKSServicePolicy: Destruction complete after 0s
aws_iam_role.cluster: Destroying... [id=mycluster-cluster]
aws_iam_role.cluster: Destruction complete after 2s
aws_subnet.private[1]: Destruction complete after 3s
aws_subnet.private[0]: Destruction complete after 3s
aws_subnet.public[0]: Destruction complete after 3s
aws_subnet.public[1]: Destruction complete after 3s
aws_vpc.vpc: Destroying... [id=vpc-04c9ab8f8bb7c22e3]
aws_vpc.vpc: Destruction complete after 1s

Destroy complete! Resources: 28 destroyed.

```

## What now?

Documentation to check out:
* [EKS user guide](https://docs.aws.amazon.com/eks/latest/userguide)
* [Terraform EKS cluster reference](https://www.terraform.io/docs/providers/aws/r/eks_cluster.html)
* [CNI proposal on Kubernetes networking with AWS VPC](https://github.com/aws/amazon-vpc-cni-k8s/blob/master/docs/cni-proposal.md)

Other things you may wish to do:
* Set up the [Kubernetes dashboard](https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html)
* Set up [cluster autoscaler](https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html)
* Set up an ingress controller like [nginx ingress controller](https://kubernetes.github.io/ingress-nginx/deploy/#aws)
* Set up [Prometheus and Grafana monitoring](https://www.eksworkshop.com/intermediate/240_monitoring/)
* Set up CI like [Jenkins X](https://jenkins-x.io/docs/)
* Set up [ExternalDNS for integration with Route 53](https://github.com/kubernetes-sigs/external-dns)
* Configure [control plane logging](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)
* Use [Calico for network policy enforcement](https://docs.aws.amazon.com/eks/latest/userguide/calico.html)
* [Restrict access to Kubernetes API server](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html)
