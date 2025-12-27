#!/bin/sh
set -x

# Wait for MariaDB port 3306 to be open 
until mariadb-admin ping -h"$WORDPRESS_DB_HOST" --protocol=tcp --silent; do
    echo "Waiting for MariaDB connection..."
    sleep 2
done

# Extra safety: Give MariaDB time to finish privilege setup
sleep 5

cd /var/www/html

# Create wp-config.php if it doesn't exist
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create --allow-root \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$(cat /run/secrets/db_password)" \
        --dbhost="$WORDPRESS_DB_HOST"
fi

# Run the installation (Removes the Installation Page)
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WORDPRESS_ROOT_USER" \
        --admin_password="$(cat /run/secrets/db_root_password)" \
        --admin_email="hdchouai@gmail.com"

    echo "Creating secondary user..."
    wp user create --allow-root "editor_user" "editor@42.fr" \
        --role=author --user_pass="$(cat /run/secrets/db_password)"
fi

echo "WordPress setup complete. Starting PHP-FPM..."
mkdir -p /run/php
exec /usr/sbin/php-fpm8.2 -F