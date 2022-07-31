DOCKER_COMPOSE_FILE	= srcs/docker-compose.yml

DATABASE_VOLUME		= /home/efrancon/data/mariadb_volume

WORDPRESS_VOLUME	= /home/efrancon/data/wordpress_volume

MKDIR				= mkdir -p

RM					= rm -rf

all:	up

up:
		sudo $(MKDIR) $(DATABASE_VOLUME)
		sudo $(MKDIR) $(WORDPRESS_VOLUME)
		docker-compose -f $(DOCKER_COMPOSE_FILE) up --build -d

down:
		docker-compose -f $(DOCKER_COMPOSE_FILE) down

stop:
		docker-compose -f $(DOCKER_COMPOSE_FILE) stop

logs:
		docker-compose -f $(DOCKER_COMPOSE_FILE) logs

clean:		down
		docker container prune --force

fclean:		clean
		sudo $(RM) $(DATABASE_VOLUME)
		sudo $(RM) $(WORDPRESS_VOLUME)
		docker system prune --all --force

re:			fclean all

.PHONY:		all volume up down clean fclean re

RESET		= \033[0m
RED			= \033[1;31m
GREEN		= \033[1;32m
YELLOW		= \033[1;33m
BLUE		= \033[1;34m
WHITE		= \033[1;37m
ORANGE		= \033[0;38;5;208m
UP			= \033[A
CUT			= \033[K
