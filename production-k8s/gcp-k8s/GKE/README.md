### Terraform GKE + simple demo 

This repository contains a Terraform project that builds a Google Kubernetes Engine cluster with a custom node pool.

### Requirements:

- gcloud-sdk
- terraform
- kubernetes-cli


#### Install Terraform

#### Install Cloud SDK (gcloud, gsutil, bq, etc.)

Note: Cloud SDK requires Python; supported versions are Python 3 (preferred, 3.5 to 3.8) and Python 2 (2.7.9 or higher).

```
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-326.0.0-linux-x86_64.tar.gz
tar -zxvf google-cloud-sdk-326.0.0-linux-x86_64.tar.gz 
```
Optional. Use the install script to add Cloud SDK tools to your path. You'll also be able to opt-in to command-completion for your shell and usage statistics collection. Run the script using this command:
```
./google-cloud-sdk/install.sh
```
Run gcloud init to initialize the SDK:
```
./google-cloud-sdk/bin/gcloud init
```
Check:
```
$ ./google-cloud-sdk/bin/gcloud config list
[core]
account = YOUR_GOOGLE_ACCOUNT@gmail.com
disable_usage_reporting = True
project = PROJECT_ID

Your active configuration is: [default]
```

#### Install kubectl

### Tasks

- Sign up/in for GCP
- Create a new Google Cloud Project (Demo)
- Create service account for terraform (Name: demo-terraform; Role: Owner or Roles: Kubernetes Engine Admin/Storage Admin/Service Account User), service account key (ADD KEY: Select JSON as the key type) and download JSON credentials
- Copy downloaded JSON credentials file as credentials.json file to the project directory for this demo.
- Enable Kubernetes Engine API & Compute Engine API (APIs & Services) 
- Add SSH keys: ssh-keygen and add ssh pub key (Compute Engine/Metadata/SSH Keys -> add davar:generated pub key). Note: All instances in this project inherit these SSH keys 

- Run vim main.tf to set the project ID (etc.)
- Terraforming: terraform init/plan/apply
```
terraform init
terraform fmt/plan
terraform apply
```
Example Output:
```
$ terraform apply

...
google_container_cluster.gke-cluster: Creating...
...
google_container_cluster.gke-cluster: Still creating... [2m40s elapsed]
google_container_cluster.gke-cluster: Creation complete after 2m50s [id=projects/windy-art-303706/locations/europe-west2-a/clusters/gke-demo]
google_container_node_pool.primary_pool: Creating...
...
google_container_node_pool.primary_pool: Still creating... [5m0s elapsed]
google_container_node_pool.primary_pool: Creation complete after 5m2s [id=projects/windy-art-303706/locations/europe-west2-a/clusters/gke-demo/nodePools/primary-pool]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
Check k8s cluster:

```
$ ./google-cloud-sdk/bin/gcloud container clusters list
NAME      LOCATION        MASTER_VERSION    MASTER_IP     MACHINE_TYPE   NODE_VERSION      NUM_NODES  STATUS
gke-demo  europe-west2-a  1.17.14-gke.1600  34.89.78.209  n1-standard-1  1.17.14-gke.1600  1          RUNNING
```
- Install kubectl using Google Cloud SDK
```
$ ./google-cloud-sdk/bin/gcloud components install kubectl

Your current Cloud SDK version is: 326.0.0
Installing components from version: 326.0.0

┌──────────────────────────────────────────────────────────────────┐
│               These components will be installed.                │
├─────────────────────┬─────────────────────┬──────────────────────┤
│         Name        │       Version       │         Size         │
├─────────────────────┼─────────────────────┼──────────────────────┤
│ kubectl             │             1.17.14 │             71.7 MiB │
│ kubectl             │             1.17.14 │              < 1 MiB │
└─────────────────────┴─────────────────────┴──────────────────────┘

For the latest full release notes, please visit:
  https://cloud.google.com/sdk/release_notes

Do you want to continue (Y/n)?  Y

╔════════════════════════════════════════════════════════════╗
╠═ Creating update staging area                             ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Installing: kubectl                                      ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Installing: kubectl                                      ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Creating backup and activating new installation          ═╣
╚════════════════════════════════════════════════════════════╝

Performing post processing steps...done.                                                                                                                                                        

Update done!
```
- Install kubectl (not using Google SDK)

Note: GKE k8s version is 1.17.14, so we have to install the same kubectl version. To install without Google Cloud SDK

```
$ wget https://dl.k8s.io/v1.17.14/kubernetes-client-linux-amd64.tar.gz
$ tar -zxvf kubernetes-client-linux-amd64.tar.gz 
kubernetes/
kubernetes/client/
kubernetes/client/bin/
kubernetes/client/bin/kubectl

$ ./kubernetes/client/bin/kubectl version
Client Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.14", GitCommit:"f238f5142728be4033c37aa0ad69bf806090beae", GitTreeState:"clean", BuildDate:"2020-11-11T13:11:40Z", GoVersion:"go1.13.15", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"17+", GitVersion:"v1.17.14-gke.1600", GitCommit:"7c407f5cc8632f9af5a2657f220963aa7f1c46e7", GitTreeState:"clean", BuildDate:"2020-12-07T09:22:27Z", GoVersion:"go1.13.15b4", Compiler:"gc", Platform:"linux/amd64"}

$ sudo mv ./kubernetes/client/bin/kubectl /usr/local/bin/

```
- Setup kubeconfig
```
$ gcloud config set project PROJECT_ID (Optional: set the current project)

$ export KUBECONFIG=~/.kube/k8s-GKE

$ ./google-cloud-sdk/bin/gcloud container clusters get-credentials gke-demo --zone europe-west2-a
Fetching cluster endpoint and auth data.
kubeconfig entry generated for gke-demo.

$ cat ~/.kube/k8s-GKE
```

Now you can access your cluster using the Kubernetes CLI: kubectl cluster-info.

```
$ kubectl cluster-info
Kubernetes master is running at https://34.89.78.209
GLBCDefaultBackend is running at https://34.89.78.209/api/v1/namespaces/kube-system/services/default-http-backend:http/proxy
KubeDNS is running at https://34.89.78.209/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://34.89.78.209/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

$ kubectl get all --all-namespaces
NAMESPACE     NAME                                                            READY   STATUS    RESTARTS   AGE
kube-system   pod/event-exporter-gke-666b7ffbf7-clzhp                         2/2     Running   0          36m
kube-system   pod/fluentbit-gke-59lwd                                         2/2     Running   0          35m
kube-system   pod/gke-metrics-agent-7mw9r                                     1/1     Running   0          35m
kube-system   pod/kube-dns-9c59558bb-lxnc6                                    4/4     Running   4          36m
kube-system   pod/kube-dns-autoscaler-5c78d65cd9-7l59w                        1/1     Running   0          36m
kube-system   pod/kube-proxy-gke-gke-demo-primary-pool-19cba24b-p1mc          1/1     Running   0          35m
kube-system   pod/l7-default-backend-5b76b455d-bq66c                          1/1     Running   0          36m
kube-system   pod/metrics-server-v0.3.6-547dc87f5f-x54pp                      2/2     Running   3          34m
kube-system   pod/prometheus-to-sd-v5fz7                                      1/1     Running   0          35m
kube-system   pod/stackdriver-metadata-agent-cluster-level-7db8c69448-rq28f   2/2     Running   0          30m

NAMESPACE     NAME                           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
default       service/kubernetes             ClusterIP   10.35.240.1     <none>        443/TCP         36m
kube-system   service/default-http-backend   NodePort    10.35.245.83    <none>        80:31920/TCP    36m
kube-system   service/kube-dns               ClusterIP   10.35.240.10    <none>        53/UDP,53/TCP   36m
kube-system   service/metrics-server         ClusterIP   10.35.247.169   <none>        443/TCP         36m

NAMESPACE     NAME                                       DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                                                             AGE
kube-system   daemonset.apps/fluentbit-gke               1         1         1       1            1           beta.kubernetes.io/os=linux                                               36m
kube-system   daemonset.apps/gke-metrics-agent           1         1         1       1            1           kubernetes.io/os=linux                                                    36m
kube-system   daemonset.apps/gke-metrics-agent-windows   0         0         0       0            0           kubernetes.io/os=windows                                                  36m
kube-system   daemonset.apps/kube-proxy                  0         0         0       0            0           beta.kubernetes.io/os=linux,node.kubernetes.io/kube-proxy-ds-ready=true   36m
kube-system   daemonset.apps/metadata-proxy-v0.1         0         0         0       0            0           beta.kubernetes.io/os=linux,cloud.google.com/metadata-proxy-ready=true    36m
kube-system   daemonset.apps/nvidia-gpu-device-plugin    0         0         0       0            0           <none>                                                                    36m
kube-system   daemonset.apps/prometheus-to-sd            1         1         1       1            1           beta.kubernetes.io/os=linux                                               36m

NAMESPACE     NAME                                                       READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/event-exporter-gke                         1/1     1            1           36m
kube-system   deployment.apps/kube-dns                                   1/1     1            1           36m
kube-system   deployment.apps/kube-dns-autoscaler                        1/1     1            1           36m
kube-system   deployment.apps/l7-default-backend                         1/1     1            1           36m
kube-system   deployment.apps/metrics-server-v0.3.6                      1/1     1            1           36m
kube-system   deployment.apps/stackdriver-metadata-agent-cluster-level   1/1     1            1           36m

NAMESPACE     NAME                                                                  DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/event-exporter-gke-666b7ffbf7                         1         1         1       36m
kube-system   replicaset.apps/kube-dns-9c59558bb                                    1         1         1       36m
kube-system   replicaset.apps/kube-dns-autoscaler-5c78d65cd9                        1         1         1       36m
kube-system   replicaset.apps/l7-default-backend-5b76b455d                          1         1         1       36m
kube-system   replicaset.apps/metrics-server-v0.3.6-547dc87f5f                      1         1         1       34m
kube-system   replicaset.apps/metrics-server-v0.3.6-6bf8877855                      0         0         0       36m
kube-system   replicaset.apps/stackdriver-metadata-agent-cluster-level-5df5985c68   0         0         0       36m
kube-system   replicaset.apps/stackdriver-metadata-agent-cluster-level-7db8c69448   1         1         1       30m
```
Apply some manifests:

```
$ cd k8s-manifests

#Storage and persistent disks

$ kubectl apply -f ssd.yaml
$ kubectl apply -f storage-change.yaml

#Load balancing

$ kubectl run nginx --image=nginx --port=80
deployment.apps/nginx created

$ kubectl expose deployment nginx --target-port=80 --type=NodePort
service/nginx exposed

$ kubectl get service nginx
NAME    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx   NodePort   10.35.255.244   <none>        80:32494/TCP   31s

$ kubectl get all
NAME                         READY   STATUS    RESTARTS   AGE
pod/nginx-5578584966-zxpzs   1/1     Running   0          17m

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/kubernetes   ClusterIP   10.35.240.1     <none>        443/TCP        62m
service/nginx        NodePort    10.35.255.244   <none>        80:32494/TCP   16m

NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   1/1     1            1           17m

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-5578584966   1         1         1       17m

$ kubectl apply -f basic-ingress.yaml
ingress.extensions/basic-ingress created

$ kubectl get ingress basic-ingress
NAME            HOSTS   ADDRESS         PORTS   AGE
basic-ingress   *       34.107.226.55   80      42s

#Check nginx ---> http://34.107.226.55/ ---> Welcome to nginx!

#Clean ingress/nginx service/deployment

$ kubectl delete -f basic-ingress.yaml
ingress.extensions "basic-ingress" deleted

$ kubectl delete service/nginx
service "nginx" deleted

$ kubectl delete deployment.apps/nginx
deployment.apps "nginx" deleted

# Scaling nodes with the cluster autoscaler

gcloud container clusters create [CLUSTER-NAME] --num-nodes=5 \
--enable-autoscaling --min-nodes=3 --max-nodes=10 [--zone=[ZONE] \ --project=[PROJECT-
ID]]

# Scaling pods with the horizontal pod autoscaler (HPA)

$ kubectl autoscale deployment my-app --max=6 --min=4 --cpu-percent=50
$ kubectl describe hpa [NAME-OF-HPA]
$ kubectl delete hpa [NAME-OF-HPA]

# Container registry 

$ docker pull nginx
Using default tag: latest
...
docker.io/library/nginx:latest
$ docker tag nginx us.gcr.io/windy-art-303706/nginx
$ gcloud docker -- push us.gcr.io/windy-art-303706/nginx
$ gcloud docker -- pull us.gcr.io/windy-art-303706/nginx
$ gcloud container images delete us.gcr.io/windy-art-303706/nginx
$ kubectl run nginx --image=us.gcr.io/windy-art-303706/nginx

#Rolling updates
$ kubectl set image deployment nginx nginx=nginx:1.12.2
$ kubectl set resources deployment nginx --limits=cpu=400m,memory=1024Mi --requests=cpu=200m,memory=512Mi
$ kubectl rollout status deployment nginx
$ kubectl rollout pause deployment nginx
$ kubectl rollout resume deployment nginx
$ kubectl rollout undo deployment nginx --to-revision=3

#SSH to Worker Node (user davar)

$ gcloud compute ssh gke-gke-demo-primary-pool-7d9203ca-v865 --zone europe-west2-a
Warning: Permanently added 'compute.6329642282550514897' (ED25519) to the list of known hosts.

Welcome to Kubernetes v1.17.14-gke.1600!

You can find documentation for Kubernetes at:
  http://docs.kubernetes.io/

The source for this release can be found at:
  /home/kubernetes/kubernetes-src.tar.gz
Or you can download it at:
  https://storage.googleapis.com/kubernetes-release-gke/release/v1.17.14-gke.1600/kubernetes-src.tar.gz

It is based on the Kubernetes source at:
  https://github.com/kubernetes/kubernetes/tree/v1.17.14-gke.1600

For Kubernetes copyright and licensing information, see:
  /home/kubernetes/LICENSES

davar@gke-gke-demo-primary-pool-7d9203ca-v865 ~ $ ps -ef
davar@gke-gke-demo-primary-pool-7d9203ca-v865 ~ $ docker ps -a
```

- Clean GKE cluster: `terraform destroy`
