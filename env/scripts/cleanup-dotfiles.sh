#!/bin/bash
# Dotfiles cleanup script
# This script helps organize and clean up dotfiles structure

echo "🧹 Cleaning up dotfiles structure..."

# Remove old Authentik files since we're not using it anymore
if [ -f "homelab/.authentik.env" ]; then
    echo "Removing old Authentik environment file..."
    rm -f homelab/.authentik.env
fi

# Create proper .gitignore for environment files
cat > env/.gitignore << 'GITEOF'
# Generated environment files (contain secrets)
*.env
!*.env.template

# Temporary files
*.tmp
*.bak
GITEOF

# Update main .gitignore to include environment files
if ! grep -q "env/.*\.env" .gitignore 2>/dev/null; then
    echo "" >> .gitignore
    echo "# Environment files with secrets" >> .gitignore
    echo "env/*.env" >> .gitignore
    echo "homelab/*.env" >> .gitignore
fi

# Create a README for the environment management
cat > env/README.md << 'README_EOF'
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
README_EOF

echo "✅ Created environment management README"
echo "✅ Updated .gitignore to exclude environment files"
echo "✅ Cleaned up old Authentik files"
