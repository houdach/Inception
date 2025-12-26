#!/bin/sh
# Use set -x to see exactly which command fails in the logs
set -x

echo "Waiting for MariaDB at $WORDPRESS_DB_HOST..."

# Check connectivity without crashing the script
while true; do
    # Try to ping
    mariadb-admin ping -h"$WORDPRESS_DB_HOST" --silent
    
    # Check the exit code of the ping command
    # 0 = Success (Ready)
    # 1 = Access Denied (Also means it's Ready, just needs a password later)
    if [ $? -eq 0 ] || [ $? -eq 1 ]; then
        echo "MariaDB is alive and responding!"
        break
    fi

    echo "MariaDB not ready... sleeping 2s"
    sleep 2
done

echo "MariaDB is UP!"
sleep 5
# Move to the directory where WordPress is installed
cd /var/www/html

# Create wp-config.php if it doesn't exist
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create --allow-root \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$(cat $WORDPRESS_DB_PASSWORD_FILE)" \
        --dbhost="$WORDPRESS_DB_HOST"
fi

# Install WordPress if not installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WORDPRESS_ROOT_USER" \
        --admin_password="$(cat $MYSQL_ROOT_PASSWORD_FILE)" \
        --admin_email="hdchouai@gmail.com"

    echo "Creating secondary user..."
    wp user create --allow-root "editor_user" "editor@42.fr" \
        --role=author \
        --user_pass="$(cat $WORDPRESS_DB_PASSWORD_FILE)"
fi

echo "WordPress setup completed. Starting PHP-FPM..."
# Ensure runtime directory exists
mkdir -p /run/php

# Final check: start PHP-FPM in foreground
exec /usr/sbin/php-fpm8.2 -F