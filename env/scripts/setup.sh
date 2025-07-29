#!/bin/bash
# Initial setup script for homelab environment management

set -e

echo "🚀 Setting up homelab environment management with 1Password..."

# Check if 1Password CLI is installed
if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI not found. Please install it first:"
    echo "   https://developer.1password.com/docs/cli/get-started"
    exit 1
fi

# Check if user is signed in to 1Password
if ! op account list > /dev/null 2>&1; then
    echo "🔐 Please sign in to 1Password CLI:"
    echo "   op signin"
    exit 1
fi

echo "✅ 1Password CLI is ready"

# Check if homelab vault exists
if ! op vault get homelab > /dev/null 2>&1; then
    echo "📦 Creating 'homelab' vault in 1Password..."
    op vault create homelab
fi

echo "✅ Homelab vault is ready"

# Offer to create secrets
read -p "🔑 Would you like to create initial secrets in 1Password? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./manage-secrets.sh create
fi

# Show next steps
echo ""
echo "🎉 Setup complete! Next steps:"
echo ""
echo "1. Generate environment files:"
echo "   source scripts/load-env.sh postgres"
echo "   source scripts/load-env.sh nextcloud"
echo "   source scripts/load-env.sh keycloak"
echo ""
echo "2. Copy environment files to your Docker compose directories"
echo ""
echo "3. Update your Docker compose files to use the environment files"
echo ""
echo "📖 See env/README.md for more details"
