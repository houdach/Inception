#!/bin/bash
set -e

# 1. Ensure the socket directory exists and has right permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql


if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "First run: Initializing MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Create temporary SQL file
    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then exit 1; fi

    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';
CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB_NAME};
CREATE USER IF NOT EXISTS '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';
GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${WORDPRESS_DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Run the bootstrap
    mysqld --user=mysql --bootstrap < $tfile
    rm -f $tfile
    echo "MariaDB initialization complete."
fi

# 3. Start MariaDB
echo "Starting MariaDB on port 3306..."
exec mysqld --user=mysql