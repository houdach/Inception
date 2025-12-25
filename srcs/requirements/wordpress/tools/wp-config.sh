#!/bin/sh
set -e

DB_HOST=${WORDPRESS_DB_HOST:-mariadb}
DB_PORT=${WORDPRESS_DB_PORT:-3306}
DB_NAME=${WORDPRESS_DB_NAME:-wordpress}
DB_USER=${WORDPRESS_DB_USER:-wpuser}
DB_PASSWORD=$(cat ${WORDPRESS_DB_PASSWORD_FILE})

MAX_RETRIES=30
COUNT=0

echo "Waiting for database $DB_HOST:$DB_PORT..."

until mysqladmin ping -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" --silent; do
    COUNT=$((COUNT + 1))
    if [ $COUNT -ge $MAX_RETRIES ]; then
        echo "Error: Database not ready after $MAX_RETRIES attempts."
        exit 1
    fi
    echo "Waiting for database... attempt $COUNT"
    sleep 2
done

echo "Database is ready!"

# Generate wp-config.php
WP_CONFIG_FILE=/var/www/html/wp-config.php
cat > "$WP_CONFIG_FILE" <<EOF
<?php
define('DB_NAME', '$DB_NAME');
define('DB_USER', '$DB_USER');
define('DB_PASSWORD', '$DB_PASSWORD');
define('DB_HOST', '$DB_HOST');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');
define('AUTH_KEY', '$(openssl rand -base64 32)');
define('SECURE_AUTH_KEY', '$(openssl rand -base64 32)');
define('LOGGED_IN_KEY', '$(openssl rand -base64 32)');
define('NONCE_KEY', '$(openssl rand -base64 32)');
define('AUTH_SALT', '$(openssl rand -base64 32)');
define('SECURE_AUTH_SALT', '$(openssl rand -base64 32)');
define('LOGGED_IN_SALT', '$(openssl rand -base64 32)');
define('NONCE_SALT', '$(openssl rand -base64 32)');
\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if (!defined('ABSPATH')) define('ABSPATH', __DIR__ . '/');
require_once ABSPATH . 'wp-settings.php';
EOF

chown www-data:www-data "$WP_CONFIG_FILE"

# Start PHP-FPM
exec /usr/sbin/php-fpm8.2 -F
