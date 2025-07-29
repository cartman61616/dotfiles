# Environment Management with 1Password

This directory contains templates and scripts for managing environment variables securely using 1Password CLI.

## Setup

1. Install and authenticate with 1Password CLI:
   ```bash
   op signin
   ```

2. Create secrets in 1Password vault:
   ```bash
   ./scripts/manage-secrets.sh create
   ```

3. Generate environment files from templates:
   ```bash
   source scripts/load-env.sh postgres
   source scripts/load-env.sh nextcloud
   source scripts/load-env.sh keycloak
   ```

## Directory Structure

- `templates/` - Environment file templates with 1Password references
- `scripts/` - Management scripts for secrets and environment files
- `*.env` - Generated environment files (git-ignored)

## Templates Available

- `postgres.env.template` - PostgreSQL database configuration
- `nextcloud.env.template` - Nextcloud configuration
- `keycloak.env.template` - Keycloak authentication server
- `redis.env.template` - Redis cache configuration
- `monitoring.env.template` - Grafana and monitoring stack

## Security Notes

- Never commit actual `.env` files to git
- All secrets are stored in 1Password vault "homelab"
- Environment files are automatically generated from templates
- Use `op://vault/item/field` format for 1Password references
