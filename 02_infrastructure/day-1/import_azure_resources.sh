#!/bin/bash
# Terraform import commands for Day-1 resources
# Usage: ./import_azure_resources.sh test
#        ./import_azure_resources.sh dev
#
# IMPORTANT: Before running this script, you need to:
# 1. Get the actual Azure resource IDs for each resource
# 2. Replace the placeholder values (marked with TODO) with actual IDs
# 3. Ensure terraform is initialized: terraform init -backend-config=../environments/test/backend-config-day-1.hcl
#
# To get resource IDs:
# - Resource Groups: az group show --name <rg-name> --query id -o tsv
# - Managed Identities: az identity show --name <identity-name> --resource-group <rg-name> --query id -o tsv
# - Role Definitions: az role definition list --name "<role-name>" --query "[0].id" -o tsv
# - VNet: az network vnet show --name <vnet-name> --resource-group <rg-name> --query id -o tsv
# - Subnets: az network vnet subnet show --vnet-name <vnet-name> --resource-group <rg-name> --name <subnet-name> --query id -o tsv

set -euo pipefail

ENV="${1:-test}"
VAR_CONFIG="../environments/${ENV}/00-config-day-1.auto.tfvars"
VAR_PARAMS="../environments/${ENV}/00-parameters-day-1.auto.tfvars"

# Subscription ID - get from config or set here
SUBSCRIPTION_ID="${SUBSCRIPTION_ID:-782871a0-bcee-44fb-851f-ccd3e69ada2a}"

echo "=========================================="
echo "Day-1 Resource Import Script"
echo "Environment: ${ENV}"
echo "=========================================="
echo ""
echo "⚠️  WARNING: This script contains placeholder resource IDs."
echo "   You must replace all TODO placeholders with actual Azure resource IDs before running."
echo ""

# Check if variable files exist
if [[ ! -f "${VAR_CONFIG}" ]]; then
  echo "Error: Variable file not found: ${VAR_CONFIG}"
  exit 1
fi
if [[ ! -f "${VAR_PARAMS}" ]]; then
  echo "Error: Variable file not found: ${VAR_PARAMS}"
  exit 1
fi

# Read resource group names from VAR_PARAMS (needed for managed identities and other resources)
RESOURCE_GROUP_CORE_NAME=$(grep "^resource_group_core_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "resource-group-core")
RESOURCE_GROUP_SENSITIVE_NAME=$(grep "^resource_group_sensitive_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "resource-group-sensitive")

# Resource Groups
echo "=========================================="
echo "Importing Resource Groups"
echo "=========================================="
echo ""

echo "Checking azurerm_resource_group.vnet..."
if ! terraform state show azurerm_resource_group.vnet >/dev/null 2>&1; then
  echo "  Importing azurerm_resource_group.vnet..."
  # TODO: Replace with actual resource group ID
  # Get with: az group show --name rg-vnet-002 --query id -o tsv
  RESOURCE_GROUP_VNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/rg-vnet-002"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_resource_group.vnet \
    "${RESOURCE_GROUP_VNET_ID}"
  echo "  ✓ Imported azurerm_resource_group.vnet"
else
  echo "  ✓ azurerm_resource_group.vnet already in state, skipping"
fi

echo "Checking azurerm_resource_group.core..."
if ! terraform state show azurerm_resource_group.core >/dev/null 2>&1; then
  echo "  Importing azurerm_resource_group.core..."
  # Get with: az group show --name <resource_group_core_name> --query id -o tsv
  RESOURCE_GROUP_CORE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_resource_group.core \
    "${RESOURCE_GROUP_CORE_ID}"
  echo "  ✓ Imported azurerm_resource_group.core"
else
  echo "  ✓ azurerm_resource_group.core already in state, skipping"
fi

echo "Checking azurerm_resource_group.sensitive..."
if ! terraform state show azurerm_resource_group.sensitive >/dev/null 2>&1; then
  echo "  Importing azurerm_resource_group.sensitive..."
  # Get with: az group show --name <resource_group_sensitive_name> --query id -o tsv
  RESOURCE_GROUP_SENSITIVE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_resource_group.sensitive \
    "${RESOURCE_GROUP_SENSITIVE_ID}"
  echo "  ✓ Imported azurerm_resource_group.sensitive"
else
  echo "  ✓ azurerm_resource_group.sensitive already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Subscription Budgets"
echo "=========================================="
echo ""

echo "Checking azurerm_consumption_budget_subscription.subscription_budget..."
if ! terraform state show azurerm_consumption_budget_subscription.subscription_budget >/dev/null 2>&1; then
  echo "  Importing azurerm_consumption_budget_subscription.subscription_budget..."
  # Read subscription_budget_name from VAR_PARAMS or use default
  BUDGET_NAME=$(grep "^subscription_budget_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "subscription_budget")
  BUDGET_ID="/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Consumption/budgets/${BUDGET_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_consumption_budget_subscription.subscription_budget \
    "${BUDGET_ID}"
  echo "  ✓ Imported azurerm_consumption_budget_subscription.subscription_budget"
else
  echo "  ✓ azurerm_consumption_budget_subscription.subscription_budget already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Public IPs"
echo "=========================================="
echo ""

echo "Checking azurerm_public_ip.aks_public_ip..."
if ! terraform state show azurerm_public_ip.aks_public_ip >/dev/null 2>&1; then
  echo "  Importing azurerm_public_ip.aks_public_ip..."
  # Get with: az network public-ip show --name <aks_public_ip_name> --resource-group <resource_group_core_name> --query id -o tsv
  # Read aks_public_ip_name from VAR_PARAMS or use default
  AKS_PUBLIC_IP_NAME=$(grep "^aks_public_ip_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "aks_public_ip")
  PUBLIC_IP_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.Network/publicIPAddresses/${AKS_PUBLIC_IP_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_public_ip.aks_public_ip \
    "${PUBLIC_IP_ID}"
  echo "  ✓ Imported azurerm_public_ip.aks_public_ip"
else
  echo "  ✓ azurerm_public_ip.aks_public_ip already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Virtual Network Module Resources"
echo "=========================================="
echo ""
echo "⚠️  Note: The vnet module uses azapi_resource (not azurerm resources)."
echo "   azapi_resource import may not work reliably due to provider limitations."
echo "   If imports fail, run 'terraform plan' to see if resources need to be created"
echo "   or if they're already managed by Terraform."
echo ""
echo "   Resources to attempt importing:"
echo "   - module.vnet.azapi_resource.vnet"
echo "   - module.vnet.module.subnet[\"snet-aks-pods\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-aks-nodes\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-agw\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-cognitive\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-kv\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-psql\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-redis\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-storage\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-github\"].azapi_resource.subnet"
echo ""

# Virtual Network
echo "Checking module.vnet resources..."
# Get VNet resource group name
VNET_RG_NAME="rg-vnet-002"
VNET_NAME="vnet-001"

# The VNet module uses azapi_resource, not azurerm_virtual_network
# NOTE: azapi_resource import may not work reliably. If import fails, the resource may already exist
# or may need to be managed differently. Check terraform plan after running this script.
echo "Checking module.vnet.azapi_resource.vnet..."
if ! terraform state show module.vnet.azapi_resource.vnet >/dev/null 2>&1; then
  echo "  Attempting to import module.vnet.azapi_resource.vnet..."
  # Get with: az network vnet show --name vnet-001 --resource-group rg-vnet-002 --query id -o tsv
  VNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${VNET_RG_NAME}/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}"
  set +e  # Temporarily disable exit on error for this import attempt
  IMPORT_OUTPUT=$(terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    module.vnet.azapi_resource.vnet \
    "${VNET_ID}" 2>&1)
  IMPORT_EXIT_CODE=$?
  set -e  # Re-enable exit on error
  
  if [ ${IMPORT_EXIT_CODE} -eq 0 ]; then
    echo "  ✓ Imported module.vnet.azapi_resource.vnet"
  else
    echo "  ⚠️  Import failed for module.vnet.azapi_resource.vnet (exit code: ${IMPORT_EXIT_CODE})"
    echo "     This may be expected - azapi resources may not support standard import."
    echo "     Error: ${IMPORT_OUTPUT}"
    echo "     Run 'terraform plan' to check if the resource needs to be created or is already managed."
  fi
else
  echo "  ✓ module.vnet.azapi_resource.vnet already in state, skipping"
fi

# Subnets - import each subnet
# The module uses nested subnet modules with azapi_resource
# Format: "terraform-key:actual-azure-subnet-name"
# Note: Terraform uses keys like "snet-agw" but Azure uses names like "snet-application-gateway"
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
  RESOURCE_ADDRESS="module.vnet.module.subnet[\"${subnet_key}\"].azapi_resource.subnet"
  if ! terraform state show "${RESOURCE_ADDRESS}" >/dev/null 2>&1; then
    echo "  Attempting to import ${RESOURCE_ADDRESS}..."
    # Get with: az network vnet subnet show --vnet-name vnet-001 --resource-group rg-vnet-002 --name ${subnet_name} --query id -o tsv
    # Note: Use actual Azure subnet name, not the terraform key
    SUBNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${VNET_RG_NAME}/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${subnet_name}"
    set +e  # Temporarily disable exit on error for this import attempt
    IMPORT_OUTPUT=$(terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      "${RESOURCE_ADDRESS}" \
      "${SUBNET_ID}" 2>&1)
    IMPORT_EXIT_CODE=$?
    set -e  # Re-enable exit on error
    
    if [ ${IMPORT_EXIT_CODE} -eq 0 ]; then
      echo "  ✓ Imported ${RESOURCE_ADDRESS}"
    else
      echo "  ⚠️  Import failed for ${RESOURCE_ADDRESS} (exit code: ${IMPORT_EXIT_CODE})"
      echo "     This may be expected - azapi resources may not support standard import."
      echo "     Error: ${IMPORT_OUTPUT}"
      echo "     Run 'terraform plan' to check if the resource needs to be created or is already managed."
    fi
  else
    echo "  ✓ ${RESOURCE_ADDRESS} already in state, skipping"
  fi
done

echo ""
echo "=========================================="
echo "Importing Managed Identities"
echo "=========================================="
echo ""

# Read identity names from VAR_PARAMS
PSQL_IDENTITY_NAME=$(grep "^psql_user_assigned_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
INGESTION_CACHE_IDENTITY_NAME=$(grep "^ingestion_cache_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
INGESTION_STORAGE_IDENTITY_NAME=$(grep "^ingestion_storage_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
DOCUMENT_INTELLIGENCE_IDENTITY_NAME=$(grep "^document_intelligence_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
AKS_IDENTITY_NAME=$(grep "^aks_user_assigned_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
GRAFANA_IDENTITY_NAME=$(grep "^grafana_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")

# Managed Identities are in sensitive resource group except document_intelligence and aks_workload which are in core
echo "Checking azurerm_user_assigned_identity.psql_identity..."
if ! terraform state show azurerm_user_assigned_identity.psql_identity >/dev/null 2>&1; then
  if [[ -n "${PSQL_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.psql_identity..."
    # TODO: Replace with actual identity ID
    # Get with: az identity show --name ${PSQL_IDENTITY_NAME} --resource-group ${RESOURCE_GROUP_SENSITIVE_NAME} --query id -o tsv
    PSQL_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${PSQL_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.psql_identity \
      "${PSQL_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.psql_identity"
  else
    echo "  ⚠️  psql_user_assigned_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.psql_identity already in state, skipping"
fi

echo "Checking azurerm_user_assigned_identity.ingestion_cache_identity..."
if ! terraform state show azurerm_user_assigned_identity.ingestion_cache_identity >/dev/null 2>&1; then
  if [[ -n "${INGESTION_CACHE_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.ingestion_cache_identity..."
    # TODO: Replace with actual identity ID
    INGESTION_CACHE_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${INGESTION_CACHE_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.ingestion_cache_identity \
      "${INGESTION_CACHE_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.ingestion_cache_identity"
  else
    echo "  ⚠️  ingestion_cache_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.ingestion_cache_identity already in state, skipping"
fi

echo "Checking azurerm_user_assigned_identity.ingestion_storage_identity..."
if ! terraform state show azurerm_user_assigned_identity.ingestion_storage_identity >/dev/null 2>&1; then
  if [[ -n "${INGESTION_STORAGE_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.ingestion_storage_identity..."
    # TODO: Replace with actual identity ID
    INGESTION_STORAGE_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${INGESTION_STORAGE_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.ingestion_storage_identity \
      "${INGESTION_STORAGE_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.ingestion_storage_identity"
  else
    echo "  ⚠️  ingestion_storage_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.ingestion_storage_identity already in state, skipping"
fi

echo "Checking azurerm_user_assigned_identity.document_intelligence_identity..."
if ! terraform state show azurerm_user_assigned_identity.document_intelligence_identity >/dev/null 2>&1; then
  if [[ -n "${DOCUMENT_INTELLIGENCE_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.document_intelligence_identity..."
    # TODO: Replace with actual identity ID
    DOCUMENT_INTELLIGENCE_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${DOCUMENT_INTELLIGENCE_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.document_intelligence_identity \
      "${DOCUMENT_INTELLIGENCE_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.document_intelligence_identity"
  else
    echo "  ⚠️  document_intelligence_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.document_intelligence_identity already in state, skipping"
fi

echo "Checking azurerm_user_assigned_identity.aks_workload_identity..."
if ! terraform state show azurerm_user_assigned_identity.aks_workload_identity >/dev/null 2>&1; then
  if [[ -n "${AKS_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.aks_workload_identity..."
    # TODO: Replace with actual identity ID
    AKS_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${AKS_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.aks_workload_identity \
      "${AKS_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.aks_workload_identity"
  else
    echo "  ⚠️  aks_user_assigned_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.aks_workload_identity already in state, skipping"
fi

echo "Checking azurerm_user_assigned_identity.grafana_identity..."
if ! terraform state show azurerm_user_assigned_identity.grafana_identity >/dev/null 2>&1; then
  if [[ -n "${GRAFANA_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.grafana_identity..."
    # TODO: Replace with actual identity ID
    GRAFANA_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${GRAFANA_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.grafana_identity \
      "${GRAFANA_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.grafana_identity"
  else
    echo "  ⚠️  grafana_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.grafana_identity already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Custom Role Definitions"
echo "=========================================="
echo ""

# Custom Role Definitions
# Import format: {role_definition_resource_id}|{scope}
# The role_definition_resource_id is the full Azure resource ID, and scope is the subscription ID
SUBSCRIPTION_SCOPE="/subscriptions/${SUBSCRIPTION_ID}"

# Role definition IDs from terraform state
# Format: /subscriptions/{subscription-id}/providers/Microsoft.Authorization/roleDefinitions/{guid}|/subscriptions/{subscription-id}
echo "Checking azurerm_role_definition.emergency_admin..."
if ! terraform state show azurerm_role_definition.emergency_admin >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.emergency_admin..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.emergency_admin \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/14e570ce-b6dc-f404-9eb9-ff271205cf34|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.emergency_admin"
else
  echo "  ✓ azurerm_role_definition.emergency_admin already in state, skipping"
fi

echo "Checking azurerm_role_definition.devops_preview..."
if ! terraform state show azurerm_role_definition.devops_preview >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.devops_preview..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.devops_preview \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/a36ac756-3599-98f8-350d-153655fddbfd|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.devops_preview"
else
  echo "  ✓ azurerm_role_definition.devops_preview already in state, skipping"
fi

echo "Checking azurerm_role_definition.telemetry_observer..."
if ! terraform state show azurerm_role_definition.telemetry_observer >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.telemetry_observer..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.telemetry_observer \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/175b5d34-3284-ec30-7aba-dd7a2502cab5|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.telemetry_observer"
else
  echo "  ✓ azurerm_role_definition.telemetry_observer already in state, skipping"
fi

echo "Checking azurerm_role_definition.sensitive_data_observer..."
if ! terraform state show azurerm_role_definition.sensitive_data_observer >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.sensitive_data_observer..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.sensitive_data_observer \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/79b5d30f-05b2-5a6b-1483-9677cb5916c1|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.sensitive_data_observer"
else
  echo "  ✓ azurerm_role_definition.sensitive_data_observer already in state, skipping"
fi

echo "Checking azurerm_role_definition.vnet_subnet_access..."
if ! terraform state show azurerm_role_definition.vnet_subnet_access >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.vnet_subnet_access..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.vnet_subnet_access \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/601d68ee-cef2-0d84-e696-34a9bf0e3b0f|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.vnet_subnet_access"
else
  echo "  ✓ azurerm_role_definition.vnet_subnet_access already in state, skipping"
fi

echo "Checking azurerm_role_definition.acr_puller..."
if ! terraform state show azurerm_role_definition.acr_puller >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.acr_puller..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.acr_puller \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/0e36e8b9-0905-d27c-50c1-f162bc5a533e|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.acr_puller"
else
  echo "  ✓ azurerm_role_definition.acr_puller already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Key Vaults"
echo "=========================================="
echo ""

# Read Key Vault names from VAR_PARAMS or use defaults
MAIN_KV_NAME_PREFIX=$(grep "^main_kv_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "hakv1")
SENSITIVE_KV_NAME_PREFIX=$(grep "^sensitive_kv_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "hakv2")

# Compute full Key Vault names (matching local.main_kv_name and local.sensitive_kv_name pattern)
# Pattern: ${var.main_kv_name}${var.env}v2
# We need to get env from VAR_CONFIG or VAR_PARAMS
ENV_VALUE=$(grep "^env" "${VAR_CONFIG}" "${VAR_PARAMS}" 2>/dev/null | head -1 | cut -d'"' -f2 || echo "${ENV}")
MAIN_KV_NAME="${MAIN_KV_NAME_PREFIX}${ENV_VALUE}v2"
SENSITIVE_KV_NAME="${SENSITIVE_KV_NAME_PREFIX}${ENV_VALUE}v2"

echo "Checking azurerm_key_vault.main_kv..."
if ! terraform state show azurerm_key_vault.main_kv >/dev/null 2>&1; then
  echo "  Importing azurerm_key_vault.main_kv..."
  echo "  Key Vault name: ${MAIN_KV_NAME}"
  echo "  Resource Group: ${RESOURCE_GROUP_CORE_NAME}"
  # Get with: az keyvault show --name ${MAIN_KV_NAME} --resource-group ${RESOURCE_GROUP_CORE_NAME} --query id -o tsv
  MAIN_KV_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.KeyVault/vaults/${MAIN_KV_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_key_vault.main_kv \
    "${MAIN_KV_ID}"
  echo "  ✓ Imported azurerm_key_vault.main_kv"
else
  echo "  ✓ azurerm_key_vault.main_kv already in state, skipping"
fi

echo "Checking azurerm_key_vault.sensitive_kv..."
if ! terraform state show azurerm_key_vault.sensitive_kv >/dev/null 2>&1; then
  echo "  Importing azurerm_key_vault.sensitive_kv..."
  echo "  Key Vault name: ${SENSITIVE_KV_NAME}"
  echo "  Resource Group: ${RESOURCE_GROUP_SENSITIVE_NAME}"
  # Get with: az keyvault show --name ${SENSITIVE_KV_NAME} --resource-group ${RESOURCE_GROUP_SENSITIVE_NAME} --query id -o tsv
  SENSITIVE_KV_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.KeyVault/vaults/${SENSITIVE_KV_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_key_vault.sensitive_kv \
    "${SENSITIVE_KV_ID}"
  echo "  ✓ Imported azurerm_key_vault.sensitive_kv"
else
  echo "  ✓ azurerm_key_vault.sensitive_kv already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Import script completed!"
echo "=========================================="
echo "Next steps:"
echo "   - Review and update all TODO placeholders with actual resource IDs"
echo "   - Run 'terraform plan' to verify imports and identify any missing resources"
echo "   - Import any additional resources shown in the plan"
echo "   - Some cosmetic drifts are expected (API versions, etc.)"
echo ""

