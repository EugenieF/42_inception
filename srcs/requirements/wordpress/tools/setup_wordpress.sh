#!/bin/bash

WP_CONFIG_FILE=/var/www/html/wp-config.php

# We check if WordPress is already installed
if [ ! -f "$WP_CONFIG_FILE" ]; then

	cd /var/www/html

	# We download WordPress with wp-cli (= wordpress command line interface)
	wp core download --allow-root

	# We wait for MariaDB to be fully installed
	until mysqladmin --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} --host=mariadb ping; do
		sleep 2
	done

	# We create a new wp-config.php file (= wordpress configuration file) with MYSQL_USER
	wp config create	--dbname=${MYSQL_DATABASE} \
						--dbuser=${MYSQL_USER} \
						--dbpass=${MYSQL_PASSWORD} \
						--dbhost=mariadb \
						--allow-root

	# We install WordPress with WORDPRESS_ADMIN_USER
	wp core install		--url=${DOMAIN_NAME} \
						--title=${WP_TITLE} \
						--admin_user=${WP_ADMIN} \
						--admin_password=${WP_ADMIN_PASSWORD} \
						--admin_email=${WP_ADMIN_EMAIL} \
						--skip-email \
						--allow-root

	# We create a wordpress simple user
	wp user create 		${WP_USER} ${WP_USER_EMAIL} \
						--user_pass=${WP_USER_PASSWORD} \
						--role=author \
						--allow-root

	# We install a theme
	wp theme install "inspiro" --activate --allow-root

	# We generate an article
	wp post generate --count=1 --post_author="efrancon" --post_title="Welcome to my project !" --allow-root

fi;

# We execute the CMD of the Dockerfile ["php-fpm7.3", "-F"] --> launch the php-fpm daemon
exec "$@"
