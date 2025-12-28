User Documentation — Inception

This document explains how to use and interact with the Inception infrastructure as an end user or administrator.

1. Services Provided

This project deploys a Docker-based infrastructure composed of the following services:

NGINX
Acts as the single entry point of the infrastructure, serving HTTPS traffic on port 443 using TLSv1.2/TLSv1.3.

WordPress
PHP-based CMS running with php-fpm, without an embedded web server.

MariaDB
Database server used by WordPress, not exposed outside the Docker network.

Redis (Bonus)
Cache service used to improve WordPress performance.

All services communicate through a dedicated Docker network.

2. Starting and Stopping the Project
▶ Start the infrastructure
make

⏹ Stop the infrastructure
make down

🔄 Rebuild everything
make re

3. Accessing the Website and Admin Panel
🌐 Website

Open a browser and navigate to:

https://<login>.42.fr


Example:

https://wil.42.fr

🔐 WordPress Admin Panel
https://<login>.42.fr/wp-admin


Use the administrator credentials defined during the initial WordPress setup.

4. Credentials Management

Sensitive credentials are handled securely using Docker secrets.

Location on host:

secrets/


Files include:

db_password

db_root_password

These credentials:

Are not stored in Dockerfiles

Are not exposed in the Git repository

Are injected into containers at runtime

5. Checking Service Status
📦 Running containers
docker ps

📜 Logs
docker logs nginx
docker logs wordpress
docker logs mariadb

🌐 Network
docker network inspect inception


If all containers are running and the website is accessible via HTTPS, the stack is functioning correctly.