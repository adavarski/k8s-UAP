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
