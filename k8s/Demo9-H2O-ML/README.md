### Jupyter environment

Build custom JupyterLab docker image and pushing it into DockerHub container registry.
```
$ cd ./jupyterlab
$ docker build -t jupyterlab-h2o .
$ docker tag jupyterlab-h2o:latest davarski/jupyterlab-h2o:latest
$ docker login 
$ docker push davarski/jupyterlab-h2o:latest

```
Run Jupyter Notebook inside k8s as pod:
```
$ cd ./k8s/
$ sudo k3s crictl pull davarski/jupyterlab-h2o:latest
$ kubectl apply -f jupyter-notebook.pod.yaml -f jupyter-notebook.svc.yaml -f jupyter-notebook.ingress.yaml

```
Once the Pod is running, copy the generated token from the pod output logs.
```
$ kubectl logs jupyter-notebook
[I 06:44:51.680 LabApp] Writing notebook server cookie secret to /home/jovyan/.local/share/jupyter/runtime/notebook_cookie_secret
[I 06:44:51.904 LabApp] Loading IPython parallel extension
[I 06:44:51.916 LabApp] JupyterLab extension loaded from /opt/conda/lib/python3.7/site-packages/jupyterlab
[I 06:44:51.916 LabApp] JupyterLab application directory is /opt/conda/share/jupyter/lab
[W 06:44:51.920 LabApp] JupyterLab server extension not enabled, manually loading...
[I 06:44:51.929 LabApp] JupyterLab extension loaded from /opt/conda/lib/python3.7/site-packages/jupyterlab
[I 06:44:51.929 LabApp] JupyterLab application directory is /opt/conda/share/jupyter/lab
[I 06:44:51.930 LabApp] Serving notebooks from local directory: /home/jovyan
[I 06:44:51.930 LabApp] The Jupyter Notebook is running at:
[I 06:44:51.930 LabApp] http://(jupyter-notebook or 127.0.0.1):8888/?token=1efac938a73ef297729290af9b301e92755f5ffd7c72bbf8
[I 06:44:51.930 LabApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 06:44:51.933 LabApp] 
    
    To access the notebook, open this file in a browser:
        file:///home/jovyan/.local/share/jupyter/runtime/nbserver-1-open.html
    Or copy and paste one of these URLs:
        http://(jupyter-notebook or 127.0.0.1):8888/?token=1efac938a73ef297729290af9b301e92755f5ffd7c72bbf8
```
Browse to http://jupyter.data.davar.com/lab 

Note: Jupyter Notebooks are a browser-based (or web-based) IDE (integrated development environments)


### Deploy H2O cluster
```
kubectl apply -f ./k8s/k8s-h2o/40-h2o-statefulset.yaml
kubectl apply -f ./k8s/k8s-h2o/50-h2o-headless-service.yaml
kubectl apply -f ./k8s/k8s-h2o/60-h2o-ingress.yaml
```

Example H2O AutoML jupyter notebook: https://github.com/adavarski/k8s-UAP/blob/main/k8s/Demo9-H2O-ML/notebooks/h2o-automl.ipynb (based on: https://github.com/adavarski/k8s-UAP/blob/main/k8s/Demo9-H2O-ML/notebooks/Coursera-examples/h2o-AutoML-example.ipynb)


[Coursera-examples](https://github.com/adavarski/h2o-jupyter-docker/tree/main/notebooks)
