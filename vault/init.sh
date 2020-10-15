#!/bin/bash
kubectl apply -f sa.yaml
kubectl apply -f crb.yaml

export VAULT_SA_NAME=$(kubectl get sa vault-auth -n vault -o jsonpath="{.secrets[*]['name']}")
export SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME -n vault -o jsonpath="{.data.token}" | base64 --decode; echo)
 Set SA_CA_CRT to the PEM encoded CA cert used to talk to Kubernetes API
export SA_CA_CRT=$(kubectl get secret $VAULT_SA_NAME -n vault -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)
export K8S_HOST="https://kubernetes.default.svc:443"
export VAULT_PORT=$(kubectl get svc vault-ui -n secrets -o json | jq '.spec.ports[0].nodePort')
export VAULT_ADDR=http://localhost:$VAULT_PORT
export VAULT_TOKEN=root

vault auth enable kubernetes 2> /dev/null

vault write auth/kubernetes/config \
        token_reviewer_jwt="$SA_JWT_TOKEN" \
        kubernetes_host="$K8S_HOST" \
        kubernetes_ca_cert="$SA_CA_CRT"

vault policy write dockerhub - <<EOF
path "secret/data/dockerhub/*" {
    capabilities = ["read", "list"]
}
EOF

vault write auth/kubernetes/role/myapprole \
        bound_service_account_names=vault-auth \
        bound_service_account_namespaces=vault \
        policies=dockerhub \
        ttl=24h


export DOCKER_USER=$(head -n 1 dockerhub.txt)
export DOCKER_PASS=$(head -n 2 dockerhub.txt)
vault kv put secret/dockerhub/config username=$DOCKER_USER \
        password=$DOCKER_PASS \
        ttl=1h


export dokcerhub_token=$(vault token create -policy="dockerhub")
