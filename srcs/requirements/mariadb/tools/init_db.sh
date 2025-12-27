#!/bin/bash
set -e

# Load secrets into local variables for clean expansion
ROOT_P=$(cat /run/secrets/db_root_password)
USER_P=$(cat /run/secrets/db_password)

# Prepare runtime directory
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Initialize database if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Use bootstrap to run SQL commands before server starts
mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${WORDPRESS_DB_NAME}\`;
CREATE USER IF NOT EXISTS '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '$USER_P';
GRANT ALL PRIVILEGES ON \`${WORDPRESS_DB_NAME}\`.* TO '${WORDPRESS_DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_P';
FLUSH PRIVILEGES;
EOF
    echo "MariaDB initialization complete."
fi

# Execute the main process in the foreground
exec mysqld --user=mysql --console 