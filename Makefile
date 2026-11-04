#VARIABLES

DATA_PATH ?= $(HOME)/data/$(NAME)
# The bind driver needs an absolute path, so relative values like ./data are resolved here
override DATA_PATH := $(abspath $(DATA_PATH))
# docker compose reads it from the environment to fill ${DATA_PATH} in the compose file
export DATA_PATH

COMPOSE_FILE := srcs/docker-compose.yml
DOCKER_COMPOSE := docker compose -f $(COMPOSE_FILE)

# COLOURS
PDEL-OLM := \033[38;5;207m
DAXFERNA := \033[38;5;76m
PEPALOMA := \033[38;5;55m
CROWN    := \033[38;5;220m
RESET    := \033[0m

# ==============================================================================
# CORE TARGETS (42 Evaluation Standards)
# ==============================================================================

.PHONY: all dirs up down stop start restart clean fclean re status ps

# Default target: builds images if needed and runs containers in the background
all: dirs
	$(DOCKER_COMPOSE) up -d --build
	@$(MAKE) msg_credits

dirs:
	@echo "Creating data directory in $(DATA_PATH)..."
	@mkdir -p "$(DATA_PATH)/postgres"


# Start containers in detached mode without rebuilding
up: dirs
	$(DOCKER_COMPOSE) up -d

# Stop and remove containers and networks created by compose
down:
	$(DOCKER_COMPOSE) down

# Stop running containers without removing them
stop:
	$(DOCKER_COMPOSE) stop

# Start stopped containers
start:
	$(DOCKER_COMPOSE) start

# Restart containers
restart:
	$(DOCKER_COMPOSE) restart

# Clean: stops and removes project containers and networks
clean:
	$(DOCKER_COMPOSE) down --remove-orphans

# Fclean: complete project teardown (removes containers, networks, volumes, and images)
# Scoped strictly to this project so it won't affect other Docker projects on your machine
fclean:
	$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans

# Full rebuild
re: fclean all

# Display status of project containers
status ps:
	$(DOCKER_COMPOSE) ps

# ==============================================================================
# LOGS INSPECTION
# ==============================================================================

.PHONY: logs logs-api logs-frontend logs-nginx logs-db logs-adminer

# Stream logs of all services
logs:
	$(DOCKER_COMPOSE) logs -f

# Stream logs for individual services
logs-api:
	$(DOCKER_COMPOSE) logs -f api

logs-frontend:
	$(DOCKER_COMPOSE) logs -f frontend

logs-nginx:
	$(DOCKER_COMPOSE) logs -f nginx

logs-db:
	$(DOCKER_COMPOSE) logs -f db

logs-adminer:
	$(DOCKER_COMPOSE) logs -f adminer

# ==============================================================================
# INTERACTIVE SHELLS (Debugging)
# ==============================================================================

.PHONY: sh-api sh-frontend sh-nginx sh-db sh-adminer

# Shell into backend (Node Alpine uses sh)
sh-api:
	docker exec -it api sh

# Shell into frontend (Node Alpine uses sh)
sh-frontend:
	docker exec -it frontend sh

# Shell into Nginx
sh-nginx:
	docker exec -it nginx sh

# Shell into PostgreSQL database (Alpine uses sh)
sh-db:
	docker exec -it postgres sh

# Shell into Adminer
sh-adminer:
	docker exec -it adminer sh

# ==============================================================================
# TEAM CREDITS BANNER
# ==============================================================================

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
