COMPOSE_PATH := srcs/docker-compose.yml

all:
	docker compose -f $(COMPOSE_PATH) up --build -d

up:
	docker compose -f $(COMPOSE_PATH) up -d

down:
	docker compose -f $(COMPOSE_PATH) down

clean:
	-docker stop $$(docker ps -qa);
	-docker rm $$(docker ps -qa);
	-docker rmi -f $$(docker images -qa);
	-docker volume rm $$(docker volume ls -q);
	-docker network rm $$(docker network ls -q) 2> /dev/null
	-docker system prune -af