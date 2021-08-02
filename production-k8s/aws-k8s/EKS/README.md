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


## Setup variables

In `main.tf` set your AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY

  `access_key = ""`
  `secret_key = ""`

In `terraform.tfvars` set the variables you'd like.

`name` and `region` must be defined, everything else is optional.

## Provisioning

```shell
terraform init
terraform plan
terraform apply
```

## Configure kubectl

Pre: Install aws-iam-authenticator
```
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
sudo cp ./aws-iam-authenticator /usr/local/bin
aws-iam-authenticator help
```

See [this guide on setting up authentication](https://docs.aws.amazon.com/eks/latest/userguide/managing-auth.html).

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
kubectl get nodes -o wide
kubectl get all --all-namespaces
```
Example:

```
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
