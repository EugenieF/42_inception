FROM debian:buster

RUN	apt-get update && \
	apt-get install -y \
	mariadb-server \
	mariadb-client

# Create MySQL service directory
RUN	mkdir -p /run/mysqld /var/lib/mysql && \
# Give MySQL user and group permission to work with the created directory
	chown -R mysql:mysql /run/mysqld /var/lib/mysql

# mysql_install_db inits the database and creates a 'root@localhost' account with no initial password set
RUN	mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal --skip-test-db

# We enable remote-access to the database in the configuration file my.cnf
COPY ./conf/my.cnf /etc/mysql/my.cnf
# equivalent to the command --> RUN sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# MariaDB installation script is imported in /usr/local/bin to be executed as entrypoint
COPY ./tools/setup_mariadb.sh /usr/local/bin/

# Serves only as documentation here
EXPOSE 3306

ENTRYPOINT ["setup_mariadb.sh"]

# Command launched at the end of the setup
CMD ["/usr/bin/mysqld_safe", "--datadir=/var/lib/mysql"]
