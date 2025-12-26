*This project has been created as part of the 42 curriculum by hchouai.*

# Inception

## Description

Inception is a system administration project from the 42 curriculum.  
The objective is to build a complete and secure web infrastructure using **Docker** and **Docker Compose**, following strict rules regarding isolation, security, and service orchestration.

The project deploys a WordPress website using:
- **NGINX** as a web server with TLS (HTTPS only)
- **WordPress** running with **PHP-FPM**
- **MariaDB** as the database

Each service runs inside its own Docker container and communicates through a dedicated Docker network.

## Project Overview

The stack is composed of:
- A custom **NGINX** image exposing only port **443**
- A **WordPress** container using PHP-FPM
- A **MariaDB** container for data storage
- **Docker secrets** for secure credentials handling
- **Docker volumes** for data persistence
- A custom **Docker bridge network**

No pre-built images (such as official WordPress or MariaDB images) are used.

## Instructions

### Prerequisites
- Docker
- Docker Compose
- GNU Make

### Build and Run the Project
From the root of the repository:

```bash
make
