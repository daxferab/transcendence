NGNX-IMAGE = nginx-image
NGNX-CONTAINER = nginx-container
NGNX-DOCKERFILE = nginx/Dockerfile

all:
	docker build -f $(NGNX-DOCKERFILE) -t $(NGNX-IMAGE) .
	docker run -d --name $(NGNX-CONTAINER) -p 8080:80 -v $(shell pwd)/src:/usr/share/nginx/html $(NGNX-IMAGE)

clean:
	docker container stop $(NGNX-CONTAINER)
	docker container remove $(NGNX-CONTAINER)
	docker image rm $(NGNX-IMAGE)
