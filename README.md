## UAP : Universal Analytics Platform (k8s-based)

### Objectives: k8s-based Data-Driven Analytics/Data Science(ML/DeepML) PaaS/SaaS Platform for Data Analyst/Data Engineer/Data Scientist/DataOps/MLOps playground (R&D/MVP/POC/environmints)

### Used stacks and products:

VPN (WireGuard, k8s:Kilo); Monitoring stacks (Prometheus-based, TIG:Telegraf+InfluxDB+Grafana, Sensu, Zabbix); Indexing and Analytics/Debugging and Log management stacks (ELK/EFK); Pipeline: Messaging/Kafka stack (Kafka cluster, Zookeper cluster, Kafka Replicator, Kafka Connect, Schema Registry); Routing and Transformation (Serverless:OpenFaaS; ETL:Apache NiFi/Airflow); Data Lake/Big Data (MinIO s3-compatable Object Storage); DWHs (HIVE SQL-Engine with MinIO:s3, Presto SQL query engine with Hive/Cassandra/MySql/Postgres/etc. as data sources); Apache Spark for large-scale distributed Big Data processing and data analytics with Delta Lake (Lakehouse) and MinIO(S3); Machine Learning/Deep Learning/AutoML (TensorFlow, Pandas/Koalas, Keras, Scikit-learn, Spark MLlib, etc.; k8s:Model Development with AutoML: Kubeflow(MLflow, etc.) and k8s:AI Model Deployment (Seldon Core); Spark ML with S3(MinIO) as Data Source); GitLab/Jenkins/Jenkins X/Argo CD In-Platform CI/CD (GitOps); Identity and Access Management (IAM:Keycloak); JupyterHub/JupyterLab for data science; HashiCorp Vault cluster; k8s Persistent Volumes (Rook Ceph, Gluster); etc.

Summary: k8s-based Analytics/ML/DeepML SaaS using Big Data/Data Lake: MinIO (s3-compatable object storage) with Hive(s3) SQL-Engine/DWHs (instead of Snowflake as big data platform for example), Apache Spark(Hive for metadata)/Delta Lake(lakehouses)/Jupyter/etc. (instead of Databricks for example) + Kafka stack + ELK/EFK + Serverless(OpenFaaS) + ETL(Apache NiFi/Airflow) + ML/DeepML/AutoML + GitOps. 

<img src="https://github.com/adavarski/k8s-UAP/blob/main/k8s/003-pictures/saas-v4.0.0.png" width="900">

Note: For building Analytics/ML SaaS platform we can also use cloud-native SaaSs as reference (or build SaaS based on cloud-native SaaSs): Snowflake(SaaS/DWaaS) as big data solution on a single data platform (DWH, S3, etc.) + Databricks(cloud-based big data processing SaaS: unified analytics platform for ML & Data Science) + AWS S3/MKS/SQS/ELK/Lambda/etc.


### PaaS/SaaS MVP/POC/Development environments used:

- k8s: local (k3s, minikube, kubespray). Note: Default development environment: [k3s](https://github.com/adavarski/k8s-UAP/tree/main/k8s) 
- k8s: AWS: Default cloud k8s MVP/POC/Development environment using [KOPS](https://github.com/adavarski/k8s-UAP/tree/main/production-k8s/aws-k8s/KOPS) for k8s clusters deploy on AWS and k8s Operators/Helm Charts/YAML manifests for creating k8s deployments (PaaS/SaaS services). Note: Using managed k8s (different cloud providers) + terraform to create a k8s cluster: AWS:[EKS](https://github.com/adavarski/k8s-UAP/tree/main/production-k8s/aws-k8s/EKS), GCP:[GKE](https://github.com/adavarski/k8s-UAP/tree/main/production-k8s/gcp-k8s/GKE), Azure:[AKS](https://github.com/adavarski/k8s-UAP/tree/main/production-k8s/azure-k8s/AKS), OCI:[OKE](https://github.com/adavarski/k8s-UAP/tree/main/production-k8s/oci-k8s/OKE), DiritalOcean:[DOKS](https://github.com/adavarski/k8s-UAP/tree/main/production-k8s/digitalocean-k8s/DOKS)

### PaaS/SaaS objectives:

Platform as a Service (PaaS) will be data-driven and data-science platform allowing end user to develop, run, and manage applications without the complexity of building and maintaining the infrastructure.

Software as a Service (SaaS) will be "on-demand software", accessed/used by end users using a web browser.

### Productionalize PaaS/SaaS: k8s (KOPS, Rancher, managed k8s)

k8s-based data-driven Analytics/ML/DeepML SaaS platform provisioning/deploy : KOPS for k8s provisioning on AWS(default); Rancher (custom provisioning): k3s(for branches development)/RKE(for on-prem k8s) and Rancher(for the public clouds) with AWS EKS/Azure AKS/Google GKE; managed k8s on AWS/Azure/GCP/OCP/etc. k8s Operators/Helm Charts/YAML manifests for creating k8s deployments (PaaS/SaaS services).

### Playground:

- Demo_1: [DataProcessing: Serverless:OpenFaaS+ETL:Apache Nifi](https://github.com/adavarski/k8s-UAP/tree/main/k8s/Demo1-DataProcessing-Serverless-ETL/)
- Demo_2: [DataProcessing: MinIO](https://github.com/adavarski/k8s-UAP/tree/main/k8s/Demo2-DataProcessing-MinIO/)
- Demo_3: [AutoML: MLFlow+Seldon Core](https://github.com/adavarski/k8s-UAP/tree/main/k8s/Demo3-AutoML-MLFlow-SeldonCore/)
- Demo_4: [DeepML with TensorFlow 2.0](https://github.com/adavarski/k8s-UAP/tree/main/k8s/Demo4-DeepML-TensorFlow)
- Demo_5: [BigData: MinIO Data Lake with Hive/Presto SQL-Engines](https://github.com/adavarski/k8s-UAP/tree/main/k8s/Demo5-BigData-MinIO-Hive-Presto)
- Demo_6: [Spark with MinIO(S3) and Delta Lake for large-scale big data processing and ML](https://github.com/adavarski/k8s-UAP/tree/main/k8s/Demo6-Spark-ML)
- Demo_7: [SaaS deploy with IAM: Keycloak + JupyterHUB/JupyterLAB](https://github.com/adavarski/k8s-UAP/tree/main/k8s/Demo7-SaaS)
- Demo_8: [ML/DeepML for Cybersecurity ](https://github.com/adavarski/k8s-UAP/tree/main/k8s/Demo8-ML-Cybersecurity)
- Demo_9: [ML/DeepML with H2O](https://github.com/adavarski/k8s-UAP/tree/main/k8s/Demo9-H2O-ML)



