#!/bin/sh

DB_HOST=${WORDPRESS_DB_HOST:-mariadb}
DB_PORT=${WORDPRESS_DB_PORT:-3306}
DB_NAME=${WORDPRESS_DB_NAME:-wordpress}
DB_USER=${WORDPRESS_DB_USER:-wpuser}
DB_PASSWORD=$(cat ${WORDPRESS_DB_PASSWORD_FILE})

MAX_RETRIES=30
COUNT=0

echo "Waiting for database $DB_HOST:$DB_PORT..."

until mysqladmin ping -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" --silent; do
  COUNT=$((COUNT+1))
  if [ $COUNT -ge $MAX_RETRIES ]; then
    echo "Error: Database not ready after $MAX_RETRIES attempts."
    exit 1
  fi
  echo "Waiting for database... attempt $COUNT"
  sleep 2
done

echo "Database is ready! Starting PHP-FPM..."

exec /usr/sbin/php-fpm8.2 -F
