NAME = inception

COMPOSE = docker-compose
COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

down:
	$(COMPOSE) -f $(COMPOSE_FILE) down

start:
	$(COMPOSE) -f $(COMPOSE_FILE) start

stop:
	$(COMPOSE) -f $(COMPOSE_FILE) stop

restart:
	$(COMPOSE) -f $(COMPOSE_FILE) restart

clean: down
	docker system prune -af

fclean: down
	docker system prune -af --volumes

re: fclean all

.PHONY: all up down start stop restart clean fclean re
