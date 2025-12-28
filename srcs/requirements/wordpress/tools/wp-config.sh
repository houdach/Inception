#!/bin/bash
set -e

# 1. Wait for MariaDB (Sleep is okay, but a ping loop is better)
sleep 10


DB_PASS=$(cat /run/secrets/db_password)
ADMIN_PASS=$(cat /run/secrets/db_root_password)

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    
    wp config create --allow-root \
        --dbname=$WORDPRESS_DB_NAME \
        --dbuser=$WORDPRESS_DB_USER \
        --dbpass=$DB_PASS \
        --dbhost=$WORDPRESS_DB_HOST

    echo "Installing WordPress core..."
    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user="hchouai" \
        --admin_password=$ADMIN_PASS \
        --admin_email="hdchouai@gmail.com"
    
    echo "Checking for Redis connectivity..."

    COUNTER=0
    while ! ping -c 1 redis &>/dev/null; do
        echo "Waiting for redis network... ($COUNTER)"
        sleep 2
        COUNTER=$((COUNTER + 1))
        if [ $COUNTER -gt 15 ]; then
            echo "Redis timeout"
            exit 1
        fi
    done
    echo "Redis is up! Configuring..."
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root
    echo "Installing and activating theme..."
    wp theme install astra --activate --allow-root
    echo "Creating secondary user..."
    wp user create --allow-root \
        "user_inception" "user@42.fr" \
        --role=author \
        --user_pass="user123"

fi

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F
