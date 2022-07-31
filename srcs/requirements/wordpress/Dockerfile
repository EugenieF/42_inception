FROM debian:buster

RUN	apt-get update && \
	apt-get install -y	\
	curl \
	# To be able to use mysqladmin:
	mariadb-client \
	# Installation of required php extensions for WordPress:
	php7.3 \
	# php7.3-cli php7.3-common php7.3-opcache php7.3-json are automatically installed:
	php7.3-fpm \
	# Performs remote request operations:
	php7.3-curl \
	# Connects to MySQL for database interactions:
	php7.3-mysql \
	# Used to properly handle UTF 8 text:
	php7.3-mbstring \
	# Used for XML parsing:
	php7.3-xml \
	# Used for decompressing Plugins, Themes, and WordPress update packages:
	php7.3-zip \
	# To work on images and resize images:
	php7.3-gd \
	# Provides a module for PHP applications that use IMAP:
	php7.3-imap

# Creation of the folders to enable wordpress and php start 
RUN	mkdir -p /var/www/html ; mkdir -p /run/php

# Installation of WP-CLI = WordPress command line interface
RUN	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# PHP-FPM configuration is done in the file www.conf
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# WordPress installation script is imported in /usr/local/bin to be executed as entrypoint
COPY ./tools/setup_wordpress.sh /usr/local/bin/

# Serves only as documentation here
EXPOSE 9000

ENTRYPOINT ["setup_wordpress.sh"]

# Command launched at the end of the setup
CMD ["php-fpm7.3", "-F"]

# php-fpm7.3 [--help]
# -F, --nodaemonize 			: force to stay in foreground and ignore daemonize option from config file
# -R, --allow-to-run-as-root	: Allow pool to run as root (disabled by default)
