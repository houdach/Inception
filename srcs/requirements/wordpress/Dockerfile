FROM debian:bookworm

RUN apt update && apt install -y \
    php-fpm \
    php-mysql \
    mariadb-client \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set Workdir so files land in /var/www/html
WORKDIR /var/www/html

# Download WordPress into /var/www/html
RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

# Configure PHP-FPM
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf
RUN mkdir -p /run/php

COPY tools/wp-config.sh /usr/local/bin/wp-config.sh
RUN chmod +x /usr/local/bin/wp-config.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp-config.sh"]