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
terraform apply
```

## Configure kubectl

See [this guide on setting up authentication](https://docs.aws.amazon.com/eks/latest/userguide/managing-auth.html).

## Test it works

```shell
kubectl get nodes -o wide
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
