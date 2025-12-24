FROM debian:bookworm

# Install PHP-FPM, extensions, MySQL client, curl, unzip
RUN apt update && apt install -y \
    php-fpm \
    php-mysql \
    php-gd \
    php-cli \
    php-curl \
    php-zip \
    php-xml \
    php-mbstring \
    mariadb-client \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM to listen on 0.0.0.0:9000
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf

# Create PHP runtime folder
RUN mkdir -p /run/php

WORKDIR /var/www/html

# Download WordPress
RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

# Copy wp-config script
COPY tools/wp-config.sh /usr/local/bin/wp-config.sh
RUN chmod +x /usr/local/bin/wp-config.sh

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp-config.sh"]
