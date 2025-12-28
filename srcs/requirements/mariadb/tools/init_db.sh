#!/bin/bash
set -e
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

DB_PASS=$(cat $WORDPRESS_DB_PASSWORD_FILE)

service mariadb start
sleep 3
mysql -u root -e "CREATE USER IF NOT EXISTS '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"

mysql -u root -e "CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME;"

mysql -u root -e "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* to '$WORDPRESS_DB_USER'@'%';"

mysql -u root -e "FLUSH PRIVILEGES;"
service mariadb stop

exec mysqld_safe
