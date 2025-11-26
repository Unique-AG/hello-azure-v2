#!/bin/bash
# Terraform import commands for Day-2 resources (identity/governance)
# These commands import existing resources from Azure into the day-2 terraform state
#
# Resources imported:
# - Azure AD groups
# - Application registration (module.application_registration.*)
#
# IMPORTANT: Day-2 resources depend on resources created in day-1.
# Ensure day-1 resources are imported and applied before importing day-2 resources.

set -euo pipefail

# Get the script directory and ensure we're in day-2
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

# Check if we're in the day-2 directory
if [[ ! -f "90-backend.tf" ]]; then
    echo "Error: This script must be run from the day-2 directory"
    exit 1
fi

# Get environment from argument or prompt
ENV="${1:-}"
if [[ -z "${ENV}" ]]; then
    read -p "Which environment? (test/dev) [test]: " ENV
    ENV=${ENV:-test}
fi

if [[ ! "$ENV" =~ ^(test|dev)$ ]]; then
    echo "Error: Invalid environment. Must be 'test' or 'dev'"
    exit 1
fi

# Set variable file paths
VAR_CONFIG="../${ENV}/00-config.auto.tfvars"
VAR_PARAMS="../${ENV}/00-parameters-day-2.auto.tfvars"

# Check if variable files exist
if [[ ! -f "${VAR_CONFIG}" ]]; then
    echo "Error: Variable file not found: ${VAR_CONFIG}"
    exit 1
fi
if [[ ! -f "${VAR_PARAMS}" ]]; then
    echo "Error: Variable file not found: ${VAR_PARAMS}"
    exit 1
fi

# Subscription ID from config (will be read from var file, but set default for reference)
export SUBSCRIPTION_ID="782871a0-bcee-44fb-851f-ccd3e69ada2a"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if resource exists in state
check_resource_exists() {
    local resource_address=$1
    if terraform state show "${resource_address}" >/dev/null 2>&1; then
        return 0  # Resource exists
    else
        return 1  # Resource does not exist
    fi
}

# Function to import resource if it doesn't exist, with automatic pattern discovery
import_resource_if_not_exists() {
    local resource_address=$1
    local resource_id=$2
    local resource_name=$3
    local alternative_patterns="${4:-}"  # Optional: comma-separated alternative patterns
    
    echo -e "${BLUE}Checking ${resource_name}...${NC}"
    
    if check_resource_exists "${resource_address}"; then
        echo -e "${YELLOW}  ⚠️  ${resource_name} already exists in state, skipping import${NC}"
        return 0
    else
        echo -e "${GREEN}  ✓ ${resource_name} not found in state, proceeding with import...${NC}"
        echo -e "${BLUE}  Running: terraform import ${resource_address} ${resource_id}${NC}"
        
        # Try the primary address first and capture both stdout and stderr
        local import_output
        local import_exit_code
        
        # Check if timeout command is available
        if command -v timeout >/dev/null 2>&1; then
            # Use timeout with a longer duration (60 seconds) and show progress
            echo -e "${BLUE}  (This may take up to 60 seconds...)${NC}"
            import_output=$(timeout 60 terraform import \
                -var-file="${VAR_CONFIG}" \
                -var-file="${VAR_PARAMS}" \
                "${resource_address}" "${resource_id}" 2>&1)
            import_exit_code=$?
        else
            # Fallback if timeout is not available - show warning
            echo -e "${YELLOW}  ⚠️  Warning: timeout command not available, import may hang${NC}"
            echo -e "${BLUE}  (This may take up to 60 seconds...)${NC}"
            import_output=$(terraform import \
                -var-file="${VAR_CONFIG}" \
                -var-file="${VAR_PARAMS}" \
                "${resource_address}" "${resource_id}" 2>&1)
            import_exit_code=$?
        fi
        
        if [ ${import_exit_code} -eq 0 ]; then
            echo -e "${GREEN}  ✓ Successfully imported ${resource_name}${NC}"
            return 0
        else
            # Debug: Show the actual error for troubleshooting
            echo -e "${YELLOW}  Import failed with exit code: ${import_exit_code}${NC}"
            echo -e "${RED}  Full error output:${NC}"
            # Show error output - preserve formatting but make it visible
            printf '%s\n' "${import_output}" | while IFS= read -r line; do
                echo "    ${line}"
            done
        
            # Check if it's a state lock error first
            if echo "${import_output}" | grep -qi "state lock\|state blob is already locked"; then
                local lock_id
                lock_id=$(echo "${import_output}" | grep -oP 'ID:\s+\K[^\s]+' | head -1 || echo "")
                echo -e "${RED}  ✗ Failed to import ${resource_name} - State is locked${NC}"
                echo -e "${YELLOW}  The Terraform state is locked, likely from a previous interrupted operation.${NC}"
                if [ -n "${lock_id}" ]; then
                    echo -e "${YELLOW}  To unlock, run: terraform force-unlock -force ${lock_id}${NC}"
                else
                    echo -e "${YELLOW}  To unlock, check the error message above for the lock ID and run:${NC}"
                    echo -e "${YELLOW}  terraform force-unlock -force <LOCK_ID>${NC}"
                fi
                return 1
            # Check if it's a "does not exist in configuration" error
            elif echo "${import_output}" | grep -q "does not exist in the configuration"; then
                echo -e "${YELLOW}  ⚠️  Resource address '${resource_address}' not found in configuration${NC}"
                
                # Try to extract suggested resource address from error message
                local suggested_address
                suggested_address=$(echo "${import_output}" | grep -oP 'resource "\w+" "\w+"' | head -1 || echo "")
                
                if [ -n "${suggested_address}" ]; then
                    echo -e "${BLUE}  💡 Terraform suggests: ${suggested_address}${NC}"
                fi
                
                echo -e "${BLUE}  🔍 Attempting to discover correct resource address...${NC}"
                
                # Try alternative patterns if provided
                if [ -n "${alternative_patterns}" ]; then
                    IFS=',' read -ra PATTERNS <<< "${alternative_patterns}"
                    for alt_pattern in "${PATTERNS[@]}"; do
                        alt_pattern=$(echo "${alt_pattern}" | xargs)  # Trim whitespace
                        echo -e "${BLUE}    Trying: ${alt_pattern}${NC}"
                        
                        local alt_output
                        local alt_exit_code
                        # Use timeout to prevent hanging
                        if command -v timeout >/dev/null 2>&1; then
                            alt_output=$(timeout 60 terraform import \
                                -var-file="${VAR_CONFIG}" \
                                -var-file="${VAR_PARAMS}" \
                                "${alt_pattern}" "${resource_id}" 2>&1)
                            alt_exit_code=$?
                        else
                            alt_output=$(terraform import \
                                -var-file="${VAR_CONFIG}" \
                                -var-file="${VAR_PARAMS}" \
                                "${alt_pattern}" "${resource_id}" 2>&1)
                            alt_exit_code=$?
                        fi
                        
                        if [ ${alt_exit_code} -eq 0 ]; then
                            echo -e "${GREEN}  ✓ Successfully imported using: ${alt_pattern}${NC}"
                            return 0
                        elif echo "${alt_output}" | grep -q "does not exist in the configuration"; then
                            echo -e "${YELLOW}      Pattern '${alt_pattern}' also not found in configuration${NC}"
                            continue
                        else
                            # Other error - show it but continue trying
                            echo -e "${YELLOW}      Pattern '${alt_pattern}' failed: $(echo "${alt_output}" | head -1)${NC}"
                            continue
                        fi
                    done
                fi
                
                # If no alternatives worked, show helpful error message with full details
                echo -e "${RED}  ✗ Failed to import ${resource_name} - resource address not found in configuration${NC}"
                echo -e "${YELLOW}  Full error message:${NC}"
                echo "${import_output}" | sed 's/^/    /'
                echo -e "${YELLOW}  💡 Tip: The error message above should show the correct resource address to use${NC}"
                echo -e "${YELLOW}     Run 'terraform plan' to see what resources the module creates${NC}"
                return 1
            elif echo "${import_output}" | grep -q "state lock\|state blob is already locked"; then
                # State lock error
                local lock_id
                lock_id=$(echo "${import_output}" | grep -oP 'ID:\s+\K[^\s]+' | head -1 || echo "")
                echo -e "${RED}  ✗ Failed to import ${resource_name} - State is locked${NC}"
                echo -e "${YELLOW}  The Terraform state is locked, likely from a previous interrupted operation.${NC}"
                if [ -n "${lock_id}" ]; then
                    echo -e "${YELLOW}  To unlock, run: terraform force-unlock -force ${lock_id}${NC}"
                else
                    echo -e "${YELLOW}  To unlock, check the error message above for the lock ID and run:${NC}"
                    echo -e "${YELLOW}  terraform force-unlock -force <LOCK_ID>${NC}"
                fi
                echo -e "${RED}  Full error output:${NC}"
                echo "${import_output}" | sed 's/^/    /'
                return 1
            else
                # Other error (permissions, resource doesn't exist in Azure, etc.)
                echo -e "${RED}  ✗ Failed to import ${resource_name}${NC}"
                echo -e "${RED}  Full error output:${NC}"
                echo "${import_output}" | sed 's/^/    /'
                return 1
            fi
        fi
    fi
}

echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Day-2 Resource Import${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Check if terraform is initialized
if [ ! -d ".terraform" ]; then
    echo -e "${RED}Error: Terraform not initialized in this directory${NC}"
    echo -e "${YELLOW}Please run: terraform init -backend-config=../test/backend-config-day-2.hcl${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Terraform initialized${NC}"
echo -e "${BLUE}Using environment: ${ENV}${NC}"
echo -e "${BLUE}Variable files: ${VAR_CONFIG}, ${VAR_PARAMS}${NC}"
echo -e "${YELLOW}⚠️  PREREQUISITE: Day-1 resources must be imported and applied first!${NC}"
echo -e "${YELLOW}   Day-2 resources depend on resources created in day-1.${NC}"
echo ""

echo ""
echo -e "${BLUE}Importing Azure AD groups into terraform state...${NC}"
echo ""

# Azure AD Groups
# Import format: /groups/{object_id} (the GUID assigned by Azure AD)
# These groups are used for role-based access control (RBAC)
import_resource_if_not_exists \
    "azuread_group.telemetry_observer" \
    "/groups/3e60cd87-c622-44d7-801f-fc691822d0ca" \
    "azuread_group.telemetry_observer"

import_resource_if_not_exists \
    "azuread_group.sensitive_data_observer" \
    "/groups/5be17159-b6e6-4823-b478-c9430f90ebe1" \
    "azuread_group.sensitive_data_observer"

import_resource_if_not_exists \
    "azuread_group.devops" \
    "/groups/dfffea4f-9516-4a4d-ad56-b21c4f174b82" \
    "azuread_group.devops"

import_resource_if_not_exists \
    "azuread_group.emergency_admin" \
    "/groups/3139d505-c738-49ca-8182-b9f4b334059b" \
    "azuread_group.emergency_admin"

import_resource_if_not_exists \
    "azuread_group.admin_kubernetes_cluster" \
    "/groups/a435bed7-88b3-464f-bc3c-ba000d37ece5" \
    "azuread_group.admin_kubernetes_cluster"

import_resource_if_not_exists \
    "azuread_group.main_keyvault_secret_writer" \
    "/groups/fa8f2e2c-154e-4d4a-a99c-7dfa825858ef" \
    "azuread_group.main_keyvault_secret_writer"

echo ""
echo -e "${BLUE}Importing application registration resources into terraform state...${NC}"
echo ""

# Azure AD Service Principal for Microsoft Graph
# This is a well-known service principal that already exists in Azure AD
# Import format: /servicePrincipals/{object_id}
import_resource_if_not_exists \
    "azuread_service_principal.msgraph" \
    "/servicePrincipals/29c402c3-5bb1-4677-9a9b-80f77cd74944" \
    "azuread_service_principal.msgraph"

# Application Registration Module Resources
# Import format: /applications/{object_id} for applications, /servicePrincipals/{object_id} for service principals
import_resource_if_not_exists \
    "module.application_registration.azuread_application.this" \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554" \
    "module.application_registration.azuread_application.this"

import_resource_if_not_exists \
    "module.application_registration.azuread_service_principal.this" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010" \
    "module.application_registration.azuread_service_principal.this"

# Random UUID for maintainers role
# This must be imported BEFORE azuread_application_app_role.maintainers
# Import format: {uuid_value}
import_resource_if_not_exists \
    "module.application_registration.random_uuid.maintainers" \
    "2ca08d18-0116-978f-bc4e-a110cc8a12d9" \
    "module.application_registration.random_uuid.maintainers"

# Application App Roles
# Import format: /applications/{application_id}/appRoles/{role_id}
import_resource_if_not_exists \
    "module.application_registration.azuread_application_app_role.maintainers" \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/appRoles/2ca08d18-0116-978f-bc4e-a110cc8a12d9" \
    "module.application_registration.azuread_application_app_role.maintainers"

import_resource_if_not_exists \
    "module.application_registration.azuread_application_app_role.managed_roles[\"application_support\"]" \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/appRoles/719570d9-6707-40f4-9193-29ae0745392e" \
    "module.application_registration.azuread_application_app_role.managed_roles[application_support]"

import_resource_if_not_exists \
    "module.application_registration.azuread_application_app_role.managed_roles[\"infrastructure_support\"]" \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/appRoles/0a7f4e66-4942-4a2e-a433-82e54464f116" \
    "module.application_registration.azuread_application_app_role.managed_roles[infrastructure_support]"

import_resource_if_not_exists \
    "module.application_registration.azuread_application_app_role.managed_roles[\"system_support\"]" \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/appRoles/8719acef-9791-41e4-9621-92d05315181c" \
    "module.application_registration.azuread_application_app_role.managed_roles[system_support]"

import_resource_if_not_exists \
    "module.application_registration.azuread_application_app_role.managed_roles[\"user\"]" \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/appRoles/6a902661-cfac-44f4-846c-bc5ceaa012d4" \
    "module.application_registration.azuread_application_app_role.managed_roles[user]"

# Application Password
# Import format: /applications/{application_id}/password/{key_id}
import_resource_if_not_exists \
    "module.application_registration.azuread_application_password.aad_app_password[0]" \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/password/fa3e3b35-6c30-4a97-b5f9-1fe3f30d195d" \
    "module.application_registration.azuread_application_password.aad_app_password[0]"

# App Role Assignments - Maintainers
# Import format: {id} (the full path from state)
import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.maintainers[\"084a1c45-5010-4aab-bab6-7b86a9d10e5c\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/RRxKCBBQq0q6tnuGqdEOXEeWO3NWueZItSB0uhLHfLQ" \
    "module.application_registration.azuread_app_role_assignment.maintainers[084a1c45]"

import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.maintainers[\"3b48f167-cb68-4655-b45b-878e170af84d\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/Z_FIO2jLVUa0W4eOFwr4TTafg3vVXT5Em4jqhTXUjt8" \
    "module.application_registration.azuread_app_role_assignment.maintainers[3b48f167]"

import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.maintainers[\"4b89a1f0-8038-4929-81e6-6d128dac7aa0\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/8KGJSziAKUmB5m0Sjax6oF3WDUAtnwpAhQJJAOJZjLQ" \
    "module.application_registration.azuread_app_role_assignment.maintainers[4b89a1f0]"

import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.maintainers[\"4ee4611f-b24c-444b-8d34-edab333bf868\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/H2HkTkyyS0SNNO2rMzv4aEeaT8GgFQFCo2P1rtQyp3s" \
    "module.application_registration.azuread_app_role_assignment.maintainers[4ee4611f]"

# App Role Assignments - Managed Roles (application_support)
import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.managed_roles[\"application_support:084a1c45-5010-4aab-bab6-7b86a9d10e5c\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/RRxKCBBQq0q6tnuGqdEOXCe-72KXeWRBs_OM6Qk-K3A" \
    "module.application_registration.azuread_app_role_assignment.managed_roles[application_support:084a1c45]"

import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.managed_roles[\"application_support:3b48f167-cb68-4655-b45b-878e170af84d\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/Z_FIO2jLVUa0W4eOFwr4TdnphcTuf0xIqmODzGXHbBg" \
    "module.application_registration.azuread_app_role_assignment.managed_roles[application_support:3b48f167]"

import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.managed_roles[\"application_support:4b89a1f0-8038-4929-81e6-6d128dac7aa0\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/8KGJSziAKUmB5m0Sjax6oLIA2TWno25PoU_6NU8h3wE" \
    "module.application_registration.azuread_app_role_assignment.managed_roles[application_support:4b89a1f0]"

import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.managed_roles[\"application_support:4ee4611f-b24c-444b-8d34-edab333bf868\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/H2HkTkyyS0SNNO2rMzv4aEvieKf9F0RJhH8NS1WYbUs" \
    "module.application_registration.azuread_app_role_assignment.managed_roles[application_support:4ee4611f]"

# App Role Assignments - Managed Roles (user)
import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.managed_roles[\"user:084a1c45-5010-4aab-bab6-7b86a9d10e5c\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/RRxKCBBQq0q6tnuGqdEOXGbH1YDlewtDmQTItNgzE08" \
    "module.application_registration.azuread_app_role_assignment.managed_roles[user:084a1c45]"

import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.managed_roles[\"user:3b48f167-cb68-4655-b45b-878e170af84d\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/Z_FIO2jLVUa0W4eOFwr4TYRyzkPg6slBiQMy4oG5wZE" \
    "module.application_registration.azuread_app_role_assignment.managed_roles[user:3b48f167]"

import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.managed_roles[\"user:4b89a1f0-8038-4929-81e6-6d128dac7aa0\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/8KGJSziAKUmB5m0Sjax6oHhDPWazNnpMsDPxtUeOPB8" \
    "module.application_registration.azuread_app_role_assignment.managed_roles[user:4b89a1f0]"

import_resource_if_not_exists \
    "module.application_registration.azuread_app_role_assignment.managed_roles[\"user:4ee4611f-b24c-444b-8d34-edab333bf868\"]" \
    "/servicePrincipals/5dbf19b3-6943-4696-9334-55b8c5566010/appRoleAssignedTo/H2HkTkyyS0SNNO2rMzv4aHU7MVR2up9KnsngViZrQVQ" \
    "module.application_registration.azuread_app_role_assignment.managed_roles[user:4ee4611f]"

# Key Vault Secrets
# NOTE: These depend on key vault resources which are in day-1 (perimeter resources).
# These will be imported after key vaults are defined and imported in day-1.
# Import format: {key_vault_id}/secrets/{secret_name}
# import_resource_if_not_exists \
#     "module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_id[0]" \
#     "https://hakv2testv2.vault.azure.net/secrets/aad-app-ha-test-gitops-client-id" \
#     "module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_id[0]"
#
# import_resource_if_not_exists \
#     "module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_secret[0]" \
#     "https://hakv2testv2.vault.azure.net/secrets/aad-app-ha-test-gitops-client-secret" \
#     "module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_secret[0]"

echo -e "${YELLOW}  [INFO] Skipping key vault secrets imports.${NC}"
echo -e "${YELLOW}         These will be imported after key vault resources are defined in day-1.${NC}"

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Day-2 Resources Imported Successfully!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Run 'terraform plan' to verify imports"
echo "2. Check for any expected cosmetic drifts"
echo "3. Key vault secrets will need to be imported separately after key vaults are in day-1"
echo ""

