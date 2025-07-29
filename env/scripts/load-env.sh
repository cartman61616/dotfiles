#!/bin/bash
# 1Password Environment Loader
# Usage: source env/scripts/load-env.sh <service-name>

if [ -z "$1" ]; then
    echo "Usage: source env/scripts/load-env.sh <service-name>"
    return 1
fi

SERVICE_NAME="$1"
ENV_TEMPLATE="env/templates/${SERVICE_NAME}.env.template"
ENV_FILE="env/${SERVICE_NAME}.env"

if [ ! -f "$ENV_TEMPLATE" ]; then
    echo "Template not found: $ENV_TEMPLATE"
    return 1
fi

# Check if 1Password CLI is authenticated
if ! op account list > /dev/null 2>&1; then
    echo "Please authenticate with 1Password CLI first:"
    echo "op signin"
    return 1
fi

# Generate environment file from template
echo "Generating $ENV_FILE from 1Password..."
cp "$ENV_TEMPLATE" "$ENV_FILE"

# Replace 1Password references with actual values
while IFS= read -r line; do
    if [[ $line == *"op://"* ]]; then
        # Extract the 1Password reference
        op_ref=$(echo "$line" | grep -o 'op://[^"]*')
        if [ -n "$op_ref" ]; then
            # Get the actual value from 1Password
            actual_value=$(op read "$op_ref" 2>/dev/null)
            if [ $? -eq 0 ]; then
                # Replace in the file
                sed -i "s|${op_ref}|${actual_value}|g" "$ENV_FILE"
            else
                echo "Warning: Could not read $op_ref from 1Password"
            fi
        fi
    fi
done < "$ENV_TEMPLATE"

echo "Environment file generated: $ENV_FILE"
echo "Don't forget to add *.env to .gitignore!"
