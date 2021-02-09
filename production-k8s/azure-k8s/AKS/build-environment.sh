#!/bin/bash
set -eux

# install dependencies.
sudo apt-get update
sudo apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg

# install azure-cli.
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y azure-cli
az --version

# install terraform.
# see https://www.terraform.io/downloads.html
artifact_url=https://releases.hashicorp.com/terraform/0.14.4/terraform_0.14.4_linux_amd64.zip
artifact_sha=042f1f4fb47696b3442eca12bce7cce6de0b477b299503ddad6b8bc3777a54b5
artifact_path="/tmp/$(basename $artifact_url)"
wget -qO $artifact_path $artifact_url
if [ "$(sha256sum $artifact_path | awk '{print $1}')" != "$artifact_sha" ]; then
    echo "downloaded $artifact_url failed the checksum verification"
    exit 1
fi
sudo unzip -o $artifact_path -d /usr/local/bin
rm $artifact_path
CHECKPOINT_DISABLE=1 terraform version

# install kubectl, the same version of AKS k8s (see AKS/variables.tf)

wget https://dl.k8s.io/v1.19.6/kubernetes-client-linux-amd64.tar.gz
tar -zxvf kubernetes-client-linux-amd64.tar.gz && sudo cp ./kubernetes/client/bin/kubectl /usr/local/bin && rm -rf ./kubernetes


