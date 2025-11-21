#!/usr/bin/env bash
# Build script to generate Terraform configurations for all environments
# This script uses Terraform's templatefile() function to generate environment-specific files
# Compatible with both Linux and macOS

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Generating Terraform configurations for all environments..."
echo ""

# Initialize Terraform in generator directory
echo "Initializing Terraform..."
if ! terraform init > /dev/null 2>&1; then
  echo "Running terraform init (this may take a moment)..."
  terraform init
fi

# Apply generator to create all environment files
echo "Generating environment files from templates..."
terraform apply -auto-approve -var-file=environments.tfvars

# List of shared resource files to copy (not templated)
SHARED_FILES=(
  "01-variables.tf"
  "02-locals.tf"
  "03-data.tf"
  "10-resource-groups.tf"
  "20-networking.tf"
  "21-managed-identities.tf"
  "22-custom-roles.tf"
  "23-azuread-groups.tf"
  "24-application-registration.tf"
  "25-federated-identity-credentials.tf"
  "99-outputs.tf"
)

# Copy shared resource files to each generated environment
for env in dev test; do
  if [ -d "generated/${env}" ]; then
    echo "Copying shared files to generated/${env}/..."
    for file in "${SHARED_FILES[@]}"; do
      if [ -f "test/${file}" ]; then
        cp "test/${file}" "generated/${env}/"
        echo "  [OK] Copied ${file}"
      else
        echo "  [WARN] ${file} not found in test/ directory"
      fi
    done
  else
    echo "  [WARN] generated/${env}/ directory not found"
  fi
done

echo ""
echo "Generation complete!"
echo ""
echo "Generated environments:"
echo "  - generated/dev/"
echo "  - generated/test/"
echo ""
echo "To use a generated environment:"
echo "  cd generated/test"
echo "  terraform init"
echo "  terraform plan"

