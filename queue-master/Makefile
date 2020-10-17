build:
	DOCKER_BUILDKIT=1 docker build --progress=plain --tag qmaster .

run:
	docker run -it --rm -d -p 8045:80 qmaster

test:
	curl localhost:8045/health | jq
