
up: testEnv secret-dockerhub install-ingress pipeline pipelineRun apply-roles apply-tasks namespace

testEnv:
	kubectl config set-context --current --namespace=tekton-pipelines

secret-dockerhub:
	docker login
	kubectl create secret generic nbaghanim-docker-hub \
	 --from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json \
 	--type=kubernetes.io/dockerconfigjson -n test	

logging: 
	./elf/elf.sh

monitoring:
	./grafana/pro.graf.sh

pipeline:
	kubectl create -f ./pipelines/

pipelineRun:
	kubectl create -f ./pipelinerun/

resource:
	kubectl create -f ./PipelineResource/ -n test

apply-roles:
	kubectl apply -f ./role/
	
apply-tasks:
	kubectl apply -f ./tekton-microservices/carts/ -n test
	kubectl apply -f ./tekton-microservices/catalogue/ -n test
	kubectl apply -f ./tekton-microservices/e2e-js-test/ -n test
	kubectl apply -f ./tekton-microservices/e2e-tests/ -n test
	kubectl apply -f ./tekton-microservices/edge-router/ -n test
	kubectl apply -f ./tekton-microservices/front-end/ -n test
	kubectl apply -f ./tekton-microservices/load-test/ -n test
	kubectl apply -f ./tekton-microservices/orders/ -n test
	kubectl apply -f ./tekton-microservices/payment/ -n test
	kubectl apply -f ./tekton-microservices/shipping/ -n test
	kubectl apply -f ./tekton-microservices/user/ -n test
	kubectl apply -f ./tekton-microservices/queue-master/ -n test

delete-tasks:
	
	kubectl delete -f ./tekton-microservices/carts/ -n test
	kubectl delete -f ./tekton-microservices/catalogue/ -n test
	kubectl delete -f ./tekton-microservices/e2e-js-test/ -n test
	kubectl delete -f ./tekton-microservices/e2e-test/ -n test
	kubectl delete -f ./tekton-microservices/edge-router/ -n test
	kubectl delete -f ./tekton-microservices/front-end/ -n test
	kubectl delete -f ./tekton-microservices/load-test/ -n test
	kubectl delete -f ./tekton-microservices/orders/ -n test
	kubectl delete -f ./tekton-microservices/payment/ -n test
	kubectl delete -f ./tekton-microservices/shipping/ -n test
	kubectl delete -f ./tekton-microservices/user/ -n test
	kubectl delete -f ./tekton-microservices/queue-master/ -n test
	kubectl delete -f ./tekton-microservices/queue-master/ -n tes
	

namespace:
	kubectl create namespace test
	kubectl create namespace production

logs: 
	tkn pr logs --last

install-ingress:
	echo "Ingress: install" | tee -a output.log
	kubectl apply -n ingress-nginx -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml | tee -a output.log
	kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s

delete-ingress:
	 echo "Ingress: delete" | tee -a output.log
	 kubectl delete -n ingress -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml | tee -a output.log 2>/dev/null | true


test:
	kubectl create secret generic nbaghanim-docker-hub \
        --from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json \
        --type=kubernetes.io/dockerconfigjson -n test
	kubectl apply -f tests/roles -n test
	kubectl create -f tests/task-run-test.yaml -n test
	kubectl create -f tests/task-build-push.yaml -n test
	kubectl create -f tests/pipeline-run-test.yaml -n test
	kubectl create -f tests/pipeline-run-test-without-yaml.yaml -n test
	
test-run:
	kubectl create -f tests/pipeline-run-test-without-yaml.yaml -n test
