all:
	@mkdir -p /Users/mac/data/mariadb
	@mkdir -p /Users/mac/data/wordpress
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker system prune -af

fclean: clean
	@sudo rm -rf /Users/mac/data
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

re: fclean all