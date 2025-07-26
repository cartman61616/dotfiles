# Docker Environment Configuration

This directory contains template environment files for Docker services. 

## 🔒 Security Notice

The `.env.example` files are safe templates. **Never commit actual `.env` files to Git** as they contain sensitive information like passwords and API keys.

## 📁 File Structure

```
docker/
├── authentik/
│   └── .env.example    # Template for Authentik configuration
├── monitoring/
│   └── .env.example    # Template for monitoring stack
├── nextcloud/
│   └── .env.example    # Template for Nextcloud configuration
├── traefik/
│   └── .env.example    # Template for Traefik configuration
└── README.md           # This file
```

## 🚀 Setup Instructions

1. **Copy templates to actual environment files:**
   ```bash
   for dir in docker/*/; do
     if [ -f "$dir/.env.example" ]; then
       cp "$dir/.env.example" "$dir/.env.local"
     fi
   done
   ```

2. **Edit each `.env.local` file and replace placeholders:**
   - Replace `REPLACE_WITH_YOUR_SECURE_VALUE` with actual values
   - Generate secure passwords: `openssl rand -base64 32`
   - Generate htpasswd hashes: `htpasswd -nb username password`

3. **Create symlinks in docker-stack directory:**
   ```bash
   # From the docker-stack directory
   ln -sf ~/dotfiles/docker/authentik/.env.local authentik/.env
   ln -sf ~/dotfiles/docker/monitoring/.env.local monitoring/.env
   ln -sf ~/dotfiles/docker/nextcloud/.env.local nextcloud/.env
   ln -sf ~/dotfiles/docker/traefik/.env.local traefik/.env
   ```

## 🔑 Required Variables

### Authentik (`authentik/.env.local`)
- `PG_PASS` - PostgreSQL password
- `AUTHENTIK_SECRET_KEY` - Application secret key
- `REDIS_PASS` - Redis password
- `DOMAIN` - Your domain name

### Monitoring (`monitoring/.env.local`)
- `GRAFANA_PASSWORD` - Grafana admin password
- `DOMAIN` - Your domain name

### Nextcloud (`nextcloud/.env.local`)
- `MYSQL_ROOT_PASSWORD` - MySQL root password
- `MYSQL_PASSWORD` - MySQL user password
- `REDIS_PASSWORD` - Redis password
- `NEXTCLOUD_ADMIN_PASSWORD` - Nextcloud admin password
- `DOMAIN` - Your domain name

### Traefik (`traefik/.env.local`)
- `DOMAIN` - Your domain name
- `ACME_EMAIL` - Email for Let's Encrypt
- `TRAEFIK_AUTH` - Basic auth hash (htpasswd format)

## 💾 Backup Strategy

Your actual environment files are backed up to `../docker-env-backup/` with timestamps.

## 🛡️ Security Best Practices

- Keep `.env.local` files secure and never commit them
- Use strong, unique passwords for each service
- Regularly rotate secrets and passwords
- Backup environment files securely outside of version control
