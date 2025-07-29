#!/bin/bash
# 1Password Secret Management for Homelab
# Usage: ./manage-secrets.sh [create|list|update] [service-name]

set -e

VAULT="homelab"

create_secrets() {
    echo "Creating 1Password items for homelab services..."
    
    # Create PostgreSQL shared password
    echo "Creating PostgreSQL shared password..."
    op item create --vault="$VAULT" --category=database --title="postgres-shared" \
        username=postgres \
        password="$(openssl rand -base64 32)" \
        --tags=homelab,database
    
    # Create Keycloak admin password
    echo "Creating Keycloak admin password..."
    op item create --vault="$VAULT" --category=password --title="keycloak-admin" \
        username=admin \
        password="$(openssl rand -base64 24)" \
        --tags=homelab,keycloak
    
    # Create Nextcloud admin password
    echo "Creating Nextcloud admin password..."
    op item create --vault="$VAULT" --category=password --title="nextcloud-admin" \
        username=admin \
        password="$(openssl rand -base64 24)" \
        --tags=homelab,nextcloud
    
    # Create Redis password
    echo "Creating Redis password..."
    op item create --vault="$VAULT" --category=password --title="redis-shared" \
        password="$(openssl rand -base64 32)" \
        --tags=homelab,redis
    
    # Create Grafana admin password
    echo "Creating Grafana admin password..."
    op item create --vault="$VAULT" --category=password --title="grafana-admin" \
        username=admin \
        password="$(openssl rand -base64 24)" \
        --tags=homelab,monitoring
    
    echo "✅ Created all 1Password items for homelab services."
}

list_secrets() {
    echo "Listing homelab secrets in 1Password..."
    op item list --vault="$VAULT" --tags=homelab
}

update_secret() {
    if [ -z "$2" ]; then
        echo "Usage: $0 update <item-title>"
        exit 1
    fi
    
    echo "Updating secret: $2"
    op item edit "$2" --vault="$VAULT"
}

case "$1" in
    create)
        create_secrets
        ;;
    list)
        list_secrets
        ;;
    update)
        update_secret "$@"
        ;;
    *)
        echo "Usage: $0 [create|list|update] [service-name]"
        echo ""
        echo "Commands:"
        echo "  create  - Create all homelab secrets in 1Password"
        echo "  list    - List all homelab secrets"
        echo "  update  - Update a specific secret"
        exit 1
        ;;
esac
