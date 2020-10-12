#!/bin/bash
git clone https://github.com/KnowledgeHut-AWS/k8s-sandbox
cd k8s-sandbox
make cluster-up init install-cicd install-secrets
kubectl apply -f vault/sa.yaml
kubectl apply -f vault/crb.yaml
export VAULT_PORT=$(kubectl get svc vault-ui -n secrets -o json | jq '.spec.ports[0].nodePort')
export VAULT_ADDR=http://localhost:$VAULT_PORT
export VAULT_TOKEN=root

vault policy write dockerhub - <<EOF
path "secret/*" {
    capabilities = ["read", "list"]
}
EOF
export DOCKER_USER=$(head -n 1 dockerhub.txt)
export DOCKER_PASS=$(head -n 2 dockerhub.txt)
vault secrets enable -path="secret" kv
vault kv put secret/data/dockerhub username=$DOCKER_USER
vault kv put secret/data/dockerhub password=$DOCKER_PASS
vault policy write dockerhub vault/dockerhub-policy.hcl
export dokcerhub_toke=$(vault token create -policy="dockerhub")

kubectl create configmap config-artifact-pvc \
                         --from-literal=size=10Gi \
                         --from-literal=storageClassName=manual \
                         -o yaml -n tekton-pipelines \
                         --dry-run=client | kubectl replace -f -
kubectl apply -f secret.yaml -n tekton-pipelines
kubectl apply -f bucket.yaml -n tekton-pipelines
