FROM debian:bookworm

RUN apt update && apt install -y \
    php-fpm \
    php-mysql \
    mariadb-client \
    iputils-ping \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html
RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf
RUN mkdir -p /run/php

COPY tools/wp-config.sh /usr/local/bin/wp-config.sh
RUN chmod +x /usr/local/bin/wp-config.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp-config.sh"]