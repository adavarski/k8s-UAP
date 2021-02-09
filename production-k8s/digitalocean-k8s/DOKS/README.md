# Example DigitalOcean Kubernetes cluster using Terraform

This repository showcases using Terraform to provision a new DigitalOcean VPC, and managed Kubernetes cluster with nodes within.

## Install and configure

Setup [`doctl`](https://github.com/digitalocean/doctl) on your system, and initialise auth:

```shell
doctl auth init
```

When requested, enter a token generated from the [Applications & API](https://cloud.digitalocean.com/account/api/tokens) section of the DigitalOcean dashboard.

Now export the token as an environment variable so Terraform can find it:

```shell
export TF_VAR_do_token=YOUR_TOKEN_HERE
```

### Setup variables

`name` and `region` are required. `cluster_version` specifies the Kubernetes version to use (currently defaults to `1.18`.)

* `doctl kubernetes options regions` shows which regions are available, use the slug value for `region`.
* `doctl kubernetes options versions` shows which Kubernetes versions are available, use the slug value for `cluster_version`.

## Provisioning

```shell
terraform init
terraform apply
```

### Configure kubectl

Retrieve the kubeconfig using `doctl` (replacing `mycluster` with the name you specified in `terraform.tfvars`):

```shell
doctl kubernetes cluster kubeconfig save mycluster
```

### Test it works

```shell
kubectl get nodes -o wide
```

## Tearing down

```shell
terraform destroy
```

## What now?

See the [Kubernetes on DigitalOcean documentation](https://www.digitalocean.com/docs/kubernetes/) for general information on the service,
and [Kubernetes on DigitalOcean resources](https://www.digitalocean.com/resources/kubernetes/) for guides and tutorials on building
and operating Kubernetes. You might also want to check out a guide on [upgrading DigitalOcean Kubernetes clusters](https://www.digitalocean.com/docs/kubernetes/how-to/upgrade-cluster/).

Some examples of integrations with DigitalOcean you can configure:

* [Use DigitalOcean load balancers with Kubernetes](https://www.digitalocean.com/docs/kubernetes/how-to/add-load-balancers/)
* [Use DigitalOcean block storage volumes with Kubernetes](https://www.digitalocean.com/docs/kubernetes/how-to/add-volumes/)
