FROM debian:bookworm

RUN apt update && apt install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 3306

CMD ["mysqld_safe"]
