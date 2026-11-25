#VARIABLES

.DEFAULT_GOAL := all

COMPOSE_PATH := srcs/docker-compose.yml

#COLOURS

PDEL-OLM := \033[38;5;207m
DAXFERNA := \033[38;5;76m
ANTOFERN := \033[38;5;55m
CARMELAG := \033[38;5;30m

CROWN := \033[38;5;220m
RESET := \033[0m

#RULES

.PHONY: a all
a: all
all:
	docker compose -f $(COMPOSE_PATH) up --build -d
	@$(MAKE) msg_credits

.PHONY: u up
u: up
up:
	docker compose -f $(COMPOSE_PATH) up -d

.PHONY: d down
d: down
down:
	docker compose -f $(COMPOSE_PATH) down

.PHONY: c clean
c: clean
clean:
	-docker stop frontend backend db;
	-docker rm frontend backend db;
	-docker rmi -f nginx:alpine	node:24-alpine postgres:18-alpine srcs-api:latest srcs-nginx:latest;
	-docker network rm srcs_transcendence
	-docker system prune -af

.PHONY: r re
r: re
re: clean all

.PHONY: bf bash_frontend
bf: bash_frontend
bash_frontend:
	docker exec -it frontend bash

.PHONY: bd bash_db
bd: bash_db
bash_db:
	docker exec -it db bash

.PHONY: lf logs_frontend
lf: logs_frontend
logs_frontend:
	docker compose -f $(COMPOSE_PATH) logs nginx

.PHONY: ld logs_db
ld: logs_db
logs_db:
	docker compose -f $(COMPOSE_PATH) logs db

.PHONY: lb logs_backend
lb: logs_backend
logs_backend:
	docker compose -f $(COMPOSE_PATH) logs api

.PHONY: ps
ps:
	docker ps

.PHONY: msg_credits
msg_credits:
	@echo "$(CROWN)\n\
            ▟╗▟▙╖▙╖\n\
            ██████║\n\$(PDEL-OLM)\
██████╗ ████▇▇╗ ▇▇▇████╗██╗            ██████╗ ██╗     ███╗   ███╗\n\
██╔══██╗██╔══██╗██╔════╝██║           ██╔═══██╗██║     ████╗ ████║\n\
██████╔╝██║  ██║█████╗  ██║    █████╗ ██║   ██║██║     ██╔████╔██║\n\
██╔═══╝ ██║  ██║██╔══╝  ██║    ╚════╝ ██║   ██║██║     ██║╚██╔╝██║\n\
██║     ██████╔╝███████╗███████╗      ╚██████╔╝███████╗██║ ╚═╝ ██║\n\
╚═╝     ╚═════╝ ╚══════╝╚══════╝       ╚═════╝ ╚══════╝╚═╝     ╚═╝\n\
$(CROWN)\
                                           ▟╗▟▙╖▙╖\n\
                                           ██████║\n$(DAXFERNA)\
██████╗  █████╗ ██╗  ██╗███████╗███████╗███▇▇▇╗ ▇▇█╗   ██╗ █████╗ \n\
██╔══██╗██╔══██╗╚██╗██╔╝██╔════╝██╔════╝██╔══██╗████╗  ██║██╔══██╗\n\
██║  ██║███████║ ╚███╔╝ █████╗  █████╗  ██████╔╝██╔██╗ ██║███████║\n\
██║  ██║██╔══██║ ██╔██╗ ██╔══╝  ██╔══╝  ██╔══██╗██║╚██╗██║██╔══██║\n\
██████╔╝██║  ██║██╔╝╚██╗██║     ███████╗██║  ██║██║ ╚████║██║  ██║\n\
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝\n\
$(CROWN)\
                         ▟╗▟▙╖▙╖\n\
                         ██████║\n$(ANTOFERN)\
 █████╗ ███╗   ██╗███████▇▇ ▇▇▇▇██╗ ███████╗███████╗██████╗ ███╗   ██╗ \n\
██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗██╔════╝██╔════╝██╔══██╗████╗  ██║ \n\
███████║██╔██╗ ██║   ██║   ██║   ██║█████╗  █████╗  ██████╔╝██╔██╗ ██║ \n\
██╔══██║██║╚██╗██║   ██║   ██║   ██║██╔══╝  ██╔══╝  ██╔══██╗██║╚██╗██║ \n\
██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║     ███████╗██║  ██║██║ ╚████║ \n\
╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ \n\
$(CROWN)\
                                                        ▟╗▟▙╖▙╖\n\
                                                        ██████║\n$(CARMELAG)\
 ██████╗ █████╗ ██████╗ ███╗   ███╗███████╗██╗      ████▇╗  ▇▇▇███╗  \n\
██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║     ██╔══██╗██╔════╝  \n\
██║     ███████║██████╔╝██╔████╔██║█████╗  ██║     ███████║██║  ███╗ \n\
██║     ██╔══██║██╔══██╗██║╚██╔╝██║██╔══╝  ██║     ██╔══██║██║   ██║ \n\
╚██████╗██║  ██║██║  ██║██║ ╚═╝ ██║███████╗███████╗██║  ██║╚██████╔╝ \n\
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝  \n\
$(RESET)"
