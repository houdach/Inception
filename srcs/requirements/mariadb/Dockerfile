FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

VOLUME /var/lib/mysql

COPY tools/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh


EXPOSE 3306
ENTRYPOINT ["/usr/local/bin/init_db.sh"]
