build:
	DOCKER_BUILDKIT=1 docker build --progress=plain --tag load .

run:
	docker run -it --rm -d load

test:
	curl localhost:8089/health | jq
