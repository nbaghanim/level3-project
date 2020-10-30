#!/bin/bash
git clone https://github.com/nbaghanim/k8s-sandbox
cd k8s-sandbox
make cluster-up init install-cicd install-secrets
                         --from-literal=storageClassName=manual \
                         -o yaml -n tekton-pipelines \
                         --dry-run=client | kubectl replace -f -
kubectl apply -f secret.yaml -n tekton-pipelines
kubectl apply -f config-map.yaml -n tekton-pipelines
