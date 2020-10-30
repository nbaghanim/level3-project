up: namespace testEnv secret-docker roles tasks pipeline pipelineRun

testEnv:
	kubectl config set-context --current --namespace=test

secret-docker-hub: 		
	 docker login
        kubectl create secret generic nbaghanim-docker-hub \
         --from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json \
        --type=kubernetes.io/dockerconfigjson -n test   



roles:
	kubectl apply -f ./roles/ 
	kubectl apply -f ./roles/ -n production
tasks:
	kubectl create -f ./tasks/

taskrun: 
	kubectl create -f ./taskrun/

pipeline:
	kubectl create -f ./pipelines/

pipelineRun:
	kubectl create -f ./pipelinerun/

namespace:
	kubectl create namespace test
	kubectl create namespace production

down: delete-namespaces

delete-namespaces:	
	kubectl config set-context --current --namespace=default
	kubectl delete namespace test
	kubectl	delete namespace production

delete-tasks:
	tkn t delete $$(tkn t ls -n tekton-pipelines | cut -d ' ' -f 1 | tail -n +2) -n test || true

delete-pipelines:
	tkn p delete $$(tkn p ls -n tekton-pipelines | cut -d ' ' -f 1 | tail -n +2) -n test || true

delete-taskrunners:
	tkn tr delete $$(tkn tr ls -n tekton-pipelines | cut -d ' ' -f 1 | tail -n +2) -n test || true

delete-pipelinerunners:
	tkn pr delete $$(tkn pr ls -n tekton-pipelines | cut -d ' ' -f 1 | tail -n +2) -n test || true

delete-secret:
	kubectl delete secrets omar-docker-hub-creds -n tekton-pipelines

logs:
	tkn pr logs --last

install-ingress:
	echo "Ingress: install" | tee -a output.log
	kubectl apply -n ingress-nginx -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml | tee -a output.log
	kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s

delete-ingress:
	echo "Ingress: delete" | tee -a output.log
	kubectl delete -n ingress -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml | tee -a output.log 2>/dev/null | true

checkStatus:
	#./run.sh
	echo "waiting for the pods to be readey"
	./run1.sh

test:
	kubectl create secret generic nbaghanim-docker-hub-creds \
        --from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json \
        --type=kubernetes.io/dockerconfigjson -n test
	kubectl apply -f tests/roles -n test
	kubectl create -f tests/task-run-test.yaml -n test
	kubectl create -f tests/task-build-push.yaml -n test
	kubectl create -f tests/pipeline-run-test.yaml -n test
	kubectl create -f tests/pipeline-run-test-without-yaml.yaml -n test

deploy:
	kubectl create namespace production

test-run:
	kubectl create -f tests/pipeline-run-test-without-yaml.yaml -n test
