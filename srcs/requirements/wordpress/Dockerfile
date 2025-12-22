FROM debian:bookworm

# Install PHP & extensions
RUN apt update && apt install -y \
    php-fpm php-mysql php-cli php-mbstring php-xml php-gd unzip curl \
    && rm -rf /var/lib/apt/lists/*

# Copy any tools (optional for now)
COPY tools/ /tools/

# Expose PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm7.4", "-F"]
