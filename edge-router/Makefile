build:
	docker build -t edge .

run:
	docker run -it --rm -d -p 8044:80 edge

test:
	curl localhost:8044/health | jq
