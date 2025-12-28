Developer Documentation — Inception

This document explains how a developer can set up, build, and maintain the Inception infrastructure.

1. Environment Setup
🖥 System Requirements

Linux Virtual Machine (Debian recommended)

Docker & Docker Compose

GNU Make

Install required tools:

sudo apt update
sudo apt install -y docker.io docker-compose-plugin make
sudo usermod -aG docker $USER


Log out and log back in after installation.

2. Configuration Files
.env

Location:

srcs/.env


Contains non-sensitive configuration such as:

Domain name

Database name

Database user

Service hostnames

Secrets

Location:

secrets/


Contains sensitive credentials:

Database password

Database root password

Used through Docker secrets, never hardcoded.

3. Build and Launch
▶ Build and run containers
make

⏹ Stop containers
make down

🧹 Full cleanup
make fclean

4. Container and Volume Management
📦 Containers
docker ps
docker logs <container_name>

💾 Volumes
docker volume ls

5. Data Persistence

Persistent data is stored on the host using bind-mounted volumes:

MariaDB

/home/<login>/data/mariadb


WordPress

/home/<login>/data/wordpress


Data remains available even after container removal.

6. Architecture Overview

One container per service

Custom Dockerfile for each service

Dedicated Docker network

NGINX is the only exposed service (port 443)

Automatic container restart on failure

No forbidden options (latest, network: host, infinite loops)

7. Bonus Service

Redis is implemented as an additional service:

Runs in its own container

Connected through the internal Docker network

Used to improve WordPress caching

8. Summary

This project complies with all Inception requirements:

Secure secret management

Persistent volumes

Clean Docker architecture

Full reproducibility on any Linux VM