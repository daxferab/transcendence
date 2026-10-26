#VARIABLES

.DEFAULT_GOAL := all

COMPOSE_PATH := srcs/docker-compose.yml

#COLOURS

PDEL-OLM := \033[38;5;207m
DAXFERNA := \033[38;5;76m
PEPALOMA := \033[38;5;55m

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
	-docker stop $$(docker ps -qa);
	-docker rm $$(docker ps -qa);
	-docker rmi -f $$(docker images -qa);
	-docker volume rm $$(docker volume ls -q);
	-docker network rm $$(docker network ls -q) 2> /dev/null
	-docker system prune -af

.PHONY: bn bash_nginx
bn: bash_nginx
bash_nginx:
	docker exec -it nginx bash

.PHONY: bp bash_postgres
bp: bash_postgres
bash_postgres:
	docker exec -it postgres bash

.PHONY: ln logs_nginx
ln: logs_nginx
logs_nginx:
	docker compose -f $(COMPOSE_PATH) logs nginx

.PHONY: lp logs_postgres
lp: logs_postgres
logs_postgres:
	docker compose -f $(COMPOSE_PATH) logs postgres

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
                           ██████║\n$(PEPALOMA)\
██████╗ ███████╗██████╗  ██▇▇▇╗ ▇▇╗      ██████╗ ███╗   ███╗ █████╗ \n\
██╔══██╗██╔════╝██╔══██╗██╔══██╗██║     ██╔═══██╗████╗ ████║██╔══██╗\n\
██████╔╝█████╗  ██████╔╝███████║██║     ██║   ██║██╔████╔██║███████║\n\
██╔═══╝ ██╔══╝  ██╔═══╝ ██╔══██║██║     ██║   ██║██║╚██╔╝██║██╔══██║\n\
██║     ███████╗██║     ██║  ██║███████╗╚██████╔╝██║ ╚═╝ ██║██║  ██║\n\
╚═╝     ╚══════╝╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝\n\
$(RESET)"
