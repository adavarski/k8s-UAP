
```
kubectl apply -f ./003-data/50000-h2o/40-h2o-statefulset.yaml
kubectl apply -f ./003-data/50000-h2o/50-h2o-headless-service.yaml
kubectl apply -f ./003-data//50000-h2o/60-h2o-ingress.yaml
```

Example H2O AutoML jupyter notebook: https://github.com/adavarski/k8s-UAP/blob/main/k8s/Demo9-H2O-ML/notebooks/h2o-automl.ipynb (based on: https://github.com/adavarski/k8s-UAP/blob/main/k8s/Demo9-H2O-ML/notebooks/Coursera-examples/h2o-AutoML-example.ipynb)

Notebook:
```

pip install requests 
pip install tabulate 
pip install "colorama>=0.3.8" 
pip install future 
pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o
```

TBD: Dockerfile: 
```
RUN pip install requests \
&& pip install tabulate \
&& pip install "colorama>=0.3.8" \
&& pip install future \
&& pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o
```
