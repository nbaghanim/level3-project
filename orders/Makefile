build:
	DOCKER_BUILDKIT=1 docker build --progress=plain --tag orders .

run:
	docker run -it --rm orders

localtest:
	docker run -it --rm -d -p 8029:80 orders
