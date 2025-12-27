#!/bin/bash
set -e

# 1. Wait for MariaDB (Sleep is okay, but a ping loop is better)
sleep 10

# 2. Extract passwords from secrets
DB_PASS=$(cat /run/secrets/db_password)
ADMIN_PASS=$(cat /run/secrets/db_root_password)

cd /var/www/html

# 3. Only run setup if WordPress isn't already configured
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    
    # Use WP-CLI instead of sed (It's much more robust)
    wp config create --allow-root \
        --dbname=$WORDPRESS_DB_NAME \
        --dbuser=$WORDPRESS_DB_USER \
        --dbpass="" \
        --dbhost=$WORDPRESS_DB_HOST

    echo "Installing WordPress core..."
    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user="hchouai" \
        --admin_password=$ADMIN_PASS \
        --admin_email="hdchouai@gmail.com"

    echo "Creating secondary user..."
    wp user create --allow-root \
        "user_inception" "user@42.fr" \
        --role=author \
        --user_pass="user123"
fi

# 4. Start PHP-FPM in foreground (MANDATORY for Docker)
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F