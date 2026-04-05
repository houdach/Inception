# inception — Docker Infrastructure from Scratch

*This project has been created as part of the 42 curriculum by hchouai.*

---

## Description

**inception** is a system administration project from the 42 Network curriculum. The objective is to build a complete and secure web infrastructure using **Docker** and **Docker Compose**, following strict rules regarding isolation, security, and service orchestration.

The project deploys a WordPress website using:
- **NGINX** as the single entry point, with TLS (HTTPS only, port 443)
- **WordPress** running with **PHP-FPM** (no embedded web server)
- **MariaDB** as the database backend
- **Redis** as an object cache layer (bonus)

Each service runs in its own container built from a custom Dockerfile — no pre-built images from Docker Hub. All containers communicate through a dedicated Docker bridge network.

### Architecture

```
Internet
    │
    ▼
[ nginx ] ← port 443 (HTTPS / TLSv1.2+)   ← only exposed service
    │
    ▼
[ wordpress ] :9000 (php-fpm)
    │           volume: /home/hchouai/data/wordpress
    ├──────────────────────────┐
    ▼                          ▼
[ mariadb ] :3306          [ redis ] :6379
volume: /home/hchouai/      object cache
data/mariadb                (bonus)
```

### Services

| Service | Role | Port |
|---|---|---|
| nginx | Reverse proxy, TLSv1.2/1.3, single entry point | 443 |
| wordpress | PHP-FPM CMS, no embedded web server | 9000 |
| mariadb | Relational database, persistent volume | 3306 |
| redis | WordPress object cache (bonus) | 6379 |

### Key constraints respected

- No `latest` tags — all images pinned to a stable base (Alpine / Debian)
- No pre-built service images — every container built from a custom `Dockerfile`
- Containers restart automatically on failure (`restart: unless-stopped`)
- Credentials passed via **Docker secrets**, never hardcoded or committed
- Persistent bind-mount volumes for database and WordPress files
- Custom bridge network — only nginx exposed to host

---

## Instructions

### Prerequisites

- Linux Virtual Machine (Debian recommended)
- Docker + Docker Compose
- GNU Make

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-plugin make
sudo usermod -aG docker $USER
# log out and back in after this
```

### Configuration

**`.env`** — located at `srcs/.env`, contains non-sensitive config:
- Domain name
- Database name and user
- Service hostnames

**`secrets/`** — contains sensitive credentials, never committed to Git:
```
secrets/
├── db_password
└── db_root_password
```
These are injected into containers at runtime via Docker secrets — not stored in Dockerfiles or environment variables.

### Build and Run

```bash
# Build and start all containers
make

# Stop containers
make down

# Full cleanup (containers + volumes + network)
make fclean
```

### Accessing the Site

Add the domain to your `/etc/hosts` first:
```bash
echo "127.0.0.1 hchouai.42.fr" | sudo tee -a /etc/hosts
```

| URL | Description |
|---|---|
| `https://hchouai.42.fr` | WordPress site |
| `https://hchouai.42.fr/wp-admin` | Admin panel |

Accept the self-signed certificate warning in your browser.

### Verifying the Stack

```bash
# Check running containers
docker ps

# Logs per service
docker logs nginx
docker logs wordpress
docker logs mariadb

# Inspect the internal network
docker network inspect inception

# Verify TLS
docker exec nginx openssl s_client -connect localhost:443 -tls1_3

# List volumes
docker volume ls
```

### Data Persistence

Persistent data is stored as bind-mount volumes on the host:

| Volume | Host path |
|---|---|
| MariaDB | `/home/hchouai/data/mariadb` |
| WordPress | `/home/hchouai/data/wordpress` |

Data survives container removal and rebuilds.

---

## Live Demo

👉 [Open interactive demo →](https://houdach.github.io/Inception/)

---

## Resources

### Docker & Infrastructure

- [Docker official documentation](https://docs.docker.com/)
- [docker-compose reference](https://docs.docker.com/compose/compose-file/)
- [Alpine Linux packages](https://pkgs.alpinelinux.org/)
- [nginx documentation](https://nginx.org/en/docs/)
- [PHP-FPM configuration guide](https://www.php.net/manual/en/install.fpm.configuration.php)
- [MariaDB Docker setup](https://mariadb.com/kb/en/installing-and-using-mariadb-via-docker/)
- [WP-CLI documentation](https://wp-cli.org/)
- [Redis object cache for WordPress](https://wordpress.org/plugins/redis-cache/)
- [Docker secrets documentation](https://docs.docker.com/engine/swarm/secrets/)

### TLS / SSL

- [OpenSSL self-signed certificate guide](https://www.openssl.org/docs/man1.1.1/man1/openssl-req.html)
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)

### AI Usage

AI tools were used during this project for:

- Clarifying nginx TLS configuration syntax and cipher suite selection
- Reviewing Dockerfile best practices (layer caching, non-root users, COPY vs ADD)
- Understanding Docker secrets injection patterns at container init
- Helping structure and review this README

All suggestions were reviewed and tested before use. Every Dockerfile and config file was written and understood line by line.
