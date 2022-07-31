#!/bin/bash

DATABASE_DIR=/var/lib/mysql/${MYSQL_DATABASE}

if [ ! -d "$DATABASE_DIR" ]; then

	# Launch mariadb server in background
	/usr/bin/mysqld_safe --datadir=/var/lib/mysql &

	# We check whether the server is available
	# The return status from mysqladmin is 0 if the server is running, 1 if it is not
	until mysqladmin ping 2> /dev/null; do
		sleep 2
	done

	# Connexion to the database:
	# We :	- create the database
	# 		- set the root password
	#		- disable remote access for root user and delete the empty user
	# 		- create a simple user and give him rights (use of '%' instead of 'localhost' to allow him remote-access)
	# 		- refresh the privileges

	mysql -u root << EOF

	CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

	DELETE FROM mysql.user WHERE user='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
	DELETE FROM mysql.user WHERE user='';

	CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

	FLUSH PRIVILEGES;

EOF

	# Shutdown the server because we need to restart it
	killall mysqld 2> /dev/null

fi

# We execute the CMD of the Dockerfile ["mysqld_safe"] --> relaunch the database
exec "$@"
