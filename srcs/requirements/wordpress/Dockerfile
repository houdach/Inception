FROM debian:bookworm

# Install PHP-FPM, extensions, MySQL client, curl, unzip
RUN apt update && apt install -y \
    php-fpm \
    php-mysql \
    mariadb-client \
    php-gd \
    php-cli \
    iputils-ping \
    php-curl \
    php-zip \
    php-xml \
    php-mbstring \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*
# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
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
