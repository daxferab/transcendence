#VARIABLES

.DEFAULT_GOAL := all

COMPOSE_PATH := srcs/docker-compose.yml
PROJECT_NAME := transcendence

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

.PHONY: b build
b: build
build:
	docker compose -f $(COMPOSE_PATH) build

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
	-docker compose -f $(COMPOSE_PATH) down -v --remove-orphans
	-docker volume rm $(PROJECT_NAME)_pgdata 2>/dev/null
	-docker network rm $(PROJECT_NAME)_transcendence_net 2>/dev/null
	-docker rmi -f $(PROJECT_NAME)-api:latest $(PROJECT_NAME)-nginx:latest 2>/dev/null

.PHONY: r re
r: re
re: clean all

.PHONY: bf bash_frontend
bf: bash_frontend
bash_frontend:
	docker exec -it transcendence_frontend bash

.PHONY: bd bash_db
bd: bash_db
bash_db:
	docker exec -it transcendence_db bash

.PHONY: psq
psq:
	docker exec -it transcendence_db psql -U $(shell grep POSTGRES_USER .env | cut -d= -f2 | tr -d '"') -d $(shell grep POSTGRES_DB .env | cut -d= -f2 | tr -d '"')

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

.PHONY: mkcert
mkcert:
	mkdir -p srcs/infra/nginx/ssl
	mkcert -install
	mkcert localhost 127.0.0.1
	mv localhost+1-key.pem localhost+1.pem srcs/infra/nginx/ssl

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
