## DataProcessing (Data Lake: MinIO)


<img src="https://github.com/adavarski/k8s-UAP/blob/main/k8s/Demo2-DataProcessing-MinIO/pictures/6-DataLakes_object_processin_pipeline.png" width="800">

Data Lake as Object Storage: Build a Data Lake with Object Storage, implemented with MinIO. MinIO provides a distributed, fault-tolerant object storage system compatible with Amazon S3. MinIO is horizontally scalable and supports objects up to five terabytes, with no limit to the number of objects it may store. These capabilities alone meet the basic conceptual requirements of a Data Lake. However, MinIO is extensible though its support for events and a powerful S3-compatible query system. Transactional databases, data warehouses, and data marts are all technologies that intend to store and retrieve data in known structures. Organizations often need to store new and varied types of data, often whose form is not known or suitable for structured data systems. The concept of managing this idea of unlimited data in any conceivable form is known as a Data Lake. Traditionally, filesystems and block storage solutions store most file-based data that an organization wishes to gather and maintain outside of its database management systems. Filesystems and block storage systems are challenging to scale, with varying degrees of fault tolerance, distribution, and limited support for metadata and analytics. HDFS (Hadoop Distributed File System) has been a popular choice for organizations needing the conceptual advantage of a Data Lake. HDFS is complicated to set up and maintain, typically requiring dedicated infrastructure and one or more experts to keep it operational and performant.


### Install MinIO client

```
$ wget https://dl.min.io/client/mc/release/linux-amd64/mc && chmod +x mc && sudo mv mc /usr/local/bin
```

### Configure mc and create MinIO buckets 
```
$ mc config host add minio-cluster https://minio.data.davar.com minio minio123 --insecure
mc: Configuration written to `/home/davar/.mc/config.json`. Please update your access credentials.
mc: Successfully created `/home/davar/.mc/share`.
mc: Initialized share uploads `/home/davar/.mc/share/uploads.json` file.
mc: Initialized share downloads `/home/davar/.mc/share/downloads.json` file.
Added `minio-cluster` successfully.
```
Note: --insecure, because of self-signed certificate (ingress)

Edit /home/davar/.mc/config.json and change "url": "https://minio.data.davar.com" to "url": "http://minio.data.davar.com", because we will not use TLS (`mc --insecure`, if we use https) during this demo.

```
$ mc mb minio-cluster/upload
$ mc mb minio-cluster/processed
$ mc mb minio-cluster/twitter
$ mc config host list
$ mc ls minio-cluster 
[2020-12-02 09:56:08 EET]     0B processed/
[2020-12-02 09:56:20 EET]     0B twitter/
[2020-12-02 09:55:57 EET]     0B upload/
$ mc ls minio-cluster/upload
```
### Configure MinIO Events 
```
$ mc admin config set minio-cluster notify_kafka:1 enable=on topic=upload brokers="kafka:9092" sasl_username= sasl_password= sasl_mechanism=plain client_tls_cert= client_tls_key= tls_client_auth=0 sasl=off tls=off tls_skip_verify=off queue_limit=0
$ mc admin config set minio-cluster notify_elasticsearch:1 enable=on format="namespace" index="processed" url="http://elasticsearch:9200" --insecure
$ mc admin config set minio-cluster notify_mqtt:1 enable=on broker="tcp://mqtt:1883" topic=processed password= username= qos=0 keep_alive_interval=0s reconnect_interval=0s queue_dir= queue_limit=0 --insecure

$ mc admin service restart minio-cluster

$ mc admin config get minio-cluster notify_elasticsearch 
notify_elasticsearch enable=off url= format=namespace index= queue_dir= queue_limit=0 
notify_elasticsearch:1 url=http://elasticsearch:9200 format=namespace index=processed queue_dir= queue_limit=0 

$ mc admin config get minio-cluster notify_kafka 
notify_kafka enable=off topic= brokers= sasl_username= sasl_password= sasl_mechanism=plain client_tls_cert= client_tls_key= tls_client_auth=0 sasl=off tls=off tls_skip_verify=off queue_limit=0 queue_dir= version= 
notify_kafka:1 topic=upload brokers=kafka:9092 sasl_username= sasl_password= sasl_mechanism=plain client_tls_cert= client_tls_key= tls_client_auth=0 sasl=off tls=off tls_skip_verify=off queue_limit=0 queue_dir= version= 

$ mc admin config get minio-cluster notify_mqtt 
notify_mqtt:1 broker=tcp://mqtt:1883 topic=processed password= username= qos=0 keep_alive_interval=0s reconnect_interval=0s queue_dir= queue_limit=0 
notify_mqtt enable=off broker= topic= password= username= qos=0 keep_alive_interval=0s reconnect_interval=0s queue_dir= queue_limit=0 


```
### Configure Minio Notifications 
```
$ mc event add minio-cluster/upload arn:minio:sqs::1:kafka --event put --suffix=".csv" 
$ mc event add minio-cluster/processed arn:minio:sqs::1:mqtt --event put --suffix=".gz" 
$ mc event add minio-cluster/processed arn:minio:sqs::1:elasticsearch --event put --suffix=".gz"

$ mc admin service restart minio-cluster ## optional

```
### Test MinIO Events/Notifications: Create test.cvs file, mc cp to upload bucket and check kafka topic: upload

```
$ echo test > test.csv
$ mc cp test1.csv minio-cluster/upload

$ kubectl exec -it kafka-client-util bash -n data
root@kafka-client-util:/# kafka-topics --zookeeper zookeeper-headless:2181 --list
__confluent.support.metrics
__consumer_offsets
messages
metrics
twitter
upload
root@kafka-client-util:/# kafka-console-consumer --bootstrap-server kafka:9092 --topic upload --from-beginning -max-messages 3
{"EventName":"s3:ObjectCreated:Put","Key":"upload/test.csv","Records":[{"eventVersion":"2.0","eventSource":"minio:s3","awsRegion":"","eventTime":"2020-12-02T08:42:59.822Z","eventName":"s3:ObjectCreated:Put","userIdentity":{"principalId":"minio"},"requestParameters":{"accessKey":"minio","region":"","sourceIPAddress":"10.42.0.1"},"responseElements":{"content-length":"0","x-amz-request-id":"164CD9BE9FBE5C85","x-minio-deployment-id":"85826866-b2ff-4c9e-80c6-48d91e742c43","x-minio-origin-endpoint":"http://10.42.0.135:9000"},"s3":{"s3SchemaVersion":"1.0","configurationId":"Config","bucket":{"name":"upload","ownerIdentity":{"principalId":"minio"},"arn":"arn:aws:s3:::upload"},"object":{"key":"test.csv","eTag":"d41d8cd98f00b204e9800998ecf8427e","contentType":"text/csv","userMetadata":{"content-type":"text/csv"},"sequencer":"164CD9BEA0672963"}},"source":{"host":"10.42.0.1","port":"","userAgent":"MinIO (linux; amd64) minio-go/v7.0.6 mc/2020-11-25T23:04:07Z"}}]}
^CProcessed a total of 1 messages

root@kafka-client-util:/# kafka-console-consumer --bootstrap-server kafka:9092 --topic upload --from-beginning -max-messages 1|python -m json.tool
Processed a total of 1 messages
{
    "EventName": "s3:ObjectCreated:Put",
    "Key": "upload/test.csv",
    "Records": [
        {
            "awsRegion": "",
            "eventName": "s3:ObjectCreated:Put",
            "eventSource": "minio:s3",
            "eventTime": "2020-12-02T08:42:59.822Z",
            "eventVersion": "2.0",
            "requestParameters": {
                "accessKey": "minio",
                "region": "",
                "sourceIPAddress": "10.42.0.1"
            },
            "responseElements": {
                "content-length": "0",
                "x-amz-request-id": "164CD9BE9FBE5C85",
                "x-minio-deployment-id": "85826866-b2ff-4c9e-80c6-48d91e742c43",
                "x-minio-origin-endpoint": "http://10.42.0.135:9000"
            },
            "s3": {
                "bucket": {
                    "arn": "arn:aws:s3:::upload",
                    "name": "upload",
                    "ownerIdentity": {
                        "principalId": "minio"
                    }
                },
                "configurationId": "Config",
                "object": {
                    "contentType": "text/csv",
                    "eTag": "d41d8cd98f00b204e9800998ecf8427e",
                    "key": "test.csv",
                    "sequencer": "164CD9BEA0672963",
                    "userMetadata": {
                        "content-type": "text/csv"
                    }
                },
                "s3SchemaVersion": "1.0"
            },
            "source": {
                "host": "10.42.0.1",
                "port": "",
                "userAgent": "MinIO (linux; amd64) minio-go/v7.0.6 mc/2020-11-25T23:04:07Z"
            },
            "userIdentity": {
                "principalId": "minio"
            }
        }
    ]
}

```

### Install/Configure Go  
```
$ wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
$ sudo tar -C /usr/local -xzf go1.15.5.linux-amd64.tar.gz

# setup go dev environment
$ tail -n5 ~/.bashrc 

export GOROOT=/usr/local/go
export PATH=${GOROOT}/bin:${PATH}
export GOPATH=$HOME/go
export PATH=${GOPATH}/bin:${PATH}

davar@carbon:~$ source ~/.bashrc 
davar@carbon:~$ go version
go version go1.15.5 linux/amd64
$ go env

OR logout/login from console (go version)

Note: As of Go 1.14, Go Modules are ready for production use and considered the official dependency management system for Go. All developers are encouraged to use Go Modules for new projects along with migrating any existing projects.
```
### Create Go compressor app
```
mkdir -p ~/workspace/compressor
cd ~/workspace/compressor/
go mod init github.com/compressor
mkdir cmd
cp GIT_CLONE_REPO_LOCATION/composer/compressor.go cmd/
cp GIT_CLONE_REPO_LOCATION/composer/Dockerfile .

```
Test go app (execute the compressor application configured with the
buckets upload and processed along with the object upload/donors.csv)

```
$ for i in {1..1000000};do echo "test$i" >> donors.csv;done
$ mc cp donors.csv minio-cluster/upload 
donors.csv:                                   10.39 MiB / 10.39 MiB ┃▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┃ 171.63 MiB/s
$  mc ls minio-cluster/upload
[2020-12-02 20:06:16 EET]  10MiB donors.csv
[2020-12-02 10:42:59 EET]    10B test.csv

```
<img src="https://github.com/adavarski/k8s-UAP/blob/main/k8s//Demo2-DataProcessing-MinIO/pictures/minio-bucket-upload.png" width="800">

```
$ export ENDPOINT=minio.data.davar.com
$ export ACCESS_KEY_ID=minio
$ export ACCESS_KEY_SECRET=minio123
go run ./cmd/compressor.go -f upload -k donors.csv -t processed
$ mc rm minio-cluster/processed/donors.csv.gz

```
### Build/Push/Test go compressor app docker image

```
docker build -t davarski/compressor:v1.0.0 .
docker login
docker push davarski/compressor:v1.0.0

$ docker run -e ENDPOINT=$ENDPOINT -e ACCESS_KEY_ID=$ACCESS_KEY_ID -e ACCESS_KEY_SECRET=$ACCESS_KEY_SECRET -e ENDPOINT_SSL=false davarski/compressor:v1.0.0 -f=upload -k=donors.csv -t=processed
2020/12/02 18:06:49 Starting download stream upload/donors.csv.
2020/12/02 18:06:49 BEGIN PutObject
2020/12/02 18:06:49 Compress and stream.
2020/12/02 18:06:49 Compressed: 10890288 bytes
2020/12/02 18:06:49 COMPLETE PutObject

```
Check kafka topic upload and elasticsearch processed index:

```
$ kubectl exec -it kafka-client-util bash -n data
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
root@kafka-client-util:/# kafka-topics --zookeeper zookeeper-headless:2181 --list
__confluent.support.metrics
__consumer_offsets
messages
metrics
twitter
upload

root@kafka-client-util:/# kafka-console-consumer --bootstrap-server kafka:9092 --topic upload --from-beginning -max-messages 1|python -m json.tool
root@kafka-client-util:/# kafka-console-consumer --bootstrap-server kafka:9092 --topic upload --from-beginning -max-messages 5

root@kafka-client-util:/# kafka-console-consumer --bootstrap-server kafka:9092 --topic upload --from-beginning  -max-messages 9 |tail -n1
Processed a total of 9 messages
{"EventName":"s3:ObjectCreated:Put","Key":"upload/donors.csv","Records":[{"eventVersion":"2.0","eventSource":"minio:s3","awsRegion":"","eventTime":"2020-12-02T18:06:16.463Z","eventName":"s3:ObjectCreated:Put","userIdentity":{"principalId":"minio"},"requestParameters":{"accessKey":"minio","region":"","sourceIPAddress":"10.42.0.1"},"responseElements":{"content-length":"0","x-amz-request-id":"164CF87B7F5E766F","x-minio-deployment-id":"85826866-b2ff-4c9e-80c6-48d91e742c43","x-minio-origin-endpoint":"http://10.42.0.160:9000"},"s3":{"s3SchemaVersion":"1.0","configurationId":"Config","bucket":{"name":"upload","ownerIdentity":{"principalId":"minio"},"arn":"arn:aws:s3:::upload"},"object":{"key":"donors.csv","size":10890288,"eTag":"2a787e31b90587c44bfa22d121acc135","contentType":"text/csv","userMetadata":{"content-type":"text/csv"},"sequencer":"164CF87B85323195"}},"source":{"host":"10.42.0.1","port":"","userAgent":"MinIO (linux; amd64) minio-go/v7.0.6 mc/2020-11-25T23:04:07Z"}}]}
root@kafka-client-util:/# kafka-console-consumer --bootstrap-server kafka:9092 --topic upload --from-beginning  -max-messages 9 |tail -n1| python -m json.tool
Processed a total of 9 messages
{
    "EventName": "s3:ObjectCreated:Put",
    "Key": "upload/donors.csv",
    "Records": [
        {
            "awsRegion": "",
            "eventName": "s3:ObjectCreated:Put",
            "eventSource": "minio:s3",
            "eventTime": "2020-12-02T18:06:16.463Z",
            "eventVersion": "2.0",
            "requestParameters": {
                "accessKey": "minio",
                "region": "",
                "sourceIPAddress": "10.42.0.1"
            },
            "responseElements": {
                "content-length": "0",
                "x-amz-request-id": "164CF87B7F5E766F",
                "x-minio-deployment-id": "85826866-b2ff-4c9e-80c6-48d91e742c43",
                "x-minio-origin-endpoint": "http://10.42.0.160:9000"
            },
            "s3": {
                "bucket": {
                    "arn": "arn:aws:s3:::upload",
                    "name": "upload",
                    "ownerIdentity": {
                        "principalId": "minio"
                    }
                },
                "configurationId": "Config",
                "object": {
                    "contentType": "text/csv",
                    "eTag": "2a787e31b90587c44bfa22d121acc135",
                    "key": "donors.csv",
                    "sequencer": "164CF87B85323195",
                    "size": 10890288,
                    "userMetadata": {
                        "content-type": "text/csv"
                    }
                },
                "s3SchemaVersion": "1.0"
            },
            "source": {
                "host": "10.42.0.1",
                "port": "",
                "userAgent": "MinIO (linux; amd64) minio-go/v7.0.6 mc/2020-11-25T23:04:07Z"
            },
            "userIdentity": {
                "principalId": "minio"
            }
        }
    ]
}

```

Open a terminal and port-forward Elasticsearch:
```
$ kubectl port-forward elasticsearch-0 9200:9200 -n data
Forwarding from 127.0.0.1:9200 -> 9200
Forwarding from [::1]:9200 -> 9200
Handling connection for 9200
Handling connection for 9200
```

The following command returns all records from indexes beginning with processed-:

```
$ curl http://localhost:9200/processed*/_search|python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1260  100  1260    0     0   5727      0 --:--:-- --:--:-- --:--:--  5727
{
    "_shards": {
        "failed": 0,
        "skipped": 0,
        "successful": 1,
        "total": 1
    },
    "hits": {
        "hits": [
            {
                "_id": "processed/donors.csv.gz",
                "_index": "processed",
                "_score": 1.0,
                "_source": {
                    "Records": [
                        {
                            "awsRegion": "",
                            "eventName": "s3:ObjectCreated:CompleteMultipartUpload",
                            "eventSource": "minio:s3",
                            "eventTime": "2020-12-02T18:06:49.748Z",
                            "eventVersion": "2.0",
                            "requestParameters": {
                                "accessKey": "minio",
                                "region": "",
                                "sourceIPAddress": "10.42.0.1"
                            },
                            "responseElements": {
                                "content-length": "329",
                                "x-amz-request-id": "164CF88343E00280",
                                "x-minio-deployment-id": "85826866-b2ff-4c9e-80c6-48d91e742c43",
                                "x-minio-origin-endpoint": "http://10.42.0.160:9000"
                            },
                            "s3": {
                                "bucket": {
                                    "arn": "arn:aws:s3:::processed",
                                    "name": "processed",
                                    "ownerIdentity": {
                                        "principalId": "minio"
                                    }
                                },
                                "configurationId": "Config",
                                "object": {
                                    "contentType": "application/octet-stream",
                                    "eTag": "f7a510642b6464bd49b65f1f2cdb9b4d-1",
                                    "key": "donors.csv.gz",
                                    "sequencer": "164CF883451A05B4",
                                    "size": 2333610,
                                    "userMetadata": {
                                        "X-Minio-Internal-actual-size": "2333610",
                                        "content-type": "application/octet-stream"
                                    }
                                },
                                "s3SchemaVersion": "1.0"
                            },
                            "source": {
                                "host": "10.42.0.1",
                                "port": "",
                                "userAgent": "MinIO (linux; amd64) minio-go/v6.0.44"
                            },
                            "userIdentity": {
                                "principalId": "minio"
                            }
                        }
                    ]
                },
                "_type": "event"
            }
        ],
        "max_score": 1.0,
        "total": {
            "relation": "eq",
            "value": 1
        }
    },
    "timed_out": false,
    "took": 213
}
```

### Kibana : create index pattern (processed-*) and Discover

<img src="https://github.com/adavarski/k8s-UAP/blob/main/k8s/Demo2-DataProcessing-MinIO/pictures/kibana-minio-processed--index-discovery.png" width="800">

### JupyterLab/Jupyter Notebook (Jupyter environment)

Setup RBAC (Role&RoleBinding)  for default service account (permissions to create resource "jobs" in API group "batch" in the namespace "data": {"group":"batch","kind":"jobs"}"

```
kubectl apply -f ./jupyterlab/juputer-role.yml
```
Jupyter Notebooks are a browser-based (or web-based) IDE (integrated development environments)

Build custom JupyterLab docker image and pushing it into DockerHub container registry.
```
$ cd ./jupyterlab
$ docker build -t jupyterlab-eth .
$ docker tag jupyterlab-eth:latest davarski/jupyterlab-eth:latest
$ docker login 
$ docker push davarski/jupyterlab-eth:latest
```
Run Jupyter Notebook inside k8s as pod:

```
kubectl run -i -t jupyter-notebook --namespace=data --restart=Never --rm=true --env="JUPYTER_ENABLE_LAB=yes" --image=davarski/jupyterlab-eth:latest 

```
Example output:
```
davar@carbon:~$ export KUBECONFIG=~/.kube/k3s-config-jupyter 
davar@carbon:~$ kubectl run -i -t jupyter-notebook --namespace=data --restart=Never --rm=true --env="JUPYTER_ENABLE_LAB=yes" --image=davarski/jupyterlab-eth:latest
If you don't see a command prompt, try pressing enter.
[I 08:24:34.011 LabApp] Writing notebook server cookie secret to /home/jovyan/.local/share/jupyter/runtime/notebook_cookie_secret
[I 08:24:34.378 LabApp] Loading IPython parallel extension
[I 08:24:34.402 LabApp] JupyterLab extension loaded from /opt/conda/lib/python3.7/site-packages/jupyterlab
[I 08:24:34.402 LabApp] JupyterLab application directory is /opt/conda/share/jupyter/lab
[W 08:24:34.413 LabApp] JupyterLab server extension not enabled, manually loading...
[I 08:24:34.439 LabApp] JupyterLab extension loaded from /opt/conda/lib/python3.7/site-packages/jupyterlab
[I 08:24:34.440 LabApp] JupyterLab application directory is /opt/conda/share/jupyter/lab
[I 08:24:34.441 LabApp] Serving notebooks from local directory: /home/jovyan
[I 08:24:34.441 LabApp] The Jupyter Notebook is running at:
[I 08:24:34.441 LabApp] http://(jupyter-notebook or 127.0.0.1):8888/?token=5bebb78cc162e7050332ce46371ca3adc82306fac0bc082a
[I 08:24:34.441 LabApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 08:24:34.451 LabApp] 
    
    To access the notebook, open this file in a browser:
        file:///home/jovyan/.local/share/jupyter/runtime/nbserver-7-open.html
    Or copy and paste one of these URLs:
        http://(jupyter-notebook or 127.0.0.1):8888/?token=5bebb78cc162e7050332ce46371ca3adc82306fac0bc082a
```

Once the Pod is running, copy the generated token from the output logs. Jupyter Notebooks listen on port 8888 by default. In testing and demonstrations such as this, it is common to port-forward Pod containers directly to a local workstation rather than configure Services and Ingress. Caution Jupyter Notebooks intend and purposefully allow remote code execution. Exposing Jupyter Notebooks to public interfaces requires proper security considerations.

Port-forward the test-notebook Pod with the following command: 
``
kubectl port-forward jupyter-notebook 8888:8888 -n data
``
Browse to http://localhost:8888//?token=5bebb78cc162e7050332ce46371ca3adc82306fac0bc082a
```
!pip install kubernetes
```
```
from os import path
import yaml
import time
from kubernetes import client, config
from kubernetes.client.rest import ApiException
from IPython.display import clear_output
```
```
envs = [
    client.V1EnvVar("ENDPOINT", "minio-service.data:9000"),
    client.V1EnvVar("ACCESS_KEY_ID", "minio"),
    client.V1EnvVar("ACCESS_KEY_SECRET", "minio123"),
    client.V1EnvVar("ENDPOINT_SSL", "false"),
]
```
```
container = client.V1Container(
    name="compressor",
    image="davarski/compressor:v1.0.0",
    env=envs,
    args=["-f=upload",
          "-k=donors.csv",
          "-t=processed"])
```          
          
```
podTmpl = client.V1PodTemplateSpec(
    metadata=client.V1ObjectMeta(
        labels={"app": "compress-donors"}
    ),
    spec=client.V1PodSpec(
        restart_policy="Never",
        containers=[container]))
```
```
job = client.V1Job(
    api_version="batch/v1",
    kind="Job",
    metadata=client.V1ObjectMeta(
        name="compress-donors"
    ),
    spec=client.V1JobSpec(
        template=podTmpl,
        backoff_limit=2)
    )
```
```
config.load_incluster_config()
batch_v1 = client.BatchV1Api()
```
```
resp = batch_v1.create_namespaced_job(
    body=job,
    namespace="data")
```

```
completed = False
while completed == False:
    time.sleep(1)
    try:
        resp = batch_v1.read_namespaced_job_status(
            name="compress-donors",
            namespace="data", pretty=False)
    except ApiException as e:
        print(e.reason)
        break
    clear_output(True)
    print(resp.status)
    if resp.status.conditions is None:
        continue
    if len(resp.status.conditions) > 0:
        clear_output(True)
        print(resp.status.conditions)
        if resp.status.conditions[0].type == "Failed":
            print("FAILED -- Pod Log --")
            core_v1 = client.CoreV1Api()
            pod_resp = core_v1.list_namespaced_pod(
                namespace="data",
                label_selector="app=compress-donors",
                limit=1
            )
            log_resp = core_v1.read_namespaced_pod_log(
                name=pod_resp.items[0].metadata.name,
                namespace='data')
            print(log_resp)
        print("Removing Job...")
        resp = batch_v1.delete_namespaced_job(
            name="compress-donors",
            namespace="data",
            body=client.V1DeleteOptions(
                propagation_policy='Foreground',
                grace_period_seconds=5))
        break
```
Example Output:
```
[{'last_probe_time': datetime.datetime(2020, 12, 3, 9, 7, 13, tzinfo=tzlocal()),
 'last_transition_time': datetime.datetime(2020, 12, 3, 9, 7, 13, tzinfo=tzlocal()),
 'message': None,
 'reason': None,
 'status': 'True',
 'type': 'Complete'}]
Removing Job...
```

<img src="https://github.com/adavarski/k8s-UAP/blob/main/k8s/Demo2-DataProcessing-MinIO/pictures/MinIO-JupyterLab.png" width="800">


### k8s cronjob test (Object processing using k8s cronjob)
```
$ kubectl create -f cronjob/k8s-cronjob-compress.yaml
```

### Serverless Object Processing
TODO: Automating the processes developed using Serverless (Functions as a Service) : OpenFaaS function.


