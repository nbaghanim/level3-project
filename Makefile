init:
	git clone https://github.com/nbaghanim/k8s-sandbox.git
	cd k8s-sandbox && make up && make install-cicd && make install-ingress

logging:
	cd k8s-sandbox && make install-logging && cd ..

monitoring:
	cd k8s-sandbox && make install-monitoring && cd ..


secret-dockerhub:
	docker login
	kubectl create secret generic nbaghanim-docker-hub \
	 --from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json \
 	--type=kubernetes.io/dockerconfigjson -n test	


deploy-images:
	kubectl apply -f ./front-end/front-end-dep.yaml -n test
	kubectl apply -f ./front-end/front-end-ingress.yaml -n test
	kubectl apply -f ./front-end/front-end-svc.yaml -n test
	kubectl apply -f ./carts/carts-db-dep.yaml -n test
	kubectl apply -f ./carts/carts-db-svc.yaml -n test
	kubectl apply -f ./carts/carts-dep.yaml -n test
	kubectl apply -f ./carts/carts-svc.yaml -n test
	kubectl apply -f ./catalogue/catalogue-db-dep.yaml -n test
	kubectl apply -f ./catalogue/catalogue-db-svc.yaml -n test
	kubectl apply -f ./catalogue/catalogue-dep.yaml -n test
	kubectl apply -f ./catalogue/catalogue-svc.yaml -n test
	kubectl apply -f ./orders/orders-db-dep.yaml -n test
	kubectl apply -f ./orders/orders-db-svc.yaml -n test
	kubectl apply -f ./orders/orders-dep.yaml -n test
	kubectl apply -f ./orders/orders-svc.yaml -n test
	kubectl apply -f ./payment/payment-dep.yaml -n test
	kubectl apply -f ./payment/payment-svc.yaml -n test
	kubectl apply -f ./rabbitmq/rabbitmq-dep.yaml -n test
	kubectl apply -f ./rabbitmq/rabbitmq-svc.yaml -n test
	kubectl apply -f ./shipping/shipping-dep.yaml -n test
	kubectl apply -f ./shipping/shipping-svc.yaml -n test
	kubectl apply -f ./user/user-db-dep.yaml -n test
	kubectl apply -f ./user/user-db-svc.yaml -n test
	kubectl apply -f ./user/user-dep.yaml -n test
	kubectl apply -f ./user/user-svc.yaml -n test

build_deploy:
	kubectl create -f ./test-tekton/tasks/build-push-task.yaml -n test
	kubectl create -f ./test-tekton/tasks/deploy-task.yaml -n test
	kubectl create -f ./test-tekton/tasks/deploy-task-prod.yaml -n test
	kubectl create -f ./test-tekton/tasks/run-e2e.yaml -n test
	kubectl create -f ./test-tekton/tasks/wait-prods.yaml -n test

up: build run


build:
	docker build -t front-end ./front-end/
	docker build -t edge-router ./edge-router/
	docker build -t catalogue ./catalogue/
	docker build -t catalogue-db ./catalogue/docker/catalogue-db/
	docker build -t carts ./carts/
	docker build -t orders ./orders/
	docker build -t shipping ./shipping/
	docker build -t queue-master ./queue-master/
	docker build -t payment ./payment/
	docker build -t user ./user/
	docker build -t user-db ./user/docker/user-db/


down:
	docker rm -f front-end
	docker rm -f edge-router
	docker rm -f catalogue
	docker rm -f catalogue-db
	docker rm -f carts
	docker rm -f carts-db
	docker rm -f orders
	docker rm -f orders-db
	docker rm -f shipping
	docker rm -f queue-master
	docker rm -f rabbitmq
	docker rm -f payment
	docker rm -f user-db
	docker rm -f user
	docker network rm project
	

