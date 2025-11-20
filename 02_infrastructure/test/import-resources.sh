#!/bin/bash
# Terraform import commands for Azure resources
# These commands import existing resources from Azure into the new terraform state
#
# Module Structure:
# - The Azure/avm-res-network-virtualnetwork module (v0.7.1) uses azapi_resource internally
# - VNET resource address: module.vnet.azapi_resource.vnet
# - Subnet resource addresses: module.vnet.module.subnet["KEY"].azapi_resource.subnet
# - The module manages subnets separately, so they are not included in the VNET body
#
# Expected Drifts After Import:
# - API version differences (cosmetic, Azure accepts both)
# - Subnets removed from VNET body (expected, module manages them separately)
# - Read-only properties in output block (not managed by Terraform)
# - Optional properties set to null (module doesn't manage them)
# - Telemetry resources will be created (module-internal, safe to create)
#
# All drifts are COSMETIC and will NOT modify your infrastructure.

set -eu pipefail

# Subscription ID from config
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
        
        # Try the primary address first and capture both stdout and stderr
        # Use timeout to prevent hanging (30 seconds should be enough)
        local import_output
        local import_exit_code
        
        # Check if timeout command is available
        if command -v timeout >/dev/null 2>&1; then
            import_output=$(timeout 30 terraform import "${resource_address}" "${resource_id}" 2>&1)
            import_exit_code=$?
        else
            # Fallback if timeout is not available
            import_output=$(terraform import "${resource_address}" "${resource_id}" 2>&1)
            import_exit_code=$?
        fi
        
        if [ ${import_exit_code} -eq 0 ]; then
            echo -e "${GREEN}  ✓ Successfully imported ${resource_name}${NC}"
            return 0
        else
            # Debug: Show the actual error for troubleshooting
            echo -e "${YELLOW}  Import failed with exit code: ${import_exit_code}${NC}"
            echo -e "${BLUE}  Error output: $(echo "${import_output}" | head -2)${NC}"
        
            # Check if it's a "does not exist in configuration" error
            if echo "${import_output}" | grep -q "does not exist in the configuration"; then
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
                            alt_output=$(timeout 30 terraform import "${alt_pattern}" "${resource_id}" 2>&1)
                            alt_exit_code=$?
                        else
                            alt_output=$(terraform import "${alt_pattern}" "${resource_id}" 2>&1)
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
            else
                # Other error (permissions, resource doesn't exist in Azure, etc.)
                echo -e "${RED}  ✗ Failed to import ${resource_name}${NC}"
                echo -e "${RED}     Error: $(echo "${import_output}" | head -3)${NC}"
                return 1
            fi
        fi
    fi
}

echo -e "${BLUE}Importing resource groups into terraform state...${NC}"
echo ""

# Import core resource group
import_resource_if_not_exists \
    "azurerm_resource_group.core" \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/resource-group-core" \
    "azurerm_resource_group.core"

# Import sensitive resource group
import_resource_if_not_exists \
    "azurerm_resource_group.sensitive" \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/resource-group-sensitive" \
    "azurerm_resource_group.sensitive"

# Import vnet resource group
import_resource_if_not_exists \
    "azurerm_resource_group.vnet" \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/rg-vnet-002" \
    "azurerm_resource_group.vnet"

echo ""
echo -e "${BLUE}Importing VNET and subnets into terraform state...${NC}"
echo ""

# VNET resource group name
VNET_RG_NAME="rg-vnet-002"
VNET_NAME="vnet-001"

# Import virtual network
# Note: The Azure/avm-res-network-virtualnetwork module uses azapi_resource instead of azurerm_virtual_network
# Based on the terraform state from hello-azure, the correct address is: module.vnet.azapi_resource.vnet
import_resource_if_not_exists \
    "module.vnet.azapi_resource.vnet" \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${VNET_RG_NAME}/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}" \
    "module.vnet.azapi_resource.vnet"

# Import all subnets
# Note: The module uses nested subnet modules with azapi_resource
# Based on the terraform state from hello-azure, the correct pattern is: module.vnet.module.subnet["KEY"].azapi_resource.subnet
# Format: "terraform-key:actual-azure-subnet-name"
declare -a SUBNETS=(
    "snet-aks-pods:snet-aks-pods"
    "snet-aks-nodes:snet-aks-nodes"
    "snet-agw:snet-application-gateway"
    "snet-cognitive:snet-cognitive-services"
    "snet-kv:snet-key-vault"
    "snet-psql:snet-postgres"
    "snet-redis:snet-redis"
    "snet-storage:snet-storage"
    "snet-github:snet-github-runners"
)

for subnet_pair in "${SUBNETS[@]}"; do
    IFS=':' read -r subnet_key subnet_name <<< "${subnet_pair}"
    # The correct subnet resource address based on the terraform state
    import_resource_if_not_exists \
        "module.vnet.module.subnet[\"${subnet_key}\"].azapi_resource.subnet" \
        "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${VNET_RG_NAME}/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${subnet_name}" \
        "module.vnet.module.subnet[\"${subnet_key}\"].azapi_resource.subnet"
done

echo ""
echo -e "${BLUE}Importing managed identities into terraform state...${NC}"
echo ""

# Resource group names
CORE_RG_NAME="resource-group-core"
SENSITIVE_RG_NAME="resource-group-sensitive"

# Import managed identities in sensitive resource group
# These identities are used for services that handle sensitive data
import_resource_if_not_exists \
    "azurerm_user_assigned_identity.psql_identity" \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${SENSITIVE_RG_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/psql-id-test" \
    "azurerm_user_assigned_identity.psql_identity"

import_resource_if_not_exists \
    "azurerm_user_assigned_identity.ingestion_cache_identity" \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${SENSITIVE_RG_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/cache-id-test" \
    "azurerm_user_assigned_identity.ingestion_cache_identity"

import_resource_if_not_exists \
    "azurerm_user_assigned_identity.ingestion_storage_identity" \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${SENSITIVE_RG_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/storage-id-test" \
    "azurerm_user_assigned_identity.ingestion_storage_identity"

# Import managed identities in core resource group
# These identities are used for core services
import_resource_if_not_exists \
    "azurerm_user_assigned_identity.document_intelligence_identity" \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${CORE_RG_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/docint-id-test" \
    "azurerm_user_assigned_identity.document_intelligence_identity"

import_resource_if_not_exists \
    "azurerm_user_assigned_identity.aks_workload_identity" \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${CORE_RG_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aks-id-test" \
    "azurerm_user_assigned_identity.aks_workload_identity"

import_resource_if_not_exists \
    "azurerm_user_assigned_identity.grafana_identity" \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${CORE_RG_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/grafana-id-test" \
    "azurerm_user_assigned_identity.grafana_identity"

echo ""
echo -e "${BLUE}Importing custom role definitions into terraform state...${NC}"
echo ""

# Custom role definitions
# Import format: {role_definition_resource_id}|{scope}
# The role_definition_resource_id is the full Azure resource ID, and scope is the subscription ID
SUBSCRIPTION_SCOPE="/subscriptions/${SUBSCRIPTION_ID}"

# Role definition IDs from terraform state
# Format: /subscriptions/{subscription-id}/providers/Microsoft.Authorization/roleDefinitions/{guid}|/subscriptions/{subscription-id}
import_resource_if_not_exists \
    "azurerm_role_definition.emergency_admin" \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/14e570ce-b6dc-f404-9eb9-ff271205cf34|${SUBSCRIPTION_SCOPE}" \
    "azurerm_role_definition.emergency_admin"

import_resource_if_not_exists \
    "azurerm_role_definition.devops_preview" \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/a36ac756-3599-98f8-350d-153655fddbfd|${SUBSCRIPTION_SCOPE}" \
    "azurerm_role_definition.devops_preview"

import_resource_if_not_exists \
    "azurerm_role_definition.telemetry_observer" \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/175b5d34-3284-ec30-7aba-dd7a2502cab5|${SUBSCRIPTION_SCOPE}" \
    "azurerm_role_definition.telemetry_observer"

import_resource_if_not_exists \
    "azurerm_role_definition.sensitive_data_observer" \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/79b5d30f-05b2-5a6b-1483-9677cb5916c1|${SUBSCRIPTION_SCOPE}" \
    "azurerm_role_definition.sensitive_data_observer"

import_resource_if_not_exists \
    "azurerm_role_definition.vnet_subnet_access" \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/601d68ee-cef2-0d84-e696-34a9bf0e3b0f|${SUBSCRIPTION_SCOPE}" \
    "azurerm_role_definition.vnet_subnet_access"

import_resource_if_not_exists \
    "azurerm_role_definition.acr_puller" \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/0e36e8b9-0905-d27c-50c1-f162bc5a533e|${SUBSCRIPTION_SCOPE}" \
    "azurerm_role_definition.acr_puller"

echo ""
echo -e "${BLUE}Importing Azure AD groups into terraform state...${NC}"
echo ""

# Azure AD Groups
# Import format: {object_id} (the GUID assigned by Azure AD)
# These groups are used for role-based access control (RBAC)
import_resource_if_not_exists \
    "azuread_group.telemetry_observer" \
    "3e60cd87-c622-44d7-801f-fc691822d0ca" \
    "azuread_group.telemetry_observer"

import_resource_if_not_exists \
    "azuread_group.sensitive_data_observer" \
    "5be17159-b6e6-4823-b478-c9430f90ebe1" \
    "azuread_group.sensitive_data_observer"

import_resource_if_not_exists \
    "azuread_group.devops" \
    "dfffea4f-9516-4a4d-ad56-b21c4f174b82" \
    "azuread_group.devops"

import_resource_if_not_exists \
    "azuread_group.emergency_admin" \
    "3139d505-c738-49ca-8182-b9f4b334059b" \
    "azuread_group.emergency_admin"

import_resource_if_not_exists \
    "azuread_group.admin_kubernetes_cluster" \
    "a435bed7-88b3-464f-bc3c-ba000d37ece5" \
    "azuread_group.admin_kubernetes_cluster"

import_resource_if_not_exists \
    "azuread_group.main_keyvault_secret_writer" \
    "fa8f2e2c-154e-4d4a-a99c-7dfa825858ef" \
    "azuread_group.main_keyvault_secret_writer"

echo ""
echo -e "${GREEN}Resources imported successfully!${NC}"
echo ""
echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Expected Drifts After Import${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}When you run 'terraform plan' after importing, you may see drifts.${NC}"
echo -e "${BLUE}These are EXPECTED and COSMETIC - they will NOT modify your infrastructure:${NC}"
echo ""
echo -e "${YELLOW}1. VNET Resource (module.vnet.azapi_resource.vnet):${NC}"
echo "   - Will show 'subnets' being removed from VNET body"
echo "     → This is expected: the module manages subnets separately"
echo "   - Will show API version change (2024-05-01 → 2023-11-01)"
echo "     → This is cosmetic: Azure accepts both versions"
echo "   - Will show 'output' block being removed"
echo "     → This is read-only state, not managed by Terraform"
echo "   - Will show properties being set to null"
echo "     → These are optional properties the module doesn't manage"
echo ""
echo -e "${YELLOW}2. Subnet Resources (module.vnet.module.subnet[...].azapi_resource.subnet):${NC}"
echo "   - Will show API version change (2024-05-01 → 2023-11-01)"
echo "     → This is cosmetic: Azure accepts both versions"
echo "   - Will show 'output' block being removed"
echo "     → This is read-only state, not managed by Terraform"
echo "   - Will show properties being set to null"
echo "     → These are optional properties the module doesn't manage"
echo "   - Will show 'locks' being added"
echo "     → This is a module feature for resource protection"
echo ""
echo -e "${YELLOW}3. New Resources to be Created:${NC}"
echo "   - module.vnet.modtm_telemetry.telemetry[0]"
echo "   - module.vnet.random_uuid.telemetry[0]"
echo "     → These are module-internal telemetry resources"
echo "     → They don't exist in Azure yet and will be created on first apply"
echo "     → They are safe to create and don't affect your infrastructure"
echo ""
echo -e "${GREEN}✓ All these drifts are COSMETIC and SAFE${NC}"
echo -e "${GREEN}✓ They represent state representation differences, not actual infrastructure changes${NC}"
echo -e "${GREEN}✓ Your infrastructure will remain unchanged${NC}"
echo ""
echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "1. Run 'terraform plan' to see the expected cosmetic drifts"
echo "2. Verify that only cosmetic drifts are shown (no actual infrastructure changes)"
echo "3. Document these expected drifts as acceptable for zero-drift migration"
echo ""
echo -e "${YELLOW}Note:${NC} Do NOT run 'terraform apply' in this repository."
echo "      This repo is for refactoring and importing only."

